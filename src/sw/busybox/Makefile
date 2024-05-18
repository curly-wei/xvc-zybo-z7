 # include utiluty
kUtilitiesTopPath = ${UTILITIES_TOP_DIR}

include ${kUtilitiesTopPath}/makefile/color_printer.mk
include ${kUtilitiesTopPath}/makefile/clone_remote_repo.mk

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
	CONFIG_PREFIX=${kOutputDir}


################################################################################
# Run area below #
################################################################################

.PHONY: \
	all \
	clone_remot_busybox_src \
	clean 
#.NOTPARALLEL:


## Regarding:
## sleep 1 && sed '/CONFIG_TCPSVD=y/..... 
## Here is patching for bug of TC
## If the bug will be fix in the future, remove these line
all: clone_remot_busybox_src ${kDeps}
	$(call InfoPrint,"Start to build busybox")
	mkdir -p ${kBuildDir} ${kOutputDir} 
	${MAKE} -C ${kBusyboxSrcLocalPath} ${kBuildArgs} ${kBusyboxConfName}
	sleep 1 && sed '/CONFIG_TCPSVD=y/s/.*/CONFIG_TCPSVD=n/' -i ${kBusyboxSrcLocalPath}/.config
	sleep 1 && sed '/CONFIG_TC=y/s/.*/CONFIG_TC=n/' -i ${kBusyboxSrcLocalPath}/.config
	${MAKE} -C ${kBusyboxSrcLocalPath} ${kBuildArgs}
	${MAKE} -C ${kBusyboxSrcLocalPath} ${kBuildArgs} install
	@for i in ${kRootFolders}; do \
	 	mkdir -p ${kOutputDir}/$${i}; \
	done	
	cp ${kFSTabPath} ${kFSTabOutDest}
	$(call InfoPrint,"Build xvc_os_busybox has been completed")


clone_remot_busybox_src:
	$(call InfoPrint,"Check Remote/Local Repository...")
	$(call CloneRemoteRepo,\
		${kBusyboxSrcRemoteRepoUrl},\
		${kBusyboxSrcRemoteBranchTag},\
		${kBusyboxSrcLocalPath},\
	)

clean:
	$(call InfoPrint,"Clean xvc_os_busybox build/out directories")
	rm -rf ${kBuildDir} ${kOutputDir}

