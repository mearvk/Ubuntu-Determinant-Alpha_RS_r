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


#include <math.h>

GE_INTERNAL void
ge_blend_color(const CairoColor *color1, const CairoColor *color2, CairoColor *composite);

typedef enum {
	GLIDE_BEVEL_STYLE_SMOOTH = 1,

	GLIDE_BEVEL_STYLE_SMOOTHER,

	GLIDE_BEVEL_STYLE_THINICE,

	GLIDE_BEVEL_STYLE_REDMOND,

	GLIDE_BEVEL_STYLE_FLAT,

	GLIDE_BEVEL_STYLE_NONE,

	/* Default */
	GLIDE_BEVEL_STYLE_DEFAULT = GLIDE_BEVEL_STYLE_SMOOTHER
} GlideBevelStyle;

typedef enum {
	GLIDE_BORDER_TYPE_IN, 
	GLIDE_BORDER_TYPE_OUT, 
	GLIDE_BORDER_TYPE_ETCHED, 
	GLIDE_BORDER_TYPE_ENGRAVED, 
	GLIDE_BORDER_TYPE_NONE
} GlideBorderType;

typedef enum {
	GLIDE_SIDE_TOP,
	GLIDE_SIDE_LEFT,
	GLIDE_SIDE_RIGHT,
	GLIDE_SIDE_BOTTOM,
	GLIDE_SIDE_NONE
} GlideSide;

GE_INTERNAL void do_glide_draw_border_with_gap(cairo_t *canvas,
					CairoColor *base,
					GlideBevelStyle bevel_style,
					GlideBorderType border_type,
					gint x,
					gint y,
					gint width,
					gint height,
					GlideSide gap_side,
					gint gap_pos,
					gint gap_size);

GE_INTERNAL void do_glide_draw_border(cairo_t *canvas,
                              CairoColor *base,
                              GlideBevelStyle bevel_style,
                              GlideBorderType border_type,
                              gint x,
                              gint y,
                              gint width,
                              gint height);

typedef enum {
	GLIDE_CHECK_INCONSISTENT, 
	GLIDE_CHECK_ON, 
	GLIDE_CHECK_OFF 
} GlideCheckState;

GE_INTERNAL void do_glide_draw_check (cairo_t *cr,
                            CairoColor *color, 
                            gint x, 
                            gint y, 
                            gint width, 
                            gint height);
                
GE_INTERNAL void 
do_glide_draw_round_option(cairo_t *canvas,
				CairoColor *base,
				CairoColor *fill_color,
				CairoColor *check_color,
        	                GlideBevelStyle bevel_style,
                	        GlideBorderType border_type,
				GlideCheckState check_state,
				gint x,
				gint y,
				gint width,
				gint height);

GE_INTERNAL void
do_glide_draw_simple_circle (cairo_t *canvas,
                     	  		CairoColor * tl,
                       			CairoColor * br,
					gint center_x, 
					gint center_y, 
					gint radius);
            
GE_INTERNAL void do_glide_draw_arrow (cairo_t *cr,
                            CairoColor *color,
                            GtkArrowType arrow_type, 
                            gboolean fill,
                            gint x, 
                            gint y, 
                            gint width, 
                            gint height);
                            
GE_INTERNAL void do_glide_draw_line(cairo_t *cr, 
                          CairoColor * dark, 
                          CairoColor * light, 
                          GdkRectangle * area, 
                          gint start, 
                          gint end, 
                          gint base, 
                          gboolean horizontal);
 
GE_INTERNAL void
do_glide_draw_grip (cairo_t *canvas,
			CairoColor * light,
			CairoColor * dark,
			gint x,
			gint y,
			gint width,
			gint height,
			gboolean vertical);

GE_INTERNAL void glide_gtk2_engine_hack_menu_shell_setup(GtkWidget *widget);
