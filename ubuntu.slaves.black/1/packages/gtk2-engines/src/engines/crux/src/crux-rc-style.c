#include <gtk/gtk.h>

#include "crux-rc-style.h"
#include "crux-style.h"

#include <stdio.h>
#include <string.h>


static GtkStyle *crux_rc_style_create_style (GtkRcStyle *rc_style);

G_DEFINE_DYNAMIC_TYPE (CruxRcStyle, crux_rc_style, GTK_TYPE_RC_STYLE)

void
crux_rc_style_register_types (GTypeModule *module)
{
	crux_rc_style_register_type (module);
}

static void
crux_rc_style_class_init (CruxRcStyleClass *klass)
{
	GtkRcStyleClass *rc_style_class = GTK_RC_STYLE_CLASS (klass);
	rc_style_class->create_style = crux_rc_style_create_style;
}

static GtkStyle *
crux_rc_style_create_style (GtkRcStyle *rc_style)
{
	return GTK_STYLE (g_object_new (CRUX_TYPE_STYLE, NULL));
}

static void
crux_rc_style_init (CruxRcStyle *rc_style)
{
}

static void
crux_rc_style_class_finalize (CruxRcStyleClass *klass)
{
}

