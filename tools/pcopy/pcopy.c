/*
 * pcopy — Parallel Copy/Move userspace tool
 *
 * Uses the pcopy kernel module (/dev/pcopy) to perform hardware-aware
 * parallel file copy and move operations. Falls back to sequential
 * splice if the kernel module is not loaded.
 *
 * Usage:
 *   pcopy [options] <source...> <destination>
 *   pmove [options] <source...> <destination>
 *
 * Options:
 *   -j N          Force N parallel channels (default: auto-detect)
 *   -c SIZE       Chunk size in KB (default: auto-tune)
 *   -s            Sync after each file (fsync)
 *   -p            Preserve permissions and timestamps
 *   -f            Force overwrite existing files
 *   -v            Verbose output (per-file progress)
 *   -n            Dry run (show what would be done)
 *   --status      Show hardware status and exit
 *   --help        Show usage
 *
 * Examples:
 *   pcopy *.log /backup/logs/           # Copy all .log files in parallel
 *   pcopy -j 8 -s dir1/ dir2/ /mnt/    # 8 channels, sync, two source dirs
 *   pmove -p old/ new/                  # Move with preserved attrs
 *   pcopy --status                      # Show NVMe/PCIe/CPU detection
 *
 * The tool auto-detects:
 *   - Number of online CPUs
 *   - NVMe hardware queue depth (via /dev/pcopy ioctl)
 *   - PCIe generation and lane width
 *   - Optimal chunk size for the device
 *
 * When multiple files are copied, each file is assigned to a channel.
 * Channels run in parallel, each issuing I/O that maps to a distinct
 * NVMe submission queue via the kernel's blk-mq layer.
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 * License: GPL-2.0
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <dirent.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/time.h>
#include <linux/limits.h>
#include <getopt.h>
#include <libgen.h>
#include <time.h>

/* Must match kernel module definitions */
#define PCOPY_IOCTL_MAGIC       0xPC
#define PCOPY_MAX_FILES         4096

#define PCOPY_F_SYNC            (1 << 0)
#define PCOPY_F_PRESERVE        (1 << 1)
#define PCOPY_F_OVERWRITE       (1 << 2)
#define PCOPY_F_MOVE            (1 << 3)
#define PCOPY_F_CROSS_DEVICE    (1 << 4)
#define PCOPY_F_VERBOSE         (1 << 5)

struct pcopy_file_pair {
	char src_path[PATH_MAX];
	char dst_path[PATH_MAX];
};

struct pcopy_batch_request {
	__u32 nr_files;
	__u32 flags;
	__u32 max_channels;
	__u32 chunk_size;
	struct pcopy_file_pair *pairs;
};

struct pcopy_hw_status {
	__u32 online_cpus;
	__u32 nr_hw_queues;
	__u32 pcie_gen;
	__u32 pcie_lanes;
	__u32 bandwidth_mb_s;
	__u32 recommended_channels;
	__u32 chunk_size;
	__u32 nvme_detected;
};

#define PCOPY_IOC_COPY   _IOW(PCOPY_IOCTL_MAGIC, 1, struct pcopy_batch_request)
#define PCOPY_IOC_MOVE   _IOW(PCOPY_IOCTL_MAGIC, 2, struct pcopy_batch_request)
#define PCOPY_IOC_STATUS _IOR(PCOPY_IOCTL_MAGIC, 3, struct pcopy_hw_status)

/* Fallback: read /proc/pcopy/status if ioctl unavailable */
static int pcopy_read_proc_status(struct pcopy_hw_status *hw)
{
	FILE *f = fopen("/proc/pcopy/status", "r");
	char line[256];

	if (!f)
		return -1;

	memset(hw, 0, sizeof(*hw));
	hw->online_cpus = sysconf(_SC_NPROCESSORS_ONLN);

	while (fgets(line, sizeof(line), f)) {
		sscanf(line, "Block HW Queues: %u", &hw->nr_hw_queues);
		sscanf(line, "PCIe Generation: Gen%u", &hw->pcie_gen);
		sscanf(line, "PCIe Lanes: x%u", &hw->pcie_lanes);
		sscanf(line, "Est. Bandwidth: %u MB/s", &hw->bandwidth_mb_s);
		sscanf(line, "Recommended Channels: %u", &hw->recommended_channels);
		sscanf(line, "Recommended Chunk: %u KB", &hw->chunk_size);
		if (strstr(line, "NVMe Detected:") && strstr(line, "YES"))
			hw->nvme_detected = 1;
	}

	if (hw->chunk_size)
		hw->chunk_size *= 1024;  /* Convert KB to bytes */

	fclose(f);
	return 0;
}

