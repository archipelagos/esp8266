DOWNLOAD_RULE_PREFIX=		download

DOWNLOAD_SOURCE_LIST=		$(CONFIG_TOOLCHAIN_NAME) \
				$(CONFIG_RTOS_NAME)

DOWNLOAD_RULE_LIST=		$(addprefix \
					$(DOWNLOAD_RULE_PREFIX)_, \
					$(DOWNLOAD_SOURCE_LIST))

