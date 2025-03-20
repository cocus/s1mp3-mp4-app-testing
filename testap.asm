
;-------------------------------------------------------------------------------
; definitions
;-------------------------------------------------------------------------------
HEADER_LENGTH:    equ 0x0800
CODE_ADDRESS:     equ 0x0800
FILE_LENGTH:      equ 36864               ; the filesize of the ap u want to replace


;-------------------------------------------------------------------------------
; ap header
;-------------------------------------------------------------------------------
                  org   0x0000
header:           dw    0x0050            ; header id
		              dw    0x4757            ;
		              dw    0x9719            ;
		              dw    0x0003            ;
                  dw    HEADER_LENGTH     ; text fileoffset (lo)
                  dw    0                 ; text fileoffset (hi)
                  dw    CODE_LENGTH       ; text length
                  dw    CODE_ADDRESS      ; text address
                  dw    0                 ; data fileoffset (lo)
                  dw    0                 ; data fileoffset (hi)
                  dw    0                 ; data length
                  dw    0                 ; data address
                  dw    0                 ; bss length
		              dw    0                 ; bss address
                  dw    entrypoint        ; entry point
                  db    0                 ; entry bank
                  db    0                 ; number of banks
                  ds    HEADER_LENGTH - $


;-------------------------------------------------------------------------------
; code segment
;-------------------------------------------------------------------------------
                  org   CODE_ADDRESS

;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_REG_WATCHDOG:	equ	0x004e
;	---------------------------------
; Function init
; ---------------------------------
entrypoint:
;main.c:16: __asm__("push    bc");
	push	   bc
;main.c:17: __asm__("push    de");
	push	   de
;main.c:18: __asm__("ld      hl, 0xFFF0");
	ld	     hl, 0xFFF0
;main.c:19: __asm__("add     hl, sp");
	add	    hl, sp
;main.c:20: __asm__("ld      sp, hl");
	ld	     sp, hl
;main.c:21: main();
	call	_main
;main.c:22: __asm__("pop de");
	pop	de
;main.c:23: __asm__("pop bc");
	pop	bc
;main.c:24: __asm__("ret");
	ret
;main.c:25: }
	ret
;main.c:31: void Watchdog_Pet(void)
;	---------------------------------
; Function Watchdog_Pet
; ---------------------------------
_Watchdog_Pet:
;main.c:33: REG_WATCHDOG |= WATCHDOG_RESET;
	in	a, (_REG_WATCHDOG)
	or	0x08
	out	(_REG_WATCHDOG), a
;main.c:34: }
	ret
;main.c:36: uint8_t API_RST8_no_params(uint8_t fun) __naked __sdcccall(1)
;	---------------------------------
; Function API_RST8_no_params
; ---------------------------------
_API_RST8_no_params:
;main.c:39: __asm__("jp 0x8");
	jp	0x8
;main.c:40: }
;main.c:42: void API_RST10_one_param(uint16_t fun, uint16_t param) __naked __sdcccall(1)
;	---------------------------------
; Function API_RST10_one_param
; ---------------------------------
_API_RST10_one_param:
;main.c:46: __asm__("jp 0x10");
	jp	0x10
;main.c:47: }
;main.c:49: void API_RST10_two_param(uint16_t fun /* hl */, uint16_t param1 /* de */, uint16_t param2 /* stack */) __naked __sdcccall(1)
;	---------------------------------
; Function API_RST10_two_param
; ---------------------------------
_API_RST10_two_param:
;main.c:54: __asm__("pop bc"); /* param2 -> BC */
	pop	bc
;main.c:55: __asm__("jp 0x10");
	jp	0x10
;main.c:56: }
;main.c:58: void API_RST20_two_param(uint8_t fun /* a */, uint16_t param1 /* stack */, uint16_t param2 /* de */) __naked __sdcccall(1)
;	---------------------------------
; Function API_RST20_two_param
; ---------------------------------
_API_RST20_two_param:
;main.c:63: __asm__("pop bc"); /* param1 -> BC */
	pop	bc
;main.c:64: __asm__("jp 0x20");
	jp	0x20
;main.c:65: }
;main.c:67: void API_PutS(char* str /* hl */, uint16_t color /* de */) __naked  __sdcccall(1)
;	---------------------------------
; Function API_PutS
; ---------------------------------
_API_PutS:
;main.c:72: API_RST10_two_param(0x11a3, str, (uint8_t)color);
	ld	d, 0x00
	ex	de, hl
	push	hl
	ld	hl, 0x11a3
	call	_API_RST10_two_param
;main.c:73: __asm__("ret");
	ret
