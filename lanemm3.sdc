## Generated SDC file "lanemm3.sdc"

## Copyright (C) 1991-2010 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 9.1 Build 304 01/25/2010 Service Pack 1 SJ Web Edition"

## DATE    "Wed Mar 03 00:44:08 2010"

##
## DEVICE  "EPM570T100C3"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {ZCLK} -period 166.666 -waveform { 0.000 83.333 } [get_ports { ZCLK }]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************

set_min_delay -from [get_ports {D[0]}] -to [get_registers {MEMOREG[0]}] -3.000
set_min_delay -from [get_ports {D[1]}] -to [get_registers {MEMOREG[1]}] -3.000
set_min_delay -from [get_ports {D[2]}] -to [get_registers {MEMOREG[2]}] -3.000
set_min_delay -from [get_ports {D[3]}] -to [get_registers {MEMOREG[3]}] -3.000
set_min_delay -from [get_ports {D[4]}] -to [get_registers {MEMOREG[4]}] -3.000
set_min_delay -from [get_ports {D[5]}] -to [get_registers {MEMOREG[5]}] -3.000
set_min_delay -from [get_ports {D[6]}] -to [get_registers {MEMOREG[6]}] -3.000
set_min_delay -from [get_ports {D[7]}] -to [get_registers {MEMOREG[7]}] -3.000
set_min_delay -from [get_ports {D[0]}] -to [get_registers {EMM2REG[0]}] -3.000
set_min_delay -from [get_ports {D[1]}] -to [get_registers {EMM2REG[1]}] -3.000
set_min_delay -from [get_ports {D[2]}] -to [get_registers {EMM2REG[2]}] -3.000
set_min_delay -from [get_ports {D[3]}] -to [get_registers {EMM2REG[3]}] -3.000
set_min_delay -from [get_ports {D[4]}] -to [get_registers {EMM2REG[4]}] -3.000
set_min_delay -from [get_ports {D[5]}] -to [get_registers {EMM2REG[5]}] -3.000
set_min_delay -from [get_ports {D[6]}] -to [get_registers {EMM2REG[6]}] -3.000
set_min_delay -from [get_ports {D[7]}] -to [get_registers {EMM2REG[7]}] -3.000
set_min_delay -from [get_ports {D[0]}] -to [get_registers {EMM2REG[8]}] -3.000
set_min_delay -from [get_ports {D[1]}] -to [get_registers {EMM2REG[9]}] -3.000
set_min_delay -from [get_ports {D[2]}] -to [get_registers {EMM2REG[10]}] -3.000
set_min_delay -from [get_ports {D[3]}] -to [get_registers {EMM2REG[11]}] -3.000
set_min_delay -from [get_ports {D[4]}] -to [get_registers {EMM2REG[12]}] -3.000
set_min_delay -from [get_ports {D[5]}] -to [get_registers {EMM2REG[13]}] -3.000
set_min_delay -from [get_ports {D[6]}] -to [get_registers {EMM2REG[14]}] -3.000
set_min_delay -from [get_ports {D[7]}] -to [get_registers {EMM2REG[15]}] -3.000
set_min_delay -from [get_ports {D[0]}] -to [get_registers {EMM2REG[16]}] -3.000
set_min_delay -from [get_ports {D[1]}] -to [get_registers {EMM2REG[17]}] -3.000
set_min_delay -from [get_ports {D[2]}] -to [get_registers {EMM2REG[18]}] -3.000
set_min_delay -from [get_ports {D[0]}] -to [get_registers {CMOSREG[0]}] -3.000
set_min_delay -from [get_ports {D[1]}] -to [get_registers {CMOSREG[1]}] -3.000
set_min_delay -from [get_ports {D[2]}] -to [get_registers {CMOSREG[2]}] -3.000
set_min_delay -from [get_ports {D[3]}] -to [get_registers {CMOSREG[3]}] -3.000
set_min_delay -from [get_ports {D[4]}] -to [get_registers {CMOSREG[4]}] -3.000
set_min_delay -from [get_ports {D[5]}] -to [get_registers {CMOSREG[5]}] -3.000
set_min_delay -from [get_ports {D[6]}] -to [get_registers {CMOSREG[6]}] -3.000
set_min_delay -from [get_ports {D[7]}] -to [get_registers {CMOSREG[7]}] -3.000
set_min_delay -from [get_ports {D[0]}] -to [get_registers {CMOSREG[8]}] -3.000
set_min_delay -from [get_ports {D[1]}] -to [get_registers {CMOSREG[9]}] -3.000
set_min_delay -from [get_ports {D[2]}] -to [get_registers {CMOSREG[10]}] -3.000
set_min_delay -from [get_ports {D[3]}] -to [get_registers {CMOSREG[11]}] -3.000
set_min_delay -from [get_ports {D[4]}] -to [get_registers {CMOSREG[12]}] -3.000
set_min_delay -from [get_ports {D[5]}] -to [get_registers {CMOSREG[13]}] -3.000
set_min_delay -from [get_ports {D[6]}] -to [get_registers {CMOSREG[14]}] -3.000
set_min_delay -from [get_ports {D[7]}] -to [get_registers {CMOSREG[15]}] -3.000
set_min_delay -from [get_ports {D[0]}] -to [get_registers {RFREG[0]}] -3.000
set_min_delay -from [get_ports {D[1]}] -to [get_registers {RFREG[1]}] -3.000
set_min_delay -from [get_ports {D[2]}] -to [get_registers {RFREG[2]}] -3.000
set_min_delay -from [get_ports {D[3]}] -to [get_registers {RFREG[3]}] -3.000
set_min_delay -from [get_ports {D[4]}] -to [get_registers {RFREG[4]}] -3.000
set_min_delay -from [get_ports {D[5]}] -to [get_registers {RFREG[5]}] -3.000
set_min_delay -from [get_ports {D[6]}] -to [get_registers {RFREG[6]}] -3.000
set_min_delay -from [get_ports {D[7]}] -to [get_registers {RFREG[7]}] -3.000
set_min_delay -from [get_ports {D[0]}] -to [get_registers {EMMREG[8]}] -3.000
set_min_delay -from [get_ports {D[1]}] -to [get_registers {EMMREG[9]}] -3.000
set_min_delay -from [get_ports {D[2]}] -to [get_registers {EMMREG[10]}] -3.000
set_min_delay -from [get_ports {D[3]}] -to [get_registers {EMMREG[11]}] -3.000
set_min_delay -from [get_ports {D[4]}] -to [get_registers {EMMREG[12]}] -3.000
set_min_delay -from [get_ports {D[5]}] -to [get_registers {EMMREG[13]}] -3.000
set_min_delay -from [get_ports {D[6]}] -to [get_registers {EMMREG[14]}] -3.000
set_min_delay -from [get_ports {D[7]}] -to [get_registers {EMMREG[15]}] -3.000
set_min_delay -from [get_ports {A[8]}] -to [get_registers {EMMREG[16]}] -3.000
set_min_delay -from [get_ports {A[9]}] -to [get_registers {EMMREG[17]}] -3.000
set_min_delay -from [get_ports {A[10]}] -to [get_registers {EMMREG[18]}] -3.000
set_min_delay -from [get_ports {A[11]}] -to [get_registers {EMMREG[19]}] -3.000
set_min_delay -from [get_ports {A[8]}] -to [get_registers {RFREG[8]}] -3.000
set_min_delay -from [get_ports {A[9]}] -to [get_registers {RFREG[9]}] -3.000
set_min_delay -from [get_ports {A[10]}] -to [get_registers {RFREG[10]}] -3.000
set_min_delay -from [get_ports {A[11]}] -to [get_registers {RFREG[11]}] -3.000
set_min_delay -from [get_ports {A[12]}] -to [get_registers {RFREG[12]}] -3.000
set_min_delay -from [get_ports {A[13]}] -to [get_registers {RFREG[13]}] -3.000
set_min_delay -from [get_ports {A[14]}] -to [get_registers {RFREG[14]}] -3.000
set_min_delay -from [get_ports {A[15]}] -to [get_registers {RFREG[15]}] -3.000
set_min_delay -from [get_ports {D[0]}] -to [get_registers {ROMREG[8]}] -3.000
set_min_delay -from [get_ports {D[1]}] -to [get_registers {ROMREG[9]}] -3.000
set_min_delay -from [get_ports {D[2]}] -to [get_registers {ROMREG[10]}] -3.000
set_min_delay -from [get_ports {D[3]}] -to [get_registers {ROMREG[11]}] -3.000
set_min_delay -from [get_ports {D[4]}] -to [get_registers {ROMREG[12]}] -3.000
set_min_delay -from [get_ports {D[5]}] -to [get_registers {ROMREG[13]}] -3.000
set_min_delay -from [get_ports {D[6]}] -to [get_registers {ROMREG[14]}] -3.000
set_min_delay -from [get_ports {D[7]}] -to [get_registers {ROMREG[15]}] -3.000
set_min_delay -from [get_ports {A[8]}] -to [get_registers {ROMREG[16]}] -3.000
set_min_delay -from [get_ports {A[9]}] -to [get_registers {ROMREG[17]}] -3.000
set_min_delay -from [get_ports {A[10]}] -to [get_registers {ROMREG[18]}] -3.000
set_min_delay -from [get_ports {A[11]}] -to [get_registers {ROMREG[19]}] -3.000


#**************************************************************
# Set Input Transition
#**************************************************************

