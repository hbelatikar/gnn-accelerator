#############################################################
## Library settings
#############################################################
## Library settings are sourced from `synopsys_pt.setup`
## Please check this file for target_library, link_library and other lib/db files
# read_db /cae/apps/data/tsmclibs-2013/digital/Front_End/timing_power_noise/NLDM/tcbn45gsbwp_120a/tcbn45gsbwptc.db

#############################################################
## Initial setup
#############################################################
set top top

file mkdir ./reports

#############################################################
## Enable power analysis mode in PrimeTime
#############################################################
set power_enable_analysis true

#############################################################
## Read design and link
#############################################################
redirect -tee ./reports/read_netlist.log { read_verilog ${top}.post_route.vg }

current_design ${top}

redirect -tee ./reports/link.log { link }

# redirect -tee ./reports/read_saif.log { read_saif $SAIF -strip_path top_tb/top }

#############################################################
## Read design constraints
#############################################################
redirect -tee ./reports/read_sdc.log { read_sdc ${top}.post_route.sdc }

#############################################################
## Read design parasitics
#############################################################
redirect -tee ./reports/read_spef.log { read_parasitics -format SPEF ${top}.post_route.spef.gz }

#############################################################
## Dump reports
#############################################################
redirect -tee ./reports/pt.check_timing.rpt    { check_timing }
redirect -tee ./reports/pt.area.rpt    { report_cell_usage }
redirect -tee ./reports/pt.update_timing.rpt   { update_timing }
redirect -tee ./reports/pt.timing.rpt          { report_timing }
redirect -tee ./reports/pt.power.rpt           { report_power -verbose }
redirect -tee ./reports/pt.hier_power.rpt      { report_power -hierarchy -nosplit }
redirect -tee ./reports/pt.timing.setup.rpt    { report_timing -delay max -max_paths 20 }
redirect -tee ./reports/pt.timing.hold.rpt     { report_timing -delay min -max_paths 20 }
