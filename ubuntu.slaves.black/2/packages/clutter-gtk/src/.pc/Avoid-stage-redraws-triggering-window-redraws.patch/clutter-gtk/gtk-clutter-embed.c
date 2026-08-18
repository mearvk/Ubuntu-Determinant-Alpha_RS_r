/* gtk-clutter-embed.c: Embeddable ClutterStage
 *
 * Copyright (C) 2007 OpenedHand
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library. If not see <http://www.fsf.org/licensing>.
 *
 * Authors:
 *   Iain Holmes  <iain@openedhand.com>
 *   Emmanuele Bassi  <ebassi@openedhand.com>
 */

/**
 * SECTION:gtk-clutter-embed
 * @Title: GtkClutterEmbed
 * @short_description: Widget for embedding a Clutter scene
 * @See_Also: #ClutterStage
 *
 * #GtkClutterEmbed is a GTK+ widget embedding a #ClutterStage inside
 * a GTK+ application.
 *
 * By using a #GtkClutterEmbed widget is possible to build, show and
 * interact with a scene built using Clutter inside a GTK+ application.
 *
 * ## Event handling with GtkClutterEmbed
 *
 * Due to re-entrancy concerns, you should not use GTK event-related
 * API from within event handling signals emitted by Clutter actors
 * inside a #GtkClutterEmbed.
 *
 * Event-related API, like the GTK drag and drop functions, or the
 * GTK grab ones, cause events to be processed inside the GDK event
 * loop; #GtkClutterEmbed and the Clutter event loop may use those
 * events to generate Clutter events, and thus emit signals on
 * #ClutterActors. If you use the event-related signals of a
 * #ClutterActor to call the GTK API, one of the two event loops
 * will try to re-enter into each other, and either cause a crash
 * or simply block your application.
 *
 * To avoid this behavior, you can either:
 *
 *  - only use GTK+ event handling signals to call event-related
 *    GTK functions
 *  - let the main loop re-enter, by calling event-related GTK
 *    functions from within an idle or a timeout callback
 *
 * You should also make sure you're not using GTK widgets that call
 * event-related GTK API, like the grab functions in a #GtkMenu, in
 * response to Clutter actor events.
 *
 * ## Using GtkClutterEmbed as a container
 *
 * Though #GtkClutterEmbed is a #GtkContainer subclass, it is not a
 * real GTK+ container; #GtkClutterEmbed is required to implement the
 * #GtkContainer virtual functions in order to embed a #GtkWidget
 * through the #GtkClutterActor class. Calling gtk_container_add()
 * on a #GtkClutterEmbed will trigger an assertion. It is strongly
 * advised not to override the #GtkContainer implementation when
 * subclassing #GtkClutterEmbed, to avoid breaking internal state.
 */

#include "config.h"

#include <math.h>
#include <string.h>
#include "gtk-clutter-embed.h"
#include "gtk-clutter-offscreen.h"
#include "gtk-clutter-actor.h"

#include <glib-object.h>

#include <gdk/gdk.h>

#if defined(CLUTTER_WINDOWING_X11)
#include <clutter/x11/clutter-x11.h>
#endif

#if defined(CLUTTER_WINDOWING_GDK)
#include <clutter/gdk/clutter-gdk.h>
#endif

#if defined(CLUTTER_WINDOWING_WIN32)
#include <clutter/win32/clutter-win32.h>
#endif

#if defined(CLUTTER_WINDOWING_WAYLAND)
#include <clutter/wayland/clutter-wayland.h>
#endif

#if defined(GDK_WINDOWING_X11)
#include <gdk/gdkx.h>
#endif

#if defined(GDK_WINDOWING_WIN32)
#include <gdk/gdkwin32.h>
#endif

#if defined(GDK_WINDOWING_WAYLAND)
#include <gdk/gdkwayland.h>
#endif

struct _GtkClutterEmbedPrivate
{
  ClutterActor *stage;

  GList *children;
  int n_active_children;

  guint queue_redraw_id;
  guint queue_relayout_id;

  guint geometry_changed : 1;
  guint use_layout_size : 1;

#if defined(GDK_WINDOWING_WAYLAND) && defined(CLUTTER_WINDOWING_WAYLAND)
  struct wl_subcompositor *subcompositor;
  struct wl_surface *clutter_surface;
  struct wl_subsurface *subsurface;
#endif
};

static gint num_filter = 0;

enum
{
  PROP_0,

  PROP_USE_LAYOUT_SIZE
};

G_DEFINE_TYPE_WITH_PRIVATE (GtkClutterEmbed, gtk_clutter_embed, GTK_TYPE_CONTAINER)

static void
gtk_clutter_embed_send_configure (GtkClutterEmbed *embed)
{
  GtkWidget *widget;
  GtkAllocation allocation;
  GdkEvent *event = gdk_event_new (GDK_CONFIGURE);

  widget = GTK_WIDGET (embed);
  gtk_widget_get_allocation (widget, &allocation);

  event->configure.window = g_object_ref (gtk_widget_get_window (widget));
  event->configure.send_event = TRUE;
  event->configure.x = allocation.x;
  event->configure.y = allocation.y;
  event->configure.width = allocation.width;
  event->configure.height = allocation.height;

  gtk_widget_event (widget, event);
  gdk_event_free (event);
}

#if defined(GDK_WINDOWING_WAYLAND) && defined(CLUTTER_WINDOWING_WAYLAND)
static void
gtk_clutter_embed_ensure_surface (GtkClutterEmbed *embed)
{
  GtkClutterEmbedPrivate *priv = embed->priv;

  if (priv->subcompositor && !priv->clutter_surface)
    {
      GdkDisplay *display;
      struct wl_compositor *compositor;

      display = gtk_widget_get_display (GTK_WIDGET (embed));
      compositor = gdk_wayland_display_get_wl_compositor (display);
      priv->clutter_surface = wl_compositor_create_surface (compositor);
    }
}

