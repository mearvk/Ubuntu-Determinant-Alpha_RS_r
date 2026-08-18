/*
 * clutter-imtext.h
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
 */

#ifndef __CLUTTER_IMTEXT_H__
#define __CLUTTER_IMTEXT_H__

G_BEGIN_DECLS

#include <clutter/clutter.h>
#include "clutter-imcontext.h"

#define CLUTTER_TYPE_IMTEXT                (clutter_imtext_get_type ())
#define CLUTTER_IMTEXT(obj)                (G_TYPE_CHECK_INSTANCE_CAST ((obj), CLUTTER_TYPE_IMTEXT, ClutterIMText))
#define CLUTTER_IS_IMTEXT(obj)             (G_TYPE_CHECK_INSTANCE_TYPE ((obj), CLUTTER_TYPE_IMTEXT))
#define CLUTTER_IMTEXT_CLASS(klass)        (G_TYPE_CHECK_CLASS_CAST ((klass), CLUTTER_TYPE_IMTEXT, ClutterIMTextClass))
#define CLUTTER_IS_IMTEXT_CLASS(klass)     (G_TYPE_CHECK_CLASS_TYPE ((klass), CLUTTER_TYPE_IMTEXT))
#define CLUTTER_IMTEXT_GET_CLASS(obj)      (G_TYPE_INSTANCE_GET_CLASS ((obj), CLUTTER_TYPE_IMTEXT, ClutterIMTextClass))

typedef struct _ClutterIMText              ClutterIMText;
typedef struct _ClutterIMTextPrivate       ClutterIMTextPrivate;
typedef struct _ClutterIMTextClass         ClutterIMTextClass;

struct _ClutterIMText
{
  ClutterText parent_instance;

  ClutterIMTextPrivate *priv;
};

struct _ClutterIMTextClass
{
  ClutterTextClass parent_class;
};

GType clutter_imtext_get_type (void) G_GNUC_CONST;

ClutterActor * clutter_imtext_new (const gchar *text);
void clutter_imtext_set_autoshow_im (ClutterIMText *self, gboolean autoshow);

G_END_DECLS

#endif /* __CLUTTER_IMTEXT_H__ */
