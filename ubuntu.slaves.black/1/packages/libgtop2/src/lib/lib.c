/* lib.c */
/* This is a generated file.  Please modify `lib.pl' */

#include <config.h>

#include <glibtop.h>
#include <glibtop/error.h>
#include <glibtop/open.h>

#include <glibtop/sysdeps.h>
#include <glibtop/union.h>
#include <glib/gi18n-lib.h>

#include <glibtop/command.h>

/* Some required fields are missing. */

static void
_glibtop_missing_feature (glibtop *server, const char *feature,
			  const guint64 present, guint64 *required)
{
	guint64 old_required = *required;

	/* Return if we have all required fields. */
	if ((~present & old_required) == 0)
		return;

	switch (server->error_method) {
	case GLIBTOP_ERROR_METHOD_WARN_ONCE:
		*required &= present;
	case GLIBTOP_ERROR_METHOD_WARN:
		glibtop_warn_r (server,
				_("glibtop_get_%s (): Client requested "
				  "field mask %05lx, but only have %05lx."),
				 feature, (unsigned long) old_required,
				 (unsigned long) present);
		break;
	case GLIBTOP_ERROR_METHOD_ABORT:
		glibtop_error_r (server,
				 _("glibtop_get_%s (): Client requested "
				  "field mask %05lx, but only have %05lx."),
				 feature, (unsigned long) old_required,
				 (unsigned long) present);
		break;
	}
}

/* Library functions. */

void
glibtop_get_cpu_l (glibtop *server, glibtop_cpu *buf)
{
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_CPU), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_CPU)))
	{
		const void *send_ptr = NULL;
		const size_t send_size = 0;

		glibtop_call_l (server, GLIBTOP_CMND_CPU,
				send_size, send_ptr,
				sizeof (glibtop_cpu), buf);
	} else {
#if (!GLIBTOP_SUID_CPU)
		glibtop_get_cpu_s (server, buf);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_cpu");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.cpu)
		_glibtop_missing_feature (server, "cpu", buf->flags,
					  &server->required.cpu);
}

void
glibtop_get_mem_l (glibtop *server, glibtop_mem *buf)
{
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_MEM), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_MEM)))
	{
		const void *send_ptr = NULL;
		const size_t send_size = 0;

		glibtop_call_l (server, GLIBTOP_CMND_MEM,
				send_size, send_ptr,
				sizeof (glibtop_mem), buf);
	} else {
#if (!GLIBTOP_SUID_MEM)
		glibtop_get_mem_s (server, buf);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_mem");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.mem)
		_glibtop_missing_feature (server, "mem", buf->flags,
					  &server->required.mem);
}

void
glibtop_get_swap_l (glibtop *server, glibtop_swap *buf)
{
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_SWAP), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_SWAP)))
	{
		const void *send_ptr = NULL;
		const size_t send_size = 0;

		glibtop_call_l (server, GLIBTOP_CMND_SWAP,
				send_size, send_ptr,
				sizeof (glibtop_swap), buf);
	} else {
#if (!GLIBTOP_SUID_SWAP)
		glibtop_get_swap_s (server, buf);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_swap");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.swap)
		_glibtop_missing_feature (server, "swap", buf->flags,
					  &server->required.swap);
}

void
glibtop_get_uptime_l (glibtop *server, glibtop_uptime *buf)
{
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_UPTIME), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_UPTIME)))
	{
		const void *send_ptr = NULL;
		const size_t send_size = 0;

		glibtop_call_l (server, GLIBTOP_CMND_UPTIME,
				send_size, send_ptr,
				sizeof (glibtop_uptime), buf);
	} else {
#if (!GLIBTOP_SUID_UPTIME)
		glibtop_get_uptime_s (server, buf);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_uptime");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.uptime)
		_glibtop_missing_feature (server, "uptime", buf->flags,
					  &server->required.uptime);
}

