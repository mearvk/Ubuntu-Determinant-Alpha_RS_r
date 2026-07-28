// SPDX-License-Identifier: GPL-2.0
/*
 * Heuristic Port Monitor (HPM) - Three-Pipe Architecture
 *
 * A three-stage heuristic pipeline for monitoring all ports (0 through extended
 * range) with data safety review at each stage. Covers:
 *
 *   Pipe 1: Protocol Framing Analysis (HTTP, FTP, raw buffer, direct frame)
 *   Pipe 2: Behavioral Heuristics (stealth packets, timing, identity, anomaly)
 *   Pipe 3: Response Graphing & Reversal Detection (IDS inversion, port abuse)
 *
 * Each pipe has a safety checkpoint that logs, scores, and optionally blocks.
 *
 * Informed by:
 *   - eBPF/XDP kernel-level packet inspection patterns
 *   - Deep packet inspection heuristic classification
 *   - Netfilter hook-based traffic interception
 *   - Temporal/behavioral anomaly detection research
 *
 * References:
 *   [1] iKern: Advanced Intrusion Detection at Kernel Level Using eBPF (MDPI 2024)
 *   [2] eBPF-Powered Cross-Layer Anomaly Detection Framework (Jangid et al.)
 *   [3] Netfilter/eBPF TCP flag-based probing attack filtering (2020)
 *   [4] Automated Network Security with Rust - Port Scanner Detection (Synacktiv 2024)
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/netfilter.h>
#include <linux/netfilter_ipv4.h>
#include <linux/ip.h>
#include <linux/tcp.h>
#include <linux/udp.h>
#include <linux/skbuff.h>
#include <linux/timer.h>
#include <linux/jiffies.h>
#include <linux/hashtable.h>
#include <linux/spinlock.h>
#include <linux/kthread.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/slab.h>
#include <linux/time.h>
#include <linux/ktime.h>
#include <linux/ratelimit.h>
#include <linux/workqueue.h>
#include <net/ip.h>
#include <net/tcp.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("MEARVK LLC");
MODULE_DESCRIPTION("Heuristic Port Monitor - Three-Pipe Security Pipeline");
MODULE_VERSION("1.0.0");

/* ============================================================
 * Configuration & Constants
 * ============================================================ */

#define HPM_EXTENDED_PORT_MAX	30000000000000000000ULL
#define HPM_HASH_BITS		16
#define HPM_MAX_TRACKED_IPS	65536
#define HPM_LOG_RING_SIZE	4096
#define HPM_WINDOW_SECONDS	60	/* Sliding window for rate analysis */
#define HPM_SCAN_THRESHOLD	15	/* Ports in window = scan detection */
#define HPM_DOS_THRESHOLD	1000	/* Packets/sec from single IP */
#define HPM_STEALTH_FLAGS	(TH_FIN | TH_URG | TH_PUSH) /* XMAS scan */
#define HPM_TIME_ZONE_SLOTS	24	/* Hour-of-day behavioral slots */

/* TCP flag shortcuts */
#ifndef TH_FIN
#define TH_FIN	0x01
#define TH_SYN	0x02
#define TH_RST	0x04
#define TH_PUSH	0x08
#define TH_ACK	0x10
#define TH_URG	0x20
#endif

/* Pipe identifiers */
#define HPM_PIPE_1_FRAMING	1
#define HPM_PIPE_2_BEHAVIOR	2
#define HPM_PIPE_3_RESPONSE	3

/* Threat severity levels */
#define HPM_SEVERITY_NONE	0
#define HPM_SEVERITY_LOW	1
#define HPM_SEVERITY_MEDIUM	2
#define HPM_SEVERITY_HIGH	3
#define HPM_SEVERITY_CRITICAL	4

/* Admin toggle states */
#define HPM_STATE_ACTIVE	1
#define HPM_STATE_DORMANT	0

/* ============================================================
 * Data Structures
 * ============================================================ */

/*
 * Per-source-IP tracking entry
 * Maintains behavioral profile for heuristic analysis
 */
struct hpm_source_profile {
	__be32			ip_addr;
	u64			extended_port;	/* For extended port tracking */
	struct hlist_node	node;

	/* Pipe 1: Protocol framing counters */
	u32	http_calls;		/* HTTP request count in window */
	u32	ftp_calls;		/* FTP command count in window */
	u32	raw_buffers;		/* Raw/binary frames seen */
	u32	malformed_frames;	/* Frames failing protocol parse */

