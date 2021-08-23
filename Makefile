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

# Build Dirs
kBuildDirHw := ${kBuildDir}/build_hw
kBuildDirSw := ${kBuildDir}/build_sw

kBuildDirOsDT := ${kBuildDir}/build_dt
kBuildDirOsFSBL := ${kBuildDir}/build_fsbl
kBuildDirOsKernel := ${kBuildDir}/build_kernel
kBuildDirOsUBoot := ${kBuildDir}/build_uboot
kBuildDirOsBusybox := ${kBuildDir}/build_busybox

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

RUN_GUI_AFTER_BULD_HW ?= false

kHwTarget := xvc_server_hw.xsa
kHwTargetPath := ${kOutDirHw}/${kHwTarget}

kHwBuildScriptDir := ${kSrcDirHw}
kHwBuildArgs := \
	HW_TARGET=${kHwTargetPath} \
	BUILD_DIR=${kBuildDirHw} \
	OUTPUT_DIR=${kOutDirHw} \
	VIVADO_CLI=${VIVADO_CLI} \
	RUN_GUI_AFTER_BULD_HW=${RUN_GUI_AFTER_BULD_HW} \
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

kDTBuildScriptDir := ${kSrcDirOs}/dt
kDTBuildArgs := \
	BUILD_DIR=${kBuildDirOsDT} \
	OUTPUT_DIR=${kOutDirOsDT} \
	XSCT_CLI=${XSCT_CLI} \
	XSA_SRCS_PATH=${kHwTargetPath} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath} 

###########################
# property for build fsbl #
###########################

kFSBLTarget := xvc_server_fsbl.elf
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

kKernelTarget := uImage
kKernelTargetPath := ${kOutDirOsKernel}/${kKernelTarget}

kKernelBuildScriptDir := ${kSrcDirOs}/kernel
kKernelBuildArgs := \
	KERNEL_TARGET=${kKernelTargetPath} \
	BUILD_DIR=${kBuildDirOsKernel} \
	OUTPUT_DIR=${kOutDirOsKernel} \
	CROSS_COMPILE=${CROSS_COMPILE} \
	ARCH=${ARCH} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath}

################################################################################
#########
# build #
#########
################################################################################

###################
# Check build env #
###################
necessary_exec_prog := \
	${VIVADO_CLI} \
	${CROSS_COMPILE}gcc \
	${XSCT_CLI} \
	git \
	bash

chk_env := $(foreach exec,$(necessary_exec_prog),\
	$(if $(shell which $(exec)),"Found $(exec); ",$(error "No $(exec) in PATH")))

#############
# All build #
#############

all: \
	build_hw build_sw \
	gen_base_dt build_fsbl \
	build_kernel build_uboot build_busybox

build_hw: 
	${MAKE} -C ${kHwBuildScriptDir} ${kHwBuildArgs}

build_sw: 
	${MAKE} -C ${kSwBuildScriptDir} ${kSwBuildArgs}

gen_base_dt: build_hw
	${MAKE} -C ${kDTBuildScriptDir} ${kDTBuildArgs}

build_fsbl: build_hw
	${MAKE} -C ${kFSBLBuildScriptDir} ${kFSBLBuildArgs}

build_kernel:
	${MAKE} -C ${kKernelBuildScriptDir} ${kKernelBuildArgs}

build_uboot:

build_busybox:

################################################################################
#########
# Clean #
#########
################################################################################

clean_hw:
	${MAKE} -C ${kHwBuildScriptDir} ${kHwBuildArgs} clean
clean_sw:
	${MAKE} -C ${kSwBuildScriptDir} ${kSwBuildArgs} clean
clean_dt:
	${MAKE} -C ${kDTBuildScriptDir} ${kDTBuildArgs} clean
clean_fsbl:
	${MAKE} -C ${kFSBLBuildScriptDir} ${kFSBLBuildArgs} clean
clean_kernel:
	${MAKE} -C ${kKernelBuildScriptDir} ${kKernelBuildArgs} clean

distclean: \
	clean_hw \
	clean_sw \
	clean_dt \
	clean_fsbl \
	clean_kernel

################################################################################
#########
# PHONY #
#########
################################################################################

.PHONY: \
	clean_hw \
	clean_sw \
	clean_dt \
	distclean \
	all \
	build_hw \
	build_sw \
	gen_base_dt \
	build_fsbl \
	build_kernel \
	build_uboot \
	build_busybox
	