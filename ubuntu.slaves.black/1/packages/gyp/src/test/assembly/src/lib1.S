#if PLATFORM_WINDOWS || PLATFORM_MAC
# define IDENTIFIER(n)  _##n
#else /* Linux */
# define IDENTIFIER(n)  n
#endif

.globl IDENTIFIER(lib1_function)
.type  IDENTIFIER(lib1_function), %function
IDENTIFIER(lib1_function):
#if defined(__x86_64__) || defined(__amd64__) || defined(__i386__)
  movl $42, %eax
  ret
#elif defined(__arm__)
  movs r0, #42
  bx lr
#elif defined(__aarch64__)
  mov w0, 42
  ret
#elif defined(__powerpc64__)
  li 3, 42
  blr
#elif defined(__s390x__)
  lhi  %r2, 42
  br   %r14
#endif
