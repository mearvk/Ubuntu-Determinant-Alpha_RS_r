/* LUA - a LUA scriptable GTK+ engine
 * Copyright (C) 2006 Daniel Borgmann <daniel.borgmann@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 * Project contact: <gnome-themes-list@gnome.org>
 *
 */


#include <sys/stat.h>

#include "misc_utils.h"

gchar*
misc_utils_locate_theme_path (const gchar *name)
{
	gchar *path = NULL;
	const gchar *home_dir;
	gchar *subpath = g_strdup ("gtk-2.0" G_DIR_SEPARATOR_S "gtk-theme.lua");
	
	home_dir = g_get_home_dir ();
	if (home_dir)
	{
		path = g_build_filename (home_dir, ".themes", name, subpath, NULL);
		if (!g_file_test (path, G_FILE_TEST_EXISTS))
		{
			g_free (path);
			path = NULL;
		}
	}
	
	if (!path)
	{
		gchar *theme_dir = gtk_rc_get_theme_dir ();
		path = g_build_filename (theme_dir, name, subpath, NULL);
		g_free (theme_dir);
		
		if (!g_file_test (path, G_FILE_TEST_EXISTS))
		{
			g_free (path);
			path = NULL;
		}
	}
	
	/* check for a up-to-date compiled version */
	if (path)
	{
		gchar *cpath = g_strconcat (path, "c", NULL);
		
		if (g_file_test (cpath, G_FILE_TEST_EXISTS))
		{
			struct stat p;
			struct stat c;
			stat (path, &p);
			stat (cpath, &c);
			
			if (c.st_mtime >= p.st_mtime)
				path = g_strdup (cpath);
		}
		g_free (cpath);
	}
	
	g_free (subpath);
	return path;
}
