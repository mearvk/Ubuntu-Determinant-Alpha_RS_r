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

#include "config.h"

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <glib/gstdio.h>
#include <gmodule.h>
#include "clutter-immodule.h"
#include "clutter-imcontextsimple.h"

#define SIMPLE_ID "clutter-im-context-simple"

typedef struct _ClutterIMModule      ClutterIMModule;
typedef struct _ClutterIMModuleClass ClutterIMModuleClass;

#define CLUTTER_TYPE_IM_MODULE          (clutter_im_module_get_type ())
#define CLUTTER_IM_MODULE(im_module)    (G_TYPE_CHECK_INSTANCE_CAST ((im_module), CLUTTER_TYPE_IM_MODULE, ClutterIMModule))
#define CLUTTER_IS_IM_MODULE(im_module) (G_TYPE_CHECK_INSTANCE_TYPE ((im_module), CLUTTER_TYPE_IM_MODULE))

struct _ClutterIMModule
{
  GTypeModule parent_instance;

  gboolean builtin;

  GModule *library;

  void          (*list)   (const ClutterIMContextInfo ***contexts,
		           guint                    *n_contexts);
  void          (*init)   (GTypeModule              *module);
  void          (*exit)   (void);
  ClutterIMContext *(*create) (const gchar              *context_id);

  ClutterIMContextInfo **contexts;
  guint n_contexts;

  gchar *path;
};

struct _ClutterIMModuleClass
{
  GTypeModuleClass parent_class;
};

static GType clutter_im_module_get_type (void);

static gint n_loaded_contexts = 0;
static GHashTable *contexts_hash = NULL;
static GSList *modules_list = NULL;

static GObjectClass *parent_class = NULL;

static gchar *im_module_file = NULL;

static gchar *
clutter_get_im_module_file (void)
{
  const gchar *var = g_getenv ("CLUTTER_IM_MODULE_FILE");
  gchar *result = NULL;

  if (var)
    result = g_strdup (var);

  if (!result)
    {
      if (im_module_file)
	result = g_strdup (im_module_file);
      else
	result = g_build_filename (CLUTTER_IMCONTEXT_SYSCONFDIR, "clutter-imcontext", "clutter.immodules", NULL);
    }

  return result;
}


static gboolean
clutter_im_module_load (GTypeModule *module)
{
  ClutterIMModule *im_module = CLUTTER_IM_MODULE (module);

  if (!im_module->builtin)
    {
      im_module->library = g_module_open (im_module->path, G_MODULE_BIND_LAZY | G_MODULE_BIND_LOCAL);
      if (!im_module->library)
	{
	  g_warning ("%s", g_module_error());
	  return FALSE;
	}

      /* extract symbols from the lib */
      if (!g_module_symbol (im_module->library, "im_module_init",
			    (gpointer *)&im_module->init) ||
	  !g_module_symbol (im_module->library, "im_module_exit",
			    (gpointer *)&im_module->exit) ||
	  !g_module_symbol (im_module->library, "im_module_list",
			    (gpointer *)&im_module->list) ||
	  !g_module_symbol (im_module->library, "im_module_create",
			    (gpointer *)&im_module->create))
	{
	  g_warning ("%s", g_module_error());
	  g_module_close (im_module->library);

	  return FALSE;
	}
    }

  /* call the module's init function to let it */
  /* setup anything it needs to set up. */
  im_module->init (module);

  return TRUE;
}

static void
clutter_im_module_unload (GTypeModule *module)
{
  ClutterIMModule *im_module = CLUTTER_IM_MODULE (module);

  im_module->exit();

  if (!im_module->builtin)
    {
      g_module_close (im_module->library);
      im_module->library = NULL;

      im_module->init = NULL;
      im_module->exit = NULL;
      im_module->list = NULL;
      im_module->create = NULL;
    }
}

/* This only will ever be called if an error occurs during
 * initialization
 */
static void
clutter_im_module_finalize (GObject *object)
{
  ClutterIMModule *module = CLUTTER_IM_MODULE (object);

  g_free (module->path);

  parent_class->finalize (object);
}

G_DEFINE_TYPE (ClutterIMModule, clutter_im_module, G_TYPE_TYPE_MODULE)

