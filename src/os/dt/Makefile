# include utiluty
include ${UTILITIES_TOP_DIR}/makefile/color_printer.mk

# I/O/B dir
kXSASrcsPath := ${XSA_SRCS_PATH}
kBuildDir := ${BUILD_DIR}
kOutputDir := ${OUTPUT_DIR}

# Compiler
kXsctCLI := ${XSCT_CLI}
kXsctCLIFlags := -tclargs
kXsctCLIArgs := 

################################################################################
########################
## Please cheack here ##
########################

kBuildTCLScript := 

kXilDTSrcRepoURL := https://github.com/Xilinx/device-tree-xlnx.git
kXilDTSrcLocalDirName := device-tree-xlnx
kXilDTSrcRemoteBranchTag := master
kXilDTSrcLocalPath := ${kBuildDir}/${kXilDTSrcLocalDirName}
################################################################################

clone_repo_from_remote:
	git clone \
		--depth=1 \
		--branch=${kXilDTSrcRemoteBranchTag} \
		${kXilDTSrcRepoURL} ${kXilDTSrcLocalPath}

gen_base_dt: ${kXSASrcsPath} clone_repo_from_remote
	${kXsctCLI} 

clean:
	$(call GPrint,"UserINFO: Clean xvc_os_dt build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir}

.PHONY: clean