/*
 * test-imtext.c
 *
 * Author: raymond liu <raymond.liu@intel.com>
 *
 * Copyright (C) 2009, Intel Corporation.
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * version 2.1 as published by the Free Software Foundation.
 * 
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA
 */

#include <stdlib.h>
#include <X11/Xlib.h>

#include <clutter/clutter.h>
#include <clutter/x11/clutter-x11.h>
#include <clutter-imcontext/clutter-imtext.h>

#define FONT "Mono Bold 22px"

#define STEP g_message("%s,%d\n", __func__, __LINE__)

ClutterActor *the_stage = NULL;

static gchar *testtext =
"Hello\n"
"测试\n";

static void
stage_focus_in(ClutterActor *actor)
{
  STEP;
}

static void
on_key_focus_in(ClutterActor *actor)
{
  STEP;
}

static void
on_show(ClutterActor *actor)
{
  STEP;
}

static void
on_key_focus_out(ClutterActor *actor)
{
  STEP;
}

static gboolean
on_key_press(ClutterActor *actor, ClutterKeyEvent *event,
	gpointer *data)
{
  //STEP;
  return FALSE;
}

static void
on_text_paint (ClutterActor *actor,
                gpointer      data)
{
  ClutterActorBox allocation = { 0, };
  float width, height;

  clutter_actor_get_allocation_box (actor, &allocation);
  width = allocation.x2 - allocation.x1;
  height = allocation.y2 - allocation.y1;

  cogl_set_source_color4ub (255, 255, 255, 255);
  cogl_path_round_rectangle (0, 0,
                             width,
                             height,
                             (float)(4),
                             COGL_ANGLE_FROM_DEG (1.0));
  cogl_path_stroke ();
}


int
main (int    argc,
                char **argv)
{
  ClutterActor *stage;
  ClutterActor *text, *text2;
  ClutterActor *group;
  ClutterColor  text_color       = { 0x33, 0xff, 0x33, 0xff };
  ClutterColor  cursor_color     = { 0xff, 0x33, 0x33, 0xff };
  ClutterColor  background_color = { 0x00, 0x00, 0x30, 0xff };

  clutter_init (&argc, &argv);

  the_stage = stage = clutter_stage_get_default ();
  clutter_stage_set_color (CLUTTER_STAGE (stage), &background_color);

  text = clutter_imtext_new ("Auto Show IM");

  clutter_container_add_actor (CLUTTER_CONTAINER (stage), text);
  clutter_actor_set_size (text, 380, 90);
  clutter_actor_set_position (text, 10, 10);

  clutter_text_set_line_wrap (CLUTTER_TEXT (text), TRUE);

  clutter_actor_set_reactive (text, TRUE);

  clutter_text_set_editable (CLUTTER_TEXT (text), TRUE);
  clutter_text_set_selectable (CLUTTER_TEXT (text), TRUE);
  clutter_text_set_cursor_color (CLUTTER_TEXT (text), &cursor_color);

  clutter_text_set_color (CLUTTER_TEXT (text), &text_color);
  clutter_text_set_font_name (CLUTTER_TEXT (text), FONT);

  clutter_imtext_set_autoshow_im (CLUTTER_IMTEXT (text), TRUE);

  g_signal_connect (text, "key-focus-in", G_CALLBACK (on_key_focus_in), NULL);
  g_signal_connect (text, "key-focus-out", G_CALLBACK (on_key_focus_out), NULL);

  g_signal_connect (text, "show", G_CALLBACK (on_show), NULL);

  g_signal_connect (text, "key-press-event", G_CALLBACK (on_key_press), NULL);
  g_signal_connect (text, "paint", G_CALLBACK (on_text_paint), NULL);


// text2
  text2 = clutter_imtext_new ("Show IM According to env: CLUTTER_IMCONTEXT_AUTOSHOW");

  clutter_container_add_actor (CLUTTER_CONTAINER (stage), text2);
  clutter_actor_set_position (text2, 10, 120);
  clutter_actor_set_size (text2, 380, 90);
  clutter_text_set_line_wrap (CLUTTER_TEXT (text2), TRUE);

  clutter_actor_set_reactive (text2, TRUE);

  clutter_text_set_editable (CLUTTER_TEXT (text2), TRUE);
  clutter_text_set_selectable (CLUTTER_TEXT (text2), TRUE);
  clutter_text_set_cursor_color (CLUTTER_TEXT (text2), &cursor_color);

  clutter_text_set_color (CLUTTER_TEXT (text2), &text_color);
  clutter_text_set_font_name (CLUTTER_TEXT (text2), FONT);

  g_signal_connect (text2, "key-focus-in", G_CALLBACK (on_key_focus_in), NULL);
  g_signal_connect (text2, "key-focus-out", G_CALLBACK (on_key_focus_out), NULL);

  g_signal_connect (text2, "show", G_CALLBACK (on_show), NULL);

  g_signal_connect (text2, "key-press-event", G_CALLBACK (on_key_press), NULL);
  g_signal_connect (text2, "paint", G_CALLBACK (on_text_paint), NULL);

  g_signal_connect (stage, "key-focus-in", G_CALLBACK (stage_focus_in), NULL);

  clutter_actor_set_size (stage, 420, 220);
  clutter_actor_show (stage);

  clutter_main ();

  return EXIT_SUCCESS;
}
