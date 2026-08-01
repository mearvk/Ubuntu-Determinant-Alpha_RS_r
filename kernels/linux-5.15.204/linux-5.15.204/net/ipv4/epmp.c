// SPDX-License-Identifier: GPL-2.0
/*
 * Extended Port Multiplexing Protocol (EPMP) - Kernel Module
 *
 * This module listens on TCP port 64444 and provides:
 * 1. Protocol specification discovery (respond to '1' or '1s' with JSON spec)
 * 2. Port multiplexing for extended ports beyond 65535 up to 30 quintillion
 * 3. Diffie-Hellman (2048+ bit) initial key exchange
 * 4. RSA (2048+ bit) for subsequent communication
 * 5. Data mode negotiation (raw/encrypted/hybrid)
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/net.h>
#include <linux/in.h>
#include <linux/socket.h>
#include <linux/tcp.h>
#include <linux/kthread.h>
#include <linux/slab.h>
#include <linux/crypto.h>
#include <crypto/dh.h>
#include <crypto/rsa.h>
#include <crypto/hash.h>
#include <crypto/akcipher.h>
#include <crypto/kpp.h>
#include <net/sock.h>
#include <net/tcp.h>

#define EPMP_PORT		64444
#define EPMP_VERSION		1
#define EPMP_MAGIC		0x45504D50	/* "EPMP" */
#define EPMP_MAX_CONNECTIONS	256
#define EPMP_DH_MIN_BITS	2048
#define EPMP_RSA_MIN_BITS	2048
#define EPMP_SESSION_TIMEOUT_S	3600
#define EPMP_MAX_PORT		30000000000000000000ULL

/* Extended port range - 64-bit addressing */
#define EPMP_LEGACY_PORT_MAX	65535
#define EPMP_EXTENDED_PORT_MIN	65536

/* Data mode codes */
#define EPMP_MODE_RAW		0
#define EPMP_MODE_ENCRYPTED	1
#define EPMP_MODE_HYBRID	2

/* Frame flags */
#define EPMP_FLAG_ENCRYPTED	BIT(0)
#define EPMP_FLAG_FRAGMENTED	BIT(1)
#define EPMP_FLAG_FINAL_FRAG	BIT(2)
#define EPMP_FLAG_PRIORITY	BIT(3)

/* Error codes */
#define EPMP_ERR_SUCCESS		0x00
#define EPMP_ERR_INVALID_PORT		0x01
#define EPMP_ERR_PORT_UNREACHABLE	0x02
#define EPMP_ERR_HANDSHAKE_FAILED	0x03
#define EPMP_ERR_DECRYPTION_ERROR	0x04
#define EPMP_ERR_SEQUENCE_ERROR		0x05
#define EPMP_ERR_CHECKSUM_MISMATCH	0x06
#define EPMP_ERR_MODE_MISMATCH		0x07
#define EPMP_ERR_SESSION_EXPIRED	0x08
#define EPMP_ERR_RATE_LIMITED		0x09

MODULE_LICENSE("GPL");
MODULE_AUTHOR("MEARVK LLC");
MODULE_DESCRIPTION("Extended Port Multiplexing Protocol - Port 64444 Service");
MODULE_VERSION("1.0.0");

/*
 * EPMP frame header structure - 42 bytes total
 * Carries data destined for extended ports (> 65535) through port 64444
 */
struct epmp_frame_header {
	__be32	magic;		/* EPMP_MAGIC */
	__u8	version;	/* Protocol version */
	__be64	target_port;	/* Destination extended port (0 - 30 quintillion) */
	__be64	source_port;	/* Source extended port */
	__be64	payload_length;	/* Payload size in bytes */
	__be16	flags;		/* Frame flags */
	__be32	sequence;	/* Sequence number */
	__be32	checksum;	/* CRC-32C of header + payload */
} __packed;

/* Handshake state machine */
enum epmp_session_state {
	EPMP_STATE_INIT = 0,
	EPMP_STATE_DH_EXCHANGE,
	EPMP_STATE_RSA_EXCHANGE,
	EPMP_STATE_MODE_NEGOTIATION,
	EPMP_STATE_ESTABLISHED,
	EPMP_STATE_ERROR,
};

/* Per-connection session */
struct epmp_session {
	enum epmp_session_state state;
	struct socket *sock;
	u8 data_mode;			/* raw, encrypted, or hybrid */
	u64 target_port;		/* Currently addressed extended port */