static void
gtk_clutter_embed_ensure_subsurface (GtkClutterEmbed *embed)
{
  GtkClutterEmbedPrivate *priv;
  GtkWidget *widget;
  struct wl_surface *gtk_surface;
  GdkWindow *window;
  gint x, y;

  widget = GTK_WIDGET (embed);
  priv = embed->priv;

  if (priv->subsurface)
    return;

  window = gtk_widget_get_window (widget);
  gtk_surface = gdk_wayland_window_get_wl_surface (gdk_window_get_toplevel (window));
  priv->subsurface =
    wl_subcompositor_get_subsurface (priv->subcompositor,
                                     priv->clutter_surface,
                                     gtk_surface);

  gdk_window_get_origin (window, &x, &y);
  wl_subsurface_set_position (priv->subsurface, x, y);
  wl_subsurface_set_desync (priv->subsurface);
}
#endif

static void
gtk_clutter_embed_ensure_stage_realized (GtkClutterEmbed *embed)
{
  GtkClutterEmbedPrivate *priv = GTK_CLUTTER_EMBED (embed)->priv;

  if (!gtk_widget_get_realized (GTK_WIDGET (embed)))
    return;

  if (!clutter_actor_is_realized (priv->stage))
    {
      GdkWindow *window = gtk_widget_get_window (GTK_WIDGET (embed));

#if defined(CLUTTER_WINDOWING_GDK)
      if (clutter_check_windowing_backend (CLUTTER_WINDOWING_GDK))
        {
          clutter_gdk_set_stage_foreign (CLUTTER_STAGE (priv->stage), window);
        }
      else
#endif
#if defined(GDK_WINDOWING_X11) && defined(CLUTTER_WINDOWING_X11)
      if (clutter_check_windowing_backend (CLUTTER_WINDOWING_X11) &&
          GDK_IS_X11_WINDOW (window))
        {
          clutter_x11_set_stage_foreign (CLUTTER_STAGE (priv->stage),
                                         GDK_WINDOW_XID (window));
        }
      else
#endif
#if defined(GDK_WINDOWING_WIN32) && defined(CLUTTER_WINDOWING_WIN32)
      if (clutter_check_windowing_backend (CLUTTER_WINDOWING_WIN32) &&
          GDK_IS_WIN32_WINDOW (window))
        {
          clutter_win32_set_stage_foreign (CLUTTER_STAGE (priv->stage),
                                           GDK_WINDOW_HWND (window));
        }
      else
#endif
#if defined(GDK_WINDOWING_WAYLAND) && defined (CLUTTER_WINDOWING_WAYLAND)
      if (clutter_check_windowing_backend (CLUTTER_WINDOWING_WAYLAND) &&
          GDK_IS_WAYLAND_WINDOW (window))
        {
          gtk_clutter_embed_ensure_surface (embed);
          clutter_wayland_stage_set_wl_surface (CLUTTER_STAGE (priv->stage),
                                                priv->clutter_surface);
        }
      else
#endif
        {
          g_warning ("No backend found!");
        }

      clutter_actor_realize (priv->stage);
    }

  /* A stage cannot really be unmapped because it is the top of
   * Clutter's scene tree. So if the Gtk embedder is mapped, we
   * translate this as visible for the ClutterStage. */
  if (gtk_widget_get_mapped (GTK_WIDGET (embed)))
    clutter_actor_show (priv->stage);

  clutter_actor_queue_relayout (priv->stage);

  gtk_clutter_embed_send_configure (embed);

#if defined(GDK_WINDOWING_WAYLAND) && defined (CLUTTER_WINDOWING_WAYLAND)
  if (clutter_check_windowing_backend (CLUTTER_WINDOWING_WAYLAND))
    gtk_clutter_embed_ensure_subsurface (embed);
#endif
}

static void
gtk_clutter_embed_stage_unrealize (GtkClutterEmbed *embed)
{
  GtkClutterEmbedPrivate *priv = embed->priv;

#if defined(GDK_WINDOWING_WAYLAND) && defined(CLUTTER_WINDOWING_WAYLAND)
  g_clear_pointer (&priv->subsurface, wl_subsurface_destroy);
  g_clear_pointer (&priv->clutter_surface, wl_surface_destroy);
#endif

  /* gtk may emit an unmap signal after dispose, so it's possible we
   * may have already disposed priv->stage. */
  if (priv->stage != NULL)
    {
      clutter_actor_hide (priv->stage);
      clutter_actor_unrealize (priv->stage);
    }
}

static void
on_stage_queue_redraw (ClutterStage *stage,
                       ClutterActor *origin,
                       gpointer      user_data)
{
  GtkWidget *embed = user_data;
  GtkClutterEmbedPrivate *priv = GTK_CLUTTER_EMBED (embed)->priv;

  if (priv->n_active_children > 0)
    priv->geometry_changed = TRUE;

  gtk_widget_queue_draw (embed);
}

static void
on_stage_queue_relayout (ClutterStage *stage,
			 gpointer      user_data)
{
  GtkWidget *embed = user_data;
  GtkClutterEmbedPrivate *priv = GTK_CLUTTER_EMBED (embed)->priv;

  if (priv->use_layout_size)
    gtk_widget_queue_resize (embed);
}

