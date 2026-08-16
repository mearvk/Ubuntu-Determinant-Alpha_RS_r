#ifndef CRUX_STYLE_H
#define CRUX_STYLE_H

#include <gtk/gtk.h>
#include <gmodule.h>

#include "crux-draw.h"

G_BEGIN_DECLS

GE_INTERNAL extern GType crux_type_style;

#define CRUX_TYPE_STYLE              (crux_style_get_type ())
#define CRUX_STYLE(object)           (G_TYPE_CHECK_INSTANCE_CAST ((object), CRUX_TYPE_STYLE, CruxStyle))
#define CRUX_STYLE_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), CRUX_TYPE_STYLE, CruxStyleClass))
#define CRUX_IS_STYLE(object)        (G_TYPE_CHECK_INSTANCE_TYPE ((object), CRUX_TYPE_STYLE))
#define CRUX_IS_STYLE_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), CRUX_TYPE_STYLE))
#define CRUX_STYLE_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), CRUX_TYPE_STYLE, CruxStyleClass))

typedef struct _CruxStyle CruxStyle;
typedef struct _CruxStyleClass CruxStyleClass;

struct _CruxStyle
{
  GtkStyle parent_instance;
};

struct _CruxStyleClass
{
  GtkStyleClass parent_class;

};

GE_INTERNAL void  crux_style_register_types (GTypeModule *module);
GE_INTERNAL GType crux_style_get_type       (void);

G_END_DECLS

#endif
