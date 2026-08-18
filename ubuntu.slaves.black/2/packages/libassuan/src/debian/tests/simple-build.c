#include <assuan.h>

/* Author: Daniel Kahn Gillmor <dkg@fifthhorseman.net>
 *
 * A simple test program that exercises a tiny piece of libassuan.
 */

int main() {
  assuan_context_t ctx;
  const char *gpgrt_version, *assuan_version;
  gpg_error_t err;

  gpgrt_version = gpgrt_check_version (GPGRT_VERSION);
  assuan_version = assuan_check_version (ASSUAN_VERSION);
  gpgrt_printf ("gpgrt version %s\nassuan version %s\n", gpgrt_version, assuan_version);

  err = assuan_new (&ctx);
  if (err) {
    gpgrt_fprintf (gpgrt_stderr, "assuan_new failed: %s\n", gpg_strerror (err));
    return 1;
  }
  assuan_release (ctx);
  return 0;
}
