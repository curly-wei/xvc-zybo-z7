
# get-opt
package require cmdline

set parameters {
  {B.arg "" "Build Dir"}
  {O.arg "" "Output Dir"}
  {U.arg "" "Path to XVC-TCL-Utilities-Dir"}
  {x.arg "" "Path to xvc_server_hw.xsa"}
}

array set arg [cmdline::getoptions argv ${parameters}]

set requiredParameters {B O U x}
foreach iter ${requiredParameters} {
  if {$arg(${iter}) == ""} {
    error "Missing required parameter: -${iter}"
  } else {
    if {$arg(${iter}) == $arg(B)} {
      set kBuildDir $arg(${iter})
    } elseif {$arg(${iter}) == $arg(O)} {
      set kOutputDir $arg(${iter})
    } elseif {$arg(${iter}) == $arg(U)} {
      set kTCLUtilitiesTopDir $arg(${iter})
    } elseif {$arg(${iter}) == $arg(x)} {
      set kXSAFilePath $arg(${iter})
    } else {
      error "Input arguments error"
    }
  }
}

# include ErrStr and InfoStr
source ${kTCLUtilitiesTopDir}/tcl/color_render.tcl

puts [InfoStr "-----------------------------------------------"]
puts [InfoStr "Start to Generate Device Tree for xvc"]
puts [InfoStr "-----------------------------------------------"]

#Output file(cp) properties

# Local/Remote Repo property
set kXilDTSrcRepoURL "https://github.com/Xilinx/device-tree-xlnx.git"
set kXilDTSrcLocalDirName "device-tree-xlnx"
set kXilDTSrcRemoteBranchTag "master"
set kXilDTSrcLocalPath "${kBuildDir}/${kXilDTSrcLocalDirName}"

puts [InfoStr "clone dt repo from remote"]
exec -ignorestderr \
  git clone \
  --depth=1 \
  --branch=${kXilDTSrcRemoteBranchTag} \
  ${kXilDTSrcRepoURL} ${kXilDTSrcLocalPath}
# if no "-ignorestderr" then build will be interruped,
# because git display download message with stderr

puts [InfoStr "Set DT repositary from xilinx-git"]
hsi::set_repo_path ${kXilDTSrcLocalPath}

puts [InfoStr "check xsa file if exist"]
if { [file exist ${kXSAFilePath}] == 1} {
  puts [InfoStr "Found xsa file, located at:"]
  puts [InfoStr [file normalize ${kXSAFilePath}] ]
} else {
  error [ErrStr "xsa file does not exist"]
}

puts [InfoStr "read xsa file"]
hsi::open_hw_design ${kXSAFilePath}

puts [InfoStr "create DT project from xsa file"]
hsi::create_sw_design device-tree -os device_tree -proc ps7_cortexa9_0

puts [InfoStr "Generate DT"]
hsi::generate_target -dir ${kOutputDir}

puts [InfoStr "-----------------------------------------------"]
puts [InfoStr "Generate Device Tree completed"]
puts [InfoStr "-----------------------------------------------"]