static void
clutter_im_module_class_init (ClutterIMModuleClass *class)
{
  GTypeModuleClass *module_class = G_TYPE_MODULE_CLASS (class);
  GObjectClass *gobject_class = G_OBJECT_CLASS (class);

  parent_class = G_OBJECT_CLASS (g_type_class_peek_parent (class));

  module_class->load = clutter_im_module_load;
  module_class->unload = clutter_im_module_unload;

  gobject_class->finalize = clutter_im_module_finalize;
}

static void
clutter_im_module_init (ClutterIMModule* object)
{
}

static void
free_info (ClutterIMContextInfo *info)
{
  g_free ((char *)info->context_id);
  g_free ((char *)info->context_name);
  g_free ((char *)info->domain);
  g_free ((char *)info->domain_dirname);
  g_free ((char *)info->default_locales);
  g_free (info);
}

static void
add_module (ClutterIMModule *module, GSList *infos)
{
  GSList *tmp_list = infos;
  gint i = 0;
  gint n = g_slist_length (infos);
  module->contexts = g_new (ClutterIMContextInfo *, n);

  while (tmp_list)
    {
      ClutterIMContextInfo *info = tmp_list->data;

      if (g_hash_table_lookup (contexts_hash, info->context_id))
	{
	  free_info (info);	/* Duplicate */
	}
      else
	{
	  g_hash_table_insert (contexts_hash, (char *)info->context_id, module);
	  module->contexts[i++] = tmp_list->data;
	  n_loaded_contexts++;
	}

      tmp_list = tmp_list->next;
    }
  g_slist_free (infos);
  module->n_contexts = i;

  modules_list = g_slist_prepend (modules_list, module);
}

static void
clutter_im_module_initialize (void)
{
  GString *line_buf = g_string_new (NULL);
  GString *tmp_buf = g_string_new (NULL);
  gchar *filename = clutter_get_im_module_file();
  FILE *file;
  gboolean have_error = FALSE;

  ClutterIMModule *module = NULL;
  GSList *infos = NULL;

  contexts_hash = g_hash_table_new (g_str_hash, g_str_equal);

  file = g_fopen (filename, "r");
  if (!file)
    {
      /* In case someone wants only the default input method,
       * we allow no file at all.
       */
      g_string_free (line_buf, TRUE);
      g_string_free (tmp_buf, TRUE);
      g_free (filename);
      return;
    }

  while (!have_error && pango_read_line (file, line_buf))
    {
      const char *p;

      p = line_buf->str;

      if (!pango_skip_space (&p))
	{
	  /* Blank line marking the end of a module
	   */
	  if (module && *p != '#')
	    {
	      add_module (module, infos);
	      module = NULL;
	      infos = NULL;
	    }

	  continue;
	}

      if (!module)
	{
	  /* Read a module location
	   */
	  module = g_object_new (CLUTTER_TYPE_IM_MODULE, NULL);

	  if (!pango_scan_string (&p, tmp_buf) ||
	      pango_skip_space (&p))
	    {
	      g_warning ("Error parsing context info in '%s'\n  %s",
			 filename, line_buf->str);
	      have_error = TRUE;
	    }

	  module->path = g_strdup (tmp_buf->str);
	  g_type_module_set_name (G_TYPE_MODULE (module), module->path);
	}
      else
	{
	  ClutterIMContextInfo *info = g_new0 (ClutterIMContextInfo, 1);

	  /* Read information about a context type
	   */
	  if (!pango_scan_string (&p, tmp_buf))
	    goto context_error;
	  info->context_id = g_strdup (tmp_buf->str);

	  if (!pango_scan_string (&p, tmp_buf))
	    goto context_error;
	  info->context_name = g_strdup (tmp_buf->str);

	  if (!pango_scan_string (&p, tmp_buf))
	    goto context_error;
	  info->domain = g_strdup (tmp_buf->str);

	  if (!pango_scan_string (&p, tmp_buf))
	    goto context_error;
	  info->domain_dirname = g_strdup (tmp_buf->str);

	  if (!pango_scan_string (&p, tmp_buf))
	    goto context_error;
	  info->default_locales = g_strdup (tmp_buf->str);

	  if (pango_skip_space (&p))
	    goto context_error;

	  infos = g_slist_prepend (infos, info);
	  continue;

	context_error:
	  g_warning ("Error parsing context info in '%s'\n  %s",
		     filename, line_buf->str);
	  have_error = TRUE;
	}
    }

  if (have_error)
    {
      GSList *tmp_list = infos;
      while (tmp_list)
	{
	  free_info (tmp_list->data);
	  tmp_list = tmp_list->next;
	}
      g_slist_free (infos);

      g_object_unref (module);
    }
  else if (module)
    add_module (module, infos);

  fclose (file);
  g_string_free (line_buf, TRUE);
  g_string_free (tmp_buf, TRUE);
  g_free (filename);
}

