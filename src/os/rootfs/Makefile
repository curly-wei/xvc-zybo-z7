 # include utiluty
kUtilitiesTopPath := ${UTILITIES_TOP_DIR}
kMKUtilitiesPath := $(wildcard ${kUtilitiesTopPath}/makefile/*.mk)
include ${kMKUtilitiesPath}

# I/O/B dir
kSrcsDir := $(shell pwd)

kBuildDir := ${BUILD_DIR}
kOutputDir := ${OUTPUT_DIR}


################################################################################
########################
## Please cheack here ##
########################


################################################################################


kDeps := \
	${kMKUtilitiesPath} 


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