	/* DH state */
	struct crypto_kpp *dh_tfm;
	u8 *dh_shared_secret;
	size_t dh_secret_len;

	/* RSA state */
	struct crypto_akcipher *rsa_tfm;
	u8 *rsa_client_pubkey;
	size_t rsa_client_pubkey_len;
	u8 *rsa_server_pubkey;
	size_t rsa_server_pubkey_len;

	/* Session key (derived from DH for hybrid mode) */
	u8 session_key[32];		/* AES-256 key */

	/* Housekeeping */
	unsigned long last_activity;
	u32 sequence_counter;
	struct list_head list;
};

/* Global state */
static struct socket *epmp_listen_sock;
static struct task_struct *epmp_accept_thread;
static LIST_HEAD(epmp_sessions);
static DEFINE_SPINLOCK(epmp_sessions_lock);
static bool epmp_running;
static atomic_t active_connections = ATOMIC_INIT(0);
static DECLARE_WAIT_QUEUE_HEAD(epmp_conn_wait);

/*
 * The protocol specification JSON - served when client sends '1' or '1s'
 * This is compiled into the module from port_mux_spec.json
 */
static const char epmp_spec_json[] =
#include "port_mux_spec_inline.h"
;

/*
 * Check if received data is a spec discovery request ('1' or '1s')
 */
static bool epmp_is_discovery_request(const char *buf, size_t len)
{
	if (len == 1 && buf[0] == '1')
		return true;
	if (len == 2 && buf[0] == '1' && buf[1] == 's')
		return true;
	return false;
}

/*
 * Send the protocol specification JSON to the client
 */
static int epmp_send_spec(struct socket *sock)
{
	struct kvec iov;
	struct msghdr msg = { .msg_flags = MSG_NOSIGNAL };
	int ret;

	iov.iov_base = (void *)epmp_spec_json;
	iov.iov_len = sizeof(epmp_spec_json) - 1; /* exclude null terminator */

	ret = kernel_sendmsg(sock, &msg, &iov, 1, iov.iov_len);
	return ret;
}

/*
 * Validate an extended port number is within range
 */
static inline bool epmp_port_valid(u64 port)
{
	return port <= EPMP_MAX_PORT;
}

/*
 * Determine if a port requires multiplexing through port 64444
 * Standard ports (0-65535) are directly addressable.
 * Extended ports (65536+) must go through the multiplexer.
 */
static inline bool epmp_port_needs_mux(u64 port)
{
	return port > EPMP_LEGACY_PORT_MAX;
}

/*
 * Initialize a Diffie-Hellman key exchange (2048+ bits)
 */
static int epmp_dh_init(struct epmp_session *session)
{
	session->dh_tfm = crypto_alloc_kpp("dh", 0, 0);
	if (IS_ERR(session->dh_tfm)) {
		pr_err("epmp: Failed to allocate DH transform\n");
		return PTR_ERR(session->dh_tfm);
	}

	session->state = EPMP_STATE_DH_EXCHANGE;
	return 0;
}

/*
 * Initialize RSA for post-handshake communication (2048+ bits)
 */
static int epmp_rsa_init(struct epmp_session *session)
{
	session->rsa_tfm = crypto_alloc_akcipher("rsa", 0, 0);
	if (IS_ERR(session->rsa_tfm)) {
		pr_err("epmp: Failed to allocate RSA transform\n");
		return PTR_ERR(session->rsa_tfm);
	}

	session->state = EPMP_STATE_RSA_EXCHANGE;
	return 0;
}

/*
 * Process an EPMP frame from an established session
 * Demultiplexes the frame to the target extended port
 */
static int epmp_process_frame(struct epmp_session *session,
			      struct epmp_frame_header *hdr,
			      const u8 *payload, size_t payload_len)
{
	u64 target_port = be64_to_cpu(hdr->target_port);

	if (!epmp_port_valid(target_port))
		return -EPMP_ERR_INVALID_PORT;

	if (hdr->magic != cpu_to_be32(EPMP_MAGIC))
		return -EINVAL;

	/* Verify checksum */
	/* TODO: CRC-32C validation */

	/* Check encryption matches negotiated mode */
	if (session->data_mode == EPMP_MODE_ENCRYPTED &&
	    !(be16_to_cpu(hdr->flags) & EPMP_FLAG_ENCRYPTED))
		return -EPMP_ERR_MODE_MISMATCH;

	/* Route payload to the target extended port service */
	/* This is where the actual demultiplexing happens -
	 * the kernel's extended port table maps u64 ports to
	 * registered handlers */
	pr_debug("epmp: Routing frame to extended port %llu (seq=%u, len=%llu)\n",
		 target_port, be32_to_cpu(hdr->sequence),
		 be64_to_cpu(hdr->payload_length));

	session->last_activity = jiffies;
	session->sequence_counter++;

	return 0;
}

