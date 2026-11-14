# YEEWARE GameCube  ->  make  ->  YEEWARE.dol  (abra no Dolphin ou no Swiss/Wii)
ifeq ($(strip $(DEVKITPRO)),)
$(error "DEVKITPRO nao definido (use a imagem devkitpro/devkitppc)")
endif
DEVKITPPC ?= $(DEVKITPRO)/devkitPPC
PREFIX := $(DEVKITPPC)/bin/powerpc-eabi-
CC     := $(PREFIX)gcc
ELF2DOL := $(DEVKITPRO)/tools/bin/elf2dol

MACHDEP := -DGEKKO -mogc -mcpu=750 -meabi -mhard-float
CFLAGS  := -O2 -Wall -std=gnu99 $(MACHDEP) -I$(DEVKITPRO)/libogc/include -Isrc
LDFLAGS := -g $(MACHDEP)
LIBS    := -L$(DEVKITPRO)/libogc/lib/cube -lasnd -logc -lm

OBJS := src/main_gc.o src/game.o src/font.o src/music.o

all: YEEWARE.dol

YEEWARE.dol: YEEWARE.elf
	$(ELF2DOL) $< $@

YEEWARE.elf: $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) $(LIBS) -o $@

src/%.o: src/%.c src/game.h
	$(CC) $(CFLAGS) -c $< -o $@

src/music.o: src/music.S data/BOSS.RAW
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) YEEWARE.elf YEEWARE.dol
