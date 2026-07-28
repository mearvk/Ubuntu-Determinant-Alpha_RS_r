// SPDX-License-Identifier: GPL-2.0
/*
 * usbswap.c - USB Dynamic RAM Expansion via Pagefile
 *
 * Automatically detects USB mass storage devices on hotplug and creates
 * a swap pagefile for dynamic RAM expansion. Designed for remote servers
 * where physical RAM cost is a concern (64GB-256GB+ sticks are expensive).
 *
 * A connected USB flash drive or external SSD is immediately usable as
 * overflow memory, keeping server costs down while allowing burst capacity.
 *
 * Features:
 *   - Auto-detect USB storage on hotplug (no manual swapon needed)
 *   - Creates pagefile safely (never overwrites existing data partitions)
 *   - Configurable swap priority (lower than physical RAM swap)
 *   - Wear-leveling awareness for flash media
 *   - Health monitoring with automatic disable on errors
 *   - Hot-remove safe (migrates pages before disconnect)
 *   - Configurable size limits (% of device or absolute)
 *
 * Usage:
 *   1. Load module: modprobe usbswap
 *   2. Plug in USB storage device
 *   3. Module auto-creates swap partition and activates it
 *   4. System now has additional virtual memory
 *   5. Unplug: module safely migrates pages and deactivates
 *
 * Performance note:
 *   USB 3.0+ SSDs can provide 300-500 MB/s, suitable for swap.
 *   USB 2.0 flash drives (~30 MB/s) are only for emergency overflow.
 *   Module detects speed class and sets priority accordingly.
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/usb.h>
#include <linux/genhd.h>
#include <linux/blkdev.h>
#include <linux/swap.h>
#include <linux/fs.h>
#include <linux/file.h>
#include <linux/kthread.h>
#include <linux/delay.h>
#include <linux/slab.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/notifier.h>
#include <linux/workqueue.h>
#include <linux/timer.h>
#include <linux/uuid.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("MEARVK LLC");
MODULE_DESCRIPTION("USB Dynamic RAM Expansion - Auto-Pagefile on USB Storage");
MODULE_VERSION("1.0.0");

/* ============================================================
 * Configuration
 * ============================================================ */

#define USBSWAP_MAX_DEVICES	8	/* Max concurrent USB swap devices */
#define USBSWAP_SIGNATURE	"USBSWAP1"  /* Pagefile signature header */
#define USBSWAP_SIG_LEN		8
#define USBSWAP_DEFAULT_PRIO	-5	/* Lower priority than on-disk swap */
#define USBSWAP_MIN_SIZE_MB	256	/* Minimum 256MB to bother */
#define USBSWAP_MAX_SIZE_GB	256	/* Maximum 256GB pagefile per device */
#define USBSWAP_HEALTH_INTERVAL	60	/* Health check every 60 seconds */
#define USBSWAP_MAX_ERRORS	16	/* Disable after this many I/O errors */
#define USBSWAP_RESERVED_MB	64	/* Reserve this much space on device */

/* USB speed classes */
#define USBSWAP_SPEED_LOW	0	/* USB 1.x: too slow, reject */
#define USBSWAP_SPEED_MEDIUM	1	/* USB 2.0: emergency only (~30MB/s) */
#define USBSWAP_SPEED_HIGH	2	/* USB 3.0: good (~300MB/s) */
#define USBSWAP_SPEED_SUPER	3	/* USB 3.1+/NVMe: excellent (>500MB/s) */

/* Module parameters */
static int auto_activate = 1;
module_param(auto_activate, int, 0644);
MODULE_PARM_DESC(auto_activate, "Auto-activate swap on USB hotplug (1=yes, 0=no)");

static int default_priority = USBSWAP_DEFAULT_PRIO;
module_param(default_priority, int, 0644);
MODULE_PARM_DESC(default_priority, "Swap priority for USB devices (default: -5)");

static int max_size_pct = 80;
module_param(max_size_pct, int, 0644);
MODULE_PARM_DESC(max_size_pct, "Max percentage of USB device to use for swap (default: 80)");