void
glibtop_get_loadavg_l (glibtop *server, glibtop_loadavg *buf)
{
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_LOADAVG), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_LOADAVG)))
	{
		const void *send_ptr = NULL;
		const size_t send_size = 0;

		glibtop_call_l (server, GLIBTOP_CMND_LOADAVG,
				send_size, send_ptr,
				sizeof (glibtop_loadavg), buf);
	} else {
#if (!GLIBTOP_SUID_LOADAVG)
		glibtop_get_loadavg_s (server, buf);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_loadavg");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.loadavg)
		_glibtop_missing_feature (server, "loadavg", buf->flags,
					  &server->required.loadavg);
}

void
glibtop_get_shm_limits_l (glibtop *server, glibtop_shm_limits *buf)
{
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_SHM_LIMITS), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_SHM_LIMITS)))
	{
		const void *send_ptr = NULL;
		const size_t send_size = 0;

		glibtop_call_l (server, GLIBTOP_CMND_SHM_LIMITS,
				send_size, send_ptr,
				sizeof (glibtop_shm_limits), buf);
	} else {
#if (!GLIBTOP_SUID_SHM_LIMITS)
		glibtop_get_shm_limits_s (server, buf);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_shm_limits");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.shm_limits)
		_glibtop_missing_feature (server, "shm_limits", buf->flags,
					  &server->required.shm_limits);
}

void
glibtop_get_msg_limits_l (glibtop *server, glibtop_msg_limits *buf)
{
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_MSG_LIMITS), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_MSG_LIMITS)))
	{
		const void *send_ptr = NULL;
		const size_t send_size = 0;

		glibtop_call_l (server, GLIBTOP_CMND_MSG_LIMITS,
				send_size, send_ptr,
				sizeof (glibtop_msg_limits), buf);
	} else {
#if (!GLIBTOP_SUID_MSG_LIMITS)
		glibtop_get_msg_limits_s (server, buf);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_msg_limits");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.msg_limits)
		_glibtop_missing_feature (server, "msg_limits", buf->flags,
					  &server->required.msg_limits);
}

void
glibtop_get_sem_limits_l (glibtop *server, glibtop_sem_limits *buf)
{
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_SEM_LIMITS), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_SEM_LIMITS)))
	{
		const void *send_ptr = NULL;
		const size_t send_size = 0;

		glibtop_call_l (server, GLIBTOP_CMND_SEM_LIMITS,
				send_size, send_ptr,
				sizeof (glibtop_sem_limits), buf);
	} else {
#if (!GLIBTOP_SUID_SEM_LIMITS)
		glibtop_get_sem_limits_s (server, buf);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_sem_limits");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.sem_limits)
		_glibtop_missing_feature (server, "sem_limits", buf->flags,
					  &server->required.sem_limits);
}

pid_t*
glibtop_get_proclist_l (glibtop *server, glibtop_proclist *buf,
                        gint64 which, gint64 arg)
{
	pid_t* retval = (pid_t*) 0;
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_PROCLIST), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_PROCLIST)))
	{
		struct {
			gint64 buf_which;
			gint64 buf_arg;
		} param_buf;

		param_buf.buf_which = which;
		param_buf.buf_arg = arg;

		const void *send_ptr = &param_buf;
		const size_t send_size = sizeof param_buf;

		retval = glibtop_call_l (server, GLIBTOP_CMND_PROCLIST,
				         send_size, send_ptr,
				         sizeof (glibtop_proclist), buf);
	} else {
#if (!GLIBTOP_SUID_PROCLIST)
		retval = glibtop_get_proclist_s (server, buf, which, arg);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_proclist");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.proclist)
		_glibtop_missing_feature (server, "proclist", buf->flags,
					  &server->required.proclist);

	/* Now we can return. */

	return retval;
}

