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

kKernelSrcRemoteRepoUrl := https://github.com/Xilinx/linux-xlnx.git 
kKernelSrcRemoteBranchTag := master
kKernelSrcLocalDirName := kernel_src
kKernelSrcLocalPath := ${kBuildDir}/${kKernelSrcLocalDirName}

kKernelConfName := xilinx_zynq_defconfig
kUImgLoadAddr := 0x8000

kUImageGenDir := ${kKernelSrcLocalPath}/arch/arm/boot/
kUImageFileName := uImage
kUImageGenPath := ${kUImageGenDir}/${kUImageFileName}
################################################################################

kTarget := $(basename $(notdir ${KERNEL_TARGET}))
kTargetPath := ${kOutputDir}/${kTarget}

kDeps := \
	${kTCLUtilitiesTopPath}

# Compiler
kCC := ${CROSS_COMPILE}
kARCH := ${ARCH}

kBuildArgs := \
	CROSS_COMPILE=${kCC} \
	ARCH=${kARCH} \
	INSTALL_PATH=${kOutputDir}

kMakeUImageArgs := \
	UIMAGE_LOADADDR=${kUImgLoadAddr} \
	${kUImageFileName}

all: | start_msg init_dir  build_kernel end_msg

build_kernel: ${kTargetPath} 
${kTargetPath}: ${kDeps} clone_remote_kernel_src
	${MAKE} -C ${kKernelSrcLocalPath} ${kKernelConfName}
	${MAKE} -C ${kKernelSrcLocalPath} ${kBuildArgs}
	${MAKE} -C ${kKernelSrcLocalPath} ${kMakeUImageArgs}
	cp ${kUImageGenPath} ${kOutputDir}

clone_remote_kernel_src:
	$(call InfoPrint,"Check Remote repository...")
	@if [ ! -d ${kKernelSrcLocalPath} ]; then \
		echo "Remote repository doesn't exist in local, cloning...";\
		git clone \
		--depth=1 \
		--branch=${kKernelSrcRemoteBranchTag} \
		${kKernelSrcRemoteRepoUrl} ${kKernelSrcLocalPath}; \
	else \
		echo "Remote repository exist in local, check newest..."; \
		cd ${kKernelSrcLocalPath}; \
		git pull ${kKernelSrcRemoteRepoUrl}; \
	fi	

init_dir:
	mkdir -p ${kBuildDir} ${kOutputDir} 

start_msg:
	$(call InfoPrint,"Start to build kernel")

end_msg: 
	$(call InfoPrint,"Build kernel has completed")

clean: 
	$(call InfoPrint,"Clean kernel build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir}

.PHONY: \
	all \
	init_dir \
	clone_remote_kernel_src \
	build_kernel \
	clean \
	start_msg \
	end_msg 
