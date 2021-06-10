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
InfoPrint "Start to build busybox"
InfoPrint "-----------------------------------------------"

# IO properties
kBuildDir="$(realpath $(pwd))"
kOutputDir="${kBuildDir}/xvc_server_os/busybox"

# Local/Remote Repo property
kBusyboxSrcRemoteRepoUrl="https://git.busybox.net/busybox/"
kBusyboxSrcRemoteBranchTag="master"
kBusyboxSrcLocalDirName="build_busybox"
kBusyboxSrcLocalPath="${kBuildDir}/${kBusyboxSrcLocalDirName}"

#Build properties
kBusyboxConfName="defconfig"
kMaxJobs="$(( $(nproc) / 2 ))"

#Output file(cp) properties
kBusyboxGenFsDirName="_install"
kBusyboxGenFsDirPath="${kBusyboxSrcLocalPath}/${kBusyboxGenFsDirName}"

InfoPrint "clean previously build object"
rm -rf ${kBusyboxSrcLocalPath} ${kOutputDir}

InfoPrint "create output dir"
mkdir -p ${kOutputDir}

InfoPrint "download source code"
git clone \
  --depth=1 \
  --branch=${kBusyboxSrcRemoteBranchTag} \
  ${kBusyboxSrcRemoteRepoUrl} ${kBusyboxSrcLocalPath}

InfoPrint "set build envs."
export CROSS_COMPILE=arm-linux-gnueabihf-
export ARCH=arm
export MAKEFLAGS=j${kMaxJobs}

InfoPrint "conf source code"
make -C ${kBusyboxSrcLocalPath} ${kBusyboxConfName}

InfoPrint "build busybox"
make -C ${kBusyboxSrcLocalPath}

InfoPrint "generate busybox root dir"
make -C ${kBusyboxSrcLocalPath} install

InfoPrint "create some sys dir for busybox root dir"
mkdir -p\
  "${kBusyboxGenFsDirPath}/etc/rc.d" \
  "${kBusyboxGenFsDirPath}/var/log" \
  "${kBusyboxGenFsDirPath}/root" \
  "${kBusyboxGenFsDirPath}/proc" \
  "${kBusyboxGenFsDirPath}/sys" \
  "${kBusyboxGenFsDirPath}/srv" \
  "${kBusyboxGenFsDirPath}/boot" \
  "${kBusyboxGenFsDirPath}/mnt" \
  "${kBusyboxGenFsDirPath}/tmp" \
  "${kBusyboxGenFsDirPath}/home" \
  "${kBusyboxGenFsDirPath}/dev" \
  "${kBusyboxGenFsDirPath}/lib"

InfoPrint "export busybox root dir to output dir"
cp -r "${kBusyboxGenFsDirPath}" ${kOutputDir}

InfoPrint "unset env"
unset MAKEFLAGS
unset ARCH
unset CROSS_COMPILE

InfoPrint "-----------------------------------------------"
InfoPrint "Build busybox completed"
InfoPrint "-----------------------------------------------"
