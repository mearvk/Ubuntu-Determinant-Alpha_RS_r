/*
 * clutter-imtext
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

/**
 * SECTION:clutter-imtext
 * @short_description: Text widget with Input Method Context embbed
 * @stability: Unstable
 * @see_also: #ClutterText
 * @include: clutter-imtext/clutter-imtext.h
 *
 * #ClutterIMText is a widget which can work with Different Input Method. It derives from
 * #ClutterText to add the capability to handle Input Method Related function and signals.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <stdlib.h>

#include <glib.h>

#include <clutter/clutter.h>

#include "clutter-immulticontext.h"
#include "clutter-imtext.h"

#define CLUTTER_IMTEXT_GET_PRIVATE(obj)    \
        (G_TYPE_INSTANCE_GET_PRIVATE ((obj), CLUTTER_TYPE_IMTEXT, ClutterIMTextPrivate))

struct _ClutterIMTextPrivate
{
  ClutterIMContext *im_context;
  gboolean auto_show_im;
};

G_DEFINE_TYPE (ClutterIMText, clutter_imtext, CLUTTER_TYPE_TEXT)

static gboolean
_get_env_enable_autoshow(void)
{
  static gint env_enable_autoshow = -1;

  if (env_enable_autoshow == -1) {

    const gchar *envvar = NULL;

    envvar = g_getenv ("CLUTTER_IMCONTEXT_AUTOSHOW");
    if (envvar && !g_ascii_strcasecmp (envvar, "TRUE"))
      env_enable_autoshow = 1;
    else
      env_enable_autoshow = 0;
  }

  return (env_enable_autoshow == 1);
}

/**
 * clutter_text_position_to_pixel:
 * @text: a #ClutterText
 * @position: position in characters
 * @x: return location for the X coordinate in pixel, or %NULL
 * @y: return location for the Y coordinate in pixel, or %NULL
 * @line_height: return location for the line height in pixel, or %NULL
 *
 * Retrieves the coordinates of the given @position in pixel.
 *
 * Return value: %TRUE if the conversion was successful
 */
static gboolean
clutter_text_position_to_pixel (ClutterText *text,
                                 gint         position,
                                 gint *x, gint *y,
                                 gint *line_height)
{
  gfloat fx = 0, fy = 0, fheight = 0;

  clutter_text_position_to_coords(text, position, &fx, &fy, &fheight);

  if (x)
    *x = fx;

  if (y)
    *y = fy;

  if (line_height)
    *line_height = fheight;

  return TRUE;
}

static void update_im_cursor_location (ClutterIMText *self)
{
  ClutterIMTextPrivate *priv = self->priv;
  ClutterText *clutter_text = CLUTTER_TEXT (self);
  gint position = clutter_text_get_cursor_position(clutter_text);
  ClutterIMRectangle area;

  clutter_text_position_to_pixel (clutter_text, position,
                              &area.x, &area.y, &area.height);
  area.width = 0;

  clutter_im_context_set_cursor_location (priv->im_context, &area);
}

static void
clutter_imtext_commit_cb (ClutterIMContext *context, const gchar  *str,
				ClutterIMText *imtext)
{
  ClutterIMTextPrivate *priv = imtext->priv;
  ClutterText *clutter_text = CLUTTER_TEXT (imtext);

  if (clutter_text_get_editable(clutter_text))
    {
      clutter_text_delete_selection(clutter_text);
      clutter_text_insert_text (clutter_text, str,
      				clutter_text_get_cursor_position (clutter_text));
    }
}

static void
clutter_imtext_focus_in_cb (ClutterIMText *imtext)
{
  ClutterIMTextPrivate *priv = imtext->priv;
  ClutterText *clutter_text = CLUTTER_TEXT (imtext);

  if (!clutter_text_get_editable(clutter_text))
    return;

  if (priv->auto_show_im)
    clutter_im_context_show (priv->im_context);
  else
    clutter_im_context_focus_in (priv->im_context);
}

static void
clutter_imtext_focus_out_cb (ClutterIMText *imtext)
{
  ClutterIMTextPrivate *priv = imtext->priv;
  ClutterText *clutter_text = CLUTTER_TEXT (imtext);

  if (!clutter_text_get_editable(clutter_text))
    return;

  if (priv->auto_show_im)
    clutter_im_context_hide (priv->im_context);
  else
    clutter_im_context_focus_out (priv->im_context);
}

