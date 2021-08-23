# include utiluty
kUtilitiesTopPath = ${UTILITIES_TOP_DIR}

include ${kUtilitiesTopPath}/makefile/color_printer.mk

# I/O/B dir
kSrcsDir := $(shell pwd)
kXSASrcsPath := ${XSA_SRCS_PATH}
kBuildDir := ${BUILD_DIR}
kOutputDir := ${OUTPUT_DIR}

################################################################################
########################
## Please cheack here ##
########################

kBuildTCLScript := build_fsbl.tcl
################################################################################

kBuildTCLScriptPath := ${kSrcsDir}/${kBuildTCLScript}

kTCLUtilitiesTopPath := ${kUtilitiesTopPath}/tcl

kTarget := $(basename $(notdir ${FSBL_TARGET}))
kTargetExec := ${kOutputDir}/${kTarget}.elf

kDeps := \
	${kXSASrcsPath} \
	${kBuildTCLScriptPath} \
	${kTCLUtilitiesTopPath}

# Compiler
kXsctCLI := ${XSCT_CLI}
kXsctCLIArgs := \
	-B ${kBuildDir} \
	-O ${kOutputDir} \
	-t ${kTarget} \
	-U ${kTCLUtilitiesTopPath} \
	-x ${kXSASrcsPath} 

all: | start_msg init_dir build_fsbl end_msg

build_fsbl: ${kTargetExec} 
${kTargetExec}: ${kDeps}
	${kXsctCLI} ${kBuildTCLScriptPath} ${kXsctCLIArgs}

start_msg:
	$(call InfoPrint,"Start to build fsbl")

end_msg:
	$(call InfoPrint,"Build fsbl has completed")

init_dir:
	mkdir -p ${kBuildDir} ${kOutputDir} 

clean:
	$(call InfoPrint,"Clean xvc_os_fsbl build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir} 

.PHONY: \
	all \
	init_dir \
	build_fsbl \
	clean \
	start_msg \
	end_msg \
	init_dir