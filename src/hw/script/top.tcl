# get-opt
package require cmdline

set parameters {
  {B.arg "" "Build Dir"}
  {O.arg "" "Output Dir"}
  {t.arg "" "BD-Target Name"}
  {U.arg "" "Path to XVC-TCL-Utilities-Dir"}
  {f.arg "" "FPGA Part"}
  {v.arg "" "Path to VerilogHDL-Files"}
  {x.arg "" "Path to XDC-Files"}
  {b.arg "" "Path to Top-BD-Script-File"}
  {p.arg "" "Path to PS-Preset-Script-File"}
}

array set arg [cmdline::getoptions argv ${parameters}]

set requiredParameters {B O t U f v x b p}
foreach iter ${requiredParameters} {
  if {$arg(${iter}) == ""} {
    error "Missing required parameter: -${iter}"
  } else {
    switch $arg(${iter}) \
      $arg(B) { set kBuildDir $arg(${iter}) }\
      $arg(O) { set kOutputDir $arg(${iter}) }\
      $arg(t) { set kBDName $arg(${iter})}\
      $arg(U) { set kTCLUtilitiesTopDir $arg(${iter}) }\
      $arg(f) { set kFPGAPart $arg(${iter}) }\
      $arg(v) { set kVerilogFiles $arg(${iter}) }\
      $arg(x) { set kXDCFiles $arg(${iter}) }\
      $arg(b) { set kTopBDScriptFile $arg(${iter}) }\
      $arg(p) { set kPSPresetFile $arg(${iter}) }\
      default { error "Input arguments error" }
  }
}
# include ErrStr and InfoStr
source ${kTCLUtilitiesTopDir}/color_render.tcl
# include NThreadsRunVivado
source ${kTCLUtilitiesTopDir}/get_max_threads.tcl

puts [InfoStr "---------------------------------------------"]
puts [InfoStr "Run Vivado to build XVC HW"]
puts [InfoStr "---------------------------------------------"]

# Go to build dir
puts [InfoStr "Go to xvc_hw build Directory: \n ${kBuildDir}"]
cd ${kBuildDir}

# Set project properties (create dummy(diskless) project)
set_part ${kFPGAPart}
set_property TARGET_LANGUAGE Verilog [current_project]
set_property DEFAULT_LIB work [current_project]

# Regarding source_mgmt_mode, see
# doc/faq/hw_script_faq.md
# chapter
# 1.1 About `set_property source_mgmt_mode All [current_project]`
set_property source_mgmt_mode All [current_project]

set_param general.maxThreads [NThreadsRunVivado]
puts [InfoStr "Max threads = [get_param general.maxThreads]"]

## STEP#1: setup design sources and constraints
#
#Read-in verilog files from source folder
puts [InfoStr "read-in src-verilog files: \n ${kVerilogFiles}"]
read_verilog ${kVerilogFiles}

# Read-in xdc files from source folder
puts [InfoStr "read-in src-xdc files: \n ${kXDCFiles}"]
read_xdc ${kXDCFiles}

# STEP#2: Create block diagram (bd) with ps(processor system) and jtag-axi
#
# Load ps preset
puts [InfoStr "read-in files for ps preset: \n ${kPSPresetFile}"]
source ${kPSPresetFile}

# read-in bd-created shell and execute it
puts [ InfoStr "read-in files for top xvc-bd file: \n ${kTopBDScriptFile}" ]
source ${kTopBDScriptFile}
init_xcv_system_bd ${kBDName}
create_root_design ""

# if create bd succseefully, read-in and make wrapper
set bd_files_path "${kBuildDir}/.srcs/sources_1/bd/${kBDName}/${kBDName}.bd" 

# create bd wrapper for top hw
set_property synth_checkpoint_mode None [ get_files ${bd_files_path} ]
# synth_checkpoint_mode refer to doc/faq/hw_script_faq.md
# chapter
# 1.2 About `set_property synth_checkpoint_mode None...

generate_target all [ get_files ${bd_files_path} ]
set top_bd_wrapper_name "${kBDName}_wrapper"
set top_bd_wrapper_path \
  "${kBuildDir}/.gen/sources_1/bd/${kBDName}/hdl/${top_bd_wrapper_name}.v"
