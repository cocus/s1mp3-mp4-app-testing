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
	.globl _itoa_3
	.globl _GetSysMsg
	.globl _SetAsciiFont
	.globl _UpdateScreen
	.globl _PutS_2
	.globl _PutS
	.globl _PutChar
	.globl _SetTextPos
	.globl _ClearScreen
	.globl _PutImage
	.globl _API_RST20_one_param
	.globl _API_RST20_two_param
	.globl _API_RST10_two_param
	.globl _API_RST10_one_param
	.globl _API_RST8_no_params
	.globl _Watchdog_Pet
	.globl _LCD_CMD
	.globl _hourglass
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_REG_WATCHDOG	=	0x004e
_REG_BATTERY_MON	=	0x00d0
_REG_GPIOC_DATA	=	0x00f4
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_LCD_CMD	=	0x8000
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
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
;main.c:60: void Watchdog_Pet(void)
;	---------------------------------
; Function Watchdog_Pet
; ---------------------------------
_Watchdog_Pet::
;main.c:62: REG_WATCHDOG |= WATCHDOG_RESET;
	in	a, (_REG_WATCHDOG)
	or	a, #0x08
	out	(_REG_WATCHDOG), a
;main.c:63: }
	ret
;main.c:65: uint8_t API_RST8_no_params(uint8_t fun) __naked __sdcccall(1)
;	---------------------------------
; Function API_RST8_no_params
; ---------------------------------
_API_RST8_no_params::
;main.c:68: __asm__("jp 0x8");
	jp	0x8
;main.c:69: }
;main.c:71: void API_RST10_one_param(uint16_t fun, uint16_t param) __naked __sdcccall(1)
;	---------------------------------
; Function API_RST10_one_param
; ---------------------------------
_API_RST10_one_param::
;main.c:75: __asm__("jp 0x10");
	jp	0x10
;main.c:76: }
;main.c:78: void API_RST10_two_param(uint16_t fun /* hl */, uint16_t param1 /* de */, uint16_t param2 /* stack */) __naked __sdcccall(1)
;	---------------------------------
; Function API_RST10_two_param
; ---------------------------------
_API_RST10_two_param::
;main.c:83: __asm__("pop bc"); /* param2 -> BC */
	pop	bc
;main.c:84: __asm__("jp 0x10");
	jp	0x10
;main.c:85: }
;main.c:87: void API_RST20_two_param(uint8_t fun /* a */, uint16_t param1 /* stack */, uint16_t param2 /* de */) __naked __sdcccall(1)
;	---------------------------------
; Function API_RST20_two_param
; ---------------------------------
_API_RST20_two_param::
;main.c:92: __asm__("pop bc"); /* param1 -> BC */
	pop	bc
;main.c:93: __asm__("jp 0x20");
	jp	0x20
;main.c:94: }
;main.c:96: void API_RST20_one_param(uint8_t fun /* a */, uint16_t param1 /* stack? */) __naked __sdcccall(1)
;	---------------------------------
; Function API_RST20_one_param
; ---------------------------------
_API_RST20_one_param::
;main.c:100: __asm__("jp 0x20");
	jp	0x20
;main.c:101: }
;main.c:212: void PutImage(/* hl */ region_t *imageregion, /* de */ char *imageaddr) __naked __sdcccall(1)
;	---------------------------------
; Function PutImage
; ---------------------------------
_PutImage::
;main.c:216: API_RST20_two_param(API_PutImage /* a */, imageregion /* hl */, imageaddr /* de */);
	ex	de, hl
	push	hl
	ld	a, #0x02
	call	_API_RST20_two_param
;main.c:217: __asm__("ret");
	ret
;main.c:220: }
;main.c:222: void ClearScreen(/* hl */ region_t *imageregion) __naked __sdcccall(1)
;	---------------------------------
; Function ClearScreen
; ---------------------------------
_ClearScreen::
	ex	de, hl
;main.c:225: API_RST10_one_param(API_ClearScreen /* a */, imageregion /* hl */);
	ld	hl, #0x00a0
;main.c:226: __asm__("ret");
	jp  _API_RST10_one_param
;main.c:228: }
;main.c:230: void SetTextPos(uint8_t col /* a */, uint8_t row /* l */) __naked __sdcccall(1)
;	---------------------------------
; Function SetTextPos
; ---------------------------------
_SetTextPos::
;main.c:234: API_RST20_two_param(API_SetTextPos /* a */, col /* stack */, row /* de */);
	ld	h, #0x00
	ld	d, h
	push	hl
	ld	e, a
	ld	a, #0x06
	call	_API_RST20_two_param