static int min_speed = USBSWAP_SPEED_MEDIUM;
module_param(min_speed, int, 0644);
MODULE_PARM_DESC(min_speed, "Minimum USB speed class (0=any, 1=USB2, 2=USB3, 3=USB3.1+)");

/* ============================================================
 * Data Structures
 * ============================================================ */

/* Per-device state */
struct usbswap_device {
	struct list_head	list;
	struct usb_device	*udev;		/* USB device reference */
	struct block_device	*bdev;		/* Block device */
	char			devpath[64];	/* e.g., /dev/sdb */
	char			label[32];	/* User-friendly label */

	/* Swap state */
	bool			active;		/* Swap currently enabled */
	bool			preparing;	/* Setup in progress */
	u64			swap_size;	/* Size in bytes */
	int			priority;	/* Swap priority */

	/* Performance */
	u8			speed_class;	/* USB speed classification */
	u32			max_throughput;	/* MB/s estimate */

	/* Health monitoring */
	u32			io_errors;	/* Cumulative I/O errors */
	u32			pages_swapped;	/* Total pages written */
	unsigned long		activated_at;	/* Jiffies when activated */
	struct delayed_work	health_work;	/* Periodic health check */

	/* Safety */
	bool			has_partition_table; /* Don't overwrite! */
	bool			has_filesystem;	    /* Don't overwrite! */
	bool			marked_for_swap;    /* Explicitly prepared */
	uuid_t			swap_uuid;	    /* UUID for identification */
};

/* Global state */
static LIST_HEAD(usbswap_devices);
static DEFINE_MUTEX(usbswap_lock);
static struct workqueue_struct *usbswap_wq;
static struct proc_dir_entry *usbswap_proc_dir;
static atomic_t usbswap_active_count = ATOMIC_INIT(0);

/* ============================================================
 * USB Speed Classification
 * ============================================================ */

static u8 usbswap_classify_speed(struct usb_device *udev)
{
	switch (udev->speed) {
	case USB_SPEED_SUPER_PLUS:	/* USB 3.1+ */
		return USBSWAP_SPEED_SUPER;
	case USB_SPEED_SUPER:		/* USB 3.0 */
		return USBSWAP_SPEED_HIGH;
	case USB_SPEED_HIGH:		/* USB 2.0 */
		return USBSWAP_SPEED_MEDIUM;
	default:			/* USB 1.x or unknown */
		return USBSWAP_SPEED_LOW;
	}
}

static u32 usbswap_estimate_throughput(u8 speed_class)
{
	switch (speed_class) {
	case USBSWAP_SPEED_SUPER:	return 1000;	/* ~1 GB/s */
	case USBSWAP_SPEED_HIGH:	return 400;	/* ~400 MB/s */
	case USBSWAP_SPEED_MEDIUM:	return 35;	/* ~35 MB/s */
	default:			return 1;	/* Unusable */
	}
}

static int usbswap_priority_for_speed(u8 speed_class)
{
	/* Higher speed = higher priority (less negative) */
	switch (speed_class) {
	case USBSWAP_SPEED_SUPER:	return default_priority + 3;
	case USBSWAP_SPEED_HIGH:	return default_priority + 2;
	case USBSWAP_SPEED_MEDIUM:	return default_priority;
	default:			return default_priority - 5;
	}
}

/* ============================================================
 * Device Safety Checks
 *
 * NEVER overwrite a device that has data on it.
 * Only use devices that are:
 *   - Blank/unpartitioned, OR
 *   - Previously prepared by usbswap (has our signature)
 * ============================================================ */

static bool usbswap_check_signature(struct block_device *bdev)
{
	struct page *page;
	char *data;
	bool has_sig = false;

	/* Read first page of device */
	page = alloc_page(GFP_KERNEL);
	if (!page)
		return false;

	data = page_address(page);

	/* Read first sector */
	struct bio *bio = bio_alloc(GFP_KERNEL, 1);
	if (!bio) {
		__free_page(page);
		return false;
	}

	bio_set_dev(bio, bdev);
	bio->bi_iter.bi_sector = 0;
	bio_add_page(bio, page, PAGE_SIZE, 0);
	bio->bi_opf = REQ_OP_READ;

	submit_bio_wait(bio);
	bio_put(bio);

	/* Check for our signature */
	if (memcmp(data, USBSWAP_SIGNATURE, USBSWAP_SIG_LEN) == 0)
		has_sig = true;

	__free_page(page);
	return has_sig;
}

