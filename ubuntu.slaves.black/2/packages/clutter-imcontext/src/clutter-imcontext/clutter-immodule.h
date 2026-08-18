/*
 * clutter-imcontext 
 * clutter-imcontext is an imcontext framework modified base on GTK's imcontext.
 *
 * Author: raymond liu <raymond.liu@intel.com>
 *
 * Copyright (C) 2000 Red Hat, Inc.
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

#ifndef __CLUTTER_IM_MODULE_H__
#define __CLUTTER_IM_MODULE_H__

#include "clutter-imcontext.h"

G_BEGIN_DECLS

typedef struct _ClutterIMContextInfo ClutterIMContextInfo;

struct _ClutterIMContextInfo
{
  const gchar *context_id;
  const gchar *context_name;
  const gchar *domain;
  const gchar *domain_dirname;
  const gchar *default_locales;
};

void           _clutter_im_module_list          (const ClutterIMContextInfo ***contexts,
                                                 guint *n_contexts);
ClutterIMContext * _clutter_im_module_create    (const gchar *context_id);
const gchar  * _clutter_im_module_get_default_context_id (void);

/* The following entry points are exported by each input method module
 */

/*
void          im_module_list   (const ClutterIMContextInfo ***contexts,
				guint                      *n_contexts);
void          im_module_init   (GTypeModule                *module);
void          im_module_exit   (void);
ClutterIMContext *im_module_create (const gchar            *context_id);
*/

gchar       * get_im_module_path (void);

G_END_DECLS

#endif /* __CLUTTER_IM_MODULE_H__ */
