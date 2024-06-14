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

kKernelSrcRemoteRepoUrl := https://github.com/Xilinx/linux-xlnx.git
#kKernelSrcRemoteRepoUrl := https://gitlab.com/linux-kernel/linux
kKernelSrcRemoteBranchTag := master
kKernelSrcLocalDirName := $(basename $(notdir ${kSrcsDir}))_src
kKernelSrcLocalPath := ${kBuildDir}/${kKernelSrcLocalDirName}

kKernelConfName := xilinx_zynq_defconfig
kUImgLoadAddr := 0x8000

kTarget := $(basename $(notdir ${KERNEL_TARGET}))
kTargetExec := $(notdir ${KERNEL_TARGET})
kTargetExecPath := ${kOutputDir}/${kTargetExec}

kUImageGenDir := ${kKernelSrcLocalPath}/arch/arm/boot
kUImageGenFileName := ${kTarget}
kUImageGenPath := ${kUImageGenDir}/${kUImageGenFileName}

################################################################################


kDeps := \
	${kMKUtilitiesPath}

# Compiler
kCC := ${CROSS_COMPILE}
kARCH := ${ARCH}

kBuildArgs := \
	CROSS_COMPILE=${kCC} \
	ARCH=${kARCH} \
	INSTALL_PATH=${kOutputDir}

kMakeUImageArgs := \
	UIMAGE_LOADADDR=${kUImgLoadAddr} \
	${kUImageGenFileName}


################################################################################
# Run area below #
################################################################################

.PHONY: \
	all \
	clone_remote_kernel_src \
	clean 

#.NOTPARALLEL:


all: ${kTargetExecPath}
${kTargetExecPath}: ${kDeps} clone_remote_kernel_src 
	$(call InfoPrint,"Start to build xvc_os_kernel")
	mkdir -p ${kBuildDir} ${kOutputDir} 
	${MAKE} -C ${kKernelSrcLocalPath} ${kBuildArgs} ${kKernelConfName}
	${MAKE} -C ${kKernelSrcLocalPath} ${kBuildArgs}
	${MAKE} -C ${kKernelSrcLocalPath} ${kMakeUImageArgs}
	cp ${kUImageGenPath} ${kTargetExecPath}
	$(call InfoPrint,"Build xvc_os_kernel has been completed")

clone_remote_kernel_src:
	$(call InfoPrint,"Check Remote/Local Repository...")
	$(call CloneRemoteRepo,\
		${kKernelSrcRemoteRepoUrl},\
		${kKernelSrcRemoteBranchTag},\
		${kKernelSrcLocalPath},\
	)


clean:
	$(call InfoPrint,"Clean xvc_os_kernel build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir}
