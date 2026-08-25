; Ubuntu White Direct — common x86-64 native bootstrap
; ASYSMA rehearsal source
;
; IMPORTANT:
;   This source intentionally contains NO Linux, Windows, or macOS system calls.
;   It is a common CPU/ABI-neutral probe core at the machine-instruction level.
;   The host OS supplies a small native adapter that implements the Direct API.
;
; Build model:
;   white_direct_bootstrap.asm -> x86-64 object -> OS-native executable
;                                      Linux   -> ELF
;                                      Windows -> PE/COFF
;                                      macOS   -> Mach-O
;
; The same source is intended to be assembled for each target. The linker and
; host adapter, rather than this source, select the OS executable format and ABI.
;
; ABI contract for the common core:
;   RDI = pointer to DirectContext
;   RSI = pointer to DirectResult
;   RDX = pointer to DirectAdapter table
;   RAX = result code
;
; The adapter table is deliberately opaque to this assembly layer. The common
; core may invoke only the documented callback slots supplied by the host.
;
; DirectContext and DirectResult are owned by the higher-level contract. The
; common bootstrap only records CPU facts and asks the adapter for host facts.
;
; This file does not perform privileged operations and does not execute an
; ASYSMA payload. It is intended to run after the desktop OS has created a
; normal user process.

BITS 64
DEFAULT REL

SECTION .text

; ---------------------------------------------------------------------------
; white_direct_bootstrap
;
; Input:
;   RDI = DirectContext*
;   RSI = DirectResult*
;   RDX = DirectAdapter*
;
; Output:
;   RAX = 0 on successful probe, non-zero on failure.
;
; Required adapter contract:
;   [RDX + 0]  = host_probe function pointer
;   host_probe(DirectContext*, DirectResult*) follows the host executable's
;   native calling convention. The host adapter is responsible for entering
;   this common core with the documented register contract.
;
; The first stage is pure CPU inspection. CPUID is available on all x86-64
; processors; the OS is not contacted until the adapter callback is invoked.
; ---------------------------------------------------------------------------

global white_direct_bootstrap

global white_direct_cpu_probe

white_direct_bootstrap:
    push rbp
    mov rbp, rsp

    ; Preserve the three contract arguments in non-volatile scratch locations
    ; within this frame. The host adapter remains responsible for its ABI rules.
    push r12
    push r13
    push r14

    mov r12, rdi                    ; DirectContext*
    mov r13, rsi                    ; DirectResult*
    mov r14, rdx                    ; DirectAdapter*

    ; Establish CPU evidence first.
    mov rdi, r12
    mov rsi, r13
    call white_direct_cpu_probe
    test eax, eax
    jnz .fail

    ; No OS-specific instruction or syscall is made here. The adapter owns
    ; the host-specific transition and may decline the operation.
    mov rax, [r14 + 0]
    test rax, rax
    jz .fail

    mov rdi, r12
    mov rsi, r13
    call rax
    test eax, eax
    jnz .fail

    xor eax, eax
    jmp .done

.fail:
    mov eax, 1

.done:
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

; ---------------------------------------------------------------------------
; white_direct_cpu_probe
;
; Writes a minimal CPU evidence record through the DirectResult pointer.
; The exact structure is documented separately; this rehearsal records only
; values that are safe to obtain without OS services.
;
; DirectResult layout used here:
;   +00  uint32 magic = 'WDC1'
;   +04  uint32 flags
;   +08  uint32 max_basic_leaf
;   +0c  uint32 max_extended_leaf
;   +10  uint32 vendor_ebx
;   +14  uint32 vendor_edx
;   +18  uint32 vendor_ecx
;
; ---------------------------------------------------------------------------

white_direct_cpu_probe:
    push rbp
    mov rbp, rsp

    ; CPUID leaf 0: vendor and maximum basic leaf.
    xor eax, eax
    cpuid

    mov r8d, ebx
    mov r9d, edx
    mov r10d, ecx

    mov [rsi + 0], dword 0x31434457 ; "WDC1" little-endian
    mov [rsi + 8], eax
    mov [rsi + 0x10], r8d
    mov [rsi + 0x14], r9d
    mov [rsi + 0x18], r10d

    ; Leaf 0x80000000: maximum extended leaf.
    mov eax, 0x80000000
    cpuid
    mov [rsi + 0x0c], eax

    ; flags bit 0 = CPUID probe completed.
    mov [rsi + 4], dword 1

    xor eax, eax
    pop rbp
    ret
