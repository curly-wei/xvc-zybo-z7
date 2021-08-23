#Color renderning Green
define InfoPrint 
	@$(eval kColorGreen := '\e[1;32m')
	@$(eval kColorEnd := '\e[0m')
	@echo -e $(kColorGreen)"[UserINFO]: "${1}$(kColorEnd)
endef

#Color renderning Red
define ErrorPrint 
	@$(eval kColorRed := '\e[1;31m')
	@$(eval kColorEnd := '\e[0m')
	@echo -e $(kColorGreen)"[UserINFO]: "${1}$(kColorEnd)
endef