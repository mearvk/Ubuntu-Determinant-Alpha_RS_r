/*
 * driverctl.c — Hardware Driver Discovery, Scan, and Installation Manager
 *
 * Discovers system hardware via PCI/USB sysfs enumeration, queries known
 * driver source repositories (kernel DRM tree, Mesa, NVIDIA, AMD, Intel),
 * downloads appropriate driver packages, scans them with ClamAV for malware,
 * and installs verified drivers.
 *
 * Supports: GPUs, NICs, WiFi, audio, motherboard chipsets, memory controllers,
 *           NVMe, USB controllers, and storage adapters.
 *
 * Data Sources:
 *   - Linux kernel device tree (drivers/gpu/drm, drivers/net, drivers/sound)
 *   - Mesa releases (mesa3d.org)
 *   - NVIDIA proprietary + open kernel modules
 *   - AMD ROCm / AMDGPU firmware
 *   - Intel media driver, GPU tools, firmware
 *   - Linux-firmware repository (kernel.org)
 *   - PCI ID database (pci-ids.ucw.cz)
 *
 * Usage:
 *   driverctl scan                 — Discover all hardware, show driver status
 *   driverctl scan --gpu           — GPU devices only
 *   driverctl scan --net           — Network devices only
 *   driverctl scan --audio         — Audio devices only
 *   driverctl scan --all           — All device classes
 *   driverctl install <device>     — Download, scan, install driver for device
 *   driverctl install --all        — Install best drivers for all devices
 *   driverctl update               — Check for newer driver versions
 *   driverctl update --install     — Update and install newer versions
 *   driverctl status               — Show installed drivers and versions
 *   driverctl verify <file>        — ClamAV scan of a driver package
 *   driverctl sources              — Show upstream source repositories
 *   driverctl tree                 — Show kernel device tree driver map
 *   driverctl --help               — This help
 *
 * Build:
 *   gcc -O2 -o driverctl driverctl.c -lcurl -lmysqlclient
 *   sudo make install  →  /usr/local/bin/driverctl
 *
 * Requires: libcurl, ClamAV (clamscan), pciutils (lspci), usbutils (lsusb)
 *
 * Author: Max Rupplin — MEARVK LLC
 * Date: August 8, 2026
 * License: GPL-2.0
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <errno.h>
#include <dirent.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <time.h>
#include <ctype.h>
#include <curl/curl.h>
#include <mysql/mysql.h>

/* ═══════════════════════════════════════════════════════════════════════
   Constants
   ═══════════════════════════════════════════════════════════════════════ */

#define VERSION             "1.0.0"
#define PROGRAM_NAME        "driverctl"

/* Paths */
#define SYSFS_PCI           "/sys/bus/pci/devices"
#define SYSFS_USB           "/sys/bus/usb/devices"
#define PROC_MODULES        "/proc/modules"
#define DRIVER_CACHE        "/var/cache/driverctl"
#define DRIVER_DB           "/var/lib/driverctl"
#define DRIVER_LOG          "/var/log/driverctl.log"

/* PCI Class Codes (top byte) */
#define PCI_CLASS_DISPLAY       0x03
#define PCI_CLASS_MULTIMEDIA    0x04
#define PCI_CLASS_NETWORK       0x02
#define PCI_CLASS_STORAGE       0x01
#define PCI_CLASS_BRIDGE        0x06
#define PCI_CLASS_MEMORY        0x05
#define PCI_CLASS_SERIAL_BUS    0x0C
#define PCI_CLASS_WIRELESS      0x0D
#define PCI_CLASS_PROCESSOR     0x0B

/* Vendor IDs */
#define VENDOR_NVIDIA   0x10DE
#define VENDOR_AMD      0x1002
#define VENDOR_INTEL    0x8086
#define VENDOR_REALTEK  0x10EC
#define VENDOR_BROADCOM 0x14E4
#define VENDOR_QUALCOMM 0x168C
#define VENDOR_MEDIATEK 0x14C3
#define VENDOR_MARVELL  0x11AB
#define VENDOR_MELLANOX 0x15B3
#define VENDOR_SAMSUNG  0x144D
#define VENDOR_MICRON   0x1344

/* Driver source repositories */
#define URL_LINUX_FIRMWARE  "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git"
#define URL_MESA_RELEASES   "https://archive.mesa3d.org/"
#define URL_NVIDIA_DRIVER   "https://download.nvidia.com/XFree86/Linux-x86_64/"
#define URL_AMD_FIRMWARE    "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/amdgpu"
#define URL_INTEL_FIRMWARE  "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/i915"
#define URL_PCIIDS          "https://pci-ids.ucw.cz/v2.2/pci.ids.gz"
#define URL_KERNEL_DRM      "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm"
#define URL_KERNEL_NET      "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net"
#define URL_KERNEL_SOUND    "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/sound"

/* Limits */
#define MAX_DEVICES         256
#define MAX_DRIVERS         512
#define MAX_PATH            4096
#define MAX_NAME            256
#define MAX_URL             1024
#define MAX_CMD             2048
#define CURL_TIMEOUT        60

/* Database */
#define DB_HOST     "127.0.0.1"
#define DB_USER     "root"
#define DB_PASS     ""
#define DB_NAME     "nwe_driverctl"
#define DB_PORT     3306

/* ═══════════════════════════════════════════════════════════════════════
   ANSI Colors
   ═══════════════════════════════════════════════════════════════════════ */

#define C_RESET     "\033[0m"
#define C_WHITE     "\033[37;1m"
#define C_GREEN     "\033[32;1m"
#define C_RED       "\033[31;1m"
#define C_YELLOW    "\033[33;1m"
#define C_CYAN      "\033[36m"
#define C_DIM       "\033[2m"
#define C_BLUE      "\033[34;1m"
#define C_MAGENTA   "\033[35;1m"

/* ═══════════════════════════════════════════════════════════════════════
   Data Structures
   ═══════════════════════════════════════════════════════════════════════ */

typedef enum {
    DEV_CLASS_GPU = 0,
    DEV_CLASS_NETWORK,
    DEV_CLASS_AUDIO,
    DEV_CLASS_STORAGE,
    DEV_CLASS_USB_CONTROLLER,
    DEV_CLASS_BRIDGE,
    DEV_CLASS_MEMORY,
    DEV_CLASS_WIRELESS,
    DEV_CLASS_OTHER,
    DEV_CLASS_COUNT
} DeviceClass;

static const char *device_class_names[] = {
    "GPU/Display",
    "Network",
    "Audio/Multimedia",
    "Storage",
    "USB Controller",
    "Bridge/Chipset",
    "Memory Controller",
    "Wireless",
    "Other"
};

typedef enum {
    DRIVER_STATUS_NONE = 0,     /* No driver loaded */
    DRIVER_STATUS_KERNEL,       /* Using in-tree kernel driver */
    DRIVER_STATUS_FIRMWARE,     /* Kernel driver + firmware loaded */
    DRIVER_STATUS_PROPRIETARY,  /* Vendor proprietary driver */
    DRIVER_STATUS_OUTDATED,     /* Driver loaded but newer available */
    DRIVER_STATUS_OPTIMAL       /* Best available driver installed */
} DriverStatus;

static const char *driver_status_names[] = {
    "NO DRIVER",
    "Kernel (in-tree)",
    "Kernel + Firmware",
    "Proprietary",
    "Outdated",
    "Optimal"
};

static const char *driver_status_colors[] = {
    C_RED,
    C_YELLOW,
    C_GREEN,
    C_CYAN,
    C_YELLOW,
    C_GREEN
};

typedef struct {
    char pci_slot[32];          /* e.g., "0000:01:00.0" */
    unsigned int vendor_id;
    unsigned int device_id;
    unsigned int class_code;    /* Full 24-bit class code */
    DeviceClass dev_class;
    char vendor_name[MAX_NAME];
    char device_name[MAX_NAME];
    char current_driver[MAX_NAME];
    char firmware_version[MAX_NAME];
    DriverStatus status;
    char recommended_driver[MAX_NAME];
    char recommended_url[MAX_URL];
    char recommended_version[64];
} HardwareDevice;

typedef struct {
    char name[MAX_NAME];
    char version[64];
    char url[MAX_URL];
    char description[512];
    char vendor[64];
    DeviceClass target_class;
    unsigned int vendor_id;
    unsigned int device_id_min;
    unsigned int device_id_max;
    int priority;               /* Higher = preferred */
} DriverEntry;

typedef struct {
    char url[MAX_URL];
    char filename[MAX_NAME];
    char local_path[MAX_PATH];
    size_t size;
    int scan_result;            /* 0 = clean, 1 = infected, -1 = scan failed */
    char scan_detail[512];
} DownloadResult;

/* ═══════════════════════════════════════════════════════════════════════
   Globals
   ═══════════════════════════════════════════════════════════════════════ */

static HardwareDevice g_devices[MAX_DEVICES];
static int g_device_count = 0;
static DriverEntry g_drivers[MAX_DRIVERS];
static int g_driver_count = 0;
static int g_verbose = 0;
static FILE *g_logfile = NULL;

/* ═══════════════════════════════════════════════════════════════════════
   Logging
   ═══════════════════════════════════════════════════════════════════════ */

static void log_open(void)
{
    g_logfile = fopen(DRIVER_LOG, "a");
    if (!g_logfile)
        g_logfile = stderr;
}

static void log_msg(const char *level, const char *fmt, ...)
{
    va_list ap;
    time_t now;
    char timebuf[64];

    if (!g_logfile) return;

    time(&now);
    strftime(timebuf, sizeof(timebuf), "%Y-%m-%d %H:%M:%S", localtime(&now));
    fprintf(g_logfile, "[%s] %s: ", timebuf, level);

    va_start(ap, fmt);
    vfprintf(g_logfile, fmt, ap);
    va_end(ap);

    fprintf(g_logfile, "\n");
    fflush(g_logfile);
}