;main.c:74: }
;main.c:76: void API_Update_Screen(uint16_t mode /* hl */) __naked  __sdcccall(1)
;	---------------------------------
; Function API_Update_Screen
; ---------------------------------
_API_Update_Screen:
	ex	de, hl
;main.c:79: API_RST10_one_param(0xa0 /* hl */, mode /* de */);
	ld	hl, 0x00a0
;main.c:80: __asm__("ret");
	jp  _API_RST10_one_param
;main.c:81: }
;main.c:83: void API_Screen_Clear(uint16_t param1 /* hl */, uint16_t param2 /* de */) __naked  __sdcccall(1)
;	---------------------------------
; Function API_Screen_Clear
; ---------------------------------
_API_Screen_Clear:
;main.c:87: API_RST20_two_param(2 /* a */, param1 /* hl */, param2 /* de */);
	ex	de, hl
	push	hl
	ld	a, 0x02
	call	_API_RST20_two_param
;main.c:88: __asm__("ret");
	ret
;main.c:89: }
;main.c:91: void API_Set_Text_Pos(uint8_t col /* a */, uint8_t row /* l */) __naked  __sdcccall(1)
;	---------------------------------
; Function API_Set_Text_Pos
; ---------------------------------
_API_Set_Text_Pos:
;main.c:97: API_RST20_two_param(6 /* a */, col /* stack */, row /* de */);
	ld	h, 0x00
	ld	d, h
	push	hl
	ld	e, a
	ld	a, 0x06
	call	_API_RST20_two_param
;main.c:98: __asm__("ret");
	ret
;main.c:99: }
;main.c:101: uint8_t API_Get_Sys_Msg(void) __naked  __sdcccall(1)
;	---------------------------------
; Function API_Get_Sys_Msg
; ---------------------------------
_API_Get_Sys_Msg:
;main.c:103: return API_RST8_no_params(0x11);
	ld	a, 0x11
	jp	_API_RST8_no_params
;main.c:104: }
;main.c:107: void main(void)
;	---------------------------------
; Function main
; ---------------------------------
_main:
;main.c:109: API_Screen_Clear(0 /* hl */, 0xffff /* de */);
	ld	de, 0xffff
	ld	hl, 0x0000
	call	_API_Screen_Clear
;main.c:110: API_Update_Screen(0);
	ld	hl, 0x0000
	call	_API_Update_Screen
;main.c:112: API_Set_Text_Pos(0x0, 0x40);
	ld	l, 0x40
	xor	a
	call	_API_Set_Text_Pos
;main.c:113: API_PutS("HI FROM C", 0x00ff);
	ld	de, 0x00ff
	ld	hl, ___str_0
	call	_API_PutS
;main.c:115: while(1)
l00104:
;main.c:117: Watchdog_Pet();
	call	_Watchdog_Pet
;main.c:118: if (API_Get_Sys_Msg() == 4)
	call	_API_Get_Sys_Msg
	sub	0x04
	jr	NZ, l00104
;main.c:124: API_Screen_Clear(0 /* hl */, 0xf0ff /* de */);
	ld	de, 0xf0ff
	ld	hl, 0x0000
	call	_API_Screen_Clear
;main.c:125: API_Update_Screen(0);
	ld	hl, 0x0000
	call	_API_Update_Screen
;main.c:127: API_Set_Text_Pos(0x0, 0x60);
	ld	l, 0x60
	xor	a
	call	_API_Set_Text_Pos
;main.c:128: API_PutS("cocus was here", 0x00ff);
	ld	de, 0x00ff
	ld	hl, ___str_1
	call	_API_PutS
;main.c:130: while(1)
l00109:
;main.c:132: Watchdog_Pet();
	call	_Watchdog_Pet
;main.c:133: if (API_Get_Sys_Msg() == 4)
	call	_API_Get_Sys_Msg
	sub 0x04
	jr	NZ, l00109
;main.c:135: API_Set_Text_Pos(0x0, 0x80);
	ld	l, 0x80
	xor	a
	call	_API_Set_Text_Pos
;main.c:136: API_PutS("bye!", 0x00ff);
	ld	de, 0x00ff
	ld	hl, ___str_2
;main.c:139: break;
;main.c:142: }
	jp	_API_PutS
___str_0: db "HI FROM C", 0
___str_1: db "cocus was here", 0
___str_2: db "bye!", 0


;-------------------------------------------------------------------------------
; end of file
;-------------------------------------------------------------------------------
CODE_LENGTH:      equ   $ - CODE_ADDRESS
FILE_OFFSET:      equ   HEADER_LENGTH + CODE_LENGTH
                  if    FILE_LENGTH > FILE_OFFSET
                    ds    FILE_LENGTH - FILE_OFFSET
                  endif
                  end
