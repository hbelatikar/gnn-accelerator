
1. Make sure the design SDC (top.sdc) and synthesized netlist (top.vg) are placed in this directory

2. Source the environment using the following commands (once in each new terminal)
export LD_LIBRARY_PATH=/cae/apps/data/synopsys-2021/lc/S-2021.06/linux64/nwtn/shlib:${LD_LIBRARY_PATH}
export TERM=xterm-basic
source /cae/apps/env/synopsys-icc-vS-2021.06

3. Run IC Compiler to perform APR
icc_shell -f ./apr_script.tcl -shared_license
   - The screen output is captured into ./icc_output.txt

4. Check reports and outputs
   - Utilization, timing, area reports are dumped after every stage in the flow in `./reports/`
   - DRC/LVS/power connection reports are dumped after the post-route stage in `./reports/`
   - The Verilog gate-level netlist is dumped after every stage in `./outputs`

5. Simulate top.post_route.vg with the testbench and the script provided.
