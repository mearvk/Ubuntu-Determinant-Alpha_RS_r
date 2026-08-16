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

  
#include <cairo.h>

#include "lua.h"

#include "ge-support.h"

typedef struct {
	gboolean is_bezier;
	gdouble x;
	gdouble y;
	gdouble x1;
	gdouble y1;
	gdouble x2;
	gdouble y2;
} BezierPoint;

GE_INTERNAL gboolean luaopen_draw (lua_State *L);
