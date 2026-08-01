import uvm_pkg::*;
  `include "uvm_macros.svh"
import RAM_Test_pkg::*;
module SPI_Top;
    bit clk;
    bit rst_n;
    always #5 clk=~clk;

    RAM_Interface ram_if(clk);
    asynch_ram ram(ram_if.din,ram_if.clk,ram_if.rstn,ram_if.rx_valid,ram_if.dout,ram_if.tx_valid);
    bind asynch_ram RAM_SVA ram_sva(ram_if.din,ram_if.clk,ram_if.rstn,ram_if.rx_valid,ram_if.dout,ram_if.tx_valid);

    initial begin
    uvm_config_db #(virtual RAM_Interface)::set(null,"uvm_test_top","RAMif",ram_if);
    run_test("RAM_test");
     end
endmodule 