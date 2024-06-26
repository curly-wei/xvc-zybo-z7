# https://wiki.beyondlogic.org/index.php?title=Cross_Compiling_BusyBox_for_ARM#DropBear_.28Optional.29
# ./configure --prefix=`pwd`/out --host=arm-linux-gnueabihf --with-zlib=../zlib/out  

kUtilitiesTopPath := ${UTILITIES_TOP_DIR}
kMKUtilitiesPath := $(wildcard ${kUtilitiesTopPath}/makefile/*.mk)
include ${kMKUtilitiesPath}
# include utiluty

# I/O/B dir
kSrcsDir := $(shell pwd)
kBuildDir := ${BUILD_DIR}
kOutputDir := ${OUTPUT_DIR}

################################################################################
########################
## Please cheack here ##
########################
kZLibSrcsPath := ${ZLIB_SRCS_PATH}

kDropbearSrcRemoteRepoUrl := https://github.com/mkj/dropbear
kDropbearSrcRemoteBranchTag := master
kDropbearSrcLocalDirName := $(basename $(notdir ${kSrcsDir}))_src
kDropbearSrcLocalPath := ${kBuildDir}/${kDropbearSrcLocalDirName}

kTarget := $(basename $(notdir ${SW_TARGET_DROPBEAR}))
kTargetExec := $(notdir ${SW_TARGET_DROPBEAR})
kTargetExecPath := ${kOutputDir}/${kTargetExec}

# Compiler
kCC := ${CROSS_COMPILE:-=}

# cfg before make 
kCfgArgs := \
	${kDropbearSrcLocalPath}/configure \
	--prefix=${kOutputDir} \
	--with-zlib=${kZLibSrcsPath} \
	--host=${kCC}

################################################################################

kDeps := \
	${kMKUtilitiesPath} 

################################################################################
# Run area below #
################################################################################

.PHONY: \
	all \
	clone_remote_dropbear_src \
	clean 
#.NOTPARALLEL:


all: ${kTargetExecPath}
${kTargetExecPath}: ${kDeps} clone_remote_dropbear_src 
	$(call InfoPrint,"Start to build dropbear")
	mkdir -p ${kBuildDir} ${kOutputDir} 
	cd ${kBuildDir} && ${kCfgArgs}
	${MAKE} -C ${kBuildDir}
	${MAKE} -C ${kBuildDir} install
	$(call InfoPrint,"Build dropbear has been completed")


clone_remote_dropbear_src:
	$(call InfoPrint,"Check Remote/Local Repository...")
	$(call CloneRemoteRepo,\
		${kDropbearSrcRemoteRepoUrl},\
		${kDropbearSrcRemoteBranchTag},\
		${kDropbearSrcLocalPath},\
	)

clean: 
	$(call InfoPrint,"Clean dropbear build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir}
