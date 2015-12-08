# INFO: https://blog.cesanta.com/esp8266-gdb

include mk/config.mk
include mk/internal.mk
include mk/download.mk
include mk/examples.mk
include mk/clean.mk
include mk/flash.mk
include mk/root.mk
include mk/wifi.mk

# TODO: Try OTA - Over-the-air programming.
# TODO: rebuild
# TODO: flash
# TODO: test
# TODO: size
# TODO: TIPS:
# TODO: * You can use -jN for parallel builds. Much faster! Use 'make rebuild' instead of 'make clean all' for parallel builds.
# TODO: * You can create a local.mk file to create local overrides of variables like ESPPORT & ESPBAUD.

all: \
		$(EXAMPLES_RULE_LIST)

$(FLASH_RULE_LIST): \
		$(FLASH_RULE_PREFIX)_%: \
		$(INTERNAL_EXAMPLES_DIR)/%/$(EXAMPLES_TARGET_LOWER_FILE) \
		$(INTERNAL_EXAMPLES_DIR)/%/$(EXAMPLES_TARGET_UPPER_FILE)
	export \
		PATH=$(ROOT_DIR)/$(INTERNAL_TOOLCHAIN_BIN_DIR):$(PATH) && \
	make \
		flash \
		-C \
		$(INTERNAL_EXAMPLES_DIR)/$* \
		ESPPORT=/dev/ttyUSB0

$(WIFI_RULE):
	sed \
		's/^#warning/\/\/#warning/g' \
		-i \
		$(INTERNAL_WIFI_FILE_DIR)
	sed \
		's/\"mywifissid\"/\"aos_devel\"/g' \
		-i \
		$(INTERNAL_WIFI_FILE_DIR)
	sed \
		's/\"my\ secret\ password\"/\"aos_devel\"/g' \
		-i \
		$(INTERNAL_WIFI_FILE_DIR)

$(EXAMPLES_RULE_LIST): \
		$(EXAMPLES_RULE_PREFIX)_%: \
		$(WIFI_RULE) \
		$(INTERNAL_EXAMPLES_DIR)/%/$(EXAMPLES_TARGET_LOWER_FILE) \
		$(INTERNAL_EXAMPLES_DIR)/%/$(EXAMPLES_TARGET_UPPER_FILE)

# TODO: Examples can be built outside the sdk - try it out.
$(EXAMPLES_TARGET_FILE_LIST): \
		%/$(EXAMPLES_TARGET_LOWER_FILE): \
		$(INTERNAL_TOOLCHAIN_BIN_DIR) \
		$(INTERNAL_RTOS_SRC_DIR)
	cd \
		$* && \
		export \
			PATH=$(ROOT_DIR)/$(INTERNAL_TOOLCHAIN_BIN_DIR):$(PATH) && \
			make
# \
#				BUILDDIR=build

#make flash -j4 -C examples/http_get ESPPORT=/dev/ttyUSB0

$(INTERNAL_TOOLCHAIN_BIN_DIR): \
		$(INTERNAL_TOOLCHAIN_SRC_DIR)
	cd \
		$(INTERNAL_TOOLCHAIN_SRC_DIR) && \
		make \
			STANDALONE=y

$(DOWNLOAD_RULE_LIST): \
		$(DOWNLOAD_RULE_PREFIX)_%: \
		$(INTERNAL_SRC_DIR)/%

$(INTERNAL_TOOLCHAIN_SRC_DIR): \
		%:
	git \
		clone \
		--recursive \
		$(INTERNAL_TOOLCHAIN_FULL_URL) \
		$*

$(INTERNAL_RTOS_SRC_DIR): \
		%:
	git \
		clone \
		--recursive \
		$(INTERNAL_RTOS_FULL_URL) \
		$*

$(CLEAN_RULE_PREFIX): \
		$(CLEAN_RULE_PREFIX)_$(INTERNAL_SRC_DIR) \
		$(CLEAN_RULE_LIST)

$(CLEAN_RULE_PREFIX)_$(INTERNAL_SRC_DIR): \
		$(CLEAN_RULE_PREFIX)_%:
	echo rm \
		-rf \
		$*

$(CLEAN_RULE_LIST): \
		$(CLEAN_RULE_PREFIX)_$(EXAMPLES_RULE_PREFIX)_%:
	cd \
		$(INTERNAL_EXAMPLES_DIR)/$* && \
		make \
			$(CLEAN_RULE_PREFIX)

