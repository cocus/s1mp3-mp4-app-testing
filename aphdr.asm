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
                  dw    CODE_ADDRESS        ; entry point
                  db    0                 ; entry bank
                  db    0                 ; number of banks
                  ds    HEADER_LENGTH - $
