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

StdErrPrintExit  "ee"

GPrint "--------------------------------------"
GPrint "UserINFO: Start to build uboot"
GPrint "--------------------------------------"

GPrint "--------------------------------------"
GPrint "UserINFO: Build uboot completed"
GPrint "--------------------------------------"
