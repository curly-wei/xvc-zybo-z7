PROJ_ROOT_DIR ?= $(shell realpath `pwd`/../../)

# include utiluty
UTILITIES_TOP_DIR ?= $(shell realpath ${PROJ_ROOT_DIR}/src/utilities)
kUtilitiesTopPath := ${UTILITIES_TOP_DIR}
include ${kUtilitiesTopPath}/makefile/color_printer.mk


#########################################################
      # Necessary properities, please check #
#########################################################

# I/O/B dir global (full project on parent)
PROJ_BUILD_DIR ?= ${PROJ_ROOT_DIR}/build
PROJ_OUTPUT_DIR ?= ${PROJ_BUILD_DIR}/out
# Compiler ant its features
VIVADO_CLI ?= vivado
XSCT_CLI ?= xsct
CROSS_COMPILE ?= arm-linux-gnueabihf-
ARCH ?= arm

#########################################################

# I/O/B local (for os)
kBuildDirOs := ${PROJ_BUILD_DIR}/os
kOutDirOs := ${PROJ_OUTPUT_DIR}/os
kSrcDirOs := $(shell pwd)

# Compiler and its env. for vivado and vitis
kVIVADO := ${VIVADO_CLI}
kXSCT := ${XSCT_CLI}

# Compiler and its env. for cross-compile
kCC := ${CROSS_COMPILE}
kArch := ${ARCH}

# Build Dir
kBuildDirOsBootimg := ${kBuildDirOs}/bootimg
kBuildDirOsHw := ${kBuildDirOs}/build_hw
kBuildDirOsFSBL := ${kBuildDirOs}/build_fsbl
kBuildDirOsUboot := ${kBuildDirOs}/build_uboot
kBuildDirOsDT := ${kBuildDirOs}/build_dt
kBuildDirOsKernel := ${kBuildDirOs}/build_kernel

# Output Dir
kOutDirOsBootimg  := ${kOutDirOs}/bootimg
kOutDirOsHw := ${kOutDirOs}/hw
kOutDirOsFSBL := ${kOutDirOs}/fsbl
kOutDirOsUboot := ${kOutDirOs}/uboot
kOutDirOsDT := ${kOutDirOs}/dt
kOutDirOsKernel := ${kOutDirOs}/kernel

##################################################################

#########################
# property for bootimg #
########################
kBootimgTarget := boot.bin
kBootimgTargetPath := ${kOutDirOsBootimg}/${kBootimgTarget}

kBootimgBuildScriptDir := ${kSrcDirOs}/bootimg
kBootimgBuildArgs := \
	BOOTIMG_TARGET=${kBootimgTargetPath} \
	BUILD_DIR=${kBuildDirOsBootimg} \
	OUTPUT_DIR=${kOutDirOsBootimg} \
	FSBL_SRCS_PATH=${kFSBLTargetPath} \
	XSA_SRC_PATH=${kHwTargetPath} \
	UBOOT_SRCS_PATH=${kUbootTargetPath} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath}

#########################
# property for build hw #
#########################
kHwTarget := xvc_server_hw.xsa
kHwTargetPath := ${kOutDirOsHw}/${kHwTarget}

kHwBuildScriptDir := ${kSrcDirOs}/hw
kHwBuildArgs := \
	HW_TARGET=${kHwTargetPath} \
	BUILD_DIR=${kBuildDirOsHw} \
	OUTPUT_DIR=${kOutDirOsHw} \
	VIVADO_CLI=${kVIVADO} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath} 

###########################
# property for build fsbl #
###########################
kFSBLTarget := fsbl.elf
kFSBLTargetPath := ${kOutDirOsFSBL}/${kFSBLTarget}

kFSBLBuildScriptDir := ${kSrcDirOs}/fsbl
kFSBLBuildArgs := \
	FSBL_TARGET=${kFSBLTargetPath} \
	BUILD_DIR=${kBuildDirOsFSBL} \
	OUTPUT_DIR=${kOutDirOsFSBL} \
	XSCT_CLI=${kXSCT} \
	XSA_SRC_PATH=${kHwTargetPath} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath} 

