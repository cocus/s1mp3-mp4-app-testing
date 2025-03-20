org 0x3400

;Output a test pattern to the display.

start:
	push    bc
	push    de

	ld      hl, 0FFF0h
	add     hl, sp
	ld      sp, hl

	ld      bc, 0xFFFF
	ld      de, 0x0
	call    PutImage ; clear screen

	ld      de, 0 ; update screen 0 = all, 1 = only changed
	call    ClearScreen

	ld      c, 110
	ld      e, 0h
	call    SetTextPos

	ld      de, textstr
	ld      c, 0xff ; color?
	call    PutS2

	call wait4

	ld      de, 0
	call    ClearScreen

	ld      c, 40h
	ld      e, 0h
	call    SetTextPos

	ld      de, textstr
	ld      c, 127 ; color?
	call    PutS2

	call wait4


	ld      hl, 0
	ex      de, hl
	ld      hl, 12h
	add     hl, sp
	ld      sp, hl
	ex      de, hl
	pop     bc
	jp      got_msg4
	;pop de
	;pop bc
	;ret

; ---------------------------------------------------------------------------
got_msg4:
		ex      de, hl
		ex      (sp), hl
		ex      de, hl
		push    hl
		call    sub_BC9
		jr      nz, loc_C04
		jr      loc_C08

loc_C04:                                ; CODE XREF: RSTBankAPI+BF0↑j
		ld      hl, 1008h
        rst     10h

loc_C08:                                ; CODE XREF: RSTBankAPI+BF2↑j
        pop     hl
        pop     de
        ret

; =============== S U B R O U T I N E =======================================
sub_BC9:                                ; CODE XREF: sub_BDF+3↓p
								; RSTBankAPI+BED↓p
		push    de
		ld      a, e
		rlca
		rlca
		rlca
		and     7
		push    hl
		push    bc
		ld      hl, (0x98)
		ld      b, 0
		ld      c, a
		add     hl, bc
		ld      a, (hl)
		cp      e
		pop     bc
		pop     hl
		pop     de
		ret
; ---------------------------------------------------------------------------



; =============== S U B R O U T I N E =======================================
StrLen:
                push    af
                push    hl
                push    de
                push    bc
                xor     a
                ex      de, hl
loc_D1F:
                cp      (hl)
                ldi
                jr      nz, loc_D1F
                pop     bc
                pop     de
                pop     hl
                pop     af
                ret
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================
PutS2:
                ld      hl, 0x11A3
                jp      RSTBankAPI
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================
MSG_GetSysMsg:
                ld      a, 11h
                jp      RSTFastAPI
; ---------------------------------------------------------------------------


wait4:
		in	  a, (4Eh)          ; set watchdog timer
        set	  3, a
        out	  (4Eh), a
		
		call MSG_GetSysMsg
		cp 4
		jr z, is_4
        jp    wait4           ; infinite loop

is_4:
	ret

textstr:          db    'Cocus screwed it up! 2025!', 0

;-------------------------------------------------------------------------------
; api functions and definitions
;-------------------------------------------------------------------------------
RSTFastAPI:       equ   0x08
RSTBankAPI:       equ   0x10
RSTDisplayAPI:    equ   0x20

API_PutChar:      equ   0x00
API_PutS:         equ   0x01
API_PutImage:     equ   0x02
API_GetFontPoint: equ   0x03
API_SetAsciiFont: equ   0x05
API_SetTextPos:   equ   0x06
API_GetTextPos:   equ   0x07
API_UpdateScreen: equ   0x10
;BANKA
API_UI_BaseNoA:   equ   0x00a0
API_ClearScreen:  equ   0x0000 + API_UI_BaseNoA
API_PutSDImage:   equ   0x0001 + API_UI_BaseNoA
API_InvertRegion: equ   0x0002 + API_UI_BaseNoA
API_SetContrast:  equ   0x0003 + API_UI_BaseNoA
API_HoriScroll:   equ   0x0004 + API_UI_BaseNoA
API_StandbyScreen:equ   0x0005 + API_UI_BaseNoA
API_MsgBox:       equ   0x000f + API_UI_BaseNoA
;BANKB
API_UI_BaseNoB:   equ   0x10a0
API_ShowLogo:     equ   0x0001 + API_UI_BaseNoB

FONT_TYPE_TINY:         equ 0xff
FONT_TYPE_TINY_INVERT:  equ 0xff
FONT_TYPE_SMALL:        equ 0
FONT_TYPE_SMALL_INVERT: equ 1
FONT_TYPE_LARGE:        equ 4
FONT_TYPE_LARGE_INVERT: equ 0xff
FONT_TYPE_DEFAULT:      equ FONT_TYPE_SMALL

;Display API
UpdateScreen:     ld    a, API_UpdateScreen
                  jp    RSTDisplayAPI
SetTextPos:       ld    a, API_SetTextPos
                  jp    RSTDisplayAPI
GetTextPos:       ld    a, API_GetTextPos
                  jp    RSTDisplayAPI
SetAsciiFont:     ld    a, API_SetAsciiFont
                  jp    RSTDisplayAPI
PutChar:          ld    a, API_PutChar
                  jp    RSTDisplayAPI
PutS:             ld    a, API_PutS
                  jp    RSTDisplayAPI
PutImage:         ld    a, API_PutImage
                  jp    RSTDisplayAPI
PutSDImage:       ld    hl, API_PutSDImage
                  jp    RSTDisplayAPI
GetFontPoint:     ld    a, API_GetFontPoint
                  jp    RSTDisplayAPI
;Bank API
StandbyScreen:    ld    hl, API_StandbyScreen
                  jp    RSTBankAPI
ClearScreen:      ld    hl, API_ClearScreen
                  jp    RSTBankAPI
HoriScroll:       ld    hl, API_HoriScroll
                  jp    RSTBankAPI
MsgBox:           ld    hl, API_MsgBox
                  jp    RSTBankAPI
ShowLogo:         ld    hl, API_ShowLogo
                  jp    RSTBankAPI
SetContrast:      ld    hl, API_SetContrast
                  jp    RSTBankAPI
InvertRegion:     ld    hl, API_InvertRegion
                  jp    RSTBankAPI