static void
gtk_clutter_embed_dispose (GObject *gobject)
{
  GtkClutterEmbedPrivate *priv = GTK_CLUTTER_EMBED (gobject)->priv;


  if (priv->stage)
    {
      if (priv->queue_redraw_id)
        g_signal_handler_disconnect (priv->stage, priv->queue_redraw_id);

      if (priv->queue_relayout_id)
        g_signal_handler_disconnect (priv->stage, priv->queue_relayout_id);

      priv->queue_redraw_id = 0;
      priv->queue_relayout_id = 0;

      clutter_actor_destroy (priv->stage);
      priv->stage = NULL;

#if defined(GDK_WINDOWING_WAYLAND) && defined(CLUTTER_WINDOWING_WAYLAND)
      g_clear_pointer (&priv->subsurface, wl_subsurface_destroy);
#endif
    }

  G_OBJECT_CLASS (gtk_clutter_embed_parent_class)->dispose (gobject);
}

static void
gtk_clutter_embed_show (GtkWidget *widget)
{
  GTK_WIDGET_CLASS (gtk_clutter_embed_parent_class)->show (widget);

  gtk_clutter_embed_ensure_stage_realized (GTK_CLUTTER_EMBED (widget));
}

static GdkWindow *
pick_embedded_child (GdkWindow       *offscreen_window,
                     double           widget_x,
                     double           widget_y,
                     GtkClutterEmbed *embed)
{
  GtkClutterEmbedPrivate *priv = embed->priv;
  ClutterActor *a;
  GtkWidget *widget;

  a = clutter_stage_get_actor_at_pos (CLUTTER_STAGE (priv->stage),
				      CLUTTER_PICK_REACTIVE,
				      widget_x, widget_y);
  if (GTK_CLUTTER_IS_ACTOR (a))
    {
      widget = gtk_clutter_actor_get_widget (GTK_CLUTTER_ACTOR (a));

      if (GTK_CLUTTER_OFFSCREEN (widget)->active)
	return gtk_widget_get_window (widget);
    }

  return NULL;
}

static GdkFilterReturn
gtk_clutter_filter_func (GdkXEvent *native_event,
                         GdkEvent  *event         G_GNUC_UNUSED,
                         gpointer   user_data     G_GNUC_UNUSED)
{
#if defined(CLUTTER_WINDOWING_X11)
  if (clutter_check_windowing_backend (CLUTTER_WINDOWING_X11))
    {
      XEvent *xevent = native_event;

      /* let Clutter handle all events coming from the windowing system */
      clutter_x11_handle_event (xevent);
    }
  else
#endif
#if defined(CLUTTER_WINDOWING_WIN32)
  if (clutter_check_windowing_backend (CLUTTER_WINDOWING_WIN32))
    {
      MSG *msg = native_event;

      clutter_win32_handle_event (msg);
    }
  else
#endif
    g_critical ("Unsuppored Clutter backend");

  /* we don't care if Clutter handled the event: we want GDK to continue
   * the event processing as usual
   */
  return GDK_FILTER_CONTINUE;
}

static gboolean
gtk_clutter_embed_draw (GtkWidget *widget, cairo_t *cr)
{
#if defined(CLUTTER_WINDOWING_GDK)
  GtkClutterEmbedPrivate *priv = GTK_CLUTTER_EMBED (widget)->priv;

  if (clutter_check_windowing_backend (CLUTTER_WINDOWING_GDK))
    clutter_stage_ensure_redraw (CLUTTER_STAGE (priv->stage));
#endif

  return GTK_WIDGET_CLASS (gtk_clutter_embed_parent_class)->draw (widget, cr);
}

