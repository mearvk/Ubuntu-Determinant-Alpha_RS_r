#include <stdlib.h>
#include <math.h>

#include <gtk/gtk.h>
#include <clutter/clutter.h>

#include <clutter-gtk/clutter-gtk.h>

#define NHANDS          4
#define WINWIDTH        400
#define WINHEIGHT       400
#define RADIUS          150

#ifndef EXAMPLES_DATADIR
#define EXAMPLES_DATADIR "."
#endif

typedef struct SuperOH
{
  ClutterActor *stage;
  ClutterActor *hand[NHANDS];
  ClutterActor *bgtex;
  ClutterActor *group;
} SuperOH; 

static gboolean fade = FALSE;
static gboolean fullscreen = FALSE;

/* input handler */
static gboolean
input_cb (ClutterStage *stage,
	  ClutterEvent *event,
	  gpointer      data)
{
  ClutterEventType event_type = clutter_event_type (event);
  SuperOH *oh = data;

  if (event_type == CLUTTER_BUTTON_PRESS)
    {
      ClutterActor *a;
      gfloat x, y;

      clutter_event_get_coords (event, &x, &y);

      a = clutter_stage_get_actor_at_pos (stage, CLUTTER_PICK_ALL, x, y);
      if (a != NULL && (CLUTTER_IS_TEXTURE (a) || CLUTTER_IS_CLONE (a)))
	clutter_actor_hide (a);
    }
  else if (event->type == CLUTTER_KEY_PRESS)
    {
      g_print ("*** key press event (key:%c) ***\n",
	       clutter_event_get_key_symbol (event));
      
      if (clutter_event_get_key_symbol (event) == CLUTTER_KEY_q)
	gtk_main_quit ();
      else if (clutter_event_get_key_symbol (event) == CLUTTER_KEY_r)
        {
          int i;

          for (i = 0; i < NHANDS; i++)
            clutter_actor_show (oh->hand[i]);
        }
    }

  return TRUE;
}


/* Timeline handler */
void
frame_cb (ClutterTimeline *timeline, 
	  gint             msecs,
	  gpointer         data)
{
  SuperOH        *oh = (SuperOH *)data;
  gint            i;
  guint           rotation = clutter_timeline_get_progress (timeline) * 360.0f;

  /* Rotate everything clockwise about stage center*/
  clutter_actor_set_rotation_angle (oh->group, CLUTTER_Z_AXIS, rotation);

  for (i = 0; i < NHANDS; i++)
    {
      /* rotate each hand around there centers */
      clutter_actor_set_rotation_angle (oh->hand[i],
                                        CLUTTER_Z_AXIS,
                                        - 6.0 * rotation);
      if (fade == TRUE)
        clutter_actor_set_opacity (oh->hand[i], (255 - (rotation % 255)));
    }
}

static void
clickity (GtkButton *button,
          gpointer   stack)
{
  if (g_strcmp0 (gtk_stack_get_visible_child_name (GTK_STACK (stack)), "label") == 0)
    gtk_stack_set_visible_child_name (GTK_STACK (stack), "clutter");
  else
    gtk_stack_set_visible_child_name (GTK_STACK (stack), "label");

  fade = !fade;
}

static void
on_fullscreen (GtkButton *button,
               GtkWindow *window)
{
  if (!fullscreen)
    {
      gtk_window_fullscreen (window);
      fullscreen = TRUE;
    }
  else
    {
      gtk_window_unfullscreen (window);
      fullscreen = FALSE;
    }
}

