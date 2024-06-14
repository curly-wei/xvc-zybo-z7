# include utiluty
kUtilitiesTopPath := ${UTILITIES_TOP_DIR}
kMKUtilitiesPath := $(wildcard ${kUtilitiesTopPath}/makefile/*.mk)
include ${kMKUtilitiesPath}

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
kOpensshSrcRemoteBranchTag := master
kOpensshSrcLocalDirName := $(basename $(notdir ${kSrcsDir}))_src
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
	${kMKUtilitiesPath} 


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
	$(call CloneRemoteRepo,\
		${kOpensshSrcRemoteRepoUrl},\
		${kOpensshSrcRemoteBranchTag},\
		${kOpensshSrcLocalPath},\
	)

clean: 
	$(call InfoPrint,"Clean openssh build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir}
