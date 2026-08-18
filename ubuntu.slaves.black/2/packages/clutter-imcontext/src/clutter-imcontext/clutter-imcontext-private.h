/*
 * clutter-imcontext-private.h
 *
 * Author: raymond liu <raymond.liu@intel.com>
 *
 * Copyright (C) 2009, Intel Corporation.
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * version 2.1 as published by the Free Software Foundation.
 * 
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA
 *
 */

#ifndef __CLUTTER_IMCONTEXT_PRIVATE_H__
#define __CLUTTER_IMCONTEXT_PRIVATE_H__

#include <glib.h>
#include <glib-object.h>

G_BEGIN_DECLS

#define I_(str)         (g_intern_static_string ((str)))

#if (ENABLE_DEBUG)
#define DBG(x, a...) g_fprintf (stderr,  __FILE__ ",%d,%s: " x "\n", __LINE__, __func__, ##a)
#else
#define DBG(x, a...) do {} while (0)
#endif

#define STEP() DBG("")

gboolean _clutter_boolean_handled_accumulator (GSignalInvocationHint *ihint,
                                      GValue                *return_accu,
                                      const GValue          *handler_return,
                                      gpointer               dummy);

G_END_DECLS

#endif /* __CLUTTER_IMCONTEXT_PRIVATE_H__ */
