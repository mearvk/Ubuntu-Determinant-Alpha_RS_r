#include <stdio.h>
#include <CUnit/CUnit.h>
#include <CUnit/Basic.h>

#define ADD_TEST(X) do { if (!X) { CU_cleanup_registry();return CU_get_error(); } } while (0)

int
init_suite(void) {
  fprintf(stdout, "Suite initialized!\n");
  return 0;
}

int
clean_suite(void) {
  fprintf(stdout, "\n\nSuite cleaned!\n");
  return 0;
}

void
test(void) {
  int x = 1;
  CU_ASSERT_EQUAL(x, 1);
  return;
}

int
main(void)
{
  CU_pSuite ste = NULL;

  if (CUE_SUCCESS != CU_initialize_registry()) {
    return CU_get_error();
  }

  ste = CU_add_suite("cunit_test", init_suite, clean_suite);
  if (NULL == ste) {
    CU_cleanup_registry();
    return CU_get_error();
  }
  if (CU_get_error() != CUE_SUCCESS) {
    fprintf(stderr, "Error creating suite (%d): %s\n", CU_get_error(), CU_get_error_msg());
  }

  ADD_TEST(CU_add_test(ste, "Verify 1 == 1...", test));

  if (CU_get_error() != CUE_SUCCESS) {
    fprintf(stderr, "Error creating suite (%d): %s\n", CU_get_error(), CU_get_error_msg());
  }

  CU_basic_set_mode(CU_BRM_VERBOSE);
  CU_ErrorCode run_errors = CU_basic_run_suite(ste);
  if (run_errors != CUE_SUCCESS) {
    fprintf(stderr, "Error running tests (%d): %s\n", run_errors, CU_get_error_msg());
  }

  CU_basic_show_failures(CU_get_failure_list());
  CU_cleanup_registry();

  printf("\nDone!\n");

  return CU_get_error();
}
