/* Industrial - a cairo based GTK+ engine
 * Copyright (C) 2001 Red Hat, Inc.
 * Copyright (C) 2002 Ximian, Inc.
 * Copyright (C) 2006-2007 Benjamin Berg <benjamin@sipsolutions.net>
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
 * modified by Alexander Larsson <alexl@redhat.com>
 * modified by Christopher James Lahey <clahey@ximian.com>
 * modified by Benjamin Berg <benjamin@sipsolutions.net>
 *
 */


enum {
	TOKEN_CONTRAST = G_TOKEN_LAST + 1,
	TOKEN_CONTRAST_CENTER,
	TOKEN_ROUNDED_BUTTONS,
	TOKEN_HINT,
	TOKEN_TRUE,
	TOKEN_FALSE
};

static struct {
	const gchar *name;
	guint token;
} theme_symbols[] = {
	{ "contrast",		TOKEN_CONTRAST },
	{ "rounded_buttons",	TOKEN_ROUNDED_BUTTONS },
	{ "hint",               TOKEN_HINT },
	{ "TRUE",		TOKEN_TRUE },
	{ "FALSE",		TOKEN_FALSE }
};

static guint
theme_parse_named_double (GScanner * scanner, double *value)
{
	guint token;

	/* Skip name */
	token = g_scanner_get_next_token (scanner);

	token = g_scanner_get_next_token (scanner);
	if (token != G_TOKEN_EQUAL_SIGN)
		return G_TOKEN_EQUAL_SIGN;

	token = g_scanner_get_next_token (scanner);
	
	if (token == G_TOKEN_INT)
		*value = scanner->value.v_int;
	else if (token == G_TOKEN_FLOAT)
		*value = scanner->value.v_float;
	else
		return G_TOKEN_FLOAT;

	return G_TOKEN_NONE;
}

static guint
theme_parse_boolean (GScanner * scanner,
		     GTokenType wanted_token, gboolean * retval)
{
	guint token;

	token = g_scanner_get_next_token (scanner);
	if (token != wanted_token)
		return wanted_token;

	token = g_scanner_get_next_token (scanner);
	if (token != G_TOKEN_EQUAL_SIGN)
		return G_TOKEN_EQUAL_SIGN;

	token = g_scanner_get_next_token (scanner);
	if (token == TOKEN_TRUE)
		*retval = TRUE;
	else if (token == TOKEN_FALSE)
		*retval = FALSE;
	else
		return TOKEN_TRUE;

	return G_TOKEN_NONE;
}

static guint
parse_rc_style (GScanner * scanner,
		IndustrialRcStyle *rc)
{
	static GQuark scope_id = 0;
	guint old_scope;
	guint token;
	guint i;

	/* Set up a new scope in this scanner. */

	if (!scope_id)
		scope_id = g_quark_from_string ("industrial_theme_engine");

	/* If we bail out due to errors, we *don't* reset the scope, so the
	 * error messaging code can make sense of our tokens.
	 */
	old_scope = g_scanner_set_scope (scanner, scope_id);

	/* Now check if we already added our symbols to this scope
	 * (in some previous call to industrial_rc_style_parse for the
	 * same scanner.
	 */

	if (!g_scanner_lookup_symbol (scanner, theme_symbols[0].name)) {
		for (i = 0; i < G_N_ELEMENTS (theme_symbols); i++)
			g_scanner_scope_add_symbol (scanner, scope_id, theme_symbols[i].name,
						    GINT_TO_POINTER (theme_symbols[i].token));
	}

	/* We're ready to go, now parse the top level */

	token = g_scanner_peek_next_token (scanner);
	while (token != G_TOKEN_RIGHT_CURLY) {
		switch (token) {
		case TOKEN_CONTRAST:
			token = theme_parse_named_double (scanner, &rc->contrast);
			rc->fields |= INDUSTRIAL_FIELDS_CONTRAST;
			break;
		case TOKEN_ROUNDED_BUTTONS:
			token = theme_parse_boolean (scanner, TOKEN_ROUNDED_BUTTONS, &rc->rounded_buttons);
			rc->fields |= INDUSTRIAL_FIELDS_ROUNDED_BUTTONS;
			break;
		case TOKEN_HINT:
			token = ge_rc_parse_hint (scanner, &rc->hint);
			rc->fields |= INDUSTRIAL_FIELDS_HINT;
			break;
		default:
			g_scanner_get_next_token (scanner);
			token = G_TOKEN_RIGHT_CURLY;
			break;
		}

		if (token != G_TOKEN_NONE)
			return token;

		token = g_scanner_peek_next_token (scanner);
	}

	g_scanner_get_next_token (scanner);

	g_scanner_set_scope (scanner, old_scope);

	return G_TOKEN_NONE;
}
