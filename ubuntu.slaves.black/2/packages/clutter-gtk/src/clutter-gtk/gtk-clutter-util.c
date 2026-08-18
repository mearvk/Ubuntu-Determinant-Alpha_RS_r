#include "config.h"

#include "gtk-clutter-util.h"
#include "gtk-clutter-offscreen.h"
#include "gtk-clutter-version.h"

#include <gdk-pixbuf/gdk-pixbuf.h>
#include <gdk/gdk.h>
#include <gtk/gtk.h>
#include <clutter/clutter.h>

#if defined(CLUTTER_WINDOWING_GDK)
#include <clutter/gdk/clutter-gdk.h>
#endif

#if defined(CLUTTER_WINDOWING_X11)
#include <clutter/x11/clutter-x11.h>
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

#if defined(GDK_WINDOWING_MIR)
#include <gdk/gdkmir.h>
#endif

/**
 * SECTION:gtk-clutter-util
 * @Title: Utility Functions
 * @short_description: Utility functions for integrating Clutter in GTK+
 *
 * In order to properly integrate a Clutter scene into a GTK+ applications
 * a certain degree of state must be retrieved from GTK+ itself.
 *
 * Clutter-GTK provides API for easing the process of synchronizing colors
 * with the current GTK+ theme and for loading image sources from #GdkPixbuf,
 * GTK+ stock items and icon themes.
 */

static const guint clutter_gtk_major_version = CLUTTER_GTK_MAJOR_VERSION;
static const guint clutter_gtk_minor_version = CLUTTER_GTK_MINOR_VERSION;
static const guint clutter_gtk_micro_version = CLUTTER_GTK_MICRO_VERSION;

static gboolean gtk_clutter_is_initialized = FALSE;

static void
gtk_clutter_init_internal (void)
{
  GdkDisplay *display;

  display = gdk_display_get_default ();

#if defined(CLUTTER_WINDOWING_GDK)
  if (clutter_check_windowing_backend (CLUTTER_WINDOWING_GDK))
    {
      clutter_gdk_set_display (gdk_display_get_default ());

      /* let GDK be in charge of the event handling */
      clutter_gdk_disable_event_retrieval ();
    }
  else
#endif
#if defined(GDK_WINDOWING_X11) && defined(CLUTTER_WINDOWING_X11)
  if (clutter_check_windowing_backend (CLUTTER_WINDOWING_X11) &&
      GDK_IS_X11_DISPLAY (display))
    {
      /* enable ARGB visuals by default for Clutter */
      clutter_x11_set_use_argb_visual (TRUE);

      /* share the X11 Display with GTK+ */
      clutter_x11_set_display (GDK_DISPLAY_XDISPLAY (gdk_display_get_default ()));

      /* let GTK+ be in charge of the event handling */
      clutter_x11_disable_event_retrieval ();
    }
  else
#endif
#if defined(GDK_WINDOWING_WIN32) && defined(CLUTTER_WINDOWING_WIN32)
  if (clutter_check_windowing_backend (CLUTTER_WINDOWING_WIN32) &&
      GDK_IS_WIN32_DISPLAY (display))
    {
      /* let GTK+ be in charge of the event handling */
      clutter_win32_disable_event_retrieval ();
    }
  else
#endif
#if defined(GDK_WINDOWING_WAYLAND) && defined(CLUTTER_WINDOWING_WAYLAND)
  if (clutter_check_windowing_backend (CLUTTER_WINDOWING_WAYLAND) &&
      GDK_IS_WAYLAND_DISPLAY (display))
    {
      /* let GTK+ be in charge of the event handling */
      clutter_wayland_disable_event_retrieval ();

      clutter_wayland_set_display (gdk_wayland_display_get_wl_display (display));
    }
  else
#endif
#if defined(GDK_WINDOWING_MIR) && defined(CLUTTER_WINDOWING_MIR)
  if (clutter_check_windowing_backend (CLUTTER_WINDOWING_MIR) &&
      GDK_IS_MIR_DISPLAY (display))
    {
      /* let GTK+ be in charge of the event handling */
      /* This is disabled until Mir does not support sub-surfaces.
      clutter_mir_disable_event_retrieval ();
      */

      clutter_mir_set_connection (gdk_mir_display_get_mir_connection (display));
    }
  else
#endif
    g_error ("*** Unsupported backend.");

  /* We disable clutter accessibility support in order to not
   * interfere with gtk accessibility support.
   */
  clutter_disable_accessibility ();
}

static gboolean
post_parse_hook (GOptionContext  *context,
                 GOptionGroup    *group,
                 gpointer         data,
                 GError         **error)
{
  gtk_clutter_is_initialized = TRUE;

  gtk_clutter_init_internal ();

  /* this is required since parsing clutter's option group did not
   * complete the initialization process
   */
  return clutter_init_with_args (NULL, NULL, NULL, NULL, NULL, error) == CLUTTER_INIT_SUCCESS;
}

