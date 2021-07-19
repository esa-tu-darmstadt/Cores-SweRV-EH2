SHELL:=/bin/bash

buildVivado:
	# run swerv configuration with parameters
	export RV_ROOT=$(pwd)
	configs/swerv.config -set=dccm_enable=0 -set=iccm_enable=0 -set=icache_enable=0 -set=fpga_optimize=1
	exec ./buildVivado.sh

clean:
	echo "clean"
	rm -rf vivado_proj/
	rm -rf snapshots/
