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

kGccSrcRemoteRepoUrl := https://github.com/gcc-mirror/gcc
kGccSrcRemoteBranchTag := master
kGccSrcLocalDirName := $(basename $(notdir ${kSrcsDir}))_src
kGccSrcLocalPath := ${kBuildDir}/${kGccSrcLocalDirName}

kTarget := $(basename $(notdir ${SW_TARGET_GCC}))
kTargetExec := $(notdir ${SW_TARGET_GCC})
kTargetExecPath := ${kOutputDir}/${kTargetExec}

# Compiler
kCC := ${CROSS_COMPILE:-=}

# cfg before make 
kCfgArgs := \
	${kGccSrcLocalPath}/configure \
	--prefix=${kOutputDir} \
	--build=$(shell uname -m) \
	--enable-crypt \
	--host=${kCC}

################################################################################

kDeps := \
	${kMKUtilitiesPath} 

################################################################################
# Run area below #
################################################################################

.PHONY: \
	all \
	clone_remote_gcc_src \
	clean 
#.NOTPARALLEL:

all: ${kTargetExecPath}
${kTargetExecPath}: ${kDeps} clone_remote_gcc_src 
	$(call InfoPrint,"Start to build gcc")
	mkdir -p ${kBuildDir} ${kOutputDir} 
	cd ${kBuildDir} && ${kCfgArgs}
	${MAKE} -C ${kBuildDir}
	${MAKE} -C ${kBuildDir} install
	$(call InfoPrint,"Build gcc has been completed")

clone_remote_gcc_src:
	$(call InfoPrint,"Check Remote/Local Repository...")
	$(call CloneRemoteRepo,\
		${kGccSrcRemoteRepoUrl},\
		${kGccSrcRemoteBranchTag},\
		${kGccSrcLocalPath},\
	)

clean: 
	$(call InfoPrint,"Clean gcc build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir}