static void
gtk_clutter_embed_realize (GtkWidget *widget)
{
  GtkAllocation allocation;
  GtkStyleContext *style_context;
  GdkWindow *window;
  GdkWindowAttr attributes;
  gint attributes_mask;
  gint border_width;

#if defined(CLUTTER_WINDOWING_GDK)
  if (clutter_check_windowing_backend (CLUTTER_WINDOWING_GDK))
    {
      GdkVisual *visual = clutter_gdk_get_visual ();
      gtk_widget_set_visual (widget, visual);
    }
#endif
#if defined(GDK_WINDOWING_X11) && defined(CLUTTER_WINDOWING_X11)
  if (clutter_check_windowing_backend (CLUTTER_WINDOWING_X11))
    {
      const XVisualInfo *xvinfo;
      GdkVisual *visual;

      /* We need to use the colormap from the Clutter visual, since
       * the visual is tied to the GLX context
       */
      xvinfo = clutter_x11_get_visual_info ();
      if (xvinfo == None)
        {
          g_critical ("Unable to retrieve the XVisualInfo from Clutter");
          return;
        }

      visual = gdk_x11_screen_lookup_visual (gtk_widget_get_screen (widget),
                                             xvinfo->visualid);
      gtk_widget_set_visual (widget, visual);
    }
#endif

  gtk_widget_set_realized (widget, TRUE);

  gtk_widget_get_allocation (widget, &allocation);
  border_width = gtk_container_get_border_width (GTK_CONTAINER (widget));

  attributes.window_type = GDK_WINDOW_CHILD;
  attributes.x = allocation.x + border_width;
  attributes.y = allocation.y + border_width;
  attributes.width = allocation.width - 2 * border_width;
  attributes.height = allocation.height - 2 * border_width;
  attributes.wclass = GDK_INPUT_OUTPUT;
  attributes.visual = gtk_widget_get_visual (widget);

  /* NOTE: GDK_MOTION_NOTIFY above should be safe as Clutter does its own
   *       throttling.
   */
  attributes.event_mask = gtk_widget_get_events (widget)
                        | GDK_EXPOSURE_MASK
                        | GDK_SCROLL_MASK
                        | GDK_BUTTON_PRESS_MASK
                        | GDK_BUTTON_RELEASE_MASK
                        | GDK_KEY_PRESS_MASK
                        | GDK_KEY_RELEASE_MASK
                        | GDK_POINTER_MOTION_MASK
                        | GDK_ENTER_NOTIFY_MASK
                        | GDK_LEAVE_NOTIFY_MASK
                        | GDK_TOUCH_MASK
                        | GDK_SMOOTH_SCROLL_MASK
                        | GDK_STRUCTURE_MASK;

  attributes_mask = GDK_WA_X | GDK_WA_Y | GDK_WA_VISUAL;

  window = gdk_window_new (gtk_widget_get_parent_window (widget),
                           &attributes,
                           attributes_mask);

  gtk_widget_set_window (widget, window);
  gdk_window_set_user_data (window, widget);

  /* this does the translation of the event from Clutter to GDK
   * we embedding a GtkWidget inside a GtkClutterActor
   */
  g_signal_connect (window, "pick-embedded-child",
		    G_CALLBACK (pick_embedded_child),
                    widget);

  style_context = gtk_widget_get_style_context (widget);
  gtk_style_context_set_background (style_context, window);

#if defined(GDK_WINDOWING_X11) && defined(CLUTTER_WINDOWING_X11)
  if (clutter_check_windowing_backend (CLUTTER_WINDOWING_X11) &&
      GDK_IS_X11_WINDOW (window))
    {
      if (num_filter == 0)
        gdk_window_add_filter (NULL, gtk_clutter_filter_func, widget);
      num_filter++;
    }
  else
#endif
#if defined(GDK_WINDOWING_WIN32) && defined(CLUTTER_WINDOWING_WIN32)
  if (clutter_check_windowing_backend (CLUTTER_WINDOWING_WIN32) &&
      GDK_IS_WIN32_WINDOW (window))
    {
      if (num_filter == 0)
        gdk_window_add_filter (NULL, gtk_clutter_filter_func, widget);
      num_filter++;
    }
  else
#endif
    {
      /* Nothing to do. */
    }

  gtk_clutter_embed_ensure_stage_realized (GTK_CLUTTER_EMBED (widget));
}

static void
gtk_clutter_embed_unrealize (GtkWidget *widget)
{
  GtkClutterEmbed *embed = GTK_CLUTTER_EMBED (widget);

  if (num_filter > 0)
    {
      num_filter--;
      if (num_filter == 0)
        gdk_window_remove_filter (NULL, gtk_clutter_filter_func, widget);
    }

  gtk_clutter_embed_stage_unrealize (embed);

  GTK_WIDGET_CLASS (gtk_clutter_embed_parent_class)->unrealize (widget);
}

static GtkSizeRequestMode
gtk_clutter_embed_get_request_mode (GtkWidget *widget)
{
  GtkClutterEmbedPrivate *priv = GTK_CLUTTER_EMBED (widget)->priv;
  GtkSizeRequestMode mode;

  mode = GTK_SIZE_REQUEST_CONSTANT_SIZE;
  if (priv->stage != NULL &&
      priv->use_layout_size &&
      clutter_actor_get_layout_manager (priv->stage) != NULL)
    {
      switch (clutter_actor_get_request_mode (priv->stage))
	{
	case CLUTTER_REQUEST_HEIGHT_FOR_WIDTH:
	  mode = GTK_SIZE_REQUEST_HEIGHT_FOR_WIDTH;
	  break;
	case CLUTTER_REQUEST_WIDTH_FOR_HEIGHT:
	  mode = GTK_SIZE_REQUEST_WIDTH_FOR_HEIGHT;
	  break;
        case CLUTTER_REQUEST_CONTENT_SIZE:
          mode = GTK_SIZE_REQUEST_CONSTANT_SIZE;
          break;
	}
    }

  return mode;
}

static void
gtk_clutter_embed_get_preferred_width_for_height (GtkWidget *widget,
						  gint       height,
						  gint      *minimum,
						  gint      *natural)
{
  GtkClutterEmbedPrivate *priv = GTK_CLUTTER_EMBED (widget)->priv;
  float min, nat;

  min = 0;
  nat = 0;

  if (priv->stage != NULL &&
      priv->use_layout_size)
    {
      ClutterLayoutManager *manager = clutter_actor_get_layout_manager (priv->stage);
      if (manager)
	clutter_layout_manager_get_preferred_width (manager,
						    CLUTTER_CONTAINER (priv->stage),
						    (float)height, &min, &nat);
    }

  min = ceilf (min);
  nat = ceilf (nat);

  if (minimum)
    *minimum = min;

  if (natural)
    *natural = nat;
}

static void
gtk_clutter_embed_get_preferred_height_for_width (GtkWidget *widget,
						  gint       width,
						  gint      *minimum,
						  gint      *natural)
{
  GtkClutterEmbedPrivate *priv = GTK_CLUTTER_EMBED (widget)->priv;
  float min, nat;

  min = 0;
  nat = 0;

  if (priv->stage != NULL &&
      priv->use_layout_size)
    {
      ClutterLayoutManager *manager = clutter_actor_get_layout_manager (priv->stage);
      if (manager)
	clutter_layout_manager_get_preferred_height (manager,
						     CLUTTER_CONTAINER (priv->stage),
						     (float)width, &min, &nat);
    }

  min = ceilf (min);
  nat = ceilf (nat);

  if (minimum)
    *minimum = min;

  if (natural)
    *natural = nat;
}

