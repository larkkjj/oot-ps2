MIPS			:= mips64r5900el-ps2-elf-
EE_GCC			:= $(MIPS)gcc
BUILD_DIR		:= build/

LIBULTRA_SOURCE		:= $(foreach path,*,$(wildcard $(path)/*.c))
LIBULTRA_OBJECTS	:= $(patsubst %.c,$(BUILD_DIR)/%.o,$(LIBULTRA_SOURCE))
LIBULTRA_STATIC_LIB	:= libultra64.a

INCLUDE			:= -I$(PS2SDK)/ee/include -I$(PS2SDK)/common/include \
			   -I$(PS2SDK)/ports/include -I. -I../../include
LIBRARIES		:= -L$(PS2SDK)/ee/lib -L$(PS2SDK)/ports/lib

FLAGS			:= -D_EE -D__GNU__C -DNON_MATCHING

all: build_lib

clean:
	rm -rf $(LIBULTRA_OBJECTS) $(LIBULTRA_STATIC_LIB)

build_lib: $(LIBULTRA_OBJECTS)
	$(MIPS)ar rcs $(LIBULTRA_STATIC_LIB) $^

$(BUILD_DIR)/%.o: %.c
	@test -d $(@D) || mkdir -p $(@D) || continue;
	$(EE_GCC) $(INCLUDE) $(LIBRARIES) $(FLAGS) -c $< -o $@
