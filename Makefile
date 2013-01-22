# Arduino 0022 Makefile
# Arduino adaptation by mellis, eighthave, oli.keller, linvinus
#
# This makefile allows you to build sketches from the command line
# without the Arduino environment (or Java).
#
# Detailed instructions for using the makefile:
#
#  1. Copy this file into the folder with your sketch. There should be a
#     file with the same name as the folder and with the extension .pde
#     (e.g. foo.pde in the foo/ folder).
#
#  2. Modify the line containg "INSTALL_DIR" to point to the directory that
#     contains the Arduino installation (for example, under Mac OS X, this
#     might be /Applications/arduino-0012).
#
#  3. Modify the line containing "PORT" to refer to the filename
#     representing the USB or serial connection to your Arduino board
#     (e.g. PORT = /dev/tty.USB0).  If the exact name of this file
#     changes, you can use * as a wildcard (e.g. PORT = /dev/tty.usb*).
#
#  4. Set the line containing "MCU" to match your board's processor.
#     Older one's are atmega8 based, newer ones like Arduino Mini, Bluetooth
#     or Diecimila have the atmega168.  If you're using a LilyPad Arduino,
#     change F_CPU to 8000000.
#
#  5. Modify the line containing "SET_SERIAL" to refer to the filename
#     representing the programm setSerialSignal, this programm used
#     to initialisede arduino bootloader.
#     Addition information available there http://johanneshoff.com/arduino-command-line.html.
#
#  6. At the command line, change to the directory containing your
#     program's file and the makefile.
#
#  7. Type "make" and press enter to compile/verify your program.
#
#  8. Type "make upload", reset your Arduino board, and press enter to
#     upload your program to the Arduino board.
#
#  9. To generate new empty project type "make newproject".
#
# $Id$
 
TARGET = $(notdir $(CURDIR))
INSTALL_DIR = /Applications/Arduino.app/Contents/Resources/Java
VARIANT=standard
VARIANT_HEADERS=$(INSTALL_DIR)/hardware/arduino/variants/$(VARIANT)
PORT = /dev/tty.usbmodem*
AVRDUDE_PROGRAMMER = arduino
SET_SERIAL = ../pulsedtr.py
MONITOR = ../monitor.py
SERIAL_RATE = 9600
SLEEP = sleep
SET_SERIAL_SLEEP_TIME = 0.5
MCU = atmega328p
F_CPU = 16000000
 
#use arduino pde file, or renerate cpp from it
#CXX_APP = applet/$(TARGET).cpp
CXX_APP = $(TARGET).pde
 
############################################################################
# Below here nothing should be changed...
 
VERSION=18
ARDUINO = $(INSTALL_DIR)/hardware/arduino/cores/arduino
LIBRARY = $(INSTALL_DIR)/libraries
LIBRARIES = $(LIBRARY)/Servo
AVR_TOOLS_PATH = $(INSTALL_DIR)/hardware/tools/avr/bin
#AVR_TOOLS_PATH = /$(INSTALL_DIR)/hardware/tools/avr/
AVRDUDE_PATH = $(INSTALL_DIR)/hardware/tools
C_MODULES =  \
$(ARDUINO)/wiring_pulse.c \
$(ARDUINO)/wiring_analog.c \
$(ARDUINO)/wiring.c \
$(ARDUINO)/wiring_digital.c \
$(ARDUINO)/WInterrupts.c \
$(ARDUINO)/wiring_shift.c \
# end of C_MODULES
 
CXX_MODULES = \
$(ARDUINO)/CDC.cpp \
$(ARDUINO)/HID.cpp \
$(ARDUINO)/HardwareSerial.cpp \
$(ARDUINO)/IPAddress.cpp \
$(ARDUINO)/Print.cpp \
$(ARDUINO)/Stream.cpp \
$(ARDUINO)/Tone.cpp \
$(ARDUINO)/USBCore.cpp \
$(ARDUINO)/WMath.cpp \
$(ARDUINO)/WString.cpp \
$(ARDUINO)/main.cpp \
$(ARDUINO)/new.cpp \
$(LIBRARY)/Servo/Servo.cpp \
# end of CXX_MODULES
 
C_ADDITION_MODULES := $(shell ls -1 *.c)
CXX_ADDITION_MODULES := $(shell ls -1 *.cpp)
 