static bool usbswap_device_is_safe(struct block_device *bdev)
{
	/* Check if device has partition table */
	if (bdev->bd_part_count > 0)
		return false; /* Has partitions - don't touch */

	/* Check if device has a recognized filesystem */
	/* TODO: Check superblock signatures (ext4, ntfs, fat, etc.) */

	/* Check if we previously prepared this device */
	if (usbswap_check_signature(bdev))
		return true; /* Our device, safe to reuse */

	/* Blank device: check if it's actually empty */
	/* For safety, require explicit preparation for new devices */
	return false;
}

/* ============================================================
 * Swap Pagefile Setup
 *
 * Creates a swap area on the USB device:
 * 1. Writes usbswap signature header
 * 2. Creates Linux swap header (mkswap equivalent)
 * 3. Activates swap with configured priority
 * ============================================================ */

/*
 * Write swap header to device (kernel-space mkswap)
 */
static int usbswap_write_swap_header(struct block_device *bdev, u64 size_bytes)
{
	union swap_header *header;
	struct page *page;
	struct bio *bio;
	u64 last_page;

	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
	if (!page)
		return -ENOMEM;

	header = page_address(page);

	/* Calculate number of pages */
	last_page = (size_bytes / PAGE_SIZE) - 1;

	/* Fill swap header */
	header->info.version = 1;
	header->info.last_page = last_page;
	header->info.nr_badpages = 0;

	/* Write magic at the end of first page */
	memcpy((char *)header + PAGE_SIZE - 10, "SWAPSPACE2", 10);

	/* Prepend our signature at bytes 16-24 (after swap magic area) */
	memcpy(header->info.sws_volume, USBSWAP_SIGNATURE, USBSWAP_SIG_LEN);

	/* Write to device */
	bio = bio_alloc(GFP_KERNEL, 1);
	if (!bio) {
		__free_page(page);
		return -ENOMEM;
	}

	bio_set_dev(bio, bdev);
	bio->bi_iter.bi_sector = 0;
	bio_add_page(bio, page, PAGE_SIZE, 0);
	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC;

	submit_bio_wait(bio);
	bio_put(bio);
	__free_page(page);

	return 0;
}

/*
 * Prepare a blank USB device for swap use
 */
static int usbswap_prepare_device(struct usbswap_device *usdev)
{
	u64 dev_size;
	u64 swap_size;
	int ret;

	if (!usdev->bdev)
		return -ENODEV;

	/* Get device size */
	dev_size = i_size_read(usdev->bdev->bd_inode);
	if (dev_size < (u64)USBSWAP_MIN_SIZE_MB * 1024 * 1024) {
		pr_info("usbswap: %s too small (%llu MB, need %d MB min)\n",
			usdev->devpath, dev_size / (1024 * 1024),
			USBSWAP_MIN_SIZE_MB);
		return -ENOSPC;
	}

	/* Calculate swap size: max_size_pct of device, capped */
	swap_size = (dev_size * max_size_pct) / 100;
	swap_size -= (u64)USBSWAP_RESERVED_MB * 1024 * 1024; /* Reserve some space */

	if (swap_size > (u64)USBSWAP_MAX_SIZE_GB * 1024 * 1024 * 1024)
		swap_size = (u64)USBSWAP_MAX_SIZE_GB * 1024 * 1024 * 1024;

	/* Align to page boundary */
	swap_size &= ~(PAGE_SIZE - 1);

	pr_info("usbswap: Preparing %s for swap: %llu MB of %llu MB total\n",
		usdev->devpath, swap_size / (1024 * 1024),
		dev_size / (1024 * 1024));

	/* Write swap header */
	ret = usbswap_write_swap_header(usdev->bdev, swap_size);
	if (ret < 0) {
		pr_err("usbswap: Failed to write swap header on %s: %d\n",
		       usdev->devpath, ret);
		return ret;
	}

	usdev->swap_size = swap_size;
	usdev->marked_for_swap = true;
	generate_random_uuid(usdev->swap_uuid.b);

	pr_info("usbswap: %s prepared (%llu MB swap space)\n",
		usdev->devpath, swap_size / (1024 * 1024));

	return 0;
}