;main.c:235: __asm__("ret");
	ret
;main.c:238: }
;main.c:241: void PutChar(uint16_t code) __naked __sdcccall(1)
;	---------------------------------
; Function PutChar
; ---------------------------------
_PutChar::
	ex	de, hl
;main.c:244: API_RST20_one_param(API_PutChar /* a */, code /* hl */);
	xor	a, a
;main.c:245: __asm__("ret");
	jp  _API_RST20_one_param
;main.c:248: }
;main.c:250: void PutS(/* hl */ char *str, /* de */ uint16_t strlen) __naked __sdcccall(1)
;	---------------------------------
; Function PutS
; ---------------------------------
_PutS::
;main.c:254: API_RST20_two_param(API_PutS /* a */, str /* stack? */, (uint8_t)strlen /* de */);
	ld	d, #0x00
	ex	de, hl
	push	hl
	ld	a, #0x01
	call	_API_RST20_two_param
;main.c:255: __asm__("ret");
	ret
;main.c:258: }
;main.c:267: void UpdateScreen(/* hl */ region_t *imageregion) __naked __sdcccall(1)
;	---------------------------------
; Function UpdateScreen
; ---------------------------------
_UpdateScreen::
	ex	de, hl
;main.c:270: API_RST20_one_param(API_UpdateScreen /* a */, imageregion /* hl */);
	ld	a, #0x04
;main.c:271: __asm__("ret");
	jp  _API_RST20_one_param
;main.c:273: }
;main.c:285: void SetAsciiFont(unsigned char FontID) __naked __sdcccall(1)
;	---------------------------------
; Function SetAsciiFont
; ---------------------------------
_SetAsciiFont::
;main.c:288: API_RST20_one_param(API_SetAsciiFont /* a */, FontID /* hl */);
	ld	d, #0x00
	ld	e, a
	ld	a, #0x05
;main.c:289: __asm__("ret");
	jp  _API_RST20_one_param
;main.c:291: }
;main.c:316: unsigned char GetSysMsg(void)
;	---------------------------------
; Function GetSysMsg
; ---------------------------------
_GetSysMsg::
;main.c:318: return API_RST8_no_params(API_MSG_GetSysMsg);
	ld	a, #0x11
;main.c:319: }
	jp	_API_RST8_no_params
;main.c:331: char *itoa_3(uint16_t i, char *buf)
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
;main.c:333: buf[0] = (i % 1000) / 100 + '0';
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
;main.c:334: buf[1] = (i % 100) / 10 + '0';
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
;main.c:335: buf[2] = (i % 10) + '0';
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
;main.c:336: buf[3] = 0;
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	inc	hl
	ld	(hl), #0x00
;main.c:338: return buf;
	ld	e, c
	ld	d, b
;main.c:339: }
	ld	sp, ix
	pop	ix
	ret
;main.c:442: static inline void gpio_c2_off(void)
;	---------------------------------
; Function gpio_c2_off
; ---------------------------------
_gpio_c2_off:
;main.c:444: REG_GPIOC_DATA &= 0xfb;
	in	a, (_REG_GPIOC_DATA)
	and	a, #0xfb
	out	(_REG_GPIOC_DATA), a
;main.c:445: }
	ret
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
;main.c:447: static inline void gpio_c2_on(void)
;	---------------------------------
; Function gpio_c2_on
; ---------------------------------
_gpio_c2_on:
;main.c:449: REG_GPIOC_DATA |= 0x4;
	in	a, (_REG_GPIOC_DATA)
	or	a, #0x04
	out	(_REG_GPIOC_DATA), a
;main.c:450: }
	ret
;main.c:452: static inline void ssd1789_cmd(uint8_t cmd)
;	---------------------------------
; Function ssd1789_cmd
; ---------------------------------
_ssd1789_cmd:
	ld	c, a
;main.c:444: REG_GPIOC_DATA &= 0xfb;
	in	a, (_REG_GPIOC_DATA)
	and	a, #0xfb
	out	(_REG_GPIOC_DATA), a
;main.c:455: LCD_CMD = cmd;
	ld	hl, #_LCD_CMD
	ld	(hl), c
;main.c:456: }
	ret
