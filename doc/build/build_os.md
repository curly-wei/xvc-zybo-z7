# How to configure os (binding device-tree, boot-loader, bit-stream-from-FPGA)

## 0 Necessary packages for build os

* Only support Linux enviroment for build
* Vitis 2020.2, which `bin-path` contented in your `$PATH` env.var
* uboot-tools
* device-tree-compiler (dtc)
* [Linaro GCC Compiler version 7.5, arm-linux-gnueabihf](https://www.linaro.org/downloads/)
* package for build Linux kernel
  * ncurses lib32-ncurses gawk flex bison openssl dkms libelf pciutils systemd-libs autoconf (for Archlinux)
  * Ubuntu/Debian refer to [here](https://wiki.ubuntu.com/Kernel/BuildYourOwnKernel)
  
## 1 Build FSBL (First Stage Boot Loader)

if `build` folder doesn't exist in the root dir of this project, then

create `build` folder in the root dir of this project.

`cd` to build folder

``` bash
# Using bash in the root directory of this project
$ cd build
$ xsct -eval source ../src/os/script/gen_fsbl.tcl 
```

## 2 Build DT (device tree)

if `build` folder doesn't exist in the root dir of this project, then

create `build` folder in the root dir of this project.

`cd` to build folder

``` bash
# Using bash in the root directory of this project
$ cd build
$ xsct -eval source ../src/os/script/gen_fsbl.tcl 
```
