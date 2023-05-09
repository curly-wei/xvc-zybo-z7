# FAQ for build hw

## 1 About `set_property DEFAULT_LIB work [current_project]`

Regarding source_mgmt_mode, see

<https://www.xilinx.com/support/answers/69846.html>

and

<https://www.xilinx.com/support/answers/63488.html>

If source_mgmt_mode hasn't set as 'All',

then we can't compile axi_jtage with 'source code mode',

axi_jtage only can be compile with 'locked ip mode'

## 2 About `set_property synth_checkpoint_mode None [ get_files ${bd_file_and_path} ]`

see [ug994-vivado-ip-subsystem](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_1/ug994-vivado-ip-subsystems.pdf)

## 3 About `open_checkpoint <post-route.dcp>`

Before write_hw_platform, must run

`open_checkpoint <post-route.dcp>`

furthermore, can't use read_bd ${bd_file_and_path}

reason Refer to [here](https://support.xilinx.com/s/question/0D52E00007G0pJYSAZ/whats-usage-of-readcheckpoint?language=en_US)

## 4 About `Critical warning of DDR clk to dqs seem can be ignore`

[Refer to here](https://github.com/Digilent/vivado-boards/issues/20)

It seems can be ignore.

## 5 About `set_property platform.design_intent...`

There are necessary information for bring hw output to *.XSA* file
