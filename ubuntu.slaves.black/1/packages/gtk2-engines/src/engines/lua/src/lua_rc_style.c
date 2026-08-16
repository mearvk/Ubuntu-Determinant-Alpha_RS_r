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


#include "lua_style.h"
#include "lua_rc_style.h"

G_DEFINE_DYNAMIC_TYPE (LuaRcStyle, lua_rc_style, GTK_TYPE_RC_STYLE)

static GtkStyle *lua_rc_style_create_style (GtkRcStyle             *rc_style);
static guint     lua_rc_style_parse        (GtkRcStyle             *rc_style,
                                            GtkSettings            *settings,
                                            GScanner               *scanner);
static void      lua_rc_style_merge        (GtkRcStyle             *dest,
                                            GtkRcStyle             *src);


enum
{
	TOKEN_THEME = G_TOKEN_LAST + 1,
	TOKEN_TRUE,
	TOKEN_FALSE
};

static struct
{
	const gchar        *name;
	guint               token;
}
gtk2_rc_symbols[] =
{
	{ "theme",  TOKEN_THEME },
	{ "TRUE",	TOKEN_TRUE },
	{ "FALSE",	TOKEN_FALSE }
};

void
lua_rc_style_register_types (GTypeModule *module)
{
	lua_rc_style_register_type (module);
}

static void
lua_rc_style_init (LuaRcStyle *lua_rc)
{
	/* FIXME: Uhm, this is BROKEN, at least at a later point a
	 *        non static string is assigned, and will NOT be freed. */
	lua_rc->theme = "";
}

static void
lua_rc_style_class_init (LuaRcStyleClass *klass)
{
	GtkRcStyleClass *rc_style_class = GTK_RC_STYLE_CLASS (klass);

	rc_style_class->parse = lua_rc_style_parse;
	rc_style_class->create_style = lua_rc_style_create_style;
	rc_style_class->merge = lua_rc_style_merge;
}

static void
lua_rc_style_class_finalize (LuaRcStyleClass *klass)
{
}

static guint
gtk2_rc_parse_boolean (GtkSettings *settings,
                       GScanner    *scanner,
                       gboolean    *retval)
{
	guint token;
	token = g_scanner_get_next_token(scanner);

	token = g_scanner_get_next_token(scanner);
	if (token != G_TOKEN_EQUAL_SIGN)
		return G_TOKEN_EQUAL_SIGN;

	token = g_scanner_get_next_token(scanner);
	if (token == TOKEN_TRUE)
		*retval = TRUE;
	else if (token == TOKEN_FALSE)
		*retval = FALSE;
	else
		return TOKEN_TRUE;

	return G_TOKEN_NONE;
}

static guint
gtk2_rc_parse_color(GtkSettings  *settings,
                    GScanner     *scanner,
                    GdkColor     *color)
{
	guint token;

	/* Skip 'blah_color' */
	token = g_scanner_get_next_token(scanner);

	token = g_scanner_get_next_token(scanner);
	if (token != G_TOKEN_EQUAL_SIGN)
		return G_TOKEN_EQUAL_SIGN;

	return gtk_rc_parse_color (scanner, color);
}

static guint
gtk2_rc_parse_contrast(GtkSettings  *settings,
                       GScanner     *scanner,
                       double       *contrast)
{
	guint token;

	/* Skip 'contrast' */
	token = g_scanner_get_next_token(scanner);

	token = g_scanner_get_next_token(scanner);
	if (token != G_TOKEN_EQUAL_SIGN)
		return G_TOKEN_EQUAL_SIGN;

	token = g_scanner_get_next_token(scanner);
	if (token != G_TOKEN_FLOAT)
		return G_TOKEN_FLOAT;

	*contrast = scanner->value.v_float;

	return G_TOKEN_NONE;
}

static guint
gtk2_rc_parse_int (GtkSettings  *settings,
                   GScanner     *scanner,
                   guint8       *progressbarstyle)
{
	guint token;

	token = g_scanner_get_next_token(scanner);

	token = g_scanner_get_next_token(scanner);
	if (token != G_TOKEN_EQUAL_SIGN)
		return G_TOKEN_EQUAL_SIGN;

	token = g_scanner_get_next_token(scanner);
	if (token != G_TOKEN_INT)
		return G_TOKEN_INT;

	*progressbarstyle = scanner->value.v_int;

	return G_TOKEN_NONE;
}

static guint
gtk2_rc_parse_theme (GtkSettings  *settings,
                     GScanner     *scanner,
                     gchar        **theme)
{
	guint token;
	
	token = g_scanner_get_next_token (scanner);
	
	token = g_scanner_get_next_token (scanner);
	if (token != G_TOKEN_EQUAL_SIGN)
		return G_TOKEN_EQUAL_SIGN;
		
	token = g_scanner_get_next_token(scanner);
	if (token != G_TOKEN_STRING)
		return G_TOKEN_STRING;

	*theme = g_strdup (scanner->value.v_string);

	return G_TOKEN_NONE;
}

static guint
lua_rc_style_parse (GtkRcStyle  *rc_style,
                    GtkSettings *settings,
                    GScanner    *scanner)
{
	static GQuark scope_id = 0;
	LuaRcStyle *lua_rc_style = LUA_RC_STYLE (rc_style);

	guint old_scope;
	guint token;
	guint i;
  
	/* Set up a new scope in this scanner. */

	if (!scope_id)
		scope_id = g_quark_from_string("lua_theme_engine");

	/* If we bail out due to errors, we *don't* reset the scope, so the
	 * error messaging code can make sense of our tokens.
	 */
	old_scope = g_scanner_set_scope(scanner, scope_id);

	/* Now check if we already added our symbols to this scope
	 * (in some previous call to estrela_rc_style_parse for the
	 * same scanner.
	 */

	if (!g_scanner_lookup_symbol(scanner, gtk2_rc_symbols[0].name))
	{
		for (i = 0; i < G_N_ELEMENTS (gtk2_rc_symbols); i++)
			g_scanner_scope_add_symbol(scanner, scope_id,
		gtk2_rc_symbols[i].name,
		GINT_TO_POINTER(gtk2_rc_symbols[i].token));
	}

	/* We're ready to go, now parse the top level */

	token = g_scanner_peek_next_token(scanner);
	while (token != G_TOKEN_RIGHT_CURLY)
	{
		switch (token)
		{
		case TOKEN_THEME:
			token = gtk2_rc_parse_theme (settings, scanner, &lua_rc_style->theme);
			break;
	
		default:
			g_scanner_get_next_token(scanner);
			token = G_TOKEN_RIGHT_CURLY;
			break;
		}

		if (token != G_TOKEN_NONE)
			return token;

		token = g_scanner_peek_next_token(scanner);
	}

	g_scanner_get_next_token(scanner);

	g_scanner_set_scope(scanner, old_scope);

	return G_TOKEN_NONE;
}

static void
lua_rc_style_merge (GtkRcStyle *dest,
                    GtkRcStyle *src)
{
	LuaRcStyle *dest_w, *src_w;
	
	GTK_RC_STYLE_CLASS (lua_rc_style_parent_class)->merge (dest, src);
	
	if (!IS_LUA_RC_STYLE (src))
		return;
	
	src_w = LUA_RC_STYLE (src);
	dest_w = LUA_RC_STYLE (dest);
	
	dest_w->theme = src_w->theme;
}


/* Create an empty style suitable to this RC style
 */
static GtkStyle *
lua_rc_style_create_style (GtkRcStyle *rc_style)
{
	return GTK_STYLE (g_object_new (TYPE_LUA_STYLE, NULL));
}