	/* Pipe 2: Behavioral heuristics */
	u32	ports_touched;		/* Distinct ports in window */
	u32	packets_in_window;	/* Total packets in current window */
	u32	stealth_packets;	/* NULL/XMAS/FIN scan attempts */
	u32	syn_flood_count;	/* SYN without completing handshake */
	u8	hour_activity[HPM_TIME_ZONE_SLOTS]; /* Per-hour activity map */
	u8	expected_hour_min;	/* Expected operating window start */
	u8	expected_hour_max;	/* Expected operating window end */

	/* Pipe 3: Response graphing */
	u32	response_latencies[16];	/* Last 16 RTT samples (microseconds) */
	u8	latency_idx;
	u32	ids_trigger_count;	/* Times this IP triggered IDS rules */
	u32	reversal_score;		/* Graph-based reversal anomaly score */
	bool	wrong_port_detected;	/* Port used outside expected set */
	bool	wrong_hour_detected;	/* Activity outside expected hours */
	bool	wrong_identity;		/* Source does not match expected admin */

	/* Safety review scores (set at each pipe checkpoint) */
	u8	pipe1_safety_score;	/* 0-100: protocol framing safety */
	u8	pipe2_safety_score;	/* 0-100: behavioral safety */
	u8	pipe3_safety_score;	/* 0-100: response pattern safety */

	/* Metadata */
	unsigned long	first_seen;
	unsigned long	last_seen;
	unsigned long	window_start;
	u8		severity;	/* Current threat assessment */
	spinlock_t	lock;
};

/*
 * Log ring entry for the logging daemon
 */
struct hpm_log_entry {
	ktime_t		timestamp;
	__be32		src_ip;
	__be32		dst_ip;
	u16		src_port;
	u64		dst_port;	/* Extended port capable */
	u8		pipe_id;	/* Which pipe generated this log */
	u8		severity;
	u8		safety_score;
	char		message[128];
};

/*
 * Response graph node for Pipe 3 analysis
 */
struct hpm_response_graph {
	u32	request_hash;		/* Hash of request pattern */
	u32	response_time_us;	/* Response latency */
	u16	response_port;		/* Port that responded */
	u8	response_flags;		/* TCP flags in response */
	u8	anomaly_score;		/* 0-255 anomaly score */
};

/* ============================================================
 * Global State
 * ============================================================ */

static DEFINE_HASHTABLE(hpm_source_table, HPM_HASH_BITS);
static DEFINE_SPINLOCK(hpm_table_lock);

/* Log ring buffer */
static struct hpm_log_entry *hpm_log_ring;
static atomic_t hpm_log_head = ATOMIC_INIT(0);
static atomic_t hpm_log_tail = ATOMIC_INIT(0);
static DEFINE_SPINLOCK(hpm_log_lock);

/* Admin control */
static int hpm_active = HPM_STATE_ACTIVE; /* Toggle: 1=active, 0=dormant */
module_param(hpm_active, int, 0644);
MODULE_PARM_DESC(hpm_active, "Toggle heuristic monitor: 1=active, 0=dormant");

/* Logging daemon thread */
static struct task_struct *hpm_log_daemon;
static struct workqueue_struct *hpm_wq;

/* Netfilter hooks */
static struct nf_hook_ops hpm_nf_hook_in;
static struct nf_hook_ops hpm_nf_hook_out;

/* Proc filesystem entries for admin interface */
static struct proc_dir_entry *hpm_proc_dir;
static struct proc_dir_entry *hpm_proc_status;
static struct proc_dir_entry *hpm_proc_toggle;
static struct proc_dir_entry *hpm_proc_log;

/* ============================================================
 * PIPE 1: Protocol Framing Analysis
 *
 * Inspects the framing of incoming data to identify:
 * - HTTP calls (GET/POST/PUT/DELETE headers)
 * - FTP commands (USER/PASS/RETR/STOR/LIST)
 * - Direct buffer/binary frames (no recognizable protocol header)
 * - Malformed frames (partial headers, truncated, overlapping)
 *
 * Safety Checkpoint 1: Scores the protocol conformance.
 * Non-conforming frames increase threat score.
 * ============================================================ */

/* Known HTTP method signatures */
static const char *http_methods[] = {
	"GET ", "POST ", "PUT ", "DELETE ", "HEAD ",
	"OPTIONS ", "PATCH ", "CONNECT ", "TRACE ", NULL
};

/* Known FTP command signatures */
static const char *ftp_commands[] = {
	"USER ", "PASS ", "RETR ", "STOR ", "LIST ",
	"CWD ", "PWD", "QUIT", "PORT ", "PASV", NULL
};

