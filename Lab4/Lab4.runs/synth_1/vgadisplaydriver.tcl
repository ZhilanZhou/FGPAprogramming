# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/MIE/Desktop/COMP541/Lab/Lab4/Lab4.cache/wt [current_project]
set_property parent.project_path C:/Users/MIE/Desktop/COMP541/Lab/Lab4/Lab4.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Users/MIE/Desktop/COMP541/Lab/Lab4/Lab4.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog C:/Users/MIE/Desktop/COMP541/Lab/Lab4/Lab4.srcs/sources_1/imports/Lab/display640x480.vh
read_verilog -library xil_defaultlib -sv {
  C:/Users/MIE/Desktop/COMP541/Lab/Lab4/Lab4.srcs/sources_1/new/vgatimer.sv
  C:/Users/MIE/Desktop/COMP541/Lab/Lab4/Lab4.srcs/sources_1/imports/new/xycounter.sv
  C:/Users/MIE/Desktop/COMP541/Lab/Lab4/Lab4.srcs/sources_1/imports/Lab/vgadisplaydriver.sv
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/MIE/Desktop/COMP541/Lab/Lab4/Lab4.srcs/constrs_1/imports/Lab/clock.xdc
set_property used_in_implementation false [get_files C:/Users/MIE/Desktop/COMP541/Lab/Lab4/Lab4.srcs/constrs_1/imports/Lab/clock.xdc]

read_xdc C:/Users/MIE/Desktop/COMP541/Lab/Lab4/Lab4.srcs/constrs_1/imports/Lab/vga.xdc
set_property used_in_implementation false [get_files C:/Users/MIE/Desktop/COMP541/Lab/Lab4/Lab4.srcs/constrs_1/imports/Lab/vga.xdc]


synth_design -top vgadisplaydriver -part xc7a100tcsg324-1


write_checkpoint -force -noxdef vgadisplaydriver.dcp

catch { report_utilization -file vgadisplaydriver_utilization_synth.rpt -pb vgadisplaydriver_utilization_synth.pb }
