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


#include <gtk/gtk.h>

typedef struct _IndustrialRcStyle IndustrialRcStyle;
typedef struct _IndustrialRcStyleClass IndustrialRcStyleClass;

#define INDUSTRIAL_TYPE_RC_STYLE              (industrial_rc_style_get_type ())
#define INDUSTRIAL_RC_STYLE(object)           (G_TYPE_CHECK_INSTANCE_CAST ((object), INDUSTRIAL_TYPE_RC_STYLE, IndustrialRcStyle))
#define INDUSTRIAL_RC_STYLE_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), INDUSTRIAL_TYPE_RC_STYLE, IndustrialRcStyleClass))
#define INDUSTRIAL_IS_RC_STYLE(object)        (G_TYPE_CHECK_INSTANCE_TYPE ((object), INDUSTRIAL_TYPE_RC_STYLE))
#define INDUSTRIAL_IS_RC_STYLE_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), INDUSTRIAL_TYPE_RC_STYLE))
#define INDUSTRIAL_RC_STYLE_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), INDUSTRIAL_TYPE_RC_STYLE, IndustrialRcStyleClass))

typedef enum {
	INDUSTRIAL_FIELDS_CONTRAST		= 1 << 0,
	INDUSTRIAL_FIELDS_ROUNDED_BUTTONS	= 1 << 1,
	INDUSTRIAL_FIELDS_HINT                  = 1 << 2
} IndustrialFields;

struct _IndustrialRcStyle {
	GtkRcStyle parent_instance;

	double contrast;
	gboolean rounded_buttons;
	GQuark hint;

	IndustrialFields fields;
};

struct _IndustrialRcStyleClass {
	GtkRcStyleClass parent_class;
};

GE_INTERNAL void  industrial_rc_style_register_types (GTypeModule * module);
GE_INTERNAL GType industrial_rc_style_get_type       (void);

