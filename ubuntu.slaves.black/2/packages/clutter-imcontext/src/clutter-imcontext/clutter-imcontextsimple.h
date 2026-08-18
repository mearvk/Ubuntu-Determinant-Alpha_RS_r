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

#ifndef __CLUTTER_IM_CONTEXT_SIMPLE_H__
#define __CLUTTER_IM_CONTEXT_SIMPLE_H__

#include "clutter-imcontext.h"

G_BEGIN_DECLS


#define CLUTTER_TYPE_IM_CONTEXT_SIMPLE              (clutter_im_context_simple_get_type ())
#define CLUTTER_IM_CONTEXT_SIMPLE(obj)              (G_TYPE_CHECK_INSTANCE_CAST ((obj), CLUTTER_TYPE_IM_CONTEXT_SIMPLE, ClutterIMContextSimple))
#define CLUTTER_IM_CONTEXT_SIMPLE_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), CLUTTER_TYPE_IM_CONTEXT_SIMPLE, ClutterIMContextSimpleClass))
#define CLUTTER_IS_IM_CONTEXT_SIMPLE(obj)           (G_TYPE_CHECK_INSTANCE_TYPE ((obj), CLUTTER_TYPE_IM_CONTEXT_SIMPLE))
#define CLUTTER_IS_IM_CONTEXT_SIMPLE_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), CLUTTER_TYPE_IM_CONTEXT_SIMPLE))
#define CLUTTER_IM_CONTEXT_SIMPLE_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), CLUTTER_TYPE_IM_CONTEXT_SIMPLE, ClutterIMContextSimpleClass))


typedef struct _ClutterIMContextSimple       ClutterIMContextSimple;
typedef struct _ClutterIMContextSimpleClass  ClutterIMContextSimpleClass;

struct _ClutterIMContextSimple
{
  ClutterIMContext object;
};

struct _ClutterIMContextSimpleClass
{
  ClutterIMContextClass parent_class;
};

GType         clutter_im_context_simple_get_type  (void) G_GNUC_CONST;
ClutterIMContext *clutter_im_context_simple_new       (void);

G_END_DECLS

#endif /* __CLUTTER_IM_CONTEXT_SIMPLE_H__ */
