# /bin/tclsh
proc MaxThreads {} {
  set OS ${::tcl_platform(platform)}
  if { ${OS} == "Windows" } {
    set kNThreads ${::env(NUMBER_OF_PROCESSORS)}
  } else {
    set kNThreads [exec nproc]
  }
  return ${kNThreads}
}

proc NThreadsRunVivado {} {
  set kThisPCMaxThreads [MaxThreads]
  set kVivadoMaxCoreSupported 8
  if { ${kThisPCMaxThreads} > ${kVivadoMaxCoreSupported} } {
    return ${kVivadoMaxCoreSupported}
  } else {
    return ${kThisPCMaxThreads}
  }
}