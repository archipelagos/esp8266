EXAMPLES_RULE_PREFIX=		example

EXAMPLES_FILE_LIST_COMMAND=	ls \
					$(INTERNAL_EXAMPLES_DIR)

ifneq ($(wildcard $(INTERNAL_EXAMPLES_DIR)), )
EXAMPLES_FILE_LIST=		$(shell \
					$(EXAMPLES_FILE_LIST_COMMAND))
else
EXAMPLES_FILE_LIST=
endif

EXAMPLES_FILTER_OUT_LIST=	$(CONFIG_BUILDSCRIPT_FILE_NAME) \
				experiments \
				tests

EXAMPLES_TARGET_LIST=		$(filter-out \
					$(EXAMPLES_FILTER_OUT_LIST), \
					$(EXAMPLES_FILE_LIST))

EXAMPLES_RULE_LIST=		$(addprefix \
					$(EXAMPLES_RULE_PREFIX)_, \
					$(EXAMPLES_TARGET_LIST))

EXAMPLES_TARGET_ROOT_DIR_LIST=	$(addprefix \
					$(INTERNAL_EXAMPLES_DIR)/, \
					$(EXAMPLES_TARGET_LIST))

EXAMPLES_TARGET_LOWER_FILE=	$(CONFIG_FIRMWARE_DIR_NAME)/$(CONFIG_TARGET_LOWER_FILE_NAME)
EXAMPLES_TARGET_UPPER_FILE=	$(CONFIG_FIRMWARE_DIR_NAME)/$(CONFIG_TARGET_UPPER_FILE_NAME)

EXAMPLES_TARGET_LOWER_FILE_LIST=$(addsuffix \
					/$(EXAMPLES_TARGET_LOWER_FILE), \
					$(EXAMPLES_TARGET_ROOT_DIR_LIST))

EXAMPLES_TARGET_UPPER_FILE_LIST=$(addsuffix \
					/$(EXAMPLES_TARGET_UPPER_FILE), \
					$(EXAMPLES_TARGET_ROOT_DIR_LIST))