static int hpm_pipe1_classify_protocol(const unsigned char *payload, int len)
{
	int i;

	if (len < 3)
		return -1; /* Too short to classify */

	/* Check HTTP methods */
	for (i = 0; http_methods[i]; i++) {
		int mlen = strlen(http_methods[i]);
		if (len >= mlen && !memcmp(payload, http_methods[i], mlen))
			return 1; /* HTTP */
	}

	/* Check FTP commands */
	for (i = 0; ftp_commands[i]; i++) {
		int clen = strlen(ftp_commands[i]);
		if (len >= clen && !memcmp(payload, ftp_commands[i], clen))
			return 2; /* FTP */
	}

	/* Check for TLS/SSL ClientHello (direct encrypted frame) */
	if (len >= 5 && payload[0] == 0x16 && payload[1] == 0x03)
		return 3; /* TLS frame */

	/* Otherwise: raw/binary buffer - no recognized framing */
	return 0; /* Raw buffer */
}

static u8 hpm_pipe1_safety_check(struct hpm_source_profile *profile,
				 int protocol_class, int payload_len)
{
	u8 score = 100; /* Start at full safety */

	/* Malformed or unrecognized protocol */
	if (protocol_class == -1) {
		score -= 30;
		profile->malformed_frames++;
	} else if (protocol_class == 0) {
		/* Raw buffer: not inherently dangerous but suspicious at scale */
		score -= 5;
		profile->raw_buffers++;
		if (profile->raw_buffers > 100)
			score -= 20; /* Excessive raw buffers */
	}

	/* Too many protocol switches = confusion/evasion attempt */
	if (profile->http_calls > 0 && profile->ftp_calls > 0 &&
	    profile->raw_buffers > 0)
		score -= 15;

	/* Very large payloads on non-standard frames */
	if (protocol_class == 0 && payload_len > 8192)
		score -= 10;

	if (score < 0)
		score = 0;

	profile->pipe1_safety_score = score;
	return score;
}

/* ============================================================
 * PIPE 2: Behavioral Heuristics
 *
 * Analyzes behavioral patterns to detect:
 * - Stealth packets (NULL scan, XMAS scan, FIN scan)
 * - DoS/DDoS patterns (rate flooding)
 * - Port scanning (sequential/randomized port probing)
 * - IDS evasion techniques (fragmentation, flag manipulation)
 * - Wrong port at wrong hour (temporal anomaly)
 * - Wrong identity adjusting port steadiness (authorization)
 *
 * Safety Checkpoint 2: Behavioral safety score.
 * ============================================================ */

static bool hpm_is_stealth_packet(struct tcphdr *tcph)
{
	u8 flags = ((u8 *)tcph)[13]; /* TCP flags byte */

	/* NULL scan: no flags set */
	if (flags == 0)
		return true;

	/* XMAS scan: FIN+URG+PUSH */
	if ((flags & (TH_FIN | TH_URG | TH_PUSH)) == (TH_FIN | TH_URG | TH_PUSH))
		return true;

	/* FIN scan: only FIN set (no ACK) */
	if (flags == TH_FIN)
		return true;

	/* Maimon scan: FIN+ACK to closed port */
	if (flags == (TH_FIN | TH_ACK))
		return true;

	/* Invalid flag combination: SYN+FIN */
	if ((flags & (TH_SYN | TH_FIN)) == (TH_SYN | TH_FIN))
		return true;

	/* Invalid: SYN+RST */
	if ((flags & (TH_SYN | TH_RST)) == (TH_SYN | TH_RST))
		return true;

	return false;
}

static bool hpm_is_dos_pattern(struct hpm_source_profile *profile)
{
	unsigned long window_elapsed;

	window_elapsed = (jiffies - profile->window_start) / HZ;
	if (window_elapsed == 0)
		window_elapsed = 1;

	/* Packets per second exceeds threshold */
	return (profile->packets_in_window / window_elapsed) > HPM_DOS_THRESHOLD;
}

static bool hpm_is_port_scan(struct hpm_source_profile *profile)
{
	return profile->ports_touched > HPM_SCAN_THRESHOLD;
}

static bool hpm_is_wrong_hour(struct hpm_source_profile *profile)
{
	struct tm tm;
	time64_t now = ktime_get_real_seconds();

	time64_to_tm(now, 0, &tm);

	/* If expected hours are configured, check compliance */
	if (profile->expected_hour_min != profile->expected_hour_max) {
		if (tm.tm_hour < profile->expected_hour_min ||
		    tm.tm_hour > profile->expected_hour_max) {
			profile->wrong_hour_detected = true;
			return true;
		}
	}
	return false;
}

/*
 * "Using the wrong port at the wrong hour" detection
 * Cross-references port activity against temporal baseline
 */
