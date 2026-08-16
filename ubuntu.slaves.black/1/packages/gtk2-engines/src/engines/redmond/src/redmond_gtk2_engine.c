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


#include "redmond_gtk2_engine.h"
#include "redmond_gtk2_drawing.h"
#include "redmond_gtk2_misc.h"
 
/**********************************/ 
/* Register & Initialize RC Style */ 
/**********************************/ 

G_DEFINE_DYNAMIC_TYPE (RedmondRcStyle, redmond_rc_style, GTK_TYPE_RC_STYLE)

/* Create an empty style suitable to this RC style */ 
static GtkStyle *
redmond_rc_style_create_style (GtkRcStyle * rc_style)
{
  return GTK_STYLE (g_object_new (REDMOND_TYPE_STYLE, NULL));;
}
 
static void
redmond_rc_style_init (RedmondRcStyle *rc_style)
{
}

static void
redmond_rc_style_class_init (RedmondRcStyleClass * klass)
{
  GtkRcStyleClass *rc_style_class = GTK_RC_STYLE_CLASS (klass);
 
  rc_style_class->create_style = redmond_rc_style_create_style;
}

static void
redmond_rc_style_class_finalize (RedmondRcStyleClass * klass)
{
}
 
/***************************************/ 
/* Register & Initialize Drawing Style */ 
/***************************************/ 

G_DEFINE_DYNAMIC_TYPE (RedmondStyle, redmond_style, GTK_TYPE_STYLE)

static void
redmond_simple_hatch_mask_pattern(CairoPattern *pattern)
{
	cairo_t * cr;
	cairo_surface_t *surface;

	pattern->scale = GE_DIRECTION_NONE;
	pattern->translate = GE_DIRECTION_NONE;

	surface = cairo_image_surface_create(CAIRO_FORMAT_A8, 2, 2);

	cr = cairo_create(surface);

	cairo_set_source_rgba(cr, 0, 0, 0, 0);
	cairo_rectangle (cr, 0, 0, 2, 2);
	cairo_fill (cr);

	cairo_set_source_rgba(cr, 1, 1, 1, 1);
	cairo_rectangle (cr, 1, 0, 1, 1);
	cairo_fill (cr);

	cairo_rectangle (cr, 0, 1, 1, 1);
	cairo_fill (cr);

	cairo_destroy(cr);

	pattern->handle = cairo_pattern_create_for_surface (surface);
	cairo_surface_destroy(surface);

	cairo_pattern_set_extend (pattern->handle, CAIRO_EXTEND_REPEAT);
}

static void
redmond_style_realize (GtkStyle * style)
{
  RedmondStyle *redmond_style = REDMOND_STYLE (style);
  int i;
 
  GTK_STYLE_CLASS (redmond_style_parent_class)->realize (style);
 
  ge_gtk_style_to_cairo_color_cube (style, &redmond_style->color_cube);

  redmond_simple_hatch_mask_pattern(&redmond_style->hatch_mask);

  for (i = 0; i < 5; i++)
    { 
      ge_shade_color(&(redmond_style->color_cube.bg[i]), 0.3, &(redmond_style->black_border[i]));

      redmond_style->bg_color[i] = ge_cairo_color_pattern(&(redmond_style->color_cube.bg[i]));

      redmond_style->bg_image[i] = NULL;

      if ((style->bg_pixmap[i]) && (style->bg_pixmap[i] != (GdkPixmap*) GDK_PARENT_RELATIVE))
      {
        redmond_style->bg_image[i] = ge_cairo_pixmap_pattern(style->bg_pixmap[i]);
      }
    }
}
 
static void
redmond_style_unrealize (GtkStyle * style)
{
  RedmondStyle *redmond_style = REDMOND_STYLE (style);
  int i;

  cairo_pattern_destroy(redmond_style->hatch_mask.handle);

	for (i = 0; i < 5; i++)
	{
		ge_cairo_pattern_destroy(redmond_style->bg_color[i]);
		ge_cairo_pattern_destroy(redmond_style->bg_image[i]);
        }

  GTK_STYLE_CLASS (redmond_style_parent_class)->unrealize (style);
}

static void
redmond_style_init (RedmondStyle *style)
{
}

static void
redmond_style_class_init (RedmondStyleClass * klass)
{
  GtkStyleClass *style_class = GTK_STYLE_CLASS (klass);
 
  style_class->realize = redmond_style_realize;
  style_class->unrealize = redmond_style_unrealize;
 
  style_class->draw_hline = redmond_draw_hline;
  style_class->draw_vline = redmond_draw_vline;
  style_class->draw_arrow = redmond_draw_arrow;
  style_class->draw_box = redmond_draw_box;
  style_class->draw_check = redmond_draw_check;
  style_class->draw_option = redmond_draw_option;
  style_class->draw_tab = redmond_draw_tab;
  style_class->draw_slider = redmond_draw_slider;
  style_class->draw_shadow = redmond_draw_shadow;
  style_class->draw_extension = redmond_draw_extension;
  style_class->draw_handle = redmond_draw_handle;
}

static void
redmond_style_class_finalize (RedmondStyleClass * klass)
{
}
   
/****************/ 
/* Engine Hooks */ 
/****************/ 
GE_EXPORT void
theme_init (GTypeModule * module)
{
  redmond_rc_style_register_type (module);
  redmond_style_register_type (module);
}
 
GE_EXPORT void
theme_exit (void)
{
}
 
GE_EXPORT GtkRcStyle *
theme_create_rc_style (void)
{
  void *ptr;
  ptr = GTK_RC_STYLE (g_object_new (REDMOND_TYPE_RC_STYLE, NULL));  
  return (GtkRcStyle *)ptr;
}
