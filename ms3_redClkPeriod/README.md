1. Setup the environment (once in each new terminal)
export LD_LIBRARY_PATH=/cae/apps/data/synopsys-2021/lc/S-2021.06/linux64/nwtn/shlib:${LD_LIBRARY_PATH}
export TERM=xterm-basic
source /cae/apps/env/synopsys-dc_shell-vS-2021.06

2. Specify the source files in `./analyze.tcl`. The name of the top-level module is specified in `./syn_script.tcl` under the variable name `top`.

3. Check the design constraints in `./constraints.tcl`
   - Adjust the clock frequency, clock port name, reset port name if required

4. Make sure the name of the clock matches the one in your top script.

5. Make sure the name of the module matches the filename.

6. Run synthesis
dc_shell -f ./syn_script.tcl -output_log_file ./dc_output.txt

6. Check the reports in `./reports` directory in the following order:
   - `analyze.log`          - Reports syntactical errors in the input source files
   - `elaborate.log`        - Elaboration binds all the source files together to create the top level design
   - `link.log`             - Design is linked with all dependencies - any missing references are highlighted here
   - `check_design.*.log`   - Design is linked with all dependencies - any missing references are highlighted here
   - `synth.*.rpt`          - Area, power, timing information dumped

7. Outputs are dumped in `./outputs` directory
   - Use the netlist and SDC for APR

8. Take the *.vg from the output and simulate to verify the functioanlity of the design.

9. You need include the path to the library files. The path is /cae/apps/data/tsmclibs-2013/digital/Front_End/verilog/tcbn45gsbwp_120a/tcbn45gsbwp.v

A sample script for questasim is also available.