static void
gtk_clutter_embed_get_preferred_width (GtkWidget *widget,
				       gint      *minimum,
				       gint      *natural)
{
  gtk_clutter_embed_get_preferred_width_for_height (widget, -1, minimum, natural);
}

static void
gtk_clutter_embed_get_preferred_height (GtkWidget *widget,
					gint      *minimum,
					gint      *natural)
{
  gtk_clutter_embed_get_preferred_height_for_width (widget, -1, minimum, natural);
}

static void
gtk_clutter_embed_size_allocate (GtkWidget     *widget,
                                 GtkAllocation *allocation)
{
  GtkClutterEmbedPrivate *priv = GTK_CLUTTER_EMBED (widget)->priv;
  int scale_factor = gtk_widget_get_scale_factor (widget);

  gtk_widget_set_allocation (widget, allocation);

  /* change the size of the stage and ensure that the viewport
   * has been updated as well
   */
  clutter_actor_set_size (priv->stage, allocation->width, allocation->height);

  if (gtk_widget_get_realized (widget))
    {
      gdk_window_move_resize (gtk_widget_get_window (widget),
                              allocation->x,
                              allocation->y,
                              allocation->width,
                              allocation->height);

      clutter_stage_ensure_viewport (CLUTTER_STAGE (priv->stage));

      gtk_clutter_embed_send_configure (GTK_CLUTTER_EMBED (widget));

#if defined(GDK_WINDOWING_X11) && defined(CLUTTER_WINDOWING_X11)
      if (clutter_check_windowing_backend (CLUTTER_WINDOWING_X11) &&
	  GDK_IS_X11_WINDOW (gtk_widget_get_window (widget)))
	{
	  XConfigureEvent xevent = { ConfigureNotify };
	  xevent.window = GDK_WINDOW_XID (gtk_widget_get_window (widget));
	  xevent.width = allocation->width * scale_factor;
	  xevent.height = allocation->height * scale_factor;

	  /* Ensure cogl knows about the new size immediately, as we will
	     draw before we get the ConfigureNotify response. */
	  clutter_x11_handle_event ((XEvent *)&xevent);
	}
#endif
#if defined(GDK_WINDOWING_WAYLAND) && defined(CLUTTER_WINDOWING_WAYLAND)
      if (priv->subsurface)
        {
          gint x, y;
          gdk_window_get_origin (gtk_widget_get_window (widget), &x, &y);
          wl_subsurface_set_position (priv->subsurface, x, y);
        }
#endif
    }
}

static gboolean
gtk_clutter_embed_map_event (GtkWidget	 *widget,
                             GdkEventAny *event)
{
  GtkClutterEmbed *embed = GTK_CLUTTER_EMBED (widget);
  GtkClutterEmbedPrivate *priv = embed->priv;
  GtkWidgetClass *parent_class;
  gboolean res = FALSE;

  parent_class = GTK_WIDGET_CLASS (gtk_clutter_embed_parent_class);
  if (parent_class->map_event)
    res = parent_class->map_event (widget, event);

  gtk_clutter_embed_ensure_stage_realized (embed);

  clutter_actor_queue_redraw (priv->stage);

  return res;
}

static gboolean
gtk_clutter_embed_unmap_event (GtkWidget   *widget,
                               GdkEventAny *event)
{
  GtkClutterEmbed *embed = GTK_CLUTTER_EMBED (widget);
  GtkWidgetClass *parent_class;
  gboolean res = FALSE;

  parent_class = GTK_WIDGET_CLASS (gtk_clutter_embed_parent_class);
  if (parent_class->unmap_event)
    res = parent_class->unmap_event (widget, event);

  gtk_clutter_embed_stage_unrealize (embed);

  return res;
}

static gboolean
gtk_clutter_embed_focus_in (GtkWidget     *widget,
                            GdkEventFocus *event)
{
  GtkClutterEmbedPrivate *priv = GTK_CLUTTER_EMBED (widget)->priv;

  g_signal_emit_by_name (priv->stage, "activate");

  clutter_stage_set_key_focus (CLUTTER_STAGE (priv->stage), NULL);

  return FALSE;
}

static gboolean
gtk_clutter_embed_focus_out (GtkWidget     *widget,
                             GdkEventFocus *event)
{
  GtkClutterEmbedPrivate *priv = GTK_CLUTTER_EMBED (widget)->priv;

  g_signal_emit_by_name (priv->stage, "deactivate");

  /* give back key focus to the stage */
  clutter_stage_set_key_focus (CLUTTER_STAGE (priv->stage), NULL);

  return FALSE;
}

static gboolean
gtk_clutter_embed_key_event (GtkWidget   *widget,
                             GdkEventKey *event)
{
  GtkClutterEmbedPrivate *priv = GTK_CLUTTER_EMBED (widget)->priv;
  ClutterDeviceManager *manager;
  ClutterInputDevice *device;
  ClutterEvent cevent = { 0, };

  if (event->type == GDK_KEY_PRESS)
    cevent.key.type = CLUTTER_KEY_PRESS;
  else if (event->type == GDK_KEY_RELEASE)
    cevent.key.type = CLUTTER_KEY_RELEASE;
  else
    return FALSE;

  manager = clutter_device_manager_get_default ();
  device = clutter_device_manager_get_core_device (manager, CLUTTER_KEYBOARD_DEVICE);

  cevent.key.stage = CLUTTER_STAGE (priv->stage);
  cevent.key.time = event->time;
  cevent.key.modifier_state = event->state;
  cevent.key.keyval = event->keyval;
  cevent.key.hardware_keycode = event->hardware_keycode;
  cevent.key.unicode_value = gdk_keyval_to_unicode (event->keyval);
  cevent.key.device = device;

  clutter_do_event (&cevent);

  return FALSE;
}