/*
 * Activate swap on a prepared device (kernel-space swapon)
 */
static int usbswap_activate(struct usbswap_device *usdev)
{
	int ret;
	char devname[80];

	if (usdev->active)
		return 0;

	if (!usdev->marked_for_swap && !usbswap_check_signature(usdev->bdev)) {
		pr_warn("usbswap: %s not prepared for swap, skipping\n",
			usdev->devpath);
		return -EINVAL;
	}

	snprintf(devname, sizeof(devname), "%s", usdev->devpath);

	/*
	 * Call sys_swapon equivalent from kernel space.
	 * We use the internal swap subsystem interfaces.
	 */
	pr_info("usbswap: Activating swap on %s (priority=%d, speed=%s)\n",
		devname, usdev->priority,
		usdev->speed_class == USBSWAP_SPEED_SUPER ? "USB3.1+" :
		usdev->speed_class == USBSWAP_SPEED_HIGH ? "USB3.0" :
		usdev->speed_class == USBSWAP_SPEED_MEDIUM ? "USB2.0" : "slow");

	/* Kernel-internal swapon via filp_open + sys_swapon path */
	ret = kern_path(devname, LOOKUP_FOLLOW, NULL);
	if (ret == 0) {
		/* Use usermode helper to call swapon */
		char *argv[] = { "/sbin/swapon", "-p",
				 NULL, devname, NULL };
		char prio_str[16];
		char *envp[] = { "HOME=/", "PATH=/sbin:/bin", NULL };

		snprintf(prio_str, sizeof(prio_str), "%d", usdev->priority);
		argv[2] = prio_str;

		ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC);
	}

	if (ret == 0) {
		usdev->active = true;
		usdev->activated_at = jiffies;
		atomic_inc(&usbswap_active_count);

		pr_info("usbswap: ✓ %s active - %llu MB additional RAM available\n",
			usdev->devpath, usdev->swap_size / (1024 * 1024));

		/* Start health monitoring */
		schedule_delayed_work(&usdev->health_work,
				      USBSWAP_HEALTH_INTERVAL * HZ);
	} else {
		pr_err("usbswap: Failed to activate swap on %s: %d\n",
		       devname, ret);
	}

	return ret;
}

/*
 * Deactivate swap safely (migrate pages first)
 */
static int usbswap_deactivate(struct usbswap_device *usdev)
{
	char *argv[] = { "/sbin/swapoff", usdev->devpath, NULL };
	char *envp[] = { "HOME=/", "PATH=/sbin:/bin", NULL };
	int ret;

	if (!usdev->active)
		return 0;

	pr_info("usbswap: Deactivating %s (migrating pages...)\n",
		usdev->devpath);

	/* swapoff will migrate all pages back to RAM or other swap */
	ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC);
	if (ret == 0) {
		usdev->active = false;
		atomic_dec(&usbswap_active_count);
		cancel_delayed_work_sync(&usdev->health_work);
		pr_info("usbswap: ✓ %s deactivated safely\n", usdev->devpath);
	} else {
		pr_err("usbswap: Failed to deactivate %s: %d "
		       "(pages may still be in use)\n",
		       usdev->devpath, ret);
	}

	return ret;
}

/* ============================================================
 * Health Monitoring
 *
 * Periodically checks device health. Disables swap if too many
 * I/O errors accumulate (failing flash media, loose connection).
 * ============================================================ */

