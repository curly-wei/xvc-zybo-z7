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

kTarget := busybox

kBusyboxSrcRemoteRepoUrl := https://git.busybox.net/busybox/
kBusyboxSrcRemoteBranchTag := master
kBusyboxSrcLocalDirName := busybox_src
kBusyboxSrcLocalPath := ${kBuildDir}/${kBusyboxSrcLocalDirName}

kBusyboxConfName := defconfig

kBusyboxGenFsDirName := _install
kBusyboxGenFsDirPath := ${kBusyboxSrcLocalPath}/${kBusyboxGenFsDirName}

kRootFolders := \
	/etc/rc.d \
  /var/log \
  /root \
  /proc \
  /sys \
  /srv \
  /boot \
  /mnt \
  /tmp \
  /home \
  /dev \
  /lib

################################################################################

kDeps := \
	${kTCLUtilitiesTopPath}

# Compiler
kCC := ${CROSS_COMPILE}
kARCH := ${ARCH}

kBuildArgs := \
	CROSS_COMPILE=${kCC} \
	ARCH=${kARCH} \
	INSTALL_PATH=${kOutputDir}

kMakeUImageArgs := \
	UIMAGE_LOADADDR=${kUImgLoadAddr} \
	${kUImageGenFileName}


################################################################################
# Run area below #
################################################################################
.NOTPARALLEL: 

.PHONY: \
	all \
	clone_remote_kernel_src \
	clean 

all: clone_busybox_src
	$(call InfoPrint,"Start to build busybox")
	mkdir -p ${kBuildDir} ${kOutputDir} 
	${MAKE} -C ${kBusyboxSrcLocalPath} ${kBusyboxConfName}
	${MAKE} -C ${kBusyboxSrcLocalPath}
	${MAKE} -C ${kBusyboxSrcLocalPath} install
	# @for i in ${kRootFolders}; do \
	# 	mkdir -p ${kBusyboxGenFsDirPath}/$${i}; \
	# done	
	cp -r ${kBusyboxGenFsDirPath}/* ${kOutputDir}


clone_busybox_src:
	$(call InfoPrint,"Check Remote/Local Repository...")
	@if [ ! -d ${kBusyboxSrcLocalPath} ]; then \
		echo "Remote repository doesn't exist in local, cloning...";\
		git clone \
		--depth=1 \
		--branch=${kBusyboxSrcRemoteBranchTag} \
		${kBusyboxSrcRemoteRepoUrl} ${kBusyboxSrcLocalPath}; \
	else \
		echo "Remote repository exist in local, check newest..."; \
		cd ${kBusyboxSrcLocalPath}; \
		git pull ${kBusyboxSrcRemoteRepoUrl}; \
	fi	

clean:
	$(call InfoPrint,"Clean xvc_os_busybox build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir}

