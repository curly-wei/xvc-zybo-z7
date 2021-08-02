# /bin/tclsh
proc ErrStr {strs} {
  set kColorRBegin "\x1b\[1;31m"
  set kColorEnd "\x1b\[0m"
  return "${kColorRBegin}UserERROR: ${strs}${kColorEnd}"
}
proc InfoStr {strs} {
  set kColorGBegin "\x1b\[1;32m"
  set kColorEnd "\x1b\[0m"
  return "${kColorGBegin}UserINFO: ${strs}${kColorEnd}"
}