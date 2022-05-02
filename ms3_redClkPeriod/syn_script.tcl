## All input source files must be specified in ./analyze.tcl

#############################################################
## Library settings
#############################################################
## Library settings are sourced from `synopsys_dc.setup`
## Please check this file for target_library, link_library and other lib/db files

#############################################################
## Initial setup
#############################################################
set top top

file delete -force ./work
file delete -force ./alib-52
file delete -force ./outputs
file delete -force ./reports
file delete -force ./default.svf
file delete -force ./dc_output.txt
file mkdir ./outputs
file mkdir ./reports

#############################################################
## Analyze source files
#############################################################
echo "\[ INFO\] Analyzing source files"
redirect -tee ./reports/analyze.log { source ./analyze.tcl }

#############################################################
## Elaboration
#############################################################
echo "\[ INFO\] Elaborating..."
redirect -tee ./reports/elaborate.log { elaborate ${top} }

#############################################################
## Linking design
#############################################################
echo "\[ INFO\] Linking..."
set current_design ${top}
redirect -tee ./reports/link.log { link }

#############################################################
## Checking design
#############################################################
echo "\[ INFO\] Checking design"
redirect -tee ./reports/check_design.presynth.log { check_design }

#############################################################
## Design constraints
#############################################################
echo "\[ INFO\] Setting design constraints"
redirect -tee ./reports/constraints.log { source ./constraints.tcl }

#############################################################
## Synthesize design
#############################################################
echo "\[ INFO\] Synthesizing design"

## First compilation pass
compile -map_effort medium
redirect -tee ./reports/check_design.postpass1.log { check_design }

## Unflatten design now that its compiled
ungroup -all -flatten

## Force hold time to be met for all flops
set_fix_hold clk

## Compile again with higher effort
compile -map_effort high 
redirect -tee ./reports/check_design.postpass2.log { check_design }

## Optimize netlist for area
## optimize_netlist -area
## redirect -tee ./reports/check_design.final.log { check_design }

#############################################################
## Dump reports
#############################################################
echo "\[ INFO\] Dumping reports"
report_area   -hierarchy > ./reports/synth.area.rpt
report_power  -hierarchy > ./reports/synth.power.rpt

report_timing -delay max -max_paths 20 > ./reports/synth.timing.setup.rpt
report_timing -delay min -max_paths 20 > ./reports/synth.timing.hold.rpt

report_constraint -all_violators > ./reports/synth.timing.all_violators.rpt
report_qor                       > ./reports/synth.qor.rpt

## Dump output netlist and SDC
echo "\[ INFO\] Dumping outputs"
write -format verilog -output ./outputs/${top}.vg
write_sdc ./outputs/${top}.sdc

# exit
