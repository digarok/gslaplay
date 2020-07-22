#
# gslaplay/Makefile
#

# This makefile was created by Jason Andersen
#
# I build on Windows-10 64-bit, this makefile is designed to run under
# a Windows-10 Command Prompt, and makes use of DOS shell commands
#
# As far a free stuff, I setup a c:\bin directory, in my path
# the following packages and executables are in there
#
# Fine Tools from Brutal Deluxe
# http://www.brutaldeluxe.fr/products/crossdevtools/
# Cadius.exe
# Merlin32.exe
# OMFAnalyzer.exe
# LZ4.exe
#
# gnumake-4.2.1-x64.exe (with a symbolic link that aliases this to "make")
#
# https://apple2.gs/plus/
# gsplus32.exe (KEGS based GS Emulator fork by Dagen Brock)
# I configure this to boot the player.po image directly
# once that's done "make run" will build, update the disk image
# and boot into the player.
#

# Make and Build Variables

TARGETNAME = play

VPATH = src:obj
ASMFILES = $(wildcard asm/*.s)
ASM = merlin32

help:
	@echo. 
	@echo $(TARGETNAME) Makefile
	@echo -------------------------------------------------
	@echo build commands:
	@echo    make gs     - Apple IIgs
	@echo    make image  - Build Bootable .PO File
	@echo    make run    - Build / Run IIgs on emulator
	@echo    make clean  - Clean intermediate/target files
	@echo    make depend - Build dependencies
	@echo -------------------------------------------------
	@echo.

$(TARGETNAME).sys16: $(ASMFILES) $(OBJFILES)
	$(ASM) -v macros asm/link.s
	move /y asm\$(TARGETNAME).sys16 .

gs: $(TARGETNAME).sys16

disk image: gs
	@echo Updating $(TARGETNAME).po
	@echo Remove $(TARGETNAME).sys16
	cadius deletefile $(TARGETNAME).po /$(TARGETNAME)/$(TARGETNAME).sys16
	@echo Add $(TARGETNAME).sys16
	cadius addfile $(TARGETNAME).po /$(TARGETNAME) ./$(TARGETNAME).sys16

run: image
	gsplus32

clean:
	@echo Remove $(TARGETNAME).sys16
	$(shell if exist $(TARGETNAME).sys16 echo Y | del $(TARGETNAME).sys16)
#	@echo Remove Intermediate Files
#	@del /q obj\*

depend:
	@echo TODO - make dependencies

# Create all the directories
#$(shell if not exist $(DIRS) mkdir $(DIRS))

