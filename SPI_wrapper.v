module SPI_wrapper(clk, rstn,mosi,miso,ss_n);
    input clk,rstn,mosi,ss_n;
    output miso;

    wire [9:0] rx_data;
    wire [7:0] tx_data;
    wire rx_valid,tx_valid;
  
    SPI_slave slave(mosi, ss_n ,rx_data, rx_valid, clk, rstn, tx_data, tx_valid, miso);
    synch_ram ram(rx_data,clk,rstn,rx_valid,tx_data,tx_valid);
endmodule