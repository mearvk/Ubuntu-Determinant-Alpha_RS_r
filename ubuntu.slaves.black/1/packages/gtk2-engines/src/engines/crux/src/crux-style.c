#include "crux-style.h"
#include "crux-draw.h"

#include <gtk/gtk.h>
#include <stdio.h>

G_DEFINE_DYNAMIC_TYPE (CruxStyle, crux_style, GTK_TYPE_STYLE)

void
crux_style_register_types (GTypeModule *module)
{
	crux_style_register_type (module);
}

static void
crux_style_class_init (CruxStyleClass *klass)
{
  GtkStyleClass *style_class = GTK_STYLE_CLASS (klass);
  crux_draw_style_class_init (style_class);
}

static void
crux_style_init (CruxStyle *style)
{
}

static void
crux_style_class_finalize (CruxStyleClass *klass)
{
}

