# A Vivado script that demonstrates a very simple RTL-to-bitstream batch flow
#
# NOTE:  typical usage would be "vivado -mode tcl -source create_bft_batch.tcl" 
#
# ref: 
# https://tinyurl.com/p7y7wu3j
#
## STEP#0:  Prepare
#

#Define output directory and workspace(BuildDir)
set kBuildDir "[pwd]"
set kOutputDir "${kBuildDir}/xvc_server_hw" 

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

puts [GStr "============================================="]
puts [GStr "UserINFO: Start to build xvc_hw"]
puts [GStr "============================================="]

#clean previois buildedcd folder and design
puts [GStr "UserINFO: clear previous build objects"]
set kVivadoDefaultGenOutFolders [ \
  list \
  "${kBuildDir}/.srcs" \
  "${kBuildDir}/.gen" \
  "${kBuildDir}/.Xil" \
  "${kBuildDir}/NA" \
]
set purged_dirs [ concat ${kVivadoDefaultGenOutFolders} ${kOutputDir} ]
foreach dir ${purged_dirs} {
  file delete -force [ glob -nocomplain ${dir} ]
}

# Create director for output objects
file mkdir ${kOutputDir}

#Define name of xvc-bd (sub project)
set kBDName "xvc_system"

#Set project properties (create dummy(diskless) project)
set kFPGAPart "xc7z010clg400-1"
set_part ${kFPGAPart}
#set_property BOARD_PART "digilentinc.com:zybo-z7-10:part0:1.0" [current_project]
set_property TARGET_LANGUAGE Verilog [current_project]
set_property DEFAULT_LIB work [current_project]

set_property source_mgmt_mode All [current_project]
# Regarding source_mgmt_mode, see
# doc/faq/hw_script_faq.md
# chapter
# 1.1 About `set_property DEFAULT_LIB work [current_project]`

#Define directory of source code and IP (dirs of srcs)
set kTopSrcsDir [file normalize "${kBuildDir}/../src/hw"]
set kTopScriptDir "${kTopSrcsDir}/script"
set kVerilogSrcDirs [list "${kTopSrcsDir}/hdl" ]
set kXDCSrcDirs [list "${kTopSrcsDir}/xdc" ]
set kIPSrcDirs [list "${kTopSrcsDir}/ip" ]


# Define preset file for ps
set kPSPresetFile "${kTopScriptDir}/zybo-z7-ps-preset.tcl"

# Define script of bd-top file for ps
set kTopBDScriptFile "${kTopScriptDir}/bd_system.tcl"

#Set max-thread to build
proc NumThreadsRun {} {
  set kVivadoMaxCoreSupported 8
  set OS ${::tcl_platform(platform)}
  if { ${OS} == "Windows" } {
    set cpu_core_count [ expr ${::env(NUMBER_OF_PROCESSORS)}/2 ]
  } else {
    set cpu_core_count [ expr [exec nproc]/2 ]
  }
  if { ${cpu_core_count} > ${kVivadoMaxCoreSupported} } {
    set cpu_core_count  ${kVivadoMaxCoreSupported}
  }
  return ${cpu_core_count}
}

set_param general.maxThreads [NumThreadsRun]
puts [GStr "UserINFO: Max threads = [get_param general.maxThreads]"]

## STEP#1: setup design sources and constraints
#
#Read-in verilog files from source folder
foreach dirs ${kVerilogSrcDirs} {
  set verilog_files [glob -nocomplain "${dirs}/*.v" ]
  if { ${verilog_files} != "" } {
    read_verilog ${verilog_files}
    puts [GStr "UserINFO: read-in src-verilog files: \n${verilog_files}"]
  } 
}

# Read-in xdc files from source folder
foreach dirs ${kXDCSrcDirs} {
  set xdc_files [glob -nocomplain "${dirs}/*.xdc" ]
  if { ${xdc_files} != "" } {
    read_xdc ${xdc_files}
    puts [GStr "UserINFO: read-in xdc files: \n${xdc_files}"]
  }
}

# Read-in ip files from source folders
set has_ip_files 0
foreach dirs ${kIPSrcDirs} {
  set ip_files [glob -nocomplain "${dirs}/*/*.xci" ]
  if { ${ip_files} != "" } {
    read_ip ${ip_files}
    set ${has_ip_files} 1
    puts [GStr "UserINFO: read-in ip files: \n${ip_files}"]
  }
}

# Set ip repository path (not Xilinx ip, is 3rd party ip) if its exist
if { ${has_ip_files} == 1 } {
  set_property IP_REPO_PATHS ${kIPSrcDirs} [current_fileset]
  update_ip_catalog
}

# STEP#2: Create block diagram (bd) with ps(processor system) and jtag-axi
#
# Load ps preset
if { [ file exists ${kPSPresetFile} ] == 1 } {
  puts [GStr "UserINFO: read-in files for ps preset: \n${kPSPresetFile}"]
  source ${kPSPresetFile}
} else {
  error [ RStr
    "UserERROR: read-in files for ps preset: < ${kPSPresetFile} > fail. \
    This file is necessary, please check again\
  "]  
    
}

