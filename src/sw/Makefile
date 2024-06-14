PROJ_ROOT_DIR ?= $(shell realpath `pwd`/../../)

UTILITIES_TOP_DIR ?= $(shell realpath ${PROJ_ROOT_DIR}/src/utilities)
kUtilitiesTopPath := ${UTILITIES_TOP_DIR}
kMKUtilitiesPath := $(wildcard ${kUtilitiesTopPath}/makefile/*.mk)
# include utiluty
include ${kMKUtilitiesPath}



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
kBuildDirSwGlibc:= ${kBuildDirSw}/build_glibc
kBuildDirSwZlib := ${kBuildDirSw}/build_zlib
kBuildDirSwDropbear := ${kBuildDirSw}/build_dropbear
kBuildDirSwOpenssh := ${kBuildDirSw}/build_openssh
kBuildDirSwOpenssl := ${kBuildDirSw}/build_openssl
kBuildDirSwXVCServer := ${kBuildDirSw}/build_xvc_server
kBuildDirSwOsBusybox := ${kBuildDirSw}/build_busybox


# Output Dir
kOutDirSwGlibc := ${kOutDirSw}/glibc
kOutDirSwZlib := ${kOutDirSw}/zlib
kOutDirSwDropbear := ${kOutDirSw}/dropbear
kOutDirSwOpenssh := ${kOutDirSw}/openssh
kOutDirSwOpenssl := ${kOutDirSw}/openssl
kOutDirSwXVCServer := ${kOutDirSw}/xvc_server
kOutDirSwOsBusybox := ${kOutDirSw}/busybox

##################################################################


###############################
# property for build glibc #
##############################
kGlibcTarget := libc.so
kGlibcTargetPath := ${kOutDirSwGlibc}/lib/${kGlibcTarget}

kGlibcBuildScriptDir := ${kSrcDirSw}/glibc
kGlibcBuildArgs := \
	SW_TARGET_GLIBC=${kGlibcTargetPath} \
	BUILD_DIR=${kBuildDirSwGlibc} \
	OUTPUT_DIR=${kOutDirSwGlibc} \
	CROSS_COMPILE=${kCC} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath}


###############################
# property for build zlib #
##############################
kZlibTarget := libz.so
kZlibTargetPath := ${kOutDirSwZlib}/lib/${kZlibTarget}

kZlibBuildScriptDir := ${kSrcDirSw}/zlib
kZlibBuildArgs := \
	SW_TARGET_ZLIB=${kZlibTargetPath} \
	BUILD_DIR=${kBuildDirSwZlib} \
	OUTPUT_DIR=${kOutDirSwZlib} \
	CROSS_COMPILE=${kCC} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath}


###############################
# property for build Dropbear #
##############################
kDropbearTarget := dropbear
kDropbearTargetPath := ${kOutDirSwDropbear}/bin/${kDropbearTarget}

kDropbearBuildScriptDir := ${kSrcDirSw}/dropbear
kDropbearBuildArgs := \
	SW_TARGET_DROPBEAR=${kDropbearTargetPath} \
	BUILD_DIR=${kBuildDirSwDropbear} \
	OUTPUT_DIR=${kOutDirSwDropbear} \
	CROSS_COMPILE=${kCC} \
	ZLIB_SRCS_PATH=${kOutDirSwZlib} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath}


###############################
# property for build openssh #
##############################
kOpensshTarget := sshd
kOpensshTargetPath := ${kOutDirSwOpenssh}/sbin/${kOpensshTarget}

kOpensshBuildScriptDir := ${kSrcDirSw}/openssh
kOpensshBuildArgs := \
	SW_TARGET_OPENSSH=${kOpensshTargetPath} \
	BUILD_DIR=${kBuildDirSwOpenssh} \
	OUTPUT_DIR=${kOutDirSwOpenssh} \
	CROSS_COMPILE=${kCC} \
	ZLIB_SRCS_PATH=${kOutDirSwZlib} \
	OPENSSL_SRCS_PATH=${kOutDirSwOpenssl} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath}


###############################
# property for build openssl #
##############################
kOpensslTarget := openssl
kOpensslTargetPath := ${kOutDirSwOpenssl}/bin/${kOpensslTarget}

kOpensslBuildScriptDir := ${kSrcDirSw}/openssl
kOpensslBuildArgs := \
	SW_TARGET_OPENSSL=${kOpensslTargetPath} \
	BUILD_DIR=${kBuildDirSwOpenssl} \
	OUTPUT_DIR=${kOutDirSwOpenssl} \
	CROSS_COMPILE=${kCC} \
	UTILITIES_TOP_DIR=${kUtilitiesTopPath}



#################################
# property for build xvc server #
#################################
kXvcServerTarget := xvc_server.elf
kXvcServerTargetPath := ${kOutDirSwXVCServer}/bin/${kXvcServerTarget}

kXVCServerBuildScriptDir := ${kSrcDirSw}/xvc_server
kXVCServerBuildArgs := \
	SW_TARGET_XVC_SERVER=${kXvcServerTargetPath} \
	BUILD_DIR=${kBuildDirSwXVCServer} \
	OUTPUT_DIR=${kOutDirSwXVCServer} \
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


################################################################################
#########
# build #
#########
################################################################################

.PHONY: \
	distclean \
	clean_glibc \
	clean_zlib \
	clean_dropbear \
	clean_openssh \
	clean_openssl \
	clean_xvc_server \
	clean_busybox \
	all \
	build_glibc \
	build_zlib \
	build_dropbear \
	build_openssh \
	build_openssl \
	build_xvc_server \
	build_busybox

all: build_openssh build_xvc_server
build_glibc:
	${MAKE} -C ${kGlibcBuildScriptDir} ${kGlibcBuildArgs} 

build_zlib: build_glibc
	${MAKE} -C ${kZlibBuildScriptDir} ${kZlibBuildArgs}

build_dropbear:
	${MAKE} -C ${kDropbearBuildScriptDir} ${kDropbearBuildArgs}

build_openssh: build_openssl
	${MAKE} -C ${kOpensshBuildScriptDir} ${kOpensshBuildArgs}

build_openssl: build_zlib
	${MAKE} -C ${kOpensslBuildScriptDir} ${kOpensslBuildArgs}

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
clean_openssh:
	${MAKE} -C ${kOpensshBuildScriptDir} ${kOpensshBuildArgs} clean
clean_openssl:
	${MAKE} -C ${kOpensslBuildScriptDir} ${kOpensslBuildArgs} clean
clean_xvc_server:
	${MAKE} -C ${kXVCServerBuildScriptDir} ${kXVCServerBuildArgs} clean
clean_busybox:
	${MAKE} -C ${kBusyboxBuildScriptDir} ${kBusyboxBuildArgs} clean


distclean: \
	clean_glibc \
	clean_zlib \
	clean_dropbear \
	clean_openssh \
	clean_openssl \
	clean_xvc_server \
	clean_busybox
