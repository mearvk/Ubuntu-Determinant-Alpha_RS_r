#ifndef CRUX_THEME_H
#define CRUX_THEME_H

#include <ge-support.h>

G_BEGIN_DECLS

GE_EXPORT void theme_init (GTypeModule *module);
GE_EXPORT void theme_exit (void);

GE_EXPORT GtkRcStyle *theme_create_rc_style (void);

GE_EXPORT const gchar* g_module_check_init (GModule *module);
    
G_END_DECLS

#endif
