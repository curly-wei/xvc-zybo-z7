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
kSrcDirOs := ${kSrcDir}/os
kSrcDirSw := ${kSrcDir}/sw

# Build Dirs
kBuildDirOs := ${PROJ_BUILD_DIR}/os
kBuildDirSw := ${PROJ_BUILD_DIR}/sw
kBuildDirRoootfs := ${PROJ_BUILD_DIR}/rootfs

# Output Dirs
kOutDirOs := ${PROJ_OUTPUT_DIR}/os
kOutDirSw := ${PROJ_OUTPUT_DIR}/sw
kOutDirRoootfs := ${PROJ_BUILD_DIR}/rootfs

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

#######################
# property for rootfs #
#######################
kRootFsSwSrcsDir := ${kOutDirSw}
kRootfsOutPath := 


kRoootFSTarget := rootfs.img
kRootFSTargetPath := ${kOutDirOsRootFS}/${kRoootFSTarget}

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
	autoreconf \
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
	clean_rootfs \
	clean_os \
	clean_sw \
	all \
	make_rootfs \
	build_os \
	build_sw

################################################################################
#########
# build #
#########
################################################################################

all: make_rootfs

make_rootfs:
	@rm -rf ${kBuildDirRoootfs}
	@mkdir -p ${kBuildDirRoootfs}
	@for i in `ls -d ${kRootFsSwSrcsDir}/*`; do \
		cp -a $${i}/* ${kBuildDirRoootfs}; \
	done	
	mkimage -A arm -T ramdisk -c gzip -d 
	


build_os: 
	${MAKE} -C ${kOsBuildScriptDir} ${kOsBuildArgs}

build_sw: build_os
	${MAKE} -C ${kSwBuildScriptDir} ${kSwBuildArgs}


################################################################################
#########
# Clean #
#########
################################################################################
clean_rootfs:
	${MAKE} -C ${kRootFSBuildScriptDir} ${kRootFSBuildArgs} distclean
clean_os: 
	${MAKE} -C ${kOsBuildScriptDir} ${kOsBuildArgs} distclean
clean_sw:
	${MAKE} -C ${kSwBuildScriptDir} ${kSwBuildArgs} distclean

distclean: \
	clean_rootfs \
	clean_os \
	clean_sw 
