import uvm_pkg::*;
  `include "uvm_macros.svh"
import RAM_Test_pkg::*;
module RAM_Top;
    bit clk;
    always #5 clk=~clk;

    RAM_Interface ram_if(clk);
    synch_ram ram(ram_if.din,ram_if.clk,ram_if.rstn,ram_if.rx_valid,ram_if.dout,ram_if.tx_valid);
    bind synch_ram RAM_SVA ram_sva(ram_if.din,ram_if.clk,ram_if.rstn,ram_if.rx_valid,ram_if.dout,ram_if.tx_valid);

    initial begin
        ram_if.rstn     = 0;
        ram_if.rx_valid = 0;
        ram_if.din      = 0;
        uvm_config_db #(virtual RAM_Interface)::set(null,"uvm_test_top","RAMif",ram_if);
        run_test("RAM_Test");
     end
     initial begin
        $readmemh("mem.dat", ram.mem);
     end
endmodule 