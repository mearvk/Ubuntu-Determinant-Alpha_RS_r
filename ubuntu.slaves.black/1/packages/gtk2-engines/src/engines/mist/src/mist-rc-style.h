#include <gtk/gtk.h>
#include "ge-support.h"

typedef struct _MistRcStyle MistRcStyle;
typedef struct _MistRcStyleClass MistRcStyleClass;

#define MIST_TYPE_RC_STYLE              (mist_rc_style_get_type ())
#define MIST_RC_STYLE(object)           (G_TYPE_CHECK_INSTANCE_CAST ((object), MIST_TYPE_RC_STYLE, MistRcStyle))
#define MIST_RC_STYLE_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), MIST_TYPE_RC_STYLE, MistRcStyleClass))
#define MIST_IS_RC_STYLE(object)        (G_TYPE_CHECK_INSTANCE_TYPE ((object), MIST_TYPE_RC_STYLE))
#define MIST_IS_RC_STYLE_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), MIST_TYPE_RC_STYLE))
#define MIST_RC_STYLE_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), MIST_TYPE_RC_STYLE, MistRcStyleClass))

struct _MistRcStyle {
	GtkRcStyle parent_instance;
};

struct _MistRcStyleClass {
	GtkRcStyleClass parent_class;
};

GE_INTERNAL void  mist_rc_style_register_types (GTypeModule *module);
GE_INTERNAL GType mist_rc_style_get_type       (void);

