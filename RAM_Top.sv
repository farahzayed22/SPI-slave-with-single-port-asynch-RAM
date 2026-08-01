import uvm_pkg::*;
  `include "uvm_macros.svh"
module SPI_Top;
    bit clk;
    bit rst_n;
    RAM_Interface ram_if(clk);
    asynch_ram ram(ram_if.din,ram_if.clk,ram_if.rstn,ram_if.rx_valid,ram_if.dout,ram_if.tx_valid);
    
endmodule 