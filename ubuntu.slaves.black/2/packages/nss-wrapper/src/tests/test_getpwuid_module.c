#include "config.h"

#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

#include <pwd.h>

static void test_nwrap_passwd(void **state)
{
	struct passwd *pwd;
	uid_t id = 424242;

	(void) state; /* unused */

	pwd = getpwuid(id);
	assert_non_null(pwd);

	assert_string_equal(pwd->pw_name, "hanswurst");
	assert_int_equal(pwd->pw_uid, id);
	assert_int_equal(pwd->pw_gid, id);
}

int main(void)
{
	int rc;

	const struct CMUnitTest tests[] = {
		cmocka_unit_test(test_nwrap_passwd),
	};

	rc = cmocka_run_group_tests(tests, NULL, NULL);

	return rc;
}
