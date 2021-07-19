# /bin/bash
InfoPrint "-----------------------------------------------"
InfoPrint "Start to build uboot"
InfoPrint "-----------------------------------------------"

# IO properties
kBuildDir="$(realpath $(pwd))"
kOutputDir="${kBuildDir}/xvc_server_os/u-boot"

# Local/Remote Repo property
kUBootSrcRemoteRepoUrl="git@github.com:u-boot/u-boot.git"
kUBootSrcRemoteBranchTag="master"
kUBootSrcLocalDirName="build_uboot"
kUBootSrcLocalPath="${kBuildDir}/${kUBootSrcLocalDirName}"

#Build properties
kUbootConfName="xilinx_zynq_virt_defconfig"
kMaxJobs="$(( $(nproc) / 2 ))" 

#Output file(cp) properties
kUBootGenFileName="u-boot"
kUBootOutFileName="u-boot.elf"
kUBootGenFilePath="${kUBootSrcLocalPath}/${kUBootGenFileName}"
kUBootOutFilePath="${kOutputDir}/${kUBootOutFileName}"

InfoPrint "clean previously build object"
rm -rf ${kUBootSrcLocalPath} ${kOutputDir}

InfoPrint "create output dir"
mkdir -p ${kOutputDir}

InfoPrint "download source code"
git clone \
  --depth=1 \
  --branch=${kUBootSrcRemoteBranchTag} \
  ${kUBootSrcRemoteRepoUrl} ${kUBootSrcLocalPath} 

InfoPrint "set build envs."
export CROSS_COMPILE=arm-linux-gnueabihf-
export ARCH=arm
export MAKEFLAGS=j${kMaxJobs}

InfoPrint "conf source code"
make -C ${kUBootSrcLocalPath} ${kUbootConfName}

InfoPrint "build u-boot"
make -C ${kUBootSrcLocalPath}

InfoPrint "export u-boot.elf file to output dir"
cp ${kUBootGenFilePath} ${kUBootOutFilePath}

InfoPrint "unset env"
unset MAKEFLAGS
unset ARCH
unset CROSS_COMPILE

InfoPrint "-----------------------------------------------"
InfoPrint "Build uboot completed"
InfoPrint "-----------------------------------------------"
