# Founction Redering string output
proc ErrStr {strs} {
  set kColorRBegin "\x1b\[1;31m"
  set kColorEnd "\x1b\[0m"
  return "UserERROR: ${kColorRBegin}${strs}${kColorEnd}"
}
proc InfoStr {strs} {
  set kColorGBegin "\x1b\[1;32m"
  set kColorEnd "\x1b\[0m"
  return "UserINFO: ${kColorGBegin}${strs}${kColorEnd}"
}

puts [InfoStr "-----------------------------------------------"]
puts [InfoStr "Start to Generate Device Tree for xvc"]
puts [InfoStr "-----------------------------------------------"]

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

puts [InfoStr "clear previous build objects"]
file delete -force ${kBuildDir} ${kBaseDTGenDir}

puts [InfoStr "create work(build) dir"]
file mkdir ${kBuildDir}

puts [InfoStr "create output dir"]
file mkdir ${kBaseDTGenDir}

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
hsi::generate_target -dir ${kBaseDTGenDir}

puts [InfoStr "-----------------------------------------------"]
puts [InfoStr "Generate Device Tree completed"]
puts [InfoStr "-----------------------------------------------"]
