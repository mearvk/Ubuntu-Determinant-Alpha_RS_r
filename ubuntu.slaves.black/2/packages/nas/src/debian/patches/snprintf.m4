Description: Include missing m4 macro
 Running autoreconf fails because the AC_FUNC_SNPRINTF macro isn't part
 of autoconf upstream, but rather was pulled in from an external resource
 (e.g., http://ac-archive.sourceforge.net/ac-archive/ac_func_snprintf.html).
 Include it in the tree so that autoreconf works correctly.

Author: Rüdiger Kuhlmann <info@ruediger-kuhlmann.de> 
Index: nas/config/acinclude.m4
===================================================================
--- /dev/null
+++ nas/config/acinclude.m4
@@ -0,0 +1,65 @@
+dnl Author: Rüdiger Kuhlmann <info@ruediger-kuhlmann.de>
+dnl License:
+dnl    AllPermissive
+dnl    Copying and distribution of this file, with or without modification,
+dnl    are permitted in any medium without royalty provided the copyright
+dnl    notice and this notice are preserved. Users of this software should
+dnl    generally follow the principles of the MIT License includings its
+dnl    disclaimer.
+
+AC_DEFUN([AC_FUNC_SNPRINTF],
+[AC_CHECK_FUNCS(snprintf vsnprintf)
+AC_MSG_CHECKING(for working snprintf)
+AC_CACHE_VAL(ac_cv_have_working_snprintf,
+[AC_TRY_RUN(
+[#include &lt;stdio.h&gt;
+
+int main(void)
+{
+    char bufs[5] = { 'x', 'x', 'x', '\0', '\0' };
+    char bufd[5] = { 'x', 'x', 'x', '\0', '\0' };
+    int i;
+    i = snprintf (bufs, 2, "%s", "111");
+    if (strcmp (bufs, "1")) exit (1);
+    if (i != 3) exit (1);
+    i = snprintf (bufd, 2, "%d", 111);
+    if (strcmp (bufd, "1")) exit (1);
+    if (i != 3) exit (1);
+    exit(0);
+}], ac_cv_have_working_snprintf=yes, ac_cv_have_working_snprintf=no, ac_cv_have_working_snprintf=cross)])
+AC_MSG_RESULT([$ac_cv_have_working_snprintf])
+AC_MSG_CHECKING(for working vsnprintf)
+AC_CACHE_VAL(ac_cv_have_working_vsnprintf,
+[AC_TRY_RUN(
+[#include &lt;stdio.h&gt;
+#include &lt;stdarg.h&gt;
+
+int my_vsnprintf (char *buf, const char *tmpl, ...)
+{
+    int i;
+    va_list args;
+    va_start (args, tmpl);
+    i = vsnprintf (buf, 2, tmpl, args);
+    va_end (args);
+    return i;
+}
+
+int main(void)
+{
+    char bufs[5] = { 'x', 'x', 'x', '\0', '\0' };
+    char bufd[5] = { 'x', 'x', 'x', '\0', '\0' };
+    int i;
+    i = my_vsnprintf (bufs, "%s", "111");
+    if (strcmp (bufs, "1")) exit (1);
+    if (i != 3) exit (1);
+    i = my_vsnprintf (bufd, "%d", 111);
+    if (strcmp (bufd, "1")) exit (1);
+    if (i != 3) exit (1);
+    exit(0);
+}], ac_cv_have_working_vsnprintf=yes, ac_cv_have_working_vsnprintf=no, ac_cv_have_working_vsnprintf=cross)])
+AC_MSG_RESULT([$ac_cv_have_working_vsnprintf])
+if test x$ac_cv_have_working_snprintf$ac_cv_have_working_vsnprintf != "xyesyes"; then
+  AC_LIBOBJ(snprintf)
+  AC_MSG_WARN([Replacing missing/broken (v)snprintf() with version from http://www.ijs.si/software/snprintf/.])
+  AC_DEFINE(PREFER_PORTABLE_SNPRINTF, 1, "enable replacement (v)snprintf if system (v)snprintf is broken")
+fi])