#define LOG_INFO(...)   log_msg("INFO",  __VA_ARGS__)
#define LOG_WARN(...)   log_msg("WARN",  __VA_ARGS__)
#define LOG_ERROR(...)  log_msg("ERROR", __VA_ARGS__)

/* ═══════════════════════════════════════════════════════════════════════
   Utility Functions
   ═══════════════════════════════════════════════════════════════════════ */

static int read_sysfs_str(const char *path, char *buf, size_t len)
{
    FILE *f = fopen(path, "r");
    if (!f) return -1;

    if (!fgets(buf, (int)len, f)) {
        fclose(f);
        return -1;
    }
    fclose(f);

    /* Strip trailing whitespace/newline */
    size_t slen = strlen(buf);
    while (slen > 0 && (buf[slen - 1] == '\n' || buf[slen - 1] == '\r'
                        || buf[slen - 1] == ' '))
        buf[--slen] = '\0';

    return 0;
}

static unsigned int read_sysfs_hex(const char *path)
{
    char buf[64];
    if (read_sysfs_str(path, buf, sizeof(buf)) != 0)
        return 0;
    return (unsigned int)strtoul(buf, NULL, 16);
}

static int file_exists(const char *path)
{
    struct stat st;
    return stat(path, &st) == 0;
}

static int ensure_dir(const char *path)
{
    struct stat st;
    if (stat(path, &st) == 0 && S_ISDIR(st.st_mode))
        return 0;
    return mkdir(path, 0755);
}

static int run_command(const char *cmd, char *output, size_t output_size)
{
    FILE *p;
    size_t total = 0;

    p = popen(cmd, "r");
    if (!p) return -1;

    if (output && output_size > 0) {
        output[0] = '\0';
        while (total < output_size - 1) {
            size_t n = fread(output + total, 1, output_size - 1 - total, p);
            if (n == 0) break;
            total += n;
        }
        output[total] = '\0';
    } else {
        /* Drain output */
        char drain[4096];
        while (fread(drain, 1, sizeof(drain), p) > 0)
            ;
    }

    return pclose(p);
}

/* ═══════════════════════════════════════════════════════════════════════
   PCI ID → Human-Readable Name Resolution
   ═══════════════════════════════════════════════════════════════════════ */

static void resolve_vendor_name(unsigned int vendor_id, char *out, size_t len)
{
    switch (vendor_id) {
    case VENDOR_NVIDIA:   snprintf(out, len, "NVIDIA Corporation"); break;
    case VENDOR_AMD:      snprintf(out, len, "Advanced Micro Devices [AMD/ATI]"); break;
    case VENDOR_INTEL:    snprintf(out, len, "Intel Corporation"); break;
    case VENDOR_REALTEK:  snprintf(out, len, "Realtek Semiconductor"); break;
    case VENDOR_BROADCOM: snprintf(out, len, "Broadcom Inc."); break;
    case VENDOR_QUALCOMM: snprintf(out, len, "Qualcomm Atheros"); break;
    case VENDOR_MEDIATEK: snprintf(out, len, "MediaTek Inc."); break;
    case VENDOR_MARVELL:  snprintf(out, len, "Marvell Technology"); break;
    case VENDOR_MELLANOX: snprintf(out, len, "Mellanox Technologies"); break;
    case VENDOR_SAMSUNG:  snprintf(out, len, "Samsung Electronics"); break;
    case VENDOR_MICRON:   snprintf(out, len, "Micron Technology"); break;
    default:
        snprintf(out, len, "Unknown [%04x]", vendor_id);
        break;
    }
}

/*
 * Query lspci for device description (more accurate than built-in table).
 * Falls back to built-in vendor name + hex device ID.
 */
static void resolve_device_name(const char *pci_slot, unsigned int vendor_id,
                                unsigned int device_id, char *out, size_t len)
{
    char cmd[512];
    char result[512];

    snprintf(cmd, sizeof(cmd), "lspci -s %s -q 2>/dev/null | head -1", pci_slot);
    if (run_command(cmd, result, sizeof(result)) == 0 && strlen(result) > 8) {
        /* lspci output format: "01:00.0 VGA compatible controller: ..." */
        char *colon = strchr(result, ':');
        if (colon) {
            colon++; /* skip first colon+space */
            colon = strchr(colon, ':');
            if (colon) {
                colon++;
                while (*colon == ' ') colon++;
                snprintf(out, len, "%s", colon);
                return;
            }
        }
        snprintf(out, len, "%s", result);
        return;
    }

    /* Fallback */
    char vendor_str[128];
    resolve_vendor_name(vendor_id, vendor_str, sizeof(vendor_str));
    snprintf(out, len, "%s Device [%04x]", vendor_str, device_id);
}

/* ═══════════════════════════════════════════════════════════════════════
   PCI Class → DeviceClass Mapping
   ═══════════════════════════════════════════════════════════════════════ */

static DeviceClass pci_class_to_dev_class(unsigned int class_code)
{
    unsigned int base_class = (class_code >> 16) & 0xFF;
    unsigned int sub_class = (class_code >> 8) & 0xFF;

    switch (base_class) {
    case PCI_CLASS_DISPLAY:
        return DEV_CLASS_GPU;
    case PCI_CLASS_NETWORK:
        if (sub_class == 0x80) return DEV_CLASS_WIRELESS;
        return DEV_CLASS_NETWORK;
    case PCI_CLASS_MULTIMEDIA:
        return DEV_CLASS_AUDIO;
    case PCI_CLASS_STORAGE:
        return DEV_CLASS_STORAGE;
    case PCI_CLASS_BRIDGE:
        return DEV_CLASS_BRIDGE;
    case PCI_CLASS_MEMORY:
        return DEV_CLASS_MEMORY;
    case PCI_CLASS_SERIAL_BUS:
        return DEV_CLASS_USB_CONTROLLER;
    case PCI_CLASS_WIRELESS:
        return DEV_CLASS_WIRELESS;
    default:
        return DEV_CLASS_OTHER;
    }
}

/* ═══════════════════════════════════════════════════════════════════════
   Hardware Enumeration via sysfs
   ═══════════════════════════════════════════════════════════════════════ */

static int enumerate_pci_devices(void)
{
    DIR *dir;
    struct dirent *ent;
    char path[MAX_PATH];

    dir = opendir(SYSFS_PCI);
    if (!dir) {
        fprintf(stderr, "%s: Cannot read %s: %s\n",
                PROGRAM_NAME, SYSFS_PCI, strerror(errno));
        return -1;
    }

    while ((ent = readdir(dir)) != NULL && g_device_count < MAX_DEVICES) {
        if (ent->d_name[0] == '.') continue;

        HardwareDevice *dev = &g_devices[g_device_count];
        memset(dev, 0, sizeof(*dev));

        strncpy(dev->pci_slot, ent->d_name, sizeof(dev->pci_slot) - 1);

        /* Read vendor ID */
        snprintf(path, sizeof(path), "%s/%s/vendor", SYSFS_PCI, ent->d_name);
        dev->vendor_id = read_sysfs_hex(path);

        /* Read device ID */
        snprintf(path, sizeof(path), "%s/%s/device", SYSFS_PCI, ent->d_name);
        dev->device_id = read_sysfs_hex(path);

        /* Read class code */
        snprintf(path, sizeof(path), "%s/%s/class", SYSFS_PCI, ent->d_name);
        dev->class_code = read_sysfs_hex(path);

        /* Skip invalid entries */
        if (dev->vendor_id == 0 && dev->device_id == 0) continue;

        /* Determine device class */
        dev->dev_class = pci_class_to_dev_class(dev->class_code);

        /* Resolve names */
        resolve_vendor_name(dev->vendor_id, dev->vendor_name,
                            sizeof(dev->vendor_name));
        resolve_device_name(dev->pci_slot, dev->vendor_id, dev->device_id,
                            dev->device_name, sizeof(dev->device_name));

        /* Check current driver */
        snprintf(path, sizeof(path), "%s/%s/driver", SYSFS_PCI, ent->d_name);
        if (file_exists(path)) {
            char link_target[MAX_PATH];
            ssize_t len = readlink(path, link_target, sizeof(link_target) - 1);
            if (len > 0) {
                link_target[len] = '\0';
                char *name = strrchr(link_target, '/');
                if (name)
                    strncpy(dev->current_driver, name + 1,
                            sizeof(dev->current_driver) - 1);
                else
                    strncpy(dev->current_driver, link_target,
                            sizeof(dev->current_driver) - 1);
                dev->status = DRIVER_STATUS_KERNEL;
            }
        }

        /* Check for firmware */
        snprintf(path, sizeof(path), "%s/%s/firmware_node",
                 SYSFS_PCI, ent->d_name);
        if (file_exists(path) && dev->status == DRIVER_STATUS_KERNEL)
            dev->status = DRIVER_STATUS_FIRMWARE;

        g_device_count++;
    }

    closedir(dir);
    LOG_INFO("Enumerated %d PCI devices", g_device_count);
    return g_device_count;
}

/* ═══════════════════════════════════════════════════════════════════════
   Known Driver Database — Built-in + MySQL extension
   ═══════════════════════════════════════════════════════════════════════ */

/*
 * Populate the built-in driver knowledge. This covers the major
 * vendors and maps hardware IDs to recommended driver packages.
 * The MySQL database extends this with user additions and version tracking.
 */
