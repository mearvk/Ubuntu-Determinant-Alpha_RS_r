/* Clutter-Gtk Window Test
 *
 * (c) 2009, Collabora Ltd.
 *
 * Written by Davyd Madeley <davyd.madeley@collabora.co.uk>
 */

#include <stdlib.h>
#include <gtk/gtk.h>
#include <clutter/clutter.h>
#include <clutter-gtk/clutter-gtk.h>

enum
{
    NAME_COLUMN,
    PIXBUF_COLUMN,
    N_COLUMNS
};

static void
add_liststore_rows (GtkListStore *store,
                    const char *first, ...)
{
    GtkIconTheme *theme;
    va_list var_args;
    char *icon;

    theme = gtk_icon_theme_get_default ();

    va_start (var_args, first);

    for (icon = (char *) first; icon != NULL; icon = va_arg (var_args, char *))
    {
        GdkPixbuf *pixbuf = gtk_icon_theme_load_icon (theme, icon, 48,
                                                      0,
                                                      NULL);

        gtk_list_store_insert_with_values (store, NULL, -1,
                                           NAME_COLUMN, icon,
                                           PIXBUF_COLUMN, pixbuf,
                                           -1);
        if (pixbuf != NULL)
          g_object_unref (pixbuf);
    }

    va_end (var_args);
}

static void
add_toolbar_items (GtkToolbar *toolbar,
                   const char *first, ...)
{
    va_list var_args;
    char *stock_id;

    va_start (var_args, first);

    for (stock_id = (char *) first; stock_id != NULL;
         stock_id = va_arg (var_args, char *))
    {
        GtkToolItem *item = g_object_new (GTK_TYPE_TOOL_BUTTON,
                                          "icon-name", stock_id,
                                          "label", NULL,
                                          NULL);
        gtk_toolbar_insert (toolbar, item, -1);
    }

    va_end (var_args);
}

static gboolean
on_toolbar_enter (ClutterActor *actor,
                  ClutterEvent *event,
                  gpointer      dummy G_GNUC_UNUSED)
{
  clutter_actor_save_easing_state (actor);
  clutter_actor_set_easing_mode (actor, CLUTTER_LINEAR);

  clutter_actor_set_opacity (actor, 255);
  clutter_actor_set_y (actor, 0);

  clutter_actor_restore_easing_state (actor);

  return CLUTTER_EVENT_STOP;
}

static gboolean
on_toolbar_leave (ClutterActor *actor,
                  ClutterEvent *event,
                  gpointer      dummy G_GNUC_UNUSED)
{
  clutter_actor_save_easing_state (actor);
  clutter_actor_set_easing_mode (actor, CLUTTER_LINEAR);

  clutter_actor_set_opacity (actor, 128);
  clutter_actor_set_y (actor, clutter_actor_get_height (actor) * -0.5f);

  clutter_actor_restore_easing_state (actor);

  return CLUTTER_EVENT_STOP;
}

int
main (int argc, char **argv)
{
    GtkWidget *window, *iconview, *sw, *toolbar;
    GtkListStore *store;
    ClutterActor *stage, *actor;

    if (gtk_clutter_init (&argc, &argv) != CLUTTER_INIT_SUCCESS)
      return EXIT_FAILURE;

    window = gtk_clutter_window_new ();
    g_signal_connect (window, "destroy", G_CALLBACK (gtk_main_quit), NULL);
    gtk_window_set_default_size (GTK_WINDOW (window), 400, 300);

    store = gtk_list_store_new (N_COLUMNS, G_TYPE_STRING, GDK_TYPE_PIXBUF);
    add_liststore_rows (store,
                        "devhelp",
                        "empathy",
                        "evince",
                        "gnome-panel",
                        "seahorse",
                        "sound-juicer",
                        "totem",
                        NULL);

    iconview = gtk_icon_view_new_with_model (GTK_TREE_MODEL (store));
    gtk_icon_view_set_text_column (GTK_ICON_VIEW (iconview), NAME_COLUMN);
    gtk_icon_view_set_pixbuf_column (GTK_ICON_VIEW (iconview), PIXBUF_COLUMN);

    sw = gtk_scrolled_window_new (NULL, NULL);
    gtk_container_add (GTK_CONTAINER (window), sw);
    gtk_container_add (GTK_CONTAINER (sw), iconview);
    gtk_widget_show_all (sw);

    /* Widget 2 is a toolbar */
    stage = gtk_clutter_window_get_stage (GTK_CLUTTER_WINDOW (window));

    toolbar = gtk_toolbar_new ();
    add_toolbar_items (GTK_TOOLBAR (toolbar),
                       "list-add",
                       "format-text-bold",
                       "format-text-italic",
                       "media-optical",
                       "edit-copy",
                       NULL);

    gtk_widget_show_all (toolbar);
    actor = gtk_clutter_actor_new_with_contents (toolbar);
    clutter_actor_add_constraint (actor, clutter_bind_constraint_new (stage, CLUTTER_BIND_WIDTH, 0.0));
    g_signal_connect (actor, "enter-event", G_CALLBACK (on_toolbar_enter), NULL);
    g_signal_connect (actor, "leave-event", G_CALLBACK (on_toolbar_leave), NULL);

    clutter_actor_set_y (actor, clutter_actor_get_height (actor) * -0.5);
    clutter_actor_set_opacity (actor, 128);
    clutter_actor_set_reactive (actor, TRUE);
    clutter_actor_add_child (stage, actor);

    gtk_widget_show_all (window);
    gtk_main ();

    return 0;
}
