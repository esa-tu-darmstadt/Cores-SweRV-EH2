#!/bin/bash
# Executed by makefile in same folder to build the vivado project

# patch eh2_pdef.vh
sed -i '1 i\`ifndef pdef_sec \n`define pdef_sec' snapshots/default/eh2_pdef.vh
sed -i '$ a`endif' snapshots/default/eh2_pdef.vh
# build the vivado project
mkdir vivado_proj
cd vivado_proj && vivado -nolog -nojournal -mode batch -source ../swervVivado.tcl