static void
gtk_clutter_embed_style_updated (GtkWidget *widget)
{
  GdkScreen *screen;
  GtkSettings *gtk_settings;
  ClutterSettings *clutter_settings;
  gchar *font_name;
  gint double_click_time, double_click_distance;
#if defined(GDK_WINDOWING_X11) && defined(CLUTTER_WINDOWING_X11)
  gint xft_dpi, xft_hinting, xft_antialias;
  gchar *xft_hintstyle, *xft_rgba;
#endif

  if (gtk_widget_get_realized (widget))
    {
#if 0
      GtkClutterEmbedPrivate *priv = GTK_CLUTTER_EMBED (widget)->priv;
      GtkStyleContext *style_context;
      GtkStateFlags state_flags;
      GdkRGBA *bg_color;
      ClutterColor color;

      style_context = gtk_widget_get_style_context (widget);
      state_flags = gtk_widget_get_state_flags (widget);
      gtk_style_context_get (style_context, state_flags,
                             "background-color", &bg_color,
                             NULL);

      color.red   = CLAMP (bg_color->red   * 255, 0, 255);
      color.green = CLAMP (bg_color->green * 255, 0, 255);
      color.blue  = CLAMP (bg_color->blue  * 255, 0, 255);
      color.alpha = CLAMP (bg_color->alpha * 255, 0, 255);
      clutter_stage_set_color (CLUTTER_STAGE (priv->stage), &color);

      gdk_rgba_free (bg_color);
#endif
    }

  if (gtk_widget_has_screen (widget))
    screen = gtk_widget_get_screen (widget);
  else
    screen = gdk_screen_get_default ();

  gtk_settings = gtk_settings_get_for_screen (screen);
  g_object_get (G_OBJECT (gtk_settings),
                "gtk-font-name", &font_name,
                "gtk-double-click-time", &double_click_time,
                "gtk-double-click-distance", &double_click_distance,
                NULL);

#if defined(GDK_WINDOWING_X11) && defined(CLUTTER_WINDOWING_X11)
  if (GDK_IS_X11_SCREEN (screen))
    {
      g_object_get (G_OBJECT (gtk_settings),
                    "gtk-xft-dpi", &xft_dpi,
                    "gtk-xft-antialias", &xft_antialias,
                    "gtk-xft-hinting", &xft_hinting,
                    "gtk-xft-hintstyle", &xft_hintstyle,
                    "gtk-xft-rgba", &xft_rgba,
                    NULL);
    }
#endif

  /* copy all settings and values coming from GTK+ into
   * the ClutterBackend; this way, a scene embedded into
   * a GtkClutterEmbed will not look completely alien
   */
  clutter_settings = clutter_settings_get_default ();

#if defined(GDK_WINDOWING_X11) && defined(CLUTTER_WINDOWING_X11)
  if (GDK_IS_X11_SCREEN (screen))
    {
      g_object_set (G_OBJECT (clutter_settings),
                    "font-name", font_name,
                    "double-click-time", double_click_time,
                    "double-click-distance", double_click_distance,
                    "font-antialias", xft_antialias,
                    "font-dpi", xft_dpi,
                    "font-hinting", xft_hinting,
                    "font-hint-style", xft_hintstyle,
                    "font-subpixel-order", xft_rgba,
                    NULL);
    }
  else
#endif
    {
      g_object_set (G_OBJECT (clutter_settings),
                    "font-name", font_name,
                    "double-click-time", double_click_time,
                    "double-click-distance", double_click_distance,
                    NULL);
    }

#if defined(GDK_WINDOWING_X11) && defined(CLUTTER_WINDOWING_X11)
  if (GDK_IS_X11_SCREEN (screen))
    {
      g_free (xft_hintstyle);
      g_free (xft_rgba);
    }
#endif

  g_free (font_name);

  GTK_WIDGET_CLASS (gtk_clutter_embed_parent_class)->style_updated (widget);
}

void
_gtk_clutter_embed_set_child_active (GtkClutterEmbed *embed,
                                     GtkWidget       *child,
                                     gboolean         active)
{
  GdkWindow *child_window;

  child_window = gtk_widget_get_window (child);

  if (active)
    {
      embed->priv->n_active_children++;
      gdk_offscreen_window_set_embedder (child_window,
					 gtk_widget_get_window (GTK_WIDGET (embed)));
    }
  else
    {
      embed->priv->n_active_children--;
      gdk_offscreen_window_set_embedder (child_window,
					 NULL);
    }

}

static void
gtk_clutter_embed_add (GtkContainer *container,
		       GtkWidget    *widget)
{
  GtkClutterEmbedPrivate *priv = GTK_CLUTTER_EMBED (container)->priv;

#ifndef G_DISABLE_ASSERT
  if (G_UNLIKELY (!GTK_CLUTTER_IS_OFFSCREEN (widget)))
    {
      g_critical ("Widgets of type '%s' do not support children.",
                  G_OBJECT_TYPE_NAME (container));
      return;
    }
#endif

  priv->children = g_list_prepend (priv->children, widget);
  gtk_widget_set_parent (widget, GTK_WIDGET (container));
}

static void
gtk_clutter_embed_remove (GtkContainer *container,
			  GtkWidget    *widget)
{
  GtkClutterEmbedPrivate *priv = GTK_CLUTTER_EMBED (container)->priv;
  GList *l;

  l = g_list_find (priv->children, widget);
  if (l != NULL)
    {
      priv->children = g_list_delete_link (priv->children, l);
      gtk_widget_unparent (widget);
    }
}

