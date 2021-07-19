BUILD_DIR ?= $(shell pwd)
PROJ_ROOT_DIR ?= $(shell realpath "${BUILD_DIR}/../")

# Srcs Dirs
kSrcDir := ${PROJ_ROOT_DIR}/src
kSrcDirHw := ${PROJ_ROOT_DIR}/src/hw
kSrcDirSw := ${PROJ_ROOT_DIR}/src/sw
kSrcDirOs := ${PROJ_ROOT_DIR}/src/os

# Output Dirs
kOutDir := ${BUILD_DIR}
kOutDirHw := ${BUILD_DIR}/out/hw
kOutDirSw := ${BUILD_DIR}/out/sw
kOutDirOs := ${BUILD_DIR}/out/os

kOutDirOsFSBL := ${kOutDirOs}/fsbl
kOutDirOsDT := ${kOutDirOs}/dt
kOutDirOsKernel := ${kOutDirOs}/kernel
kOutDirOsUboot := ${kOutDirOs}/uboot
kOutDirOsRootFs := ${kOutDirOs}/rootfs

# Build Dirs
kBuildDirHw := ${BUILD_DIR}/build_hw
kBuildDirSw := ${BUILD_DIR}/build_sw
kBuildDirOSFSBL := ${BUILD_DIR}/build_os/fsbl
kBuildDirOSDT := ${BUILD_DIR}/build_os/dt
kBuildDirOSKernel := ${BUILD_DIR}/build_os/kernel
kBuildDirOSUBoot := ${BUILD_DIR}/build_os/uboot
kBuildDirOSURootFS := ${BUILD_DIR}/build_os/rootfs

# Compilers and its Common flags
VIVADO_CLI ?= vivado
kVividoBuildHwCommFlags := -mode batch -notrace

XSCT_CLI ?= xsct
kXsctCommFlags :=

kXsctBuildFSBLCommFlags := source
kXsctGenBaseDTCommFlags := source

CROSS_COMPILE ?= arm-linux-gnueabihf-
ARCH ?= arm

# property for build hw
FPGA_PART ?= xc7z010clg400-1
RUN_GUI_AFTER_BULD_HW ?= false
kTCLUtilitiesTopPath := ${kSrcDir}/utilities
kHwBuildScriptSrcsDir := ${kSrcDirHw}/script
kHwXDCSrcsDir := ${kSrcDirHw}/xdc
kHwVerilogSrcsDir := ${kSrcDirHw}/hdl

kHwTargetName := xvc_server_hw
kHwBuildScriptBD := bd_system.tcl
kHwBuildScriptPSPreset := zybo-z7-ps-preset.tcl
kHwXDCSrcs += xvc-zybo-z7.xdc
kHwVerilogSrcs += axi_jtag_v1_0.v axi4_lite_if.v jtag_proc.v

kHwTopTclScriptPath := ${kHwBuildScriptSrcsDir}/top.tcl
kHwBuildScriptBDPath := ${kHwBuildScriptSrcsDir}/${kHwBuildScriptBD}
kHwBuildScriptPSPresetPath := ${kHwBuildScriptSrcsDir}/${kHwBuildScriptPSPreset}
kHwXDCSrcsPath := \
	$(foreach i, ${kHwXDCSrcs}, $(addprefix ${kHwXDCSrcsDir}/,${i} ) )
kHwVerilogSrcsPath := \
	$(foreach i, ${kHwVerilogSrcs}, $(addprefix ${kHwVerilogSrcsDir}/,${i} ) )

kHwOutTarget := ${kHwTargetName}.xsa

# property for build sw
kSwBuildScriptDir := ${kSrcDirSw}
kSwCSrcsDir := ${kSrcDirSw}

kSwBuildScriptPath += ${kSwBuildScriptDir}/Makefile
kSwCSrcs += xvc_server.c xvc_server.h xvc_server_param.h
kSwCSrcsPath:= \
	$(foreach i, ${kSwCSrcs}, $(addprefix ${kSwCSrcsDir}/ ,${i} ) )
kSwSrcs := ${kSwCSrcs} ${kSwBuildScriptPath}

kSwOutTarget := xvc_server.elf

# Check build env
necessary_exec_prog := ${VIVADO_CLI} ${CROSS_COMPILE}gcc ${XSCT_CLI}
chk_env := $(foreach exec,$(necessary_exec_prog),\
	$(if $(shell which $(exec)),"Found $(exec); ",$(error "No $(exec) in PATH")))

#############
# All build #
#############

build_hw: clean_hw init_hw ${kHwOutTarget}
${kHwOutTarget}: \
	${kHwTopTclScriptPath} \
	${kHwBuildScriptBDPath} \
	${kHwBuildScriptPSPresetPath} \
	${kHwXDCSrcsPath} \
	${kHwVerilogSrcsPath}
		${VIVADO_CLI} ${kVividoBuildHwCommFlags} \
		-source ${kHwTopTclScriptPath} -tclargs \
		-O ${kOutDirHw} \
		-B ${kBuildDirHw} \
		-t ${kHwTargetName} \
		-f ${FPGA_PART} \
		-v "${kHwVerilogSrcsPath}" \
		-x "${kHwXDCSrcsPath}" \
		-b ${kHwBuildScriptBDPath} \
		-p ${kHwBuildScriptPSPresetPath} \
		-U ${kTCLUtilitiesTopPath} \
		-g ${RUN_GUI_AFTER_BULD_HW}

build_sw: clean_sw init_sw ${kSwOutTarget}
${kSwOutTarget}: ${kSwSrcs}
	make -f ${kSwBuildScriptPath} \
	BUILD_DIR=${kBuildDirSw} \
	OUTPUT_DIR=${kOutDirSw} \
	CROSS_COMPILE=${CROSS_COMPILE} \
	ARCH=${ARCH} \
	UTILITIES_TOP_DIR=${kTCLUtilitiesTopPath}

init_hw: 
	mkdir -p ${kOutDirHw} ${kBuildDirHw}
init_sw:
	mkdir -p ${kOutDirSw} ${kBuildDirSw}
clean_hw:
	rm -rf ${kOutDirHw} ${kBuildDirHw}
clean_sw:
	rm -rf ${kOutDirSw} ${kBuildDirSw}

.PHONY: \
	init_hw \
	init_sw \
	build_hw \
	build_sw \
	gen_os_base_dt \
	build_os_fsbl \
	build_os_dt \
	build_os_kernel \
	build_os_uboot \
	build_os_rootfs \
	clean \
	clean_hw \
	clean_sw \
	clean_os_base_dt \
	clean_os_fsbl \
	clean_os_dt \
	clean_os_kernel \
	clean_os_uboot \
	clean_os_rootfs
	