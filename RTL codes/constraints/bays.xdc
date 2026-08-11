## Clock Signal (100 MHz onboard clock on Basys 3)
set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

## Reset Signal (Center Pushbutton btnC)
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports rstn]

## SPI Interface Pins (Pmod Header JA)
set_property -dict {PACKAGE_PIN J1 IOSTANDARD LVCMOS33} [get_ports mosi]
set_property -dict {PACKAGE_PIN L2 IOSTANDARD LVCMOS33} [get_ports ss_n]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports miso]

## Configuration Options (Required for 7-Series Bitstream Generation)
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

## Bitstream Compression Options
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]