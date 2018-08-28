## Switch 0
set_property -dict { PACKAGE_PIN U9 IOSTANDARD LVCMOS33 } [get_ports { X }]; #IO_L24N_T3_RS0_15 Sch=sw[0]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets X_IBUF]
