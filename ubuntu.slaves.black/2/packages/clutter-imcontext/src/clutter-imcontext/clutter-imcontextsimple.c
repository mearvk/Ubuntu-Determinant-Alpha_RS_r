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
* SECTION:clutter-imcontextsimple
* @short_description: simple fallback imcontext
* @stability: Unstable
*/

#include "config.h"
#include <stdlib.h>
#include <string.h>

#include "clutter-imcontextsimple.h"

static void     clutter_im_context_simple_finalize           (GObject                  *obj);
static gboolean clutter_im_context_simple_filter_keypress    (ClutterIMContext             *context,
							  ClutterKeyEvent              *key);
static void     clutter_im_context_simple_reset              (ClutterIMContext             *context);
static void     clutter_im_context_simple_get_preedit_string (ClutterIMContext             *context,
							  gchar                   **str,
							  PangoAttrList           **attrs,
							  gint                     *cursor_pos);

G_DEFINE_TYPE (ClutterIMContextSimple, clutter_im_context_simple, CLUTTER_TYPE_IM_CONTEXT)

static void
clutter_im_context_simple_class_init (ClutterIMContextSimpleClass *class)
{
  ClutterIMContextClass *im_context_class = CLUTTER_IM_CONTEXT_CLASS (class);
  GObjectClass *gobject_class = G_OBJECT_CLASS (class);

  im_context_class->filter_keypress = clutter_im_context_simple_filter_keypress;
  im_context_class->reset = clutter_im_context_simple_reset;
  im_context_class->get_preedit_string = clutter_im_context_simple_get_preedit_string;
  gobject_class->finalize = clutter_im_context_simple_finalize;
}

static void
clutter_im_context_simple_init (ClutterIMContextSimple *im_context_simple)
{
}

static void
clutter_im_context_simple_finalize (GObject *obj)
{
  G_OBJECT_CLASS (clutter_im_context_simple_parent_class)->finalize (obj);
}

/**
 * clutter_im_context_simple_new:
 *
 * Creates a new #ClutterIMContextSimple.
 *
 * Returns: a new #ClutterIMContextSimple.
 **/
ClutterIMContext *
clutter_im_context_simple_new (void)
{
  return g_object_new (CLUTTER_TYPE_IM_CONTEXT_SIMPLE, NULL);
}

static gboolean
clutter_im_context_simple_filter_keypress (ClutterIMContext *context,
				       ClutterKeyEvent  *event)
{
  return FALSE;
}

static void
clutter_im_context_simple_reset (ClutterIMContext *context)
{
}

static void
clutter_im_context_simple_get_preedit_string (ClutterIMContext   *context,
					  gchar         **str,
					  PangoAttrList **attrs,
					  gint           *cursor_pos)
{
  char outbuf[37]; /* up to 6 hex digits */
  int len = 0;

  outbuf[len] = '\0';

  if (str)
    *str = g_strdup (outbuf);

  if (attrs)
    {
      *attrs = pango_attr_list_new ();

      if (len)
	{
	  PangoAttribute *attr = pango_attr_underline_new (PANGO_UNDERLINE_SINGLE);
	  attr->start_index = 0;
          attr->end_index = len;
	  pango_attr_list_insert (*attrs, attr);
	}
    }

  if (cursor_pos)
    *cursor_pos = len;
}
