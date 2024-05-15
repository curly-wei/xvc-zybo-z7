# autoreconf
#./configure --host=arm-linux-gnueabihf --with-zlib=../../zlib/out --with-ssl-dir=../../openssh/out --prefix=`pwd`/out --disable-strip 
# git clone https://github.com/openssh/openssh-portable  


# include utiluty
kUtilitiesTopPath = ${UTILITIES_TOP_DIR}

include ${kUtilitiesTopPath}/makefile/color_printer.mk

# I/O/B dir
kSrcsDir := $(shell pwd)
kBuildDir := ${BUILD_DIR}
kOutputDir := ${OUTPUT_DIR}

################################################################################
########################
## Please cheack here ##
########################

kZLibSrcsPath := ${ZLIB_SRCS_PATH}
kOpensslSrcsPath := ${OPENSSL_SRCS_PATH}

kOpensshSrcRemoteRepoUrl := https://github.com/openssh/openssh-portable
kOpensshSrcRemoteBranchTag := $(basename $(notdir ${kSrcsDir}))_src
kOpensshSrcLocalDirName := openssh_src
kOpensshSrcLocalPath := ${kBuildDir}/${kOpensshSrcLocalDirName}

kTarget := $(basename $(notdir ${SW_TARGET_OPENSSL}))
kTargetExec := $(notdir ${SW_TARGET_OPENSSL})
kTargetExecPath := ${kOutputDir}/${kTargetExec}

# Compiler
kCC := ${CROSS_COMPILE:-=}

# cfg before make 
kCfgArgs := \
	./configure \
	--host=${kCC} \
	--disable-strip \
	--disable-etc-default-login \
	--with-zlib=${kZLibSrcsPath} \
	--with-ssl-dir=${kOpensslSrcsPath} \
	--prefix=${kOutputDir}

################################################################################

kDeps := \
	${kMKUtilitiesTopPath} 


################################################################################
# Run area below #
################################################################################

.PHONY: \
	all \
	clone_remote_openssh_src \
	clean 
#.NOTPARALLEL:


all: ${kTargetExecPath}
${kTargetExecPath}: ${kDeps} clone_remote_openssh_src 
	$(call InfoPrint,"Start to build openssh")
	mkdir -p ${kBuildDir} ${kOutputDir} 
	cd ${kOpensshSrcLocalPath} && autoreconf && ${kCfgArgs}
	${MAKE} -C ${kOpensshSrcLocalPath}
	${MAKE} -C ${kOpensshSrcLocalPath} install-nokeys 
	$(call InfoPrint,"Build openssh has been completed")


clone_remote_openssh_src:
	$(call InfoPrint,"Check Remote/Local Repository...")
	@if [ ! -d ${kOpensshSrcLocalPath} ]; then \
		echo "Remote repository doesn't exist in local, cloning...";\
		git clone \
		--depth=1 \
		--branch=${kOpensshSrcRemoteBranchTag} \
		${kOpensshSrcRemoteRepoUrl} ${kOpensshSrcLocalPath}; \
	else \
		echo "Remote repository exist in local, check newest..."; \
		cd ${kOpensshSrcLocalPath}; \
		git pull ${kOpensshSrcRemoteRepoUrl}; \
	fi	

clean: 
	$(call InfoPrint,"Clean openssh build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir}
