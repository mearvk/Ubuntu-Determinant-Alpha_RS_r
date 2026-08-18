/*
 * clutter-imcontext 
 * clutter-imcontext is an imcontext framework modified base on GTK's imcontext.
 *
 * Author: raymond liu <raymond.liu@intel.com>
 *
 * Copyright (C) 2000 Red Hat, Inc.
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
 *
 */

/**
 * SECTION:clutter-immulticontext
 * @short_description:  An input method context supporting multiple, loadable input methods
 * @stability: Unstable
 *
 * #ClutterIMMultiContext is an wrap input method context for supporting loadable input methods.
 */

#include "config.h"

#include <string.h>
#include <locale.h>

#include "clutter-immulticontext.h"
#include "clutter-immodule.h"

struct _ClutterIMMulticontextPrivate
{
  ClutterIMRectangle cursor_location;

  guint use_preedit : 1;
  guint have_cursor_location : 1;
  guint focus_in : 1;
};

static void     clutter_im_multicontext_finalize           (GObject                 *object);

static void     clutter_im_multicontext_set_slave          (ClutterIMMulticontext       *multicontext,
							ClutterIMContext            *slave,
							gboolean                 finalizing);

static void     clutter_im_multicontext_get_preedit_string (ClutterIMContext            *context,
							gchar                  **str,
							PangoAttrList          **attrs,
							gint                   *cursor_pos);
static gboolean clutter_im_multicontext_filter_keypress    (ClutterIMContext            *context,
							ClutterKeyEvent             *event);
static void     clutter_im_multicontext_focus_in           (ClutterIMContext            *context);
static void     clutter_im_multicontext_focus_out          (ClutterIMContext            *context);
static void     clutter_im_multicontext_show           (ClutterIMContext            *context);
static void     clutter_im_multicontext_hide          (ClutterIMContext            *context);
static void     clutter_im_multicontext_reset              (ClutterIMContext            *context);
static void     clutter_im_multicontext_set_cursor_location (ClutterIMContext            *context,
							ClutterIMRectangle		*area);
static void     clutter_im_multicontext_set_use_preedit    (ClutterIMContext            *context,
							gboolean                 use_preedit);
static gboolean clutter_im_multicontext_get_surrounding    (ClutterIMContext            *context,
							gchar                  **text,
							gint                    *cursor_index);
static void     clutter_im_multicontext_set_surrounding    (ClutterIMContext            *context,
							const char              *text,
							gint                     len,
							gint                     cursor_index);

static void     clutter_im_multicontext_preedit_start_cb        (ClutterIMContext      *slave,
							     ClutterIMMulticontext *multicontext);
static void     clutter_im_multicontext_preedit_end_cb          (ClutterIMContext      *slave,
							     ClutterIMMulticontext *multicontext);
static void     clutter_im_multicontext_preedit_changed_cb      (ClutterIMContext      *slave,
							     ClutterIMMulticontext *multicontext);
static void     clutter_im_multicontext_commit_cb               (ClutterIMContext      *slave,
							     const gchar       *str,
							     ClutterIMMulticontext *multicontext);
static gboolean clutter_im_multicontext_retrieve_surrounding_cb (ClutterIMContext      *slave,
							     ClutterIMMulticontext *multicontext);
static gboolean clutter_im_multicontext_delete_surrounding_cb   (ClutterIMContext      *slave,
							     gint               offset,
							     gint               n_chars,
							     ClutterIMMulticontext *multicontext);

static const gchar *user_context_id = NULL;
static const gchar *global_context_id = NULL;

G_DEFINE_TYPE (ClutterIMMulticontext, clutter_im_multicontext, CLUTTER_TYPE_IM_CONTEXT)