void
glibtop_get_proc_state_l (glibtop *server, glibtop_proc_state *buf,
                          pid_t pid)
{
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_PROC_STATE), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_PROC_STATE)))
	{
		struct {
			pid_t buf_pid;
		} param_buf;

		param_buf.buf_pid = pid;

		const void *send_ptr = &param_buf;
		const size_t send_size = sizeof param_buf;

		glibtop_call_l (server, GLIBTOP_CMND_PROC_STATE,
				send_size, send_ptr,
				sizeof (glibtop_proc_state), buf);
	} else {
#if (!GLIBTOP_SUID_PROC_STATE)
		glibtop_get_proc_state_s (server, buf, pid);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_proc_state");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.proc_state)
		_glibtop_missing_feature (server, "proc_state", buf->flags,
					  &server->required.proc_state);
}

void
glibtop_get_proc_uid_l (glibtop *server, glibtop_proc_uid *buf,
                        pid_t pid)
{
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_PROC_UID), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_PROC_UID)))
	{
		struct {
			pid_t buf_pid;
		} param_buf;

		param_buf.buf_pid = pid;

		const void *send_ptr = &param_buf;
		const size_t send_size = sizeof param_buf;

		glibtop_call_l (server, GLIBTOP_CMND_PROC_UID,
				send_size, send_ptr,
				sizeof (glibtop_proc_uid), buf);
	} else {
#if (!GLIBTOP_SUID_PROC_UID)
		glibtop_get_proc_uid_s (server, buf, pid);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_proc_uid");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.proc_uid)
		_glibtop_missing_feature (server, "proc_uid", buf->flags,
					  &server->required.proc_uid);
}

void
glibtop_get_proc_mem_l (glibtop *server, glibtop_proc_mem *buf,
                        pid_t pid)
{
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_PROC_MEM), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_PROC_MEM)))
	{
		struct {
			pid_t buf_pid;
		} param_buf;

		param_buf.buf_pid = pid;

		const void *send_ptr = &param_buf;
		const size_t send_size = sizeof param_buf;

		glibtop_call_l (server, GLIBTOP_CMND_PROC_MEM,
				send_size, send_ptr,
				sizeof (glibtop_proc_mem), buf);
	} else {
#if (!GLIBTOP_SUID_PROC_MEM)
		glibtop_get_proc_mem_s (server, buf, pid);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_proc_mem");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.proc_mem)
		_glibtop_missing_feature (server, "proc_mem", buf->flags,
					  &server->required.proc_mem);
}

void
glibtop_get_proc_time_l (glibtop *server, glibtop_proc_time *buf,
                         pid_t pid)
{
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_PROC_TIME), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_PROC_TIME)))
	{
		struct {
			pid_t buf_pid;
		} param_buf;

		param_buf.buf_pid = pid;

		const void *send_ptr = &param_buf;
		const size_t send_size = sizeof param_buf;

		glibtop_call_l (server, GLIBTOP_CMND_PROC_TIME,
				send_size, send_ptr,
				sizeof (glibtop_proc_time), buf);
	} else {
#if (!GLIBTOP_SUID_PROC_TIME)
		glibtop_get_proc_time_s (server, buf, pid);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_proc_time");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.proc_time)
		_glibtop_missing_feature (server, "proc_time", buf->flags,
					  &server->required.proc_time);
}

void
glibtop_get_proc_signal_l (glibtop *server, glibtop_proc_signal *buf,
                           pid_t pid)
{
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_PROC_SIGNAL), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_PROC_SIGNAL)))
	{
		struct {
			pid_t buf_pid;
		} param_buf;

		param_buf.buf_pid = pid;

		const void *send_ptr = &param_buf;
		const size_t send_size = sizeof param_buf;

		glibtop_call_l (server, GLIBTOP_CMND_PROC_SIGNAL,
				send_size, send_ptr,
				sizeof (glibtop_proc_signal), buf);
	} else {
#if (!GLIBTOP_SUID_PROC_SIGNAL)
		glibtop_get_proc_signal_s (server, buf, pid);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_proc_signal");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.proc_signal)
		_glibtop_missing_feature (server, "proc_signal", buf->flags,
					  &server->required.proc_signal);
}