static bool hpm_temporal_port_anomaly(struct hpm_source_profile *profile,
				      u16 port)
{
	struct tm tm;
	time64_t now = ktime_get_real_seconds();

	time64_to_tm(now, 0, &tm);

	/* Record activity in hourly slot */
	profile->hour_activity[tm.tm_hour]++;

	/* High-privilege ports (< 1024) accessed outside business hours */
	if (port < 1024 && (tm.tm_hour < 6 || tm.tm_hour > 22))
		return true;

	/* Management ports (SSH:22, RDP:3389, etc.) at unusual hours */
	if ((port == 22 || port == 3389 || port == 5900) &&
	    (tm.tm_hour < 4 || tm.tm_hour > 2)) {
		/* Check if this is a new pattern for this source */
		if (profile->hour_activity[tm.tm_hour] <= 2)
			return true; /* First time seen at this hour */
	}

	return false;
}

/*
 * "IDS used backwards" detection
 * Detects patterns where an attacker is probing to map IDS rules
 * by observing which packets get dropped vs passed.
 * They graph system responses to find the reversal point.
 */
static bool hpm_ids_reversal_detection(struct hpm_source_profile *profile)
{
	int i;
	u32 increasing = 0, decreasing = 0;

	/* Analyze response latency pattern for systematic probing */
	for (i = 1; i < 16 && i <= profile->latency_idx; i++) {
		if (profile->response_latencies[i] > profile->response_latencies[i - 1])
			increasing++;
		else
			decreasing++;
	}

	/*
	 * If responses show a clear step pattern (some fast, some slow/dropped),
	 * it suggests someone is mapping the filtering rules by measuring timing.
	 * A reversal = finding the boundary where blocked becomes allowed.
	 */
	if (profile->latency_idx >= 10 &&
	    (increasing > 12 || decreasing > 12)) {
		profile->reversal_score += 10;
		return true;
	}

	/* Systematic port walking with consistent timing = IDS mapping */
	if (profile->ports_touched > 10 &&
	    profile->ids_trigger_count > 5 &&
	    profile->stealth_packets > 3) {
		profile->reversal_score += 20;
		return true;
	}

	return false;
}

static u8 hpm_pipe2_safety_check(struct hpm_source_profile *profile,
				 struct tcphdr *tcph, u16 dst_port)
{
	u8 score = 100;

	/* Stealth packet detection */
	if (tcph && hpm_is_stealth_packet(tcph)) {
		score -= 40;
		profile->stealth_packets++;
	}

	/* DoS pattern */
	if (hpm_is_dos_pattern(profile))
		score -= 30;

	/* Port scanning */
	if (hpm_is_port_scan(profile))
		score -= 25;

	/* Temporal anomaly: wrong port at wrong hour */
	if (hpm_temporal_port_anomaly(profile, dst_port)) {
		score -= 15;
		profile->wrong_port_detected = true;
	}

	/* Wrong hour entirely */
	if (hpm_is_wrong_hour(profile))
		score -= 10;

	/* IDS reversal probing */
	if (hpm_ids_reversal_detection(profile))
		score -= 35;

	if (score < 0)
		score = 0;

	profile->pipe2_safety_score = score;
	return score;
}

/* ============================================================
 * PIPE 3: Response Graphing & Reversal Detection
 *
 * Monitors outbound responses and correlates with inbound requests:
 * - Graphs response times to detect IDS rule mapping attempts
 * - Detects "using IDS backwards" to find filter boundaries
 * - Tracks response patterns for systematic reversal attacks
 * - Monitors admin actions for identity mismatches
 *
 * Safety Checkpoint 3: Response integrity score.
 * ============================================================ */

/*
 * "Wrong person to adjust port steadiness" detection
 * Checks if the source modifying port state/firewall rules matches
 * the expected admin identity (based on source IP/subnet/time).
 */
struct hpm_admin_identity {
	__be32	expected_ip;
	__be32	expected_subnet_mask;
	u8	expected_hour_min;
	u8	expected_hour_max;
	bool	configured;
};

static struct hpm_admin_identity hpm_admin = {
	.configured = false,
};

static bool hpm_verify_admin_identity(__be32 src_ip)
{
	if (!hpm_admin.configured)
		return true; /* No admin policy configured = allow all */

	/* Check if source matches expected admin IP/subnet */
	if ((src_ip & hpm_admin.expected_subnet_mask) !=
	    (hpm_admin.expected_ip & hpm_admin.expected_subnet_mask))
		return false;

	/* Check if within expected admin hours */
	struct tm tm;
	time64_t now = ktime_get_real_seconds();
	time64_to_tm(now, 0, &tm);

	if (tm.tm_hour < hpm_admin.expected_hour_min ||
	    tm.tm_hour > hpm_admin.expected_hour_max)
		return false;

	return true;
}

