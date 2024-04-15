# include utiluty
kUtilitiesTopPath = ${UTILITIES_TOP_DIR}

include ${kUtilitiesTopPath}/makefile/color_printer.mk

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

kMKUtilitiesTopPath := ${kUtilitiesTopPath}/makefile

kDeps := \
	${kCSrcsPath} \
	${kMKUtilitiesTopPath} \
	${kCHeadersPath}

# Compiler
kCC := ${CROSS_COMPILE}gcc
kDebugFlags := -g
kReleaseFlags := -O2 -D RELEASE 
kCFlags := -std=c11 -Wall
kLDFlags := -static

.NOTPARALLEL: all

default: debug_build
debug_build: start_msg init_dir ${kTargetExecDebug} end_msg
release_build: start_msg init_dir ${kTargetExecRelease} end_msg

${kTargetExecDebug}: ${kObjDebug}
	$(call InfoPrint,"Linking...")
	${kCC} ${kLDFlags} ${kObjDebug} -o ${kTargetExecDebug}

${kTargetExecRelease}: ${kTargetExecRelease}
	$(call InfoPrint,"Linking...")
	${kCC} ${kLDFlags} ${kObjRelease} -o ${kTargetExecRelease}

${kObjDebug}: ${kDeps}
	$(call InfoPrint,"Compiling (debug)...")
	${kCC} ${kCFlags} ${kDebugFlags} -c ${kCSrcsPath} -o ${kObjDebug}

${kObjRelease}: ${kDeps}
	$(call InfoPrint,"Compiling (release)...")
	${kCC} ${kCFlags} ${kReleaseFlags} -c ${kCSrcsPath} -o ${kObjDebug}

start_msg:
	$(call InfoPrint,"Start to check/build xvc_sw")

end_msg:
	$(call InfoPrint,"Check/build xvc_sw has been completed")

init_dir: 
	$(call InfoPrint,"Create OutDir and BuildDir for xvc_sw")
	mkdir -p ${kBuildDir} ${kOutputDir}

clean: 
	$(call InfoPrint,"Clean xvc_sw build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir}

.PHONY: \
	start_msg \
	end_msg \
	init_dir \
	default \
	debug_build \
	release_build \
	clean


