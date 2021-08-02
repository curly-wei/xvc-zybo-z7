# include ErrStr and InfoStr
source ${kTCLUtilitiesTopDir}/tcl/color_render.tcl

puts [InfoStr "-----------------------------------------------"]
puts [InfoStr "Run Vivado to build FSBL"]
puts [InfoStr "-----------------------------------------------"]

# IO properties
set kXSAFilePath "[pwd]/xvc_server_hw/xvc_system_top.xsa"
set kBuildDir "[pwd]/build_xvc_fsbl"
set kOutputDir "[pwd]/xvc_server_os/fsbl" 

#Build properties
set kAPPName "xvc_fsbl"
set kPlatformName "${kAPPName}_pf"
set kDomainName "${kAPPName}_dom"

#Output file(cp) properties
set kFSBLGenDir "${kBuildDir}/${kAPPName}/Debug"
set kFSBLGenFileName "${kAPPName}.elf"
set kFSBLGenPath "${kFSBLGenDir}/${kFSBLGenFileName}"

puts [InfoStr "clear previous build objects"]
file delete -force ${kOutputDir} ${kBuildDir}

puts [InfoStr "check xsa file if exist"]
if { [file exist ${kXSAFilePath}] == 1} {
  puts [InfoStr "Found xsa file, located at:"]
  puts [InfoStr [file normalize ${kXSAFilePath}] ]
} else {
  error [ErrStr "xsa file does not exist"]
}

puts [InfoStr "create/set work(build) dir"]
setws ${kBuildDir}

puts [InfoStr "create output dir"]
file mkdir ${kOutputDir} 

puts [InfoStr "create pf"]
platform create \
  -name ${kPlatformName} \
  -hw ${kXSAFilePath}


puts [InfoStr "create domain"]
domain create \
  -name ${kDomainName} \
  -os standalone \
  -proc ps7_cortexa9_0

puts [InfoStr "set bsplib xilffs"]
bsp setlib xilffs

puts [InfoStr "generate pf"]
platform generate

puts [InfoStr "create app"]
app create \
  -name ${kAPPName} \
  -platform ${kPlatformName} \
  -domain ${kDomainName} \
  -template {Zynq FSBL} 

puts [InfoStr "conf app"]
app config \
  -name ${kAPPName} \
  define-compiler-symbols {FSBL_DEBUG_INFO}

puts [InfoStr "build app"]
app build -name ${kAPPName} 

puts [InfoStr "export fsbl.elf file to output dir"]
file copy ${kFSBLGenPath} ${kOutputDir}

#exec bootgen -arch zynq -image output.bif -w -o "${kOutputDir}/BOOT.BIN"

puts [InfoStr "-----------------------------------------------"]
puts [InfoStr "Run Vivado to build FSBL has completed"]
puts [InfoStr "-----------------------------------------------"]
