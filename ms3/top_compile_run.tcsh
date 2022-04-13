#!/bin/tcsh

source /cae/apps/env/mentor-QuestaSim-2021.2-2

export PATH=/cae/apps/data/mentor-2021/questasim/bin:${PATH}

echo "[ Info] Starting Compilation ..."

\rm -rf ./LibTop modelsim.ini  vsim.wlf transcript wave.do
echo "[ Info] Creating Library Object ..."

###################################################################################################
## Create QuestaSim design and library
###################################################################################################
vlib LibTop
vmap -quiet work $PWD/LibTop
echo "[ Info] Compiling Netlist and Testbench ..."

###################################################################################################
## Compile Verilog source and testbench
###################################################################################################
## Syntax
## vlog -suppress vlog-2583 -sv +acc -nologo -quiet -work work \
## <list-of-source-files> \
## <list-of-source-files> \
## <list-of-source-files> \

# ./rtl/top.sv ./rtl/mlp.sv ./rtl/neuron4.sv \
vlog -suppress vlog-2583 -sv +acc -nologo -quiet -work work \
    ./outputs/top.vg \
    /cae/apps/data/tsmclibs-2013/digital/Front_End/verilog/tcbn45gsbwp_120a/tcbn45gsbwp.v \
    ./rtl_files/top_tb.sv 

###################################################################################################
## Optimize design
###################################################################################################
echo "[ Info] Elaborating Design ..."
# Syntax
# vopt -quiet -suppress vopt-143 -work work -check_synthesis -o <name_of_top_design_>_opt <name_of_top_design>
# vopt -quiet -suppress vopt-143 -work work -check_synthesis -o mlp_opt top 

###################################################################################################
## Run simulation
###################################################################################################
echo "[ Info] Starting Simulation ..."

## Syntax
## vsim $1 -lib ./LibTop <name_of_testbench_module> -t ps -do ./run.do -sv_seed 10
vsim $1 -lib ./LibTop tb_top -t ps -do ./run.do -sv_seed 10
