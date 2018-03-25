.PHONY: all build-dirs linuxpba pbaimage clean

ARCH ?= 64
CC = gcc
CXX = g++
CFLAGS = -m$(ARCH) -Wall -O2
CXXFLAGS = $(CFLAGS) -std=c++11
ifeq ($(ARCH),64)
	PBAIMAGE = UEFI64
else
	PBAIMAGE = BIOS32
endif

BUILD_DIR = build/$(ARCH)
DIST_DIR = dist/$(ARCH)
SOURCE_DIRS = Common Common/pbkdf2 linux LinuxPBA
INCLUDE_PATHS = $(addprefix -I,$(SOURCE_DIRS))

C_SOURCES = $(foreach SOURCE_DIR,$(SOURCE_DIRS),$(wildcard $(SOURCE_DIR)/*.c))
CXX_SOURCES = $(foreach SOURCE_DIR,$(SOURCE_DIRS),$(wildcard $(SOURCE_DIR)/*.cpp))
C_OBJECTS = $(patsubst %.c,%.o,$(addprefix $(BUILD_DIR)/,$(C_SOURCES)))
CXX_OBJECTS = $(patsubst %.cpp,%.o,$(addprefix $(BUILD_DIR)/,$(CXX_SOURCES)))
OBJECTS = $(C_OBJECTS) $(CXX_OBJECTS)


all: linuxpba

build-dirs:
	mkdir -p $(addprefix $(BUILD_DIR)/,$(SOURCE_DIRS))
	mkdir -p $(DIST_DIR)

linuxpba: $(DIST_DIR)/linuxpba

$(DIST_DIR)/linuxpba: build-dirs $(OBJECTS)
	$(CXX) $(OBJECTS) -o $@

$(CXX_OBJECTS): $(BUILD_DIR)/%.o : %.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDE_PATHS) -c $< -o $@

$(C_OBJECTS): $(BUILD_DIR)/%.o : %.c
	$(CC) $(CFLAGS) $(INCLUDE_PATHS) -c $< -o $@


pbaimage: linuxpba
	echo "not implemented"


clean:
	rm -rf build/ dist/ *-patched.img
