# include utiluty
kUtilitiesTopPath := ${UTILITIES_TOP_DIR}
kMKUtilitiesTopPath := $(wildcard ${UTILITIES_TOP_DIR}/makefile/*.mk)
include ${kMKUtilitiesTopPath}


# I/O/B dir
kSrcsDir := $(shell pwd)
kBuildDir := ${BUILD_DIR}
kOutputDir := ${OUTPUT_DIR}

kVerilogSrcsDir := ${kSrcsDir}/hdl
kXDCSrcsDir := ${kSrcsDir}/xdc
kScriptsDir := ${kSrcsDir}/script

################################################################################
########################
## Please cheack here ##
########################

kVerilogSrcs := axi_jtag_v1_0.v axi4_lite_if.v jtag_proc.v
kXDCSrcs := xvc-zybo-z7.xdc
kTopBuildScript := top.tcl
kBuildScriptBD := bd_system.tcl
kBuildScriptPSPreset := zybo-z7-ps-preset.tcl

kFPGAPart := xc7z010clg400-1
################################################################################

kVerilogSrcsPath:= \
	$(foreach i,${kVerilogSrcs},$(addprefix ${kVerilogSrcsDir}/,${i}))
kXDCSrcsPath := \
	$(foreach i,${kXDCSrcs},$(addprefix ${kXDCSrcsDir}/,${i}))
kTopBuildScriptPath := ${kScriptsDir}/${kTopBuildScript}
kBuildScriptBDPath := ${kScriptsDir}/${kBuildScriptBD}
kBuildScriptPSPresetPath := ${kScriptsDir}/${kBuildScriptPSPreset}
kTCLUtilitiesTopPath := $(wildcard ${UTILITIES_TOP_DIR}/tcl/*.tcl)


kTarget := $(basename $(notdir ${HW_TARGET}))
kTargetXSA := ${HW_TARGET}

kDeps := \
	${kVerilogSrcsPath} \
	${kXDCSrcsPath} \
	${kTopBuildScriptPath} \
	${kBuildScriptBDPath} \
	${kBuildScriptPSPresetPath} \
	${kMKUtilitiesTopPath} \
	${kTCLUtilitiesTopPath}

# Compiler
kVivadoCLI := ${VIVADO_CLI}
kVivadoCLIFlags := \
	-mode batch -notrace \
	-log ${kBuildDir}/vivado.log \
	-jou ${kBuildDir}/vivado.jou

kVivadoCLIArgs := \
	-O ${kOutputDir} \
	-B ${kBuildDir} \
	-t ${kTarget} \
	-f ${kFPGAPart} \
	-v "${kVerilogSrcsPath}" \
	-x "${kXDCSrcsPath}" \
	-b ${kBuildScriptBDPath} \
	-p ${kBuildScriptPSPresetPath} \
	-U "${kTCLUtilitiesTopPath}"


################################################################################
# Run area below #
################################################################################

.PHONY: \
	all \
	clean

#.NOTPARALLEL:

all: ${kTargetXSA}
${kTargetXSA}: ${kDeps}
	$(call InfoPrint,"Start to build xvc_hw") 
	mkdir -p ${kBuildDir} ${kOutputDir}
	${kVivadoCLI} ${kVivadoCLIFlags} \
		-source ${kTopBuildScriptPath} \
		-tclargs ${kVivadoCLIArgs}
	$(call InfoPrint,"Build xvc_hw has been completed")

clean: 
	$(call InfoPrint,"Clean xvc_hw build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir}