static gint
compare_clutterimcontextinfo_name(const ClutterIMContextInfo **a,
			      const ClutterIMContextInfo **b)
{
  return g_utf8_collate ((*a)->context_name, (*b)->context_name);
}

/**
 * _clutter_im_module_list:
 * @contexts: location to store an array of pointers to #ClutterIMContextInfo
 *            this array should be freed with g_free() when you are finished.
 *            The structures it points are statically allocated and should
 *            not be modified or freed.
 * @n_contexts: the length of the array stored in @contexts
 *
 * List all available types of input method context
 **/
void
_clutter_im_module_list (const ClutterIMContextInfo ***contexts,
		     guint                    *n_contexts)
{
  int n = 0;

  static ClutterIMContextInfo simple_context_info = {
    SIMPLE_ID,
    "Simple",
    "",
    "",
    ""
  };


  if (!contexts_hash)
    clutter_im_module_initialize ();

  if (n_contexts)
    *n_contexts = (n_loaded_contexts + 1);

  if (contexts)
    {
      GSList *tmp_list;
      int i;

      *contexts = g_new (const ClutterIMContextInfo *, n_loaded_contexts + 1);

      (*contexts)[n++] = &simple_context_info;

      tmp_list = modules_list;
      while (tmp_list)
	{
	  ClutterIMModule *module = tmp_list->data;

	  for (i=0; i<module->n_contexts; i++)
	    (*contexts)[n++] = module->contexts[i];

	  tmp_list = tmp_list->next;
	}

      /* fisrt element (Default) should always be at top */
      qsort ((*contexts)+1, n-1, sizeof (ClutterIMContextInfo *), (GCompareFunc)compare_clutterimcontextinfo_name);
    }
}

/**
 * _clutter_im_module_create:
 * @context_id: the context ID for the context type to create
 *
 * Create an IM context of a type specified by the string
 * ID @context_id.
 *
 * Return value: a newly created input context of or @context_id, or
 * if that could not be created, a newly created ClutterIMContextSimple.
 **/
ClutterIMContext *
_clutter_im_module_create (const gchar *context_id)
{
  ClutterIMModule *im_module;
  ClutterIMContext *context = NULL;

  if (!contexts_hash)
    clutter_im_module_initialize ();

  if (strcmp (context_id, SIMPLE_ID) != 0)
    {
      im_module = g_hash_table_lookup (contexts_hash, context_id);
      if (!im_module)
	{
	  g_warning ("Attempt to load unknown IM context type '%s'", context_id);
	}
      else
	{
	  if (g_type_module_use (G_TYPE_MODULE (im_module)))
	    {
	      context = im_module->create (context_id);
	      g_type_module_unuse (G_TYPE_MODULE (im_module));
	    }

	  if (!context)
	    g_warning ("Loading IM context type '%s' failed", context_id);
	}
    }

  if (!context)
     return clutter_im_context_simple_new ();
  else
    return context;
}

/**
 * _clutter_im_module_get_default_context_id:
 *
 * Return value: the context ID (will never be %NULL)
 **/
const gchar *
_clutter_im_module_get_default_context_id ()
{
  const gchar *context_id = NULL;
  const gchar *envvar;

  if (!contexts_hash)
    clutter_im_module_initialize ();

  envvar = g_getenv ("CLUTTER_IM_MODULE");

  if (envvar &&
      (strcmp (envvar, SIMPLE_ID) == 0 ||
       g_hash_table_lookup (contexts_hash, envvar)))
    return envvar;

  return context_id ? context_id : SIMPLE_ID;
}

gchar *
get_im_module_path (void)
{
  gchar *module_path = NULL;

  module_path = g_build_filename (CLUTTER_IMCONTEXT_LIBDIR,
                                "clutter-imcontext", "immodules", NULL);

  return module_path;
}
