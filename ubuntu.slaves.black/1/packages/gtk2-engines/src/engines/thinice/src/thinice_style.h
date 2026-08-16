#include <gtk/gtk.h>
#include "ge-support.h"

typedef struct _ThiniceStyle ThiniceStyle;
typedef struct _ThiniceStyleClass ThiniceStyleClass;

#define THINICE_TYPE_STYLE              (thinice_style_get_type ())
#define THINICE_STYLE(object)           (G_TYPE_CHECK_INSTANCE_CAST ((object), THINICE_TYPE_STYLE, ThiniceStyle))
#define THINICE_STYLE_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), THINICE_TYPE_STYLE, ThiniceStyleClass))
#define THINICE_IS_STYLE(object)        (G_TYPE_CHECK_INSTANCE_TYPE ((object), THINICE_TYPE_STYLE))
#define THINICE_IS_STYLE_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), THINICE_TYPE_STYLE))
#define THINICE_STYLE_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), THINICE_TYPE_STYLE, ThiniceStyleClass))

struct _ThiniceStyle
{
  GtkStyle parent_instance;
  CairoColorCube color_cube;
};

struct _ThiniceStyleClass
{
  GtkStyleClass parent_class;
};

GE_INTERNAL void  thinice_style_register_types (GTypeModule *module);
GE_INTERNAL GType thinice_style_get_type       (void);


