import uvm_pkg::*;
  `include "uvm_macros.svh"
import slave_Test_pkg::*;
module slave_Top;

    bit clk;
    always #5 clk = ~clk;

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

    initial begin
        slave_if.rstn     = 0;
        slave_if.tx_valid = 0;
        slave_if.tx_data  = 0;
        slave_if.ss_n     = 1;
        slave_if.mosi     = 0;

        uvm_config_db #(virtual slave_Interface)::set(null, "uvm_test_top", "slaveif", slave_if);
        run_test("slave_Test");
    end
endmodule