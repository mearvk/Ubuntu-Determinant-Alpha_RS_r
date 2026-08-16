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


/* Misc Drawing/Colour Functions */  
GE_INTERNAL void
do_redmond_draw_masked_fill (cairo_t * cr,
                                  CairoPattern *mask,
                                  CairoColor * background,
                                  CairoColor * foreground,
                                  gint x,
                                  gint y, 
                                  gint width, 
                                  gint height);

GE_INTERNAL void do_redmond_draw_check (cairo_t *cr,
                            CairoColor *color, 
                            gint x, 
                            gint y, 
                            gint width, 
                            gint height);
                            
GE_INTERNAL void do_redmond_draw_arrow (cairo_t *canvas,
                            CairoColor *color,
                            GtkArrowType arrow_type, 
                            gboolean fill,
                            gint x, 
                            gint y, 
                            gint width, 
                            gint height);

GE_INTERNAL void
do_redmond_draw_simple_circle (cairo_t *canvas,
                     	  		CairoColor * tl,
                       			CairoColor * br,
					gint center_x, 
					gint center_y, 
					gint radius);
                            
GE_INTERNAL void do_redmond_draw_line(cairo_t *cr, 
                          CairoColor * dark, 
                          CairoColor * light, 
                          GdkRectangle * area, 
                          gint start, 
                          gint end, 
                          gint base, 
                          gboolean horizontal);
 
GE_INTERNAL void redmond_gtk2_engine_hack_menu_shell_setup_signals(GtkWidget *widget);
GE_INTERNAL void redmond_gtk2_engine_hack_menu_shell_cleanup_signals(GtkWidget *widget);
