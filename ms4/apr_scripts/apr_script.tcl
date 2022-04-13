###########################################################################
## Initial setup
###########################################################################
set top    top 
set module top 
set newlib top

## Create a container Milkyway library
create_mw_lib -technology /cae/apps/data/tsmclibs-2013/digital/Back_End/milkyway/tcbn45gsbwp_120a/techfiles/HVH_0d5_0/tsmcn45_10lm7X2ZRDL.tf -bus_naming_style {[%d]} -mw_reference_library /cae/apps/data/tsmclibs-2013/digital/Back_End/milkyway/tcbn45gsbwp_120a/frame_only_HVH_0d5_0/tcbn45gsbwp ${newlib}

## Provide the backend collaterals - metal stack for RC extraction
set_tlu_plus_files -max_tluplus /cae/apps/data/tsmclibs-2013/digital/Back_End/milkyway/tcbn45gsbwp_120a/techfiles/tluplus/cln45gs_1p10m+alrdl_typical_top2.tluplus -tech2itf_map /cae/apps/data/tsmclibs-2013/digital/Back_End/milkyway/tcbn45gsbwp_120a/techfiles/tluplus/star.map_10M

## Open the Milkyway library
open_mw_lib ${newlib}

###########################################################################
## Read design collaterals
###########################################################################
## Read the synthesized netlist
import_designs -format verilog -top ${top} -cel ${top} ${module}.vg

## Read the design constraints
read_sdc ${module}.sdc

###########################################################################
## Logical connection of PWR and GND pins
###########################################################################
derive_pg_connection -power_net VDD -power_pin VDD \
    -ground_net VSS -ground_pin VSS -create_port top
derive_pg_connection -ground_net VSS -ground_pin VSS -create_port top
derive_pg_connection -power_net  VDD -power_pin  VDD -create_port top
derive_pg_connection -power_net  VDD -power_pin  VDD -tie

file mkdir ./reports
file mkdir ./outputs

###########################################################################
## Floorplan
###########################################################################
## Create a floorplan
## 60% utilization to start with for example
create_floorplan \
    -core_utilization 0.6 \
    -flip_first_row \
    -start_first_row \
    -left_io2core 10 \
    -bottom_io2core 10 \
    -right_io2core 10 \
    -top_io2core 10 \
    -row_core_ratio 1

## Create power mesh
## create_rectilinear_rings  -nets  {VDD VSS}  -width {4 4} -space {1 1} -layers {M9 M10}
create_rectangular_rings  \
    -nets {VSS}  \
    -left_offset 0.5  \
    -left_segment_layer M9  \
    -left_segment_width 1.0  \
    -extend_ll  \
    -extend_lh  \
    -right_offset 0.5  \
    -right_segment_layer M9  \
    -right_segment_width 1.0  \
    -extend_rl  \
    -extend_rh  \
    -bottom_offset 0.5  \
    -bottom_segment_layer M10  \
    -bottom_segment_width 1.0  \
    -extend_bl  \
    -extend_bh  \
    -top_offset 0.5  \
    -top_segment_layer M10  \
    -top_segment_width 1.0  \
    -extend_tl  \
    -extend_th
create_rectangular_rings  \
    -nets {VDD}  \
    -left_offset 1.8  \
    -left_segment_layer M9  \
    -left_segment_width 1.0  \
    -extend_ll  \
    -extend_lh  \
    -right_offset 1.8  \
    -right_segment_layer M9  \
    -right_segment_width 1.0  \
    -extend_rl  \
    -extend_rh  \
    -bottom_offset 1.8  \
    -bottom_segment_layer M10  \
    -bottom_segment_width 1.0  \
    -extend_bl  \
    -extend_bh  \
    -top_offset 1.8  \
    -top_segment_layer M10  \
    -top_segment_width 1.0  \
    -extend_tl  \
    -extend_th

###########################################################################
## Placement
###########################################################################
## Create rough placement and legalize
create_fp_placement

## Placement optimization
place_opt
place_opt -effort low -area_recovery -power
derive_pg_connection -power_net VDD -power_pin VDD -ground_net VSS -ground_pin VSS

