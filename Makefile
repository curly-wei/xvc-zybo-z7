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
kOutDir := ${kBuildDir}
kOutDirHw := ${kBuildDir}/out/hw
kOutDirSw := ${kBuildDir}/out/sw
kOutDirOs := ${kBuildDir}/out/os

kOutDirOsFSBL := ${kOutDirOs}/fsbl
kOutDirOsDT := ${kOutDirOs}/dt
kOutDirOsKernel := ${kOutDirOs}/kernel
kOutDirOsUboot := ${kOutDirOs}/uboot
kOutDirOsRootFs := ${kOutDirOs}/rootfs

# Build Dirs
kBuildDirHw := ${kBuildDir}/build_hw
kBuildDirSw := ${kBuildDir}/build_sw
kBuildDirOSFSBL := ${kBuildDir}/build_os/fsbl
kBuildDirOSDT := ${kBuildDir}/build_os/dt
kBuildDirOSKernel := ${kBuildDir}/build_os/kernel
kBuildDirOSUBoot := ${kBuildDir}/build_os/uboot
kBuildDirOSURootFS := ${kBuildDir}/build_os/rootfs

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
# property for build os #
#########################

kFSBLBuildScriptDir := ${kSrcDirOs}/fsbl

kDTBuildScriptDir := ${kSrcDirOs}/dt
kDTBuildArgs := \
	BUILD_DIR=${kBuildDirSw} \
	OUTPUT_DIR=${kOutDirSw} \
	XSCT_CLI=${XSCT_CLI} \
	XSA_SRCS_PATH=${kHwTargetPath}


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

all: build_hw build_sw build_os

build_hw: 
	make -C ${kHwBuildScriptDir} ${kHwBuildArgs}

build_sw: 
	make -C ${kSwBuildScriptDir} ${kSwBuildArgs}

gen_base_dt: build_hw
	make -C ${kDTBuildScriptDir} ${kDTBuildArgs}

build_fsbl: build_hw

build_kernel:

build_uboot:

build_busybox:

################################################################################
#########
# Clean #
#########
################################################################################

clean_hw:
	make -C ${kHwBuildScriptDir} ${kHwBuildArgs} clean
clean_sw:
	make -C ${kSwBuildScriptDir} ${kSwBuildArgs} clean
clean_dt:
	make -C ${kDTBuildScriptDir} ${kDTBuildArgs} clean

distclean: \
	clean_hw \
	clean_sw \
	clean_dt

################################################################################
#########
# PHONY #
#########
################################################################################

.PHONY: \
	clean_hw \
	clean_sw \
	clean_dt \
	distclean
	