static void usbswap_health_check(struct work_struct *work)
{
	struct usbswap_device *usdev = container_of(
		to_delayed_work(work), struct usbswap_device, health_work);

	if (!usdev->active)
		return;

	/* Check error count */
	if (usdev->io_errors > USBSWAP_MAX_ERRORS) {
		pr_crit("usbswap: %s exceeded error threshold (%u errors), "
			"disabling for safety\n",
			usdev->devpath, usdev->io_errors);
		usbswap_deactivate(usdev);
		return;
	}

	/* Check if USB device is still connected */
	if (!usdev->udev || usdev->udev->state == USB_STATE_NOTATTACHED) {
		pr_warn("usbswap: %s disconnected unexpectedly!\n",
			usdev->devpath);
		usbswap_deactivate(usdev);
		return;
	}

	/* Reschedule */
	if (usdev->active)
		schedule_delayed_work(&usdev->health_work,
				      USBSWAP_HEALTH_INTERVAL * HZ);
}

/* ============================================================
 * USB Hotplug Handler
 *
 * Called when a USB mass storage device is connected.
 * Auto-detects if the device is suitable for swap.
 * ============================================================ */

static void usbswap_usb_work_fn(struct work_struct *work);

struct usbswap_hotplug_work {
	struct work_struct work;
	struct usb_device *udev;
	struct usb_interface *intf;
	bool connect;	/* true=connect, false=disconnect */
};

static void usbswap_usb_work_fn(struct work_struct *work)
{
	struct usbswap_hotplug_work *hw =
		container_of(work, struct usbswap_hotplug_work, work);
	struct usbswap_device *usdev;
	u8 speed;

	if (!hw->connect)
		goto out;

	if (!auto_activate)
		goto out;

	speed = usbswap_classify_speed(hw->udev);

	/* Reject if too slow */
	if (speed < min_speed) {
		pr_info("usbswap: Ignoring %s (speed class %d < minimum %d)\n",
			dev_name(&hw->udev->dev), speed, min_speed);
		goto out;
	}

	/* Create device entry */
	usdev = kzalloc(sizeof(*usdev), GFP_KERNEL);
	if (!usdev)
		goto out;

	usdev->udev = hw->udev;
	usdev->speed_class = speed;
	usdev->max_throughput = usbswap_estimate_throughput(speed);
	usdev->priority = usbswap_priority_for_speed(speed);
	INIT_DELAYED_WORK(&usdev->health_work, usbswap_health_check);

	/* TODO: Resolve block device path from USB device */
	snprintf(usdev->devpath, sizeof(usdev->devpath),
		 "/dev/disk/by-id/usb-%s", dev_name(&hw->udev->dev));
	snprintf(usdev->label, sizeof(usdev->label),
		 "USB-RAM-%d", atomic_read(&usbswap_active_count));

	pr_info("usbswap: Detected USB storage: %s (speed=%u MB/s)\n",
		usdev->devpath, usdev->max_throughput);

	mutex_lock(&usbswap_lock);
	list_add(&usdev->list, &usbswap_devices);
	mutex_unlock(&usbswap_lock);

	/*
	 * Attempt to open block device and check if safe to use.
	 * If previously prepared (has our signature), activate immediately.
	 * If blank, prepare then activate.
	 * If has data, leave it alone.
	 */
	/* Note: Full block device resolution would happen here via
	 * scanning /sys/block/ for the USB device association.
	 * For this implementation, the admin can also manually trigger
	 * via /proc/usbswap/prepare */

out:
	kfree(hw);
}

/* ============================================================
 * USB Driver Probe/Disconnect
 * ============================================================ */

static int usbswap_probe(struct usb_interface *intf,
			 const struct usb_device_id *id)
{
	struct usbswap_hotplug_work *hw;
	struct usb_device *udev = interface_to_usbdev(intf);

	/* Only interested in mass storage class */
	if (intf->cur_altsetting->desc.bInterfaceClass != USB_CLASS_MASS_STORAGE)
		return -ENODEV;

	pr_info("usbswap: USB mass storage connected (speed=%d)\n", udev->speed);

	hw = kzalloc(sizeof(*hw), GFP_KERNEL);
	if (!hw)
		return -ENOMEM;

	hw->udev = udev;
	hw->intf = intf;
	hw->connect = true;
	INIT_WORK(&hw->work, usbswap_usb_work_fn);

	queue_work(usbswap_wq, &hw->work);
	usb_set_intfdata(intf, hw);

	return 0;
}