void
glibtop_get_proc_kernel_l (glibtop *server, glibtop_proc_kernel *buf,
                           pid_t pid)
{
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_PROC_KERNEL), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_PROC_KERNEL)))
	{
		struct {
			pid_t buf_pid;
		} param_buf;

		param_buf.buf_pid = pid;

		const void *send_ptr = &param_buf;
		const size_t send_size = sizeof param_buf;

		glibtop_call_l (server, GLIBTOP_CMND_PROC_KERNEL,
				send_size, send_ptr,
				sizeof (glibtop_proc_kernel), buf);
	} else {
#if (!GLIBTOP_SUID_PROC_KERNEL)
		glibtop_get_proc_kernel_s (server, buf, pid);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_proc_kernel");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.proc_kernel)
		_glibtop_missing_feature (server, "proc_kernel", buf->flags,
					  &server->required.proc_kernel);
}

void
glibtop_get_proc_segment_l (glibtop *server, glibtop_proc_segment *buf,
                            pid_t pid)
{
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_PROC_SEGMENT), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_PROC_SEGMENT)))
	{
		struct {
			pid_t buf_pid;
		} param_buf;

		param_buf.buf_pid = pid;

		const void *send_ptr = &param_buf;
		const size_t send_size = sizeof param_buf;

		glibtop_call_l (server, GLIBTOP_CMND_PROC_SEGMENT,
				send_size, send_ptr,
				sizeof (glibtop_proc_segment), buf);
	} else {
#if (!GLIBTOP_SUID_PROC_SEGMENT)
		glibtop_get_proc_segment_s (server, buf, pid);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_proc_segment");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.proc_segment)
		_glibtop_missing_feature (server, "proc_segment", buf->flags,
					  &server->required.proc_segment);
}

char *
glibtop_get_proc_args_l (glibtop *server, glibtop_proc_args *buf,
                         pid_t pid, unsigned max_len)
{
	char * retval = (char *) 0;
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_PROC_ARGS), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_PROC_ARGS)))
	{
		struct {
			pid_t buf_pid;
			unsigned buf_max_len;
		} param_buf;

		param_buf.buf_pid = pid;
		param_buf.buf_max_len = max_len;

		const void *send_ptr = &param_buf;
		const size_t send_size = sizeof param_buf;

		retval = glibtop_call_l (server, GLIBTOP_CMND_PROC_ARGS,
				         send_size, send_ptr,
				         sizeof (glibtop_proc_args), buf);
	} else {
#if (!GLIBTOP_SUID_PROC_ARGS)
		retval = glibtop_get_proc_args_s (server, buf, pid, max_len);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_proc_args");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.proc_args)
		_glibtop_missing_feature (server, "proc_args", buf->flags,
					  &server->required.proc_args);

	/* Now we can return. */

	return retval;
}

glibtop_map_entry *
glibtop_get_proc_map_l (glibtop *server, glibtop_proc_map *buf,
                        pid_t pid)
{
	glibtop_map_entry * retval = (glibtop_map_entry *) 0;
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_PROC_MAP), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_PROC_MAP)))
	{
		struct {
			pid_t buf_pid;
		} param_buf;

		param_buf.buf_pid = pid;

		const void *send_ptr = &param_buf;
		const size_t send_size = sizeof param_buf;

		retval = glibtop_call_l (server, GLIBTOP_CMND_PROC_MAP,
				         send_size, send_ptr,
				         sizeof (glibtop_proc_map), buf);
	} else {
#if (!GLIBTOP_SUID_PROC_MAP)
		retval = glibtop_get_proc_map_s (server, buf, pid);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_proc_map");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.proc_map)
		_glibtop_missing_feature (server, "proc_map", buf->flags,
					  &server->required.proc_map);

	/* Now we can return. */

	return retval;
}