static void populate_builtin_drivers(void)
{
    DriverEntry *d;

    /* ─── NVIDIA GPUs ─── */
    d = &g_drivers[g_driver_count++];
    snprintf(d->name, sizeof(d->name), "nvidia-driver");
    snprintf(d->version, sizeof(d->version), "560.35.03");
    snprintf(d->url, sizeof(d->url), "%s560.35.03/NVIDIA-Linux-x86_64-560.35.03.run", URL_NVIDIA_DRIVER);
    snprintf(d->description, sizeof(d->description),
             "NVIDIA proprietary driver (GeForce RTX 40/50 series, RTX 30, GTX 16+)");
    snprintf(d->vendor, sizeof(d->vendor), "NVIDIA");
    d->target_class = DEV_CLASS_GPU;
    d->vendor_id = VENDOR_NVIDIA;
    d->device_id_min = 0x2200; /* RTX 40 series start */
    d->device_id_max = 0x2FFF;
    d->priority = 90;

    d = &g_drivers[g_driver_count++];
    snprintf(d->name, sizeof(d->name), "nvidia-open");
    snprintf(d->version, sizeof(d->version), "560.35.03");
    snprintf(d->url, sizeof(d->url),
             "https://github.com/NVIDIA/open-gpu-kernel-modules/archive/refs/tags/560.35.03.tar.gz");
    snprintf(d->description, sizeof(d->description),
             "NVIDIA open kernel modules (Turing+ GPUs, GPL-2.0/MIT)");
    snprintf(d->vendor, sizeof(d->vendor), "NVIDIA");
    d->target_class = DEV_CLASS_GPU;
    d->vendor_id = VENDOR_NVIDIA;
    d->device_id_min = 0x1E00; /* Turing start */
    d->device_id_max = 0x2FFF;
    d->priority = 85;

    d = &g_drivers[g_driver_count++];
    snprintf(d->name, sizeof(d->name), "nouveau");
    snprintf(d->version, sizeof(d->version), "kernel-builtin");
    snprintf(d->url, sizeof(d->url), "%s/nouveau", URL_KERNEL_DRM);
    snprintf(d->description, sizeof(d->description),
             "Nouveau — open-source NVIDIA driver (in-tree, limited perf)");
    snprintf(d->vendor, sizeof(d->vendor), "NVIDIA");
    d->target_class = DEV_CLASS_GPU;
    d->vendor_id = VENDOR_NVIDIA;
    d->device_id_min = 0x0000;
    d->device_id_max = 0xFFFF;
    d->priority = 30;

    /* ─── AMD GPUs ─── */
    d = &g_drivers[g_driver_count++];
    snprintf(d->name, sizeof(d->name), "amdgpu");
    snprintf(d->version, sizeof(d->version), "kernel-builtin");
    snprintf(d->url, sizeof(d->url), "%s/amd", URL_KERNEL_DRM);
    snprintf(d->description, sizeof(d->description),
             "AMDGPU — in-tree kernel driver (GCN 1.2+, RDNA, RDNA2/3/4)");
    snprintf(d->vendor, sizeof(d->vendor), "AMD");
    d->target_class = DEV_CLASS_GPU;
    d->vendor_id = VENDOR_AMD;
    d->device_id_min = 0x6600; /* GCN 1.2+ */
    d->device_id_max = 0xFFFF;
    d->priority = 80;

    d = &g_drivers[g_driver_count++];
    snprintf(d->name, sizeof(d->name), "amdgpu-firmware");
    snprintf(d->version, sizeof(d->version), "20240811");
    snprintf(d->url, sizeof(d->url), "%s", URL_AMD_FIRMWARE);
    snprintf(d->description, sizeof(d->description),
             "AMDGPU firmware blobs (required for RDNA2/3/4, updated monthly)");
    snprintf(d->vendor, sizeof(d->vendor), "AMD");
    d->target_class = DEV_CLASS_GPU;
    d->vendor_id = VENDOR_AMD;
    d->device_id_min = 0x7300; /* RDNA2+ */
    d->device_id_max = 0xFFFF;
    d->priority = 85;

    d = &g_drivers[g_driver_count++];
    snprintf(d->name, sizeof(d->name), "mesa");
    snprintf(d->version, sizeof(d->version), "24.2.1");
    snprintf(d->url, sizeof(d->url), "%smesa-24.2.1.tar.xz", URL_MESA_RELEASES);
    snprintf(d->description, sizeof(d->description),
             "Mesa 3D — userspace OpenGL/Vulkan (RadeonSI, RADV, ANV, Zink)");
    snprintf(d->vendor, sizeof(d->vendor), "Mesa");
    d->target_class = DEV_CLASS_GPU;
    d->vendor_id = 0; /* Multi-vendor */
    d->device_id_min = 0;
    d->device_id_max = 0xFFFF;
    d->priority = 75;

    /* ─── Intel GPUs ─── */
    d = &g_drivers[g_driver_count++];
    snprintf(d->name, sizeof(d->name), "i915");
    snprintf(d->version, sizeof(d->version), "kernel-builtin");
    snprintf(d->url, sizeof(d->url), "%s/i915", URL_KERNEL_DRM);
    snprintf(d->description, sizeof(d->description),
             "Intel i915 — in-tree driver (Gen 4 through Meteor Lake)");
    snprintf(d->vendor, sizeof(d->vendor), "Intel");
    d->target_class = DEV_CLASS_GPU;
    d->vendor_id = VENDOR_INTEL;
    d->device_id_min = 0x0000;
    d->device_id_max = 0xFFFF;
    d->priority = 80;

    d = &g_drivers[g_driver_count++];
    snprintf(d->name, sizeof(d->name), "xe");
    snprintf(d->version, sizeof(d->version), "kernel-6.8+");
    snprintf(d->url, sizeof(d->url), "%s/xe", URL_KERNEL_DRM);
    snprintf(d->description, sizeof(d->description),
             "Intel Xe — next-gen driver (Lunar Lake+, Arc, Battlemage)");
    snprintf(d->vendor, sizeof(d->vendor), "Intel");
    d->target_class = DEV_CLASS_GPU;
    d->vendor_id = VENDOR_INTEL;
    d->device_id_min = 0x5690; /* Arc Alchemist */
    d->device_id_max = 0xFFFF;
    d->priority = 85;

    d = &g_drivers[g_driver_count++];
    snprintf(d->name, sizeof(d->name), "i915-firmware");
    snprintf(d->version, sizeof(d->version), "20240811");
    snprintf(d->url, sizeof(d->url), "%s", URL_INTEL_FIRMWARE);
    snprintf(d->description, sizeof(d->description),
             "Intel GPU firmware (GuC, HuC, DMC — required for Gen12+)");
    snprintf(d->vendor, sizeof(d->vendor), "Intel");
    d->target_class = DEV_CLASS_GPU;
    d->vendor_id = VENDOR_INTEL;
    d->device_id_min = 0x4C00; /* Gen12+ */
    d->device_id_max = 0xFFFF;
    d->priority = 82;

    /* ─── Network: Realtek ─── */
    d = &g_drivers[g_driver_count++];
    snprintf(d->name, sizeof(d->name), "r8169");
    snprintf(d->version, sizeof(d->version), "kernel-builtin");
    snprintf(d->url, sizeof(d->url), "%s/ethernet/realtek", URL_KERNEL_NET);
    snprintf(d->description, sizeof(d->description),
             "Realtek 8169/8168/8125 Gigabit/2.5G Ethernet (in-tree)");
    snprintf(d->vendor, sizeof(d->vendor), "Realtek");
    d->target_class = DEV_CLASS_NETWORK;
    d->vendor_id = VENDOR_REALTEK;
    d->device_id_min = 0x8168;
    d->device_id_max = 0x8168;
    d->priority = 80;

    d = &g_drivers[g_driver_count++];
    snprintf(d->name, sizeof(d->name), "r8125");
    snprintf(d->version, sizeof(d->version), "9.013.02");
    snprintf(d->url, sizeof(d->url),
             "https://github.com/realtek-semiconductor/r8125/archive/refs/tags/9.013.02.tar.gz");
    snprintf(d->description, sizeof(d->description),
             "Realtek RTL8125/8126 2.5G/5G Ethernet (vendor, newer boards)");
    snprintf(d->vendor, sizeof(d->vendor), "Realtek");
    d->target_class = DEV_CLASS_NETWORK;
    d->vendor_id = VENDOR_REALTEK;
    d->device_id_min = 0x8125;
    d->device_id_max = 0x8126;
    d->priority = 85;

    /* ─── Network: Intel ─── */
    d = &g_drivers[g_driver_count++];
    snprintf(d->name, sizeof(d->name), "e1000e");
    snprintf(d->version, sizeof(d->version), "kernel-builtin");
    snprintf(d->url, sizeof(d->url), "%s/ethernet/intel", URL_KERNEL_NET);
    snprintf(d->description, sizeof(d->description),
             "Intel PRO/1000 Ethernet — i219/i218/i217 (in-tree)");
    snprintf(d->vendor, sizeof(d->vendor), "Intel");
    d->target_class = DEV_CLASS_NETWORK;
    d->vendor_id = VENDOR_INTEL;
    d->device_id_min = 0x1500;
    d->device_id_max = 0x15FF;
    d->priority = 80;

    d = &g_drivers[g_driver_count++];
    snprintf(d->name, sizeof(d->name), "igc");
    snprintf(d->version, sizeof(d->version), "kernel-builtin");
    snprintf(d->url, sizeof(d->url), "%s/ethernet/intel", URL_KERNEL_NET);
    snprintf(d->description, sizeof(d->description),
             "Intel i225/i226 2.5G Ethernet (Alder/Raptor/Meteor Lake)");
    snprintf(d->vendor, sizeof(d->vendor), "Intel");
    d->target_class = DEV_CLASS_NETWORK;
    d->vendor_id = VENDOR_INTEL;
    d->device_id_min = 0x15F2;
    d->device_id_max = 0x15FC;
    d->priority = 85;

    /* ─── Wireless: Intel WiFi ─── */
    d = &g_drivers[g_driver_count++];
    snprintf(d->name, sizeof(d->name), "iwlwifi");
    snprintf(d->version, sizeof(d->version), "kernel-builtin");
    snprintf(d->url, sizeof(d->url),
             "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/iwlwifi");
    snprintf(d->description, sizeof(d->description),
             "Intel WiFi 6/6E/7 (AX200/AX210/AX411/BE200) firmware + driver");
    snprintf(d->vendor, sizeof(d->vendor), "Intel");
    d->target_class = DEV_CLASS_WIRELESS;
    d->vendor_id = VENDOR_INTEL;
    d->device_id_min = 0x2720;
    d->device_id_max = 0x7AF0;
    d->priority = 85;

    /* ─── Wireless: MediaTek ─── */
    d = &g_drivers[g_driver_count++];
    snprintf(d->name, sizeof(d->name), "mt76");
    snprintf(d->version, sizeof(d->version), "kernel-builtin");
    snprintf(d->url, sizeof(d->url),
             "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/mediatek");
    snprintf(d->description, sizeof(d->description),
             "MediaTek MT7921/MT7922/MT7925 WiFi 6/6E/7 (in-tree + firmware)");
    snprintf(d->vendor, sizeof(d->vendor), "MediaTek");
    d->target_class = DEV_CLASS_WIRELESS;
    d->vendor_id = VENDOR_MEDIATEK;
    d->device_id_min = 0x7902;
    d->device_id_max = 0x7925;
    d->priority = 80;

    /* ─── Wireless: Qualcomm/Atheros ─── */
    d = &g_drivers[g_driver_count++];
    snprintf(d->name, sizeof(d->name), "ath12k");
    snprintf(d->version, sizeof(d->version), "kernel-6.4+");
    snprintf(d->url, sizeof(d->url),
             "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/ath12k");
    snprintf(d->description, sizeof(d->description),
             "Qualcomm WiFi 7 (WCN7850/QCN9274) — ath12k driver + firmware");
    snprintf(d->vendor, sizeof(d->vendor), "Qualcomm");
    d->target_class = DEV_CLASS_WIRELESS;
    d->vendor_id = VENDOR_QUALCOMM;
    d->device_id_min = 0x1107;
    d->device_id_max = 0x1107;
    d->priority = 85;

    /* ─── Audio: Intel HDA ─── */
    d = &g_drivers[g_driver_count++];
    snprintf(d->name, sizeof(d->name), "snd-hda-intel");
    snprintf(d->version, sizeof(d->version), "kernel-builtin");
    snprintf(d->url, sizeof(d->url), "%s/pci/hda", URL_KERNEL_SOUND);
    snprintf(d->description, sizeof(d->description),
             "Intel HD Audio — covers Realtek ALC, Conexant, Cirrus codecs");
    snprintf(d->vendor, sizeof(d->vendor), "Intel");
    d->target_class = DEV_CLASS_AUDIO;
    d->vendor_id = VENDOR_INTEL;
    d->device_id_min = 0x0000;
    d->device_id_max = 0xFFFF;
    d->priority = 80;

    /* ─── Storage: NVMe ─── */
    d = &g_drivers[g_driver_count++];
    snprintf(d->name, sizeof(d->name), "nvme");
    snprintf(d->version, sizeof(d->version), "kernel-builtin");
    snprintf(d->url, sizeof(d->url),
             "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/nvme");
    snprintf(d->description, sizeof(d->description),
             "NVMe — native kernel driver for PCIe SSDs (Samsung, WD, Micron, SK Hynix)");
    snprintf(d->vendor, sizeof(d->vendor), "Generic");
    d->target_class = DEV_CLASS_STORAGE;
    d->vendor_id = 0; /* Multi-vendor */
    d->device_id_min = 0;
    d->device_id_max = 0xFFFF;
    d->priority = 90;

    /* ─── Broadcom Network ─── */
    d = &g_drivers[g_driver_count++];
    snprintf(d->name, sizeof(d->name), "bnxt_en");
    snprintf(d->version, sizeof(d->version), "kernel-builtin");
    snprintf(d->url, sizeof(d->url), "%s/ethernet/broadcom", URL_KERNEL_NET);
    snprintf(d->description, sizeof(d->description),
             "Broadcom NetXtreme-E/C 10/25/50/100G Ethernet");
    snprintf(d->vendor, sizeof(d->vendor), "Broadcom");
    d->target_class = DEV_CLASS_NETWORK;
    d->vendor_id = VENDOR_BROADCOM;
    d->device_id_min = 0x1600;
    d->device_id_max = 0x16FF;
    d->priority = 85;

    /* ─── Mellanox/NVIDIA ConnectX ─── */
    d = &g_drivers[g_driver_count++];
    snprintf(d->name, sizeof(d->name), "mlx5_core");
    snprintf(d->version, sizeof(d->version), "kernel-builtin");
    snprintf(d->url, sizeof(d->url), "%s/ethernet/mellanox", URL_KERNEL_NET);
    snprintf(d->description, sizeof(d->description),
             "Mellanox ConnectX-5/6/7 10/25/100/200/400G Ethernet + InfiniBand");
    snprintf(d->vendor, sizeof(d->vendor), "Mellanox");
    d->target_class = DEV_CLASS_NETWORK;
    d->vendor_id = VENDOR_MELLANOX;
    d->device_id_min = 0x1013;
    d->device_id_max = 0x1023;
    d->priority = 90;

    /* ─── Linux-firmware (catchall) ─── */
    d = &g_drivers[g_driver_count++];
    snprintf(d->name, sizeof(d->name), "linux-firmware");
    snprintf(d->version, sizeof(d->version), "20240811");
    snprintf(d->url, sizeof(d->url),
             "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-20240811.tar.gz");
    snprintf(d->description, sizeof(d->description),
             "Linux firmware collection — all vendor blobs (kernel.org)");
    snprintf(d->vendor, sizeof(d->vendor), "kernel.org");
    d->target_class = DEV_CLASS_OTHER;
    d->vendor_id = 0;
    d->device_id_min = 0;
    d->device_id_max = 0xFFFF;
    d->priority = 50;

    LOG_INFO("Populated %d built-in driver entries", g_driver_count);
}

