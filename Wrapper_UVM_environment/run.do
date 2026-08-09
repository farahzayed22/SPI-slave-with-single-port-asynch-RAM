vlib work
vlog -sv -f src_files.list +define+SIM 
vsim -voptargs=+acc work.wrapper_Top -classdebug -uvmcontrol=all  -l sim.log
add wave /wrapper_Top/wrapper_if/*
add wave /wrapper_Top/wrapper/tx_valid
add wave /wrapper_Top/wrapper/tx_data
add wave /wrapper_Top/wrapper/rx_valid
add wave /wrapper_Top/wrapper/rx_data
add wave /wrapper_Top/wrapper/wrapper_sva/a_miso_stable
add wave /wrapper_Top/slave/a_trans_from_cmd_to_read_address
add wave /wrapper_Top/slave/a_trans_from_cmd_to_read_data
add wave /wrapper_Top/slave/a_trans_from_cmd_to_write
add wave /wrapper_Top/slave/a_trans_from_idle_to_cmd
add wave /wrapper_Top/slave/a_trans_from_read_address_to_idle
add wave /wrapper_Top/slave/a_trans_from_read_data_to_idle
add wave /wrapper_Top/slave/a_trans_from_write_to_idle
add wave /wrapper_Top/slave/slave_sva/a_reset_outputs
add wave /wrapper_Top/slave/slave_sva/a_wr_addr_data_seq
add wave /wrapper_Top/slave/slave_sva/a_rd_addr_seq
add wave /wrapper_Top/slave/slave_sva/a_rd_data_seq
add wave /wrapper_Top/ram/ram_sva/a_reset_tx_valid
add wave /wrapper_Top/ram/ram_sva/a_rest_dout
add wave /wrapper_Top/ram/ram_sva/assert_high_tx_valid
add wave /wrapper_Top/ram/ram_sva/assert_low_tx_valid
add wave /wrapper_Top/ram/ram_sva/assert_read_addr_then_read_data
add wave /wrapper_Top/ram/ram_sva/assert_write_addr_then_write_data
run -all