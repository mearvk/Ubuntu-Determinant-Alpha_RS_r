/* Redmond95 - a cairo based GTK+ engine
 * Copyright (C) 2001 Red Hat, Inc.
 * Copyright (C) 2006 Andrew Johnson <acjgenius@earthlink.net>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 * Project contact: <gnome-themes-list@gnome.org>
 *
 *
 * Written by Owen Taylor <otaylor@redhat.com>
 * modified by Andrew Johnson <ajgenius@ajgenius.us>
 *
 */


#include <gmodule.h>
#include <gtk/gtk.h>
#include "ge-support.h"
 
/*****************************/
/* Pattern Fills             */
/*****************************/
#define DEFAULT_BACKGROUND_PATTERN(redmond_style, state) ((redmond_style->bg_image[state])?redmond_style->bg_image[state]:redmond_style->bg_color[state])

/*****************************/
/* RC Style Declaration      */
/*****************************/

#define REDMOND_TYPE_RC_STYLE              (redmond_rc_style_get_type ())
#define REDMOND_RC_STYLE(object)           (G_TYPE_CHECK_INSTANCE_CAST ((object), REDMOND_TYPE_RC_STYLE, RedmondRcStyle))
#define REDMOND_RC_STYLE_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), REDMOND_TYPE_RC_STYLE, RedmondRcStyleClass))
#define REDMOND_IS_RC_STYLE(object)        (G_TYPE_CHECK_INSTANCE_TYPE ((object), REDMOND_TYPE_RC_STYLE))
#define REDMOND_IS_RC_STYLE_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), REDMOND_TYPE_RC_STYLE))
#define REDMOND_RC_STYLE_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), REDMOND_TYPE_RC_STYLE, RedmondRcStyleClass))
 
typedef struct
{
  GtkRcStyle parent_instance;
} RedmondRcStyle;
 
typedef struct
{
  GtkRcStyleClass parent_class;
} RedmondRcStyleClass;

GE_INTERNAL GType redmond_rc_style_get_type (void);
 
/*****************************/
/* Drawing Style Declaration */
/*****************************/
 
#define REDMOND_TYPE_STYLE              (redmond_style_get_type ())
#define REDMOND_STYLE(object)           (G_TYPE_CHECK_INSTANCE_CAST ((object), REDMOND_TYPE_STYLE, RedmondStyle))
#define REDMOND_STYLE_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), REDMOND_TYPE_STYLE, RedmondStyleClass))
#define REDMOND_IS_STYLE(object)        (G_TYPE_CHECK_INSTANCE_TYPE ((object), REDMOND_TYPE_STYLE))
#define REDMOND_IS_STYLE_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), REDMOND_TYPE_STYLE))
#define REDMOND_STYLE_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), REDMOND_TYPE_STYLE, RedmondStyleClass))
 
typedef struct
{
  GtkStyle parent_instance;

  CairoColor black_border[5];
  CairoColorCube color_cube;

  CairoPattern *bg_color[5];
  CairoPattern *bg_image[5];
  CairoPattern hatch_mask;
} RedmondStyle;
 
typedef struct
{
  GtkStyleClass parent_class;
} RedmondStyleClass;

GE_INTERNAL GType redmond_style_get_type (void);