static void print_hw_status(const struct pcopy_hw_status *hw)
{
	printf("╔══════════════════════════════════════════════╗\n");
	printf("║  Parallel Copy/Move — Hardware Detection    ║\n");
	printf("╠══════════════════════════════════════════════╣\n");
	printf("║  Online CPUs:          %-4u                 ║\n", hw->online_cpus);
	printf("║  NVMe HW Queues:       %-4u                 ║\n", hw->nr_hw_queues);
	printf("║  NVMe Detected:        %-3s                  ║\n",
	       hw->nvme_detected ? "YES" : "no");
	printf("║  PCIe Generation:      Gen%-1u                 ║\n", hw->pcie_gen);
	printf("║  PCIe Lanes:           x%-2u                  ║\n", hw->pcie_lanes);
	printf("║  Est. Bandwidth:       %-5u MB/s            ║\n", hw->bandwidth_mb_s);
	printf("║  Recommended Channels: %-4u                 ║\n", hw->recommended_channels);
	printf("║  Recommended Chunk:    %-4u KB              ║\n",
	       hw->chunk_size / 1024);
	printf("╠══════════════════════════════════════════════╣\n");
	printf("║  Theory:                                    ║\n");
	printf("║  channels = min(CPUs, HW_Queues, files)     ║\n");
	printf("║  Each channel → distinct NVMe SQ            ║\n");
	printf("║  All SQs processed in parallel by NVMe ctrl ║\n");
	printf("║  Throughput ≈ channels × single-stream BW   ║\n");
	printf("║  Capped by PCIe lane bandwidth              ║\n");
	printf("╚══════════════════════════════════════════════╝\n");
}

/*
 * Recursively collect files from a directory into the pairs array.
 * Maintains relative path structure at destination.
 */
static int collect_files_recursive(const char *src_dir, const char *dst_dir,
				   struct pcopy_file_pair **pairs,
				   unsigned int *nr_files,
				   unsigned int *capacity)
{
	DIR *d;
	struct dirent *ent;
	struct stat st;
	char src_path[PATH_MAX], dst_path[PATH_MAX];

	d = opendir(src_dir);
	if (!d)
		return -errno;

	while ((ent = readdir(d)) != NULL) {
		if (ent->d_name[0] == '.' &&
		    (ent->d_name[1] == '\0' ||
		     (ent->d_name[1] == '.' && ent->d_name[2] == '\0')))
			continue;

		snprintf(src_path, PATH_MAX, "%s/%s", src_dir, ent->d_name);
		snprintf(dst_path, PATH_MAX, "%s/%s", dst_dir, ent->d_name);

		if (lstat(src_path, &st) < 0)
			continue;

		if (S_ISDIR(st.st_mode)) {
			/* Create destination directory */
			mkdir(dst_path, st.st_mode);
			/* Recurse */
			collect_files_recursive(src_path, dst_path,
						pairs, nr_files, capacity);
		} else if (S_ISREG(st.st_mode)) {
			if (*nr_files >= *capacity) {
				*capacity *= 2;
				*pairs = realloc(*pairs,
						 *capacity * sizeof(struct pcopy_file_pair));
				if (!*pairs)
					return -ENOMEM;
			}

			strncpy((*pairs)[*nr_files].src_path, src_path, PATH_MAX - 1);
			strncpy((*pairs)[*nr_files].dst_path, dst_path, PATH_MAX - 1);
			(*nr_files)++;
		}
	}

	closedir(d);
	return 0;
}

static void usage(const char *progname)
{
	int is_move = (strstr(progname, "pmove") != NULL);

	printf("Usage: %s [options] <source...> <destination>\n\n", progname);
	printf("Parallel file %s using NVMe multi-queue and PCIe lane awareness.\n\n",
	       is_move ? "move" : "copy");
	printf("Options:\n");
	printf("  -j N       Force N parallel channels (default: auto)\n");
	printf("  -c SIZE    Chunk size in KB (default: auto-tune)\n");
	printf("  -s         Sync (fsync) after each file\n");
	printf("  -p         Preserve permissions and timestamps\n");
	printf("  -f         Force overwrite existing files\n");
	printf("  -v         Verbose (show per-file status)\n");
	printf("  -n         Dry run (show plan without executing)\n");
	printf("  --status   Show hardware status and exit\n");
	printf("  --help     Show this help\n");
	printf("\nExamples:\n");
	printf("  %s *.log /backup/logs/\n", progname);
	printf("  %s -j 8 -p data/ /mnt/backup/\n", progname);
	printf("  %s --status\n", progname);
	printf("\nChannel formula: min(online_cpus, nvme_hw_queues, nr_files)\n");
}