/**
 * gtk_clutter_get_option_group: (skip)
 *
 * Returns a #GOptionGroup for the command line arguments recognized
 * by Clutter. You should add this group to your #GOptionContext with
 * g_option_context_add_group(), if you are using g_option_context_parse()
 * to parse your commandline arguments instead of using gtk_clutter_init()
 * or gtk_clutter_init_with_args().
 *
 * You should add this option group to your #GOptionContext after
 * the GTK option group created with gtk_get_option_group(), and after
 * the clutter option group obtained from clutter_get_option_group_without_init().
 * You should not use clutter_get_option_group() together with this function.
 *
 * You must pass %TRUE to gtk_get_option_group() since gtk-clutter's option
 * group relies on it.
 *
 * Parsing options using g_option_context_parse() with a #GOptionContext
 * containing the returned #GOptionGroupwith will result in Clutter's and
 * GTK-Clutter's initialisation.  That is, the following code:
 *
 * |[
 *   g_option_context_add_group (context, gtk_get_option_group (TRUE));
 *   g_option_context_add_group (context, cogl_get_option_group ());
 *   g_option_context_add_group (context, clutter_get_option_group_without_init ());
 *   g_option_context_add_group (context, gtk_clutter_get_option_group ());
 *   res = g_option_context_parse (context, &amp;argc, &amp;argc, NULL);
 * ]|
 *
 * is functionally equivalent to:
 *
 * |[
 *   gtk_clutter_init (&amp;argc, &amp;argv);
 * ]|
 *
 * After g_option_context_parse() on a #GOptionContext containing the
 * the returned #GOptionGroup has returned %TRUE, Clutter and GTK-Clutter are
 * guaranteed to be initialized.
 *
 * Return value: (transfer full): a #GOptionGroup for the commandline arguments
 *   recognized by ClutterGtk
 */
GOptionGroup *
gtk_clutter_get_option_group  (void)
{
  GOptionGroup *group;

  group = g_option_group_new ("clutter-gtk", "", "", NULL, NULL);
  g_option_group_set_parse_hooks (group, NULL, post_parse_hook);

  return group;
}

/**
 * gtk_clutter_init:
 * @argc: (inout) (allow-none): pointer to the arguments count, or %NULL
 * @argv: (array length=argc) (inout) (allow-none): pointer to the
 *   arguments vector, or %NULL
 *
 * This function should be called instead of clutter_init() and
 * gtk_init().
 *
 * Return value: %CLUTTER_INIT_SUCCESS on success, a negative integer
 *   on failure.
 */
ClutterInitError
gtk_clutter_init (int    *argc,
                  char ***argv)
{
  if (gtk_clutter_is_initialized)
    return CLUTTER_INIT_SUCCESS;

  gtk_clutter_is_initialized = TRUE;

  if (!gtk_init_check (argc, argv))
    return CLUTTER_INIT_ERROR_UNKNOWN;

  gtk_clutter_init_internal ();

  return clutter_init (argc, argv);
}

/**
 * gtk_clutter_init_with_args:
 * @argc: (inout) (allow-none): a pointer to the number of command line
 *   arguments, or %NULL
 * @argv: (inout) (allow-none) (array length=argc): a pointer to the array
 *   of command line arguments, or %NULL
 * @parameter_string: (allow-none): a string which is displayed in
 *    the first line of <option>--help</option> output, after
 *    <literal><replaceable>programname</replaceable> [OPTION...]</literal>
 * @entries: (allow-none) (array zero-terminated=1): a
 *    %NULL-terminated array of #GOptionEntry<!-- -->s describing the
 *    options of your program
 * @translation_domain: (allow-none): a translation domain to use for
 *    translating the <option>--help</option> output for the options
 *    in @entries with gettext(), or %NULL
 * @error: (allow-none): a return location for errors, or %NULL
 *
 * This function should be called instead of clutter_init() and
 * gtk_init_with_args().
 *
 * Return value: %CLUTTER_INIT_SUCCESS on success, a negative integer
 *   on failure.
 */
ClutterInitError
gtk_clutter_init_with_args (int            *argc,
                            char         ***argv,
                            const char     *parameter_string,
                            GOptionEntry   *entries,
                            const char     *translation_domain,
                            GError        **error)
{
  GOptionGroup *gtk_group, *clutter_group, *cogl_group, *clutter_gtk_group;
  GOptionContext *context;
  gboolean res;

  if (gtk_clutter_is_initialized)
    return CLUTTER_INIT_SUCCESS;

  /* we let gtk+ open the display */
  gtk_group = gtk_get_option_group (TRUE);

  /* and we prevent clutter from doing so too */
  clutter_group = clutter_get_option_group_without_init ();

  G_GNUC_BEGIN_IGNORE_DEPRECATIONS
  cogl_group = cogl_get_option_group ();
  G_GNUC_END_IGNORE_DEPRECATIONS

  clutter_gtk_group = gtk_clutter_get_option_group ();

  context = g_option_context_new (parameter_string);

  g_option_context_add_group (context, gtk_group);
  g_option_context_add_group (context, cogl_group);
  g_option_context_add_group (context, clutter_group);
  g_option_context_add_group (context, clutter_gtk_group);

  if (entries)
    g_option_context_add_main_entries (context, entries, translation_domain);

  res = g_option_context_parse (context, argc, argv, error);
  g_option_context_free (context);

  if (!res)
    return CLUTTER_INIT_ERROR_UNKNOWN;

  return CLUTTER_INIT_SUCCESS;
}

/**
 * gtk_clutter_check_version:
 * @major: the major component of the version,
 *   i.e. 1 if the version is 1.2.3
 * @minor: the minor component of the version,
 *   i.e. 2 if the version is 1.2.3
 * @micro: the micro component of the version,
 *   i.e. 3 if the version is 1.2.3
 *
 * Checks the version of the Clutter-GTK library at run-time.
 *
 * Return value: %TRUE if the version of the library is greater or
 *   equal than the one requested
 *
 * Since: 1.0
 */
gboolean
gtk_clutter_check_version (guint major,
                           guint minor,
                           guint micro)
{
  return (major > clutter_gtk_major_version) ||
         ((major == clutter_gtk_major_version) && (minor > clutter_gtk_minor_version)) ||
         ((major == clutter_gtk_major_version) && (minor == clutter_gtk_minor_version) && (micro >= clutter_gtk_micro_version));
}
