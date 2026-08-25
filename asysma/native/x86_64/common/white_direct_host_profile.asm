; ASYSMA / Ubuntu White Direct
; Common x86-64 host-profile layer.
;
; Layer 2 follows the native startup handshake. It does not make OS calls
; itself. The Direct adapter supplies a normalized host profile containing:
;   OS family, OS version, total/available memory, total/available storage.
;
; Entry contract:
;   RDI = Direct adapter table
;   RSI = writable HOST_PROFILE record
;
; Adapter function at [RDI+8] must safely populate the record and return:
;   RAX = 1  profile complete/usable
;   RAX = 0  unsupported or unavailable
;
; Missing individual observations should be represented by adapter-defined
; unknown values/flags rather than causing a crash. This layer records a
; clean status and returns to the ASYSMA interpreter.
;
BITS 64

%define ADAPTER_PROFILE 8
%define STATUS          0
%define FLAGS           8
%define MAGIC           16
%define RECORD_SIZE     24

%define STATUS_INIT        0
%define STATUS_COMPLETE   1
%define STATUS_UNKNOWN    2
%define STATUS_FAILED     3

%define FLAG_OS           0x01
%define FLAG_VERSION      0x02
%define FLAG_MEMORY       0x04
%define FLAG_STORAGE      0x08

section .text
global white_direct_host_profile_entry

white_direct_host_profile_entry:
    test    rdi, rdi
    jz      .fail
    test    rsi, rsi
    jz      .fail

    mov     qword [rsi + STATUS], STATUS_INIT
    mov     qword [rsi + FLAGS], 0
    mov     dword [rsi + MAGIC], 0x48505341       ; 'ASPH'

    ; OS-specific Direct adapter owns all platform APIs.
    ; It must be non-throwing at this boundary.
    call    qword [rdi + ADAPTER_PROFILE]
    test    rax, rax
    jz      .unknown

    mov     qword [rsi + STATUS], STATUS_COMPLETE
    xor     eax, eax
    ret

.unknown:
    mov     qword [rsi + STATUS], STATUS_UNKNOWN
    mov     eax, 1
    ret

.fail:
    mov     eax, 2
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
