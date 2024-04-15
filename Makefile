kProjName := xvc_server

################################################################################
##################
# basic property #
##################
################################################################################

######################################
# property for Build I/O Directories #
######################################

PROJ_ROOT_DIR ?= $(shell pwd)
BUILD_DIR ?= ${PROJ_ROOT_DIR}/build

kProjRootDir := ${PROJ_ROOT_DIR}
kBuildDir := ${BUILD_DIR}

# Srcs Dirs
kSrcDir := ${kProjRootDir}/src
kSrcDirHw := ${kProjRootDir}/src/hw
kSrcDirSw := ${kProjRootDir}/src/sw
kSrcDirOs := ${kProjRootDir}/src/os

# Output Dirs
kOutDir := ${kBuildDir}/out
kOutDirHw := ${kOutDir}/hw
kOutDirSw := ${kOutDir}/sw

kOutDirOsDT := ${kOutDir}/dt
kOutDirOsFSBL := ${kOutDir}/fsbl
kOutDirOsKernel := ${kOutDir}/kernel
kOutDirOsUboot := ${kOutDir}/uboot
kOutDirOsBusybox := ${kOutDir}/busybox
kOutDirOsBootimg  := ${kOutDir}/bootimg
kOutDirOsDropbear := ${kOutDir}/dropbear
kOutDirOsRootFS  := ${kOutDir}/rootfs

# Build Dirs
kBuildDirHw := ${kBuildDir}/build_hw
kBuildDirSw := ${kBuildDir}/build_sw

kBuildDirOsDT := ${kBuildDir}/build_dt
kBuildDirOsFSBL := ${kBuildDir}/build_fsbl
kBuildDirOsKernel := ${kBuildDir}/build_kernel
kBuildDirOsUboot := ${kBuildDir}/build_uboot
kBuildDirOsBusybox := ${kBuildDir}/build_busybox
kBuildDirOsBootimg := ${kBuildDir}/bootimg
kBuildDirOsDropbear := ${kBuildDir}/dropbear
kBuildDirOsRootFS := ${kBuildDir}/rootfs

#########################
# property for Compiler #
#########################

VIVADO_CLI ?= vivado

XSCT_CLI ?= xsct


CROSS_COMPILE ?= arm-linux-gnueabihf-
ARCH ?= arm


################################################################################
##############################
# property for build targets #
##############################
################################################################################

##########################
# property for utilities #
##########################

kUtilitiesTopPath := ${kSrcDir}/utilities

#########################
# property for build hw #
#########################
kHwTarget := xvc_server_hw.xsa
kHwTargetPath := ${kOutDirHw}/${kHwTarget}

kHwBuildScriptDir := ${kSrcDirHw}
kHwBuildArgs := \
	HW_TARGET=${kHwTargetPath} \
	BUILD_DIR=${kBuildDirHw} \
	OUTPUT_DIR=${kOutDirHw} \
	VIVADO_CLI=${VIVADO_CLI} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath} 

#########################
# property for build sw #
#########################
kSwTarget := xvc_server.elf
kSwTargetPath := ${kOutDirSw}/${kSwTarget}

kSwBuildScriptDir := ${kSrcDirSw}
kSwBuildArgs := \
	SW_TARGET=${kSwTargetPath} \
	BUILD_DIR=${kBuildDirSw} \
	OUTPUT_DIR=${kOutDirSw} \
	CROSS_COMPILE=${CROSS_COMPILE} \
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
	XSCT_CLI=${XSCT_CLI} \
	XSA_SRCS_PATH=${kHwTargetPath} \
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
	XSCT_CLI=${XSCT_CLI} \
	XSA_SRCS_PATH=${kHwTargetPath} \
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
	CROSS_COMPILE=${CROSS_COMPILE} \
	ARCH=${ARCH} \
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
	CROSS_COMPILE=${CROSS_COMPILE} \
	ARCH=${ARCH} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath} 

###############################
# property for build Busybox #
##############################
kBusyboxBuildScriptDir := ${kSrcDirOs}/busybox
kBusyboxBuildArgs := \
	BUILD_DIR=${kBuildDirOsBusybox} \
	OUTPUT_DIR=${kOutDirOsBusybox} \
	CROSS_COMPILE=${CROSS_COMPILE} \
	ARCH=${ARCH} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath}

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
	XSA_SRCS_PATH=${kHwTargetPath} \
	UBOOT_SRCS_PATH=${kUbootTargetPath} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath}

###############################
# property for build Dropbear #
##############################
kDropbearTarget := dropbear
kDropbearTargetPath := ${kOutDirOsDropbear}/${kDropbearTarget}