/* ═══════════════════════════════════════════════════════════════════════
   Driver Matching — Find best driver for a device
   ═══════════════════════════════════════════════════════════════════════ */

static const DriverEntry *find_best_driver(const HardwareDevice *dev)
{
    const DriverEntry *best = NULL;
    int best_priority = -1;

    for (int i = 0; i < g_driver_count; i++) {
        const DriverEntry *drv = &g_drivers[i];

        /* Class must match */
        if (drv->target_class != dev->dev_class && drv->target_class != DEV_CLASS_OTHER)
            continue;

        /* Vendor must match (0 = multi-vendor / catchall) */
        if (drv->vendor_id != 0 && drv->vendor_id != dev->vendor_id)
            continue;

        /* Device ID range check (0-0xFFFF = all devices from this vendor) */
        if (drv->vendor_id != 0) {
            if (dev->device_id < drv->device_id_min || dev->device_id > drv->device_id_max)
                continue;
        }

        /* Pick highest priority */
        if (drv->priority > best_priority) {
            best = drv;
            best_priority = drv->priority;
        }
    }

    return best;
}

/* ═══════════════════════════════════════════════════════════════════════
   ClamAV Malware Scanning
   ═══════════════════════════════════════════════════════════════════════ */

/*
 * Scan a file with ClamAV. Returns:
 *   0 = clean
 *   1 = infected (malware found)
 *  -1 = scan failed (ClamAV not available)
 */
static int clamscan_file(const char *filepath, char *detail, size_t detail_len)
{
    char cmd[MAX_CMD];
    char output[4096];
    int ret;

    if (!file_exists("/usr/bin/clamscan") && !file_exists("/usr/local/bin/clamscan")) {
        snprintf(detail, detail_len, "ClamAV not installed");
        LOG_WARN("ClamAV not found — cannot scan %s", filepath);
        return -1;
    }

    snprintf(cmd, sizeof(cmd),
             "clamscan --no-summary --infected '%s' 2>&1", filepath);
    ret = run_command(cmd, output, sizeof(output));

    if (WIFEXITED(ret)) {
        int exit_code = WEXITSTATUS(ret);
        switch (exit_code) {
        case 0:
            snprintf(detail, detail_len, "CLEAN — no threats detected");
            LOG_INFO("Scan CLEAN: %s", filepath);
            return 0;
        case 1:
            snprintf(detail, detail_len, "INFECTED: %s", output);
            LOG_ERROR("Scan INFECTED: %s — %s", filepath, output);
            return 1;
        default:
            snprintf(detail, detail_len, "Scan error (exit %d): %s",
                     exit_code, output);
            LOG_ERROR("Scan FAILED: %s (exit %d)", filepath, exit_code);
            return -1;
        }
    }

    snprintf(detail, detail_len, "Scan process error");
    return -1;
}

/* ═══════════════════════════════════════════════════════════════════════
   Download — libcurl file fetcher
   ═══════════════════════════════════════════════════════════════════════ */

struct curl_write_data {
    FILE *fp;
    size_t total;
};

