/* Glide - a cairo based GTK+ engine
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
 */


#include "glide_gtk2_engine.h"
#include "glide_gtk2_support.h"
#include "glide_gtk2_drawing.h"

#if 0
enum
  {
    TOKEN_PROFILE = G_TOKEN_LAST + 1,
  };

static struct
  {
    gchar       *name;
    guint        token;
  }
theme_symbols[] =
{
  { "profile",      TOKEN_PROFILE }
};
#endif
 
/**********************************/ 
/* Register & Initialize RC Style */ 
/**********************************/ 
 
/* Create an empty style suitable to this RC style */ 
static GtkStyle *
glide_rc_style_create_style (GtkRcStyle * rc_style)
{
  return GTK_STYLE (g_object_new (GLIDE_TYPE_STYLE, NULL));
}
 
static void
glide_rc_style_class_init (GlideRcStyleClass * klass)
{
  GtkRcStyleClass *rc_style_class = GTK_RC_STYLE_CLASS (klass);
 
  rc_style_class->create_style = glide_rc_style_create_style;
}
 
G_DEFINE_DYNAMIC_TYPE (GlideRcStyle, glide_rc_style, GTK_TYPE_RC_STYLE)

static void
glide_rc_style_class_finalize (GlideRcStyleClass *klass)
{
}

static void
glide_rc_style_init (GlideRcStyle *self)
{
}

/***************************************/ 
/* Register & Initialize Drawing Style */ 
/***************************************/ 

G_DEFINE_DYNAMIC_TYPE (GlideStyle, glide_style, GTK_TYPE_STYLE)

static void
glide_linear_overlay_pattern(gboolean vertical, gboolean EVIL_OVERLAY, CairoPattern *pattern)
{
	#if  ((CAIRO_VERSION_MAJOR < 1) || ((CAIRO_VERSION_MAJOR == 1) && (CAIRO_VERSION_MINOR < 2)))
		pattern->type = CAIRO_PATTERN_TYPE_LINEAR;
	#endif

	if (vertical)
	{
		pattern->scale = GE_DIRECTION_VERTICAL;

		pattern->handle = cairo_pattern_create_linear(0, 0, 1, 0);
	}
	else
	{
		pattern->scale = GE_DIRECTION_HORIZONTAL;

		pattern->handle = cairo_pattern_create_linear(0, 0, 0, 1);
	}

	pattern->translate = GE_DIRECTION_BOTH;

	if (EVIL_OVERLAY)
	{
		pattern->operator = CAIRO_OPERATOR_OVER;
		cairo_pattern_add_color_stop_rgba(pattern->handle, 0.000, 1, 1, 1, 0.5);
		cairo_pattern_add_color_stop_rgba(pattern->handle, 0.500, 1, 1, 1, 0.25);
		cairo_pattern_add_color_stop_rgba(pattern->handle, 1.000, 1, 1, 1, 0.5);

		/* Super Evil Overlay */
/*		cairo_pattern_add_color_stop_rgba(pattern->handle, 0.000, 1, 1, 1, 0.000);
		cairo_pattern_add_color_stop_rgba(pattern->handle, 0.085, 1, 1, 1, 0.030);
		cairo_pattern_add_color_stop_rgba(pattern->handle, 0.330, 1, 1, 1, 0.050);
		cairo_pattern_add_color_stop_rgba(pattern->handle, 0.500, 1, 1, 1, 0.250);
		cairo_pattern_add_color_stop_rgba(pattern->handle, 0.770, 1, 1, 1, 0.150);
		cairo_pattern_add_color_stop_rgba(pattern->handle, 1.000, 1, 1, 1, 0.050);*/
	}
	else
	{
		pattern->operator = CAIRO_OPERATOR_OVER;
		cairo_pattern_add_color_stop_rgba(pattern->handle, 0.000, 1, 1, 1, 0.18);
		cairo_pattern_add_color_stop_rgba(pattern->handle, 0.500, 1, 1, 1, 0.09);
		cairo_pattern_add_color_stop_rgba(pattern->handle, 1.000, 1, 1, 1, 0.18);
	}
}

