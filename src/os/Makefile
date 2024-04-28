# include utiluty
kUtilitiesTopPath = ${UTILITIES_TOP_DIR}

include ${kUtilitiesTopPath}/makefile/color_printer.mk

# I/O/B dir
kSrcsDir := $(shell pwd)
kBuildDir := ${BUILD_DIR}
kOutputDir := ${OUTPUT_DIR}

kVerilogSrcsDir := ${kSrcsDir}/hdl
kXDCSrcsDir := ${kSrcsDir}/xdc
kScriptsDir := ${kSrcsDir}/script

# Necessary properity

xsct = ${XSCT_CLI}
xsa_srcs_path = ${XSA_SRCS_PATH}



##################################################################


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
	XSCT_CLI=${xsct} \
	XSA_SRCS_PATH=${xsa_srcs_path} \
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
	XSCT_CLI=${xsct} \
	XSA_SRCS_PATH=${xsa_srcs_path} \
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


make_rootfs: build_bootimg build_busybox build_dt build_kernel \
		build_sw build_dropbear
	${MAKE} -C ${kRootFSBuildScriptDir} ${kRootFSBuildArgs} 

build_bootimg: build_fsbl build_uboot
	${MAKE} -C ${kBootimgBuildScriptDir} ${kBootimgBuildArgs} 

build_fsbl: 
	${MAKE} -C ${kFSBLBuildScriptDir} ${kFSBLBuildArgs}

build_uboot:
	${MAKE} -C ${kUbootBuildScriptDir} ${kUbootlBuildArgs}

build_busybox: 
	${MAKE} -C ${kBusyboxBuildScriptDir} ${kBusyboxBuildArgs}

build_dt: 
	${MAKE} -C ${kDTBuildScriptDir} ${kDTBuildArgs}

build_kernel:
	${MAKE} -C ${kKernelBuildScriptDir} ${kKernelBuildArgs}