glibtop_open_files_entry *
glibtop_get_proc_open_files_l (glibtop *server, glibtop_proc_open_files *buf,
                               pid_t pid)
{
	glibtop_open_files_entry * retval = (glibtop_open_files_entry *) 0;
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_PROC_OPEN_FILES), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_PROC_OPEN_FILES)))
	{
		struct {
			pid_t buf_pid;
		} param_buf;

		param_buf.buf_pid = pid;

		const void *send_ptr = &param_buf;
		const size_t send_size = sizeof param_buf;

		retval = glibtop_call_l (server, GLIBTOP_CMND_PROC_OPEN_FILES,
				         send_size, send_ptr,
				         sizeof (glibtop_proc_open_files), buf);
	} else {
#if (!GLIBTOP_SUID_PROC_OPEN_FILES)
		retval = glibtop_get_proc_open_files_s (server, buf, pid);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_proc_open_files");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.proc_open_files)
		_glibtop_missing_feature (server, "proc_open_files", buf->flags,
					  &server->required.proc_open_files);

	/* Now we can return. */

	return retval;
}

glibtop_mountentry *
glibtop_get_mountlist_l (glibtop *server, glibtop_mountlist *buf,
                         int all_fs)
{
	glibtop_mountentry * retval = (glibtop_mountentry *) 0;
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_MOUNTLIST), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_MOUNTLIST)))
	{
		struct {
			int buf_all_fs;
		} param_buf;

		param_buf.buf_all_fs = all_fs;

		const void *send_ptr = &param_buf;
		const size_t send_size = sizeof param_buf;

		retval = glibtop_call_l (server, GLIBTOP_CMND_MOUNTLIST,
				         send_size, send_ptr,
				         sizeof (glibtop_mountlist), buf);
	} else {
		retval = glibtop_get_mountlist_s (server, buf, all_fs);
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.mountlist)
		_glibtop_missing_feature (server, "mountlist", buf->flags,
					  &server->required.mountlist);

	/* Now we can return. */

	return retval;
}

void
glibtop_get_fsusage_l (glibtop *server, glibtop_fsusage *buf,
                       const char *mount_dir)
{
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_FSUSAGE), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_FSUSAGE)))
	{

	const void *send_ptr = mount_dir;

	const size_t send_size =
		strlen (mount_dir) + 1;

		glibtop_call_l (server, GLIBTOP_CMND_FSUSAGE,
				send_size, send_ptr,
				sizeof (glibtop_fsusage), buf);
	} else {
		glibtop_get_fsusage_s (server, buf, mount_dir);
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.fsusage)
		_glibtop_missing_feature (server, "fsusage", buf->flags,
					  &server->required.fsusage);
}

void
glibtop_get_netload_l (glibtop *server, glibtop_netload *buf,
                       const char *interface)
{
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_NETLOAD), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_NETLOAD)))
	{

	const void *send_ptr = interface;

	const size_t send_size =
		strlen (interface) + 1;

		glibtop_call_l (server, GLIBTOP_CMND_NETLOAD,
				send_size, send_ptr,
				sizeof (glibtop_netload), buf);
	} else {
#if (!GLIBTOP_SUID_NETLOAD)
		glibtop_get_netload_s (server, buf, interface);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_netload");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.netload)
		_glibtop_missing_feature (server, "netload", buf->flags,
					  &server->required.netload);
}

void
glibtop_get_ppp_l (glibtop *server, glibtop_ppp *buf,
                   unsigned short device)
{
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_PPP), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_PPP)))
	{
		struct {
			unsigned short buf_device;
		} param_buf;

		param_buf.buf_device = device;

		const void *send_ptr = &param_buf;
		const size_t send_size = sizeof param_buf;

		glibtop_call_l (server, GLIBTOP_CMND_PPP,
				send_size, send_ptr,
				sizeof (glibtop_ppp), buf);
	} else {
#if (!GLIBTOP_SUID_PPP)
		glibtop_get_ppp_s (server, buf, device);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_ppp");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.ppp)
		_glibtop_missing_feature (server, "ppp", buf->flags,
					  &server->required.ppp);
}

