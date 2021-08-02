#Color renderning Green
define GPrint 
	@$(eval kColorGreen := '\e[0;32m')
	@$(eval kColorEnd := '\e[0m')
	@echo -e $(kColorGreen)${1}$(kColorEnd)
endef

#Color renderning Red
define RPrint 
	@$(eval kColorRed := '\e[0;31m')
	@$(eval kColorEnd := '\e[0m')
	@echo -e $(kColorGreen)${1}$(kColorEnd)
endef