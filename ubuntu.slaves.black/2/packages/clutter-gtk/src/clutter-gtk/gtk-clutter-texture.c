/* gtk-clutter-texture.h
 *
 * Copyright (C) 2010  Intel Corp.
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
 *   Emmanuele Bassi  <ebassi@linux.intel.com>
 */

/**
 * SECTION:gtk-clutter-texture
 * @Title: GtkClutterTexture
 * @Short_Description: A texture class using GTK+ image data types
 *
 * #GtkClutterTexture is a simple sub-class of #ClutterTexture that
 * integrates nicely with #GdkPixbuf, #GtkIconTheme and stock icons.
 */

#include "config.h"

#include "gtk-clutter-texture.h"

#include <glib/gi18n-lib.h>

G_DEFINE_TYPE (GtkClutterTexture, gtk_clutter_texture, CLUTTER_TYPE_TEXTURE);

static void
gtk_clutter_texture_class_init (GtkClutterTextureClass *klass)
{
}

static void
gtk_clutter_texture_init (GtkClutterTexture *texture)
{
}

GQuark
gtk_clutter_texture_error_quark (void)
{
  return g_quark_from_static_string ("gtk-clutter-texture-error");
}

/**
 * gtk_clutter_texture_new:
 *
 * Creates a new #GtkClutterTexture actor.
 *
 * Return value: the newly created #GtkClutterTexture
 *   instance
 *
 * Since: 1.0
 */
ClutterActor *
gtk_clutter_texture_new (void)
{
  return g_object_new (GTK_CLUTTER_TYPE_TEXTURE, NULL);
}

/**
 * gtk_clutter_texture_set_from_pixbuf:
 * @texture: a #GtkClutterTexture
 * @pixbuf: a #GdkPixbuf
 * @error: a return location for errors
 *
 * Sets the contents of @texture with a copy of @pixbuf.
 *
 * Return value: %TRUE on success, %FALSE on failure.
 */
gboolean
gtk_clutter_texture_set_from_pixbuf (GtkClutterTexture  *texture,
                                     GdkPixbuf          *pixbuf,
                                     GError            **error)
{
  g_return_val_if_fail (GTK_CLUTTER_IS_TEXTURE (texture), FALSE);
  g_return_val_if_fail (GDK_IS_PIXBUF (pixbuf), FALSE);

  return clutter_texture_set_from_rgb_data (CLUTTER_TEXTURE (texture),
                                            gdk_pixbuf_get_pixels (pixbuf),
                                            gdk_pixbuf_get_has_alpha (pixbuf),
                                            gdk_pixbuf_get_width (pixbuf),
                                            gdk_pixbuf_get_height (pixbuf),
                                            gdk_pixbuf_get_rowstride (pixbuf),
                                            gdk_pixbuf_get_has_alpha (pixbuf) ? 4 : 3,
                                            0,
                                            error);
}

/**
 * gtk_clutter_texture_set_from_stock:
 * @texture: a #GtkClutterTexture
 * @widget: a #GtkWidget
 * @stock_id: the stock id of the icon
 * @icon_size: the size of the icon, or -1
 * @error: a return location for errors, or %NULL
 *
 * Sets the contents of @texture using the stock icon @stock_id, as
 * rendered by @widget.
 *
 * Return value: %TRUE on success, %FALSE on failure.
 */
gboolean
gtk_clutter_texture_set_from_stock (GtkClutterTexture  *texture,
                                    GtkWidget          *widget,
                                    const gchar        *stock_id,
                                    GtkIconSize         icon_size,
                                    GError            **error)
{
  GdkPixbuf *pixbuf;
  gboolean returnval;

  g_return_val_if_fail (GTK_CLUTTER_IS_TEXTURE (texture), FALSE);
  g_return_val_if_fail (GTK_IS_WIDGET (widget), FALSE);
  g_return_val_if_fail (stock_id != NULL, FALSE);
  g_return_val_if_fail ((icon_size > GTK_ICON_SIZE_INVALID) || (icon_size == -1), FALSE);

  G_GNUC_BEGIN_IGNORE_DEPRECATIONS
  pixbuf = gtk_widget_render_icon_pixbuf (widget, stock_id, icon_size);
  G_GNUC_END_IGNORE_DEPRECATIONS

  if (pixbuf == NULL)
    {
      g_set_error (error,
                   GTK_CLUTTER_TEXTURE_ERROR,
                   GTK_CLUTTER_TEXTURE_ERROR_INVALID_STOCK_ID,
                   _("Stock ID '%s' not found"),
                   stock_id);
      return FALSE;
    }

  returnval = gtk_clutter_texture_set_from_pixbuf (texture, pixbuf, error);
  g_object_unref (pixbuf);

  return returnval;
}

/**
 * gtk_clutter_texture_set_from_icon_name:
 * @texture: a #GtkClutterTexture
 * @widget: (allow-none): a #GtkWidget or %NULL
 * @icon_name: the name of the icon
 * @icon_size: the icon size or -1
 * @error: a return location for errors, or %NULL
 *
 * Sets the contents of @texture using the @icon_name from the
 * current icon theme.
 *
 * Return value: %TRUE on success, %FALSE on failure
 *
 * Since: 1.0
 */
gboolean
gtk_clutter_texture_set_from_icon_name (GtkClutterTexture  *texture,
                                        GtkWidget          *widget,
                                        const gchar        *icon_name,
                                        GtkIconSize         icon_size,
                                        GError            **error)
{
  GError *local_error = NULL;
  GtkSettings *settings;
  GtkIconTheme *icon_theme;
  gboolean returnval;
  gint width, height;
  GdkPixbuf *pixbuf;

  g_return_val_if_fail (CLUTTER_IS_TEXTURE (texture), FALSE);
  g_return_val_if_fail (GTK_IS_WIDGET (widget), FALSE);
  g_return_val_if_fail (icon_name != NULL, FALSE);
  g_return_val_if_fail ((icon_size > GTK_ICON_SIZE_INVALID) || (icon_size == -1), FALSE);

  if (widget && gtk_widget_has_screen (widget))
    {
      GdkScreen *screen;

      screen = gtk_widget_get_screen (widget);
      settings = gtk_settings_get_for_screen (screen);
      icon_theme = gtk_icon_theme_get_for_screen (screen);
    }
  else
    {
      settings = gtk_settings_get_default ();
      icon_theme = gtk_icon_theme_get_default ();
    }

  G_GNUC_BEGIN_IGNORE_DEPRECATIONS
  if (icon_size == -1 ||
      !gtk_icon_size_lookup_for_settings (settings, icon_size, &width, &height))
    {
      width = height = 48;
    }
  G_GNUC_END_IGNORE_DEPRECATIONS

  pixbuf = gtk_icon_theme_load_icon (icon_theme,
                                     icon_name,
                                     MIN (width, height), 0,
                                     &local_error);
  if (local_error)
    {
      g_propagate_error (error, local_error);
      return FALSE;
    }

  returnval = gtk_clutter_texture_set_from_pixbuf (texture, pixbuf, error);
  g_object_unref (pixbuf);

  return returnval;
}
