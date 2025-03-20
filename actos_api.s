.module actosapi
.optsdcc -mz80 sdcccall(1)

RSTFastAPI      = 0x08 ; Fast API
FFSDCardAPI     = 0x0c ; Fast SD card API
RSTBankAPI      = 0x10 ; Bank API (relatively slow)
I2CDrvAPI       = 0x14 ; I2C Driver entry
RSTStgAPI       = 0x18 ; Storage driver dedicated API entry
SDRAMAPI        = 0x1c ; SDRAM Driver entry
RSTDisplayAPI   = 0x20 ; Display driver dedicated API entry
RSTFSAPI        = 0x28 ; File system driver dedicated API entry
RSTSysErrAPI    = 0x30 ; System error handling dedicated API entry


; -------------------------------------
; bank a api resource
; -------------------------------------
; api bank a resource allocation for system class functions
; -------------------------------------
API_IRQ_BaseNoA = 0x0000 ; irq manager in bank a
API_SYSERR = 0x0001 ; system error
API_ADFU_BaseNoA = 0x0002 ; adfu
API_TM_BaseNoA = 0x0008 ; time manager in bank a
API_SDFS_BaseNoA = 0x0010 ; sd file system in bank a
API_MSG_BaseNoA = 0x0018 ; message system in bank a
API_DEVICE_BaseNoA = 0x0020 ; device in bank a
; -------------------------------------
; api bank a resource allocation for driver class functions
; -------------------------------------
; storage class drivers must allocate 16 bank a resources
API_STG_BaseNoA = 0x0080
; Virtual memory driver must allocate 16 bank a resources
API_VM_BaseNoA = 0x0090
; Display driver must allocate 16 bank a resources
API_UI_BaseNoA = 0x00a0
; Keyboard driver must allocate 16 bank a resources
API_KY_BaseNoA = 0x00b0
; File system driver must allocate 16 bank a resources
API_FS_BaseNoA = 0x00c0
; Fast SD card driver must allocate 16 bank a resources
API_SDCardFF_BaseNoA = 0x00d0
; I2C driver must allocate 16 Banka resources
API_I2C_BaseNoA = 0x00e0
API_SDRAM_BaseNoA = 0x00f0
; **************************************************************************
; bank b api resource
; -------------------------------------
; api bank b resource allocation for system class functions
; -------------------------------------
API_DRV_BaseNoB = 0x1000 ; driver management
API_APM_BaseNoB = 0x1008 ; ap management
API_DEVICE_BaseNoB = 0x1010 ; device management
; -------------------------------------
; api bank b resource allocation for driver class functions
; -------------------------------------
; file system fixedly allocates 32 bank b resources
API_FS_BaseNoB = 0x1080
; display driver fixedly allocates 16 bank b resources
API_UI_BaseNoB = 0x10a0
; memory driver fixedly allocates 16 bank b Resources
API_STG_BaseNoB = 0x10b0
; Memory driver must allocate 16 bank b resources
API_SDCardFF_BaseNoB = 0x10c0
















API_GetUsbCableStatus   = (0x0001+API_DEVICE_BaseNoA)
API_GetUsbAttribute     = (0x0101+API_DEVICE_BaseNoA)
API_GetUsbSetupInfo     = (0x0201+API_DEVICE_BaseNoA)
API_GetUsbVidPid        = (0x0301+API_DEVICE_BaseNoA)
API_GetMtpVidPid        = (0x0401+API_DEVICE_BaseNoA)

API_GetMtpMfrInfo       = (0x000e+API_DEVICE_BaseNoA)
API_GetMtpProdInfo      = (0x010e+API_DEVICE_BaseNoA)
API_GetMtpProdVer       = (0x020e+API_DEVICE_BaseNoA)
API_GetMtpProdSn        = (0x030e+API_DEVICE_BaseNoA)

API_GetBattery          = (0x0002+API_DEVICE_BaseNoA)

API_InitDSPCode         = (0x0003+API_DEVICE_BaseNoA)

API_StartDsp            = (0x0004+API_DEVICE_BaseNoA)
API_StopDsp             = (0x0104+API_DEVICE_BaseNoA)
API_SetDspMips          = (0x0204+API_DEVICE_BaseNoA)

API_GetWmaTable         = (0x0005+API_DEVICE_BaseNoA)
API_GetOggTable         = (0x0105+API_DEVICE_BaseNoA)

API_ADC_Enable          = (0x0006+API_DEVICE_BaseNoA)
API_ADC_Disable         = (0x0106+API_DEVICE_BaseNoA)
API_ADC_SetRate         = (0x0206+API_DEVICE_BaseNoA)
API_ADC_SetGain         = (0x0306+API_DEVICE_BaseNoA)
API_ADC_GetRate         = (0x0406+API_DEVICE_BaseNoA)
API_ADC_GetGain         = (0x0506+API_DEVICE_BaseNoA)
API_DAC_Enable          = (0x0007+API_DEVICE_BaseNoA)
API_DAC_Disable         = (0x0107+API_DEVICE_BaseNoA)
API_DAC_SetRate         = (0x0207+API_DEVICE_BaseNoA)
API_DAC_GetRate         = (0x0307+API_DEVICE_BaseNoA)
API_PA_Enable           = (0x0008+API_DEVICE_BaseNoA)
API_PA_Disable          = (0x0108+API_DEVICE_BaseNoA)
API_PA_SetVolume        = (0x0208+API_DEVICE_BaseNoA)
API_PA_GetVolume        = (0x0308+API_DEVICE_BaseNoA)

API_AI_Enable           = (0x0009+API_DEVICE_BaseNoA)
API_AI_Disable          = (0x0109+API_DEVICE_BaseNoA)
API_AI_SetGain          = (0x0209+API_DEVICE_BaseNoA)
API_AI_GetGain          = (0x0309+API_DEVICE_BaseNoA)

API_GetFwVersion        = (0x000a+API_DEVICE_BaseNoA)
API_GetDefaultComval    = (0x000b+API_DEVICE_BaseNoA)
API_GetFMTag            = (0x000c+API_DEVICE_BaseNoA)

API_InitDSPCodeExp      = (0x000d+API_DEVICE_BaseNoA)


.area _CODE


.globl	_GetBattery
_GetBattery::
    ld a, #API_GetBattery
    jp RSTBankAPI


.globl	_PutS_2
_PutS_2::
    ld c, e
    ld b, #0
    ex de, hl
    ld hl, #0x11A3
    jp RSTBankAPI



.globl	_PutChar_2
_PutChar_2::
    ld c, e
    ld b, #0
    ex de, hl
    ld hl, #0x11A3
    jp RSTBankAPI
