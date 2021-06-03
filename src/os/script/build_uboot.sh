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
GPrint "UserINFO: Start to build uboot"
GPrint "-----------------------------------------------"

# IO properties
kBuildDir="$(realpath $(pwd))"
kOutputDir="${kBuildDir}/xvc_server_os/u-boot"

# Local/Remote Repo property
kUBootSrcRemoteRepoUrl="git@github.com:u-boot/u-boot.git"
kUBootSrcRemoteBranchTag="master"
kUBootSrcLocalDirName="u-boot"
kUBootSrcLocalPath="${kBuildDir}/${kUBootSrcLocalDirName}"

#Build properties
kUbootConfName="xilinx_zynq_virt_defconfig"
kMaxJobs="$(( $(nproc) / 2 ))" 

#Output file(cp) properties
kUBootGenFileName="u-boot"
kUBootOutFileName="u-boot.elf"

GPrint "UserINFO: clean previously build object"
rm -rf ${kUBootSrcLocalPath} ${kOutputDir}

GPrint "UserINFO: create output dir"
mkdir -p ${kOutputDir}

GPrint "UserINFO: download source code"
git clone \
  --depth=1 \
  --branch=${kUBootSrcRemoteBranchTag} \
  ${kUBootSrcRemoteRepoUrl} ${kUBootSrcLocalPath} 

GPrint "UserINFO: set build envs."
export CROSS_COMPILE=arm-linux-gnueabihf-
export ARCH=arm
export MAKEFLAGS=j${kMaxJobs}

GPrint "UserINFO: conf source code"
make -C ${kUBootSrcLocalPath} ${kUbootConfName}

GPrint "UserINFO: build u-boot"
make -C ${kUBootSrcLocalPath}

GPrint "UserINFO: export u-boot.elf file to output dir"
cp "${kUBootSrcLocalPath}/${kUBootGenFileName}" \
  "${kOutputDir}/${kUBootOutFileName}"

GPrint "UserINFO: unset env"
unset MAKEFLAGS
unset ARCH
unset CROSS_COMPILE

GPrint "-----------------------------------------------"
GPrint "UserINFO: Build uboot completed"
GPrint "-----------------------------------------------"
