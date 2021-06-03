# /bin/bash
function StdErrPrintExit {
  local kColorRed='\x1b[0;31m'
  local kColorEnd='\x1b[0m'
  printf "${kColorRed}$1${kColorEnd}\n" >&2
  exit
} 

function GPrint {
  local kColorGreen='\x1b[0;32m'
  local kColorEnd='\x1b[0m'
  printf "${kColorGreen}$1${kColorEnd}\n"
}

GPrint "-----------------------------------------------"
GPrint "UserINFO: Start to build kernel"
GPrint "-----------------------------------------------"

# IO properties
kBuildDir="$(realpath $(pwd))"
kOutputDir="${kBuildDir}/xvc_server_os/kernel"

# Local/Remote Repo property
kKernelSrcRemoteRepoUrl="https://github.com/Xilinx/linux-xlnx.git"
kKernelSrcRemoteBranchTag="master"
kKernelSrcLocalDirName="linux-xlnx"
kKernelSrcLocalPath="${kBuildDir}/${kKernelSrcLocalDirName}"

#Build properties
kKernelConfName="xilinx_zynq_defconfig"
kMaxJobs="$(( $(nproc) / 2 ))"
kUImgLoadAddr="0x8000"

#Output file(cp) properties
kUImageGenDir="${kKernelSrcLocalPath}/arch/arm/boot/"
kUImageFileName="uImage"

GPrint "UserINFO: clean previously build object"
rm -rf ${kKernelSrcLocalPath} ${kOutputDir}

GPrint "UserINFO: create output dir"
mkdir -p ${kOutputDir}

GPrint "UserINFO: download source code"
git clone \
  --depth=1 \
  --branch=${kKernelSrcRemoteBranchTag} \
  ${kKernelSrcRemoteRepoUrl} ${kKernelSrcLocalPath}

GPrint "UserINFO: set build envs."
export CROSS_COMPILE=arm-linux-gnueabihf-
export ARCH=arm
export INSTALL_PATH=${kOutputDir}
export MAKEFLAGS=j${kMaxJobs}

GPrint "UserINFO: conf source code"
make -C ${kKernelSrcLocalPath} ${kKernelConfName}

GPrint "UserINFO: build kernel"
make -C ${kKernelSrcLocalPath}

GPrint "UserINFO: generate uImage from build kernel"
make \
  -C ${kKernelSrcLocalPath} \
  UIMAGE_LOADADDR=${kUImgLoadAddr} \
  ${kUImageFileName}

GPrint "UserINFO: export kernel file to output dir"
cp "${kUImageGenDir}/${kUImageFileName}" "${kOutputDir}"

GPrint "UserINFO: unset env"
unset MAKEFLAGS
unset INSTALL_PATH
unset ARCH
unset CROSS_COMPILE

GPrint "-----------------------------------------------"
GPrint "UserINFO: Build kernel completed"
GPrint "-----------------------------------------------"
