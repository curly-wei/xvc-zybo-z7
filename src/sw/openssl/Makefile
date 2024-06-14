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

kOpensslSrcRemoteRepoUrl := https://github.com/openssl/openssl.git 
kOpensslSrcRemoteBranchTag := master
kOpensslSrcLocalDirName := $(basename $(notdir ${kSrcsDir}))_src
kOpensslSrcLocalPath := ${kBuildDir}/${kOpensslSrcLocalDirName}

kTarget := $(basename $(notdir ${SW_TARGET_OPENSSL}))
kTargetExec := $(notdir ${SW_TARGET_OPENSSL})
kTargetExecPath := ${kOutputDir}/${kTargetExec}

# Compiler
kCC := ${CROSS_COMPILE}

# cfg before make 
kCfgArgs := \
	${kOpensslSrcLocalPath}/Configure \
	linux-armv4 \
	shared \
	-march=armv7-a \
	--cross-compile-prefix=${kCC} \
	--prefix=${kOutputDir}

################################################################################

kDeps := \
	${kMKUtilitiesPath} 


################################################################################
# Run area below #
################################################################################

.PHONY: \
	all \
	clone_remote_openssl_src \
	clean 
#.NOTPARALLEL:


all: ${kTargetExecPath}
${kTargetExecPath}: ${kDeps} clone_remote_openssl_src 
	$(call InfoPrint,"Start to build openssl")
	mkdir -p ${kBuildDir} ${kOutputDir} 
	cd ${kBuildDir} && ${kCfgArgs}
	${MAKE} -C ${kBuildDir}
	${MAKE} -C ${kBuildDir} install
	$(call InfoPrint,"Build openssl has been completed")


clone_remote_openssl_src:
	$(call InfoPrint,"Check Remote/Local Repository...")
	$(call CloneRemoteRepo,\
		${kOpensslSrcRemoteRepoUrl},\
		${kOpensslSrcRemoteBranchTag},\
		${kOpensslSrcLocalPath},\
	)

clean: 
	$(call InfoPrint,"Clean openssl build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir}
