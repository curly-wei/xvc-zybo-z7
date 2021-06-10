#Color renderning Green
define GPrint 
	@$(eval kColorGreen := '\e[0;32m')
	@$(eval kColorEnd := '\e[0m')
	@echo -e $(kColorGreen)${1}$(kColorEnd)
endef

#Color renderning Red
define RPrint 
	@$(eval kColorRed := '\e[0;31m')
	@$(eval kColorEnd := '\e[0m')
	@echo -e $(kColorGreen)${1}$(kColorEnd)
endef

kBuildDir ?= $(shell pwd)
kProjRootDir := $(shell realpath "${kBuildDir}/../")

# Srcs property
kSrcDir := ${kProjRootDir}/src
kSrcDirHw := ${kProjRootDir}/src/hw
kSrcDirSw := ${kProjRootDir}/src/sw
kSrcDirOs := ${kProjRootDir}/src/os

# Output property
kOutDir := ${kBuildDir}
kOutDirHw := ${kBuildDir}/out/hw
kOutDirSw := ${kBuildDir}/out/sw
kOutDirOs := ${kBuildDir}/out/os

kOutDirOsFSBL := ${kOutDirOs}/fsbl
kOutDirOsDT := ${kOutDirOs}/dt
kOutDirOsKernel := ${kOutDirOs}/kernel
kOutDirOsUboot := ${kOutDirOs}/uboot
kOutDirOsRootFs := ${kOutDirOs}/rootfs

# Build Dir
kBuildHwDir := ${kBuildDir}/build_hw
kBuildSwDir := ${kBuildDir}/build_sw
kBuildOSFSBLDir := ${kBuildDir}/build_os/fsbl
kBuildOSDTDir := ${kBuildDir}/build_os/dt
kBuildOSKernelDir := ${kBuildDir}/build_os/kernel
kBuildOSUBootDir := ${kBuildDir}/build_os/uboot
kBuildOSURootFSDir := ${kBuildDir}/build_os/rootfs

# Path to top-build-script and its args
kHwTopTclScriptPath := ${kSrcDirHw}/script/top.tcl
kHwTopTclScriptArgs := 

kOsBuildFSBLScriptPath := ${kSrcDirOs}/script/build_fsbl.tcl
kOsBuildFSBLScriptArgs :=

kOsGenBaseDtScriptPath := ${kSrcDirOs}/script/gen_base_dt.tcl
kOsGenBaseDtScriptArgs :=

# Compilers
kVividoTclTool := vivado
kkVividoCommFlags := -mode batch

kVitisXsctTool := xsct
kVitisXsctCommFlags :=

kVividoGenHwFlags := -source ${kHwTopTclScript}

kVitisXsctBuildFSBLFlags := source ${kOsBuildFSBLScriptPath}
kVitisXsctGenBaseDTFlags := source ${kOsGenBaseDtScriptPath}

# Cross platform GCC toolchain
CROSS_COMPILE ?= "arm-linux-gnueabihf-"
ARCH ?= "arm"

# hw srcs
kHwHDLSrcsDir := ${kSrcDirHw}/hdl
kHwXDCSrcsDir := ${kSrcDirHw}/xdc

kHwHDLSrcs += 
kHwXDCSrcs += 

# hw main output target file
kHwOutTarget := xvc_server_top.xsa


# Check build env
necessary_exec_prog := ${kVividoTclTool} ${kVitisXsctTool} ${CROSS_COMPILE}gcc
chk_env := $(foreach exec,$(necessary_exec_prog),\
	$(if $(shell which $(exec)),some string,$(error "No $(exec) in PATH")))

# Build script

# Build hw


# Clean

.PHONY: \
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
	