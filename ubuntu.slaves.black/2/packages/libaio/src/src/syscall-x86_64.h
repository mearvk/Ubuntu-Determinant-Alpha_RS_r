#if __ILP32__
#define __X32_SYSCALL_BIT	0x40000000UL
#define __NR_io_setup		(__X32_SYSCALL_BIT + 543)
#define __NR_io_destroy		(__X32_SYSCALL_BIT + 207)
#define __NR_io_submit		(__X32_SYSCALL_BIT + 544)
#define __NR_io_cancel		(__X32_SYSCALL_BIT + 210)
#define __NR_io_getevents	(__X32_SYSCALL_BIT + 208)
#define __NR_io_pgetevents	(__X32_SYSCALL_BIT + 333)
#else
#define __NR_io_setup		206
#define __NR_io_destroy		207
#define __NR_io_getevents	208
#define __NR_io_submit		209
#define __NR_io_cancel		210
#define __NR_io_pgetevents	333
#endif