;main.c:458: static inline void ssd1789_data(uint8_t cmd)
;	---------------------------------
; Function ssd1789_data
; ---------------------------------
_ssd1789_data:
;main.c:449: REG_GPIOC_DATA |= 0x4;
	push	af
	in	a, (_REG_GPIOC_DATA)
	or	a, #0x04
	out	(_REG_GPIOC_DATA), a
	pop	af
;main.c:461: LCD_CMD = cmd;
	ld	(_LCD_CMD+0), a
;main.c:462: }
	ret
;main.c:464: static inline void ssd1789_set_col(uint8_t start, uint8_t end)
;	---------------------------------
; Function ssd1789_set_col
; ---------------------------------
_ssd1789_set_col:
	ld	c, a
;main.c:444: REG_GPIOC_DATA &= 0xfb;
	in	a, (_REG_GPIOC_DATA)
	and	a, #0xfb
	out	(_REG_GPIOC_DATA), a
;main.c:455: LCD_CMD = cmd;
	ld	iy, #_LCD_CMD
	ld	0 (iy), #0x15
;main.c:449: REG_GPIOC_DATA |= 0x4;
	in	a, (_REG_GPIOC_DATA)
	or	a, #0x04
	out	(_REG_GPIOC_DATA), a
;main.c:461: LCD_CMD = cmd;
	ld	0 (iy), c
;main.c:449: REG_GPIOC_DATA |= 0x4;
	in	a, (_REG_GPIOC_DATA)
	or	a, #0x04
	out	(_REG_GPIOC_DATA), a
;main.c:461: LCD_CMD = cmd;
	ld	0 (iy), l
;main.c:468: ssd1789_data(end);
;main.c:469: }
	ret
;main.c:471: static inline void ssd1789_set_page(uint8_t start, uint8_t end)
;	---------------------------------
; Function ssd1789_set_page
; ---------------------------------
_ssd1789_set_page:
	ld	c, a
;main.c:444: REG_GPIOC_DATA &= 0xfb;
	in	a, (_REG_GPIOC_DATA)
	and	a, #0xfb
	out	(_REG_GPIOC_DATA), a
;main.c:455: LCD_CMD = cmd;
	ld	iy, #_LCD_CMD
	ld	0 (iy), #0x75
;main.c:449: REG_GPIOC_DATA |= 0x4;
	in	a, (_REG_GPIOC_DATA)
	or	a, #0x04
	out	(_REG_GPIOC_DATA), a
;main.c:461: LCD_CMD = cmd;
	ld	0 (iy), c
;main.c:449: REG_GPIOC_DATA |= 0x4;
	in	a, (_REG_GPIOC_DATA)
	or	a, #0x04
	out	(_REG_GPIOC_DATA), a
;main.c:461: LCD_CMD = cmd;
	ld	0 (iy), l
;main.c:475: ssd1789_data(end);
;main.c:476: }
	ret
;main.c:478: void main(void)
;	---------------------------------
; Function main
; ---------------------------------
_main::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-20
	add	hl, sp
	ld	sp, hl
;main.c:481: __asm__("ld bc, #0");      // null
	ld	bc, #0
;main.c:482: __asm__("ld de, #0xffff"); // imgaddr
	ld	de, #0xffff
;main.c:483: __asm__("ld a, #2");
	ld	a, #2
;main.c:484: __asm__("rst 0x20");
	rst	0x20
;main.c:486: __asm__("ld de, #0"); // null
	ld	de, #0
;main.c:487: __asm__("ld hl, #0xA0");
	ld	hl, #0xA0
;main.c:488: __asm__("rst 0x10");
	rst	0x10
;main.c:493: char buffer[20] = {"FORRO!!1"};
	ld	hl, #0
	add	hl, sp
	ld	(hl), #0x46
	ld	-19 (ix), #0x4f
	ld	-18 (ix), #0x52
	ld	e, l
	ld	d, h
	inc	de
	inc	de
	inc	de
	ld	a, #0x52
	ld	(de), a
	ld	-16 (ix), #0x4f
	ld	-15 (ix), #0x21
	ld	-14 (ix), #0x21
	ld	-13 (ix), #0x31
	ld	-12 (ix), #0x00
	ld	-11 (ix), #0x00
	ld	-10 (ix), #0x00
	ld	-9 (ix), #0x00
	ld	-8 (ix), #0x00
	ld	-7 (ix), #0x00
	ld	-6 (ix), #0x00
	ld	-5 (ix), #0x00
	ld	-4 (ix), #0x00
	ld	-3 (ix), #0x00
	ld	-2 (ix), #0x00
	ld	-1 (ix), #0x00