static size_t curl_write_cb(void *ptr, size_t size, size_t nmemb, void *userdata)
{
    struct curl_write_data *wd = (struct curl_write_data *)userdata;
    size_t written = fwrite(ptr, size, nmemb, wd->fp);
    wd->total += written;
    return written;
}

static int download_file(const char *url, const char *dest_path, size_t *out_size)
{
    CURL *curl;
    CURLcode res;
    struct curl_write_data wd = { .fp = NULL, .total = 0 };
    long http_code = 0;

    curl = curl_easy_init();
    if (!curl) {
        LOG_ERROR("curl_easy_init() failed");
        return -1;
    }

    wd.fp = fopen(dest_path, "wb");
    if (!wd.fp) {
        LOG_ERROR("Cannot create %s: %s", dest_path, strerror(errno));
        curl_easy_cleanup(curl);
        return -1;
    }

    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, curl_write_cb);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &wd);
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_TIMEOUT, (long)CURL_TIMEOUT);
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 1L);
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, 2L);
    curl_easy_setopt(curl, CURLOPT_USERAGENT, "driverctl/" VERSION);
    curl_easy_setopt(curl, CURLOPT_FAILONERROR, 1L);

    /* Progress bar for interactive use */
    if (isatty(STDOUT_FILENO))
        curl_easy_setopt(curl, CURLOPT_NOPROGRESS, 0L);

    res = curl_easy_perform(curl);
    fclose(wd.fp);

    if (res != CURLE_OK) {
        LOG_ERROR("Download failed: %s → %s", url, curl_easy_strerror(res));
        unlink(dest_path);
        curl_easy_cleanup(curl);
        return -1;
    }

    curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &http_code);
    curl_easy_cleanup(curl);

    if (http_code >= 400) {
        LOG_ERROR("HTTP %ld for %s", http_code, url);
        unlink(dest_path);
        return -1;
    }

    if (out_size) *out_size = wd.total;
    LOG_INFO("Downloaded %zu bytes: %s", wd.total, dest_path);
    return 0;
}

/* ═══════════════════════════════════════════════════════════════════════
   Driver Download + Scan + Install Pipeline
   ═══════════════════════════════════════════════════════════════════════ */

static int download_and_scan(const DriverEntry *drv, DownloadResult *result)
{
    char *filename;
    char dest[MAX_PATH];

    memset(result, 0, sizeof(*result));
    strncpy(result->url, drv->url, sizeof(result->url) - 1);

    /* Extract filename from URL */
    filename = strrchr(drv->url, '/');
    if (filename)
        filename++;
    else
        filename = "driver-package";

    snprintf(result->filename, sizeof(result->filename), "%s", filename);
    snprintf(dest, sizeof(dest), "%s/%s-%s-%s",
             DRIVER_CACHE, drv->vendor, drv->name, filename);
    strncpy(result->local_path, dest, sizeof(result->local_path) - 1);

    /* Ensure cache directory */
    ensure_dir(DRIVER_CACHE);

    /* Check if already cached */
    if (file_exists(dest)) {
        struct stat st;
        stat(dest, &st);
        result->size = (size_t)st.st_size;
        printf("  %s[cached]%s %s (%zu bytes)\n", C_DIM, C_RESET, dest, result->size);
    } else {
        printf("  Downloading: %s\n", drv->url);
        if (download_file(drv->url, dest, &result->size) != 0) {
            printf("  %s✗ Download failed%s\n", C_RED, C_RESET);
            result->scan_result = -1;
            snprintf(result->scan_detail, sizeof(result->scan_detail),
                     "Download failed");
            return -1;
        }
        printf("  %s✓%s Downloaded %zu bytes\n", C_GREEN, C_RESET, result->size);
    }

    /* ClamAV scan */
    printf("  Scanning with ClamAV...\n");
    result->scan_result = clamscan_file(dest, result->scan_detail,
                                         sizeof(result->scan_detail));

    if (result->scan_result == 0) {
        printf("  %s✓ CLEAN%s — %s\n", C_GREEN, C_RESET, result->scan_detail);
    } else if (result->scan_result == 1) {
        printf("  %s✗ INFECTED%s — %s\n", C_RED, C_RESET, result->scan_detail);
        printf("  %sDriver package REJECTED. Not installing.%s\n", C_RED, C_RESET);
        unlink(dest); /* Remove infected file */
        return -1;
    } else {
        printf("  %s⚠ Scan unavailable%s — %s\n", C_YELLOW, C_RESET,
               result->scan_detail);
        printf("  Proceeding with caution (ClamAV not available).\n");
    }

    return 0;
}

/*
 * Install a driver package. Method depends on package type:
 *   .run       → Execute with --silent
 *   .tar.gz    → Extract, make, make install
 *   .deb       → dpkg -i
 *   kernel-*   → modprobe (already in-tree)
 *   firmware   → Copy to /lib/firmware/
 */
static int install_driver(const DriverEntry *drv, const DownloadResult *dl)
{
    char cmd[MAX_CMD];
    int ret;

    printf("  Installing %s v%s...\n", drv->name, drv->version);

    /* In-tree kernel driver — just modprobe */
    if (strncmp(drv->version, "kernel", 6) == 0) {
        snprintf(cmd, sizeof(cmd), "modprobe %s 2>&1", drv->name);
        ret = run_command(cmd, NULL, 0);
        if (WIFEXITED(ret) && WEXITSTATUS(ret) == 0) {
            printf("  %s✓%s Module '%s' loaded successfully\n",
                   C_GREEN, C_RESET, drv->name);
            return 0;
        }
        printf("  %s⚠%s modprobe %s failed (may need kernel rebuild)\n",
               C_YELLOW, C_RESET, drv->name);
        return -1;
    }

    /* NVIDIA .run installer */
    if (strstr(dl->filename, ".run")) {
        printf("  Running NVIDIA installer (silent mode)...\n");
        snprintf(cmd, sizeof(cmd),
                 "chmod +x '%s' && '%s' --silent --no-questions 2>&1",
                 dl->local_path, dl->local_path);
        ret = run_command(cmd, NULL, 0);
        if (WIFEXITED(ret) && WEXITSTATUS(ret) == 0) {
            printf("  %s✓%s NVIDIA driver installed\n", C_GREEN, C_RESET);
            return 0;
        }
        printf("  %s✗%s NVIDIA installer failed (check dkms, headers)\n",
               C_RED, C_RESET);
        return -1;
    }

    /* Tarball — extract and build */
    if (strstr(dl->filename, ".tar.gz") || strstr(dl->filename, ".tar.xz")) {
        char extract_dir[MAX_PATH];
        snprintf(extract_dir, sizeof(extract_dir), "%s/build-%s",
                 DRIVER_CACHE, drv->name);
        ensure_dir(extract_dir);

        snprintf(cmd, sizeof(cmd),
                 "tar -xf '%s' -C '%s' --strip-components=1 2>&1",
                 dl->local_path, extract_dir);
        ret = run_command(cmd, NULL, 0);
        if (WIFEXITED(ret) && WEXITSTATUS(ret) != 0) {
            printf("  %s✗%s Extract failed\n", C_RED, C_RESET);
            return -1;
        }

        /* Check for Makefile or meson.build */
        char makefile[MAX_PATH];
        snprintf(makefile, sizeof(makefile), "%s/Makefile", extract_dir);
        if (file_exists(makefile)) {
            snprintf(cmd, sizeof(cmd),
                     "cd '%s' && make -j$(nproc) && make install 2>&1",
                     extract_dir);
        } else {
            char meson[MAX_PATH];
            snprintf(meson, sizeof(meson), "%s/meson.build", extract_dir);
            if (file_exists(meson)) {
                snprintf(cmd, sizeof(cmd),
                         "cd '%s' && meson setup build --prefix=/usr "
                         "&& ninja -C build && ninja -C build install 2>&1",
                         extract_dir);
            } else {
                printf("  %s⚠%s No build system found — manual install required\n",
                       C_YELLOW, C_RESET);
                printf("  Source extracted to: %s\n", extract_dir);
                return 0;
            }
        }

        printf("  Building (this may take a while)...\n");
        ret = run_command(cmd, NULL, 0);
        if (WIFEXITED(ret) && WEXITSTATUS(ret) == 0) {
            printf("  %s✓%s Built and installed successfully\n", C_GREEN, C_RESET);
            return 0;
        }
        printf("  %s✗%s Build failed — check %s for details\n",
               C_RED, C_RESET, extract_dir);
        return -1;
    }

    /* Firmware blobs — copy to /lib/firmware/ */
    if (strstr(drv->name, "firmware")) {
        printf("  Installing firmware to /lib/firmware/...\n");
        snprintf(cmd, sizeof(cmd),
                 "cp -rv '%s' /lib/firmware/ 2>&1 && depmod -a 2>&1",
                 dl->local_path);
        ret = run_command(cmd, NULL, 0);
        if (WIFEXITED(ret) && WEXITSTATUS(ret) == 0) {
            printf("  %s✓%s Firmware installed, modules reloaded\n",
                   C_GREEN, C_RESET);
            return 0;
        }
        printf("  %s⚠%s Firmware install may need manual extraction\n",
               C_YELLOW, C_RESET);
        return -1;
    }

    printf("  %s⚠%s Unknown package format — cached at: %s\n",
           C_YELLOW, C_RESET, dl->local_path);
    return 0;
}

/* ═══════════════════════════════════════════════════════════════════════
   MySQL Database — Version Tracking and History
   ═══════════════════════════════════════════════════════════════════════ */

