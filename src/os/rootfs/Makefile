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


################################################################################

kMKUtilitiesTopPath := ${kUtilitiesTopPath}/makefile
kDeps := \
	${kMKUtilitiesTopPath} 


################################################################################
# Run area below #
################################################################################

.PHONY: \
	all \
	gen_bootimg \
	gen_bootbif \
	extract_FPGAbit_from_xsa \
	prepare_uboot \
	prepare_fsbl \
	clean 

all:



clean:
	$(call InfoPrint,"Clean bootimg directories")
	rm -rf ${kBuildDir} ${kOutputDir} 