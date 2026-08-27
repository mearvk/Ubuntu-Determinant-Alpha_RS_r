#ifndef SMAUG_OS_H
#define SMAUG_OS_H

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    SMAUG_OS_UNKNOWN = 0,
    SMAUG_OS_LINUX,
    SMAUG_OS_WINDOWS,
    SMAUG_OS_MACOS
} SmaugOSFamily;

typedef struct {
    SmaugOSFamily family;
    const char *kernel_model;
    const char *process_model;
    const char *permission_model;
    const char *filesystem_model;
    const char *executable_model;
    const char *service_model;
    int sandbox_available;
    int mandatory_security_available;
    int code_signing_available;
} SmaugOSProfile;

int smaug_detect_os(SmaugOSProfile *profile);
const char *smaug_os_family_name(SmaugOSFamily family);

#ifdef __cplusplus
}
#endif

#endif /* SMAUG_OS_H */