static void
clutter_im_multicontext_class_init (ClutterIMMulticontextClass *class)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (class);
  ClutterIMContextClass *im_context_class = CLUTTER_IM_CONTEXT_CLASS (class);

  im_context_class->get_preedit_string = clutter_im_multicontext_get_preedit_string;
  im_context_class->filter_keypress = clutter_im_multicontext_filter_keypress;
  im_context_class->focus_in = clutter_im_multicontext_focus_in;
  im_context_class->focus_out = clutter_im_multicontext_focus_out;
  im_context_class->show = clutter_im_multicontext_show;
  im_context_class->hide = clutter_im_multicontext_hide;
  im_context_class->reset = clutter_im_multicontext_reset;
  im_context_class->set_cursor_location = clutter_im_multicontext_set_cursor_location;
  im_context_class->set_use_preedit = clutter_im_multicontext_set_use_preedit;
  im_context_class->set_surrounding = clutter_im_multicontext_set_surrounding;
  im_context_class->get_surrounding = clutter_im_multicontext_get_surrounding;

  gobject_class->finalize = clutter_im_multicontext_finalize;

  g_type_class_add_private (gobject_class, sizeof (ClutterIMMulticontextPrivate));
}

static void
clutter_im_multicontext_init (ClutterIMMulticontext *multicontext)
{
  multicontext->slave = NULL;

  multicontext->priv = G_TYPE_INSTANCE_GET_PRIVATE (multicontext, CLUTTER_TYPE_IM_MULTICONTEXT, ClutterIMMulticontextPrivate);
  multicontext->priv->use_preedit = FALSE;
  multicontext->priv->have_cursor_location = FALSE;
  multicontext->priv->focus_in = FALSE;
}

/**
 * clutter_im_multicontext_new:
 *
 * Creates a new #ClutterIMMulticontext.
 *
 * Returns: a new #ClutterIMMulticontext.
 **/
ClutterIMContext *
clutter_im_multicontext_new (void)
{
  return g_object_new (CLUTTER_TYPE_IM_MULTICONTEXT, NULL);
}

static void
clutter_im_multicontext_finalize (GObject *object)
{
  ClutterIMMulticontext *multicontext = CLUTTER_IM_MULTICONTEXT (object);

  clutter_im_multicontext_set_slave (multicontext, NULL, TRUE);
  g_free (multicontext->context_id);

  G_OBJECT_CLASS (clutter_im_multicontext_parent_class)->finalize (object);
}

static void
clutter_im_multicontext_set_slave (ClutterIMMulticontext *multicontext,
			       ClutterIMContext      *slave,
			       gboolean           finalizing)
{
  ClutterIMMulticontextPrivate *priv = multicontext->priv;
  gboolean need_preedit_changed = FALSE;

  if (multicontext->slave)
    {
      if (!finalizing)
	clutter_im_context_reset (multicontext->slave);

      g_signal_handlers_disconnect_by_func (multicontext->slave,
					    clutter_im_multicontext_preedit_start_cb,
					    multicontext);
      g_signal_handlers_disconnect_by_func (multicontext->slave,
					    clutter_im_multicontext_preedit_end_cb,
					    multicontext);
      g_signal_handlers_disconnect_by_func (multicontext->slave,
					    clutter_im_multicontext_preedit_changed_cb,
					    multicontext);
      g_signal_handlers_disconnect_by_func (multicontext->slave,
					    clutter_im_multicontext_commit_cb,
					    multicontext);

      multicontext->slave->actor = NULL;
      g_object_unref (multicontext->slave);
      multicontext->slave = NULL;

      if (!finalizing)
	need_preedit_changed = TRUE;
    }

  multicontext->slave = slave;

  if (multicontext->slave)
    {
      g_object_ref (multicontext->slave);

      g_signal_connect (multicontext->slave, "preedit-start",
			G_CALLBACK (clutter_im_multicontext_preedit_start_cb),
			multicontext);
      g_signal_connect (multicontext->slave, "preedit-end",
			G_CALLBACK (clutter_im_multicontext_preedit_end_cb),
			multicontext);
      g_signal_connect (multicontext->slave, "preedit-changed",
			G_CALLBACK (clutter_im_multicontext_preedit_changed_cb),
			multicontext);
      g_signal_connect (multicontext->slave, "commit",
			G_CALLBACK (clutter_im_multicontext_commit_cb),
			multicontext);
      g_signal_connect (multicontext->slave, "retrieve-surrounding",
			G_CALLBACK (clutter_im_multicontext_retrieve_surrounding_cb),
			multicontext);
      g_signal_connect (multicontext->slave, "delete-surrounding",
			G_CALLBACK (clutter_im_multicontext_delete_surrounding_cb),
			multicontext);

      multicontext->slave->actor = CLUTTER_IM_CONTEXT(multicontext)->actor;
      if (!priv->use_preedit)
	clutter_im_context_set_use_preedit (slave, FALSE);
      if (priv->have_cursor_location)
	clutter_im_context_set_cursor_location (slave, &priv->cursor_location);
      if (priv->focus_in)
	clutter_im_context_focus_in (slave);
    }

  if (need_preedit_changed)
    g_signal_emit_by_name (multicontext, "preedit-changed");
}

