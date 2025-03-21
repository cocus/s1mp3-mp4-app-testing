CC=sdcc
AS=sdasz80
LD=sdld
CFLAGS=-mz80 --no-std-crt0 --nostdlib --vc
ASFLAGS=
LDFLAGS= -mz80 -Wl -y \
		--std-c11 -mz80 --debug \
		--no-std-crt0 \
		-lz80

all: main.bin
# main.ap

fw.bin: main.ap
	@echo "[READER upd] main.ap -> READER.AP"
#	@cp main.ap fw/READER.AP
	@echo "[S1FWX] create FWIMAGE.FW"
	@./s1fwx a fw/fwimage.fw:fw < fw/script-fw-dir.txt
	@echo "[S1FWX] create FW.BIN"
	@./s1fwx a fw.bin:afi < fw/script-fw-dir.txt

%-asm.rel: %.s
	@echo "[SDASZ80] $< -> $@"
	@$(AS) -xlos -g -o $@ $<

%.rel: %.c
	@echo "[SDCC] $< -> $@"
	$(CC) $(CFLAGS) -c -o $@ $^

%-ap.rel: %.c
	@echo "[SDCC] $< -> $@"
	$(CC) $(CFLAGS) -c -o $@ $^

main.ihx: init-asm.rel actos_api-asm.rel main.rel
	@echo "[SDLD] $^ -> $@"
	$(CC) $(LDFLAGS) --code-loc 0x3400 --data-loc 0x3500 -o $@ $^
#-n -f link.lk -m -b _CODE=0x3400 -b _DATA=0x3500 -i
# $(CC) $(CFLAGS) --code-loc 0x3400 --data-loc 0x3400 -o $@ $^

main-ap.ihx: init-asm.rel actos_api-asm.rel main-ap.rel
	@echo "[SDLD] $^ -> $@"
	$(LD) -n -f link.lk -m -b --code-loc 0x0800 --data-loc 0x0800 _CODE=0x0800 -b _DATA=0x0800 -i $@ $^

%.bin: %.ihx
	@echo "[IHX->BIN] $< -> $@"
	makebin -p $< $@

aphdr.bin: aphdr.asm main-ap-stripped.bin
	@echo "[APHDR] $< -> $@"
	@cp aphdr.asm aphdr.tmp
	@sed -i 's/CODE_LENGTH/$(shell stat -L -c %s main-ap-stripped.bin)/' aphdr.tmp
	@./z80asm -o$@ < aphdr.tmp
	@rm aphdr.tmp

main-ap-stripped.bin: main-ap.bin
	@echo "[STRIP] $< (2048 bytes) -> $@"
	@dd if=$< of=$@ bs=1 skip=2048

main-ap-padded.bin: main-ap-stripped.bin
	@echo "[PADD] to make $< 34816 (36864 - HDR) bytes"
	@cp $< $@
	@truncate -s 34816 $@

main-stripped.bin: main.bin
	@echo "[STRIP] $< (13312 bytes) -> $@"
	@dd if=$< of=$@ bs=1 skip=13312

main.ap: aphdr.bin main-ap-padded.bin
	@echo "[AP] from $^"
	@cat $^ > $@

flash: main-stripped.bin
	loadram.exe $<

flasha: main-stripped.bin
	loadram.exe -u $<

flasha2: main-stripped.bin
	loadram.exe -u 2ndstage.bin $<

clean:
	@rm -f actos_api-asm.lst actos_api-asm.rel actos_api-asm.sym myap.rel init.rel aphdr.lst aphdr.bin actos_api-asm.rel main.ihx main.bin main-stripped.* main.rel main.cdb main.sym main.noi main.lst main.map main.lk main-ap* fw.bin init-*
