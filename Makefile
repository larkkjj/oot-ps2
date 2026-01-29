MIPS		:= mips64r5900el-ps2-elf-
EE_GCC		:= $(MIPS)gcc
EE_CPP		:= $(MIPS)gcc -E

N64		?= 0
VERSION		:= ps2-ntsc-1.2
ZELDA_BINARY	:= zelda-oot-$(VERSION).ELF
EXTRACTED_DIR	:= extracted/$(VERSION)
BUILD_DIR	:= build/$(VERSION)
BUILD_DIR_REPLACE := sed -e 's|$$(BUILD_DIR)|$(BUILD_DIR)|g'
INCS		:= -I. -Iinclude -Iassets -Iinclude/libc -Isrc -I$(BUILD_DIR) -I. -I$(EXTRACTED_DIR)

# Add Zelda64 subfolder here#
# Remember to link lib as static libraries
# Not adding them in $(ZELDA_SRC), src/code
# must be here too, but not in the moment
# since we're remounting the OG makefile

ZELDA_FOLDERS	+= src/elf_message \
		   src/dmadata \
		   src/boot \
		   src/buffers \
		   src/n64dd \

ZELDA_SOURCE	:= $(foreach files,$(ZELDA_FOLDERS),$(wildcard $(files)/*.c))

ZELDA_SRC_OBJS	:= $(patsubst %.c,$(BUILD_DIR)/%.o,$(ZELDA_SOURCE))
# These flags are passed to our code, there
# are ALOT there are just the explicit ones
ifeq ($(VERSION),ps2-ntsc-1.2)
	OOT_FLAGS	+= -DOOT_VERSION=NTSC_1_2
	OOT_FLAGS	+= -DOOT_REGION=REGION_US

	OOT_FLAGS	+= -DPLATFORM_N64=0 -DPLATFORM_GC=0\
		   -DPLATFORM_IQUE=0
endif

FLAGS		+= -DMML_VERSION=MML_VERSION_OOT \
		   -DNON_MATCHING -DDEBUG_FEATURES=1 \
		   -DCOMPILER_GCC -DBUILD_CREATOR=\"A\" \
		   -DBUILD_DATE=\"00-00-00\" -DBUILD_TIME=\"00:00\" \

COMPILER_FLAGS	+= -nostdinc
SPEC_INCLUDES := $(wildcard spec/*.inc)

all: assets $(BUILD_DIR)/spec $(ZELDA_BINARY)

assets:
	@echo nothing :p

$(BUILD_DIR)/%.o: %.c
	@test -d $(@D) || mkdir -p $(@D) || continue;
	$(EE_GCC) $(COMPILER_FLAGS) $(OOT_FLAGS) $(INCS) $(FLAGS) -c $^ -o $@

$(BUILD_DIR)/spec: spec/spec $(SPEC_INCLUDES)
	$(EE_CPP) -P -xc -fno-dollars-in-identifiers $(OOT_FLAGS) -MD -MP -MF $@.d -MT $@ -I. $< | $(BUILD_DIR_REPLACE) > $@

$(ZELDA_BINARY): $(ZELDA_SRC_OBJS)
	$(EE_GCC) -Lsrc/libultra -lultra64 $^ -o $@

clean:
	rm -rf $(ZELDA_SRC_OBJS)

