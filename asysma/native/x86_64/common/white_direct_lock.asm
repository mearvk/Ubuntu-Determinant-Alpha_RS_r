; ASYSMA / Ubuntu White Direct
; Common x86-64 desktop bootstrap / soft-lock rehearsal
;
; This source contains CPU/ISA-level code only. It deliberately does not
; issue Linux, Windows, or macOS system calls. OS interaction is delegated
; through a small adapter supplied by the native executable wrapper.
;
; Intended contract (SysV or Microsoft x64 adapter establishes entry ABI):
;   RDI = pointer to Direct adapter table
;   RSI = pointer to host profile / output record
;
; Adapter function at [RDI+0] must be a safe, non-throwing probe returning:
;   RAX = 1  recognized/ready
;   RAX = 0  unsupported/not ready
;
; The common layer then records CPU evidence and enters a cooperative
; resident/desktop state. It does NOT attempt to suppress OS exceptions,
; bypass security controls, or seize the process. "Lock" here means a soft,
; cooperative resident state owned by the application's process.
;
; NASM/YASM-style syntax.

BITS 64

%define DIRECT_PROBE      0
%define STATE             8
%define CPU_MAX_BASIC     16
%define CPU_MAX_EXTENDED  24
%define MAGIC             32
%define RECORD_SIZE       40

%define STATE_INIT        0
%define STATE_READY       1
%define STATE_UNSUPPORTED 2
%define STATE_FAILED      3
%define STATE_RESIDENT    4

section .text

global white_direct_lock_entry

global white_direct_release

; Entry:
;   RDI = Direct adapter table
;   RSI = writable host record (at least RECORD_SIZE bytes)
white_direct_lock_entry:
    test    rdi, rdi
    jz      .fail
    test    rsi, rsi
    jz      .fail

    ; Initialize record conservatively.
    mov     qword [rsi + STATE], STATE_INIT
    mov     dword [rsi + MAGIC], 0x4153594D       ; 'ASYM' marker

    ; Establish x86-64 CPU evidence without assuming an OS API.
    push    rbx
    mov     eax, 0
    cpuid
    mov     [rsi + CPU_MAX_BASIC], eax

    mov     eax, 0x80000000
    cpuid
    mov     [rsi + CPU_MAX_EXTENDED], eax
    pop     rbx

    ; Ask the OS-specific adapter to perform the actual safe host probe.
    ; The adapter is responsible for ABI correctness and OS API handling.
    call    qword [rdi + DIRECT_PROBE]
    test    rax, rax
    jz      .unsupported

    mov     qword [rsi + STATE], STATE_READY

    ; Cooperative desktop residence. The host adapter/application owns the
    ; event loop. Returning success transfers control to the next ASYSMA
    ; layer; this routine does not create an unkillable process.
    mov     qword [rsi + STATE], STATE_RESIDENT
    xor     eax, eax
    ret

.unsupported:
    mov     qword [rsi + STATE], STATE_UNSUPPORTED
    mov     eax, 1
    ret

.fail:
    ; Do not manufacture an OS exception. Return a normal failure code.
    ; The OS remains responsible for its ordinary exception mechanism.
    mov     eax, 2
    ret

; Cooperative release point for the desktop/application layer.
; Input: RSI = host record.
white_direct_release:
    test    rsi, rsi
    jz      .release_fail
    mov     qword [rsi + STATE], STATE_INIT
    xor     eax, eax
    ret
.release_fail:
    mov     eax, 2
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
