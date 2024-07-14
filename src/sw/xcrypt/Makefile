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

KXcryptSrcRemoteRepoUrl := https://github.com/besser82/libxcrypt
KXcryptSrcRemoteBranchTag := master
KXcryptSrcLocalDirName := $(basename $(notdir ${kSrcsDir}))_src
KXcryptSrcLocalPath := ${kBuildDir}/${KXcryptSrcLocalDirName}

kTarget := $(basename $(notdir ${SW_TARGET_XCRYPT}))
kTargetExec := $(notdir ${SW_TARGET_XCRYPT})
kTargetExecPath := ${kOutputDir}/${kTargetExec}

# Compiler
kCC := ${CROSS_COMPILE:-=}

# cfg before make 
kCfgArgs := \
	./configure \
	--prefix=${kOutputDir} \
	--enable-hashes=strong,glibc \
	--enable-obsolete-api=glibc \
	--disable-failure-tokens \
	--host=${kCC}

################################################################################

kDeps := \
	${kMKUtilitiesPath} 

################################################################################
# Run area below #
################################################################################

.PHONY: \
	all \
	clone_remote_xcrypt_src \
	clean 
#.NOTPARALLEL:

all: ${kTargetExecPath}
${kTargetExecPath}: ${kDeps} clone_remote_xcrypt_src 
	$(call InfoPrint,"Start to build xcrypt")
	mkdir -p ${kBuildDir} ${kOutputDir} 
	cd ${KXcryptSrcLocalPath} && ./autogen.sh && ${kCfgArgs}
	${MAKE} -C ${KXcryptSrcLocalPath}
	${MAKE} -C ${KXcryptSrcLocalPath} install
	$(call InfoPrint,"Build xcrypt has been completed")

clone_remote_xcrypt_src:
	$(call InfoPrint,"Check Remote/Local Repository...")
	$(call CloneRemoteRepo,\
		${KXcryptSrcRemoteRepoUrl},\
		${KXcryptSrcRemoteBranchTag},\
		${KXcryptSrcLocalPath},\
	)

clean: 
	$(call InfoPrint,"Clean xcrypt build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir}
