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
GPrint "UserINFO: Start to build busybox"
GPrint "-----------------------------------------------"

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

GPrint "UserINFO: clean previously build object"
rm -rf ${kBusyboxSrcLocalPath} ${kOutputDir}

GPrint "UserINFO: create output dir"
mkdir -p ${kOutputDir}

GPrint "UserINFO: download source code"
git clone \
  --depth=1 \
  --branch=${kBusyboxSrcRemoteBranchTag} \
  ${kBusyboxSrcRemoteRepoUrl} ${kBusyboxSrcLocalPath}

GPrint "UserINFO: set build envs."
export CROSS_COMPILE=arm-linux-gnueabihf-
export ARCH=arm
export MAKEFLAGS=j${kMaxJobs}

GPrint "UserINFO: conf source code"
make -C ${kBusyboxSrcLocalPath} ${kBusyboxConfName}

GPrint "UserINFO: build busybox"
make -C ${kBusyboxSrcLocalPath}

GPrint "UserINFO: generate busybox root dir"
make -C ${kBusyboxSrcLocalPath} install

GPrint "UserINFO: create some sys dir for busybox root dir"
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

GPrint "UserINFO: export busybox root dir to output dir"
cp -r "${kBusyboxGenFsDirPath}" ${kOutputDir}

GPrint "UserINFO: unset env"
unset MAKEFLAGS
unset ARCH
unset CROSS_COMPILE

GPrint "-----------------------------------------------"
GPrint "UserINFO: Build busybox completed"
GPrint "-----------------------------------------------"