puts [InfoStr \
  "read-in xvc-bd-wrapper-hdl file: \n ${top_bd_wrapper_path}"]
read_verilog ${top_bd_wrapper_path}

# STEP#3: 
# run synthesis, report utilization and timing estimates, 
# write checkpoint design
#
# Regarding reorder_files -auto
# See
# https://www.xilinx.com/support/answers/51688.html
#
puts [InfoStr "Run Synthesis"]
reorder_files -auto
synth_design -top ${top_bd_wrapper_name} -part ${kFPGAPart} -flatten rebuilt 

puts [InfoStr "Genetrate dcp/Report for Synthesis"]
write_checkpoint -force "${kOutputDir}/post_synth.dcp"
report_timing_summary -file "${kOutputDir}/post_synth_timing_summary.rpt"
report_power -file "${kOutputDir}/post_synth_power.rpt"
report_compile_order -file "${kOutputDir}/post_synth_compile_order.rpt"

# STEP#4: 
# run placement and logic optimzation, 
# report utilization and timing estimates, write checkpoint design
#
puts [InfoStr "Run Implementions"]
opt_design
place_design
phys_opt_design

puts [InfoStr "Genetrate dcp/Report for Implementions"]
#write_checkpoint -force "${kOutputDir}/post_place"
report_timing_summary -file "${kOutputDir}/post_place_timing_summary.rpt"

# STEP#5: 
# run router, report actual utilization and timing, 
# write checkpoint design, run drc, write verilog and xdc out
#
puts [InfoStr "Run Route"]
route_design
write_checkpoint -force "${kOutputDir}/post_route"

puts [InfoStr "Genetrate dcp/Report for Route"]
report_timing_summary -file "${kOutputDir}/post_route_timing_summary.rpt"
report_timing -sort_by group -max_paths 100 -path_type summary -file \
  "${kOutputDir}/post_route_timing.rpt"
report_clock_utilization -file "${kOutputDir}/clock_util.rpt"
report_utilization -file "${kOutputDir}/post_route_util.rpt"
report_power -file "${kOutputDir}/post_route_power.rpt"
report_drc -file "${kOutputDir}/post_imp_drc.rpt"

puts [InfoStr "Genetrate Summrized xdc/hdl file"]
write_verilog -force "${kOutputDir}/${kBDName}_impl_netlist.v"
write_xdc -no_fixed_only -force "${kOutputDir}/${kBDName}_impl.xdc"

# STEP#6: generate a bitstream
# 
puts [InfoStr "Genetrate Bitstream and debug info"]
write_bitstream -force "${kOutputDir}/${kBDName}.bit"
write_debug_probes -force "${kOutputDir}/${kBDName}.itx"

# STEP#7: Export the implemented hardware system to the Vitis environment
#
#
puts [InfoStr "Genetrate xsa File"]
open_checkpoint "${kOutputDir}/post_route.dcp"
# Regarding ``open_checkpoint "${kOutputDir}/post_route.dcp"
# see
# doc/faq/hw_script_faq.md
# Chapter
# 1.3 About `open_checkpoint <post-route.dcp>`

set_property platform.design_intent.embedded true [current_project]
set_property platform.design_intent.server_managed false [current_project]
set_property platform.design_intent.external_host false [current_project]
set_property platform.design_intent.datacenter false [current_project]
set_property platform.default_output_type "sd_card" [current_project]
# Regarding 
# set_property platform...
# Chapter 
# 1.5 About `set_property platform.design_intent...`

write_hw_platform -fixed -include_bit -force -verbose \
  "${kOutputDir}/${kBDName}.xsa"
validate_hw_platform -verbose "${kOutputDir}/${kBDName}.xsa"

puts [InfoStr "---------------------------------------------"]
puts [InfoStr "Run Vivado to build XVC HW has been completed"]
puts [InfoStr "---------------------------------------------"]


# Refer to here
# doc/faq/hw_script_faq.md
# Chapter
# 1.4 About `Critical warning of DDR clk to dqs seem can be ignore` 

