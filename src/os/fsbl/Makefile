# include utiluty
kUtilitiesTopPath := ${UTILITIES_TOP_DIR}
kMKUtilitiesTopPath := $(wildcard ${kUtilitiesTopPath}/makefile/*.mk)
include ${kMKUtilitiesTopPath}


# I/O/B dir
kSrcsDir := $(shell pwd)
kBuildDir := ${BUILD_DIR}
kOutputDir := ${OUTPUT_DIR}

################################################################################
########################
## Please cheack here ##
########################
kXSASrcPath := ${XSA_SRC_PATH}

kBuildTCLScript := build_fsbl.tcl


kBuildTCLScriptPath := ${kSrcsDir}/${kBuildTCLScript}

kTCLUtilitiesTopPath := $(wildcard ${UTILITIES_TOP_DIR}/tcl/*.tcl)

kTarget := $(basename $(notdir ${FSBL_TARGET}))
kTargetExec := $(notdir ${FSBL_TARGET})
kTargetExecPath := ${kOutputDir}/${kTargetExec}

kFSBLGenDir := ${kBuildDir}/${kTarget}/Debug
kFSBLGenFileName := ${kTargetExec}
kFSBLGenPath := ${kFSBLGenDir}/${kFSBLGenFileName}

# Compiler
kXsctCLI := ${XSCT_CLI}
kXsctCLIArgs := \
	-B ${kBuildDir} \
	-O ${kOutputDir} \
	-t ${kTarget} \
	-U "${kTCLUtilitiesTopPath}" \
	-x ${kXSASrcPath} 


################################################################################

kDeps := \
	${kXSASrcPath} \
	${kBuildTCLScriptPath} \
	${kTCLUtilitiesTopPath}


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
	$(call InfoPrint,"Build fsbl has been completed")

clean:
	$(call InfoPrint,"Clean xvc_os_fsbl build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir} 