static u8 hpm_pipe3_safety_check(struct hpm_source_profile *profile,
				 __be32 src_ip, u16 dst_port)
{
	u8 score = 100;

	/* Check admin identity for management ports */
	if (dst_port == 22 || dst_port == 23 || dst_port == 3389 ||
	    dst_port == 8080 || dst_port == 8443 || dst_port == 64444) {
		if (!hpm_verify_admin_identity(src_ip)) {
			score -= 40;
			profile->wrong_identity = true;
		}
	}

	/* Response pattern reversal score */
	if (profile->reversal_score > 50)
		score -= 30;
	else if (profile->reversal_score > 20)
		score -= 15;

	/* Accumulated IDS triggers suggest systematic probing */
	if (profile->ids_trigger_count > 10)
		score -= 20;

	/* Combined threat indicators */
	if (profile->wrong_port_detected && profile->wrong_hour_detected &&
	    profile->stealth_packets > 0)
		score -= 25; /* Multi-vector attack indicators */

	if (score < 0)
		score = 0;

	profile->pipe3_safety_score = score;
	return score;
}

/* ============================================================
 * Logging Daemon
 *
 * Lightweight background thread that flushes log entries from the
 * ring buffer. Minimal overhead when idle.
 * ============================================================ */

static void hpm_log_write(u8 pipe_id, u8 severity, __be32 src_ip,
			  __be32 dst_ip, u16 src_port, u64 dst_port,
			  u8 safety_score, const char *fmt, ...)
{
	struct hpm_log_entry *entry;
	int head;
	va_list args;

	if (!hpm_log_ring)
		return;

	head = atomic_inc_return(&hpm_log_head) % HPM_LOG_RING_SIZE;
	entry = &hpm_log_ring[head];

	entry->timestamp = ktime_get_real();
	entry->src_ip = src_ip;
	entry->dst_ip = dst_ip;
	entry->src_port = src_port;
	entry->dst_port = dst_port;
	entry->pipe_id = pipe_id;
	entry->severity = severity;
	entry->safety_score = safety_score;

	va_start(args, fmt);
	vsnprintf(entry->message, sizeof(entry->message), fmt, args);
	va_end(args);
}

static int hpm_log_daemon_fn(void *data)
{
	while (!kthread_should_stop()) {
		int head = atomic_read(&hpm_log_head);
		int tail = atomic_read(&hpm_log_tail);

		while (tail != head) {
			struct hpm_log_entry *entry;
			tail = (tail + 1) % HPM_LOG_RING_SIZE;
			entry = &hpm_log_ring[tail];

			/* Print to kernel log based on severity */
			switch (entry->severity) {
			case HPM_SEVERITY_CRITICAL:
				pr_crit("hpm[P%d]: %s (score=%u src=%pI4 port=%llu)\n",
					entry->pipe_id, entry->message,
					entry->safety_score, &entry->src_ip,
					entry->dst_port);
				break;
			case HPM_SEVERITY_HIGH:
				pr_warn("hpm[P%d]: %s (score=%u src=%pI4 port=%llu)\n",
					entry->pipe_id, entry->message,
					entry->safety_score, &entry->src_ip,
					entry->dst_port);
				break;
			case HPM_SEVERITY_MEDIUM:
				pr_notice("hpm[P%d]: %s (score=%u src=%pI4)\n",
					  entry->pipe_id, entry->message,
					  entry->safety_score, &entry->src_ip);
				break;
			default:
				pr_debug("hpm[P%d]: %s (score=%u)\n",
					 entry->pipe_id, entry->message,
					 entry->safety_score);
			}
			atomic_set(&hpm_log_tail, tail);
		}

		/* Sleep briefly, wake on activity or every 100ms */
		schedule_timeout_interruptible(HZ / 10);
	}
	return 0;
}

/* ============================================================
 * Netfilter Hook - Main Packet Interception Point
 *
 * All packets flow through this hook and are fed into the
 * three-pipe heuristic pipeline sequentially.
 * ============================================================ */

static struct hpm_source_profile *hpm_get_or_create_profile(__be32 src_ip)
{
	struct hpm_source_profile *profile;
	u32 hash = jhash_1word(src_ip, 0);

	hash_for_each_possible(hpm_source_table, profile, node, hash) {
		if (profile->ip_addr == src_ip)
			return profile;
	}

