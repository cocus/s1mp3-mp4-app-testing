.module crt0
.globl	_main

.area _CODE

_init::
    push bc
    push de

;    ld      hl, #0xFFF0
;    add     hl, sp
;    ld      sp, hl


;    ld      bc, #0
;    ld      de, #0xFFFF
;    call    PutImage
;
;    ld de, #0
;    call ClearScreen
;
;    ld e, #0xff
;    call SetAsciiFont
;
;    ld c, #0x22 ; '"'
;    ld e, #0x18
;    call SETTEXTPOS

    call _main

    ld    de, #mystr
    ld      c, #0xFF
    call PUTS


;    ld      hl, #4
;    add     hl, sp
;    call  STRLEN
;    ld      hl, #4
;    add     hl, sp
;    ex      de, hl
;    ld      c, #0xFF
;    call PUTS


;    ld	  de, #0
;    call	UpdateScreen

msgloop:          in	  a, (#0x4E)          ; set watchdog timer
              		set	  #3, a
              		out	  (0x4E), a

              		ld	  a, #0x11           ; call API_MSG_GetSysMsg
              		rst   0x08

                    cp #4
                    jr z, is_4

                  jp    msgloop           ; infinite loop

is_4:






    ld      hl, #0
    ex      de, hl
    ld      hl, #0x10
    add     hl, sp
    ld      sp, hl
    ex      de, hl


    pop     bc
    jp      got_msg4
    ret

mystr:
	.ascii "HI FROM ASM"
	.db 0x00
usbdisk:
    .ascii "main.ap"
    .db 0x00

ExecAP::
    ld      a, #0x20
    jp      0x8

PutImage::
    ld      a, #2
    jp      0x20

ClearScreen::
    ld      hl, #0xA0
    jp      0x10

SetAsciiFont::     ld    a, #5
                  jp    0x20

UpdateScreen:     ld    a, #0x10
                  jp    0x20
PUTS::
    ld      hl, #0x11A3
    jp      0x10

SETTEXTPOS::
ld      a, #6
jp      0x20

STRLEN::                                 ; CODE XREF: entry+1D↑p
                                        ; entry+38↑p
                push    af
                push    hl
                push    de
                push    bc
                xor     a
                ex      de, hl
loc_D1F:                                ; CODE XREF: StrLen+9↓j
                cp      (hl)
                ldi
                jr      nz, loc_D1F
                pop     bc
                pop     de
                pop     hl
                pop     af
                ret


got_msg4::
    ex      de, hl
    ex      (sp), hl
    ex      de, hl
    push    hl
    call    probably_address_of_24
    jr      nz, loc_C04
    jr      loc_C08

loc_C04:
    ld      hl, #0x1008
    rst     0x10
loc_C08:
    pop     hl
    pop     de

    ld    de, #usbdisk
    ld     bc, #0x1
    call ExecAP
    ret

probably_address_of_24::
    push    de
    ld      a, e
    rlca
    rlca
    rlca
    and     #7
    push    hl
    push    bc
    ld      hl, (0x98)
    ld      b, #0
    ld      c, a
    add     hl, bc
    ld      a, (hl)
    cp      e
    pop     bc
    pop     hl
    pop     de
    ret

