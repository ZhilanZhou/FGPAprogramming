@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim mips_tester_full_behav -key {Behavioral:sim_3:Functional:mips_tester_full} -tclbatch mips_tester_full.tcl -view C:/Users/MIE/Desktop/COMP541/Lab/Lab8/mips_tester_full_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
