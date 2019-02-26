#
# Atari800 port on PSP
#
# Copyright (C) 2009 Ludovic Jacomme (ludovic.jacomme@gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
CHAINPREFIX := /opt/mipsel-linux-uclibc
CROSS_COMPILE := $(CHAINPREFIX)/usr/bin/mipsel-linux-

CC = $(CROSS_COMPILE)gcc
CXX = $(CROSS_COMPILE)g++
STRIP = $(CROSS_COMPILE)strip

SYSROOT     := $(shell $(CC) --print-sysroot)

SDL_CONFIG = $(SYSROOT)/usr/bin/sdl-config

ATARI_VERSION	= 1.1.0
TARGET			= ./dingux-atari/dingux-atari.dge

OBJS = 	./src/gp2x_psp.o \
		./src/antic.o \
		./src/atari.o \
		./src/atari_sdl.o \
		./src/binload.o \
		./src/cartridge.o \
		./src/cassette.o \
		./src/colours.o \
		./src/compfile.o \
		./src/cpu.o \
		./src/cycle_map.o \
		./src/devices.o \
		./src/gtia.o \
		./src/input.o \
		./src/log.o \
		./src/memory.o \
		./src/monitor.o \
		./src/pbi.o \
		./src/pia.o \
		./src/pokey.o \
		./src/pokeysnd.o \
		./src/remez.o \
		./src/rtime.o \
		./src/screen.o \
		./src/sio.o \
		./src/statesav.o \
		./src/ui_basic.o \
		./src/ui.o \
		./src/util.o \
		./src/psp_main.o \
		./src/psp_kbd.o \
		./src/psp_danzeff.o \
		./src/psp_sdl.o \
		./src/psp_font.o \
		./src/psp_fmgr.o \
		./src/psp_menu.o \
		./src/psp_menu_kbd.o \
		./src/psp_menu_set.o \
		./src/psp_menu_help.o \
		./src/miniunz.o \
		./src/ioapi.o \
		./src/unzip.o \
		./src/psp_joy.o \
		./src/psp_menu_cheat.o \
		./src/psp_menu_list.o \
		./src/psp_menu_joy.o \
		./src/psp_editor.o \

DEFAULT_CFLAGS = $(shell $(SDL_CONFIG) --cflags)

MORE_CFLAGS = -I. -I$(SYSROOT)/usr/include \
-DNOCRYPT \
-DGCW0_MODE -DATARI_VERSION=\"$(ATARI_VERSION)\"  \
-mips32 -O3 -D_GNU_SOURCE=1 -D_REENTRANT -DIS_LITTLE_ENDIAN \
-fsigned-char -ffast-math -fomit-frame-pointer \
-fexpensive-optimizations -fno-strength-reduce  \
-funroll-loops  -finline-functions \
-DNO_STDIO_REDIRECT

CFLAGS = $(DEFAULT_CFLAGS) $(MORE_CFLAGS)
LDFLAGS = -s

LIBS += -L$(SYSROOT)/lib \
-lSDL \
-lSDL_image \
-lpng -lz -lm -lpthread -lstdc++ -ldl


.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

.cpp.o:
	$(CXX) $(CFLAGS) -c $< -o $@

all: $(OBJS)
	$(CC) $(LDFLAGS) $(CFLAGS) $(OBJS) $(LIBS) -o $(TARGET) && $(STRIP) $(TARGET)

install: $(TARGET)
	cp $< /media/dingux/local/emulators/dingux-atari/

clean:
	rm -f $(OBJS) $(TARGET)

