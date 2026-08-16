#include <gmodule.h>

#include "mist-rc-style.h"
#include "mist-style.h"

GE_EXPORT void
theme_init (GTypeModule *module)
{
	mist_rc_style_register_types (module);
	mist_style_register_types (module);
}

GE_EXPORT void
theme_exit (void)
{
}

GE_EXPORT GtkRcStyle *
theme_create_rc_style (void)
{
  void *ptr;
  ptr = GTK_RC_STYLE (g_object_new (MIST_TYPE_RC_STYLE, NULL));  
  return (GtkRcStyle *)ptr;
}