static void
gtk_clutter_embed_forall (GtkContainer	 *container,
			  gboolean	  include_internals,
			  GtkCallback	  callback,
			  gpointer	  callback_data)
{
  GtkClutterEmbedPrivate *priv = GTK_CLUTTER_EMBED (container)->priv;
  GList *l;

  if (include_internals)
    {
      for (l = priv->children; l != NULL; l = l->next)
	callback (l->data, callback_data);
    }
}

static GType
gtk_clutter_embed_child_type (GtkContainer *container)
{
  /* we only accept GtkClutterOffscreen children */
  return GTK_CLUTTER_TYPE_OFFSCREEN;
}

static gboolean
gtk_clutter_embed_event (GtkWidget *widget,
                         GdkEvent  *event)
{
#if defined(CLUTTER_WINDOWING_GDK)
  if (clutter_check_windowing_backend (CLUTTER_WINDOWING_GDK))
    clutter_gdk_handle_event (event);
#endif

  return FALSE;
}

static void
gtk_clutter_embed_set_property (GObject       *gobject,
                                guint          prop_id,
                                const GValue *value,
                                GParamSpec   *pspec)
{
  GtkClutterEmbed *embed = GTK_CLUTTER_EMBED (gobject);

  switch (prop_id)
    {
    case PROP_USE_LAYOUT_SIZE:
      gtk_clutter_embed_set_use_layout_size (embed, g_value_get_boolean (value));
      break;

    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (gobject, prop_id, pspec);
      break;
    }
}

static void
gtk_clutter_embed_get_property (GObject    *gobject,
                                guint       prop_id,
                                GValue     *value,
                                GParamSpec *pspec)
{
  GtkClutterEmbed *embed = GTK_CLUTTER_EMBED (gobject);

  switch (prop_id)
    {
    case PROP_USE_LAYOUT_SIZE:
      g_value_set_boolean (value, embed->priv->use_layout_size);
      break;

    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (gobject, prop_id, pspec);
      break;
    }
}

static void
gtk_clutter_embed_class_init (GtkClutterEmbedClass *klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);
  GtkWidgetClass *widget_class = GTK_WIDGET_CLASS (klass);
  GtkContainerClass *container_class = GTK_CONTAINER_CLASS (klass);
  GParamSpec *pspec;

  gobject_class->dispose = gtk_clutter_embed_dispose;
  gobject_class->set_property = gtk_clutter_embed_set_property;
  gobject_class->get_property = gtk_clutter_embed_get_property;

  widget_class->style_updated = gtk_clutter_embed_style_updated;
  widget_class->size_allocate = gtk_clutter_embed_size_allocate;
  widget_class->draw = gtk_clutter_embed_draw;
  widget_class->realize = gtk_clutter_embed_realize;
  widget_class->unrealize = gtk_clutter_embed_unrealize;
  widget_class->show = gtk_clutter_embed_show;
  widget_class->map_event = gtk_clutter_embed_map_event;
  widget_class->unmap_event = gtk_clutter_embed_unmap_event;
  widget_class->focus_in_event = gtk_clutter_embed_focus_in;
  widget_class->focus_out_event = gtk_clutter_embed_focus_out;
  widget_class->key_press_event = gtk_clutter_embed_key_event;
  widget_class->key_release_event = gtk_clutter_embed_key_event;
  widget_class->event = gtk_clutter_embed_event;
  widget_class->get_request_mode = gtk_clutter_embed_get_request_mode;
  widget_class->get_preferred_width = gtk_clutter_embed_get_preferred_width;
  widget_class->get_preferred_height = gtk_clutter_embed_get_preferred_height;
  widget_class->get_preferred_width_for_height = gtk_clutter_embed_get_preferred_width_for_height;
  widget_class->get_preferred_height_for_width = gtk_clutter_embed_get_preferred_height_for_width;

  container_class->add = gtk_clutter_embed_add;
  container_class->remove = gtk_clutter_embed_remove;
  container_class->forall = gtk_clutter_embed_forall;
  container_class->child_type = gtk_clutter_embed_child_type;


  /**
   * GtkClutterEmbed:use-layout-size:
   *
   * The #GtkWidget to be embedded into the #GtkClutterActor
   *
   * Since: 1.4
   */
  pspec = g_param_spec_boolean ("use-layout-size",
                                "Use layout size",
				"Whether to use the reported size of the LayoutManager on the stage as the widget size.",
				FALSE,
				G_PARAM_READWRITE | G_PARAM_CONSTRUCT | G_PARAM_STATIC_STRINGS);
  g_object_class_install_property (gobject_class, PROP_USE_LAYOUT_SIZE, pspec);
}

#if defined(GDK_WINDOWING_WAYLAND) && defined(CLUTTER_WINDOWING_WAYLAND)
static void
registry_handle_global (void *data,
                        struct wl_registry *registry,
                        uint32_t name,
                        const char *interface,
                        uint32_t version)
{
  GtkClutterEmbed *embed = data;
  GtkClutterEmbedPrivate *priv = embed->priv;

  if (strcmp (interface, "wl_subcompositor") == 0)
    {
      priv->subcompositor = wl_registry_bind (registry,
                                              name,
                                              &wl_subcompositor_interface,
                                              1);
    }
}

static void
registry_handle_global_remove (void *data,
                               struct wl_registry *registry,
                               uint32_t name)
{
}

static const struct wl_registry_listener registry_listener = {
  registry_handle_global,
  registry_handle_global_remove
};
#endif