#############################
# property for build Uboot #
#############################
kUbootTarget := u-boot.elf
kUbootTargetPath := ${kOutDirOsUboot}/${kUbootTarget}

kUbootBuildScriptDir := ${kSrcDirOs}/uboot
kUbootlBuildArgs := \
	UBOOT_TARGET=${kUbootTargetPath} \
	BUILD_DIR=${kBuildDirOsUboot} \
	OUTPUT_DIR=${kOutDirOsUboot} \
	CROSS_COMPILE=${kCC} \
	ARCH=${kArch} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath} 

#########################
# property for build dt #
#########################
kDTTarget := devicetree.dtb
kDTTargetPath := ${kOutDirOsDT}/${kDTTarget}

kDTBuildScriptDir := ${kSrcDirOs}/dt
kDTBuildArgs := \
	DT_TARGET=${kDTTargetPath} \
	BUILD_DIR=${kBuildDirOsDT} \
	OUTPUT_DIR=${kOutDirOsDT} \
	XSCT_CLI=${kXSCT} \
	XSA_SRC_PATH=${kHwTargetPath} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath} 

#############################
# property for build kernel #
#############################
kKernelTarget := uImage.bin
kKernelTargetPath := ${kOutDirOsKernel}/${kKernelTarget}

kKernelBuildScriptDir := ${kSrcDirOs}/kernel
kKernelBuildArgs := \
	KERNEL_TARGET=${kKernelTargetPath} \
	BUILD_DIR=${kBuildDirOsKernel} \
	OUTPUT_DIR=${kOutDirOsKernel} \
	CROSS_COMPILE=${kCC} \
	ARCH=${kArch} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath}


.PHONY: \
	distclean \
	clean_bootimg \
	clean_hw \
	clean_fsbl \
	clean_uboot \
	clean_dt \
	clean_kernel \
	all \
	build_bootimg \
	build_hw \
	build_fsbl \
	build_uboot \
	build_dt \
	build_kernel 


################################################################################
#########
# build #
#########
################################################################################

all: build_bootimg build_dt build_kernel
build_bootimg: build_fsbl build_uboot
	${MAKE} -C ${kBootimgBuildScriptDir} ${kBootimgBuildArgs} 

build_hw: 
	${MAKE} -C ${kHwBuildScriptDir} ${kHwBuildArgs}

build_fsbl: build_hw
	${MAKE} -C ${kFSBLBuildScriptDir} ${kFSBLBuildArgs}

build_uboot:
	${MAKE} -C ${kUbootBuildScriptDir} ${kUbootlBuildArgs}

build_dt: build_hw
	${MAKE} -C ${kDTBuildScriptDir} ${kDTBuildArgs}

build_kernel:
	${MAKE} -C ${kKernelBuildScriptDir} ${kKernelBuildArgs}


################################################################################
#########
# Clean #
#########
################################################################################

clean_bootimg:
	${MAKE} -C ${kBootimgBuildScriptDir} ${kBootimgBuildArgs} clean
clean_hw:
	${MAKE} -C ${kHwBuildScriptDir} ${kHwBuildArgs} clean
clean_fsbl:
	${MAKE} -C ${kFSBLBuildScriptDir} ${kFSBLBuildArgs} clean
clean_uboot:
	${MAKE} -C ${kUbootBuildScriptDir} ${kUbootlBuildArgs} clean
clean_dt:
	${MAKE} -C ${kDTBuildScriptDir} ${kDTBuildArgs} clean
clean_kernel:
	${MAKE} -C ${kKernelBuildScriptDir} ${kKernelBuildArgs} clean


distclean: \
	clean_bootimg \
	clean_hw \
	clean_fsbl \
	clean_uboot \
	clean_busybox \
	clean_dt \
	clean_kernel 
