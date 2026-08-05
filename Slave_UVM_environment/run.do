vlib work
vlog -sv -f src_files.list +define+SIM 
vsim -voptargs=+acc work.slave_Top -classdebug -uvmcontrol=all
add wave /slave_Top/slave_if/*
add wave /slave_Top/slave/a_trans_from_cmd_to_read_address
add wave /slave_Top/slave/a_trans_from_cmd_to_read_data
add wave /slave_Top/slave/a_trans_from_cmd_to_write
add wave /slave_Top/slave/a_trans_from_idle_to_cmd
add wave /slave_Top/slave/a_trans_from_read_address_to_idle
add wave /slave_Top/slave/a_trans_from_read_data_to_idle
add wave /slave_Top/slave/a_trans_from_write_to_idle
add wave /slave_Top/slave/slave_sva/a_reset_outputs
add wave /slave_Top/slave/slave_sva/a_wr_addr_data_seq
add wave /slave_Top/slave/slave_sva/a_rd_addr_seq
add wave /slave_Top/slave/slave_sva/a_rd_data_seq
run -all