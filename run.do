vlib work
vlog asynch_ram.v SPI_slave.v SPI_wrapper.v SPI_wrapper_tb.v  +cover -covercells
vsim -voptargs=+acc work.SPI_wrapper_tb -cover
add wave *
add wave -position end sim:/SPI_wrapper_tb/dut/slave/*
add wave -position end sim:/SPI_wrapper_tb/dut/ram/*
run -all