## Dump reports after placement
report_placement_utilization > ./reports/place.utilization.rpt
report_qor_snapshot          > ./reports/place.qor_snapshot.rpt
report_qor                   > ./reports/place.qor.rpt
report_area                  > ./reports/place.area.rpt
report_power                 > ./reports/place.power.rpt

report_timing -delay max -max_paths 20 > ./reports/place.timing.setup.rpt
report_timing -delay min -max_paths 20 > ./reports/place.timing.hold.rpt

write_verilog ./outputs/${module}.place.vg

###########################################################################
## Clock Tree Synthesis
###########################################################################
## First clock tree synthesis
clock_opt -only_cts -no_clock_route
derive_pg_connection -power_net VDD -power_pin VDD -ground_net VSS -ground_pin VSS

## Remove the ideal clock network to consider real delays and fix hold timing
remove_ideal_network [all_fanout -flat -clock_tree]
set_fix_hold [all_clocks]
clock_opt -no_clock_route -only_psyn -power
derive_pg_connection -power_net VDD -power_pin VDD -ground_net VSS -ground_pin VSS

## Clock net routing
route_zrt_group -all_clock_nets -reuse_existing_global_route true

## Dump reports after CTS
report_placement_utilization > ./reports/cts.utilization.rpt
report_qor_snapshot          > ./reports/cts.qor_snapshot.rpt
report_qor                   > ./reports/cts.qor.rpt
report_area                  > ./reports/cts.area.rpt
report_power                 > ./reports/cts.power.rpt

report_timing -delay max -max_paths 20 > ./reports/cts.timing.setup.rpt
report_timing -delay min -max_paths 20 > ./reports/cts.timing.hold.rpt

write_verilog ./outputs/${module}.cts.vg

###########################################################################
## Route
###########################################################################
## Perform routing with optimization
route_opt -initial_route_only

## Optimized routing step
route_opt -skip_initial_route -effort low -power
derive_pg_connection -power_net VDD -power_pin VDD -ground_net VSS -ground_pin VSS

## Incremental route to clean up DRCs
route_zrt_detail -incremental true

## Dump reports after routing
report_placement_utilization > ./reports/route.utilization.rpt
report_qor_snapshot          > ./reports/route.qor_snapshot.rpt
report_qor                   > ./reports/route.qor.rpt
report_area                  > ./reports/route.area.rpt
report_power                 > ./reports/route.power.rpt

report_timing -delay max -max_paths 20 > ./reports/route.timing.setup.rpt
report_timing -delay min -max_paths 20 > ./reports/route.timing.hold.rpt

write_verilog ./outputs/${module}.route.vg

###########################################################################
## Post-route procedures for DRC, LVS
###########################################################################
insert_stdcell_filler   \
        -cell_with_metal  "GFILL10BWP GFILL4BWP GFILL3BWP GFILL2BWP GFILLBWP" \
        -connect_to_power {VDD} \
        -connect_to_ground {VSS}

## Establish PWR/GND connections
derive_pg_connection -power_net VDD -power_pin VDD \
    -ground_net VSS -ground_pin VSS -create_port top

# preroute_standard_cells -connect horizontal 
preroute_standard_cells \
  -nets {VDD VSS} \
  -port_filter_mode off \
  -route_pins_on_layer M1 \
  -cell_master_filter_mode off \
  -cell_instance_filter_mode off \
  -voltage_area_filter_mode off

## Incremental route to clean up DRCs
route_zrt_detail -incremental true

## Dump reports after routing
report_placement_utilization > ./reports/post_route.utilization.rpt
report_qor_snapshot          > ./reports/post_route.qor_snapshot.rpt
report_qor                   > ./reports/post_route.qor.rpt
report_area                  > ./reports/post_route.area.rpt
report_power                 > ./reports/post_route.power.rpt

report_timing -delay max -max_paths 20 > ./reports/post_route.timing.setup.rpt
report_timing -delay min -max_paths 20 > ./reports/post_route.timing.hold.rpt

verify_pg_nets   > ./reports/post_route.pg_nets.rpt
verify_lvs       > ./reports/post_route.lvs.rpt
verify_zrt_route > ./reports/post_route.drc.rpt

write_verilog ./outputs/${module}.post_route.vg
write_sdc     ./outputs/${module}.post_route.sdc
write_parasitics -output ./outputs/${module}.post_route.spef -compress
