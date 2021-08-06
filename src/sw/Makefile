# include utiluty
include ${UTILITIES_TOP_DIR}/makefile/color_printer.mk

# I/O/B dir
kSrcsDir := $(shell pwd)
kBuildDir := ${BUILD_DIR}
kOutputDir := ${OUTPUT_DIR}

################################################################################
########################
## Please cheack here ##
########################

kCSrcs := xvc_server.c
kCHeaders := xvc_server.h xvc_server_param.h
################################################################################

kCSrcsPath:= \
	$(foreach i,${kCSrcs},$(addprefix ${kSrcsDir}/,${i}))
kCHeadersPath := \
	$(foreach i,${kCHeaders},$(addprefix ${kSrcsDir}/,${i}))

kTarget := $(basename $(notdir ${SW_TARGET}))

kTargetExecDebug := ${kOutputDir}/${kTarget}-d.elf
kTargetExecRelease := ${kOutputDir}/${kTarget}.elf

kObjDebug := ${kBuildDir}/${kTarget}-d.o
kObjRelease := ${kBuildDir}/${kTarget}.o

kDeps := \
	${kCSrcsPath} \
	${kCHeaders}

kCC := ${CROSS_COMPILE}gcc
kDebugFlags := -g
kReleaseFlags := -O2 -D RELEASE 
kCFlags := -std=c11 -Wall
kLDFlags := -static


default: debug_build
debug_build: start_msg init_dir ${kTargetExecDebug} end_msg
release_build: start_msg init_dir ${kTargetExecRelease} end_msg

${kTargetExecDebug}: ${kObjDebug}
	$(call GPrint,"UserINFO: Linking...")
	${kCC} ${kLDFlags} ${kObjDebug} -o ${kTargetExecDebug}

${kTargetExecRelease}: ${kTargetExecRelease}
	$(call GPrint,"UserINFO: Linking...")
	${kCC} ${kLDFlags} ${kObjRelease} -o ${kTargetExecRelease}

${kObjDebug}: ${kDeps}
	$(call GPrint,"UserINFO: Compiling (debug)...")
	${kCC} ${kCFlags} ${kDebugFlags} -c ${kCSrcsPath} -o ${kObjDebug}

${kObjRelease}: ${kDeps}
	$(call GPrint,"UserINFO: Compiling (release)...")
	${kCC} ${kCFlags} ${kReleaseFlags} -c ${kCSrcsPath} -o ${kObjDebug}


start_msg:
	$(call GPrint,"=============================================")
	$(call GPrint,"UserINFO: Start to build xvc_sw")
	$(call GPrint,"=============================================")

end_msg:
	$(call GPrint,"=============================================")
	$(call GPrint,"UserINFO: Build xvc_sw has completed")
	$(call GPrint,"=============================================")

init_dir: 
	$(call GPrint,"UserINFO: Create OutDir and BuildDir for xvc_sw")
	mkdir -p ${kBuildDir} ${kOutputDir}

clean: 
	$(call GPrint,"UserINFO: Clean xvc_sw build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir}

.PHONY: \
	start_msg \
	end_msg \
	init_dir \
	default \
	debug_build \
	release_build \
	clean


