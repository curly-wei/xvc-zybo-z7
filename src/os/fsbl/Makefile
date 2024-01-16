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
kTargetExec := $(notdir ${FSBL_TARGET})
kTargetExecPath := ${kOutputDir}/${kTargetExec}

kFSBLGenDir := ${kBuildDir}/${kTarget}/Debug
kFSBLGenFileName := ${kTargetExec}
kFSBLGenPath := ${kFSBLGenDir}/${kFSBLGenFileName}

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


################################################################################
# Run area below #
################################################################################

.PHONY: \
	all \
	clean \

#.NOTPARALLEL:

all: ${kTargetExecPath}
${kTargetExecPath}: ${kDeps}
	$(call InfoPrint,"Start to build fsbl")
	mkdir -p ${kBuildDir} ${kOutputDir} 
	${kXsctCLI} ${kBuildTCLScriptPath} ${kXsctCLIArgs}
	cp ${kFSBLGenPath} ${kTargetExecPath}
	$(call InfoPrint,"Build fsbl has completed")

clean:
	$(call InfoPrint,"Clean xvc_os_fsbl build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir} 
