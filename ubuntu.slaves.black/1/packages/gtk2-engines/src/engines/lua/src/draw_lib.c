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


#include "draw_lib.h"

#include "lauxlib.h"
#include "lualib.h"
#include "lua_utils.h"
#include "draw_utils.h"

static gdouble
fetch_number_arg (lua_State *L, gchar *name, gdouble def)
{
	gdouble ret;

	lua_getfield (L, 1, name);
	if (lua_isnumber (L, -1))
		ret = lua_tonumber (L, -1);
	else
		ret = def;
	lua_pop (L, 1);
	return ret;
}

static gdouble
fetch_boolean_arg (lua_State *L, gchar *name, gboolean def)
{
	gboolean ret;

	lua_getfield (L, 1, name);
	if (lua_isboolean (L, -1))
		ret = lua_toboolean (L, -1);
	else
		ret = def;
	lua_pop (L, 1);
	return ret;
}

static BezierPoint
fetch_point (lua_State *L)
{
	BezierPoint b;
	lua_rawgeti (L, -1, 1);
	b.x = luaL_checknumber (L, -1); lua_pop (L, 1);
	lua_rawgeti (L, -1, 2);
	b.y = luaL_checknumber (L, -1); lua_pop (L, 1);
	
	lua_rawgeti (L, -1, 3);
	if (!lua_isnumber (L, -1))
	{
		b.is_bezier = FALSE; lua_pop (L, 1);
		return b;
	}
	else {
		b.is_bezier = TRUE;
		b.x1 = luaL_checknumber (L, -1); lua_pop (L, 1);
		lua_rawgeti (L, -1, 4);
		b.y1 = luaL_checknumber (L, -1); lua_pop (L, 1);
		lua_rawgeti (L, -1, 5);
		b.x2 = luaL_checknumber (L, -1); lua_pop (L, 1);
		lua_rawgeti (L, -1, 6);
		b.y2 = luaL_checknumber (L, -1); lua_pop (L, 1);
		return b;
	}
}

static gboolean
fetch_color (lua_State *L, gint index, CairoColor *color)
{
	if (!lua_istable (L, index))
		return FALSE;

	lua_rawgeti (L, index, 1);
	if (!lua_isnumber (L, -1)) return FALSE;
	color->r = lua_tonumber (L, -1);
	lua_pop (L, 1);
	lua_rawgeti (L, index, 2);
	if (!lua_isnumber (L, -1)) return FALSE;
	color->g = lua_tonumber (L, -1);
	lua_pop (L, 1);
	lua_rawgeti (L, index, 3);
	if (!lua_isnumber (L, -1)) return FALSE;
	color->b = lua_tonumber (L, -1);
	lua_pop (L, 1);
	lua_rawgeti (L, index, 4);
	color->a = luaL_optnumber (L, -1, 1);	
	lua_pop (L, 1);
	
	return TRUE;
}

static void
push_color (lua_State *L, CairoColor color)
{
	lua_newtable (L);
	lua_pushnumber (L, color.r);
	lua_rawseti (L, -2, 1);
	lua_pushnumber (L, color.g);
	lua_rawseti (L, -2, 2);
	lua_pushnumber (L, color.b);
	lua_rawseti (L, -2, 3);
	lua_pushnumber (L, color.a);
	lua_rawseti (L, -2, 4);
}

static void
set_color_from (lua_State *L, gint index)
{
	cairo_t *cr = lua_utils_fetch_pointer (L, "cairo");
	CairoColor color;
	
	if (!lua_istable (L, index)) return;
	fetch_color (L, index, &color);
	cairo_set_source_rgba (cr, color.r, color.g, color.b, color.a);
}

