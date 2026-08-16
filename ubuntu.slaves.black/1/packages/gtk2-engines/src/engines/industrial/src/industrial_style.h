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
 */

#include <gtk/gtk.h>

#include "ge-support.h"

typedef struct _IndustrialStyle IndustrialStyle;
typedef struct _IndustrialStyleClass IndustrialStyleClass;

#define INDUSTRIAL_TYPE_STYLE              (industrial_style_get_type ())
#define INDUSTRIAL_STYLE(object)           (G_TYPE_CHECK_INSTANCE_CAST ((object), INDUSTRIAL_TYPE_STYLE, IndustrialStyle))
#define INDUSTRIAL_STYLE_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), INDUSTRIAL_TYPE_STYLE, IndustrialStyleClass))
#define INDUSTRIAL_IS_STYLE(object)        (G_TYPE_CHECK_INSTANCE_TYPE ((object), INDUSTRIAL_TYPE_STYLE))
#define INDUSTRIAL_IS_STYLE_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), INDUSTRIAL_TYPE_STYLE))
#define INDUSTRIAL_STYLE_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), INDUSTRIAL_TYPE_STYLE, IndustrialStyleClass))

struct _IndustrialStyle {
	GtkStyle parent_instance;

	double contrast;
	gboolean rounded_buttons;
	GQuark hint;
};

struct _IndustrialStyleClass {
	GtkStyleClass parent_class;
};

GE_INTERNAL void industrial_style_register_types (GTypeModule * module);
GE_INTERNAL GType industrial_style_get_type      (void);

