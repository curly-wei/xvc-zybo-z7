# Founction Redering string output
proc RStr {strs} {
  set kColorRBegin "\x1b\[1;31m"
  set kColorEnd "\x1b\[0m"
  return "${kColorRBegin}${strs}${kColorEnd}"
}
proc GStr {strs} {
  set kColorGBegin "\x1b\[1;32m"
  set kColorEnd "\x1b\[0m"
  return "${kColorGBegin}${strs}${kColorEnd}"
}

puts [GStr "--------------------------------------"]
puts [GStr "UserINFO: Start to Build FSBL"]
puts [GStr "--------------------------------------"]

set kAPPName "xvc_fsbl"
set kPlatformName "${kAPPName}_pf"
set kDomainName "${kAPPName}_dom"
set kBuildDir "[pwd]"
set kXSAFilePath "${kBuildDir}/xvc_server_hw/xvc_system_top.xsa"
set kOutputDir "${kBuildDir}/xvc_server_os/fsbl" 


puts [GStr "--------------------------------------"]
puts [GStr "UserINFO: Build FSBL completed"]
puts [GStr "--------------------------------------"]