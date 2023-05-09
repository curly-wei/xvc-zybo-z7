 # include utiluty
kUtilitiesTopPath = ${UTILITIES_TOP_DIR}

include ${kUtilitiesTopPath}/makefile/color_printer.mk

# I/O/B dir
kBuildDir := ${BUILD_DIR}
kOutputDir := ${OUTPUT_DIR}

################################################################################
########################
## Please cheack here ##
########################

kTarget := $(basename $(notdir ${BOOTIMG_TARGET}))
kTargetExec := $(notdir ${BOOTIMG_TARGET})
kTargetExecPath := ${kOutputDir}/${kTargetExec}

kBootbifName := ${kTarget}.bif
kBootbifPath := ${kOutputDir}/${kBootbifName}

kBootbifBegin := "image : {"
kBootbifEnd := "}"
kBootbifLoader := "[bootloader]${}"
kBootbifFPGABit := ${}
kBootbifUboot := ${}


################################################################################

kMKUtilitiesTopPath := ${kUtilitiesTopPath}/makefile
kDeps := \
	${kMKUtilitiesTopPath}

# Compiler
kCC := ${CROSS_COMPILE}
kARCH := ${ARCH}

kBuildArgs := \
	CROSS_COMPILE=${kCC} \
	ARCH=${kARCH} \
	INSTALL_PATH=${kOutputDir}

################################################################################
# Run area below #
################################################################################

.PHONY: \
	all \
	build_dt \
	gen_base_dt \
	clone_remote_dt_src \
	clean 

all: gen_bootimg
gen_bootimg: ${kBootbifPath}

gen_bootbif:
	@echo ${kBootbifBegin} \
	${kBootbifLoader} ${kBootbifFPGABit} ${kBootbifUboot} \
	${kBootbifEnd} \
	> ${kBootbifPath}

clean:
	$(call InfoPrint,"Clean bootimg directories")
	rm -rf ${kBuildDir} ${kOutputDir} 
