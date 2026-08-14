/***
    This file is part of PulseAudio.

    Copyright 2020 Canonical Ltd.
    Authors:
      Simon Fels <simon.fels@canonical.com>
      James Henstridge <james.henstridge@canonical.com>

    PulseAudio is free software; you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published
    by the Free Software Foundation; either version 2.1 of the License,
    or (at your option) any later version.

    PulseAudio is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
    General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with PulseAudio; if not, see <http://www.gnu.org/licenses/>.
***/

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <glib.h>
#include <snapd-glib/snapd-glib.h>

#include <pulsecore/asyncq.h>
#include <pulsecore/core.h>
#include <pulsecore/idxset.h>
#include <pulsecore/hashmap.h>
#include <pulsecore/module.h>
#include <pulsecore/mutex.h>
#include <pulsecore/thread.h>
#include <pulse/mainloop-api.h>
#include <pulse/xmalloc.h>

#define SNAP_LABEL_PREFIX           "snap."
#define SNAP_LABEL_PREFIX_LENGTH    5

PA_MODULE_AUTHOR("Canonical Ltd");
PA_MODULE_DESCRIPTION("Ubuntu Snap policy management");
PA_MODULE_VERSION(PACKAGE_VERSION);
PA_MODULE_LOAD_ONCE(true);

typedef enum snap_access {
    SNAP_ACCESS_NONE    = 0,
    SNAP_ACCESS_RECORD  = 1 << 0,
    SNAP_ACCESS_CONTROL = 1 << 1,
} snap_access_t;

struct per_client {
    struct userdata *userdata;
    uint32_t index;
    char *snap_name;
    pa_dynarray *pending_requests; /* of pa_access_data */
    bool completed;
    snap_access_t access;
};

struct userdata {
    pa_io_event *io_event;
    pa_hook_slot *connect_record_hook_slot;
    pa_hook_slot *exit_daemon_hook_slot;
    pa_hook_slot *get_module_info_hook_slot;
    pa_hook_slot *load_module_hook_slot;
    pa_hook_slot *unload_module_hook_slot;
    pa_hook_slot *kill_client_hook_slot;

    pa_thread *thread;
    pa_mutex *mutex;
    pa_cond *cond;

    pa_hashmap *clients; /* int => struct per_client */
    pa_asyncq *results; /* of struct per_client */

    /* Data owned by glib thread */
    GMainContext *main_context;
    GMainLoop *main_loop;
    GCancellable *cancellable;
    SnapdClient *snapd;
};

/* ---- Code running in glib thread ---- */

static void complete_check_access(struct per_client *pc, snap_access_t access)
{
    struct userdata *u = pc->userdata;

    pa_mutex_lock(u->mutex);
    pc->access = access;
    pc->completed = true;
    pa_asyncq_push(u->results, pc, true);
    pa_mutex_unlock(u->mutex);
}

static void get_connections_finished(GObject *source_object,
                                     GAsyncResult *result,
                                     gpointer user_data)
{
    struct per_client *pc = user_data;
    struct userdata *u = pc->userdata;
    snap_access_t access = SNAP_ACCESS_NONE;
    g_autoptr(GError) error = NULL;
    g_autoptr(GPtrArray) established = NULL;
    unsigned i;

    if (!snapd_client_get_connections2_finish(u->snapd, result, &established, NULL, NULL, NULL, &error)) {
        pa_log_warn("snapd_client_get_connections2 failed: %s", error->message);
        goto end;
    }

    /* determine pc->access */
    for (i = 0; i < established->len; i++) {
        SnapdConnection *conn = established->pdata[i];
        SnapdPlugRef *plug = snapd_connection_get_plug(conn);
        const char *snap_name = snapd_plug_ref_get_snap(plug);
        const char *iface = snapd_connection_get_interface(conn);

        /* We are only interested in connected plugs of our snap */
        if (strcmp(snap_name, pc->snap_name) != 0) {
            continue;
        }
        if (!strcmp(iface, "pulseaudio") || !strcmp(iface, "audio-record")) {
            access |= SNAP_ACCESS_RECORD;
            break;
        }
    }

end:
    complete_check_access(pc, access);
}

static void get_snap_finished(GObject *source_object,
                              GAsyncResult *result,
                              gpointer user_data)
{
    struct per_client *pc = user_data;
    struct userdata *u = pc->userdata;
    g_autoptr(GError) error = NULL;
    g_autoptr(SnapdSnap) snap = NULL;

    snap = snapd_client_get_snap_finish(u->snapd, result, &error);
    if (!snap) {
        pa_log_warn("snapd_client_get_snap failed: %s", error->message);
        complete_check_access(pc, SNAP_ACCESS_NONE);
        return;
    }

    /* Snaps using classic confinement are granted access */
    if (snapd_snap_get_confinement(snap) == SNAPD_CONFINEMENT_CLASSIC) {
        complete_check_access(pc, SNAP_ACCESS_RECORD | SNAP_ACCESS_CONTROL);
        return;
    }

    /* We have a non-classic snap, we need to check its connected
     * interfaces */
    snapd_client_get_connections2_async(
        u->snapd, SNAPD_GET_CONNECTIONS_FLAGS_NONE, pc->snap_name, NULL,
        u->cancellable, get_connections_finished, pc);
}


