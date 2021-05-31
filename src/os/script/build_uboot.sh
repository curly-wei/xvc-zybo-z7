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

uboot_remote_repo="git@github.com:u-boot/u-boot.git"
uboot_local_dir="u-boot"
uboot_conf_name="xilinx_zynq_virt_defconfig"
max_jobs=12

git clone ${uboot_remote_repo} ${uboot_local_dir}
export CROSS_COMPILE=arm-linux-gnueabihf-
export ARCH=arm
make -f ${uboot_local_dir} ${uboot_conf_name}
make -f ${uboot_local_dir} -j${max_jobs}

GPrint "-----------------------------------------------"
GPrint "UserINFO: Build uboot completed"
GPrint "-----------------------------------------------"