static void
set_gradient_from (lua_State *L, gint index)
{
	cairo_t *cr = lua_utils_fetch_pointer (L, "cairo");
	cairo_pattern_t *pattern = lua_utils_fetch_pointer (L, "pattern");
	gdouble x1, y1, x2, y2, r1, r2;
	gboolean is_radial = TRUE;
	int i;
	gdouble a;
	CairoColor color;
	
	if (!lua_istable (L, index)) return;
	lua_getfield (L, index, "x1");
	x1 = lua_tonumber (L, -1);
	lua_pop (L, 1); 
	lua_getfield (L, index, "y1");
	y1 = lua_tonumber (L, -1);
	lua_pop (L, 1); 
	lua_getfield (L, index, "x2");
	x2 = lua_tonumber (L, -1);
	lua_pop (L, 1); 
	lua_getfield (L, index, "y2");
	y2 = lua_tonumber (L, -1);
	lua_pop (L, 1); 
	lua_getfield (L, index, "r1");
	if (!lua_isnumber (L, -1))
		is_radial = FALSE;
	else
		r1 = lua_tonumber (L, -1);
	lua_pop (L, 1);
	lua_getfield (L, index, "r2");
	if (!lua_isnumber (L, -1))
		is_radial = FALSE;
	else
		r2 = lua_tonumber (L, -1);
	lua_pop (L, 1);
	
	if (pattern)
		cairo_pattern_destroy (pattern);
	
	if (is_radial)
		pattern = cairo_pattern_create_radial (x1, y1, r1, x2, y2, r2);
	else
		pattern = cairo_pattern_create_linear (x1, y1, x2, y2);
	
	i = 1;
	while (TRUE)
	{
		lua_rawgeti (L, -1, i);
		if (!lua_istable (L, -1))
			break;
		
		lua_rawgeti (L, -1, 1);
		a = lua_tonumber (L, -1);
		lua_pop (L, 1);
		lua_rawgeti (L, -1, 2);
		fetch_color (L, -1, &color);
		lua_pop (L, 1);
		cairo_pattern_add_color_stop_rgba (pattern, a, color.r, color.g, color.b, color.a);
		
		lua_pop (L, 1);
		i++;
	}
	
	cairo_set_source (cr, pattern);
	lua_utils_push_pointer (L, "pattern", pattern);
}

static void
set_source_from_args (lua_State *L)
{
	lua_getfield (L, 1, "color");
	set_color_from (L, -1);
	lua_getfield (L, 1, "gradient");
	set_gradient_from (L, -1);
}


/* Library functions start here */
static int
alpha (lua_State *L)
{
	CairoColor color;
	gdouble alpha;
	if (!fetch_color (L, 1, &color))
		luaL_error (L, "Invalid color argument.");
	alpha = luaL_checknumber (L, 2);
	color.a = alpha;
	push_color (L, color);
	return 1;
}

static int
shade (lua_State *L)
{
	CairoColor color;
	gdouble adjust;
	if (!fetch_color (L, 1, &color))
		luaL_error (L, "Invalid color argument.");
	adjust = luaL_checknumber (L, 2);
	ge_shade_color (&color, adjust, &color);
	push_color (L, color);
	return 1;
}
static int
lighter (lua_State *L)
{
	CairoColor color;
	if (!fetch_color (L, 1, &color))
		luaL_error (L, "Invalid color argument.");
	ge_shade_color (&color, 1.3, &color);
	push_color (L, color);
	return 1;	
}
static int
darker (lua_State *L)
{
	CairoColor color;
	if (!fetch_color (L, 1, &color))
		luaL_error (L, "Invalid color argument.");
	ge_shade_color (&color, 0.7, &color);
	push_color (L, color);
	return 1;
}

static gint
set_color (lua_State *L)
{
	set_color_from (L, 1);
}

static gint
set_gradient (lua_State *L)
{
	set_gradient_from (L, 1);
}

static gint
line (lua_State *L)
{
	cairo_t *cr = lua_utils_fetch_pointer (L, "cairo");
	gdouble x1, y1, x2, y2;

	if (!lua_istable (L, 1))
		return luaL_error (L, "Line function expects a table parameter.\n");
	
	x1 = fetch_number_arg (L, "x1", 0);
	y1 = fetch_number_arg (L, "y1", 0);
	x2 = fetch_number_arg (L, "x2", 0);
	y2 = fetch_number_arg (L, "y2", 0);
	set_source_from_args (L);

	cairo_move_to (cr, x1+0.5, y1+0.5);
	cairo_line_to (cr, x2+0.5, y2+0.5);
	cairo_stroke (cr);
}

static gint
rectangle (lua_State *L)
{
	cairo_t *cr = lua_utils_fetch_pointer (L, "cairo");
	gdouble x, y, width, height, radius;
	gboolean filled, tl, tr, bl, br;
	
	if (!lua_istable (L, 1))
		return luaL_error (L, "Rectangle function expects a table parameter.\n");
	
	x = fetch_number_arg (L, "x", 0);
	y = fetch_number_arg (L, "y", 0);
	width = fetch_number_arg (L, "width", 0);
	height = fetch_number_arg (L, "height", 0);
	radius = fetch_number_arg (L, "radius", 0);
	tl = fetch_boolean_arg (L, "corner_topleft", TRUE);
	tr = fetch_boolean_arg (L, "corner_topright", TRUE);
	bl = fetch_boolean_arg (L, "corner_bottomleft", TRUE);
	br = fetch_boolean_arg (L, "corner bottomright", TRUE);
	filled = fetch_boolean_arg (L, "filled", FALSE);
	set_source_from_args (L);
	
	if (!filled)
	{
		gdouble lw = cairo_get_line_width (cr);
		x += lw/2.0; y += lw/2.0;
		width -= lw; height -= lw;
	}
	
	draw_rectangle (cr, x, y, width, height, radius, tl, tr, bl, br, filled);
}

