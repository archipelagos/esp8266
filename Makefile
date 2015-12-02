# INFO: https://blog.cesanta.com/esp8266-gdb

include mk/config.mk
include mk/internal.mk
include mk/download.mk
include mk/examples.mk
include mk/flash.mk
include mk/root.mk

test:
	echo \
		$(FLASH_EXAMPLE_ID_LIST)

$(FLASH_RULE_LIST): \
		$(FLASH_RULE_PREFIX)_%: \
		$(INTERNAL_EXAMPLES_DIR)/%/$(EXAMPLES_TARGET_LOWER_FILE)
	make \
		flash \
		-C \
		$(INTERNAL_EXAMPLES_DIR)/$* \
		ESPPORT=/dev/ttyUSB0

$(EXAMPLES_RULE_LIST): \
		$(EXAMPLES_RULE_PREFIX)_%: \
		$(INTERNAL_EXAMPLES_DIR)/%/$(EXAMPLES_TARGET_LOWER_FILE)

$(EXAMPLES_TARGET_FILE_LIST): \
		%/$(EXAMPLES_TARGET_LOWER_FILE): \
		$(INTERNAL_TOOLCHAIN_BIN_DIR) \
		$(INTERNAL_RTOS_SRC_DIR)
	cd \
		$* && \
		export \
			PATH=$(ROOT_DIR)/$(INTERNAL_TOOLCHAIN_BIN_DIR):$(PATH) && \
			make

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

clean: \
		clean_$(INTERNAL_SRC_DIR)

clean_$(INTERNAL_SRC_DIR): \
		clean_%:
	echo rm \
		-rf \
		$*