MODULES = $(C_MODULES) $(CXX_MODULES)
SRC = $(C_MODULES)
CXXSRC = $(CXX_MODULES) $(CXX_APP) 
FORMAT = ihex
 
 
# Name of this Makefile (used for "make depend").
MAKEFILE = Makefile
 
# Debugging format.
# Native formats for AVR-GCC's -g are stabs [default], or dwarf-2.
# AVR (extended) COFF requires stabs, plus an avr-objcopy run.
#DEBUG = stabs
DEBUG =
 
OPT = s
 
# Place -D or -U options here
CDEFS = -DF_CPU=$(F_CPU)L -DARDUINO=$(VERSION) 
CXXDEFS = -DF_CPU=$(F_CPU)L -DARDUINO=$(VERSION)
 
 
# Place -I options here
CINCS = -I $(INSTALL_DIR)/hardware/tools/avr/include -I$(ARDUINO) -I$(LIBRARIES) -I$(CURDIR) -I$(CURDIR)/applet -I$(VARIANT_HEADERS)
CXXINCS = -I $(INSTALL_DIR)/hardware/tools/avr/include -I$(ARDUINO) -I$(LIBRARIES) -I$(CURDIR) -I$(CURDIR)/applet -I$(VARIANT_HEADERS)
 
# Compiler flag to set the C Standard level.
# c89   - "ANSI" C
# gnu89 - c89 plus GCC extensions
# c99   - ISO C99 standard (not yet fully implemented)
# gnu99 - c99 plus GCC extensions
CSTANDARD = -std=gnu99
CDEBUG = -g$(DEBUG)
CWARN = -Wall
#CWARN = -Wall   # show all warnings
#CWARN = -w      # suppress all warnings
####CTUNING = -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums
CTUNING = -ffunction-sections -fdata-sections
CXXTUNING = -fno-exceptions -ffunction-sections -fdata-sections
#CEXTRA = -Wa,-adhlns=$(<:.c=.lst)
 
CFLAGS = $(CDEBUG) -O$(OPT) $(CWARN) $(CTUNING) $(CDEFS) $(CINCS) $(CSTANDARD) $(CEXTRA)
CXXFLAGS = $(CDEBUG) -O$(OPT) $(CWARN) $(CXXTUNING) $(CDEFS) $(CINCS)
#ASFLAGS = -Wa,-adhlns=$(<:.S=.lst),-gstabs
LDFLAGS = -O$(OPT) -lm -Wl,--gc-sections
 
 
# Programming support using avrdude. Settings and variables.
AVRDUDE_PORT = $(PORT)
AVRDUDE_WRITE_FLASH = -U flash:w:applet/$(TARGET).hex
 
#AVRDUDE_FLAGS = -V -F -C $(INSTALL_DIR)/hardware/tools/avr/etc/avrdude.conf \
 
AVRDUDE_FLAGS =-p $(MCU) -P $(AVRDUDE_PORT) -c $(AVRDUDE_PROGRAMMER)
 
# Program settings
CC = $(AVR_TOOLS_PATH)/avr-gcc
CXX = $(AVR_TOOLS_PATH)/avr-g++
LD = $(AVR_TOOLS_PATH)/avr-gcc
OBJCOPY = $(AVR_TOOLS_PATH)/avr-objcopy
OBJDUMP = $(AVR_TOOLS_PATH)/avr-objdump
AR  = $(AVR_TOOLS_PATH)/avr-ar
SIZE = $(AVR_TOOLS_PATH)/avr-size
NM = $(AVR_TOOLS_PATH)/avr-nm
AVRDUDE = $(AVR_TOOLS_PATH)/avrdude
REMOVE = rm -f
MV = mv -f
 
# Define all object files.
OBJ = $(SRC:.c=.o) $(CXXSRC:.cpp=.o) $(ASRC:.S=.o)
OBJ_MODULES = $(C_MODULES:.c=.o) $(CXX_MODULES:.cpp=.o) $(C_ADDITION_MODULES:.c=.o) $(CXX_ADDITION_MODULES:.cpp=.o)
 
# Define all listing files.
LST = $(ASRC:.S=.lst) $(CXXSRC:.cpp=.lst) $(SRC:.c=.lst)
 
