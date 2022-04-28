
1. Make sure the design SDC, SPEF and APR (post-routed) netlist are placed in this directory

2. Source the environment using the following commands (once in each new terminal)
export LD_LIBRARY_PATH=/cae/apps/data/synopsys-2021/lc/S-2021.06/linux64/nwtn/shlib:${LD_LIBRARY_PATH}
export TERM=xterm-basic
source /cae/apps/env/synopsys-PrimeTime-2021

3. Run primetime
pt_shell -f ./pt_script.tcl 
   - The screen output is captured into ./pt_shell_command.log

4. Check reports and outputs
   - Examine logs, timing and power reports in `./reports`

5. Obtain the area(um^2) from Primetime (reports/pt.area.rpt)

6. To obtain maximum operating frequency:
	- Change the clock period in top.post_route.sdc and follow step 3 and step 4 above until it throws timing violations in reports.
        - Reduce the period and corresponding number inside 'waveform' to increase the clock frequency in the line  
        "create_clock [get_ports clk]  -period 10  -waveform {0 5}"
        In the above example, the clock period is 10 ns, i.e. the frequency is 100 MHz. To double the frequency, the line should be changed to
        "create_clock [get_ports clk]  -period 5  -waveform {0 2.5}"

7. Obtain the number of clock cycles (#cycles) it takes to produce the output. You have to get it from simulation (ModelSim/QuestSim etc).

8. Obtain the end-to-end latency (ns) by #cycles*1000/max frequency (in MHz)

9. Obtain the power (W) from reports/pt.hier_power.rpt (total power; unit is in W) while simulated at the highest possible frequency.

10. Please not that, Primetime may not provide the correct estimate of maximum frequency, i.e. through Primetime analysis we may not get the lowest possible frequency. To obtain a better estimate, you can change the clock period in synthesis script and perfrom synthesis, APR and Primetime analysis.
