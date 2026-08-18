create_clock -name my_wclk -period 20 [get_ports {wclk}]
create_clock -name my_rclk -period 19.900 [get_ports {rclk}]

derive_clock_uncertainty

# set_clock_groups -asynchronous -group {my_wclk} -group {my_rclk}
set_max_delay -from [get_registers {*AFIFOWriteCtrl*wptr_gray[*]}]\
	      -to [get_registers {*w2rCDC*middff[*]}]\
	      19.900
set_false_path -hold -from [get_registers {*AFIFOWriteCtrl*wptr_gray[*]}]\
	      -to [get_registers {*w2rCDC*middff[*]}]

set_max_delay -from [get_registers {*AFIFOReadCtrl*rptr_gray[*]}]\
	      -to [get_registers {*r2wCDC*middff[*]}]\
	      19.900
set_false_path -hold -from [get_registers {*AFIFOReadCtrl*rptr_gray[*]}]\
	      -to [get_registers {*r2wCDC*middff[*]}]

set_input_delay -clock my_wclk -max 5 [get_ports {winc wdata[*]}]
set_input_delay -clock my_wclk -min 0 [get_ports {winc wdata[*]}]
set_output_delay -clock my_wclk -max 5 [get_ports {wfull walmostfull}]
set_output_delay -clock my_wclk -min 0 [get_ports {wfull walmostfull}]

set_input_delay -clock my_rclk -max 5 [get_ports {rinc}]
set_input_delay -clock my_rclk -min 0 [get_ports {rinc}]
set_output_delay -clock my_rclk -max 5 [get_ports {rempty ralmostempty rdata[*]}]
set_output_delay -clock my_rclk -min 0 [get_ports {rempty ralmostempty rdata[*]}]

set_false_path -from [get_clocks my_wclk] -to [get_keepers {*AFIFOMem*rdata[*]}]
set_false_path -from [get_ports {wrst rrst}]
