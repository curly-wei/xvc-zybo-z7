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

kFSTabPath := ${kSrcsDir}/fstab
kFSTabOutDest := ${kOutputDir}/etc/fstab

kSrcs := ${kFSTabPath}

kTarget := busybox

kBusyboxSrcRemoteRepoUrl := https://git.busybox.net/busybox/
kBusyboxSrcRemoteBranchTag := master
kBusyboxSrcLocalDirName := $(basename $(notdir ${kSrcsDir}))_src
kBusyboxSrcLocalPath := ${kBuildDir}/${kBusyboxSrcLocalDirName}

kBusyboxConfName := defconfig

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

kMKUtilitiesTopPath := ${kUtilitiesTopPath}/makefile

kDeps := \
	${kSrcs}	\
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
	clone_remot_busybox_src \
	clean 
#.NOTPARALLEL:


all: clone_remot_busybox_src ${kDeps}
	$(call InfoPrint,"Start to build busybox")
	mkdir -p ${kBuildDir} ${kOutputDir} 
	${MAKE} -C ${kBusyboxSrcLocalPath} ${kBuildArgs} ${kBusyboxConfName} CONFIG_TC=n
	sed '/CONFIG_TCPSVD/s/.*//' -i ${kBusyboxSrcLocalPath}/.config
	sed '/CONFIG_TC/s/.*//' -i ${kBusyboxSrcLocalPath}/.config
	${MAKE} -C ${kBusyboxSrcLocalPath} ${kBuildArgs}
	${MAKE} -C ${kBusyboxSrcLocalPath} ${kBuildArgs} install
	@for i in ${kRootFolders}; do \
	 	mkdir -p ${kOutputDir}/$${i}; \
	done	
	cp ${kFSTabPath} ${kFSTabOutDest}
	$(call InfoPrint,"Build xvc_os_busybox has been completed")

clone_remot_busybox_src:
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

