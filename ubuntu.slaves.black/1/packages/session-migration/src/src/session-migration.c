/*
 * Copyright (C) 2010 Red Hat, Inc.
 * Copyright (C) 2012 Canonical
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the Licence, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors: Matthias Clasen <mclasen@redhat.com>
 *          Didier Roche <didier.roche@canonical.com>
 */

#include <sys/stat.h>

#include <glib.h>
#include <gio/gio.h>
#include <errno.h>
#include <locale.h>

#define MIGRATION_FILENAME_BASE "session_migration-"

static gboolean verbose = FALSE;
static gboolean dry_run = FALSE;

static gchar*
get_migration_filename ()
{
  gchar *full_session_name;
  gchar *filename;

  full_session_name = g_strdup_printf ("%s%s", MIGRATION_FILENAME_BASE, g_getenv("DESKTOP_SESSION"));
  filename = g_build_filename (g_get_user_data_dir (), full_session_name, NULL);
  g_free(full_session_name);

  return filename;
}

static gboolean
migrate_from_file (const gchar *script_path)
{
  gchar  *stdout = NULL;
  gchar  *stderr = NULL;
  gint    exit_status;
  GError *error = NULL;

  if (verbose)
    g_print ("Executing: %s\n", script_path);

  if (dry_run)
    return TRUE;

  if (!g_spawn_command_line_sync(script_path, &stdout, &stderr, &exit_status, &error) || (exit_status != 0))
    {
      if (error != NULL)
        g_printerr ("%s\nstdout: %s\nstderr: %s\n", error->message, stdout, stderr);
      else
        g_printerr("Exited with an error\nstdout: %s\nstderr: %s\n", stdout, stderr);
      return FALSE;
    }
  return TRUE;
}

static gboolean
migrate_from_dir (const gchar *dirname,
                  time_t       stored_mtime,
                  GHashTable  *migrated,
                  gboolean    *changed)
{
  time_t dir_mtime;
  struct stat statbuf;
  GDir *dir;
  const gchar *name;
  gchar *filename;
  GSList *migration_scripts = NULL;
  GSList *current_script;
  GError *error;
  *changed = FALSE;

  /* If the directory is not newer, exit */
  if (stat (dirname, &statbuf) == 0)
    dir_mtime = statbuf.st_mtime;
  else
    {
      if (verbose)
        g_print ("Directory '%s' does not exist, nothing to do\n", dirname);
      return TRUE;
    }

  if (dir_mtime <= stored_mtime)
    {
      if (verbose)
        g_print ("Directory '%s' all uptodate, nothing to do\n", dirname);
      return TRUE;
    }

  error = NULL;
  dir = g_dir_open (dirname, 0, &error);
  if (dir == NULL)
    {
      g_printerr ("Failed to open '%s': %s\n", dirname, error->message);
      return FALSE;
    }
  if (verbose)
      g_print ("Using '%s' directory\n", dirname);

  while ((name = g_dir_read_name (dir)) != NULL)
    {
      if (g_hash_table_lookup (migrated, name))
        {
          if (verbose)
            g_print ("File '%s already migrated, skipping\n", name);
          continue;
        }
      migration_scripts = g_slist_insert_sorted(migration_scripts,
                                 (gpointer)name, (GCompareFunc)g_strcmp0);
    }

  if (migration_scripts != NULL)
  {
    current_script = migration_scripts;

    do {
      filename = g_build_filename (dirname, current_script->data, NULL);

      if (migrate_from_file (filename))
        {
          gchar *myname = g_strdup (current_script->data);

          /* add the file to the migrated list */
          g_hash_table_insert (migrated, myname, myname);
          *changed = TRUE;
        }

      g_free (filename);
    } while ((current_script = g_slist_next(current_script)) != NULL);
    g_slist_free (migration_scripts);
  }
  
  g_dir_close (dir);

  return TRUE;
}

/* get_string_set() and set_string_set() could be GKeyFile API */
static GHashTable *
get_string_set (GKeyFile     *keyfile,
                const gchar  *group,
                const gchar  *key,
                GError      **error)
{
  GHashTable *migrated;
  gchar **list;
  gint i;

  list = g_key_file_get_string_list (keyfile, group, key, NULL, error);

  if (list == NULL)
    return NULL;

  migrated = g_hash_table_new_full (g_str_hash, g_str_equal, g_free, NULL);
  for (i = 0; list[i]; i++)
    g_hash_table_insert (migrated, list[i], list[i]);

  /* The hashtable now owns the strings, so only free the array */
  g_free (list);

  return migrated;
}

static void
set_string_set (GKeyFile    *keyfile,
                const gchar *group,
                const gchar *key,
                GHashTable  *set)
{
  GHashTableIter iter;
  GString *list;
  gpointer item;

  list = g_string_new (NULL);
  g_hash_table_iter_init (&iter, set);
  while (g_hash_table_iter_next (&iter, &item, NULL))
    g_string_append_printf (list, "%s;", (const gchar *) item);

  g_key_file_set_value (keyfile, group, key, list->str);
  g_string_free (list, TRUE);
}

