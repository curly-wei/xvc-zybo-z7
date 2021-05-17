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

setws ${kOutputDir}
puts [GStr "UserINFO: clear previous build objects"]
file delete -force ${kOutputDir}

puts [GStr "UserINFO: check xsa file if exist"]
if { [file exist ${kXSAFilePath}] == 1} {
  puts [GStr "UserINFO: Found xsa file, located at:"]
  puts [GStr [file normalize ${kXSAFilePath}] ]
} else {
  error [RStr "UserERROR: xsa file does not exist"]
}

puts [GStr "UserINFO: create pf"]
platform create \
  -name ${kPlatformName} \
  -hw ${kXSAFilePath}


puts [GStr "UserINFO: create domain"]
domain create \
  -name ${kDomainName} \
  -os standalone \
  -proc ps7_cortexa9_0

puts [GStr "UserINFO: set bsplib xilffs"]
bsp setlib xilffs

puts [GStr "UserINFO: generate pf"]
platform generate

puts [GStr "UserINFO: create app"]
app create \
  -name ${kAPPName} \
  -platform ${kPlatformName} \
  -domain ${kDomainName} \
  -template {Zynq FSBL} 

puts [GStr "UserINFO: conf app"]
app config \
  -name ${kAPPName} \
  define-compiler-symbols {FSBL_DEBUG_INFO}

puts [GStr "UserINFO: build app"]
app build -name ${kAPPName} 

#exec bootgen -arch zynq -image output.bif -w -o "${kOutputDir}/BOOT.BIN"

puts [GStr "--------------------------------------"]
puts [GStr "UserINFO: Build FSBL completed"]
puts [GStr "--------------------------------------"]