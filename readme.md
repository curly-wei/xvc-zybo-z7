# XVC for pynq-z2

Refer to Xilinx official documentation: [Xiilnx Virtual Cable(XVC)](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_2/ug973-vivado-release-notes-install-license.pdf) .

I'd like to make a similar one for [TUL pynq-z2 development board](https://www.tul.com.tw/ProductsPYNQ-Z2.html) with [non project TCL mode (page 22)](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2016_2/ug892-vivado-design-flows-overview.pdf).

## 0. Others link

### 0.1 (Official) Documentations will help you

``` bash
git clone git@github.com:curly-wei/xvc-pynq-z2-rsc.git
```

## 1 How to build hw

### 1.0 Before build

First,

make sure that the *Vivado* `bin` directory already exists in the `{PATH} of env.var`

You have 2 ways to build *hw*

1. vivado tcl-cli mode
2. vivado tcl-batch mode

The following sections (1.1, 1.2) will explain.

### 1.1 Using *vivado tcl-cli mode*

``` bash
# Using bash in the root directory of this project
$ mkdir build
$ cd build
$ vivado -mode tcl
```

After entry to the *Vivado tcl command line*

``` tclsh
# in the vivado tcl command line
Vivado% source ../src/hw/script/top.tcl
```

Or you can build before entry *Vivado tcl command line*

``` bash
# Using bash in the root directory of this project
$ mkdir build
$ cd build
$ vivado -mode tcl -source ../src/hw/script/top.tcl
```

After build, you can open GUI to check report

``` tclsh
# in the vivado tcl command line
Vivado% start_gui
```

### 1.2 Using *vivado tcl-batch mode*

``` bash
# Using bash in the root directory of this project
$ mkdir build
$ cd build
$ vivado -mode batch -source ../src/hw/script/top.tcl
```

### 1.3 Tips to reduce hardware build time

#### 1.3.1 Filter generated reports

You may have seen `report_****` in the `top.tcl`,

this command for generate report of build Vivado project.

Maybe not all reports are what you need,

therefore you can **Comment (#) report_\*\*\*\*** to reduce reports output,

then time of build also could be reduced.

#### 1.3.2 `write_checkpoint` maybe you don't need

From [Vivado Design Suite TclCommand Reference Guide, page 1800](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug835-vivado-tcl-commands.pdf),

explain the function about `write_checkpoint`

> Saves the design at any point in the design process, \
> so that you can quickly import it back into thetool as needed. \
> A design checkpoint (DCP) can contain \
> the netlist, the constraints, and any placement and routing information \
> from the implemented design.

The `.dcp` file need to write to disk,

compiler could interactive between disk and RAM,

so time cost of build could be increase since *write `.dcp` files to disk*

if we compile once to end (e.g. Using *vivado tcl-batch mode*),

and recomplie also clean all of previous generated object,

`write_checkpoint` maybe you don't need.

## 2. How to configure os (binding device-tree, boot-loader, bit-stream-from-FPGA)

### 2.0 Necessary packages for build os

* Vitis 2020.2, which `bin-path` contented in your `$PATH` env.var
* uboot-tools
* device-tree-compiler (dtc)

### 2.1 Build FSBL (First Stage Boot Loader)

`cd` to build folder, see [#1.1](###1.1-Using-*vivado-tcl-cli-mode*)

``` bash
# Using bash in the root directory of this project
$ cd build
$ xsct -eval source ../src/os/script/gen_fsbl.tcl 
```

## 3. How to build sw

### 3.0 Necessary packages for build sw

* linux-api-headers
* pacutils
* arm-linux-gnueabihf-gcc-linaro-bin
[Linaro GCC Compiler version 7.5, arm-linux-gnueabihf](https://www.linaro.org/downloads/), for Archlinux, installer in the `./src/sw/archlinux-linaro-gcc-7.5`, just run `makepkg -si` in there

### 3.1 Build

`cd` to build folder, see [#1.1](###1.1-Using-*vivado-tcl-cli-mode*)

``` bash
# Using bash in the root directory of this project
$ cd build
$ make -f ../src/sw/makefile release # release mode
$ make -f ../src/sw/makefile # debug mode
```

Output files (bin, systemd-service, obj-temporary) located at `build/xvc_server_sw/`

## FAQ

## Contributer

Founder: DeWei\<dewei@hep1.phys.ntu.edu.tw\>, RA, HEP-Phys-NTU