static GHashTable *
load_state (time_t *mtime)
{
  GHashTable *migrated;
  GHashTable *tmp;
  gchar *filename;
  GKeyFile *keyfile;
  GError *error;
  gchar *str;

  migrated = g_hash_table_new_full (g_str_hash, g_str_equal, g_free, NULL);

  filename = get_migration_filename();

  /* ensure file exists */
  if (!g_file_test (filename, G_FILE_TEST_EXISTS))
    {
      g_free (filename);
      return migrated;
    }

  error = NULL;
  keyfile = g_key_file_new();
  if (!g_key_file_load_from_file (keyfile, filename, 0, &error))
    {
      g_printerr ("%s: %s\n", filename, error->message);
      g_error_free (error);
      g_key_file_free (keyfile);
      g_free (filename);
      return migrated;
    }

  error = NULL;
  if ((str = g_key_file_get_string (keyfile, "State", "timestamp", &error)) == NULL)
    {
      g_printerr ("%s\n", error->message);
      g_error_free (error);
    }
  else
    {
      *mtime = (time_t)g_ascii_strtoll (str, NULL, 0);
      g_free (str);
    }

  error = NULL;
  if ((tmp = get_string_set (keyfile, "State", "migrated", &error)) == NULL)
    {
      g_printerr ("%s\n", error->message);
      g_error_free (error);
    }
  else
    {
      g_hash_table_unref (migrated);
      migrated = tmp;
    }

  g_key_file_free (keyfile);
  g_free (filename);

  return migrated;
}

static gboolean
save_state (GHashTable *migrated)
{
  gchar *filename;
  GKeyFile *keyfile;
  gchar *str;
  GError *error;
  gboolean result;

  /* Make sure the state directory exists */
  if (g_mkdir_with_parents (g_get_user_data_dir (), 0700))
    {
      g_printerr ("Failed to create directory %s: %s\n",
                  g_get_user_data_dir (), g_strerror (errno));
      return FALSE;
    }

  filename = get_migration_filename();
  keyfile = g_key_file_new ();

  str = g_strdup_printf ("%ld", time (NULL));
  g_key_file_set_string (keyfile,
                         "State", "timestamp", str);
  g_free (str);

  set_string_set (keyfile, "State", "migrated", migrated);

  str = g_key_file_to_data (keyfile, NULL, NULL);
  g_key_file_free (keyfile);

  error = NULL;
  if (!g_file_set_contents (filename, str, -1, &error))
    {
      g_printerr ("%s\n", error->message);
      g_error_free (error);

      result = FALSE;
    }
  else
    result = TRUE;

  g_free (filename);
  g_free (str);

  return result;
}

int
main (int argc, char *argv[])
{
  time_t stored_mtime = 0;
  const gchar * const *data_dirs;
  const gchar *extra_file = NULL;
  GError *error;
  GHashTable *migrated;
  gboolean changed = FALSE;
  int i;

  GOptionContext *context;
  GOptionEntry entries[] = {
    { "verbose", 0, 0, G_OPTION_ARG_NONE, &verbose, "show verbose messages", NULL },
    { "dry-run", 0, 0, G_OPTION_ARG_NONE, &dry_run, "do not perform any changes", NULL },
    { "file", 0, 0, G_OPTION_ARG_STRING, &extra_file, "Force a migration from this file only (no storage of migrated status)", NULL },
    { NULL }
  };

  setlocale (LC_ALL, "");

  g_type_init();

  context = g_option_context_new ("");
  g_option_context_set_summary (context,
    "Migrate in user session settings.");
  g_option_context_add_main_entries (context, entries, NULL);

  error = NULL;
  if (!g_option_context_parse (context, &argc, &argv, &error))
    {
      g_printerr ("%s\n", error->message);
      return 1;
    }
  g_option_context_free (context);

  migrated = load_state (&stored_mtime);

  if (extra_file)
    {
      if (!migrate_from_file (extra_file))
        return 1;
      return 0;
    }

  data_dirs = g_get_system_data_dirs ();
  for (i = 0; data_dirs[i]; i++)
    {
      gchar *migration_dir;
      gboolean changed_in_dir;

      migration_dir = g_build_filename (data_dirs[i], "session-migration", "scripts", NULL);

      if (!migrate_from_dir (migration_dir, stored_mtime, migrated, &changed_in_dir)) {
        g_free (migration_dir);
        g_hash_table_destroy (migrated);
        return 1;
      }
      changed = changed | changed_in_dir;

      g_free (migration_dir);
    }

  if (changed && !dry_run)
    {
      if (!save_state (migrated))
      {
        g_hash_table_destroy (migrated);
        return 1;
      }
    }
  g_hash_table_destroy (migrated);

  return 0;
}
