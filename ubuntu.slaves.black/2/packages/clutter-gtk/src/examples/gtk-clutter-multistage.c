#include <gtk/gtk.h>
#include <clutter/clutter.h>

#include <clutter-gtk/clutter-gtk.h>

int
main (int argc, char *argv[])
{
  ClutterActor *stage0, *stage1, *stage2, *tex1, *tex2;
  GtkWidget *window, *clutter0, *clutter1, *clutter2;
  GtkWidget *notebook, *vbox;
  ClutterColor col0 = { 0xdd, 0xff, 0xdd, 0xff };
  ClutterColor col1 = { 0xff, 0xff, 0xff, 0xff };
  ClutterColor col2 = {    0,    0,    0, 0xff };

  if (gtk_clutter_init (&argc, &argv) != CLUTTER_INIT_SUCCESS)
    g_error ("Unable to initialize GtkClutter");

  window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
  gtk_window_set_default_size (GTK_WINDOW (window), 600, 400);
  gtk_window_set_title (GTK_WINDOW (window), "Multiple GtkClutterEmbed");
  g_signal_connect (window, "destroy", G_CALLBACK (gtk_main_quit), NULL);

  notebook = gtk_notebook_new ();
  gtk_container_add (GTK_CONTAINER (window), notebook);

  clutter0 = gtk_clutter_embed_new ();
  gtk_notebook_append_page (GTK_NOTEBOOK (notebook), clutter0,
                            gtk_label_new ("One stage"));
  stage0 = gtk_clutter_embed_get_stage (GTK_CLUTTER_EMBED (clutter0));
  clutter_actor_set_background_color (stage0, &col0);

  vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 6);
  gtk_notebook_append_page (GTK_NOTEBOOK (notebook), vbox,
                            gtk_label_new ("Two stages"));

  clutter1 = gtk_clutter_embed_new ();
  gtk_widget_set_size_request (clutter1, 320, 240);
  stage1 = gtk_clutter_embed_get_stage (GTK_CLUTTER_EMBED (clutter1));
  clutter_actor_set_background_color (stage1, &col1);
  tex1 = gtk_clutter_texture_new ();
  gtk_clutter_texture_set_from_icon_name (GTK_CLUTTER_TEXTURE (tex1),
                                          clutter1,
                                          "dialog-information",
                                          GTK_ICON_SIZE_DIALOG,
                                          NULL);
  clutter_actor_set_position (tex1,
                              160 - clutter_actor_get_width (tex1) / 2.0,
                              120 - clutter_actor_get_height (tex1) / 2.0);
  clutter_actor_add_child (stage1, tex1); 
  clutter_actor_show (tex1);

  gtk_container_add (GTK_CONTAINER (vbox), clutter1);

  clutter2 = gtk_clutter_embed_new ();
  gtk_widget_set_size_request (clutter2, 320, 120);
  stage2 = gtk_clutter_embed_get_stage (GTK_CLUTTER_EMBED (clutter2));
  clutter_actor_set_background_color (stage2, &col2);
  tex2 = gtk_clutter_texture_new ();
  gtk_clutter_texture_set_from_icon_name (GTK_CLUTTER_TEXTURE (tex2),
                                          clutter1,
                                          "user-info",
                                          GTK_ICON_SIZE_BUTTON,
                                          NULL);
  clutter_actor_add_constraint (tex2, clutter_align_constraint_new (stage2, CLUTTER_ALIGN_BOTH, .5));
  clutter_actor_add_child (stage2, tex2);

  gtk_container_add (GTK_CONTAINER (vbox), clutter2);

  gtk_widget_show_all (window);

  gtk_main();

  return 0;
}
