/* Industrial - a cairo based GTK+ engine
 * Copyright (C) 2001 Red Hat, Inc.
 * Copyright (C) 2002 Ximian, Inc.
 * Copyright (C) 2006 Benjamin Berg <benjamin@sipsolutions.net>
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


#include <gmodule.h>
#include <gtk/gtk.h>

#include "industrial_style.h"
#include "industrial_rc_style.h"

GE_EXPORT void
theme_init (GTypeModule * module)
{
	industrial_rc_style_register_types (module);
	industrial_style_register_types (module);
}

GE_EXPORT void
theme_exit (void)
{
}

GE_EXPORT GtkRcStyle*
theme_create_rc_style (void)
{
	return GTK_RC_STYLE (g_object_new (INDUSTRIAL_TYPE_RC_STYLE, NULL));
}