static MYSQL *db_connect(void)
{
    MYSQL *conn = mysql_init(NULL);
    if (!conn) return NULL;

    if (!mysql_real_connect(conn, DB_HOST, DB_USER, DB_PASS,
                            DB_NAME, DB_PORT, NULL, 0)) {
        /* Try without database (first run) */
        if (!mysql_real_connect(conn, DB_HOST, DB_USER, DB_PASS,
                                NULL, DB_PORT, NULL, 0)) {
            mysql_close(conn);
            return NULL;
        }
        /* Create database */
        mysql_query(conn, "CREATE DATABASE IF NOT EXISTS " DB_NAME);
        mysql_select_db(conn, DB_NAME);
    }

    return conn;
}

static void db_create_schema(MYSQL *conn)
{
    const char *tables[] = {
        "CREATE TABLE IF NOT EXISTS devices ("
        "  id INT AUTO_INCREMENT PRIMARY KEY,"
        "  pci_slot VARCHAR(32) NOT NULL,"
        "  vendor_id INT UNSIGNED NOT NULL,"
        "  device_id INT UNSIGNED NOT NULL,"
        "  class_code INT UNSIGNED NOT NULL,"
        "  dev_class VARCHAR(32),"
        "  vendor_name VARCHAR(255),"
        "  device_name VARCHAR(255),"
        "  current_driver VARCHAR(128),"
        "  last_scan DATETIME DEFAULT CURRENT_TIMESTAMP,"
        "  UNIQUE KEY idx_slot (pci_slot)"
        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",

        "CREATE TABLE IF NOT EXISTS installed_drivers ("
        "  id INT AUTO_INCREMENT PRIMARY KEY,"
        "  device_pci_slot VARCHAR(32),"
        "  driver_name VARCHAR(128) NOT NULL,"
        "  driver_version VARCHAR(64),"
        "  vendor VARCHAR(64),"
        "  install_date DATETIME DEFAULT CURRENT_TIMESTAMP,"
        "  install_method VARCHAR(32),"
        "  scan_result VARCHAR(32),"
        "  source_url TEXT,"
        "  KEY idx_device (device_pci_slot)"
        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",

        "CREATE TABLE IF NOT EXISTS available_updates ("
        "  id INT AUTO_INCREMENT PRIMARY KEY,"
        "  driver_name VARCHAR(128) NOT NULL,"
        "  current_version VARCHAR(64),"
        "  new_version VARCHAR(64),"
        "  source_url TEXT,"
        "  discovered DATETIME DEFAULT CURRENT_TIMESTAMP,"
        "  applied TINYINT DEFAULT 0,"
        "  UNIQUE KEY idx_driver_ver (driver_name, new_version)"
        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",

        "CREATE TABLE IF NOT EXISTS source_repos ("
        "  id INT AUTO_INCREMENT PRIMARY KEY,"
        "  name VARCHAR(128) NOT NULL,"
        "  url TEXT NOT NULL,"
        "  repo_type VARCHAR(32),"
        "  last_checked DATETIME,"
        "  last_version VARCHAR(64),"
        "  description TEXT"
        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",

        NULL
    };

    for (int i = 0; tables[i]; i++)
        mysql_query(conn, tables[i]);
}

static void db_record_device(MYSQL *conn, const HardwareDevice *dev)
{
    char query[2048];
    snprintf(query, sizeof(query),
             "INSERT INTO devices (pci_slot, vendor_id, device_id, class_code, "
             "dev_class, vendor_name, device_name, current_driver, last_scan) "
             "VALUES ('%s', %u, %u, %u, '%s', '%s', '%s', '%s', NOW()) "
             "ON DUPLICATE KEY UPDATE current_driver='%s', last_scan=NOW()",
             dev->pci_slot, dev->vendor_id, dev->device_id, dev->class_code,
             device_class_names[dev->dev_class],
             dev->vendor_name, dev->device_name,
             dev->current_driver, dev->current_driver);
    mysql_query(conn, query);
}

static void db_record_install(MYSQL *conn, const char *pci_slot,
                              const DriverEntry *drv, const char *scan_result)
{
    char query[2048];
    snprintf(query, sizeof(query),
             "INSERT INTO installed_drivers (device_pci_slot, driver_name, "
             "driver_version, vendor, install_method, scan_result, source_url) "
             "VALUES ('%s', '%s', '%s', '%s', 'driverctl', '%s', '%s')",
             pci_slot, drv->name, drv->version, drv->vendor,
             scan_result, drv->url);
    mysql_query(conn, query);
}

/* ═══════════════════════════════════════════════════════════════════════
   Kernel Source Tree Reference
   ═══════════════════════════════════════════════════════════════════════ */

typedef struct {
    const char *subsystem;
    const char *path;
    const char *description;
    const char *url;
} KernelTreeEntry;

static const KernelTreeEntry kernel_tree[] = {
    { "GPU/DRM",     "drivers/gpu/drm/",        "Direct Rendering Manager (all GPUs)",
      URL_KERNEL_DRM },
    { "GPU/NVIDIA",  "drivers/gpu/drm/nouveau/", "NVIDIA open-source (Nouveau)",
      "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/nouveau" },
    { "GPU/AMD",     "drivers/gpu/drm/amd/",    "AMD GPU (AMDGPU, DC, PM)",
      "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/amd" },
    { "GPU/Intel",   "drivers/gpu/drm/i915/",   "Intel i915 (Gen4-MeteorLake)",
      "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/i915" },
    { "GPU/Intel Xe","drivers/gpu/drm/xe/",     "Intel Xe (ArcA/Battlemage/LunarLake+)",
      "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/xe" },
    { "NET/Intel",   "drivers/net/ethernet/intel/", "Intel Ethernet (e1000e, igc, ice, ixgbe)",
      "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/intel" },
    { "NET/Realtek", "drivers/net/ethernet/realtek/", "Realtek Ethernet (r8169, r8168, r8125)",
      "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/realtek" },
    { "NET/Broadcom","drivers/net/ethernet/broadcom/","Broadcom Ethernet (bnxt, tg3, b44)",
      "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/broadcom" },
    { "NET/Mellanox","drivers/net/ethernet/mellanox/","Mellanox/NVIDIA ConnectX (mlx5, mlx4)",
      "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/mellanox" },
    { "WIFI/Intel",  "drivers/net/wireless/intel/", "Intel WiFi (iwlwifi, AX200/210/BE200)",
      "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/wireless/intel" },
    { "WIFI/MediaTek","drivers/net/wireless/mediatek/","MediaTek WiFi (mt76, MT7921/7922/7925)",
      "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/wireless/mediatek" },
    { "WIFI/QCA",    "drivers/net/wireless/ath/", "Qualcomm/Atheros (ath11k, ath12k, WiFi7)",
      "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/wireless/ath" },
    { "SOUND/HDA",   "sound/pci/hda/",          "Intel HD Audio (all codec families)",
      URL_KERNEL_SOUND "/pci/hda" },
    { "SOUND/SOF",   "sound/soc/sof/",          "Sound Open Firmware (modern laptops)",
      "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/sound/soc/sof" },
    { "NVME",        "drivers/nvme/",           "NVMe storage (host, target, multipath)",
      "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/nvme" },
    { "USB/xHCI",    "drivers/usb/host/",       "USB host controllers (xHCI, EHCI, OHCI)",
      "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/usb/host" },
    { "FIRMWARE",    "lib/firmware/",           "Linux-firmware repository (all vendors)",
      URL_LINUX_FIRMWARE },
    { NULL, NULL, NULL, NULL }
};

static void show_kernel_tree(void)
{
    printf("\n%s╔══════════════════════════════════════════════════════════════╗%s\n",
           C_BLUE, C_RESET);
    printf("%s║  KERNEL DEVICE TREE — Driver Source Reference                ║%s\n",
           C_BLUE, C_RESET);
    printf("%s╚══════════════════════════════════════════════════════════════╝%s\n\n",
           C_BLUE, C_RESET);

    printf("  %-14s %-35s %s\n", "Subsystem", "Kernel Path", "Description");
    printf("  %-14s %-35s %s\n",
           "──────────────", "───────────────────────────────────",
           "────────────────────────────────────────");

    for (int i = 0; kernel_tree[i].subsystem; i++) {
        printf("  %s%-14s%s %-35s %s%s%s\n",
               C_CYAN, kernel_tree[i].subsystem, C_RESET,
               kernel_tree[i].path,
               C_DIM, kernel_tree[i].description, C_RESET);
    }

    printf("\n  %sSource:%s %s\n", C_DIM, C_RESET,
           "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers");
    printf("  %sFirmware:%s %s\n", C_DIM, C_RESET, URL_LINUX_FIRMWARE);
    printf("  %sPCI IDs:%s %s\n\n", C_DIM, C_RESET, URL_PCIIDS);
}

/* ═══════════════════════════════════════════════════════════════════════
   Source Repository Display
   ═══════════════════════════════════════════════════════════════════════ */

