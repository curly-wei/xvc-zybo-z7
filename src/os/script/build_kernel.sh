# /bin/bash
function StdErrPrintExit {
  local kColorRed='\x1b[0;31m'
  local kColorEnd='\x1b[0m'
  printf "${kColorRed}$1${kColorEnd}\n" >&2
  exit
} 

function InfoPrint {
  local kColorGreen='\x1b[0;32m'
  local kColorEnd='\x1b[0m'
  printf "UserINFO: ${kColorGreen}$1${kColorEnd}\n"
}

InfoPrint "-----------------------------------------------"
InfoPrint "Start to build kernel"
InfoPrint "-----------------------------------------------"

# IO properties
kBuildDir="$(realpath $(pwd))"
kOutputDir="${kBuildDir}/xvc_server_os/kernel"

# Local/Remote Repo property
kKernelSrcRemoteRepoUrl="https://github.com/Xilinx/linux-xlnx.git"
kKernelSrcRemoteBranchTag="master"
kKernelSrcLocalDirName="build_kernel"
kKernelSrcLocalPath="${kBuildDir}/${kKernelSrcLocalDirName}"

#Build properties
kKernelConfName="xilinx_zynq_defconfig"
kMaxJobs="$(( $(nproc) / 2 ))"
kUImgLoadAddr="0x8000"

#Output file(cp) properties
kUImageGenDir="${kKernelSrcLocalPath}/arch/arm/boot/"
kUImageFileName="uImage"
kUImageGenPath="${kUImageGenDir}/${kUImageFileName}"

InfoPrint "clean previously build object"
rm -rf ${kKernelSrcLocalPath} ${kOutputDir}

InfoPrint "create output dir"
mkdir -p ${kOutputDir}

InfoPrint "download source code"
git clone \
  --depth=1 \
  --branch=${kKernelSrcRemoteBranchTag} \
  ${kKernelSrcRemoteRepoUrl} ${kKernelSrcLocalPath}

InfoPrint "set build envs."
export CROSS_COMPILE=arm-linux-gnueabihf-
export ARCH=arm
export INSTALL_PATH=${kOutputDir}
export MAKEFLAGS=j${kMaxJobs}

InfoPrint "conf source code"
make -C ${kKernelSrcLocalPath} ${kKernelConfName}

InfoPrint "build kernel"
make -C ${kKernelSrcLocalPath}

InfoPrint "generate uImage from build kernel"
make \
  -C ${kKernelSrcLocalPath} \
  UIMAGE_LOADADDR=${kUImgLoadAddr} \
  ${kUImageFileName}

InfoPrint "export kernel file to output dir"
cp ${kUImageGenPath} ${kOutputDir}

InfoPrint "unset env"
unset MAKEFLAGS
unset INSTALL_PATH
unset ARCH
unset CROSS_COMPILE

InfoPrint "-----------------------------------------------"
InfoPrint "Build kernel completed"
InfoPrint "-----------------------------------------------"
