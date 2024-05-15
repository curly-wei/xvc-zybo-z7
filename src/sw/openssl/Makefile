# ./openssl/config linux-armv4 shared -march=armv7-a --cross-compile-prefix=arm-linux-gnueabihf- --prefix=`pwd`/out  
# git clone  https://github.com/openssl/openssl.git 

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
	${kMKUtilitiesTopPath} 


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
	@if [ ! -d ${kOpensslSrcLocalPath} ]; then \
		echo "Remote repository doesn't exist in local, cloning...";\
		git clone \
		--depth=1 \
		--branch=${kOpensslSrcRemoteBranchTag} \
		${kOpensslSrcRemoteRepoUrl} ${kOpensslSrcLocalPath}; \
	else \
		echo "Remote repository exist in local, check newest..."; \
		cd ${kOpensslSrcLocalPath}; \
		git pull ${kOpensslSrcRemoteRepoUrl}; \
	fi	

clean: 
	$(call InfoPrint,"Clean openssl build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir}
