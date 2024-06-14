###
# @file: Color renderning from the input string.
# @brief: Contain function for clone/pull from remote repo.
# @author: dewei
# @date: 2024-5-18
# @version 0.0.1 
###


###
# @brief: Color renderning Green(info) and output to stdout
# @param ${1}: Input string
###
define InfoPrint 
	@$(eval kColorGreen := '\e[1;32m')
	@$(eval kColorEnd := '\e[0m')
	@echo -e $(kColorGreen)"[UserInfoMake]: "${1}$(kColorEnd)
endef

###
# @brief: Color renderning red(error) and output to stderr
# @param ${1}: Input string
###
define ErrorPrint 
	@$(eval kColorRed := '\e[1;31m')
	@$(eval kColorEnd := '\e[0m')
	@echo -e $(kColorGreen)"[UserErrorMake]: "${1}$(kColorEnd) >&2
endef