# Combine all necessary flags and optional flags.
# Add target processor to flags.
ALL_CFLAGS = $(CFLAGS) -mmcu=$(MCU)
ALL_CXXFLAGS = $(CXXFLAGS) -mmcu=$(MCU)
ALL_ASFLAGS = -x assembler-with-cpp $(ASFLAGS) -mmcu=$(MCU)
ALL_LDFLAGS = $(LDFLAGS) -mmcu=$(MCU)
 
 
# Default target.
all: applet_files build sizeafter
 
build: elf hex
 
mk_applet_dir:
	mkdir -p ./applet
 
#applet_files: $(TARGET).pde
#	mkdir -p ./applet
#	#ln -sf ../$(TARGET).pde applet/$(TARGET).cpp
 
applet/$(TARGET).cpp: $(TARGET).pde
	# Here is the "preprocessing".
	# It creates a .cpp file based with the same name as the .pde file.
	# On top of the new .cpp file comes the WProgram.h header.
	# and prototypes for setup() and Loop()
	# Then the .cpp file will be compiled. Errors during compile will
	# refer to this new, automatically generated, file.
	# Not the original .pde file you actually edit...
	test -d applet || mkdir applet
	echo '#include "WProgram.h"' > applet/$(TARGET).cpp
	echo 'void init();' >> applet/$(TARGET).cpp
	echo 'void setup();' >> applet/$(TARGET).cpp
	echo 'void loop();' >> applet/$(TARGET).cpp
	cat $(TARGET).pde >> applet/$(TARGET).cpp
	#echo 'int main(void) {\n init();\n setup();\n for (;;) loop();\n return 0;\n}\n' >> applet/$(TARGET).cpp 
	#cp  ./*.c ./*.cpp ./*.h ./applet/ >/dev/null 2>&1
 
elf: mk_applet_dir applet/$(TARGET).elf
hex: applet/$(TARGET).hex
eep: applet/$(TARGET).eep
lss: applet/$(TARGET).lss
sym: applet/$(TARGET).sym
 
# Program the device.  
upload: applet/$(TARGET).hex
	$(SET_SERIAL) $(AVRDUDE_PORT) $(SET_SERIAL_SLEEP_TIME)
	$(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FLASH)
 
# Monitor the device.
monitor:
	$(MONITOR) $(AVRDUDE_PORT) $(SERIAL_RATE)
 
	# Display size of file.
HEXSIZE = $(SIZE) --target=$(FORMAT) applet/$(TARGET).hex
ELFSIZE = $(SIZE)  applet/$(TARGET).elf
sizebefore:
	@if [ -f applet/$(TARGET).elf ]; then echo; echo $(MSG_SIZE_BEFORE); $(HEXSIZE); echo; fi
 
sizeafter:
	@if [ -f applet/$(TARGET).elf ]; then echo; echo $(MSG_SIZE_AFTER); $(HEXSIZE); echo; fi
 
 
# Convert ELF to COFF for use in debugging / simulating in AVR Studio or VMLAB.
COFFCONVERT=$(OBJCOPY) --debugging \
--change-section-address .data-0x800000 \
--change-section-address .bss-0x800000 \
--change-section-address .noinit-0x800000 \
--change-section-address .eeprom-0x810000
 
 
coff: applet/$(TARGET).elf
	$(COFFCONVERT) -O coff-avr applet/$(TARGET).elf $(TARGET).cof
 
 
extcoff: $(TARGET).elf
	$(COFFCONVERT) -O coff-ext-avr applet/$(TARGET).elf $(TARGET).cof
 
 
.SUFFIXES: .elf .hex .eep .lss .sym
 
.elf.hex:
	$(OBJCOPY) -O $(FORMAT) -R .eeprom $< $@
 
.elf.eep:
	$(OBJCOPY) -O $(FORMAT) -j .eeprom --set-section-flags=.eeprom="alloc,load" \
	--no-change-warnings \
	--change-section-lma .eeprom=0 $< $@
 
# Create extended listing file from ELF output file.
.elf.lss:
	$(OBJDUMP) -h -S $< > $@
 
# Create a symbol table from ELF output file.
.elf.sym:
	$(NM) -n $< > $@
 
	# Link: create ELF output file from library.
#applet/$(TARGET).elf: $(TARGET).o applet/core.a
 
