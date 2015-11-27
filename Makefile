# INFO: http://www.jarzebski.pl/blog/kategoria/software.html
# INFO: http://www.nongnu.org/libunwind/
# INFO: https://blog.cesanta.com/esp8266-gdb

CONFIG_LIBRARY_NAME=		esp-open-sdk

CONFIG_REPOSITORY_SERVER=	http://github.com
CONFIG_REPOSITORY_USER=		pfalcon

CONFIG_COMPILER_COMMAND=	g++

CONFIG_BUILDSCRIPT_FILE_NAME=	Makefile

CONFIG_SRC_DIR_NAME=		src
CONFIG_BUILD_DIR_NAME=		build
CONFIG_INSTALL_DIR_NAME=	install

CONFIG_BUILDSCRIPT_FILE=	$(CONFIG_BUILDSCRIPT_FILE_NAME)

CONFIG_SRC_DIR=			$(CONFIG_SRC_DIR_NAME)
CONFIG_BUILD_DIR=		$(CONFIG_BUILD_DIR_NAME)
CONFIG_INSTALL_DIR=		$(CONFIG_INSTALL_DIR_NAME)

CONFIG_REPOSITORY_BASE_URL=	$(CONFIG_REPOSITORY_SERVER)/$(CONFIG_REPOSITORY_USER)
CONFIG_REPOSITORY_LIBRARY_URL=	$(CONFIG_REPOSITORY_BASE_URL)/$(CONFIG_LIBRARY_NAME)

ROOT_DIR=			$(relpath \
					.)

all: \
		$(CONFIG_SRC_DIR)/nodemcu/app/.output

clean: \
		clean_$(CONFIG_SRC_DIR)

clean_$(CONFIG_SRC_DIR): \
		clean_%:
	rm \
		-rf \
		$*

$(CONFIG_SRC_DIR)/$(CONFIG_LIBRARY_NAME): \
		%:
	git \
		clone \
		--recursive \
		$(CONFIG_REPOSITORY_LIBRARY_URL) \
		$*

$(CONFIG_SRC_DIR)/$(CONFIG_LIBRARY_NAME)/xtensa-lx106-elf: \
		$(CONFIG_SRC_DIR)/$(CONFIG_LIBRARY_NAME)
	cd \
		$(CONFIG_SRC_DIR)/$(CONFIG_LIBRARY_NAME) && \
		make \
			STANDALONE=y


$(CONFIG_SRC_DIR)/nodemcu: \
		%:
	git \
		clone \
		--recursive \
		https://github.com/nodemcu/nodemcu-firmware.git \
		$*

$(CONFIG_SRC_DIR)/nodemcu/app/.output: \
		$(CONFIG_SRC_DIR)/nodemcu \
		$(CONFIG_SRC_DIR)/$(CONFIG_LIBRARY_NAME)/xtensa-lx106-elf
	cd \
		$(CONFIG_SRC_DIR)/nodemcu && \
		export \
			PATH=$(realpath .)/$(CONFIG_SRC_DIR)/$(CONFIG_LIBRARY_NAME)/xtensa-lx106-elf/bin:$(PATH) && \
		make 

#tools/esptool.py write_flash -fm dio -fs 32m -ff 40m 0x00000 app/.output/eagle/debug/image/eagle.app.v6.out-0x00000.bin 0x10000 app/.output/eagle/debug/image/eagle.app.v6.out-0x10000.bin
