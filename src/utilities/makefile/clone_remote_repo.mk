#Color renderning Green
define CloneRemoteRepo
	@if [ ! -d ${3} ]; then \
		echo "Remote repository doesn't exist in local, cloning...";\
		git clone \
		--depth=1 \
		--branch=${2} \
		${1} ${3}; \
	else \
		echo "Remote repository exist in local, check newest..."; \
		cd ${3}; \
		git pull ${1}; \
	fi		
endef
