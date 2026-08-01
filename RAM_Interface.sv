interface RAM_Interface(clk);
    input bit clk;
     logic rstn;
     logic [9:0] din;
     logic rx_valid;
     logic [7:0] dout;
     logic tx_valid;
endinterface