kDropbearBuildScriptDir := ${kSrcDirOs}/dropbear
kDropbearBuildArgs := \
	BUILD_DIR=${kBuildDirOsDropbear} \
	OUTPUT_DIR=${kOutDirOsDropbear} \
	CROSS_COMPILE=${CROSS_COMPILE} \
	ARCH=${ARCH} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath}

#######################
# property for rootfs #
#######################
kRoootFSTarget := rootfs.img
kRootFSTargetPath := ${kOutDirOsRootFS}/${kRoootFSTarget}

kRootFSBuildScriptDir := ${kSrcDirOs}/rootfs
kRootFSBuildArgs := \
	ROOTFS_TARGET=${kRootFSTargetPath} \
	BUILD_DIR=${kBuildDirOsRootFS} \
	OUTPUT_DIR=${kOutDirOsRootFS} \
	BUSYBOX_SRCS_PATH=${kHwTargetPath} \
	DTB_SRCS_PATH=${kFSBLTargetPath} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath}


################################################################################
###################
# Check build env #
###################
################################################################################
necessary_exec_prog := \
	${VIVADO_CLI} \
	${CROSS_COMPILE}gcc \
	${XSCT_CLI} \
	git \
	bash \
	unzip \
	mkimage \
	dtc

chk_env := $(foreach exec,$(necessary_exec_prog),\
	$(if $(shell which $(exec)),"Found $(exec); ",$(error "No $(exec) in PATH")))


################################################################################
#########
# PHONY #
#########
################################################################################

.PHONY: \
	clean_hw \
	clean_sw \
	clean_dt \
	clean_fsbl \
	clean_kernel \
	clean_uboot \
	clean_busybox\
	clean_bootimg \
	clean_rootfs \
	distclean \
	all \
	build_hw \
	build_sw \
	build_dt \
	build_fsbl \
	build_kernel \
	build_uboot \
	build_busybox \
	build_bootimg \
	build_dropbear \
	make_rootfs
	

################################################################################
#########
# build #
#########
################################################################################

all: make_rootfs

make_rootfs: build_bootimg build_busybox build_dt build_kernel \
		build_sw build_dropbear
	${MAKE} -C ${kRootFSBuildScriptDir} ${kRootFSBuildArgs} 

build_bootimg: build_fsbl build_uboot
	${MAKE} -C ${kBootimgBuildScriptDir} ${kBootimgBuildArgs} 

build_fsbl: build_hw
	${MAKE} -C ${kFSBLBuildScriptDir} ${kFSBLBuildArgs}

build_uboot:
	${MAKE} -C ${kUbootBuildScriptDir} ${kUbootlBuildArgs}

build_busybox: 
	${MAKE} -C ${kBusyboxBuildScriptDir} ${kBusyboxBuildArgs}

build_dropbear:
	${MAKE} -C ${kDropbearBuildScriptDir} ${kDropbearBuildArgs}

build_dt: build_hw
	${MAKE} -C ${kDTBuildScriptDir} ${kDTBuildArgs}

build_kernel:
	${MAKE} -C ${kKernelBuildScriptDir} ${kKernelBuildArgs}

build_hw: 
	${MAKE} -C ${kHwBuildScriptDir} ${kHwBuildArgs}

build_sw: 
	${MAKE} -C ${kSwBuildScriptDir} ${kSwBuildArgs}


################################################################################
#########
# Clean #
#########
################################################################################
clean_rootfs:
	${MAKE} -C ${kRootFSBuildScriptDir} ${kRootFSBuildArgs} clean
clean_bootimg:
	${MAKE} -C ${kBootimgBuildScriptDir} ${kBootimgBuildArgs} clean
clean_fsbl:
	${MAKE} -C ${kFSBLBuildScriptDir} ${kFSBLBuildArgs} clean
clean_uboot:
	${MAKE} -C ${kUbootBuildScriptDir} ${kUbootlBuildArgs} clean
clean_busybox:
	${MAKE} -C ${kBusyboxBuildScriptDir} ${kBusyboxBuildArgs} clean
clean_dropbear:
	${MAKE} -C ${kDropbearBuildScriptDir} ${kDropbearBuildArgs} clean
clean_dt:
	${MAKE} -C ${kDTBuildScriptDir} ${kDTBuildArgs} clean
clean_kernel:
	${MAKE} -C ${kKernelBuildScriptDir} ${kKernelBuildArgs} clean
clean_hw:
	${MAKE} -C ${kHwBuildScriptDir} ${kHwBuildArgs} clean
clean_sw:
	${MAKE} -C ${kSwBuildScriptDir} ${kSwBuildArgs} clean

distclean: \
	clean_hw \
	clean_sw \
	clean_dt \
	clean_fsbl \
	clean_kernel \
	clean_uboot \
	clean_busybox \
	clean_bootimg \
	clean_rootfs
