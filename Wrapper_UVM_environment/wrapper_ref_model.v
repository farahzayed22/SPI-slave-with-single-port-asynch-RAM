module wrapper_ref_model(clk, rstn,mosi,miso,ss_n);
    input clk,rstn,mosi,ss_n;
    output miso;

    wire [9:0] rx_data;
    wire [7:0] tx_data;
    wire rx_valid,tx_valid;
  
    slave_ref_model slave(mosi, ss_n ,rx_data, rx_valid, clk, rstn, tx_data, tx_valid, miso);
    synch_ram ram(rx_data,clk,rstn,rx_valid,tx_data,tx_valid);
endmodule

