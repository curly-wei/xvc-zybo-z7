# Project Porperity
kInstallPrefix ?= /usr
kBuildDir ?= $(shell pwd)
kProjRootDir := $(shell realpath "${kBuildDir}/../")
kTarget := xvc_server

kCSrcDir := ${kProjRootDir}/src/sw
kIncludeDirs := ${kCSrcDir}
kSystemdFileDir := ${kProjRootDir}/src/sw
kOutputDir := ${kBuildDir}/xvc_server_sw


kCSrcFiless := ${kTarget}.c
kSystemdFile := ${kTarget}d.service

## Evaluate Project Resources
c_srcs := $(foreach csrcs, ${kCSrcFiless}, $(addprefix ${kCSrcDir}/, ${csrcs}) )
systemd_src_file := ${kSystemdFileDir}/${kSystemdFile}
objs := ${kOutputDir}/${kTarget}.o
target := ${kOutputDir}/${kTarget}
systemd_out_path := ${kOutputDir}/${kSystemdFile}
bin_install_dir := ${kInstallPrefix}/bin
sd_install_dir := ${kInstallPrefix}/lib/systemd/system

#Color renderning
define GPrint 
	@$(eval kColorRed := '\e[0;31m')
	@$(eval kColorGreen := '\e[0;32m')
	@$(eval kColorEnd := '\e[0m')
	@echo -e $(kColorGreen)${1}$(kColorEnd)
endef

.PHONY:\
	start_msg, end_msg,\
	clean, create_odir,
	install, uninstall

default: debug
debug: start_msg create_odir debug_compile linking cp_sd end_msg
release: start_msg create_odir release_compile linking cp_sd end_msg

start_msg:
	$(call GPrint,"======================================")
	$(call GPrint,"UserINFO: Start to build xvc_sw")
	$(call GPrint,"======================================")

end_msg:
	$(call GPrint,"======================================")
	$(call GPrint,"UserINFO: Build xvc_sw completed")
	$(call GPrint,"======================================")