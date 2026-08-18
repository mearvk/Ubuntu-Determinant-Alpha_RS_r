#include <gtk/gtk.h>
#include <clutter/clutter.h>

#include <clutter-gtk/clutter-gtk.h>

#ifndef EXAMPLES_DATADIR
#define EXAMPLES_DATADIR "."
#endif

typedef struct {

  GtkWidget    *window;
  GtkWidget    *popup;
  GtkWidget    *gtk_entry;

  ClutterActor *stage;
  ClutterActor *hand;
  ClutterActor *clutter_entry;

} EventApp;

static gboolean
on_enter_notify (GtkWidget *widget, GdkEventCrossing *event)
{
  g_print ("Entering widget '%s'\n", G_OBJECT_TYPE_NAME (widget));

  return FALSE;
}

static gboolean
on_leave_notify (GtkWidget *widget, GdkEventCrossing *event)
{
  g_print ("Leaving widget '%s'\n", G_OBJECT_TYPE_NAME (widget));

  return FALSE;
}

static void
on_gtk_entry_changed (GtkEditable *editable, EventApp *app)
{
  const gchar *text = gtk_entry_get_text (GTK_ENTRY (editable));

  clutter_text_set_text (CLUTTER_TEXT (app->clutter_entry), text);
}

static void
on_x_changed (GtkSpinButton *button, EventApp *app)
{
  clutter_actor_set_rotation_angle (app->hand, CLUTTER_X_AXIS,
                                    gtk_spin_button_get_value (button));
}

static void
on_y_changed (GtkSpinButton *button, EventApp *app)
{
  clutter_actor_set_rotation_angle (app->hand, CLUTTER_Y_AXIS,
                                    gtk_spin_button_get_value (button));
}

static void
on_z_changed (GtkSpinButton *button, EventApp *app)
{
  clutter_actor_set_rotation_angle (app->hand, CLUTTER_Z_AXIS,
                                    gtk_spin_button_get_value (button));
}

static void
on_opacity_changed (GtkSpinButton *button, EventApp *app)
{
  clutter_actor_set_opacity (app->hand, gtk_spin_button_get_value (button)); 
}

static gboolean
on_stage_capture (ClutterActor *stage,
                  ClutterEvent *event,
                  gpointer      dummy G_GNUC_UNUSED)
{
  switch (event->type)
    {
    case CLUTTER_BUTTON_PRESS:
    case CLUTTER_BUTTON_RELEASE:
      {
        gfloat x, y;

        clutter_event_get_coords (event, &x, &y);

        g_print ("Button %s captured at (%.2f, %.2f)\n",
                 event->type == CLUTTER_BUTTON_PRESS ? "Press" : "Relase",
                 x, y);
      }
      break;

    case CLUTTER_ENTER:
    case CLUTTER_LEAVE:
      {
        if (clutter_event_get_source (event) == stage &&
            clutter_event_get_related (event) != NULL)
          g_print ("%s the stage and %s '%s'\n",
                   event->type == CLUTTER_ENTER ? "Entering" : "Leaving",
                   event->type == CLUTTER_ENTER ? "leaving" : "entering",
                   clutter_actor_get_name (clutter_event_get_related (event)));
      }
      break;

    case CLUTTER_KEY_PRESS:
      {
        gchar buf[8];
        gint n_chars;

        n_chars = g_unichar_to_utf8 (clutter_event_get_key_unicode (event), buf);
        buf[n_chars] = '\0';
        g_print ("the stage got a key press: '%s' (symbol: %d, unicode: 0x%x)\n",
                 buf,
                 clutter_event_get_key_symbol (event),
                 clutter_event_get_key_unicode (event));
      }
      break;

    default:
      break;
    }

  return FALSE;
}

static gboolean
on_hand_button_press (ClutterActor       *actor,
                      ClutterButtonEvent *event,
                      gpointer            dummy)
{
  g_print ("Button press on hand ('%s')\n",
           g_type_name (G_OBJECT_TYPE (actor)));

  return FALSE;
}

