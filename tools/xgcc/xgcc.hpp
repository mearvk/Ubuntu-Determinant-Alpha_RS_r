#ifndef XGCC_HPP
#define XGCC_HPP

#ifdef __cplusplus
extern "C" {
#endif

/* Stable C-compatible entry points for the XGCC generation core. */
int xgcc_generation_count(void);
const char *xgcc_generation_name(int generation);
int xgcc_compile_source(const char *source, const char *output_path);

#ifdef __cplusplus
}
#endif

#ifdef __cplusplus
namespace xgcc {

struct BuildInfo {
    const char *name;
    const char *version;
    const char *target;
};

BuildInfo build_info();

} // namespace xgcc
#endif

#endif /* XGCC_HPP */