char **
glibtop_get_netlist_l (glibtop *server, glibtop_netlist *buf)
{
	char ** retval = (char **) 0;
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_NETLIST), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_NETLIST)))
	{
		const void *send_ptr = NULL;
		const size_t send_size = 0;

		retval = glibtop_call_l (server, GLIBTOP_CMND_NETLIST,
				         send_size, send_ptr,
				         sizeof (glibtop_netlist), buf);
	} else {
#if (!GLIBTOP_SUID_NETLIST)
		retval = glibtop_get_netlist_s (server, buf);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_netlist");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.netlist)
		_glibtop_missing_feature (server, "netlist", buf->flags,
					  &server->required.netlist);

	/* Now we can return. */

	return retval;
}

char **
glibtop_get_proc_wd_l (glibtop *server, glibtop_proc_wd *buf,
                       pid_t pid)
{
	char ** retval = (char **) 0;
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_PROC_WD), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_PROC_WD)))
	{
		struct {
			pid_t buf_pid;
		} param_buf;

		param_buf.buf_pid = pid;

		const void *send_ptr = &param_buf;
		const size_t send_size = sizeof param_buf;

		retval = glibtop_call_l (server, GLIBTOP_CMND_PROC_WD,
				         send_size, send_ptr,
				         sizeof (glibtop_proc_wd), buf);
	} else {
#if (!GLIBTOP_SUID_PROC_WD)
		retval = glibtop_get_proc_wd_s (server, buf, pid);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_proc_wd");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.proc_wd)
		_glibtop_missing_feature (server, "proc_wd", buf->flags,
					  &server->required.proc_wd);

	/* Now we can return. */

	return retval;
}

guint16*
glibtop_get_proc_affinity_l (glibtop *server, glibtop_proc_affinity *buf,
                             pid_t pid)
{
	guint16* retval = (guint16*) 0;
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_PROC_AFFINITY), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_PROC_AFFINITY)))
	{
		struct {
			pid_t buf_pid;
		} param_buf;

		param_buf.buf_pid = pid;

		const void *send_ptr = &param_buf;
		const size_t send_size = sizeof param_buf;

		retval = glibtop_call_l (server, GLIBTOP_CMND_PROC_AFFINITY,
				         send_size, send_ptr,
				         sizeof (glibtop_proc_affinity), buf);
	} else {
#if (!GLIBTOP_SUID_PROC_AFFINITY)
		retval = glibtop_get_proc_affinity_s (server, buf, pid);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_proc_affinity");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.proc_affinity)
		_glibtop_missing_feature (server, "proc_affinity", buf->flags,
					  &server->required.proc_affinity);

	/* Now we can return. */

	return retval;
}

void
glibtop_get_proc_io_l (glibtop *server, glibtop_proc_io *buf,
                       pid_t pid)
{
	glibtop_init_r (&server, (1 << GLIBTOP_SYSDEPS_PROC_IO), 0);

	/* If neccessary, we ask the server for the requested
	 * feature. If not, we call the sysdeps function. */

	if ((server->flags & _GLIBTOP_INIT_STATE_SERVER) &&
	    (server->features & (1 << GLIBTOP_SYSDEPS_PROC_IO)))
	{
		struct {
			pid_t buf_pid;
		} param_buf;

		param_buf.buf_pid = pid;

		const void *send_ptr = &param_buf;
		const size_t send_size = sizeof param_buf;

		glibtop_call_l (server, GLIBTOP_CMND_PROC_IO,
				send_size, send_ptr,
				sizeof (glibtop_proc_io), buf);
	} else {
#if (!GLIBTOP_SUID_PROC_IO)
		glibtop_get_proc_io_s (server, buf, pid);
#else
		errno = ENOSYS;
		glibtop_error_io_r (server, "glibtop_get_proc_io");
#endif
	}

	/* Make sure that all required fields are present. */

	if (buf->flags & server->required.proc_io)
		_glibtop_missing_feature (server, "proc_io", buf->flags,
					  &server->required.proc_io);
}

