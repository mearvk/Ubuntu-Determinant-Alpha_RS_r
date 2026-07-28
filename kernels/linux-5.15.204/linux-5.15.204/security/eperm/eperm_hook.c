/* SPDX-License-Identifier: GPL-2.0 */
/*
 * eperm_hook.c - Integration hook for generic_permission()
 *
 * This file provides the hook that integrates the Extended Permission
 * Classes (Trusted/Genius) into the standard Linux DAC permission path.
 *
 * The hook is called at the top of generic_permission() in fs/namei.c.
 * If the calling user is class 4 (Trusted) or class 5 (Genius), access
 * is granted immediately without consulting standard permission bits.
 *
 * Integration patch for fs/namei.c generic_permission():
 *
 *   int generic_permission(struct user_namespace *mnt_userns,
 *                          struct inode *inode, int mask)
 *   {
 *       int ret;
 *
 *  +    // Extended Permission Classes: check Trusted/Genius first
 *  +    #ifdef CONFIG_SECURITY_EPERM
 *  +    ret = eperm_check_access(mnt_userns, inode, mask);
 *  +    if (ret == 0)
 *  +        return 0;  // Class 4/5: access granted, no DAC needed
 *  +    // ret == -EAGAIN means not a trusted/genius user, continue normal
 *  +    #endif
 *  +
 *       // Do the basic permission checks (existing code unchanged)
 *       ret = acl_permission_check(mnt_userns, inode, mask);
 *       ...
 *   }
 *
 * The standard permission system remains ENTIRELY INTACT for classes 1-3.
 * Only registered Trusted/Genius persons bypass the check.
 *
 * Copyright (C) 2026 MEARVK LLC
 */

#ifdef CONFIG_SECURITY_EPERM

#include <linux/eperm.h>

/*
 * eperm_pre_permission_check - Called before standard DAC
 *
 * This is the single integration point. It answers one question:
 * "Is this person trusted enough to bypass permission bits entirely?"
 *
 * The answer is:
 *   - For Class 4 (Trusted): Yes. They work implicitly. Simple to audit.
 *   - For Class 5 (Genius): Yes. They work freely for mutual profit.
 *     Supreme-tier access logged for institutional record only.
 *   - For everyone else: No. Normal DAC applies as always.
 *
 * This function does NOT modify inodes, does NOT change mode bits,
 * does NOT interfere with POSIX ACLs or capabilities. It simply
 * short-circuits the permission check for known-good persons.
 */
static inline int eperm_pre_permission_check(struct user_namespace *mnt_userns,
					     struct inode *inode, int mask)
{
	return eperm_check_access(mnt_userns, inode, mask);
}

#else

static inline int eperm_pre_permission_check(struct user_namespace *mnt_userns,
					     struct inode *inode, int mask)
{
	return -EAGAIN; /* Not compiled in, always fall through */
}

#endif /* CONFIG_SECURITY_EPERM */