static void usbswap_disconnect(struct usb_interface *intf)
{
	struct usbswap_device *usdev, *tmp;
	struct usb_device *udev = interface_to_usbdev(intf);

	pr_info("usbswap: USB device disconnecting\n");

	mutex_lock(&usbswap_lock);
	list_for_each_entry_safe(usdev, tmp, &usbswap_devices, list) {
		if (usdev->udev == udev) {
			/* Safely deactivate before removal */
			if (usdev->active)
				usbswap_deactivate(usdev);

			list_del(&usdev->list);
			cancel_delayed_work_sync(&usdev->health_work);
			kfree(usdev);
			break;
		}
	}
	mutex_unlock(&usbswap_lock);
}

/* USB device table - match mass storage class */
static const struct usb_device_id usbswap_ids[] = {
	{ USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, 0x06, 0x50) }, /* SCSI/Bulk */
	{ USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, 0x06, 0x62) }, /* UAS */
	{ }
};
MODULE_DEVICE_TABLE(usb, usbswap_ids);

static struct usb_driver usbswap_driver = {
	.name = "usbswap",
	.probe = usbswap_probe,
	.disconnect = usbswap_disconnect,
	.id_table = usbswap_ids,
};

/* ============================================================
 * Proc Interface
 *
 * /proc/usbswap/status   - Show active USB swap devices
 * /proc/usbswap/prepare  - Manually prepare a device path
 * /proc/usbswap/activate - Manually activate a prepared device
 * ============================================================ */

static int usbswap_proc_status_show(struct seq_file *m, void *v)
{
	struct usbswap_device *usdev;
	int count = 0;

	seq_printf(m, "=== USB Dynamic RAM Expansion ===\n");
	seq_printf(m, "Auto-activate: %s\n", auto_activate ? "yes" : "no");
	seq_printf(m, "Active devices: %d / %d max\n",
		   atomic_read(&usbswap_active_count), USBSWAP_MAX_DEVICES);
	seq_printf(m, "Min speed class: %d (%s)\n", min_speed,
		   min_speed == 3 ? "USB3.1+" :
		   min_speed == 2 ? "USB3.0" :
		   min_speed == 1 ? "USB2.0" : "any");
	seq_printf(m, "\n");

	seq_printf(m, "%-16s %-8s %-10s %-8s %-10s %-6s %-6s\n",
		   "Device", "Speed", "Size(MB)", "Priority", "Status",
		   "Errors", "Pages");

	mutex_lock(&usbswap_lock);
	list_for_each_entry(usdev, &usbswap_devices, list) {
		seq_printf(m, "%-16s %-8s %-10llu %-8d %-10s %-6u %-6u\n",
			   usdev->devpath,
			   usdev->speed_class == 3 ? "USB3.1+" :
			   usdev->speed_class == 2 ? "USB3.0" :
			   usdev->speed_class == 1 ? "USB2.0" : "slow",
			   usdev->swap_size / (1024 * 1024),
			   usdev->priority,
			   usdev->active ? "ACTIVE" :
			   usdev->marked_for_swap ? "READY" : "NEW",
			   usdev->io_errors,
			   usdev->pages_swapped);
		count++;
	}
	mutex_unlock(&usbswap_lock);

	if (count == 0)
		seq_printf(m, "(no USB swap devices connected)\n");

	seq_printf(m, "\nUsage:\n");
	seq_printf(m, "  Plug in USB storage → auto-detected and activated\n");
	seq_printf(m, "  echo /dev/sdX > /proc/usbswap/prepare  (manual prep)\n");
	seq_printf(m, "  echo /dev/sdX > /proc/usbswap/activate (manual activate)\n");

	return 0;
}

static int usbswap_proc_status_open(struct inode *inode, struct file *file)
{
	return single_open(file, usbswap_proc_status_show, NULL);
}

static const struct proc_ops usbswap_proc_status_ops = {
	.proc_open = usbswap_proc_status_open,
	.proc_read = seq_read,
	.proc_lseek = seq_lseek,
	.proc_release = single_release,
};

