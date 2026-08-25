#ifndef XMC_OS_REGISTER_H
#define XMC_OS_REGISTER_H

#ifdef __cplusplus
extern "C" {
#endif

int xmc_register_asysma(const char *desktop_file, const char *program_name,
                        const char *icon_path, const char *executable_path);

#ifdef __cplusplus
}
#endif

#endif
