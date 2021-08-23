# include utiluty
kUtilitiesTopPath = ${UTILITIES_TOP_DIR}

include ${kUtilitiesTopPath}/makefile/color_printer.mk

# I/O/B dir
kXSASrcsPath := ${XSA_SRCS_PATH}
kBuildDir := ${BUILD_DIR}
kOutputDir := ${OUTPUT_DIR}

################################################################################
########################
## Please cheack here ##
########################

kBuildTCLScript := gen_base_dt.tcl

kXilDTSrcRepoURL := https://github.com/Xilinx/device-tree-xlnx.git
kXilDTSrcLocalDirName := device-tree-xlnx
kXilDTSrcRemoteBranchTag := master
kXilDTSrcLocalPath := ${kBuildDir}/${kXilDTSrcLocalDirName}
################################################################################

kTCLUtilitiesTopPath := ${kUtilitiesTopPath}/tcl

kDeps := \
	${kXSASrcsPath} \
	${kTCLUtilitiesTopPath}

# Compiler
kXsctCLI := ${XSCT_CLI}
kXsctCLIArgs := \
	-B ${kBuildDir} \
	-O ${kOutputDir} \
	-U ${kTCLUtilitiesTopPath} \
	-x ${kXSASrcsPath} \
	-R ${kXilDTSrcLocalPath}

all: | start_msg init_dir gen_base_dt end_msg

gen_base_dt: ${kDeps} clone_remote_dt_src 
	${kXsctCLI} ${kBuildTCLScript} ${kXsctCLIArgs}

clone_remote_dt_src:
	$(call InfoPrint,"Check Remote repository...")
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

start_msg:
	$(call InfoPrint,"Start to build dt")

end_msg:
	$(call InfoPrint,"Build dt has completed")

init_dir:
	mkdir -p ${kBuildDir} ${kOutputDir} 

clean:
	$(call InfoPrint,"Clean xvc_os_dt build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir} 

.PHONY: \
	all \
	clone_remote_dt_src \
	gen_base_dt \
	clean \
	start_msg \
	end_msg 