;main.c:494: buffer[0] = 'G';
	ld	(hl), #0x47
;main.c:497: itoa_3(REG_BATTERY_MON & 0xf, &buffer[3]);
	in	a, (_REG_BATTERY_MON)
	and	a, #0x0f
	ld	c, #0x00
	push	hl
	ld	l, a
	ld	h, c
	call	_itoa_3
	pop	hl
;main.c:499: PutS_2(buffer, -1);
	ld	de, #0xffff
	call	_PutS_2
;main.c:501: while (GetSysMsg() != 4)
00101$:
	call	_GetSysMsg
	sub	a, #0x04
	jr	Z, 00103$
;main.c:503: Watchdog_Pet();
	call	_Watchdog_Pet
	jr	00101$
00103$:
;main.c:507: __asm__("ld de, #0"); // null
	ld	de, #0
;main.c:508: __asm__("ld hl, #0xA0");
	ld	hl, #0xA0
;main.c:509: __asm__("rst 0x10");
	rst	0x10
;main.c:444: REG_GPIOC_DATA &= 0xfb;
	in	a, (_REG_GPIOC_DATA)
	and	a, #0xfb
	out	(_REG_GPIOC_DATA), a
;main.c:455: LCD_CMD = cmd;
	ld	iy, #_LCD_CMD
	ld	0 (iy), #0x15
;main.c:449: REG_GPIOC_DATA |= 0x4;
	in	a, (_REG_GPIOC_DATA)
	or	a, #0x04
	out	(_REG_GPIOC_DATA), a
;main.c:461: LCD_CMD = cmd;
	ld	0 (iy), #0x36
;main.c:449: REG_GPIOC_DATA |= 0x4;
	in	a, (_REG_GPIOC_DATA)
	or	a, #0x04
	out	(_REG_GPIOC_DATA), a
;main.c:461: LCD_CMD = cmd;
	ld	0 (iy), #0x40
;main.c:444: REG_GPIOC_DATA &= 0xfb;
	in	a, (_REG_GPIOC_DATA)
	and	a, #0xfb
	out	(_REG_GPIOC_DATA), a
;main.c:455: LCD_CMD = cmd;
	ld	0 (iy), #0x75
;main.c:449: REG_GPIOC_DATA |= 0x4;
	in	a, (_REG_GPIOC_DATA)
	or	a, #0x04
	out	(_REG_GPIOC_DATA), a
;main.c:461: LCD_CMD = cmd;
	ld	0 (iy), #0x2e
;main.c:449: REG_GPIOC_DATA |= 0x4;
	in	a, (_REG_GPIOC_DATA)
	or	a, #0x04
	out	(_REG_GPIOC_DATA), a
;main.c:461: LCD_CMD = cmd;
	ld	0 (iy), #0x51
;main.c:444: REG_GPIOC_DATA &= 0xfb;
	in	a, (_REG_GPIOC_DATA)
	and	a, #0xfb
	out	(_REG_GPIOC_DATA), a
;main.c:455: LCD_CMD = cmd;
	ld	0 (iy), #0x5c
;main.c:449: REG_GPIOC_DATA |= 0x4;
	in	a, (_REG_GPIOC_DATA)
	or	a, #0x04
	out	(_REG_GPIOC_DATA), a
;main.c:517: for (pos = 0; pos < sizeof(hourglass); pos++)
	ld	c, #0x00
00125$:
;main.c:519: LCD_CMD = hourglass[pos];
	ld	hl, #_hourglass
	ld	b, #0x00
	add	hl, bc
	ld	a, (hl)
	ld	(_LCD_CMD+0), a
;main.c:517: for (pos = 0; pos < sizeof(hourglass); pos++)
	inc	c
	ld	a, c
	sub	a, #0x09
	jr	C, 00125$
;main.c:522: while (GetSysMsg() != 4)
00105$:
	call	_GetSysMsg
	sub	a, #0x04
	jr	Z, 00107$
;main.c:524: Watchdog_Pet();
	call	_Watchdog_Pet
	jr	00105$
00107$:
;main.c:526: __asm__("ld de, #0"); // null
	ld	de, #0
;main.c:527: __asm__("ld hl, #0xA0");
	ld	hl, #0xA0
;main.c:528: __asm__("rst 0x10");
	rst	0x10
;main.c:565: }
	ld	sp, ix
	pop	ix
	ret
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
