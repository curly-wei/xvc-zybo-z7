# include utiluty
kUtilitiesTopPath = ${UTILITIES_TOP_DIR}

include ${kUtilitiesTopPath}/makefile/color_printer.mk

# I/O/B dir
kSrcsDir := $(shell pwd)

kBuildDir := ${BUILD_DIR}
kOutputDir := ${OUTPUT_DIR}

kBaseDTOutputDir := ${kBuildDir}/base_dt

kBuildDTSrcsDir := ${kSrcsDir}

################################################################################
########################
## Please cheack here ##
########################

# Param for base dt
kXSASrcsPath := ${XSA_SRCS_PATH}
kBuildTCLScript := gen_base_dt.tcl

kXilDTSrcRepoURL := https://github.com/Xilinx/device-tree-xlnx.git
kXilDTSrcLocalDirName := device-tree-xlnx
kXilDTSrcRemoteBranchTag := master
kXilDTSrcLocalPath := ${kBuildDir}/${kXilDTSrcLocalDirName}

# Param for dt
kTarget := $(basename $(notdir ${DT_TARGET}))
kTargetExec := $(notdir ${DT_TARGET})
kTargetExecPath := ${kOutputDir}/${kTargetExec}

kBuildDTSrcs := pl.dtsi system.dts
kBuildDTSrcsPath := \
	$(foreach i,${kBuildDTSrcs},$(addprefix ${kBuildDTSrcsDir}/,${i}))

################################################################################

kTCLUtilitiesTopPath := ${kUtilitiesTopPath}/tcl

kDepsBaseDT := \
	${kXSASrcsPath} \
	${kTCLUtilitiesTopPath}

kDepsBuildDT := \
	${kBuildDTSrcsPath}
	${kTCLUtilitiesTopPath}

# Compiler
kXsctCLI := ${XSCT_CLI}
kXsctCLIArgs := \
	-B ${kBuildDir} \
	-O ${kBaseDTOutputDir} \
	-U ${kTCLUtilitiesTopPath} \
	-x ${kXSASrcsPath} \
	-R ${kXilDTSrcLocalPath}

################################################################################
# Run area below #
################################################################################

.PHONY: \
	all \
	build_dt \
	gen_base_dt \
	clone_remote_dt_src \
	clean 

.NOTPARALLEL:

all: build_dt

build_dt: ${kDepsBuildDT} gen_base_dt ${kTargetExecPath}
${kTargetExecPath}: 


gen_base_dt: ${kDepsBaseDT}  clone_remote_dt_src 
	$(call InfoPrint,"Start to build dt")
	mkdir -p ${kBuildDir} ${kOutputDir} 
	${kXsctCLI} ${kBuildTCLScript} ${kXsctCLIArgs}
	$(call InfoPrint,"Build dt has completed")

clone_remote_dt_src:
	$(call InfoPrint,"Check Remote/Local Repository...")
	@if [ ! -d ${kXilDTSrcLocalPath} ]; then \
		echo "Remote repository doesn't exist in local, cloning...";\
		git clone \
		--depth=1 \
		--branch=${kXilDTSrcRemoteBranchTag} \
		${kXilDTSrcRepoURL} ${kXilDTSrcLocalPath}; \
	else \
		echo "Remote repository exist in local, check newest..."; \
		cd ${kXilDTSrcLocalPath}; \
		git pull ${kXilDTSrcRepoURL}; \
	fi	

clean:
	$(call InfoPrint,"Clean xvc_os_dt build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir} 