static gboolean check_access(void *data)
{
    struct per_client *pc = data;
    struct userdata *u = pc->userdata;

    snapd_client_get_snap_async(u->snapd, pc->snap_name, u->cancellable,
                                get_snap_finished, pc);
    return G_SOURCE_REMOVE;
}


static void thread_main(void *data) {
    struct userdata *u = data;

    pa_mutex_lock(u->mutex);

    u->main_context = g_main_context_new();
    g_main_context_push_thread_default(u->main_context);
    u->main_loop = g_main_loop_new(u->main_context, false);
    u->cancellable = g_cancellable_new();
    u->snapd = snapd_client_new();

    /* Signal main thread that we've finished initialisation */
    pa_cond_signal(u->cond, false);
    pa_mutex_unlock(u->mutex);

    pa_log_info("Starting GLib main loop");
    g_main_loop_run(u->main_loop);
    pa_log_info("GLib main loop exited");

    g_cancellable_cancel(u->cancellable);

    g_clear_object(&u->snapd);
    g_clear_object(&u->cancellable);
    g_main_context_pop_thread_default(u->main_context);
    g_clear_pointer(&u->main_loop, g_main_loop_unref);
    g_clear_pointer(&u->main_context, g_main_context_unref);
}

static gboolean thread_quit(void *data)
{
    struct userdata *u = data;

    g_main_loop_quit(u->main_loop);
    return G_SOURCE_REMOVE;
}

/* ---- Code running in main thread ---- */

static struct per_client *per_client_new(struct userdata *u,
                                         uint32_t client_index,
                                         char *snap_name) {
    struct per_client *pc = pa_xnew0(struct per_client, 1);
    pc->userdata = u;
    pc->index = client_index;
    pc->snap_name = snap_name;
    pc->pending_requests = pa_dynarray_new(NULL);
    pc->completed = false;
    pc->access = SNAP_ACCESS_NONE;
    return pc;
}

static void per_client_free(struct per_client *pc) {
    if (!pc) return;
    pa_xfree(pc->snap_name);
    pa_dynarray_free(pc->pending_requests);
    pa_xfree(pc);
}

static char *client_get_snap_name(pa_core *core, uint32_t client_index) {
    pa_client *client;
    char *label = NULL;
    char *dot;

    client = pa_idxset_get_by_index(core->clients, client_index);
    pa_assert(client != NULL);
    if (client->apparmor_label == NULL) {
        return NULL;
    }

    /* If the AppArmor context does not begin with "snap.", then this
     * is not a snap */
    label = client->apparmor_label;
    if (strncmp(label, SNAP_LABEL_PREFIX, SNAP_LABEL_PREFIX_LENGTH) != 0) {
        return NULL;
    }
    label += SNAP_LABEL_PREFIX_LENGTH;

    dot = strchr(label, '.');
    if (dot == NULL) {
        pa_log_warn("Malformed snapd AppArmor label: %s", client->apparmor_label);
        return NULL;
    }
    return pa_xstrndup(label, dot - label);
}

static pa_hook_result_t check_access_hook(pa_core *core, pa_access_data *d,
                                          struct userdata *u,
                                          snap_access_t required_access) {
    pa_hook_result_t result = PA_HOOK_STOP;
    struct per_client *pc = NULL;
    char *snap_name = NULL;

    pa_mutex_lock(u->mutex);
    pc = pa_hashmap_get(u->clients, (void *)(size_t)d->client_index);
    if (pc) {
        if (pc->completed) {
            result = ((pc->access & required_access) == required_access)
                ? PA_HOOK_OK : PA_HOOK_STOP;
        } else {
            /* A permission check for this snap is currently in progress */
            pa_dynarray_append(pc->pending_requests, d);
            result = PA_HOOK_CANCEL;
        }
        goto end;
    }

    snap_name = client_get_snap_name(core, d->client_index);
    if (!snap_name) {
        /* Not a snap, so allow access */
        result = PA_HOOK_OK;
        goto end;
    }

    /* create new per client struct, and submit to glib thread */
    pc = per_client_new(u, d->client_index, snap_name);
    pa_dynarray_append(pc->pending_requests, d);
    pa_hashmap_put(u->clients, (void *) (size_t) d->client_index, pc);
    pa_log_info("Checking access for client %d (%s)", pc->index, pc->snap_name);
    g_main_context_invoke(u->main_context, check_access, pc);

    result = PA_HOOK_CANCEL;

end:
    pa_mutex_unlock(u->mutex);
    return result;
}

static pa_hook_result_t require_record_access_hook(pa_core *core,
                                                   pa_access_data *d,
                                                   struct userdata *u) {
    return check_access_hook(core, d, u, SNAP_ACCESS_RECORD);
}