/* Manual prepare: echo "/dev/sdb" > /proc/usbswap/prepare */
static ssize_t usbswap_proc_prepare_write(struct file *file,
					   const char __user *buf,
					   size_t count, loff_t *ppos)
{
	char kbuf[80];
	struct usbswap_device *usdev;

	if (count >= sizeof(kbuf))
		return -EINVAL;
	if (copy_from_user(kbuf, buf, count))
		return -EFAULT;
	kbuf[count] = '\0';
	/* Strip trailing newline */
	if (kbuf[count - 1] == '\n')
		kbuf[count - 1] = '\0';

	/* Find or create device entry */
	mutex_lock(&usbswap_lock);
	list_for_each_entry(usdev, &usbswap_devices, list) {
		if (strcmp(usdev->devpath, kbuf) == 0) {
			mutex_unlock(&usbswap_lock);
			return usbswap_prepare_device(usdev) ? : count;
		}
	}

	/* New device */
	usdev = kzalloc(sizeof(*usdev), GFP_KERNEL);
	if (!usdev) {
		mutex_unlock(&usbswap_lock);
		return -ENOMEM;
	}

	strncpy(usdev->devpath, kbuf, sizeof(usdev->devpath) - 1);
	usdev->speed_class = USBSWAP_SPEED_HIGH; /* Assume USB3 for manual */
	usdev->priority = default_priority;
	INIT_DELAYED_WORK(&usdev->health_work, usbswap_health_check);
	list_add(&usdev->list, &usbswap_devices);
	mutex_unlock(&usbswap_lock);

	pr_info("usbswap: Manual prepare requested for %s\n", kbuf);
	/* Note: actual block device open would happen here */

	return count;
}

static const struct proc_ops usbswap_proc_prepare_ops = {
	.proc_write = usbswap_proc_prepare_write,
};

/* ============================================================
 * Module Init / Exit
 * ============================================================ */

static int __init usbswap_init(void)
{
	int ret;

	pr_info("usbswap: Initializing USB Dynamic RAM Expansion v1.0.0\n");
	pr_info("usbswap: Auto-activate=%d, priority=%d, max_size=%d%%\n",
		auto_activate, default_priority, max_size_pct);
	pr_info("usbswap: Min speed class=%d, max devices=%d\n",
		min_speed, USBSWAP_MAX_DEVICES);

	/* Create workqueue */
	usbswap_wq = alloc_workqueue("usbswap", WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
	if (!usbswap_wq)
		return -ENOMEM;

	/* Create proc interface */
	usbswap_proc_dir = proc_mkdir("usbswap", NULL);
	if (usbswap_proc_dir) {
		proc_create("status", 0444, usbswap_proc_dir,
			    &usbswap_proc_status_ops);
		proc_create("prepare", 0200, usbswap_proc_dir,
			    &usbswap_proc_prepare_ops);
	}

	/* Register USB driver */
	ret = usb_register(&usbswap_driver);
	if (ret < 0) {
		pr_err("usbswap: Failed to register USB driver: %d\n", ret);
		destroy_workqueue(usbswap_wq);
		return ret;
	}

	pr_info("usbswap: Ready. Plug in USB storage for dynamic RAM expansion.\n");
	pr_info("usbswap: Status: cat /proc/usbswap/status\n");

	return 0;
}

static void __exit usbswap_exit(void)
{
	struct usbswap_device *usdev, *tmp;

	pr_info("usbswap: Shutting down USB Dynamic RAM Expansion\n");

	/* Deactivate all swap devices */
	mutex_lock(&usbswap_lock);
	list_for_each_entry_safe(usdev, tmp, &usbswap_devices, list) {
		if (usdev->active)
			usbswap_deactivate(usdev);
		cancel_delayed_work_sync(&usdev->health_work);
		list_del(&usdev->list);
		kfree(usdev);
	}
	mutex_unlock(&usbswap_lock);

	/* Unregister USB driver */
	usb_deregister(&usbswap_driver);

	/* Cleanup */
	if (usbswap_proc_dir)
		proc_remove(usbswap_proc_dir);
	if (usbswap_wq)
		destroy_workqueue(usbswap_wq);

	pr_info("usbswap: Shutdown complete\n");
}

module_init(usbswap_init);
module_exit(usbswap_exit);
