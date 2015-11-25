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
		$(CONFIG_BUILD_DIR)/$(CONFIG_BUILDSCRIPT_FILE)

clean: \
		clean_$(CONFIG_SRC_DIR) \
		clean_$(CONFIG_BUILD_DIR) \
		clean_$(CONFIG_INSTALL_DIR)

clean_$(CONFIG_SRC_DIR): \
		clean_%:
	rm \
		-rf \
		$*

clean_$(CONFIG_BUILD_DIR): \
		clean_%:
	rm \
		-rf \
		$*

clean_$(CONFIG_INSTALL_DIR): \
		clean_%:
	rm \
		-rf \
		$*


$(CONFIG_SRC_DIR): \
		%:
	git \
		clone \
		$(CONFIG_REPOSITORY_LIBRARY_URL) \
		$*

$(CONFIG_BUILD_DIR): \
		%:
	mkdir \
		-p \
		$*

$(CONFIG_INSTALL_DIR): \
		%:
	mkdir \
		-p \
		$*

$(CONFIG_BUILD_DIR)/$(CONFIG_BUILDSCRIPT_FILE): | \
		$(CONFIG_SRC_DIR) \
		$(CONFIG_BUILD_DIR) \
		$(CONFIG_INSTALL_DIR)
	cd \
		$(CONFIG_SRC_DIR) && \
		make \
			STANDALONE=y