static pa_hook_result_t require_control_access_hook(pa_core *core,
                                                    pa_access_data *d,
                                                    struct userdata *u) {
    return check_access_hook(core, d, u, SNAP_ACCESS_CONTROL);
}

static void deliver_result(struct userdata *u, struct per_client *pc) {
    pa_access_data *ad;
    unsigned i;

    pa_log_info("Access check for client %u (%s): %d",
                pc->index, pc->snap_name, pc->access);

    /* Call the hooks without holding the mutex, since this will
     * recurse into check_snap_access.  Access to pending_requests
     * should be safe here, since connect_record_hook wont alter the
     * array when the access check is complete. */
    PA_DYNARRAY_FOREACH(ad, pc->pending_requests, i) {
        ad->async_finish_cb(ad, pc->access != SNAP_ACCESS_NONE);
    }
    pa_mutex_lock(u->mutex);
    pa_hashmap_remove_and_free(u->clients, (void *) (size_t) pc->index);
    pa_mutex_unlock(u->mutex);
}

static void check_result(pa_mainloop_api *a, pa_io_event *e, int fd, pa_io_event_flags_t flags, void *userdata) {
    struct userdata *u = userdata;
    struct per_client *pc;

    pa_asyncq_read_after_poll(u->results);
    while ((pc = pa_asyncq_pop(u->results, false)) != NULL) {
        deliver_result(u, pc);
    }
    pa_asyncq_read_before_poll(u->results);
}

int pa__init(pa_module *m) {
    struct userdata *u;

    u = pa_xnew0(struct userdata, 1);
    m->userdata = u;
    u->mutex = pa_mutex_new(false, false);
    u->cond = pa_cond_new();

    u->clients = pa_hashmap_new_full(pa_idxset_trivial_hash_func,
                                     pa_idxset_trivial_compare_func,
                                     NULL, (pa_free_cb_t) per_client_free);

    u->results = pa_asyncq_new(0);
    u->io_event = m->core->mainloop->io_new(
        m->core->mainloop, pa_asyncq_read_fd(u->results), PA_IO_EVENT_INPUT,
        check_result, u);
    pa_asyncq_read_before_poll(u->results);

    u->connect_record_hook_slot = pa_hook_connect(
        &m->core->access[PA_ACCESS_HOOK_CONNECT_RECORD], PA_HOOK_NORMAL,
        (pa_hook_cb_t) require_record_access_hook, u);
    u->exit_daemon_hook_slot = pa_hook_connect(
        &m->core->access[PA_ACCESS_HOOK_EXIT_DAEMON], PA_HOOK_NORMAL,
        (pa_hook_cb_t) require_control_access_hook, u);
    u->get_module_info_hook_slot = pa_hook_connect(
        &m->core->access[PA_ACCESS_HOOK_GET_MODULE_INFO], PA_HOOK_NORMAL,
        (pa_hook_cb_t) require_control_access_hook, u);
    u->load_module_hook_slot = pa_hook_connect(
        &m->core->access[PA_ACCESS_HOOK_LOAD_MODULE], PA_HOOK_NORMAL,
        (pa_hook_cb_t) require_control_access_hook, u);
    u->unload_module_hook_slot = pa_hook_connect(
        &m->core->access[PA_ACCESS_HOOK_UNLOAD_MODULE], PA_HOOK_NORMAL,
        (pa_hook_cb_t) require_control_access_hook, u);
    u->kill_client_hook_slot = pa_hook_connect(
        &m->core->access[PA_ACCESS_HOOK_KILL_CLIENT], PA_HOOK_NORMAL,
        (pa_hook_cb_t) require_control_access_hook, u);

    /* Start glib thread and wait for it to finish initialising. */
    pa_mutex_lock(u->mutex);
    u->thread = pa_thread_new("snapd-glib", thread_main, u);
    pa_cond_wait(u->cond, u->mutex);
    pa_mutex_unlock(u->mutex);

    return 0;
}

void pa__done(pa_module *m) {
    struct userdata *u = m->userdata;
    if (!u) return;

    pa_hook_slot_free(u->connect_record_hook_slot);
    pa_hook_slot_free(u->exit_daemon_hook_slot);
    pa_hook_slot_free(u->get_module_info_hook_slot);
    pa_hook_slot_free(u->load_module_hook_slot);
    pa_hook_slot_free(u->unload_module_hook_slot);
    pa_hook_slot_free(u->kill_client_hook_slot);

    m->core->mainloop->io_free(u->io_event);

    /* Stop the glib thread and wait for it to exit */
    g_main_context_invoke(u->main_context, thread_quit, u);
    pa_thread_join(u->thread);
    pa_thread_free(u->thread);

    pa_asyncq_free(u->results, NULL); /* items in queue owned by u->clients */
    g_clear_pointer(&u->clients, pa_hashmap_free);

    g_clear_pointer(&u->cond, pa_cond_free);
    g_clear_pointer(&u->mutex, pa_mutex_free);

    pa_xfree(u);
}
