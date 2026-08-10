vlib work
vlog synch_ram.v SPI_slave.v SPI_wrapper.v SPI_tb.v  +cover -covercells
vsim -voptargs=+acc work.SPI_tb -cover
add wave *
add wave -position insertpoint  \sim:/SPI_tb/dut/slave/current_state
add wave -position insertpoint  \sim:/SPI_tb/dut/slave/parallel2Serial
add wave -position insertpoint  \sim:/SPI_tb/dut/slave/tx_data
add wave -position insertpoint  \sim:/SPI_tb/dut/slave/tx_valid
add wave -position insertpoint  \sim:/SPI_tb/dut/slave/serial2Parallel
add wave -position insertpoint  \sim:/SPI_tb/dut/slave/rx_data
add wave -position insertpoint  \sim:/SPI_tb/dut/slave/rx_valid
run -all
