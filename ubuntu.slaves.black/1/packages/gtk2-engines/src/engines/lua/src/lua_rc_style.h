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


#include <gtk/gtkrc.h>

#include "ge-support.h"

typedef struct _LuaRcStyle LuaRcStyle;
typedef struct _LuaRcStyleClass LuaRcStyleClass;

#define TYPE_LUA_RC_STYLE              (lua_rc_style_get_type ())
#define LUA_RC_STYLE(object)           (G_TYPE_CHECK_INSTANCE_CAST ((object), TYPE_LUA_RC_STYLE, LuaRcStyle))
#define LUA_RC_STYLE_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_LUA_RC_STYLE, LuaRcStyleClass))
#define IS_LUA_RC_STYLE(object)        (G_TYPE_CHECK_INSTANCE_TYPE ((object), TYPE_LUA_RC_STYLE))
#define IS_LUA_RC_STYLE_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_LUA_RC_STYLE))
#define LUA_RC_STYLE_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_LUA_RC_STYLE, LuaRcStyleClass))

struct _LuaRcStyle
{
	GtkRcStyle parent_instance;

	gchar *theme;
};

struct _LuaRcStyleClass
{
	GtkRcStyleClass parent_class;
};

GE_INTERNAL void  lua_rc_style_register_types (GTypeModule *module);
GE_INTERNAL GType lua_rc_style_get_type (void);

