@echo off
echo "Building..."
z80asm -ltest.lst -otest.bin <test.asm
pause
"Uploading..."
loadram.exe test.bin
cd ..
pause
