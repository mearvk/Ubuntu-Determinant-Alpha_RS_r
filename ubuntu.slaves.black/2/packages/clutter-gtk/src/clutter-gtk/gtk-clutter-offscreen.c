/*
 * gtkclutteroffscreen.c
 */

#include "config.h"

#include <gtk/gtk.h>

#include "gtk-clutter-embed.h"
#include "gtk-clutter-offscreen.h"
#include "gtk-clutter-actor-internal.h"

G_DEFINE_TYPE (GtkClutterOffscreen, _gtk_clutter_offscreen, GTK_TYPE_BIN);

void _gtk_clutter_embed_set_child_active (GtkClutterEmbed *embed,
					  GtkWidget *child,
					  gboolean active);

static void
gtk_clutter_offscreen_add (GtkContainer *container,
                           GtkWidget    *child)
{
  GtkClutterOffscreen *offscreen = GTK_CLUTTER_OFFSCREEN (container);

  GTK_CONTAINER_CLASS (_gtk_clutter_offscreen_parent_class)->add (container, child);

  if (offscreen->actor != NULL &&
      clutter_actor_is_visible (offscreen->actor))
    {
      /* force a relayout */
      clutter_actor_queue_relayout (offscreen->actor);
    }
}

static void
gtk_clutter_offscreen_remove (GtkContainer *container,
                              GtkWidget    *child)
{
  GtkClutterOffscreen *offscreen = GTK_CLUTTER_OFFSCREEN (container);

  GTK_CONTAINER_CLASS (_gtk_clutter_offscreen_parent_class)->remove (container, child);

  if (offscreen->actor != NULL &&
      clutter_actor_is_visible (offscreen->actor))
    {
      /* force a relayout */
      clutter_actor_queue_relayout (offscreen->actor);
    }
}

static void
gtk_clutter_offscreen_check_resize (GtkContainer *container)
{
  GtkClutterOffscreen *offscreen = GTK_CLUTTER_OFFSCREEN (container);

  /* queue a relayout only if we're not in the middle of an
   * allocation
   */
  if (offscreen->actor != NULL && !offscreen->in_allocation)
    clutter_actor_queue_relayout (offscreen->actor);
}

static void
offscreen_window_to_parent (GdkWindow           *offscreen_window,
                            double               offscreen_x,
                            double               offscreen_y,
                            double              *parent_x,
                            double              *parent_y,
                            GtkClutterOffscreen *offscreen)
{
  ClutterVertex point, vertex;

  point.x = offscreen_x;
  point.y = offscreen_y;
  point.z = 0;
  clutter_actor_apply_transform_to_point (offscreen->actor, &point, &vertex);
  *parent_x = vertex.x;
  *parent_y = vertex.y;
}

static void
offscreen_window_from_parent (GdkWindow           *window,
                              double               parent_x,
                              double               parent_y,
                              double              *offscreen_x,
                              double              *offscreen_y,
                              GtkClutterOffscreen *offscreen)
{
  gfloat x, y;

  if (clutter_actor_transform_stage_point (offscreen->actor,
                                           parent_x,
                                           parent_y,
                                           &x, &y))
    {
      *offscreen_x = x;
      *offscreen_y = y;
    }
  else
    {
      /* Could't transform. What the heck do we do now? */
      *offscreen_x = parent_x;
      *offscreen_y = parent_y;
    }
}