int
main (int argc, char *argv[])
{
  ClutterTimeline *timeline;
  ClutterActor *stage;
  GtkWidget *window, *stack, *clutter;
  GtkWidget *label, *button, *vbox;
  GdkPixbuf *pixbuf;
  SuperOH *oh;
  gint i;
  GError *error;

  error = NULL;
  if (gtk_clutter_init_with_args (&argc, &argv,
                                  NULL,
                                  NULL,
                                  NULL,
                                  &error) != CLUTTER_INIT_SUCCESS)
    {
      if (error)
        {
          g_critical ("Unable to initialize Clutter-GTK: %s", error->message);
          g_error_free (error);
          return EXIT_FAILURE;
        }
      else
        g_error ("Unable to initialize Clutter-GTK");
    }

  /* calling gtk_clutter_init* multiple times should be safe */
  g_assert (gtk_clutter_init (NULL, NULL) == CLUTTER_INIT_SUCCESS);

  pixbuf = gdk_pixbuf_new_from_file (EXAMPLES_DATADIR G_DIR_SEPARATOR_S "redhand.png", NULL);

  if (!pixbuf)
    g_error("pixbuf load failed");

  window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
  gtk_window_set_default_size (GTK_WINDOW (window), WINWIDTH, WINHEIGHT);
  gtk_window_set_title (GTK_WINDOW (window), "Clutter Embedding");
  g_signal_connect (window, "destroy", G_CALLBACK (gtk_main_quit), NULL);

  vbox = gtk_grid_new ();
  gtk_orientable_set_orientation (GTK_ORIENTABLE (vbox), GTK_ORIENTATION_VERTICAL);
  gtk_widget_set_hexpand (vbox, TRUE);
  gtk_widget_set_vexpand (vbox, TRUE);
  gtk_container_add (GTK_CONTAINER (window), vbox);

  stack = gtk_stack_new ();
  gtk_container_add (GTK_CONTAINER (vbox), stack);

  label = gtk_label_new ("This is a label in a stack");
  gtk_stack_add_named (GTK_STACK (stack), label, "label");

  clutter = gtk_clutter_embed_new ();
  gtk_stack_add_named (GTK_STACK (stack), clutter, "clutter");
  gtk_widget_realize (clutter);

  stage = gtk_clutter_embed_get_stage (GTK_CLUTTER_EMBED (clutter));
  clutter_actor_set_background_color (stage, CLUTTER_COLOR_LightSkyBlue);

  label = gtk_label_new ("This is a label");
  gtk_container_add (GTK_CONTAINER (vbox), label);
  gtk_widget_set_hexpand (label, TRUE);

  button = gtk_button_new_with_label ("This is a button...clicky");
  g_signal_connect (button, "clicked", G_CALLBACK (clickity), stack);
  gtk_container_add (GTK_CONTAINER (vbox), button);
  gtk_widget_set_hexpand (button, TRUE);

  button = gtk_button_new_with_mnemonic ("_Fullscreen");
  g_signal_connect (button, "clicked",
                    G_CALLBACK (on_fullscreen),
                    window);
  gtk_container_add (GTK_CONTAINER (vbox), button);
  gtk_widget_set_hexpand (button, TRUE);

  button = gtk_button_new_with_mnemonic ("_Quit");
  g_signal_connect_swapped (button, "clicked",
                            G_CALLBACK (gtk_widget_destroy),
                            window);
  gtk_container_add (GTK_CONTAINER (vbox), button);
  gtk_widget_set_hexpand (button, TRUE);

  oh = g_new (SuperOH, 1);
  oh->stage = stage;

  oh->group = clutter_actor_new ();
  clutter_actor_set_pivot_point (oh->group, 0.5, 0.5);
  
  for (i = 0; i < NHANDS; i++)
    {
      gint x, y, w, h;

      /* Create a texture from pixbuf, then clone in to same resources */
      if (i == 0)
        {
          oh->hand[i] = gtk_clutter_texture_new ();
          gtk_clutter_texture_set_from_pixbuf (GTK_CLUTTER_TEXTURE (oh->hand[i]), pixbuf, NULL);
        }
      else
        oh->hand[i] = clutter_clone_new (oh->hand[0]);

      /* Place around a circle */
      w = clutter_actor_get_width (oh->hand[0]);
      h = clutter_actor_get_height (oh->hand[0]);

      x = WINWIDTH / 2  + RADIUS * cos (i * M_PI / (NHANDS / 2)) - w / 2;
      y = WINHEIGHT / 2 + RADIUS * sin (i * M_PI / (NHANDS / 2)) - h / 2;

      clutter_actor_set_position (oh->hand[i], x, y);
      clutter_actor_set_pivot_point (oh->hand[i], 0.5, 0.5);

      /* Add to our group group */
      clutter_actor_add_child (oh->group, oh->hand[i]);
    }

  /* Add the group to the stage */
  clutter_actor_add_child (stage, oh->group);

  clutter_actor_add_constraint (oh->group, clutter_align_constraint_new (oh->stage, CLUTTER_ALIGN_BOTH, 0.5));

  g_signal_connect (stage, "button-press-event",
		    G_CALLBACK (input_cb), 
		    oh);
  g_signal_connect (stage, "key-release-event",
		    G_CALLBACK (input_cb),
		    oh);

  gtk_widget_show_all (window);

  /* Create a timeline to manage animation */
  timeline = clutter_timeline_new (6000);
  clutter_timeline_set_repeat_count (timeline, -1);

  /* fire a callback for frame change */
  g_signal_connect (timeline, "new-frame",  G_CALLBACK (frame_cb), oh);

  /* and start it */
  clutter_timeline_start (timeline);

  gtk_main ();

  return 0;
}