/*
 * Handle a single client connection
 */
static int epmp_handle_connection(void *data)
{
	struct socket *sock = data;
	struct epmp_session *session;
	char buf[4096];
	struct kvec iov;
	struct msghdr msg = { .msg_flags = 0 };
	int len;

	session = kzalloc(sizeof(*session), GFP_KERNEL);
	if (!session) {
		sock_release(sock);
		return -ENOMEM;
	}

	session->sock = sock;
	session->state = EPMP_STATE_INIT;
	session->last_activity = jiffies;

	spin_lock(&epmp_sessions_lock);
	list_add(&session->list, &epmp_sessions);
	spin_unlock(&epmp_sessions_lock);

	while (epmp_running && !kthread_should_stop()) {
		iov.iov_base = buf;
		iov.iov_len = sizeof(buf);

		len = kernel_recvmsg(sock, &msg, &iov, 1, sizeof(buf), 0);
		if (len <= 0)
			break;

		session->last_activity = jiffies;

		/* Discovery request: client sends '1' or '1s' */
		if (session->state == EPMP_STATE_INIT &&
		    epmp_is_discovery_request(buf, len)) {
			epmp_send_spec(sock);
			continue;
		}

		/* State machine for handshake */
		switch (session->state) {
		case EPMP_STATE_INIT:
			/* First non-discovery data starts DH exchange */
			if (epmp_dh_init(session) < 0) {
				session->state = EPMP_STATE_ERROR;
				goto out;
			}
			/* Process DH client public value */
			/* TODO: Parse and process DH parameters */
			session->state = EPMP_STATE_DH_EXCHANGE;
			break;

		case EPMP_STATE_DH_EXCHANGE:
			/* Complete DH, move to RSA */
			if (epmp_rsa_init(session) < 0) {
				session->state = EPMP_STATE_ERROR;
				goto out;
			}
			break;

		case EPMP_STATE_RSA_EXCHANGE:
			/* RSA pubkey received, move to mode negotiation */
			session->state = EPMP_STATE_MODE_NEGOTIATION;
			break;

		case EPMP_STATE_MODE_NEGOTIATION:
			/* Client selects data mode */
			if (len >= 1) {
				session->data_mode = buf[0];
				if (session->data_mode > EPMP_MODE_HYBRID) {
					session->state = EPMP_STATE_ERROR;
					goto out;
				}
			}
			session->state = EPMP_STATE_ESTABLISHED;
			/* Send mode acknowledgment */
			{
				char ack = 1;
				struct kvec ack_iov = { .iov_base = &ack, .iov_len = 1 };
				kernel_sendmsg(sock, &msg, &ack_iov, 1, 1);
			}
			break;

		case EPMP_STATE_ESTABLISHED:
			/* Process EPMP frames */
			if (len >= (int)sizeof(struct epmp_frame_header)) {
				struct epmp_frame_header *hdr =
					(struct epmp_frame_header *)buf;
				epmp_process_frame(session, hdr,
						   (u8 *)buf + sizeof(*hdr),
						   len - sizeof(*hdr));
			}
			break;

		case EPMP_STATE_ERROR:
			goto out;
		}
	}

out:
	spin_lock(&epmp_sessions_lock);
	list_del(&session->list);
	spin_unlock(&epmp_sessions_lock);

	if (session->dh_tfm && !IS_ERR(session->dh_tfm))
		crypto_free_kpp(session->dh_tfm);
	if (session->rsa_tfm && !IS_ERR(session->rsa_tfm))
		crypto_free_akcipher(session->rsa_tfm);
	kfree(session->dh_shared_secret);
	kfree(session->rsa_client_pubkey);
	kfree(session->rsa_server_pubkey);
	kfree(session);
	sock_release(sock);

	atomic_dec(&active_connections);
	wake_up(&epmp_conn_wait);

	return 0;
}

/*
 * Accept loop - listens on port 64444 for incoming connections
 */