static void
gtk_clutter_embed_init (GtkClutterEmbed *embed)
{
  GtkClutterEmbedPrivate *priv;
  GtkWidget *widget;

  embed->priv = priv = gtk_clutter_embed_get_instance_private (embed);
  widget = GTK_WIDGET (embed);

  /* we have a real window backing our drawing */
  gtk_widget_set_has_window (widget, TRUE);

  /* we accept key focus */
  gtk_widget_set_can_focus (widget, TRUE);

  /* we own the whole drawing of this widget, including the background */
  gtk_widget_set_app_paintable (widget, TRUE);

  /* this widget should expand in both directions */
  gtk_widget_set_hexpand (widget, TRUE);
  gtk_widget_set_vexpand (widget, TRUE);

  /* we always create new stages rather than use the default */
  priv->stage = clutter_stage_new ();
  g_object_set_data (G_OBJECT (priv->stage),
		     "gtk-clutter-embed",
		     embed);

  /* intercept the queue-redraw signal of the stage to know when
   * Clutter-side requests a redraw; this way we can also request
   * a redraw GTK-side
   */
  priv->queue_redraw_id =
    g_signal_connect (priv->stage,
                      "queue-redraw", G_CALLBACK (on_stage_queue_redraw),
                      embed);

  /* intercept the queue-relayout signal of the stage to know when
   * Clutter-side needs to renegotiate it's size; this way we can
   * also request a resize GTK-side
   */
  priv->queue_relayout_id =
    g_signal_connect (priv->stage,
                      "queue-relayout", G_CALLBACK (on_stage_queue_relayout),
                      embed);


#if defined(GDK_WINDOWING_WAYLAND) && defined(CLUTTER_WINDOWING_WAYLAND)
  {
    GdkDisplay *gdk_display = gtk_widget_get_display (widget);
    if (clutter_check_windowing_backend (CLUTTER_WINDOWING_WAYLAND) &&
        GDK_IS_WAYLAND_DISPLAY (gdk_display))
      {
        struct wl_display *display;
        struct wl_registry *registry;

        display = gdk_wayland_display_get_wl_display (gdk_display);
        registry = wl_display_get_registry (display);
        wl_registry_add_listener (registry, &registry_listener, embed);

        wl_display_roundtrip (display);
      }
  }
#endif
}

/**
 * gtk_clutter_embed_new:
 *
 * Creates a new #GtkClutterEmbed widget. This widget can be
 * used to build a scene using Clutter API into a GTK+ application.
 *
 * Return value: the newly created #GtkClutterEmbed
 */
GtkWidget *
gtk_clutter_embed_new (void)
{
  return g_object_new (GTK_CLUTTER_TYPE_EMBED, NULL);
}

/**
 * gtk_clutter_embed_get_stage:
 * @embed: a #GtkClutterEmbed
 *
 * Retrieves the #ClutterStage from @embed. The returned stage can be
 * used to add actors to the Clutter scene.
 *
 * Return value: (transfer none): the Clutter stage. You should never
 *   destroy or unref the returned actor.
 */
ClutterActor *
gtk_clutter_embed_get_stage (GtkClutterEmbed *embed)
{
  g_return_val_if_fail (GTK_CLUTTER_IS_EMBED (embed), NULL);

  return embed->priv->stage;
}

/**
 * gtk_clutter_embed_set_use_layout_size:
 * @embed: a #GtkClutterEmbed
 * @use_layout_size: a boolean
 *
 * Changes the way @embed requests size. If @use_layout_size is
 * %TRUE, the @embed widget will request the size that the
 * LayoutManager reports as the preferred size. This means that
 * a Gtk+ window will automatically get the natural and minimum
 * toplevel window sizes. This is useful when the contents of the
 * clutter stage is similar to a traditional UI.
 *
 * If @use_layout_size is %FALSE (which is the default) then @embed
 * will not request any size and its up to the embedder to make sure
 * there is some size (by setting a custom size on the widget or a default
 * size on the toplevel. This makes more sense when using the @embed
 * as a viewport into a potentially unlimited clutter space.
 *
 * Since: 1.4
 */
void
gtk_clutter_embed_set_use_layout_size (GtkClutterEmbed *embed,
                                       gboolean use_layout_size)
{
  GtkClutterEmbedPrivate *priv = embed->priv;

  g_return_if_fail (GTK_CLUTTER_IS_EMBED (embed));

  use_layout_size = !!use_layout_size;
  if (use_layout_size != priv->use_layout_size)
    {
      priv->use_layout_size = use_layout_size;
      gtk_widget_queue_resize (GTK_WIDGET (embed));
      g_object_notify (G_OBJECT (embed), "use-layout-size");
   }
}

extern gboolean
gtk_clutter_embed_get_honor_stage_size (GtkClutterEmbed *embed);

gboolean
gtk_clutter_embed_get_honor_stage_size (GtkClutterEmbed *embed)
{
  return gtk_clutter_embed_get_use_layout_size (embed);
}

/**
 * gtk_clutter_embed_get_use_layout_size:
 * @embed: a #GtkClutterEmbed
 *
 * Retrieves whether the embedding uses the layout size, see
 * gtk_clutter_embed_set_use_layout_size() for details.
 *
 * Return value: %TRUE if reporting stage size as widget size, %FALSE otherwise.
 *
 * Since: 1.4
 */
gboolean
gtk_clutter_embed_get_use_layout_size (GtkClutterEmbed *embed)
{
  GtkClutterEmbedPrivate *priv = embed->priv;

  g_return_val_if_fail (GTK_CLUTTER_IS_EMBED (embed), FALSE);

  return priv->use_layout_size;
}