static gint
arc (lua_State *L)
{
	cairo_t *cr = lua_utils_fetch_pointer (L, "cairo");
	gdouble x, y, radius, angle1, angle2;
	gboolean filled;
	
	if (!lua_istable (L, 1))
		return luaL_error (L, "Arc function expects a table parameter.\n");
	
	x = fetch_number_arg (L, "x", 0);
	y = fetch_number_arg (L, "y", 0);
	radius = fetch_number_arg (L, "radius", 0);
	angle1 = fetch_number_arg (L, "angle1", 0);
	angle2 = fetch_number_arg (L, "angle2", 0);
	filled = fetch_boolean_arg (L, "filled", FALSE);
	set_source_from_args (L);
	
	cairo_arc (cr, x, y, radius, angle1, angle2);
	
	if (filled)
		cairo_fill (cr);
	else
		cairo_stroke (cr);
}

static gint
shape (lua_State *L)
{
	cairo_t *cr = lua_utils_fetch_pointer (L, "cairo");
	BezierPoint sp, p;
	gboolean filled, closed;
	gboolean first = TRUE;
	gint i = 1;
	
	if (!lua_istable (L, 1))
		return luaL_error (L, "Shape function expects a table parameter.\n");
	
	filled = fetch_boolean_arg (L, "filled", FALSE);
	closed = fetch_boolean_arg (L, "closed", FALSE);
	set_source_from_args (L);
	
	cairo_save (cr);
	if (!filled)
	{
		gdouble lw = cairo_get_line_width (cr);
		cairo_translate (cr, lw/2.0, lw/2.0);
	}
	
	while (TRUE)
	{
		lua_rawgeti (L, 1, i);
		if (lua_istable (L, -1))
		{
			p = fetch_point (L);
			if (first)
			{
				sp = p; 
				cairo_move_to (cr, sp.x, sp.y);
				first = FALSE;
			}
			else
			{
				if (p.is_bezier)
					cairo_curve_to (cr, p.x1, p.y1, p.x2, p.y2, p.x, p.y);
				else
					cairo_line_to (cr, p.x, p.y);
			}
			lua_pop (L, 1);
		} 
		else if (lua_isnil (L, -1))
		{
			lua_pop (L, 1);
			break;
		}
		i++;
	}
	
	if (filled || closed)
	{
		if (sp.is_bezier)
			cairo_curve_to (cr, sp.x1, sp.y1, sp.x2, sp.y2, sp.x, sp.y);
		else
			cairo_line_to (cr, sp.x, sp.y);
	}
	
	if (filled)
		cairo_fill (cr);
	else
		cairo_stroke (cr);
	cairo_restore (cr);
}

static gint
scale (lua_State *L)
{
	cairo_t *cr = lua_utils_fetch_pointer (L, "cairo");
	gdouble x = luaL_checknumber (L, 1);
	gdouble y = luaL_checknumber (L, 2);
	
	cairo_set_line_width (cr, cairo_get_line_width (cr) / (float)x); 
	cairo_scale (cr, x, y);
}

static gint
translate (lua_State *L)
{
	cairo_t *cr = lua_utils_fetch_pointer (L, "cairo");
	gdouble x = luaL_checknumber (L, 1);
	gdouble y = luaL_checknumber (L, 2);
	
	cairo_translate (cr, x, y);
}

static gint
save (lua_State *L)
{
	cairo_t *cr = lua_utils_fetch_pointer (L, "cairo");
	cairo_save (cr);
}

static gint
restore (lua_State *L)
{
	cairo_t *cr = lua_utils_fetch_pointer (L, "cairo");
	cairo_restore (cr);
}

gboolean
luaopen_draw (lua_State *L)
{
	/* colour adjustment */
	lua_register (L, "alpha", alpha);
	lua_register (L, "shade", shade);
	lua_register (L, "lighter", lighter);
	lua_register (L, "darker", darker);
	
	/* sources */
	lua_register (L, "set_color", set_color);
	lua_register (L, "set_gradient", set_gradient);
	
	/* drawing ops */
	lua_register (L, "line", line);
	lua_register (L, "rectangle", rectangle);
	lua_register (L, "arc", arc);
	lua_register (L, "shape", shape);
	
	/* misc cairo functions */
	lua_register (L, "scale", scale);
	lua_register (L, "translate", translate);
	lua_register (L, "save", save);
	lua_register (L, "restore", restore);
	
	return TRUE;
}
