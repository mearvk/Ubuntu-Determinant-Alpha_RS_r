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


#include "industrial_style.h"
#include "industrial_rc_style.h"

G_DEFINE_DYNAMIC_TYPE (IndustrialRcStyle, industrial_rc_style, GTK_TYPE_RC_STYLE)

void
industrial_rc_style_register_types (GTypeModule *module)
{
	industrial_rc_style_register_type (module);
}

static void
industrial_rc_style_init (IndustrialRcStyle *industrial_rc)
{
	industrial_rc->contrast = 1.0;
	industrial_rc->rounded_buttons = TRUE;
	industrial_rc->hint = 0;
	industrial_rc->fields = 0;
}

/* Create an empty style suitable to this RC style
 */
static GtkStyle*
industrial_rc_style_create_style (GtkRcStyle *rc_style)
{
	return GTK_STYLE (g_object_new (INDUSTRIAL_TYPE_STYLE, NULL));
}

#include "parse_rc_style.h"

static guint
industrial_rc_style_parse (GtkRcStyle  *rc_style,
			   GtkSettings *settings,
			   GScanner    *scanner)
{
	IndustrialRcStyle *industrial_rc = INDUSTRIAL_RC_STYLE (rc_style);
	return parse_rc_style (scanner, industrial_rc);
}

static void
industrial_rc_style_merge (GtkRcStyle *dest,
			   GtkRcStyle *src)
{
	IndustrialRcStyle *dest_w, *src_w;
	IndustrialFields fields;

	GTK_RC_STYLE_CLASS (industrial_rc_style_parent_class)->merge (dest, src);

	if (!INDUSTRIAL_IS_RC_STYLE (src))
		return;

	src_w = INDUSTRIAL_RC_STYLE (src);
	dest_w = INDUSTRIAL_RC_STYLE (dest);

	fields = (~dest_w->fields) & src_w->fields;

	if (fields & INDUSTRIAL_FIELDS_CONTRAST)
		dest_w->contrast = src_w->contrast;
	if (fields & INDUSTRIAL_FIELDS_ROUNDED_BUTTONS)
		dest_w->rounded_buttons = src_w->rounded_buttons;
	if (fields & INDUSTRIAL_FIELDS_HINT)
		dest_w->hint = src_w->hint;

	dest_w->fields = dest_w->fields | src_w->fields;
}

static void
industrial_rc_style_class_init (IndustrialRcStyleClass * klass)
{
	GtkRcStyleClass *rc_style_class = GTK_RC_STYLE_CLASS (klass);

	rc_style_class->create_style = industrial_rc_style_create_style;
	rc_style_class->parse = industrial_rc_style_parse;
	rc_style_class->merge = industrial_rc_style_merge;
}

static void
industrial_rc_style_class_finalize (IndustrialRcStyleClass *klass)
{
}