applet/$(TARGET).elf: applet/$(TARGET).o applet/core.a
	$(LD) -lc -lm $(ALL_LDFLAGS) -o $@ applet/$(TARGET).o applet/core.a -lc
 
applet/core.a: $(OBJ_MODULES)
	@for i in $(OBJ_MODULES); do echo $(AR) rcs  applet/core.a  applet/$${i##*/}; $(AR) rcs  applet/core.a applet/$${i##*/}; done
 
 
# Compile: create object files from C++ source files.
applet/$(TARGET).o: $(CXX_APP)
	$(CXX) -c $(ALL_CXXFLAGS) -x c++ $(CXX_APP) -o applet/$(*F).o
 
# Compile: create object files from C++ source files.
.cpp.o:
	$(CXX) -c $(ALL_CXXFLAGS) $< -o applet/$(*F).o
 
# Compile: create object files from C source files.
.c.o:
	$(CC) -c $(ALL_CFLAGS) $< -o applet/$(*F).o
 
 
# Compile: create assembler files from C source files.
.c.s:
	$(CC) -S $(ALL_CFLAGS) $< -o applet/$(*F).o
 
 
# Assemble: create object files from assembler source files.
.S.o:
	$(CC) -c $(ALL_ASFLAGS) $< -o applet/$(*F).o
 
 
# Automatic dependencies
%.d: %.c
	$(CC) -M $(ALL_CFLAGS) $< | sed "s;$(notdir $*).o:;$*.o $*.d:;" > applet/$(*F).d
 
%.d: %.cpp
	$(CXX) -M $(ALL_CXXFLAGS) $< | sed "s;$(notdir $*).o:;$*.o $*.d:;" > applet/$(*F).d
 
 
# Target: clean project.
clean:
	$(REMOVE) -rf applet
#	$(REMOVE) applet/$(TARGET).hex applet/$(TARGET).eep applet/$(TARGET).cof applet/$(TARGET).elf \
#	applet/$(TARGET).map applet/$(TARGET).sym applet/$(TARGET).lss applet/core.a
#	@for i in $(OBJ); do $(REMOVE)  applet/$${i##*/}; done
#	@for i in $(LST); do $(REMOVE)  applet/$${i##*/}; done
#	@for i in $(SRC:.c=.s); do $(REMOVE)  applet/$${i##*/}; done
#	@for i in $(SRC:.c=.d); do $(REMOVE)  applet/$${i##*/}; done	
#	@for i in $(CXXSRC:.cpp=.s); do $(REMOVE)  applet/$${i##*/}; done	
#	@for i in $(CXXSRC:.cpp=.d); do $(REMOVE)  applet/$${i##*/}; done	
#	@for i in $(OBJ_MODULES); do $(REMOVE)  applet/$${i##*/}; done
 
newproject:
	echo '#ifndef WProgram_h' > $(TARGET).pde	
	echo '#include "WProgram.h"' >> $(TARGET).pde
	echo '#endif' >> $(TARGET).pde
	echo '' >> $(TARGET).pde
	echo '/* Example how to include c headers' >> $(TARGET).pde
	echo '#ifdef __cplusplus ' >> $(TARGET).pde
	echo 'extern "C" {' >> $(TARGET).pde
	echo '#endif' >> $(TARGET).pde
	echo '' >> $(TARGET).pde	
	echo '#include "some_c_header_placed_in_same_directory.h"' >> $(TARGET).pde
	echo '' >> $(TARGET).pde	
	echo '#ifdef __cplusplus ' >> $(TARGET).pde
	echo '}' >> $(TARGET).pde
	echo '#endif' >> $(TARGET).pde
	echo 'end of example */' >> $(TARGET).pde
	echo '' >> $(TARGET).pde
	echo '/* standard adruino functions */' >> $(TARGET).pde
	echo 'void setup() {' >> $(TARGET).pde
	echo '}//end of setup' >> $(TARGET).pde
	echo '' >> $(TARGET).pde	
	echo 'void loop() {' >> $(TARGET).pde
	echo '}//end of	 loop' >> $(TARGET).pde
	echo '' >> $(TARGET).pde
 
 
.PHONY:	all build elf hex eep lss sym program coff extcoff clean applet_files sizebefore sizeafter mk_applet_dir newproject monitor
 
#include $(SRC:.c=.d)
#include $(CXXSRC:.cpp=.d)

