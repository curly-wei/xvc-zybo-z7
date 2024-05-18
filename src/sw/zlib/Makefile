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

kZlibSrcRemoteRepoUrl := https://github.com/madler/zlib
kZlibSrcRemoteBranchTag := master
kZlibSrcLocalDirName := $(basename $(notdir ${kSrcsDir}))_src
kZlibSrcLocalPath := ${kBuildDir}/${kZlibSrcLocalDirName}


kTarget := $(basename $(notdir ${SW_TARGET_ZLIB}))
kTargetExec := $(notdir ${SW_TARGET_ZLIB})
kTargetExecPath := ${kOutputDir}/${kTargetExec}

# Compiler
kCC := ${CROSS_COMPILE}

# cfg before make 
kCfgArgs := \
	CROSS_PREFIX=${kCC} \
	${kZlibSrcLocalPath}/configure \
	--prefix=${kOutputDir} #--static

################################################################################

kDeps := \
	${kMKUtilitiesTopPath} 

################################################################################
# Run area below #
################################################################################

.PHONY: \
	all \
	clone_remote_zlib_src \
	clean 
#.NOTPARALLEL:

all: ${kTargetExecPath}
${kTargetExecPath}: ${kDeps} clone_remote_zlib_src 
	echo ${kTargetExecPath}
	$(call InfoPrint,"Start to build zlib")
	mkdir -p ${kBuildDir} ${kOutputDir} 
	cd ${kBuildDir} && ${kCfgArgs}
	${MAKE} -C ${kBuildDir}
	${MAKE} -C ${kBuildDir} install
	$(call InfoPrint,"Build zlib has been completed")

clone_remote_zlib_src:
	$(call InfoPrint,"Check Remote/Local Repository...")
	@if [ ! -d ${kZlibSrcLocalPath} ]; then \
		echo "Remote repository doesn't exist in local, cloning...";\
		git clone \
		--depth=1 \
		--branch=${kZlibSrcRemoteBranchTag} \
		${kZlibSrcRemoteRepoUrl} ${kZlibSrcLocalPath}; \
	else \
		echo "Remote repository exist in local, check newest..."; \
		cd ${kZlibSrcLocalPath}; \
		git pull ${kZlibSrcRemoteRepoUrl}; \
	fi	

clean: 
	$(call InfoPrint,"Clean zlib build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir}






# https://stackoverflow.com/questions/53885273/cross-compile-zlib-for-arm



