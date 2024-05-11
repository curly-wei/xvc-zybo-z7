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
PROJ_BUILD_DIR ?= ${PROJ_ROOT_DIR}/build
PROJ_OUTPUT_DIR ?= ${PROJ_BUILD_DIR}/out

# Srcs Dirs
kSrcDir := ${PROJ_ROOT_DIR}/src
kSrcDirHw := ${kSrcDir}/hw
kSrcDirOs := ${kSrcDir}/os
kSrcDirSw := ${kSrcDir}/sw

# Build Dirs
kBuildDirHw := ${PROJ_BUILD_DIR}/hw
kBuildDirSw := ${PROJ_BUILD_DIR}/sw

# Output Dirs
kOutDirHw := ${PROJ_OUTPUT_DIR}/hw
kOutDirSw := ${PROJ_OUTPUT_DIR}/sw


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
	distclean \
	clean_hw \
	clean_os \
	clean_sw \
	clean_rootfs \
	all \
	make_rootfs \
	build_hw \
	build_os \
	build_sw

################################################################################
#########
# build #
#########
################################################################################

all: make_rootfs

make_rootfs: build_sw 
	${MAKE} -C ${kRootFSBuildScriptDir} ${kRootFSBuildArgs} 

build_hw: 
	${MAKE} -C ${kHwBuildScriptDir} ${kHwBuildArgs}

build_os: build_hw
	${MAKE} -C ${kOsBuildScriptDir} ${kOsBuildArgs}

build_sw: build_os
	${MAKE} -C ${kSwBuildScriptDir} ${kSwBuildArgs}


################################################################################
#########
# Clean #
#########
################################################################################
clean_rootfs:
	${MAKE} -C ${kRootFSBuildScriptDir} ${kRootFSBuildArgs} clean
clean_hw:
	${MAKE} -C ${kHwBuildScriptDir} ${kHwBuildArgs} clean
clean_os: 
	${MAKE} -C ${kOsBuildScriptDir} ${kOsBuildArgs} clean
clean_sw:
	${MAKE} -C ${kSwBuildScriptDir} ${kSwBuildArgs} clean

distclean: \
	clean_rootfs \
	clean_hw \
	clean_sw 
