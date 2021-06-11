SHELL:=/bin/bash

buildVivado:
	cd configs && ./swerv.config
	mkdir vivado_proj
	cd vivado_proj && vivado -nolog -nojournal -mode batch -source ../swervVivado.tcl

clean:
	echo "clean"
	rm -rf vivado_proj/
	rm -rf configs/snapshots/