	/* Create new profile */
	profile = kzalloc(sizeof(*profile), GFP_ATOMIC);
	if (!profile)
		return NULL;

	profile->ip_addr = src_ip;
	profile->first_seen = jiffies;
	profile->last_seen = jiffies;
	profile->window_start = jiffies;
	spin_lock_init(&profile->lock);

	hash_add(hpm_source_table, &profile->node, hash);
	return profile;
}

static unsigned int hpm_hook_fn(void *priv, struct sk_buff *skb,
				const struct nf_hook_state *state)
{
	struct iphdr *iph;
	struct tcphdr *tcph = NULL;
	struct udphdr *udph = NULL;
	struct hpm_source_profile *profile;
	unsigned char *payload = NULL;
	int payload_len = 0;
	u16 dst_port = 0;
	u8 score1, score2, score3;
	int protocol_class;

	/* Admin toggle: if dormant, pass everything */
	if (!hpm_active)
		return NF_ACCEPT;

	if (!skb)
		return NF_ACCEPT;

	iph = ip_hdr(skb);
	if (!iph)
		return NF_ACCEPT;

	/* Extract transport layer info */
	if (iph->protocol == IPPROTO_TCP) {
		tcph = tcp_hdr(skb);
		if (!tcph)
			return NF_ACCEPT;
		dst_port = ntohs(tcph->dest);
		payload = (unsigned char *)tcph + (tcph->doff * 4);
		payload_len = ntohs(iph->tot_len) - (iph->ihl * 4) - (tcph->doff * 4);
	} else if (iph->protocol == IPPROTO_UDP) {
		udph = udp_hdr(skb);
		if (!udph)
			return NF_ACCEPT;
		dst_port = ntohs(udph->dest);
		payload = (unsigned char *)udph + sizeof(struct udphdr);
		payload_len = ntohs(udph->len) - sizeof(struct udphdr);
	} else {
		return NF_ACCEPT; /* Only inspect TCP/UDP */
	}

	/* Get or create source profile */
	spin_lock(&hpm_table_lock);
	profile = hpm_get_or_create_profile(iph->saddr);
	spin_unlock(&hpm_table_lock);

	if (!profile)
		return NF_ACCEPT;

	spin_lock(&profile->lock);

	/* Update window if expired */
	if (time_after(jiffies, profile->window_start + HPM_WINDOW_SECONDS * HZ)) {
		profile->packets_in_window = 0;
		profile->ports_touched = 0;
		profile->window_start = jiffies;
	}

	profile->packets_in_window++;
	profile->last_seen = jiffies;

	/* ---- PIPE 1: Protocol Framing Analysis ---- */
	if (payload && payload_len > 0) {
		protocol_class = hpm_pipe1_classify_protocol(payload, payload_len);

		switch (protocol_class) {
		case 1: profile->http_calls++; break;
		case 2: profile->ftp_calls++; break;
		}
	} else {
		protocol_class = -1;
	}

	score1 = hpm_pipe1_safety_check(profile, protocol_class, payload_len);

	/* ---- SAFETY REVIEW POINT 1 ---- */
	if (score1 < 30) {
		hpm_log_write(HPM_PIPE_1_FRAMING, HPM_SEVERITY_HIGH,
			      iph->saddr, iph->daddr,
			      tcph ? ntohs(tcph->source) : ntohs(udph->source),
			      dst_port, score1,
			      "Framing anomaly: proto=%d malformed=%u raw=%u",
			      protocol_class, profile->malformed_frames,
			      profile->raw_buffers);
	}

	/* ---- PIPE 2: Behavioral Heuristics ---- */
	score2 = hpm_pipe2_safety_check(profile, tcph, dst_port);

	/* ---- SAFETY REVIEW POINT 2 ---- */
	if (score2 < 30) {
		hpm_log_write(HPM_PIPE_2_BEHAVIOR, HPM_SEVERITY_HIGH,
			      iph->saddr, iph->daddr,
			      tcph ? ntohs(tcph->source) : ntohs(udph->source),
			      dst_port, score2,
			      "Behavioral alert: stealth=%u dos=%d scan=%d hour=%d",
			      profile->stealth_packets,
			      hpm_is_dos_pattern(profile),
			      hpm_is_port_scan(profile),
			      profile->wrong_hour_detected);
	}

	/* ---- PIPE 3: Response Graphing & Reversal ---- */
	score3 = hpm_pipe3_safety_check(profile, iph->saddr, dst_port);

	/* ---- SAFETY REVIEW POINT 3 ---- */
	if (score3 < 30) {
		hpm_log_write(HPM_PIPE_3_RESPONSE, HPM_SEVERITY_CRITICAL,
			      iph->saddr, iph->daddr,
			      tcph ? ntohs(tcph->source) : ntohs(udph->source),
			      dst_port, score3,
			      "Response threat: reversal=%u ids_trig=%u wrong_id=%d",
			      profile->reversal_score,
			      profile->ids_trigger_count,
			      profile->wrong_identity);
	}

	/* Determine overall threat level */
	if (score1 < 20 || score2 < 20 || score3 < 20)
		profile->severity = HPM_SEVERITY_CRITICAL;
	else if (score1 < 40 || score2 < 40 || score3 < 40)
		profile->severity = HPM_SEVERITY_HIGH;
	else if (score1 < 60 || score2 < 60 || score3 < 60)
		profile->severity = HPM_SEVERITY_MEDIUM;
	else
		profile->severity = HPM_SEVERITY_NONE;

	spin_unlock(&profile->lock);

	/* Drop packet if critical threat detected */
	if (profile->severity == HPM_SEVERITY_CRITICAL) {
		profile->ids_trigger_count++;
		return NF_DROP;
	}

	return NF_ACCEPT;
}

