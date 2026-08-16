/* LUA - a LUA scriptable GTK+ engine
 * Copyright (C) 2006 Daniel Borgmann <daniel.borgmann@gmail.com>
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


#include "draw_utils.h"

static void
rounded_rectangle (cairo_t *cr,
                   gdouble x, gdouble y, gdouble w, gdouble h, gdouble radius,
                   gboolean tl, gboolean tr, gboolean bl, gboolean br)
{
	if (tl)
		cairo_move_to (cr, x+radius, y);
	else
		cairo_move_to (cr, x, y);
	
	if (tr)
		cairo_arc (cr, x+w-radius, y+radius, radius, G_PI * 1.5, G_PI * 2);
	else
		cairo_line_to (cr, x+w, y);
	
	if (br)
		cairo_arc (cr, x+w-radius, y+h-radius, radius, 0, G_PI * 0.5);
	else
		cairo_line_to (cr, x+w, y+h);
	
	if (bl)
		cairo_arc (cr, x+radius,   y+h-radius, radius, G_PI * 0.5, G_PI);
	else
		cairo_line_to (cr, x, y+h);
	
	if (tl)
		cairo_arc (cr, x+radius,   y+radius,   radius, G_PI, G_PI * 1.5);
	else
		cairo_line_to (cr, x, y);
}

void
draw_rectangle (cairo_t *cr, gdouble x, gdouble y, gdouble width, gdouble height,
                gdouble radius, gboolean tl, gboolean tr, gboolean bl, gboolean br,
                gboolean filled)
{
	if (radius)
		rounded_rectangle (cr, x, y, width, height, radius, tl, tr, bl, br);
	else
		cairo_rectangle (cr, x, y, width, height);
	
	if (filled)
		cairo_fill (cr);
	else
		cairo_stroke (cr);
}