static void
clutter_imtext_paint (ClutterActor *actor)
{
  ClutterIMText *self = CLUTTER_IMTEXT (actor);
  ClutterText *clutter_text = CLUTTER_TEXT (actor);

  if (CLUTTER_ACTOR_CLASS (clutter_imtext_parent_class)->paint)
    CLUTTER_ACTOR_CLASS (clutter_imtext_parent_class)->paint (actor);

  if (clutter_text_get_editable(clutter_text))
    update_im_cursor_location(self);

}

static gboolean
clutter_imtext_key_press (ClutterActor    *actor,
			  ClutterKeyEvent *event)
{
  ClutterIMText *self = CLUTTER_IMTEXT (actor);
  ClutterIMTextPrivate *priv = self->priv;
  ClutterText *clutter_text = CLUTTER_TEXT (actor);

  if (!clutter_text_get_editable(clutter_text))
    return FALSE;

  if (clutter_im_context_filter_keypress (priv->im_context, event))
    return TRUE;

  if (CLUTTER_ACTOR_CLASS (clutter_imtext_parent_class)->key_press_event)
    return CLUTTER_ACTOR_CLASS (clutter_imtext_parent_class)->key_press_event (actor, event);

  return FALSE;
}

static gboolean
clutter_imtext_key_release (ClutterActor    *actor,
			    ClutterKeyEvent *event)
{
  ClutterIMText *self = CLUTTER_IMTEXT (actor);
  ClutterIMTextPrivate *priv = self->priv;
  ClutterText *clutter_text = CLUTTER_TEXT (actor);

  if (!clutter_text_get_editable(clutter_text))
    return FALSE;

  if (clutter_im_context_filter_keypress (priv->im_context, event))
    return TRUE;

  if (CLUTTER_ACTOR_CLASS (clutter_imtext_parent_class)->key_release_event)
    return CLUTTER_ACTOR_CLASS (clutter_imtext_parent_class)->key_release_event (actor, event);

  return FALSE;
}

static void
clutter_imtext_class_init (ClutterIMTextClass *klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);
  ClutterActorClass *actor_class = CLUTTER_ACTOR_CLASS (klass);

  g_type_class_add_private (klass, sizeof (ClutterIMTextPrivate));

  actor_class->paint = clutter_imtext_paint;
  actor_class->key_press_event = clutter_imtext_key_press;
  actor_class->key_release_event = clutter_imtext_key_release;
}

static void
clutter_imtext_init (ClutterIMText *self)
{
  ClutterIMTextPrivate *priv;

  self->priv = priv = CLUTTER_IMTEXT_GET_PRIVATE (self);

  g_signal_connect (self, "key-focus-in",
                    G_CALLBACK (clutter_imtext_focus_in_cb), self);

  g_signal_connect (self, "key-focus-out",
                    G_CALLBACK (clutter_imtext_focus_out_cb), self);

  priv->im_context = clutter_im_multicontext_new ();
  priv->im_context->actor = CLUTTER_ACTOR(self);
  priv->auto_show_im = _get_env_enable_autoshow();

  g_signal_connect (priv->im_context, "commit",
		    G_CALLBACK (clutter_imtext_commit_cb), self);
}

/**
 * clutter_imtext_new:
 * @text: text to set  to
 *
 * Create a new #ClutterIMText with the specified text
 *
 * Returns: a new #ClutterActor
 */
ClutterActor *
clutter_imtext_new (const gchar *text)
{
  return g_object_new (CLUTTER_TYPE_IMTEXT,
                          "text", text,
                          NULL);
}

/**
 * clutter_imtext_set_autoshow_im:
 * @self: a #ClutterIMText
 * @autoshow: TRUE to send show event to IM on focus
 *
 * Set to True if you want to ask IM to show it's UI when #ClutterIMText is on focus
 *
 */
void
clutter_imtext_set_autoshow_im (ClutterIMText *self, gboolean autoshow)
{
  ClutterIMTextPrivate *priv;
  g_return_if_fail (CLUTTER_IS_IMTEXT (self));

  priv = CLUTTER_IMTEXT_GET_PRIVATE (self);
  priv->auto_show_im = autoshow;
}

