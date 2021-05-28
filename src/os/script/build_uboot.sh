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

uboot_remote_repo="git://git.denx.de/u-boot.git"
uboot_branch_zybo_z7="u-boot-2017.11-zynq-zybo-z7"

git clone ${uboot_remote_repo} ${uboot_branch_zybo_z7}
export CROSS_COMPILE=arm-linux-gnueabihf-
export ARCH=arm
make zynq_zyboz7_config 
make

GPrint "-----------------------------------------------"
GPrint "UserINFO: Build uboot completed"
GPrint "-----------------------------------------------"