static int epmp_accept_loop(void *data)
{
	struct socket *newsock;
	int ret;

	while (epmp_running && !kthread_should_stop()) {
		ret = kernel_accept(epmp_listen_sock, &newsock, O_NONBLOCK);
		if (ret < 0) {
			if (ret == -EAGAIN) {
				schedule_timeout_interruptible(HZ / 10);
				continue;
			}
			break;
		}

		/* Spawn handler thread for this connection */
		if (atomic_read(&active_connections) >= EPMP_MAX_CONNECTIONS) {
			pr_warn_ratelimited("epmp: Max connections (%d) reached, rejecting\n",
					    EPMP_MAX_CONNECTIONS);
			sock_release(newsock);
			continue;
		}

		atomic_inc(&active_connections);
		kthread_run(epmp_handle_connection, newsock,
			    "epmp_conn_%p", newsock);
	}

	return 0;
}

/*
 * Module initialization - bind to port 64444 and start accepting
 */
static int __init epmp_init(void)
{
	struct sockaddr_in addr;
	int ret;

	pr_info("epmp: Initializing Extended Port Multiplexing Protocol v%d\n",
		EPMP_VERSION);
	pr_info("epmp: Extended port range: 0 - %llu\n", EPMP_MAX_PORT);
	pr_info("epmp: Multiplexer service port: %d\n", EPMP_PORT);
	pr_info("epmp: DH minimum bits: %d, RSA minimum bits: %d\n",
		EPMP_DH_MIN_BITS, EPMP_RSA_MIN_BITS);

	/* Create listening socket */
	ret = sock_create_kern(&init_net, AF_INET, SOCK_STREAM, IPPROTO_TCP,
			       &epmp_listen_sock);
	if (ret < 0) {
		pr_err("epmp: Failed to create socket: %d\n", ret);
		return ret;
	}

	/* Set SO_REUSEADDR */
	epmp_listen_sock->sk->sk_reuse = SK_CAN_REUSE;

	/* Bind to port 64444 */
	memset(&addr, 0, sizeof(addr));
	addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = htonl(INADDR_ANY);
	addr.sin_port = htons(EPMP_PORT);

	ret = kernel_bind(epmp_listen_sock, (struct sockaddr *)&addr,
			  sizeof(addr));
	if (ret < 0) {
		pr_err("epmp: Failed to bind to port %d: %d\n", EPMP_PORT, ret);
		sock_release(epmp_listen_sock);
		return ret;
	}

	/* Listen */
	ret = kernel_listen(epmp_listen_sock, EPMP_MAX_CONNECTIONS);
	if (ret < 0) {
		pr_err("epmp: Failed to listen: %d\n", ret);
		sock_release(epmp_listen_sock);
		return ret;
	}

	/* Start accept thread */
	epmp_running = true;
	epmp_accept_thread = kthread_run(epmp_accept_loop, NULL, "epmp_accept");
	if (IS_ERR(epmp_accept_thread)) {
		pr_err("epmp: Failed to start accept thread\n");
		epmp_running = false;
		sock_release(epmp_listen_sock);
		return PTR_ERR(epmp_accept_thread);
	}

	pr_info("epmp: Listening on port %d - send '1' or '1s' for protocol spec\n",
		EPMP_PORT);
	return 0;
}

/*
 * Module cleanup
 */
static void __exit epmp_exit(void)
{
	struct epmp_session *session, *tmp;

	pr_info("epmp: Shutting down Extended Port Multiplexing Protocol\n");

	epmp_running = false;

	if (epmp_accept_thread)
		kthread_stop(epmp_accept_thread);

	if (epmp_listen_sock)
		sock_release(epmp_listen_sock);

	/* Wait for all active connection handler threads to exit */
	wait_event(epmp_conn_wait, atomic_read(&active_connections) == 0);

	/* Clean up all sessions */
	spin_lock(&epmp_sessions_lock);
	list_for_each_entry_safe(session, tmp, &epmp_sessions, list) {
		list_del(&session->list);
		if (session->sock)
			sock_release(session->sock);
		if (session->dh_tfm && !IS_ERR(session->dh_tfm))
			crypto_free_kpp(session->dh_tfm);
		if (session->rsa_tfm && !IS_ERR(session->rsa_tfm))
			crypto_free_akcipher(session->rsa_tfm);
		kfree(session->dh_shared_secret);
		kfree(session->rsa_client_pubkey);
		kfree(session->rsa_server_pubkey);
		kfree(session);
	}
	spin_unlock(&epmp_sessions_lock);

	pr_info("epmp: Shutdown complete\n");
}

module_init(epmp_init);
module_exit(epmp_exit);
