###
# @file: clone_remote_repo.mk
# @brief: Contain function for clone/pull from remote repo.
# @author: dewei
# @date: 2024-5-18
# @version 0.0.1 
###


###
# @brief: Check whether remote repo. eixis and newest in local.
#
# @param ${1}: URL of remote repo
# @param ${2}: The branch tag of remote repo
# @param ${3}: The path for download to local
###
define CloneRemoteRepo
	if [ ! -d ${3} ]; then \
		echo "Remote repository doesn't exist in local, cloning...";\
		git clone \
		--depth=1 \
		-b ${2} --\
		${1} ${3}; \
	else \
		echo "Remote repository exist in local, check newest..."; \
		cd ${3}; \
		git pull ${1}; \
	fi		
endef
