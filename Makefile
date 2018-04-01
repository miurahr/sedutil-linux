.PHONY: all build-dirs linuxpba pbaimage clean

ARCH ?= 64
CC = gcc-4.9
CXX = g++-4.9
ARCHFLAGS = -m$(ARCH)
COMMONFLAGS = $(ARCHFLAGS) -Wall -O2
CFLAGS = $(COMMONFLAGS) -std=c99
CXXFLAGS = $(COMMONFLAGS) -std=c++11

BUILD_DIR = build/$(ARCH)
DIST_DIR = dist/$(ARCH)
SOURCE_DIRS = Common Common/pbkdf2 linux LinuxPBA
INCLUDE_PATHS = $(addprefix -I,$(SOURCE_DIRS))

C_SOURCES = $(foreach SOURCE_DIR,$(SOURCE_DIRS),$(wildcard $(SOURCE_DIR)/*.c))
CXX_SOURCES = $(foreach SOURCE_DIR,$(SOURCE_DIRS),$(wildcard $(SOURCE_DIR)/*.cpp))
C_OBJECTS = $(patsubst %.c,%.o,$(addprefix $(BUILD_DIR)/,$(C_SOURCES)))
CXX_OBJECTS = $(patsubst %.cpp,%.o,$(addprefix $(BUILD_DIR)/,$(CXX_SOURCES)))
OBJECTS = $(C_OBJECTS) $(CXX_OBJECTS)

ifeq ($(ARCH),64)
	PBAIMAGE_SRC = $(wildcard UEFI64-*.img)
	PBAIMAGE_ROOTFS_PATH = EFI/boot/rootfs.cpio.xz
else
	PBAIMAGE_SRC = $(wildcard BIOS32-*.img)
	PBAIMAGE_ROOTFS_PATH = boot/extlinux/rootfs.cpio.xz
endif
PBAIMAGE_DEST = $(patsubst %,patched-%,$(PBAIMAGE_SRC))


all: linuxpba

build-dirs:
	mkdir -p $(addprefix $(BUILD_DIR)/,$(SOURCE_DIRS))
	mkdir -p $(DIST_DIR)

linuxpba: $(DIST_DIR)/linuxpba

$(DIST_DIR)/linuxpba: build-dirs $(OBJECTS)
	$(CXX) $(ARCHFLAGS) $(OBJECTS) -o $@

$(CXX_OBJECTS): $(BUILD_DIR)/%.o : %.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDE_PATHS) -c $< -o $@

$(C_OBJECTS): $(BUILD_DIR)/%.o : %.c
	$(CC) $(CFLAGS) $(INCLUDE_PATHS) -c $< -o $@


pbaimage: linuxpba
	cp $(PBAIMAGE_SRC) $(PBAIMAGE_DEST)
	mkdir -p tmp/img-mnt
	sudo mount -o loop,rw,offset=1048576 $(PBAIMAGE_DEST) tmp/img-mnt
	cp tmp/img-mnt/$(PBAIMAGE_ROOTFS_PATH) tmp

	mkdir -p tmp/root
	xz -d tmp/rootfs.cpio.xz
	cd tmp/root && sudo cpio -idm < ../rootfs.cpio
	sudo cp $(DIST_DIR)/linuxpba tmp/root/sbin
	sudo chown root:root tmp/root
	cd tmp/root && cpio -t < ../rootfs.cpio | sudo cpio -o -H newc | xz -9 -C crc32 > ../new-rootfs.cpio.xz

	sudo cp tmp/new-rootfs.cpio.xz tmp/img-mnt/$(PBAIMAGE_ROOTFS_PATH)
	sudo umount tmp/img-mnt


clean:
	rm -rf build/ dist/ tmp/ patched-*.img
