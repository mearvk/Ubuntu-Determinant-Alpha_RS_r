#include "crux.h"

#include <gtk/gtk.h>
#include <gmodule.h>
#include <stdio.h>

#include "crux-rc-style.h"
#include "crux-style.h"
#include "crux-draw.h"


GE_EXPORT void
theme_init (GTypeModule *module)
{
  crux_rc_style_register_types (module);
  crux_style_register_types (module);
}

GE_EXPORT void
theme_exit(void)
{
}

GE_EXPORT GtkRcStyle *
theme_create_rc_style (void)
{
  return GTK_RC_STYLE (g_object_new (CRUX_TYPE_RC_STYLE, NULL));
}
