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

#ifndef __CLUTTER_IM_MULTICONTEXT_H__
#define __CLUTTER_IM_MULTICONTEXT_H__

#include "clutter-imcontext.h"

G_BEGIN_DECLS

#define CLUTTER_TYPE_IM_MULTICONTEXT              (clutter_im_multicontext_get_type ())
#define CLUTTER_IM_MULTICONTEXT(obj)              (G_TYPE_CHECK_INSTANCE_CAST ((obj), CLUTTER_TYPE_IM_MULTICONTEXT, ClutterIMMulticontext))
#define CLUTTER_IM_MULTICONTEXT_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), CLUTTER_TYPE_IM_MULTICONTEXT, ClutterIMMulticontextClass))
#define CLUTTER_IS_IM_MULTICONTEXT(obj)           (G_TYPE_CHECK_INSTANCE_TYPE ((obj), CLUTTER_TYPE_IM_MULTICONTEXT))
#define CLUTTER_IS_IM_MULTICONTEXT_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), CLUTTER_TYPE_IM_MULTICONTEXT))
#define CLUTTER_IM_MULTICONTEXT_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), CLUTTER_TYPE_IM_MULTICONTEXT, ClutterIMMulticontextClass))


typedef struct _ClutterIMMulticontext        ClutterIMMulticontext;
typedef struct _ClutterIMMulticontextClass   ClutterIMMulticontextClass;
typedef struct _ClutterIMMulticontextPrivate ClutterIMMulticontextPrivate;

struct _ClutterIMMulticontext
{
  ClutterIMContext object;

  ClutterIMContext *slave;

  ClutterIMMulticontextPrivate *priv;

  gchar *context_id;
};

struct _ClutterIMMulticontextClass
{
  ClutterIMContextClass parent_class;

  /* Padding for future expansion */
  void (*_clutter_reserved1) (void);
  void (*_clutter_reserved2) (void);
  void (*_clutter_reserved3) (void);
  void (*_clutter_reserved4) (void);
};

GType         clutter_im_multicontext_get_type (void) G_GNUC_CONST;
ClutterIMContext *clutter_im_multicontext_new      (void);


G_END_DECLS

#endif /* __CLUTTER_IM_MULTICONTEXT_H__ */