static ClutterIMContext *
clutter_im_multicontext_get_slave (ClutterIMMulticontext *multicontext)
{
  if (!multicontext->slave)
    {
      ClutterIMContext *slave;

      if (!global_context_id)
        {
          if (user_context_id)
            global_context_id = user_context_id;
          else
            global_context_id = _clutter_im_module_get_default_context_id ();
        }
      slave = _clutter_im_module_create (global_context_id);
      clutter_im_multicontext_set_slave (multicontext, slave, FALSE);
      g_object_unref (slave);

      g_free (multicontext->context_id);
      multicontext->context_id = g_strdup (global_context_id);
    }

  return multicontext->slave;
}

static void
clutter_im_multicontext_get_preedit_string (ClutterIMContext   *context,
					gchar         **str,
					PangoAttrList **attrs,
					gint           *cursor_pos)
{
  ClutterIMMulticontext *multicontext = CLUTTER_IM_MULTICONTEXT (context);
  ClutterIMContext *slave = clutter_im_multicontext_get_slave (multicontext);

  if (slave)
    clutter_im_context_get_preedit_string (slave, str, attrs, cursor_pos);
  else
    {
      if (str)
	*str = g_strdup ("");
      if (attrs)
	*attrs = pango_attr_list_new ();
    }
}

static gboolean
clutter_im_multicontext_filter_keypress (ClutterIMContext *context,
				     ClutterKeyEvent  *event)
{
  ClutterIMMulticontext *multicontext = CLUTTER_IM_MULTICONTEXT (context);
  ClutterIMContext *slave = clutter_im_multicontext_get_slave (multicontext);

  if (slave)
    return clutter_im_context_filter_keypress (slave, event);
  else
    return FALSE;
}

static void
clutter_im_multicontext_focus_in (ClutterIMContext   *context)
{
  ClutterIMMulticontext *multicontext = CLUTTER_IM_MULTICONTEXT (context);
  ClutterIMContext *slave;

  /* If the global context type is different from the context we were
   * using before, get rid of the old slave and create a new one
   * for the new global context type.
   */
  if (multicontext->context_id == NULL ||
      global_context_id == NULL ||
      strcmp (global_context_id, multicontext->context_id) != 0)
    clutter_im_multicontext_set_slave (multicontext, NULL, FALSE);

  slave = clutter_im_multicontext_get_slave (multicontext);

  multicontext->priv->focus_in = TRUE;

  if (slave)
    clutter_im_context_focus_in (slave);
}

static void
clutter_im_multicontext_focus_out (ClutterIMContext   *context)
{
  ClutterIMMulticontext *multicontext = CLUTTER_IM_MULTICONTEXT (context);
  ClutterIMContext *slave = clutter_im_multicontext_get_slave (multicontext);

  multicontext->priv->focus_in = FALSE;

  if (slave)
    clutter_im_context_focus_out (slave);
}

static void
clutter_im_multicontext_show (ClutterIMContext   *context)
{
  ClutterIMMulticontext *multicontext = CLUTTER_IM_MULTICONTEXT (context);
  ClutterIMContext *slave;

  /* If the global context type is different from the context we were
   * using before, get rid of the old slave and create a new one
   * for the new global context type.
   */
  if (multicontext->context_id == NULL ||
      global_context_id == NULL ||
      strcmp (global_context_id, multicontext->context_id) != 0)
    clutter_im_multicontext_set_slave (multicontext, NULL, FALSE);

  slave = clutter_im_multicontext_get_slave (multicontext);

  if (slave)
    clutter_im_context_show (slave);
}

