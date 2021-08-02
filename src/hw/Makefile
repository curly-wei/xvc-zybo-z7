# include utiluty
include ${UTILITIES_TOP_DIR}/makefile/color_printer.mk

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
kTCLUtilitiesTopPath := ${UTILITIES_TOP_DIR}

kRunGuiAfterBuildHw := ${RUN_GUI_AFTER_BULD_HW}

kTarget := $(basename $(notdir ${HW_TARGET}))
kTargetXSA := ${HW_TARGET}

kDeps := \
	${kVerilogSrcsPath} \
	${kXDCSrcsPath} \
	${kTopBuildScriptPath} \
	${kBuildScriptBDPath} \
	${kBuildScriptPSPresetPath} \
	${kTCLUtilitiesTopPath}

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
	-U ${kTCLUtilitiesTopPath} \
	-g ${kRunGuiAfterBuildHw}


default: start_msg init_dir ${kTargetXSA} end_msg
${kTargetXSA}: ${kDeps}
	$(call GPrint,"UserINFO: Start to build hw...")
	${kVivadoCLI} ${kVivadoCLIFlags} \
		-source ${kTopBuildScriptPath} \
		-tclargs ${kVivadoCLIArgs}

start_msg:
	$(call GPrint,"=============================================")
	$(call GPrint,"UserINFO: Start to build xvc_hw")
	$(call GPrint,"=============================================")

end_msg:
	$(call GPrint,"=============================================")
	$(call GPrint,"UserINFO: Build xvc_hw has completed")
	$(call GPrint,"=============================================")

init_dir :
	$(call GPrint,"UserINFO: Create OutDir and BuildDir for xvc_hw")
	mkdir -p ${kBuildDir} ${kOutputDir}

clean: 
	$(call GPrint,"UserINFO: Clean xvc_hw build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir}

.PHONY: \
	start_msg \
	end_msg \
	init_dir \
	clean


