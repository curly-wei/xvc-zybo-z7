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

CROSS_COMPILE ?= arm-linux-gnueabihf-
ARCH ?= arm
#########################################################

# I/O/B local (for sw)
kBuildDirSw := ${PROJ_BUILD_DIR}/sw
kOutDirSw := ${PROJ_OUTPUT_DIR}/sw
kSrcDirSw := $(shell pwd)

# Compiler and its env.
kCC := ${CROSS_COMPILE}
kArch := ${ARCH}

# Build Dir
kBuildDirSwSwGlibc:= ${kBuildDirSw}/build_glibc
kBuildDirSwSwZlib := ${kBuildDirSw}/build_zlib
kBuildDirSwSwDropbear := ${kBuildDirSw}/build_dropbear
kBuildDirSwSwXVCServer := ${kBuildDirSw}/build_xvc_server
kBuildDirSwOsBusybox := ${kBuildDirSw}/build_busybox


# Output Dir
kOutDirSwSwGlibc := ${kOutDirSw}/glibc
kOutDirSwSwZlib := ${kOutDirSw}/zlib
kOutDirSwSwDropbear := ${kOutDirSw}/dropbear
kOutDirSwSwXVCServer := ${kOutDirSw}/xvc_server
kOutDirSwOsBusybox := ${kOutDirSw}/busybox

##################################################################


###############################
# property for build glibc #
##############################
kGlibcTarget := glibc.so
kGlibcTargetPath := ${kOutDirSwSwGlibc}/${kGlibcTarget}

kGlibcBuildScriptDir := ${kSrcDirSw}/Glibc
kGlibcBuildArgs := \
	SW_TARGET_GLIBC=${kGlibcTarget} \
	BUILD_DIR=${kBuildDirSwSwGlibc} \
	OUTPUT_DIR=${kOutDirSwSwGlibc} \
	CROSS_COMPILE=${kCC} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath}

###############################
# property for build zlib #
##############################
kZlibTarget := libz.so
kZlibTargetPath := ${kOutDirSwSwZlib}/${kZlibTarget}

kZlibBuildScriptDir := ${kSrcDirSw}/zlib
kZlibBuildArgs := \
	SW_TARGET_ZLIB=${kZlibTarget} \
	BUILD_DIR=${kBuildDirSwSwZlib} \
	OUTPUT_DIR=${kOutDirSwSwZlib} \
	CROSS_COMPILE=${kCC} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath}


###############################
# property for build Dropbear #
##############################
kDropbearTarget := dropbear
kDropbearTargetPath := ${kOutDirSwSwDropbear}/${kDropbearTarget}

kDropbearBuildScriptDir := ${kSrcDirSw}/dropbear
kDropbearBuildArgs := \
	SW_TARGET_DROPBEAR=${kDropbearTarget} \
	BUILD_DIR=${kBuildDirSwSwDropbear} \
	OUTPUT_DIR=${kOutDirSwSwDropbear} \
	CROSS_COMPILE=${kCC} \
	ARCH=${kArch} \
	ZLIB_SRC_PATH=${kZlibTargetPath} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath}


#################################
# property for build xvc server #
#################################
kSwTarget := xvc_server.elf
kSwTargetPath := ${kOutDirSwSwXVCServer}/${kSwTarget}

kXVCServerBuildScriptDir := ${kSrcDirSw}/xvc_server
kXVCServerBuildArgs := \
	SW_TARGET_XVC_SERVER=${kSwTargetPath} \
	BUILD_DIR=${kBuildDirSwSwXVCServer} \
	OUTPUT_DIR=${kOutDirSwSwXVCServer} \
	CROSS_COMPILE=${kCC} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath} 

###############################
# property for build Busybox #
##############################
kBusyboxBuildScriptDir := ${kSrcDirSw}/busybox
kBusyboxBuildArgs := \
	BUILD_DIR=${kBuildDirSwOsBusybox} \
	OUTPUT_DIR=${kOutDirSwOsBusybox} \
	CROSS_COMPILE=${kCC} \
	ARCH=${ARCH} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath}


.PHONY: \
	distclean \
	clean_glibc \
	clean_zlib \
	clean_dropbear \
	clean_xvc_server \
	clean_busybox \
	all \
	build_glibc \
	build_zlib \
	build_dropbear \
	build_xvc_server \
	build_busybox

################################################################################
#########
# build #
#########
################################################################################

all: build_glibc build_dropbear build_xvc_server
build_glibc:
	${MAKE} -C ${kGlibcBuildScriptDir} ${kGlibcBuildArgs} 

build_zlib:
	${MAKE} -C ${kZlibBuildScriptDir} ${kZlibBuildArgs}

build_dropbear: build_zlib
	${MAKE} -C ${kDropbearBuildScriptDir} ${kDropbearBuildArgs}

build_xvc_server:
	${MAKE} -C ${kXVCServerBuildScriptDir} ${kXVCServerBuildArgs}

build_busybox: 
	${MAKE} -C ${kBusyboxBuildScriptDir} ${kBusyboxBuildArgs}

################################################################################
#########
# Clean #
#########
################################################################################

clean_glibc:
	${MAKE} -C ${kGlibcBuildScriptDir} ${kGlibcBuildArgs} clean
clean_zlib:
	${MAKE} -C ${kZlibBuildScriptDir} ${kZlibBuildArgs} clean
clean_dropbear:
	${MAKE} -C ${kDropbearBuildScriptDir} ${kDropbearBuildArgs} clean
clean_xvc_server:
	${MAKE} -C ${kXVCServerBuildScriptDir} ${kXVCServerBuildArgs} clean
clean_busybox:
	${MAKE} -C ${kBusyboxBuildScriptDir} ${kBusyboxBuildArgs} clean


distclean: \
	clean_glibc \
	clean_zlib \
	clean_dropbear \
	clean_xvc_server \
	clean_busybox
