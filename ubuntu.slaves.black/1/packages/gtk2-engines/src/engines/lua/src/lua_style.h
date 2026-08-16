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


#include <gtk/gtkstyle.h>
#include <cairo.h>

#include "lua.h"
#include "ge-support.h"

typedef struct _LuaStyle LuaStyle;
typedef struct _LuaStyleClass LuaStyleClass;

#define TYPE_LUA_STYLE              (lua_style_get_type ())
#define LUA_STYLE(object)           (G_TYPE_CHECK_INSTANCE_CAST ((object), TYPE_LUA_STYLE, LuaStyle))
#define LUA_STYLE_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_LUA_STYLE, LuaStyleClass))
#define LUA_IS_STYLE(object)        (G_TYPE_CHECK_INSTANCE_TYPE ((object), TYPE_LUA_STYLE))
#define LUA_IS_STYLE_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_LUA_STYLE))
#define LUA_STYLE_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_LUA_STYLE, LuaStyleClass))

typedef struct
{
	CairoColor bg[5];
	CairoColor base[5];
	CairoColor text[5];
	
	CairoColor shade[9];
	CairoColor spot[3];
} LuaColors;

struct _LuaStyle
{
	GtkStyle parent_instance;
	
	LuaColors colors;
	gchar *theme;
	
	lua_State *L;
};

struct _LuaStyleClass
{
  GtkStyleClass parent_class;
};


GE_INTERNAL void  lua_style_register_types (GTypeModule *module);
GE_INTERNAL GType lua_style_get_type (void);