# create the BD-Design
if { [ file exists ${kTopBDScriptFile} ] == 1 } {
  # read-in bd-created shell and execute it
  puts [GStr \
    "UserINFO: read-in files for top xvc-bd file: \n ${kTopBDScriptFile}"]
  source ${kTopBDScriptFile}
  init_xcv_system_bd ${kBDName}
  create_root_design ""
  # if create bd succseefully, read-in and make wrapper
  set bd_file_and_path ".srcs/sources_1/bd/${kBDName}/${kBDName}.bd" 
} else {
  error [RStr "
    UserERROR: read-in files for ps preset: < ${kTopBDScriptFile} > fail. \
    This file is necessary, please check again\
  "]
}

# create bd wrapper for top hw
set_property synth_checkpoint_mode None [ get_files ${bd_file_and_path} ]
# synth_checkpoint_mode refer to doc/faq/hw_script_faq.md
# chapter
# 1.2 About `set_property synth_checkpoint_mode None...

generate_target all [ get_files ${bd_file_and_path} ]
set top_bd_wrapper_name "${kBDName}_wrapper"
set top_bd_wrapper_path \
  "${kBuildDir}/.gen/sources_1/bd/${kBDName}/hdl/${top_bd_wrapper_name}.v"
puts [GStr \
  "UserINFO: read-in xvc-bd-wrapper-hdl file: \n${top_bd_wrapper_path}"]
read_verilog ${top_bd_wrapper_path}

# STEP#3: 
# run synthesis, report utilization and timing estimates, 
# write checkpoint design
#
# Regarding reorder_files -auto
# See
# https://www.xilinx.com/support/answers/51688.html
#
puts [GStr "UserINFO: Run Synthesis"]
reorder_files -auto
synth_design -top ${top_bd_wrapper_name} -part ${kFPGAPart} -flatten rebuilt 

puts [GStr "UserINFO: Genetrate dcp/Report for Synthesis"]
write_checkpoint -force "${kOutputDir}/post_synth.dcp"
report_timing_summary -file "${kOutputDir}/post_synth_timing_summary.rpt"
report_power -file "${kOutputDir}/post_synth_power.rpt"
report_compile_order -file "${kOutputDir}/post_synth_compile_order.rpt"

# STEP#4: 
# run placement and logic optimzation, 
# report utilization and timing estimates, write checkpoint design
#
puts [GStr "UserINFO: Run Implementions"]
opt_design
place_design
phys_opt_design

puts [GStr "UserINFO: Genetrate dcp/Report for Implementions"]
#write_checkpoint -force "${kOutputDir}/post_place"
report_timing_summary -file "${kOutputDir}/post_place_timing_summary.rpt"

# STEP#5: 
# run router, report actual utilization and timing, 
# write checkpoint design, run drc, write verilog and xdc out
#
puts [GStr "UserINFO: Run Route"]
route_design
write_checkpoint -force "${kOutputDir}/post_route"

puts [GStr "UserINFO: Genetrate dcp/Report for Route"]
report_timing_summary -file "${kOutputDir}/post_route_timing_summary.rpt"
report_timing -sort_by group -max_paths 100 -path_type summary -file \
  "${kOutputDir}/post_route_timing.rpt"
report_clock_utilization -file "${kOutputDir}/clock_util.rpt"
report_utilization -file "${kOutputDir}/post_route_util.rpt"
report_power -file "${kOutputDir}/post_route_power.rpt"
report_drc -file "${kOutputDir}/post_imp_drc.rpt"

puts [GStr "UserINFO: Genetrate Summrized xdc/hdl file"]
write_verilog -force "${kOutputDir}/${kBDName}_top_impl_netlist.v"
write_xdc -no_fixed_only -force "${kOutputDir}/${kBDName}_top_impl.xdc"

# STEP#6: generate a bitstream
# 
puts [GStr "UserINFO: Genetrate Bitstream and debug info"]
write_bitstream -force "${kOutputDir}/${kBDName}_top.bit"
write_debug_probes -force "${kOutputDir}/${kBDName}_top.itx"

# STEP#7: Export the implemented hardware system to the Vitis environment
#
#
puts [GStr "UserINFO: Genetrate xsa File"]
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
  "${kOutputDir}/${kBDName}_top.xsa"
validate_hw_platform -verbose "${kOutputDir}/${kBDName}_top.xsa"

puts [GStr "============================================="]
puts [GStr "UserINFO: Build xvc_hw completed"]
puts [GStr "============================================="]

#start_gui

# Refer to here
# doc/faq/hw_script_faq.md
# Chapter
# 1.4 About `Critical warning of DDR clk to dqs seem can be ignore` 