static void show_sources(void)
{
    printf("\n%s╔══════════════════════════════════════════════════════════════╗%s\n",
           C_BLUE, C_RESET);
    printf("%s║  UPSTREAM DRIVER SOURCES                                     ║%s\n",
           C_BLUE, C_RESET);
    printf("%s╚══════════════════════════════════════════════════════════════╝%s\n\n",
           C_BLUE, C_RESET);

    printf("  %s── GPU ──%s\n", C_WHITE, C_RESET);
    printf("  NVIDIA proprietary : %s\n", URL_NVIDIA_DRIVER);
    printf("  NVIDIA open modules: https://github.com/NVIDIA/open-gpu-kernel-modules\n");
    printf("  AMD AMDGPU kernel  : %s\n", URL_AMD_FIRMWARE);
    printf("  Intel i915/Xe      : %s\n", URL_INTEL_FIRMWARE);
    printf("  Mesa (OpenGL/VK)   : %s\n", URL_MESA_RELEASES);
    printf("\n");

    printf("  %s── Network ──%s\n", C_WHITE, C_RESET);
    printf("  Linux kernel net/  : %s\n", URL_KERNEL_NET);
    printf("  Realtek r8125      : https://github.com/realtek-semiconductor/r8125\n");
    printf("  Intel ice/igc      : https://sourceforge.net/projects/e1000/\n");
    printf("\n");

    printf("  %s── WiFi ──%s\n", C_WHITE, C_RESET);
    printf("  Intel iwlwifi fw   : https://git.kernel.org/.../firmware/linux-firmware.git/tree/iwlwifi\n");
    printf("  MediaTek mt76      : https://git.kernel.org/.../firmware/linux-firmware.git/tree/mediatek\n");
    printf("  Qualcomm ath12k    : https://git.kernel.org/.../firmware/linux-firmware.git/tree/ath12k\n");
    printf("\n");

    printf("  %s── Firmware (all vendors) ──%s\n", C_WHITE, C_RESET);
    printf("  linux-firmware     : %s\n", URL_LINUX_FIRMWARE);
    printf("  PCI ID database    : %s\n", URL_PCIIDS);
    printf("\n");

    printf("  %s── Board/Chipset References ──%s\n", C_WHITE, C_RESET);
    printf("  Intel ARK          : https://ark.intel.com/\n");
    printf("  AMD Product Specs  : https://www.amd.com/en/products/specifications/\n");
    printf("  PCI SIG members    : https://pcisig.com/membership/member-companies\n");
    printf("\n");
}

/* ═══════════════════════════════════════════════════════════════════════
   Command: scan
   ═══════════════════════════════════════════════════════════════════════ */

static void cmd_scan(DeviceClass filter)
{
    printf("\n%s╔══════════════════════════════════════════════════════════════╗%s\n",
           C_BLUE, C_RESET);
    printf("%s║  HARDWARE SCAN — Driver Status Report                        ║%s\n",
           C_BLUE, C_RESET);
    printf("%s╚══════════════════════════════════════════════════════════════╝%s\n\n",
           C_BLUE, C_RESET);

    enumerate_pci_devices();
    populate_builtin_drivers();

    /* Connect to MySQL for recording */
    MYSQL *conn = db_connect();
    if (conn) db_create_schema(conn);

    int shown = 0;
    DeviceClass last_class = DEV_CLASS_COUNT;

    for (int i = 0; i < g_device_count; i++) {
        HardwareDevice *dev = &g_devices[i];

        /* Apply filter */
        if (filter != DEV_CLASS_COUNT && dev->dev_class != filter)
            continue;

        /* Skip bridges/chipsets unless explicitly requested */
        if (filter == DEV_CLASS_COUNT &&
            (dev->dev_class == DEV_CLASS_BRIDGE || dev->dev_class == DEV_CLASS_OTHER))
            continue;

        /* Print class header */
        if (dev->dev_class != last_class) {
            printf("  %s── %s ──%s\n", C_WHITE,
                   device_class_names[dev->dev_class], C_RESET);
            last_class = dev->dev_class;
        }

        /* Find recommended driver */
        const DriverEntry *recommended = find_best_driver(dev);
        if (recommended) {
            strncpy(dev->recommended_driver, recommended->name,
                    sizeof(dev->recommended_driver) - 1);
            strncpy(dev->recommended_url, recommended->url,
                    sizeof(dev->recommended_url) - 1);
            strncpy(dev->recommended_version, recommended->version,
                    sizeof(dev->recommended_version) - 1);

            /* Check if current driver matches recommended */
            if (dev->current_driver[0] &&
                strcmp(dev->current_driver, recommended->name) == 0)
                dev->status = DRIVER_STATUS_OPTIMAL;
            else if (dev->current_driver[0])
                dev->status = DRIVER_STATUS_OUTDATED;
        }

        /* Print device */
        printf("  %s[%s]%s %s%s%s\n",
               C_DIM, dev->pci_slot, C_RESET,
               C_WHITE, dev->device_name, C_RESET);
        printf("         Vendor: %s (0x%04X:0x%04X)\n",
               dev->vendor_name, dev->vendor_id, dev->device_id);
        printf("         Driver: %s%s%s",
               driver_status_colors[dev->status],
               dev->current_driver[0] ? dev->current_driver : "(none)",
               C_RESET);
        printf("  [%s%s%s]\n",
               driver_status_colors[dev->status],
               driver_status_names[dev->status], C_RESET);

        if (recommended && dev->status != DRIVER_STATUS_OPTIMAL) {
            printf("         %sRecommend: %s v%s%s\n",
                   C_GREEN, recommended->name, recommended->version, C_RESET);
        }
        printf("\n");

        /* Record in DB */
        if (conn) db_record_device(conn, dev);
        shown++;
    }

    if (conn) mysql_close(conn);

    printf("  %s─────────────────────────────────────────────────%s\n",
           C_DIM, C_RESET);
    printf("  %d device(s) shown. Use 'driverctl install <slot>' to install.\n\n",
           shown);
}

/* ═══════════════════════════════════════════════════════════════════════
   Command: install
   ═══════════════════════════════════════════════════════════════════════ */

static void cmd_install(const char *target)
{
    int install_all = (strcmp(target, "--all") == 0);
    int installed = 0;
    int failed = 0;

    enumerate_pci_devices();
    populate_builtin_drivers();

    printf("\n%s╔══════════════════════════════════════════════════════════════╗%s\n",
           C_BLUE, C_RESET);
    printf("%s║  DRIVER INSTALLATION — Download → Scan → Install             ║%s\n",
           C_BLUE, C_RESET);
    printf("%s╚══════════════════════════════════════════════════════════════╝%s\n\n",
           C_BLUE, C_RESET);

    MYSQL *conn = db_connect();
    if (conn) db_create_schema(conn);

    for (int i = 0; i < g_device_count; i++) {
        HardwareDevice *dev = &g_devices[i];

        /* Match target: --all, PCI slot, or vendor name */
        if (!install_all) {
            if (strcasecmp(target, dev->pci_slot) != 0 &&
                strcasestr(dev->device_name, target) == NULL &&
                strcasestr(dev->vendor_name, target) == NULL)
                continue;
        }

        /* Skip devices that already have optimal drivers */
        const DriverEntry *drv = find_best_driver(dev);
        if (!drv) continue;

        if (dev->current_driver[0] &&
            strcmp(dev->current_driver, drv->name) == 0) {
            if (install_all) continue; /* Skip optimal when doing --all */
            printf("  %s[%s]%s %s — already optimal (%s)\n",
                   C_DIM, dev->pci_slot, C_RESET,
                   dev->device_name, drv->name);
            continue;
        }

        printf("  %s[%s]%s %s\n", C_CYAN, dev->pci_slot, C_RESET,
               dev->device_name);
        printf("  Driver: %s v%s (%s)\n", drv->name, drv->version, drv->vendor);

        /* Download and scan */
        DownloadResult dl;
        if (download_and_scan(drv, &dl) != 0) {
            failed++;
            printf("\n");
            continue;
        }

        /* Install */
        if (install_driver(drv, &dl) == 0) {
            installed++;
            if (conn) {
                const char *scan_str = (dl.scan_result == 0) ? "CLEAN" :
                                       (dl.scan_result == -1) ? "UNAVAILABLE" : "INFECTED";
                db_record_install(conn, dev->pci_slot, drv, scan_str);
            }
        } else {
            failed++;
        }
        printf("\n");
    }

    if (conn) mysql_close(conn);

    printf("  %s─────────────────────────────────────────────────%s\n",
           C_DIM, C_RESET);
    printf("  Installed: %s%d%s  Failed: %s%d%s\n\n",
           C_GREEN, installed, C_RESET, failed ? C_RED : C_DIM, failed, C_RESET);
}

/* ═══════════════════════════════════════════════════════════════════════
   Command: update
   ═══════════════════════════════════════════════════════════════════════ */

static void cmd_update(int do_install)
{
    printf("\n%s╔══════════════════════════════════════════════════════════════╗%s\n",
           C_BLUE, C_RESET);
    printf("%s║  DRIVER UPDATE CHECK                                         ║%s\n",
           C_BLUE, C_RESET);
    printf("%s╚══════════════════════════════════════════════════════════════╝%s\n\n",
           C_BLUE, C_RESET);

    enumerate_pci_devices();
    populate_builtin_drivers();

    printf("  Checking upstream repositories for newer versions...\n\n");

    /*
     * In a full implementation, this would:
     * 1. Query linux-firmware git for latest tag
     * 2. Check NVIDIA download page for latest .run version
     * 3. Check Mesa release page for latest stable
     * 4. Compare against installed versions in MySQL
     *
     * For now, we report what we know from built-in entries.
     */

    int updates_found = 0;

    for (int i = 0; i < g_device_count; i++) {
        HardwareDevice *dev = &g_devices[i];
        const DriverEntry *drv = find_best_driver(dev);
        if (!drv) continue;

        /* If device has no driver or different driver, it's an "update" */
        if (!dev->current_driver[0] ||
            strcmp(dev->current_driver, drv->name) != 0) {
            printf("  %s[UPDATE]%s %s\n", C_YELLOW, C_RESET, dev->device_name);
            printf("           Current: %s\n",
                   dev->current_driver[0] ? dev->current_driver : "(none)");
            printf("           Available: %s v%s\n", drv->name, drv->version);
            printf("           Source: %s\n\n", drv->url);
            updates_found++;
        }
    }

    if (updates_found == 0) {
        printf("  %s✓ All devices have optimal drivers.%s\n\n", C_GREEN, C_RESET);
    } else {
        printf("  %d update(s) available.\n", updates_found);
        if (do_install) {
            printf("  Installing updates...\n\n");
            cmd_install("--all");
        } else {
            printf("  Run '%s update --install' to apply.\n\n", PROGRAM_NAME);
        }
    }
}

