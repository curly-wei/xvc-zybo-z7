# How to build sw

## 0 Necessary packages for build sw

* Only support Linux enviroment for build
* linux-api-headers
* pacutils
* [Linaro GCC Compiler version 7.5, arm-linux-gnueabihf](https://www.linaro.org/downloads/)

## 1 To build sw

if `build` folder doesn't exist in the root dir of this project, then

create `build` folder in the root dir of this project.

`cd` to `build` folder

``` bash
# Using bash in the root directory of this project
$ cd build
$ make -f ../src/sw/makefile release # release mode
$ make -f ../src/sw/makefile # debug mode
```

Output files (bin, systemd-service, obj-temporary) will located at `build/xvc_server_sw/`
