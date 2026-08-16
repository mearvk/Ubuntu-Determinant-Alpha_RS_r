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


#include "lua_utils.h"

void *
lua_utils_fetch_pointer (lua_State *L, const gchar *name)
{
	void *res;
	
	g_return_if_fail (L);
	
	lua_getfield (L, LUA_REGISTRYINDEX, name);
	if (!lua_isuserdata (L, -1))
	{
		lua_pop (L, 1);
		return NULL;
	}
	res = lua_touserdata (L, -1);
	lua_pop (L, 1);
	return res;
}

void
lua_utils_push_pointer (lua_State *L, const gchar *name, void *pointer)
{
	g_return_if_fail (L);

	lua_pushlightuserdata (L, pointer);
	lua_setfield (L, LUA_REGISTRYINDEX, name);
}