/* ═══════════════════════════════════════════════════════════════════════
   Command: status
   ═══════════════════════════════════════════════════════════════════════ */

static void cmd_status(void)
{
    printf("\n%s╔══════════════════════════════════════════════════════════════╗%s\n",
           C_BLUE, C_RESET);
    printf("%s║  DRIVERCTL STATUS                                            ║%s\n",
           C_BLUE, C_RESET);
    printf("%s╚══════════════════════════════════════════════════════════════╝%s\n\n",
           C_BLUE, C_RESET);

    /* Show loaded kernel modules relevant to drivers */
    printf("  %s── Loaded GPU Modules ──%s\n", C_WHITE, C_RESET);
    char output[4096];
    run_command("lsmod | grep -iE 'nvidia|amdgpu|i915|xe|nouveau|radeon' 2>/dev/null",
                output, sizeof(output));
    if (output[0])
        printf("  %s\n", output);
    else
        printf("  (none detected)\n\n");

    printf("  %s── Loaded Network Modules ──%s\n", C_WHITE, C_RESET);
    run_command("lsmod | grep -iE 'r8169|r8125|igc|e1000|ice|ixgbe|bnxt|mlx5' 2>/dev/null",
                output, sizeof(output));
    if (output[0])
        printf("  %s\n", output);
    else
        printf("  (none detected)\n\n");

    printf("  %s── Loaded WiFi Modules ──%s\n", C_WHITE, C_RESET);
    run_command("lsmod | grep -iE 'iwlwifi|mt76|ath1[12]k|brcmfmac|rtw8' 2>/dev/null",
                output, sizeof(output));
    if (output[0])
        printf("  %s\n", output);
    else
        printf("  (none detected)\n\n");

    printf("  %s── Firmware Directory ──%s\n", C_WHITE, C_RESET);
    run_command("ls /lib/firmware/ 2>/dev/null | wc -l", output, sizeof(output));
    printf("  /lib/firmware/: %s files\n", output);

    printf("  %s── ClamAV Status ──%s\n", C_WHITE, C_RESET);
    int ret = run_command("clamscan --version 2>/dev/null", output, sizeof(output));
    if (WIFEXITED(ret) && WEXITSTATUS(ret) == 0)
        printf("  %s%s%s\n", C_GREEN, output, C_RESET);
    else
        printf("  %sClamAV not available (driver scan disabled)%s\n\n",
               C_YELLOW, C_RESET);

    /* Database status */
    printf("  %s── Database ──%s\n", C_WHITE, C_RESET);
    MYSQL *conn = db_connect();
    if (conn) {
        MYSQL_RES *res;
        MYSQL_ROW row;
        mysql_query(conn, "SELECT COUNT(*) FROM installed_drivers");
        res = mysql_store_result(conn);
        if (res && (row = mysql_fetch_row(res))) {
            printf("  Installed drivers tracked: %s\n", row[0]);
            mysql_free_result(res);
        }
        mysql_query(conn, "SELECT COUNT(*) FROM devices");
        res = mysql_store_result(conn);
        if (res && (row = mysql_fetch_row(res))) {
            printf("  Known devices: %s\n", row[0]);
            mysql_free_result(res);
        }
        mysql_close(conn);
    } else {
        printf("  %sMySQL not connected (standalone mode)%s\n", C_DIM, C_RESET);
    }
    printf("\n");
}

/* ═══════════════════════════════════════════════════════════════════════
   Command: verify
   ═══════════════════════════════════════════════════════════════════════ */

static void cmd_verify(const char *filepath)
{
    char detail[512];
    int result;

    printf("\n  Scanning: %s\n", filepath);

    if (!file_exists(filepath)) {
        printf("  %s✗ File not found%s\n\n", C_RED, C_RESET);
        return;
    }

    result = clamscan_file(filepath, detail, sizeof(detail));
    if (result == 0)
        printf("  %s✓ CLEAN%s — %s\n\n", C_GREEN, C_RESET, detail);
    else if (result == 1)
        printf("  %s✗ INFECTED%s — %s\n\n", C_RED, C_RESET, detail);
    else
        printf("  %s⚠ SCAN UNAVAILABLE%s — %s\n\n", C_YELLOW, C_RESET, detail);
}

/* ═══════════════════════════════════════════════════════════════════════
   Main
   ═══════════════════════════════════════════════════════════════════════ */

static void usage(void)
{
    printf("\n");
    printf("  %sdriverctl%s — Hardware Driver Discovery, Scan & Installation Manager\n\n",
           C_WHITE, C_RESET);
    printf("  %sUsage:%s\n", C_CYAN, C_RESET);
    printf("    driverctl scan [--gpu|--net|--audio|--all]   Discover hardware\n");
    printf("    driverctl install <device|--all>             Download + scan + install\n");
    printf("    driverctl update [--install]                 Check for newer versions\n");
    printf("    driverctl status                             Show installed drivers\n");
    printf("    driverctl verify <file>                      ClamAV scan a package\n");
    printf("    driverctl sources                            Upstream repositories\n");
    printf("    driverctl tree                               Kernel device tree map\n");
    printf("    driverctl --help                             This help\n");
    printf("\n");
    printf("  %sExamples:%s\n", C_CYAN, C_RESET);
    printf("    driverctl scan                               # All relevant devices\n");
    printf("    driverctl scan --gpu                         # GPU only\n");
    printf("    driverctl install 0000:01:00.0               # By PCI slot\n");
    printf("    driverctl install nvidia                     # By vendor name\n");
    printf("    driverctl install --all                      # Best for everything\n");
    printf("    driverctl update --install                   # Update all\n");
    printf("\n");
    printf("  %sPipeline:%s  Discover → Download → ClamAV Scan → Install\n", C_DIM, C_RESET);
    printf("  %sDatabase:%s  MySQL (%s) tracks versions + history\n", C_DIM, C_RESET, DB_NAME);
    printf("  %sLog:%s       %s\n\n", C_DIM, C_RESET, DRIVER_LOG);
    printf("  Version %s — MEARVK LLC\n\n", VERSION);
}

int main(int argc, char *argv[])
{
    if (argc < 2) {
        usage();
        return 0;
    }

    log_open();
    curl_global_init(CURL_GLOBAL_ALL);

    const char *cmd = argv[1];

    /* --help */
    if (strcmp(cmd, "--help") == 0 || strcmp(cmd, "-h") == 0) {
        usage();
    }
    /* scan */
    else if (strcmp(cmd, "scan") == 0) {
        DeviceClass filter = DEV_CLASS_COUNT; /* show all relevant */
        if (argc > 2) {
            if (strcmp(argv[2], "--gpu") == 0)   filter = DEV_CLASS_GPU;
            else if (strcmp(argv[2], "--net") == 0) filter = DEV_CLASS_NETWORK;
            else if (strcmp(argv[2], "--audio") == 0) filter = DEV_CLASS_AUDIO;
            else if (strcmp(argv[2], "--wireless") == 0 ||
                     strcmp(argv[2], "--wifi") == 0) filter = DEV_CLASS_WIRELESS;
            else if (strcmp(argv[2], "--storage") == 0) filter = DEV_CLASS_STORAGE;
            else if (strcmp(argv[2], "--all") == 0) {
                /* Show everything including bridges */
                for (int c = 0; c < DEV_CLASS_COUNT; c++)
                    cmd_scan((DeviceClass)c);
                goto cleanup;
            }
        }
        cmd_scan(filter);
    }
    /* install */
    else if (strcmp(cmd, "install") == 0) {
        if (argc < 3) {
            fprintf(stderr, "%s: 'install' requires a target\n", PROGRAM_NAME);
            fprintf(stderr, "Usage: driverctl install <pci-slot|vendor|--all>\n");
            curl_global_cleanup();
            return 1;
        }
        cmd_install(argv[2]);
    }
    /* update */
    else if (strcmp(cmd, "update") == 0) {
        int do_install = 0;
        if (argc > 2 && strcmp(argv[2], "--install") == 0)
            do_install = 1;
        cmd_update(do_install);
    }
    /* status */
    else if (strcmp(cmd, "status") == 0) {
        cmd_status();
    }
    /* verify */
    else if (strcmp(cmd, "verify") == 0) {
        if (argc < 3) {
            fprintf(stderr, "%s: 'verify' requires a file path\n", PROGRAM_NAME);
            curl_global_cleanup();
            return 1;
        }
        cmd_verify(argv[2]);
    }
    /* sources */
    else if (strcmp(cmd, "sources") == 0) {
        show_sources();
    }
    /* tree */
    else if (strcmp(cmd, "tree") == 0) {
        show_kernel_tree();
    }
    /* verbose flag */
    else if (strcmp(cmd, "-v") == 0 || strcmp(cmd, "--verbose") == 0) {
        g_verbose = 1;
        if (argc > 2) {
            /* Re-dispatch with verbose */
            argv++;
            argc--;
            main(argc, argv);
        } else {
            usage();
        }
    }
    else {
        fprintf(stderr, "%s: Unknown command '%s'\n", PROGRAM_NAME, cmd);
        fprintf(stderr, "Run '%s --help' for usage.\n", PROGRAM_NAME);
        curl_global_cleanup();
        return 1;
    }

cleanup:
    curl_global_cleanup();
    if (g_logfile && g_logfile != stderr)
        fclose(g_logfile);

    return 0;
}
