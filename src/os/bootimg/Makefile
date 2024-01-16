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

kTarget := $(basename $(notdir ${BOOTIMG_TARGET}))
kTargetExec := $(notdir ${BOOTIMG_TARGET})
kTargetExecPath := ${kOutputDir}/${kTargetExec}

kBootbifName := ${kTarget}img.bif
kBootbifPath := ${kBuildDir}/${kBootbifName}

kXSASrcsPath := ${XSA_SRCS_PATH}
kUbootSrcsPath := ${UBOOT_SRCS_PATH}
kFSBLSrcsPath := ${FSBL_SRCS_PATH}

kFPGABitTargetName := $(basename $(notdir ${kXSASrcsPath})).bit
kFPGABitTargetPath := ${kBuildDir}/${kFPGABitTargetName}

kUbootTargetName := $(notdir ${kUbootSrcsPath})
kUbootTargetPath := ${kBuildDir}/${kUbootTargetName}

kFSBLTargetName := $(notdir ${kFSBLSrcsPath})
kUFSBLTargetPath := ${kBuildDir}/${kFSBLTargetName}

kBootbifBegin := $(basename $(notdir ${kBootbifName}))":{"
kBootbifEnd := "}"
kBootbifLoader := "[bootloader]${kUFSBLTargetPath}"
kBootbifFPGABit := ${kFPGABitTargetPath}
kBootbifUboot := ${kUbootTargetPath}


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
#.NOTPARALLEL:


all: gen_bootimg

gen_bootimg: ${kTargetExecPath}
${kTargetExecPath}: ${kDeps} gen_bootbif
	bootgen -image ${kBootbifPath} -w -o ${kTargetExecPath}


gen_bootbif: ${kBootbifPath}
${kBootbifPath}: ${kDeps} extract_FPGAbit_from_xsa prepare_uboot prepare_fsbl
	@echo "" > ${kBootbifPath}
	@echo ${kBootbifBegin} >> ${kBootbifPath} 
	@echo ${kBootbifLoader} >> ${kBootbifPath} 
	@echo ${kBootbifFPGABit} >> ${kBootbifPath} 
	@echo ${kBootbifUboot} >> ${kBootbifPath} 
	@echo ${kBootbifEnd} >> ${kBootbifPath} 
	

extract_FPGAbit_from_xsa: ${kFPGABitTargetPath}
${kFPGABitTargetPath}: ${kDeps} ${kXSASrcsPath}
	mkdir -p ${kBuildDir} ${kOutputDir} 
	unzip -p ${kXSASrcsPath} ${kFPGABitTargetName} > ${kFPGABitTargetPath}

prepare_uboot: ${kUbootTargetPath}
${kUbootTargetPath}: ${kDeps} ${kUbootSrcsPath}
	cp ${kUbootSrcsPath} ${kUbootTargetPath}

prepare_fsbl: ${kUFSBLTargetPath}
${kUFSBLTargetPath}: ${kDeps} ${kFSBLSrcsPath}
	cp ${kFSBLSrcsPath} ${kUFSBLTargetPath}

clean:
	$(call InfoPrint,"Clean bootimg directories")
	rm -rf ${kBuildDir} ${kOutputDir} 
