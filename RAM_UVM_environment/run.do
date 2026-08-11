vlib work
vlog -f src_files.list
vsim -voptargs=+acc work.RAM_Top -classdebug -uvmcontrol=all
add wave /RAM_Top/ram_if/*
add wave /RAM_Top/ram/ram_sva/assert_high_tx_valid
run -all

