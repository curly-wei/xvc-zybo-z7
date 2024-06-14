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

kGlibcSrcRemoteRepoUrl := https://github.com/bminor/glibc
kGlibcSrcRemoteBranchTag := master
kGlibcSrcLocalDirName := $(basename $(notdir ${kSrcsDir}))_src
kGlibcSrcLocalPath := ${kBuildDir}/${kGlibcSrcLocalDirName}

kTarget := $(basename $(notdir ${SW_TARGET_GLIBC}))
kTargetExec := $(notdir ${SW_TARGET_GLIBC})
kTargetExecPath := ${kOutputDir}/${kTargetExec}

# Compiler
kCC := ${CROSS_COMPILE:-=}

# cfg before make 
kCfgArgs := \
	${kGlibcSrcLocalPath}/configure \
	--prefix=${kOutputDir} \
	--build=$(shell uname -m) \
	--host=${kCC}

################################################################################

kDeps := \
	${kMKUtilitiesPath} 

################################################################################
# Run area below #
################################################################################

.PHONY: \
	all \
	clone_remote_glibc_src \
	clean 
#.NOTPARALLEL:

all: ${kTargetExecPath}
${kTargetExecPath}: ${kDeps} clone_remote_glibc_src 
	$(call InfoPrint,"Start to build glibc")
	mkdir -p ${kBuildDir} ${kOutputDir} 
	cd ${kBuildDir} && ${kCfgArgs}
	${MAKE} -C ${kBuildDir}
	${MAKE} -C ${kBuildDir} install
	$(call InfoPrint,"Build glibc has been completed")

clone_remote_glibc_src:
	$(call InfoPrint,"Check Remote/Local Repository...")
	$(call CloneRemoteRepo,\
		${kGlibcSrcRemoteRepoUrl},\
		${kGlibcSrcRemoteBranchTag},\
		${kGlibcSrcLocalPath},\
	)

clean: 
	$(call InfoPrint,"Clean glibc build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir}