#ifndef __GTK_CLUTTER_OFFSCREEN_H__
#define __GTK_CLUTTER_OFFSCREEN_H__

#include <cairo/cairo.h>
#include <gtk/gtk.h>
#include <clutter/clutter.h>

G_BEGIN_DECLS

#define GTK_CLUTTER_TYPE_OFFSCREEN              (_gtk_clutter_offscreen_get_type ())
#define GTK_CLUTTER_OFFSCREEN(obj)              (G_TYPE_CHECK_INSTANCE_CAST ((obj), GTK_CLUTTER_TYPE_OFFSCREEN, GtkClutterOffscreen))
#define GTK_CLUTTER_OFFSCREEN_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), GTK_CLUTTER_TYPE_OFFSCREEN, GtkClutterOffscreenClass))
#define GTK_CLUTTER_IS_OFFSCREEN(obj)           (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GTK_CLUTTER_TYPE_OFFSCREEN))
#define GTK_CLUTTER_IS_OFFSCREEN_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), GTK_CLUTTER_TYPE_OFFSCREEN))
#define GTK_CLUTTER_OFFSCREEN_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), GTK_CLUTTER_TYPE_OFFSCREEN, GtkClutterOffscreenClass))

typedef struct _GtkClutterOffscreen	  GtkClutterOffscreen;
typedef struct _GtkClutterOffscreenClass  GtkClutterOffscreenClass;

struct _GtkClutterOffscreen
{
  GtkBin bin;

  ClutterActor *actor;

  guint active : 1;
  guint in_allocation : 1;
};

struct _GtkClutterOffscreenClass
{
  GtkBinClass parent_class;
};

GType	   _gtk_clutter_offscreen_get_type   (void) G_GNUC_CONST;
GtkWidget *_gtk_clutter_offscreen_new        (ClutterActor        *actor);
void       _gtk_clutter_offscreen_set_active (GtkClutterOffscreen *offscreen,
                                              gboolean             active);
void       _gtk_clutter_offscreen_set_in_allocation (GtkClutterOffscreen *offscreen,
                                                     gboolean             in_allocation);
cairo_surface_t *_gtk_clutter_offscreen_get_surface (GtkClutterOffscreen *offscreen);

G_END_DECLS

#endif /* __GTK_CLUTTER_OFFSCREEN_H__ */