/* ============================================================
 * Proc Filesystem Interface - Admin Controls
 *
 * /proc/hpm/status  - View current state and statistics
 * /proc/hpm/toggle  - Write 1/0 to enable/disable monitoring
 * /proc/hpm/log     - Read recent log entries
 * ============================================================ */

static int hpm_proc_status_show(struct seq_file *m, void *v)
{
	struct hpm_source_profile *profile;
	int bkt;
	int total_tracked = 0;
	int threats_critical = 0, threats_high = 0;

	seq_printf(m, "=== Heuristic Port Monitor (HPM) ===\n");
	seq_printf(m, "State: %s\n", hpm_active ? "ACTIVE" : "DORMANT");
	seq_printf(m, "Extended Port Range: 0 - %llu\n", HPM_EXTENDED_PORT_MAX);
	seq_printf(m, "Pipes: 3 (Framing | Behavioral | Response)\n\n");

	spin_lock(&hpm_table_lock);
	hash_for_each(hpm_source_table, bkt, profile, node) {
		total_tracked++;
		if (profile->severity == HPM_SEVERITY_CRITICAL)
			threats_critical++;
		else if (profile->severity == HPM_SEVERITY_HIGH)
			threats_high++;
	}
	spin_unlock(&hpm_table_lock);

	seq_printf(m, "Tracked Sources: %d\n", total_tracked);
	seq_printf(m, "Critical Threats: %d\n", threats_critical);
	seq_printf(m, "High Threats: %d\n", threats_high);
	seq_printf(m, "Log Ring Usage: %d / %d\n",
		   atomic_read(&hpm_log_head) - atomic_read(&hpm_log_tail),
		   HPM_LOG_RING_SIZE);

	return 0;
}

static int hpm_proc_status_open(struct inode *inode, struct file *file)
{
	return single_open(file, hpm_proc_status_show, NULL);
}

static const struct proc_ops hpm_proc_status_ops = {
	.proc_open = hpm_proc_status_open,
	.proc_read = seq_read,
	.proc_lseek = seq_lseek,
	.proc_release = single_release,
};

/*
 * Toggle interface: echo 1 > /proc/hpm/toggle  (activate)
 *                   echo 0 > /proc/hpm/toggle  (deactivate)
 */
static ssize_t hpm_proc_toggle_write(struct file *file, const char __user *buf,
				     size_t count, loff_t *ppos)
{
	char kbuf[4];
	int val;

	if (count > 3)
		return -EINVAL;

	if (copy_from_user(kbuf, buf, count))
		return -EFAULT;

	kbuf[count] = '\0';

	if (kstrtoint(kbuf, 10, &val))
		return -EINVAL;

	if (val != 0 && val != 1)
		return -EINVAL;

	hpm_active = val;
	pr_info("hpm: Monitor %s by admin\n", val ? "ACTIVATED" : "DEACTIVATED");

	hpm_log_write(0, HPM_SEVERITY_MEDIUM, 0, 0, 0, 0, 100,
		      "Admin toggled monitor: %s", val ? "active" : "dormant");

	return count;
}

static const struct proc_ops hpm_proc_toggle_ops = {
	.proc_write = hpm_proc_toggle_write,
};

