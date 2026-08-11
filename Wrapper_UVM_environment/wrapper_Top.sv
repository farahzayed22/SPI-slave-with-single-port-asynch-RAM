import uvm_pkg::*;
  `include "uvm_macros.svh"
import wrapper_Test_pkg::*;
module wrapper_Top;

    bit clk;
    always #5 clk = ~clk;

    
    RAM_Interface ram_if(clk);
    synch_ram ram(
        .din(ram_if.din),
        .clk(ram_if.clk),
        .rstn(ram_if.rstn),
        .rx_valid(ram_if.rx_valid),
        .dout(ram_if.dout),
        .tx_valid(ram_if.tx_valid)
    );
   bind synch_ram RAM_SVA ram_sva(ram_if.din,ram_if.clk,ram_if.rstn,ram_if.rx_valid,ram_if.dout,ram_if.tx_valid);
    slave_Interface slave_if(clk);
    slave_ref_model slave_ref (
        .mosi        (slave_if.mosi),
        .ss_n        (slave_if.ss_n),
        .rx_data     (slave_if.rx_data_ref),
        .rx_valid    (slave_if.rx_valid_ref),
        .clk         (slave_if.clk),
        .rstn        (slave_if.rstn),
        .tx_data     (slave_if.tx_data),
        .tx_valid    (slave_if.tx_valid),
        .miso        (slave_if.miso_ref)
    );

    SPI_slave slave (
        .mosi        (slave_if.mosi),
        .ss_n        (slave_if.ss_n),
        .rx_data     (slave_if.rx_data),
        .rx_valid    (slave_if.rx_valid),
        .clk         (slave_if.clk),
        .rstn        (slave_if.rstn),
        .tx_data     (slave_if.tx_data),
        .tx_valid    (slave_if.tx_valid),
        .miso        (slave_if.miso)
    );
    bind SPI_slave slave_SVA slave_sva (
        .mosi        (slave_if.mosi),
        .ss_n        (slave_if.ss_n),
        .rx_data     (slave_if.rx_data),
        .rx_valid    (slave_if.rx_valid),
        .clk         (slave_if.clk),
        .rstn        (slave_if.rstn),
        .tx_data     (slave_if.tx_data),
        .tx_valid    (slave_if.tx_valid),
        .miso        (slave_if.miso)
    );
     wrapper_Interface wrapper_if(clk);

    wrapper_ref_model wrapper_ref (
       .clk(wrapper_if.clk),
        .rstn(wrapper_if.rstn),
        .mosi(wrapper_if.mosi),
        .ss_n(wrapper_if.ss_n),
        .miso(wrapper_if.miso_ref)
    );
    

    SPI_wrapper wrapper (
        .clk(wrapper_if.clk),
        .rstn(wrapper_if.rstn),
        .mosi(wrapper_if.mosi),
        .ss_n(wrapper_if.ss_n),
        .miso(wrapper_if.miso)
    );

    bind SPI_wrapper wrapper_SVA wrapper_sva (
        .mosi        (wrapper_if.mosi),
        .ss_n        (wrapper_if.ss_n),
        .clk         (wrapper_if.clk),
        .rstn        (wrapper_if.rstn),
        .miso        (wrapper_if.miso),
        .rx_data     (slave_if.rx_data)
    );

    assign slave_if.mosi     = wrapper.mosi;
    assign slave_if.ss_n     = wrapper.ss_n;
    assign slave_if.rstn     = wrapper.rstn;
    assign slave_if.tx_data  = wrapper.tx_data;
    assign slave_if.tx_valid = wrapper.tx_valid;

    assign ram_if.din        = wrapper.rx_data;
    assign ram_if.rx_valid   = wrapper.rx_valid;
    assign ram_if.rstn       = wrapper.rstn;
    initial begin
        wrapper_if.rstn     = 0;
        wrapper_if.ss_n     = 1;
        wrapper_if.mosi     = 0;

        uvm_config_db #(virtual wrapper_Interface)::set(null, "uvm_test_top", "wrapperif", wrapper_if);
        uvm_config_db #(virtual RAM_Interface)::set(null, "uvm_test_top", "RAMif", ram_if);
        uvm_config_db #(virtual slave_Interface)::set(null, "uvm_test_top", "slaveif", slave_if);
        run_test("wrapper_Test");
    end

    
  initial begin
    $readmemh("mem.dat", wrapper.ram.mem);
    $readmemh("mem.dat", wrapper_ref.ram.mem);
  end
endmodule
