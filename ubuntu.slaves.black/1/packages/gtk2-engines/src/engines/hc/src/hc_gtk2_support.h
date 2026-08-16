/* High Contrast - a cairo based GTK+ engine
 * Copyright (C) 2003 Sun Microsystems Inc.
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
hc_simple_border_gap_clip(cairo_t *canvas,
				gint border_thickness,

				gint x,
				gint y,
				gint width,
				gint height,

				GtkPositionType gap_side,
				gint gap_pos,
				gint gap_size);

GE_INTERNAL void do_hc_draw_arrow (cairo_t *cr,
                            CairoColor *color,
                            GtkArrowType arrow_type, 
                            gboolean fill,
                            gint x, 
                            gint y, 
                            gint width, 
                            gint height);
                            
GE_INTERNAL void do_hc_draw_line (cairo_t *cr,
			CairoColor *color,
			gdouble thickness,
			gdouble x1,
			gdouble y1,
			gdouble x2,
			gdouble y2);
 
GE_INTERNAL void do_hc_draw_dot (cairo_t *canvas,
			CairoColor * light,
			CairoColor * dark,
			gint x,
			gint y);

 
GE_INTERNAL void hc_gtk2_engine_hack_menu_shell_setup_signals(GtkWidget *widget);
GE_INTERNAL void hc_gtk2_engine_hack_menu_shell_cleanup_signals(GtkWidget *widget);