static void
gtk_clutter_offscreen_realize (GtkWidget *widget)
{
  GtkClutterOffscreen *offscreen = GTK_CLUTTER_OFFSCREEN (widget);
  GtkAllocation allocation;
  GtkStyleContext *style_context;
  GdkWindow *window;
  GdkWindowAttr attributes;
  gint attributes_mask;
  guint border_width;
  GtkWidget *parent, *child;
  GdkScreen *screen;

  gtk_widget_set_realized (widget, TRUE);

  border_width = gtk_container_get_border_width (GTK_CONTAINER (widget));

  gtk_widget_get_allocation (widget, &allocation);

  attributes.x = allocation.x + border_width;
  attributes.y = allocation.y + border_width;
  attributes.width = allocation.width - 2 * border_width;
  attributes.height = allocation.height - 2 * border_width;
  attributes.window_type = GDK_WINDOW_OFFSCREEN;
  attributes.event_mask = gtk_widget_get_events (widget)
                        | GDK_EXPOSURE_MASK;
  attributes.visual = gtk_widget_get_visual (widget);
  attributes.wclass = GDK_INPUT_OUTPUT;

  attributes_mask = GDK_WA_X | GDK_WA_Y | GDK_WA_VISUAL;

  parent = gtk_widget_get_parent (widget);
  screen = gtk_widget_get_screen (widget);

  window = gdk_window_new (gdk_screen_get_root_window (screen),
			   &attributes,
                           attributes_mask);
  gtk_widget_set_window (widget, window);
  gdk_window_set_user_data (window, widget);

  gdk_offscreen_window_set_embedder (gtk_widget_get_window (parent),
                                     window);
  g_signal_connect (window, "to-embedder",
		    G_CALLBACK (offscreen_window_to_parent),
                    widget);
  g_signal_connect (window, "from-embedder",
		    G_CALLBACK (offscreen_window_from_parent),
                    widget);

  child = gtk_bin_get_child (GTK_BIN (widget));
  if (child != NULL)
    gtk_widget_set_parent_window (child, window);

  style_context = gtk_widget_get_style_context (widget);
  gtk_style_context_set_background (style_context, window);

  if (offscreen->active)
    _gtk_clutter_embed_set_child_active (GTK_CLUTTER_EMBED (parent),
					 widget, TRUE);
}

static void
gtk_clutter_offscreen_unrealize (GtkWidget *widget)
{
  GtkClutterOffscreen *offscreen = GTK_CLUTTER_OFFSCREEN (widget);

  if (offscreen->active)
    _gtk_clutter_embed_set_child_active (GTK_CLUTTER_EMBED (gtk_widget_get_parent (widget)),
					 widget, FALSE);

  GTK_WIDGET_CLASS (_gtk_clutter_offscreen_parent_class)->unrealize (widget);
}

static void
gtk_clutter_offscreen_get_preferred_width (GtkWidget *widget,
                                           gint      *minimum,
                                           gint      *natural)
{
  GtkBin *bin = GTK_BIN (widget);
  GtkWidget *child;
  gint border_width;

  border_width = gtk_container_get_border_width (GTK_CONTAINER (widget));

  *minimum = border_width * 2;
  *natural = border_width * 2;

  child = gtk_bin_get_child (bin);

  if (child != NULL && gtk_widget_get_visible (child))
    {
      gint child_min, child_nat;

      gtk_widget_get_preferred_width (child, &child_min, &child_nat);

      *minimum += child_min;
      *natural += child_nat;
    }
}

static void
gtk_clutter_offscreen_get_preferred_height (GtkWidget *widget,
                                            gint      *minimum,
                                            gint      *natural)
{
  GtkBin *bin = GTK_BIN (widget);
  GtkWidget *child;
  gint border_width;

  border_width = gtk_container_get_border_width (GTK_CONTAINER (widget));

  *minimum = border_width * 2;
  *natural = border_width * 2;

  child = gtk_bin_get_child (bin);

  if (child != NULL && gtk_widget_get_visible (child))
    {
      gint child_min, child_nat;

      gtk_widget_get_preferred_height (child, &child_min, &child_nat);

      *minimum += child_min;
      *natural += child_nat;
    }
}

static void
gtk_clutter_offscreen_size_allocate (GtkWidget     *widget,
				     GtkAllocation *allocation)
{
  GtkAllocation old_allocation;
  GtkBin *bin = GTK_BIN (widget);
  GtkWidget *child;
  gint border_width;

  gtk_widget_get_allocation (widget, &old_allocation);

  /* some widgets call gtk_widget_queue_resize() which triggers a
   * size request/allocate cycle.
   *
   * Calling gdk_window_move_resize() triggers an expose-event of the entire
   * widget tree, so we only want to do it if the allocation has changed in
   * some way, otherwise we can just ignore it.
   */
  if (gtk_widget_get_realized (widget) &&
      (allocation->x != old_allocation.x ||
       allocation->y != old_allocation.y ||
       allocation->width != old_allocation.width ||
       allocation->height != old_allocation.height))
    {
      gdk_window_move_resize (gtk_widget_get_window (widget),
                              0, 0,
                              allocation->width,
                              allocation->height);
    }

  gtk_widget_set_allocation (widget, allocation);

  border_width = gtk_container_get_border_width (GTK_CONTAINER (widget));

  child = gtk_bin_get_child (bin);

  if (child != NULL && gtk_widget_get_visible (child))
    {
      GtkAllocation  child_alloc;

      child_alloc.x = border_width;
      child_alloc.y = border_width;
      child_alloc.width = allocation->width - 2 * border_width;
      child_alloc.height = allocation->height - 2 * border_width;

      gtk_widget_size_allocate (child, &child_alloc);
    }

  gtk_widget_queue_draw (widget);
}

