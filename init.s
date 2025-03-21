.module crt0
.globl	_main

.area _CODE

_init::
    ; Stolen from https://github.com/retro-vault/libsdcc-z80/blob/main/sample/crt0.s
    ld      (#__store_sp),sp        ; store current stack pointer
    ld      sp,#__stack             ; load new stack pointer

    ;; store all regs
    push    af
    push    bc
    push    de
    push    hl
    push    ix
    push    iy
    ex      af, af'
    push    af
    exx
    push    bc
    push    de
    push    hl

    call    gsinit                  ; call SDCC init code

    call    _main

    ; turn off backlight
    in a, (#0xee) ; gpoa
    and a, #0xfd
    out (#0xee), a

; wdt bite
loop:
    jp loop

    ;; restore all regs
    pop     hl
    pop     de
    pop     bc
    pop     af
    exx
    ex      af,af'
    pop     iy
    pop     ix
    pop     hl
    pop     de
    pop     bc
    pop     af

    ld      sp,(#__store_sp)        ; restore original stack pointer

    ;; return to wherever you were called from
    ret

        ;;	(linker documentation:) where specific ordering is desired -
        ;;	the first linker input file should have the area definitions
        ;;	in the desired order
        .area   _GSINIT
        .area   _GSFINAL
        .area   _HOME
        .area   _INITIALIZER
        .area   _INITFINAL
        .area   _INITIALIZED
        .area   _DATA
        .area   _BSS
        .area   _HEAP

        ;;	this area contains data initialization code.
        .area _GSINIT
gsinit:
        ;; initialize vars from initializer
        ld      de, #s__INITIALIZED
        ld      hl, #s__INITIALIZER
        ld      bc, #l__INITIALIZER
        ld      a, b
        or      a, c
        jr      z, gsinit_none
        ldir
gsinit_none:
        .area _GSFINAL
        ret

        .area _DATA
        .area _BSS
        ;; this is where we store the stack pointer
__store_sp:
        .word 1
        ;; 1024 bytes of operating system stack
        .ds	1024
__stack::
        .area _HEAP
__heap:
