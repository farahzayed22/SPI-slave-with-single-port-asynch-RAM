interface slave_Interface(clk);
   input bit clk;
   logic mosi, ss_n, rstn;
   logic [7:0] tx_data;
   logic tx_valid;
   logic [9:0] rx_data;
   logic rx_valid, miso;
   // reference model signals
   logic [9:0] rx_data_ref;
   logic rx_valid_ref, miso_ref;
endinterface