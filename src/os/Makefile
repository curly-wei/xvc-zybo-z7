PROJ_ROOT_DIR ?= $(shell realpath `pwd`/../../)

# include utiluty
UTILITIES_TOP_DIR ?= $(shell realpath ${PROJ_ROOT_DIR}/src/utilities)
kUtilitiesTopPath := ${UTILITIES_TOP_DIR}
include ${kUtilitiesTopPath}/makefile/color_printer.mk


#########################################################
      # Necessary properities #
#########################################################

# I/O/B dir global (full project on parent)
PROJ_BUILD_DIR ?= ${PROJ_ROOT_DIR}/build
PROJ_OUTPUT_DIR ?= ${PROJ_BUILD_DIR}/out
# Compiler ant its features
XSCT_CLI ?= xsct
XSA_SRC_PATH ?= ${PROJ_OUTPUT_DIR}/hw/xvc_server_hw.xsa
CROSS_COMPILE ?= arm-linux-gnueabihf-
ARCH ?= arm
#########################################################

# I/O/B local (for os)
kBuildDirOs := ${PROJ_BUILD_DIR}/os
kOutDirOs := ${PROJ_OUTPUT_DIR}/os
kSrcDirOs := $(shell pwd)

# Compiler and its env.
kXSCT := ${XSCT_CLI}
kXSASrcPath := ${XSA_SRC_PATH}

kCC := ${CROSS_COMPILE}
kArch := ${ARCH}

# Build Dir
kBuildDirOsOsDT := ${kBuildDirOs}/build_dt
kBuildDirOsOsFSBL := ${kBuildDirOs}/build_fsbl
kBuildDirOsOsKernel := ${kBuildDirOs}/build_kernel
kBuildDirOsOsUboot := ${kBuildDirOs}/build_uboot
kBuildDirOsOsBootimg := ${kBuildDirOs}/bootimg

# Output Dir
kOutDirOsOsDT := ${kOutDirOs}/dt
kOutDirOsOsFSBL := ${kOutDirOs}/fsbl
kOutDirOsOsKernel := ${kOutDirOs}/kernel
kOutDirOsOsUboot := ${kOutDirOs}/uboot
kOutDirOsOsBootimg  := ${kOutDirOs}/bootimg

##################################################################


#########################
# property for build dt #
#########################
kDTTarget := devicetree.dtb
kDTTargetPath := ${kOutDirOsOsDT}/${kDTTarget}

kDTBuildScriptDir := ${kSrcDirOs}/dt
kDTBuildArgs := \
	DT_TARGET=${kDTTargetPath} \
	BUILD_DIR=${kBuildDirOsOsDT} \
	OUTPUT_DIR=${kOutDirOsOsDT} \
	XSCT_CLI=${kXSCT} \
	XSA_SRC_PATH=${kXSASrcPath} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath} 

###########################
# property for build fsbl #
###########################
kFSBLTarget := fsbl.elf
kFSBLTargetPath := ${kOutDirOsOsFSBL}/${kFSBLTarget}

kFSBLBuildScriptDir := ${kSrcDirOs}/fsbl
kFSBLBuildArgs := \
	FSBL_TARGET=${kFSBLTargetPath} \
	BUILD_DIR=${kBuildDirOsOsFSBL} \
	OUTPUT_DIR=${kOutDirOsOsFSBL} \
	XSCT_CLI=${kXSCT} \
	XSA_SRC_PATH=${kXSASrcPath} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath} 

#############################
# property for build kernel #
#############################
kKernelTarget := uImage.bin
kKernelTargetPath := ${kOutDirOsOsKernel}/${kKernelTarget}

kKernelBuildScriptDir := ${kSrcDirOs}/kernel
kKernelBuildArgs := \
	KERNEL_TARGET=${kKernelTargetPath} \
	BUILD_DIR=${kBuildDirOsOsKernel} \
	OUTPUT_DIR=${kOutDirOsOsKernel} \
	CROSS_COMPILE=${kCC} \
	ARCH=${kArch} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath}

#############################
# property for build Uboot #
#############################
kUbootTarget := u-boot.elf
kUbootTargetPath := ${kOutDirOsOsUboot}/${kUbootTarget}

kUbootBuildScriptDir := ${kSrcDirOs}/uboot
kUbootlBuildArgs := \
	UBOOT_TARGET=${kUbootTargetPath} \
	BUILD_DIR=${kBuildDirOsOsUboot} \
	OUTPUT_DIR=${kOutDirOsOsUboot} \
	CROSS_COMPILE=${kCC} \
	ARCH=${kArch} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath} 

#########################
# property for bootimg #
########################
kBootimgTarget := boot.bin
kBootimgTargetPath := ${kOutDirOsOsBootimg}/${kBootimgTarget}

kBootimgBuildScriptDir := ${kSrcDirOs}/bootimg
kBootimgBuildArgs := \
	BOOTIMG_TARGET=${kBootimgTargetPath} \
	BUILD_DIR=${kBuildDirOsOsBootimg} \
	OUTPUT_DIR=${kOutDirOsOsBootimg} \
	FSBL_SRCS_PATH=${kFSBLTargetPath} \
	XSA_SRC_PATH=${kXSASrcPath} \
	UBOOT_SRCS_PATH=${kUbootTargetPath} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath}


.PHONY: \
	distclean \
	clean_bootimg \
	clean_fsbl \
	clean_uboot \
	clean_dt \
	clean_kernel \
	all \
	build_bootimg \
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

build_fsbl: 
	${MAKE} -C ${kFSBLBuildScriptDir} ${kFSBLBuildArgs}

build_uboot:
	${MAKE} -C ${kUbootBuildScriptDir} ${kUbootlBuildArgs}

build_dt: 
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
	clean_fsbl \
	clean_uboot \
	clean_busybox \
	clean_dt \
	clean_kernel 
