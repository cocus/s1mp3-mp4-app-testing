;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.2 #15323 (MINGW32)
;--------------------------------------------------------
	.module main
	
	.optsdcc -mz80 sdcccall(1)
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _SetTextPos
	.globl _SetAsciiFont
	.globl _GetSysMsg
	.globl _ClearScreen
	.globl _PutImage
	.globl _PutS_2
	.globl _itoa_3
	.globl _buffer
	.globl _hourglass
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_REG_WATCHDOG	=	0x004e
_REG_BATTERY_MON	=	0x00d0
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_buffer::
	.ds 20
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;main.c:320: char *itoa_3(uint16_t i, char *buf)
;	---------------------------------
; Function itoa_3
; ---------------------------------
_itoa_3::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
	ld	c, e
	ld	b, d
;main.c:322: buf[0] = (i % 1000) / 100 + '0';
	ex	(sp), hl
	push	bc
	ld	de, #0x03e8
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	call	__moduint
	ex	de, hl
	ld	de, #0x0064
	call	__divuint
	pop	bc
	ld	a, e
	add	a, #0x30
	ld	(bc), a
;main.c:323: buf[1] = (i % 100) / 10 + '0';
	ld	l, c
	ld	h, b
	inc	hl
	ld	-2 (ix), l
	ld	-1 (ix), h
	push	bc
	ld	de, #0x0064
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	call	__moduint
	ld	a, e
	ld	l, #0x0a
	call	__divuchar
	ld	a, e
	pop	bc
	add	a, #0x30
	pop	de
	pop	hl
	push	hl
	push	de
	ld	(hl), a
;main.c:324: buf[2] = (i % 10) + '0';
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	push	hl
	push	bc
	ld	de, #0x000a
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	call	__moduint
	pop	bc
	pop	hl
	ld	a, e
	add	a, #0x30
	ld	(hl), a
;main.c:325: buf[3] = 0;
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	inc	hl
	ld	(hl), #0x00
;main.c:327: return buf;
	ld	e, c
	ld	d, b
;main.c:328: }
	ld	sp, ix
	pop	ix
	ret
;main.c:541: void main(void)
;	---------------------------------
; Function main
; ---------------------------------
_main::
;main.c:543: PutImage(NULL, IMGADDRNULL);
	ld	de, #0xffff
	ld	hl, #0x0000
	call	_PutImage
;main.c:544: ClearScreen(NULL);
	ld	hl, #0x0000
	call	_ClearScreen
;main.c:545: SetAsciiFont(1); // big font!
	ld	a, #0x01
	call	_SetAsciiFont
;main.c:547: buffer[0] = 'G';
	ld	hl, #_buffer
	ld	(hl), #0x47
;main.c:548: itoa_3(REG_BATTERY_MON & 0xf, &buffer[3]);
	ld	de, #(_buffer + 3)
	in	a, (_REG_BATTERY_MON)
	and	a, #0x0f
	ld	h, #0x00
	ld	l, a
	call	_itoa_3
;main.c:549: SetTextPos(0, 0x40);
	ld	l, #0x40
	xor	a, a
	call	_SetTextPos
;main.c:550: PutS_2(buffer, -1);
	ld	de, #0xffff
	ld	hl, #_buffer
	call	_PutS_2
;main.c:554: while (GetSysMsg() != 4)
00101$:
	call	_GetSysMsg
	sub	a, #0x04
	jr	Z, 00103$
;main.c:307: REG_WATCHDOG |= WATCHDOG_RESET;
	in	a, (_REG_WATCHDOG)
	or	a, #0x08
	out	(_REG_WATCHDOG), a
;main.c:556: Watchdog_Pet();
	jr	00101$
00103$:
;main.c:567: buffer[0] = 'B';
	ld	hl, #_buffer
	ld	(hl), #0x42
;main.c:568: buffer[1] = 'y';
	inc	hl
	ld	(hl), #0x79
;main.c:569: buffer[2] = 'e';
	ld	hl, #_buffer + 2
	ld	(hl), #0x65
;main.c:570: buffer[3] = '\0';
	ld	hl, #(_buffer + 3)
	ld	(hl), #0x00
;main.c:572: PutS_2(buffer, -1);
	ld	de, #0xffff
	ld	hl, #_buffer
;main.c:573: }
	jp	_PutS_2
_hourglass:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x41	; 65	'A'
	.db #0x10	; 16
	.db #0xa2	; 162
	.db #0x29	; 41
	.db #0x45	; 69	'E'
	.db #0x39	; 57	'9'
	.area _CODE
	.area _INITIALIZER
__xinit__buffer:
	.ascii "FORRO!!1"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.area _CABS (ABS)