static void
clutter_im_multicontext_hide (ClutterIMContext   *context)
{
  ClutterIMMulticontext *multicontext = CLUTTER_IM_MULTICONTEXT (context);
  ClutterIMContext *slave = clutter_im_multicontext_get_slave (multicontext);

  if (slave)
    clutter_im_context_hide (slave);
}

static void
clutter_im_multicontext_reset (ClutterIMContext   *context)
{
  ClutterIMMulticontext *multicontext = CLUTTER_IM_MULTICONTEXT (context);
  ClutterIMContext *slave = clutter_im_multicontext_get_slave (multicontext);

  if (slave)
    clutter_im_context_reset (slave);
}

static void
clutter_im_multicontext_set_cursor_location (ClutterIMContext   *context,
					 ClutterIMRectangle   *area)
{
  ClutterIMMulticontext *multicontext = CLUTTER_IM_MULTICONTEXT (context);
  ClutterIMContext *slave = clutter_im_multicontext_get_slave (multicontext);

  multicontext->priv->have_cursor_location = TRUE;
  multicontext->priv->cursor_location = *area;

  if (slave)
    clutter_im_context_set_cursor_location (slave, area);
}

static void
clutter_im_multicontext_set_use_preedit (ClutterIMContext   *context,
				     gboolean	    use_preedit)
{
  ClutterIMMulticontext *multicontext = CLUTTER_IM_MULTICONTEXT (context);
  ClutterIMContext *slave = clutter_im_multicontext_get_slave (multicontext);

  use_preedit = use_preedit != FALSE;

  multicontext->priv->use_preedit = use_preedit;

  if (slave)
    clutter_im_context_set_use_preedit (slave, use_preedit);
}

static gboolean
clutter_im_multicontext_get_surrounding (ClutterIMContext  *context,
				     gchar        **text,
				     gint          *cursor_index)
{
  ClutterIMMulticontext *multicontext = CLUTTER_IM_MULTICONTEXT (context);
  ClutterIMContext *slave = clutter_im_multicontext_get_slave (multicontext);

  if (slave)
    return clutter_im_context_get_surrounding (slave, text, cursor_index);
  else
    {
      if (text)
	*text = NULL;
      if (cursor_index)
	*cursor_index = 0;

      return FALSE;
    }
}

static void
clutter_im_multicontext_set_surrounding (ClutterIMContext *context,
				     const char   *text,
				     gint          len,
				     gint          cursor_index)
{
  ClutterIMMulticontext *multicontext = CLUTTER_IM_MULTICONTEXT (context);
  ClutterIMContext *slave = clutter_im_multicontext_get_slave (multicontext);

  if (slave)
    clutter_im_context_set_surrounding (slave, text, len, cursor_index);
}

static void
clutter_im_multicontext_preedit_start_cb   (ClutterIMContext      *slave,
					ClutterIMMulticontext *multicontext)
{
  g_signal_emit_by_name (multicontext, "preedit-start");
}

static void
clutter_im_multicontext_preedit_end_cb (ClutterIMContext      *slave,
				    ClutterIMMulticontext *multicontext)
{
  g_signal_emit_by_name (multicontext, "preedit-end");
}

static void
clutter_im_multicontext_preedit_changed_cb (ClutterIMContext      *slave,
					ClutterIMMulticontext *multicontext)
{
  g_signal_emit_by_name (multicontext, "preedit-changed");
}

static void
clutter_im_multicontext_commit_cb (ClutterIMContext      *slave,
			       const gchar       *str,
			       ClutterIMMulticontext *multicontext)
{
  g_signal_emit_by_name (multicontext, "commit", str);;
}

static gboolean
clutter_im_multicontext_retrieve_surrounding_cb (ClutterIMContext      *slave,
					     ClutterIMMulticontext *multicontext)
{
  gboolean result;

  g_signal_emit_by_name (multicontext, "retrieve-surrounding", &result);

  return result;
}

static gboolean
clutter_im_multicontext_delete_surrounding_cb (ClutterIMContext      *slave,
					   gint               offset,
					   gint               n_chars,
					   ClutterIMMulticontext *multicontext)
{
  gboolean result;

  g_signal_emit_by_name (multicontext, "delete-surrounding",
			 offset, n_chars, &result);

  return result;
}
