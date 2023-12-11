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

kUbootSrcRemoteRepoUrl := https://github.com/u-boot/u-boot.git
kUbootSrcRemoteBranchTag := master
kUbootSrcLocalDirName := uboot_src
kUbootSrcLocalPath := ${kBuildDir}/${kUbootSrcLocalDirName}

kUbootConfName := xilinx_zynq_virt_defconfig
kUbootConfDT :=

kTarget := $(basename $(notdir ${UBOOT_TARGET}))
kTargetExec := $(notdir ${UBOOT_TARGET})
kTargetExecPath := ${kOutputDir}/${kTargetExec}

kUbootGenDir := ${kUbootSrcLocalPath}
kUbootGenFileName := ${kTarget}
kUbootGenFilePath := ${kUbootGenDir}/${kUbootGenFileName}

################################################################################

kMKUtilitiesTopPath := ${kUtilitiesTopPath}/makefile
kDeps := \
	${kMKUtilitiesTopPath}

# Compiler
kCC := ${CROSS_COMPILE}
kARCH := ${ARCH}

kBuildArgs := \
	CROSS_COMPILE=${kCC} \
	ARCH=${kARCH}

################################################################################
# Run area below #
################################################################################

.PHONY: \
	all \
	clone_remote_uboot_src \
	clean 

.NOTPARALLEL:

all: ${kTargetExecPath}
${kTargetExecPath}: ${kDeps} clone_remote_uboot_src 
	$(call InfoPrint,"Start to build uboot")
	mkdir -p ${kBuildDir} ${kOutputDir} 
	${MAKE} -C ${kUbootSrcLocalPath} ${kUbootConfName}
	${MAKE} -C ${kUbootSrcLocalPath} ${kBuildArgs}
	cp ${kUbootGenFilePath} ${kTargetExecPath}
	$(call InfoPrint,"Build xvc_os_uboot has been completed")

clone_remote_uboot_src:
	$(call InfoPrint,"Check Remote/Local Repository...")
	@if [ ! -d ${kUbootSrcLocalPath} ]; then \
		echo "Remote repository doesn't exist in local, cloning...";\
		git clone \
		--depth=1 \
		--branch=${kUbootSrcRemoteBranchTag} \
		${kUbootSrcRemoteRepoUrl} ${kUbootSrcLocalPath}; \
	else \
		echo "Remote repository exist in local, check newest..."; \
		cd ${kUbootSrcLocalPath}; \
		git pull ${kUbootSrcRemoteRepoUrl}; \
	fi	

clean: 
	$(call InfoPrint,"Clean xvc_os_uboot build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir}