static void
glide_style_realize (GtkStyle * style)
{
	GlideStyle *glide_style = GLIDE_STYLE (style);
	int i;
 
	GTK_STYLE_CLASS (glide_style_parent_class)->realize (style);
 
	ge_gtk_style_to_cairo_color_cube (style, &glide_style->color_cube);

	glide_linear_overlay_pattern(FALSE, FALSE, &glide_style->overlay[FALSE][FALSE]);
       	glide_linear_overlay_pattern(TRUE, FALSE, &glide_style->overlay[FALSE][TRUE]);     

	glide_linear_overlay_pattern(FALSE, TRUE, &glide_style->overlay[TRUE][FALSE]);
       	glide_linear_overlay_pattern(TRUE, TRUE, &glide_style->overlay[TRUE][TRUE]);     

	for (i = 0; i < 5; i++)
	{
		CairoColor base = glide_style->color_cube.bg[i];
		
		/* Use Smooth's alternate shades for Light/Dark/Mid */
		ge_shade_color(&base, 0.666667, &glide_style->color_cube.dark[i]);
		ge_shade_color(&base, 1.2, &glide_style->color_cube.light[i]);
		ge_blend_color(&glide_style->color_cube.dark[i], &glide_style->color_cube.light[i], &glide_style->color_cube.mid[i]);

		glide_style->bg_solid[i] = ge_cairo_color_pattern(&base);

		glide_style->bg_image[i] = NULL;
		if ((style->bg_pixmap[i]) && (style->bg_pixmap[i] != (GdkPixmap*) GDK_PARENT_RELATIVE))
		{
			glide_style->bg_image[i] = ge_cairo_pixmap_pattern(style->bg_pixmap[i]);
		}

		glide_style->bg_gradient[0][i] = ge_cairo_linear_shade_gradient_pattern(&base, 1.05, 0.95, FALSE);
		glide_style->bg_gradient[1][i] = ge_cairo_linear_shade_gradient_pattern(&base, 1.05, 0.95, TRUE);

		glide_style->active_tab_gradient[GTK_POS_LEFT][i] = ge_cairo_linear_shade_gradient_pattern(&base, 1.0, 0.95, TRUE);
		glide_style->active_tab_gradient[GTK_POS_RIGHT][i] = ge_cairo_linear_shade_gradient_pattern(&base, 1.05, 1.0, TRUE);
		glide_style->active_tab_gradient[GTK_POS_TOP][i] = ge_cairo_linear_shade_gradient_pattern(&base, 1.0, 0.95, FALSE);
		glide_style->active_tab_gradient[GTK_POS_BOTTOM][i] = ge_cairo_linear_shade_gradient_pattern(&base, 1.05, 1.0, FALSE);
	}
}

static void
glide_style_unrealize (GtkStyle * style)
{
	GlideStyle *glide_style = GLIDE_STYLE (style);
	int i;
 
	cairo_pattern_destroy(glide_style->overlay[TRUE][FALSE].handle);
	cairo_pattern_destroy(glide_style->overlay[TRUE][TRUE].handle);
	cairo_pattern_destroy(glide_style->overlay[FALSE][FALSE].handle);
	cairo_pattern_destroy(glide_style->overlay[FALSE][TRUE].handle);

	for (i = 0; i < 5; i++)
	{
		ge_cairo_pattern_destroy(glide_style->bg_solid[i]);

		ge_cairo_pattern_destroy(glide_style->bg_image[i]);

		ge_cairo_pattern_destroy(glide_style->bg_gradient[FALSE][i]);
		ge_cairo_pattern_destroy(glide_style->bg_gradient[TRUE][i]);

		ge_cairo_pattern_destroy(glide_style->active_tab_gradient[GTK_POS_LEFT][i]);
		ge_cairo_pattern_destroy(glide_style->active_tab_gradient[GTK_POS_RIGHT][i]);
		ge_cairo_pattern_destroy(glide_style->active_tab_gradient[GTK_POS_TOP][i]);
		ge_cairo_pattern_destroy(glide_style->active_tab_gradient[GTK_POS_BOTTOM][i]);
	}
 
	GTK_STYLE_CLASS (glide_style_parent_class)->unrealize (style);
}
 
static void
glide_style_class_init (GlideStyleClass * klass)
{
  GtkStyleClass *style_class = GTK_STYLE_CLASS (klass);
 
  style_class->realize = glide_style_realize;
  style_class->unrealize = glide_style_unrealize;
 
  style_class->draw_hline = glide_draw_hline;
  style_class->draw_vline = glide_draw_vline;
  style_class->draw_arrow = glide_draw_arrow;
  style_class->draw_box = glide_draw_box;
  style_class->draw_flat_box = glide_draw_flat_box;
  style_class->draw_check = glide_draw_check;
  style_class->draw_option = glide_draw_option;
  style_class->draw_tab = glide_draw_tab;
  style_class->draw_slider = glide_draw_slider;
  style_class->draw_shadow = glide_draw_shadow;
  style_class->draw_shadow_gap = glide_draw_shadow_gap;
  style_class->draw_box_gap = glide_draw_box_gap;
  style_class->draw_extension = glide_draw_extension;
  style_class->draw_handle = glide_draw_handle;
  style_class->draw_focus = glide_draw_focus;
  style_class->draw_layout = glide_draw_layout;
}
  
static void
glide_style_class_finalize (GlideStyleClass *klass)
{
}

static void
glide_style_init (GlideStyle *self)
{
}

/****************/ 
/* Engine Hooks */ 
/****************/ 
GE_EXPORT void
theme_init (GTypeModule * module)
{
  glide_rc_style_register_type (module);
  glide_style_register_type (module);
}
 
GE_EXPORT void
theme_exit (void)
{
}
 
GE_EXPORT GtkRcStyle *
theme_create_rc_style (void)
{
  void *ptr;
  ptr = GTK_RC_STYLE (g_object_new (GLIDE_TYPE_RC_STYLE, NULL));  
  return (GtkRcStyle *)ptr;
}
