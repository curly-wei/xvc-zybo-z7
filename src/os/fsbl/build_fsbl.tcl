
# get-opt
package require cmdline

set parameters {
  {B.arg "" "Build Dir"}
  {O.arg "" "Output Dir"}
  {t.arg "" "Target name of this project"}
  {U.arg "" "Path to XVC-TCL-Utilities-Dir"}
  {x.arg "" "Path to xvc_server_hw.xsa"}
}

array set arg [cmdline::getoptions argv ${parameters}]

set requiredParameters {B O t U x}
foreach iter ${requiredParameters} {
  if {$arg(${iter}) == ""} {
    error "Missing required parameter: -${iter}"
  } else {
    switch $arg(${iter}) \
      $arg(B) { set kBuildDir $arg(${iter}) } \
      $arg(O) { set kOutputDir $arg(${iter}) } \
      $arg(U) { set kTCLUtilitiesTopDir $arg(${iter}) } \
      $arg(t) { set kAPPName $arg(${iter})} \
      $arg(x) { set kXSAFilePath $arg(${iter}) } \
      default { error "Input arguments error" }
  }
}


# include ErrStr and InfoStr
source ${kTCLUtilitiesTopDir}/color_render.tcl

# include NThreadsRunVivado
source ${kTCLUtilitiesTopDir}/get_max_threads.tcl
set kMaxThreads [MaxThreads]

puts [InfoStr "-----------------------------------------------"]
puts [InfoStr "Run Vitist-XCST to build FSBL"]
puts [InfoStr "-----------------------------------------------"]

#Clean previous build
puts [InfoStr "remove previous build object"]
file delet -force ${kBuildDir}
file mkdir ${kBuildDir}

#Build properties
set kPlatformName "${kAPPName}_pf"
set kDomainName "${kAPPName}_dom"

puts [InfoStr "create/set work(build) dir"]
cd ${kBuildDir}
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

puts [InfoStr "active domain"]
domain active \
  ${kDomainName}

puts [InfoStr "set bsplib xilffs"]
bsp setlib xilffs

puts [InfoStr "generate pf"]
platform generate

puts [InfoStr "create app"]
app create -name ${kAPPName} \
  -platform ${kPlatformName} \
  -domain ${kDomainName} \
  -template {Zynq FSBL}

puts [InfoStr "conf app"]
app config \
  -name ${kAPPName} \
  define-compiler-symbols {FSBL_DEBUG_INFO}

app config \
  -name ${kAPPName} \
  -add compiler-misc {-std=c11}

puts [InfoStr "build app"]
app build -name ${kAPPName} 


#exec bootgen -arch zynq -image output.bif -w -o "${kOutputDir}/BOOT.BIN"

puts [InfoStr "------------------------------------------------"]
puts [InfoStr "Run Vitist-XCST to build FSBL has been completed"]
puts [InfoStr "------------------------------------------------"]
