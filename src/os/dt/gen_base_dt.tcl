
# get-opt
package require cmdline

set parameters {
  {B.arg "" "Build Dir"}
  {O.arg "" "Output Dir"}
  {U.arg "" "Path to XVC-TCL-Utilities-Dir"}
  {x.arg "" "Path to xvc_server_hw.xsa"}
  {R.arg "" "Top-Dir to local Xilinx-DT-Repository"}
}

array set arg [cmdline::getoptions argv ${parameters}]

set requiredParameters {B O U x R}
foreach iter ${requiredParameters} {
  if {$arg(${iter}) == ""} {
    error "Missing required parameter: -${iter}"
  } else {
    switch $arg(${iter}) \
      $arg(B) { set kBuildDir $arg(${iter}) }\
      $arg(O) { set kOutputDir $arg(${iter}) } \
      $arg(U) { set kTCLUtilitiesTopPath $arg(${iter}) }\
      $arg(x) { set kXSAFilePath $arg(${iter}) }\
      $arg(R) { set kXilDTSrcLocalPath $arg(${iter}) }\
      default { error "Input arguments error" }
  }
}

# Scan and Read-in tcl utilities
foreach tcl_utility_files ${kTCLUtilitiesTopPath} {
  source ${tcl_utility_files}
}

puts [InfoStr "-----------------------------------------------"]
puts [InfoStr "Start to Generate Device Tree for xvc"]
puts [InfoStr "-----------------------------------------------"]

puts [InfoStr "go to work directory"]
cd ${kBuildDir}

puts [InfoStr "set DT repositary from xilinx-git"]
hsi::set_repo_path ${kXilDTSrcLocalPath}

puts [InfoStr "read xsa file"]
hsi::open_hw_design -verbose ${kXSAFilePath}

puts [InfoStr "create DT project from xsa file"]
hsi::create_sw_design device-tree -os device_tree -proc ps7_cortexa9_0

puts [InfoStr "Set DT-Overlay ON"]
common::set_property CONFIG.dt_overlay true [hsi::get_os]

puts [InfoStr "Set DT-ZOCL ON"]
common::set_property CONFIG.dt_zocl true [hsi::get_os]    

puts [InfoStr "Generate DT"]
hsi::generate_target -dir ${kOutputDir}


puts [InfoStr "-----------------------------------------------"]
puts [InfoStr "Generate Device Tree has been completed"]
puts [InfoStr "-----------------------------------------------"]
