# How to build hw

## 0 Before build

First,

make sure that the *Vivado* `bin` directory already exists in the `{PATH} of env.var`

You have 2 ways to build *hw*

1. vivado tcl-cli mode
2. vivado tcl-batch mode

The following sections (1.1, 1.2) will explain.

## 1 Using *vivado tcl-cli mode*

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

## 2 Using *vivado tcl-batch mode*

``` bash
# Using bash in the root directory of this project
$ mkdir build
$ cd build
$ vivado -mode batch -source ../src/hw/script/top.tcl
```

## 3 Tips to reduce hardware build time

### 3.1 Filter generated reports

You may have seen `report_****` in the `top.tcl`,

this command for generate report of build Vivado project.

Maybe not all reports are what you need,

therefore you can **Comment (#) report_\*\*\*\*** to reduce reports output,

then time of build also could be reduced.

### 3.2 `write_checkpoint` maybe you don't need

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