static gboolean
gtk_clutter_offscreen_damage (GtkWidget      *widget,
			      GdkEventExpose *event)
{
  GtkClutterOffscreen *offscreen = GTK_CLUTTER_OFFSCREEN (widget);

  _gtk_clutter_actor_update (GTK_CLUTTER_ACTOR (offscreen->actor),
                             event->area.x,
                             event->area.y,
                             event->area.width,
                             event->area.height);

  return TRUE;
}

static void
_gtk_clutter_offscreen_class_init (GtkClutterOffscreenClass *klass)
{
  GtkWidgetClass *widget_class = GTK_WIDGET_CLASS (klass);
  GtkContainerClass *container_class = GTK_CONTAINER_CLASS (klass);

  widget_class->realize = gtk_clutter_offscreen_realize;
  widget_class->unrealize = gtk_clutter_offscreen_unrealize;
  widget_class->get_preferred_width = gtk_clutter_offscreen_get_preferred_width;
  widget_class->get_preferred_height = gtk_clutter_offscreen_get_preferred_height;
  widget_class->size_allocate = gtk_clutter_offscreen_size_allocate;

  container_class->add = gtk_clutter_offscreen_add;
  container_class->remove = gtk_clutter_offscreen_remove;
  container_class->check_resize = gtk_clutter_offscreen_check_resize;

  g_signal_override_class_handler ("damage-event",
				   GTK_CLUTTER_TYPE_OFFSCREEN,
				   G_CALLBACK (gtk_clutter_offscreen_damage));
}

static void
_gtk_clutter_offscreen_init (GtkClutterOffscreen *offscreen)
{
  gtk_widget_set_has_window (GTK_WIDGET (offscreen), TRUE);

  G_GNUC_BEGIN_IGNORE_DEPRECATIONS
  gtk_container_set_resize_mode (GTK_CONTAINER (offscreen), GTK_RESIZE_IMMEDIATE);
  G_GNUC_END_IGNORE_DEPRECATIONS

  offscreen->active = TRUE;
}

GtkWidget *
_gtk_clutter_offscreen_new (ClutterActor *actor)
{
  GtkClutterOffscreen *offscreen;

  offscreen = g_object_new (GTK_CLUTTER_TYPE_OFFSCREEN, NULL);
  offscreen->actor = actor; /* Back pointer, actor owns widget */

  return GTK_WIDGET (offscreen);
}

void
_gtk_clutter_offscreen_set_active (GtkClutterOffscreen *offscreen,
                                   gboolean             active)
{
  GtkWidget *parent;

  active = !!active;

  if (offscreen->active != active)
    {
      offscreen->active = active;
      parent = gtk_widget_get_parent (GTK_WIDGET (offscreen));
      if (parent != NULL)
	_gtk_clutter_embed_set_child_active (GTK_CLUTTER_EMBED (parent),
					     GTK_WIDGET (offscreen),
					     active);
    }
}

void
_gtk_clutter_offscreen_set_in_allocation (GtkClutterOffscreen *offscreen,
                                          gboolean             in_allocation)
{
  in_allocation = !!in_allocation;

  offscreen->in_allocation = in_allocation;
}

cairo_surface_t *
_gtk_clutter_offscreen_get_surface (GtkClutterOffscreen *offscreen)
{
  return gdk_offscreen_window_get_surface (gtk_widget_get_window (GTK_WIDGET (offscreen)));
}
