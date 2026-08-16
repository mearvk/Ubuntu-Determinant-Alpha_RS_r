#include <gmodule.h>
#include "thinice_rc_style.h"
#include "thinice_style.h"

GE_EXPORT void
theme_init (GTypeModule *module)
{
  thinice_rc_style_register_types (module);
  thinice_style_register_types (module);
}

GE_EXPORT void
theme_exit (void)
{
}

GE_EXPORT GtkRcStyle *
theme_create_rc_style (void)
{
  void *ptr;
  ptr = GTK_RC_STYLE (g_object_new (THINICE_TYPE_RC_STYLE, NULL));  
  return (GtkRcStyle *)ptr;
}
