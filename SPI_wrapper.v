module SPI_wrapper(clk, rstn,mosi,miso,ss_n);
    input clk,rstn,mosi,ss_n;
    output miso;

    wire [9:0] din;
    wire [7:0] dout;
    wire rx_valid,tx_valid;
  
    SPI_slave slave(.clk(clk),.rstn(rstn),.mosi(mosi),.miso(miso),.ss_n(ss_n),.rx_data(din),.tx_data(dout),.rx_valid(rx_valid),.tx_valid(tx_valid));
    asynch_ram ram(.clk(clk),.rstn(rstn),.din(din),.dout(dout),.rx_valid(rx_valid),.tx_valid(tx_valid));
endmodule