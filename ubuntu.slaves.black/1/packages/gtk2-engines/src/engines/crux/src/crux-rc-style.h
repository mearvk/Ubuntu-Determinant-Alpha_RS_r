#ifndef CRUX_RC_STYLE_H
#define CRUX_RC_STYLE_H

#include <gtk/gtk.h>
#include "ge-support.h"

G_BEGIN_DECLS

#define CRUX_TYPE_RC_STYLE              (crux_rc_style_get_type ())
#define CRUX_RC_STYLE(object)           (G_TYPE_CHECK_INSTANCE_CAST ((object), CRUX_TYPE_RC_STYLE, CruxRcStyle))
#define CRUX_RC_STYLE_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), CRUX_TYPE_RC_STYLE, CruxRcStyleClass))
#define CRUX_IS_RC_STYLE(object)        (G_TYPE_CHECK_INSTANCE_TYPE ((object), CRUX_TYPE_RC_STYLE))
#define CRUX_IS_RC_STYLE_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), CRUX_TYPE_RC_STYLE))
#define CRUX_RC_STYLE_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), CRUX_TYPE_RC_STYLE, CruxRcStyleClass))

typedef struct _CruxRcStyle CruxRcStyle;
typedef struct _CruxRcStyleClass CruxRcStyleClass;

struct _CruxRcStyle
{
  GtkRcStyle parent_instance;
};

struct _CruxRcStyleClass
{
  GtkRcStyleClass parent_class;
};

GE_INTERNAL void  crux_rc_style_register_types (GTypeModule *engine);
GE_INTERNAL GType crux_rc_style_get_type       (void);

G_END_DECLS

#endif