int main(int argc, char *argv[])
{
	struct pcopy_hw_status hw;
	struct pcopy_batch_request req;
	struct pcopy_file_pair *pairs = NULL;
	unsigned int nr_files = 0, capacity = 256;
	unsigned int flags = 0;
	unsigned int max_channels = 0;
	unsigned int chunk_size = 0;
	int dev_fd = -1;
	int is_move;
	int dry_run = 0;
	int verbose = 0;
	int show_status = 0;
	int opt;
	int ret = 0;
	struct timeval tv_start, tv_end;
	double elapsed;
	struct stat dst_stat;
	const char *dst_path;

	static struct option long_opts[] = {
		{"status", no_argument, NULL, 'S'},
		{"help",   no_argument, NULL, 'h'},
		{NULL, 0, NULL, 0}
	};

	/* Detect if invoked as pmove */
	is_move = (strstr(argv[0], "pmove") != NULL);

	while ((opt = getopt_long(argc, argv, "j:c:spfvnh", long_opts, NULL)) != -1) {
		switch (opt) {
		case 'j':
			max_channels = atoi(optarg);
			break;
		case 'c':
			chunk_size = atoi(optarg) * 1024;
			break;
		case 's':
			flags |= PCOPY_F_SYNC;
			break;
		case 'p':
			flags |= PCOPY_F_PRESERVE;
			break;
		case 'f':
			flags |= PCOPY_F_OVERWRITE;
			break;
		case 'v':
			verbose = 1;
			flags |= PCOPY_F_VERBOSE;
			break;
		case 'n':
			dry_run = 1;
			break;
		case 'S':
			show_status = 1;
			break;
		case 'h':
		default:
			usage(argv[0]);
			return (opt == 'h') ? 0 : 1;
		}
	}

	if (is_move)
		flags |= PCOPY_F_MOVE | PCOPY_F_CROSS_DEVICE;

	/* Show hardware status */
	if (show_status) {
		dev_fd = open("/dev/pcopy", O_RDWR);
		if (dev_fd >= 0) {
			if (ioctl(dev_fd, PCOPY_IOC_STATUS, &hw) == 0) {
				print_hw_status(&hw);
				close(dev_fd);
				return 0;
			}
			close(dev_fd);
		}
		/* Fallback to /proc */
		if (pcopy_read_proc_status(&hw) == 0) {
			print_hw_status(&hw);
			return 0;
		}
		fprintf(stderr, "pcopy: kernel module not loaded "
			"(modprobe pcopy)\n");
		return 1;
	}

	/* Need at least source and destination */
	if (argc - optind < 2) {
		usage(argv[0]);
		return 1;
	}

	/* Last argument is destination */
	dst_path = argv[argc - 1];

	/* Allocate pairs array */
	pairs = malloc(capacity * sizeof(struct pcopy_file_pair));
	if (!pairs) {
		perror("malloc");
		return 1;
	}

	/* Collect source files */
	for (int i = optind; i < argc - 1; i++) {
		struct stat src_st;

		if (lstat(argv[i], &src_st) < 0) {
			fprintf(stderr, "pcopy: cannot stat '%s': %s\n",
				argv[i], strerror(errno));
			ret = 1;
			continue;
		}

		if (S_ISDIR(src_st.st_mode)) {
			/* Directory: collect recursively */
			char dest[PATH_MAX];
			const char *base = basename(argv[i]);

			/* If destination is a directory, copy into it */
			if (stat(dst_path, &dst_stat) == 0 &&
			    S_ISDIR(dst_stat.st_mode)) {
				snprintf(dest, PATH_MAX, "%s/%s",
					 dst_path, base);
			} else {
				strncpy(dest, dst_path, PATH_MAX - 1);
			}
			mkdir(dest, src_st.st_mode);
			collect_files_recursive(argv[i], dest,
						&pairs, &nr_files, &capacity);
		} else if (S_ISREG(src_st.st_mode)) {
			/* Single file */
			if (nr_files >= capacity) {
				capacity *= 2;
				pairs = realloc(pairs,
						capacity * sizeof(struct pcopy_file_pair));
				if (!pairs) {
					perror("realloc");
					return 1;
				}
			}

			strncpy(pairs[nr_files].src_path, argv[i], PATH_MAX - 1);

			/* Construct destination path */
			if (stat(dst_path, &dst_stat) == 0 &&
			    S_ISDIR(dst_stat.st_mode)) {
				snprintf(pairs[nr_files].dst_path, PATH_MAX,
					 "%s/%s", dst_path, basename(argv[i]));
			} else {
				strncpy(pairs[nr_files].dst_path, dst_path,
					PATH_MAX - 1);
			}
			nr_files++;
		}
	}

	if (nr_files == 0) {
		fprintf(stderr, "pcopy: no files to %s\n",
			is_move ? "move" : "copy");
		free(pairs);
		return 1;
	}

	/* Compute effective channels for display */
	unsigned int eff_channels;
	dev_fd = open("/dev/pcopy", O_RDWR);
	if (dev_fd >= 0 && ioctl(dev_fd, PCOPY_IOC_STATUS, &hw) == 0) {
		eff_channels = max_channels ? max_channels : hw.recommended_channels;
		if (eff_channels > nr_files)
			eff_channels = nr_files;
	} else {
		/* Module not loaded — fall back to CPU count */
		hw.online_cpus = sysconf(_SC_NPROCESSORS_ONLN);
		hw.nr_hw_queues = hw.online_cpus;
		hw.recommended_channels = hw.online_cpus;
		eff_channels = max_channels ? max_channels : hw.online_cpus;
		if (eff_channels > nr_files)
			eff_channels = nr_files;
	}

	printf("pcopy: %u files, %u channels, %s\n",
	       nr_files, eff_channels,
	       is_move ? "MOVE" : "COPY");

	if (verbose || dry_run) {
		for (unsigned int i = 0; i < nr_files && i < 20; i++) {
			printf("  [%u] %s → %s\n", i,
			       pairs[i].src_path, pairs[i].dst_path);
		}
		if (nr_files > 20)
			printf("  ... and %u more\n", nr_files - 20);
	}

	if (dry_run) {
		printf("pcopy: dry run — no files %s\n",
		       is_move ? "moved" : "copied");
		free(pairs);
		if (dev_fd >= 0) close(dev_fd);
		return 0;
	}

	/* Execute via kernel module ioctl */
	gettimeofday(&tv_start, NULL);

	if (dev_fd >= 0) {
		req.nr_files = nr_files;
		req.flags = flags;
		req.max_channels = max_channels;
		req.chunk_size = chunk_size;
		req.pairs = pairs;

		unsigned int cmd = is_move ? PCOPY_IOC_MOVE : PCOPY_IOC_COPY;
		ret = ioctl(dev_fd, cmd, &req);
		if (ret < 0) {
			fprintf(stderr, "pcopy: ioctl failed: %s\n",
				strerror(errno));
			ret = 1;
		}
		close(dev_fd);
	} else {
		/*
		 * Fallback: module not loaded.
		 * Use multi-threaded userspace copy via fork/thread pool.
		 * This is a simplified sequential fallback for now.
		 */
		fprintf(stderr, "pcopy: kernel module not loaded, "
			"using sequential fallback\n");
		fprintf(stderr, "pcopy: load module with: modprobe pcopy\n");

		for (unsigned int i = 0; i < nr_files; i++) {
			char cmd[PATH_MAX * 2 + 16];

			if (is_move) {
				snprintf(cmd, sizeof(cmd), "mv '%s' '%s'",
					 pairs[i].src_path, pairs[i].dst_path);
			} else {
				snprintf(cmd, sizeof(cmd), "cp '%s' '%s'",
					 pairs[i].src_path, pairs[i].dst_path);
			}
			if (system(cmd) != 0)
				ret = 1;
		}
	}

	gettimeofday(&tv_end, NULL);
	elapsed = (tv_end.tv_sec - tv_start.tv_sec) +
		  (tv_end.tv_usec - tv_start.tv_usec) / 1000000.0;

	printf("pcopy: done in %.3f seconds (%u files, %u channels)\n",
	       elapsed, nr_files, eff_channels);

	free(pairs);
	return ret;
}
