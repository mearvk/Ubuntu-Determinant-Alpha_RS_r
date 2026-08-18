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

#ifndef __CLUTTER_IM_CONTEXT_H__
#define __CLUTTER_IM_CONTEXT_H__

#include <clutter/clutter.h>
#include <pango/pango.h>

G_BEGIN_DECLS

typedef struct _ClutterIMRectangle      ClutterIMRectangle;
struct _ClutterIMRectangle
{
  gint x;
  gint y;
  gint width;
  gint height;
};

#define CLUTTER_TYPE_IM_CONTEXT              (clutter_im_context_get_type ())
#define CLUTTER_IM_CONTEXT(obj)              (G_TYPE_CHECK_INSTANCE_CAST ((obj), CLUTTER_TYPE_IM_CONTEXT, ClutterIMContext))
#define CLUTTER_IM_CONTEXT_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), CLUTTER_TYPE_IM_CONTEXT, ClutterIMContextClass))
#define CLUTTER_IS_IM_CONTEXT(obj)           (G_TYPE_CHECK_INSTANCE_TYPE ((obj), CLUTTER_TYPE_IM_CONTEXT))
#define CLUTTER_IS_IM_CONTEXT_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), CLUTTER_TYPE_IM_CONTEXT))
#define CLUTTER_IM_CONTEXT_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), CLUTTER_TYPE_IM_CONTEXT, ClutterIMContextClass))

typedef struct _ClutterIMContext       ClutterIMContext;
typedef struct _ClutterIMContextClass  ClutterIMContextClass;

struct _ClutterIMContext
{
  GObject parent_instance;
  ClutterActor *actor;
};

struct _ClutterIMContextClass
{
  GObjectClass parent_class;

  /* Signals */
  void     (*preedit_start)        (ClutterIMContext *context);
  void     (*preedit_end)          (ClutterIMContext *context);
  void     (*preedit_changed)      (ClutterIMContext *context);
  void     (*commit)               (ClutterIMContext *context, const gchar *str);
  gboolean (*retrieve_surrounding) (ClutterIMContext *context);
  gboolean (*delete_surrounding)   (ClutterIMContext *context,
				    gint          offset,
				    gint          n_chars);

  /* Virtual functions */
  void     (*get_preedit_string)  (ClutterIMContext   *context,
				   gchar         **str,
				   PangoAttrList **attrs,
				   gint           *cursor_pos);
  gboolean (*filter_keypress)     (ClutterIMContext   *context,
			           ClutterKeyEvent    *event);
  void     (*focus_in)            (ClutterIMContext   *context);
  void     (*focus_out)           (ClutterIMContext   *context);
  void     (*show)                (ClutterIMContext   *context);
  void     (*hide)                (ClutterIMContext   *context);
  void     (*reset)               (ClutterIMContext   *context);
  void     (*set_cursor_location) (ClutterIMContext   *context,
				   ClutterIMRectangle   *area);
  void     (*set_use_preedit)     (ClutterIMContext   *context,
				   gboolean        use_preedit);
  void     (*set_surrounding)     (ClutterIMContext   *context,
				   const gchar    *text,
				   gint            len,
				   gint            cursor_index);
  gboolean (*get_surrounding)     (ClutterIMContext   *context,
				   gchar         **text,
				   gint           *cursor_index);

  /* Padding for future expansion */
  void (*_clutter_reserved1) (void);
  void (*_clutter_reserved2) (void);
  void (*_clutter_reserved3) (void);
  void (*_clutter_reserved4) (void);
  void (*_clutter_reserved5) (void);
  void (*_clutter_reserved6) (void);
};

GType    clutter_im_context_get_type            (void) G_GNUC_CONST;

void     clutter_im_context_get_preedit_string  (ClutterIMContext       *context,
					     gchar             **str,
					     PangoAttrList     **attrs,
					     gint               *cursor_pos);
gboolean clutter_im_context_filter_keypress     (ClutterIMContext       *context,
					     ClutterKeyEvent        *event);
void     clutter_im_context_focus_in            (ClutterIMContext       *context);
void     clutter_im_context_focus_out           (ClutterIMContext       *context);
void     clutter_im_context_show          (ClutterIMContext       *context);
void     clutter_im_context_hide          (ClutterIMContext       *context);
void     clutter_im_context_reset               (ClutterIMContext       *context);
void     clutter_im_context_set_cursor_location (ClutterIMContext       *context,
					     const ClutterIMRectangle *area);
void     clutter_im_context_set_use_preedit     (ClutterIMContext       *context,
					     gboolean            use_preedit);
void     clutter_im_context_set_surrounding     (ClutterIMContext       *context,
					     const gchar        *text,
					     gint                len,
					     gint                cursor_index);
gboolean clutter_im_context_get_surrounding     (ClutterIMContext       *context,
					     gchar             **text,
					     gint               *cursor_index);
gboolean clutter_im_context_delete_surrounding  (ClutterIMContext       *context,
					     gint                offset,
					     gint                n_chars);

G_END_DECLS

#endif /* __CLUTTER_IM_CONTEXT_H__ */