gint
main (gint argc, gchar **argv)
{
  EventApp      *app = g_new0 (EventApp, 1);
  GtkWidget     *widget, *vbox, *hbox, *button, *label, *box;
  ClutterActor  *actor;
  GdkPixbuf     *pixbuf = NULL;
  GtkSizeGroup  *size_group;

  if (gtk_clutter_init_with_args (&argc, &argv, "- Event test", NULL, NULL, NULL) != CLUTTER_INIT_SUCCESS)
    g_error ("Unable to initialize GtkClutter");

  /* Create the inital gtk window and widgets, just like normal */
  widget = gtk_window_new (GTK_WINDOW_TOPLEVEL);
  app->window = widget;
  gtk_window_set_title (GTK_WINDOW (widget), "Gtk-Clutter Interaction demo");
  gtk_window_set_default_size (GTK_WINDOW (widget), 800, 600);
  gtk_window_set_resizable (GTK_WINDOW (widget), FALSE);
  gtk_container_set_border_width (GTK_CONTAINER (widget), 12);
  g_signal_connect (widget, "destroy", G_CALLBACK (gtk_main_quit), NULL);
 
  /* Create our layout box */
  vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 12);
  gtk_container_add (GTK_CONTAINER (app->window), vbox);

  widget = gtk_entry_new ();
  app->gtk_entry = widget;
  gtk_entry_set_text (GTK_ENTRY (widget), "Enter some text");
  gtk_box_pack_start (GTK_BOX (vbox), widget, FALSE, FALSE, 0);
  g_signal_connect (widget, "changed", G_CALLBACK (on_gtk_entry_changed), app);

  hbox = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 12);
  gtk_box_pack_start (GTK_BOX (vbox), hbox, TRUE, TRUE, 0);
  
  /* Set up clutter & create our stage */
  widget = gtk_clutter_embed_new ();
  gtk_box_pack_start (GTK_BOX (hbox), widget, TRUE, TRUE, 0);
  gtk_widget_grab_focus (widget);
  app->stage = gtk_clutter_embed_get_stage (GTK_CLUTTER_EMBED (widget));
  gtk_widget_set_size_request (widget, 640, 480);
  g_signal_connect (app->stage, "captured-event",
                    G_CALLBACK (on_stage_capture),
                    NULL);
  g_signal_connect (widget, "enter-notify-event",
                    G_CALLBACK (on_enter_notify),
                    NULL);
  g_signal_connect (widget, "leave-notify-event",
                    G_CALLBACK (on_leave_notify),
                    NULL);

  /* Create the main texture that the spin buttons manipulate */
  pixbuf = gdk_pixbuf_new_from_file (EXAMPLES_DATADIR G_DIR_SEPARATOR_S "redhand.png", NULL);
  if (pixbuf == NULL)
    g_error ("Unable to load pixbuf\n");

  app->hand = actor = gtk_clutter_texture_new ();
  gtk_clutter_texture_set_from_pixbuf (GTK_CLUTTER_TEXTURE (actor), pixbuf, NULL);
  clutter_actor_add_child (app->stage, actor);
  clutter_actor_set_pivot_point (actor, 0.5, 0.5);
  clutter_actor_add_constraint (actor, clutter_align_constraint_new (app->stage, CLUTTER_ALIGN_BOTH, 0.5));
  clutter_actor_set_reactive (actor, TRUE);
  clutter_actor_set_name (actor, "Red Hand");
  g_signal_connect (actor, "button-press-event",
                    G_CALLBACK (on_hand_button_press),
                    NULL);

  /* Setup the clutter entry */
  actor = clutter_text_new_full (NULL, "", CLUTTER_COLOR_Black);
  app->clutter_entry = actor;
  clutter_actor_add_child (app->stage, actor);
  clutter_actor_set_position (actor, 0, 0);
  clutter_actor_set_size (actor, 500, 20);

  /* Create our adjustment widgets */
  size_group = gtk_size_group_new (GTK_SIZE_GROUP_HORIZONTAL);
  vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 6);
  gtk_box_pack_start (GTK_BOX (hbox), vbox, FALSE, FALSE, 0);

  box = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 6);
  gtk_box_pack_start (GTK_BOX (vbox), box, FALSE, TRUE, 0);
  label = gtk_label_new ("Rotate x-axis");
  gtk_size_group_add_widget (size_group, label);
  gtk_box_pack_start (GTK_BOX (box), label, TRUE, TRUE, 0);
  button = gtk_spin_button_new_with_range (0, 360, 1);
  gtk_box_pack_start (GTK_BOX (box), button, TRUE, TRUE, 0);
  g_signal_connect (button, "value-changed", G_CALLBACK (on_x_changed), app);
  
  box = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 6);
  gtk_box_pack_start (GTK_BOX (vbox), box, FALSE, TRUE, 0);
  label = gtk_label_new ("Rotate y-axis");
  gtk_box_pack_start (GTK_BOX (box), label, TRUE, TRUE, 0);
  gtk_size_group_add_widget (size_group, label);
  button = gtk_spin_button_new_with_range (0, 360, 1);
  gtk_box_pack_start (GTK_BOX (box), button, TRUE, TRUE, 0);
  g_signal_connect (button, "value-changed", G_CALLBACK (on_y_changed), app);

  box = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 6);
  gtk_box_pack_start (GTK_BOX (vbox), box, FALSE, TRUE, 0);
  label = gtk_label_new ("Rotate z-axis");
  gtk_box_pack_start (GTK_BOX (box), label, TRUE, TRUE, 0);
  gtk_size_group_add_widget (size_group, label);
  button = gtk_spin_button_new_with_range (0, 360, 1);
  gtk_box_pack_start (GTK_BOX (box), button, TRUE, TRUE, 0);
  g_signal_connect (button, "value-changed", G_CALLBACK (on_z_changed), app);

  box = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 6);
  gtk_box_pack_start (GTK_BOX (vbox), box, FALSE, TRUE, 0);
  label = gtk_label_new ("Adjust opacity");
  gtk_box_pack_start (GTK_BOX (box), label, TRUE, TRUE, 0);
  gtk_size_group_add_widget (size_group, label);
  button = gtk_spin_button_new_with_range (0, 255, 1);
  gtk_spin_button_set_value (GTK_SPIN_BUTTON (button), 255);
  gtk_box_pack_start (GTK_BOX (box), button, TRUE, TRUE, 0);
  g_signal_connect (button, "value-changed", G_CALLBACK (on_opacity_changed), app);

  gtk_widget_show_all (app->window);

  /* Only show/show_all the stage after parent show. widget_show will call
   * show on the stage.
  */
  clutter_actor_show (app->stage);

  gtk_main ();
  
  return 0;
}
