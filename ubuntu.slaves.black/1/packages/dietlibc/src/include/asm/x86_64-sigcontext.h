#include <asm/types.h>

/* FXSAVE frame */
/* Note: reserved1/2 may someday contain valuable data. Always save/restore
   them when you change signal frames. */
struct _fpstate {
	__u16	cwd;
	__u16	swd;
	__u16	twd;	/* Note this is not the same as the 32bit/x87/FSAVE twd */
	__u16	fop;
	__u64	rip;
	__u64	rdp; 
	__u32	mxcsr;
	__u32	mxcsr_mask;
	__u32	st_space[32];	/* 8*16 bytes for each FP-reg */
	__u32	xmm_space[64];	/* 16*16 bytes for each XMM-reg  */
	__u32	reserved2[24];
};

struct sigcontext { 
	__u64 r8;
	__u64 r9;
	__u64 r10;
	__u64 r11;
	__u64 r12;
	__u64 r13;
	__u64 r14;
	__u64 r15;
	__u64 rdi;
	__u64 rsi;
	__u64 rbp;
	__u64 rbx;
	__u64 rdx;
	__u64 rax;
	__u64 rcx;
	__u64 rsp;
	__u64 rip;
	__u64 eflags;		/* RFLAGS */
	__u16         cs;
	__u16         gs;
	__u16         fs;
	__u16         __pad0;
	__u64 err;
	__u64 trapno;
	__u64 oldmask;
	__u64 cr2;
	__extension__ union {
		struct _fpstate *fpstate;	/* zero when no FPU context */
		__u64 __fpstate_word;
	};
	__u64 reserved1[8];
};
