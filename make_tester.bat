@echo off
echo update ap file...
copy .\TESTERPADD.AP .\fw\READER.AP

cd fw
..\s1fwx a fwimage.fw:fw <script.txt
..\s1fwx a ..\fw.bin:afi <script.txt
cd ..
pause
