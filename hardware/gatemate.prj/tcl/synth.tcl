## synth.tcl

## argparse
set design  [lindex $argv 0]
set outpath [lindex $argv 1]
set inpath "../enexor-logic-analyzer.srcs/sources_1/new"

## import yosys commands
yosys -import

## inputs
read_verilog -sv ${inpath}/${design}.v
read_verilog -sv ${inpath}/Reset_Sync.v
if {${design} == "demo_top"} {
  read_verilog -sv ${inpath}/ALS.v
  read_verilog -sv ${inpath}/simpleSPI.v
}
read_verilog -sv ${inpath}/Pulse_Sync.v
read_verilog -sv ${inpath}/Clock_Divider.v
read_verilog -sv ${inpath}/Timestamp_Counter.v
read_verilog -sv ${inpath}/Trigger_Controller.v
read_verilog -sv ${inpath}/Data_Buffers_Programmable.v
read_verilog -sv ${inpath}/sram.v
read_verilog -sv ${inpath}/FSM_Controller.v
read_verilog -sv ${inpath}/Data_Width_Converter.v
read_verilog -sv ${inpath}/Mux.v
read_verilog -sv ${inpath}/UART.v
read_verilog -sv ${inpath}/UART_Tx.v
read_verilog -sv ${inpath}/UART_Rx.v

## synthesis
synth_gatemate -top ${design} -nomx8

## outputs
write_verilog -noattr ${outpath}/${design}_synth.v
