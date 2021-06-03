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

puts [GStr "-----------------------------------------------"]
puts [GStr "UserINFO: Start to Generate Device Tree for xvc"]
puts [GStr "-----------------------------------------------"]

# IO properties
set kXSAFilePath "[pwd]/xvc_server_hw/xvc_system_top.xsa"
set kBuildDir "[pwd]/build_xvc_dt"
set kBaseDTGenDir "${kBuildDir}/base_dt_gen" 

#Output file(cp) properties

# Local/Remote Repo property
set kXilDTSrcRepoURL "https://github.com/Xilinx/device-tree-xlnx.git"
set kXilDTSrcLocalDirName "device-tree-xlnx"
set kXilDTSrcRemoteBranchTag "master"
set kXilDTSrcLocalPath "${kBuildDir}/${kXilDTSrcLocalDirName}"

puts [GStr "UserINFO: clear previous build objects"]
file delete -force ${kBuildDir} ${kBaseDTGenDir}

puts [GStr "UserINFO: create work(build) dir"]
file mkdir ${kBuildDir}

puts [GStr "UserINFO: create output dir"]
file mkdir ${kBaseDTGenDir}

puts [GStr "UserINFO: clone dt repo from remote"]
exec -ignorestderr \
  git clone \
  --depth=1 \
  --branch=${kXilDTSrcRemoteBranchTag} \
  ${kXilDTSrcRepoURL} ${kXilDTSrcLocalPath}
# if no "-ignorestderr" then build will be interruped,
# because git display download message with stderr

puts [GStr "UserINFO: Set DT repositary from xilinx-git"]
hsi::set_repo_path ${kXilDTSrcLocalPath}

puts [GStr "UserINFO: check xsa file if exist"]
if { [file exist ${kXSAFilePath}] == 1} {
  puts [GStr "UserINFO: Found xsa file, located at:"]
  puts [GStr [file normalize ${kXSAFilePath}] ]
} else {
  error [RStr "UserERROR: xsa file does not exist"]
}

puts [GStr "UserINFO: read xsa file"]
hsi::open_hw_design ${kXSAFilePath}

puts [GStr "UserINFO: create DT project from xsa file"]
hsi::create_sw_design device-tree -os device_tree -proc ps7_cortexa9_0

puts [GStr "UserINFO: Generate DT"]
hsi::generate_target -dir ${kBaseDTGenDir}

puts [GStr "-----------------------------------------------"]
puts [GStr "UserINFO: Generate Device Tree completed"]
puts [GStr "-----------------------------------------------"]
