#include "total.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char **argv) {
    const char *config_path = argc > 1 ? argv[1] : "/etc/total/total.conf";
    total_config_t config;
    int rc = total_config_load(config_path, &config);
    if (rc != 0) {
        fprintf(stderr, "Total: cannot load %s: %d\n", config_path, rc);
        return EXIT_FAILURE;
    }
    if (geteuid() != 0) {
        fprintf(stderr, "Total: warning: not running with administrative privileges; policy enforcement is limited.\n");
    }
    fprintf(stdout, "Total: native moderator starting with %s\n", config_path);
    return total_service_run(&config) == 0 ? EXIT_SUCCESS : EXIT_FAILURE;
}
