# FAQ for build hw

## 1 top.tcl (build_hw)

### 1.1 About `set_property DEFAULT_LIB work [current_project]`

Regarding source_mgmt_mode, see

<https://tinyurl.com/4b7xyvxs>

and

<https://www.xilinx.com/support/answers/69846.html>

and

<https://www.xilinx.com/support/answers/63488.html>

If source_mgmt_mode hasn't set as 'All',

then we can't compile axi_jtage with 'source code mode',

axi_jtage only can be compile with 'locked ip mode'

### 1.2 About `set_property synth_checkpoint_mode None [ get_files ${bd_file_and_path} ]`

see [ug994-vivado-ip-subsystem](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_1/ug994-vivado-ip-subsystems.pdf)

### 1.3 About `open_checkpoint <post-route.dcp>`

Before write_hw_platform, must run

`open_checkpoint <post-route.dcp>`

furthermore, can't use read_bd ${bd_file_and_path}

reason Refer to [here](https://www.xilinx.com/support/answers/60945.html)

### 1.4 About `Critical warning of DDR clk to dqs seem can be ignore`

[Refer to here](https://tinyurl.com/t45wsu4v)

It seems can be ignore.

### 1.5 About `set_property platform.design_intent...`

There are necessary information for bring hw output to *.XSA* file

## 2 Makefile

### 2.1 In your code, I saw that sometime you add `""` and sometime not, so when shall I add `""`?

The **when** is your string as *input argument as next program* (getopt case)

Let see following examples:

for example:

```bash
#/bin/bash
var="is a string contain space"
bash a.bash -i ${var}
```

or

```makefile
#makefile
var="is a string contain space"
make -C /path/to/makefile/dir arg="${var}"
```

if you don't add `""` (${var}), then bash and makefile and tcl will expend as:

(1)

```bash
#bash
-i is a string contain space
```

for the `-i` will only read `is` as opt of `-i`

(2)

```makefile
#makefile
arg=is a string contain space
```

for the `arg` will only read `is` as opt of `arg`

So if your `var` may conatin **space**, than please `""` into your `${var}` when **invoke form argument list**

#### Note

Some case such as `vivado x.tcl -args ...` or `xsct x.tcl -args ...`

will auto handling arguments  `...`, so **don't add `""` for this case**
