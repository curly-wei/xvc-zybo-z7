# include utiluty
include ${UTILITIES_TOP_DIR}/color_printer/color_render.mk
include ${UTILITIES_TOP_DIR}/max_threads/get_max_threads.mk
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

default: debug
debug: start_msg create_odir debug_compile linking cp_sd end_msg
release: start_msg create_odir release_compile linking cp_sd end_msg

start_msg:
	$(call GPrint,"=============================================")
	$(call GPrint,"UserINFO: Start to build xvc_sw")
	$(call GPrint,"=============================================")

end_msg:
	$(call GPrint,"=============================================")
	$(call GPrint,"UserERROR: Build xvc_sw completed")
	$(call GPrint,"=============================================")

create_odir:
	mkdir -p ${kOutputDir}

linking: ${objs}
	${CC} ${LDFLGAS} ${objs} -o ${target}

debug_compile: ${c_srcs}
	${CC} ${CFLAGS} ${DEBUGFLGAS} ${INCLUDES} -c ${c_srcs} -o ${objs}

release_compile: ${c_srcs}
	${CC} ${CFLAGS} ${RELEASEFLAG} ${INCLUDES} -c ${c_srcs} -o ${objs}

cp_sd:
	cp -f ${systemd_src_file} ${systemd_out_path}

clean:
	rm -rf ${kOutputDir}

install: cp_sd, linking
	install -d ${bin_install_dir}
	install -m 744 ${target} ${bin_install_dir}
	install -d ${sd_install_dir}
	install -m 744 ${systemd_out_path} ${sd_install_dir}

uninstall:
	rm -f ${bin_install_dir}/${kTarget}
	rm -f ${sd_install_dir}/${kSystemdFile}

# Process compilations
.PHONY: \
	start_msg \
	end_msg \
	create_odir \
	clean \
	cp_sd \
	debug \
	release \
	linking \
	debug_compile \
	release_compile \
	install uninstall