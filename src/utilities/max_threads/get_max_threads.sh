# /bin/bash
MaxThreads() {
  if [[ ${OSTYPE} == "win32" ]]; then
    return ${NUMBER_OF_PROCESSORS}
  else; then
    return $(nproc)
  fi
}