/* Log reader */
static int hpm_proc_log_show(struct seq_file *m, void *v)
{
	int i, tail, head;
	struct hpm_log_entry *entry;

	head = atomic_read(&hpm_log_head);
	tail = head - 64; /* Show last 64 entries */
	if (tail < 0)
		tail = 0;

	seq_printf(m, "=== HPM Log (last 64 entries) ===\n");
	seq_printf(m, "%-20s %-6s %-4s %-16s %-8s %s\n",
		   "Timestamp", "Pipe", "Sev", "Source IP", "Score", "Message");

	for (i = tail; i < head; i++) {
		entry = &hpm_log_ring[i % HPM_LOG_RING_SIZE];
		seq_printf(m, "%-20lld P%-5d %-4d %pI4  %-8u %s\n",
			   ktime_to_ns(entry->timestamp),
			   entry->pipe_id, entry->severity,
			   &entry->src_ip, entry->safety_score,
			   entry->message);
	}

	return 0;
}

static int hpm_proc_log_open(struct inode *inode, struct file *file)
{
	return single_open(file, hpm_proc_log_show, NULL);
}

static const struct proc_ops hpm_proc_log_ops = {
	.proc_open = hpm_proc_log_open,
	.proc_read = seq_read,
	.proc_lseek = seq_lseek,
	.proc_release = single_release,
};

/* ============================================================
 * Module Init / Exit
 * ============================================================ */

static int __init hpm_init(void)
{
	int ret;

	pr_info("hpm: Initializing Heuristic Port Monitor v1.0.0\n");
	pr_info("hpm: Three-pipe architecture: Framing | Behavioral | Response\n");
	pr_info("hpm: Extended port range: 0 - %llu\n", HPM_EXTENDED_PORT_MAX);

	/* Allocate log ring */
	hpm_log_ring = kzalloc(sizeof(struct hpm_log_entry) * HPM_LOG_RING_SIZE,
			       GFP_KERNEL);
	if (!hpm_log_ring)
		return -ENOMEM;

	/* Initialize hash table */
	hash_init(hpm_source_table);

	/* Register Netfilter hook (incoming packets) */
	hpm_nf_hook_in.hook = hpm_hook_fn;
	hpm_nf_hook_in.hooknum = NF_INET_PRE_ROUTING;
	hpm_nf_hook_in.pf = PF_INET;
	hpm_nf_hook_in.priority = NF_IP_PRI_FIRST + 1; /* Just after conntrack */

	ret = nf_register_net_hook(&init_net, &hpm_nf_hook_in);
	if (ret < 0) {
		pr_err("hpm: Failed to register netfilter hook: %d\n", ret);
		kfree(hpm_log_ring);
		return ret;
	}

	/* Start logging daemon */
	hpm_log_daemon = kthread_run(hpm_log_daemon_fn, NULL, "hpm_logd");
	if (IS_ERR(hpm_log_daemon)) {
		pr_err("hpm: Failed to start log daemon\n");
		nf_unregister_net_hook(&init_net, &hpm_nf_hook_in);
		kfree(hpm_log_ring);
		return PTR_ERR(hpm_log_daemon);
	}

	/* Create /proc/hpm/ directory and entries */
	hpm_proc_dir = proc_mkdir("hpm", NULL);
	if (hpm_proc_dir) {
		hpm_proc_status = proc_create("status", 0444,
					      hpm_proc_dir,
					      &hpm_proc_status_ops);
		hpm_proc_toggle = proc_create("toggle", 0200,
					      hpm_proc_dir,
					      &hpm_proc_toggle_ops);
		hpm_proc_log = proc_create("log", 0444,
					   hpm_proc_dir,
					   &hpm_proc_log_ops);
	}

	pr_info("hpm: Active. Admin controls at /proc/hpm/\n");
	pr_info("hpm: Toggle: echo 0|1 > /proc/hpm/toggle\n");

	return 0;
}

static void __exit hpm_exit(void)
{
	struct hpm_source_profile *profile;
	struct hlist_node *tmp;
	int bkt;

	pr_info("hpm: Shutting down Heuristic Port Monitor\n");

	/* Stop logging daemon */
	if (hpm_log_daemon)
		kthread_stop(hpm_log_daemon);

	/* Unregister netfilter hook */
	nf_unregister_net_hook(&init_net, &hpm_nf_hook_in);

	/* Remove proc entries */
	if (hpm_proc_dir) {
		proc_remove(hpm_proc_dir);
	}

	/* Free all tracked profiles */
	spin_lock(&hpm_table_lock);
	hash_for_each_safe(hpm_source_table, bkt, tmp, profile, node) {
		hash_del(&profile->node);
		kfree(profile);
	}
	spin_unlock(&hpm_table_lock);

	/* Free log ring */
	kfree(hpm_log_ring);

	pr_info("hpm: Shutdown complete\n");
}

module_init(hpm_init);
module_exit(hpm_exit);
