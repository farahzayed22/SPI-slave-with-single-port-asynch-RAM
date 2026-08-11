module slave_SVA(mosi, ss_n, rx_data, rx_valid, clk, rstn, tx_data, tx_valid, miso);
    input mosi, ss_n, clk, rstn;
    input [7:0] tx_data;
    input tx_valid;
    input [9:0] rx_data;
    input rx_valid, miso;

    // 1. Reset Assertions
    property p_reset_outputs;
        @(posedge clk) 
        (~rstn) |=> (~miso && ~rx_valid && (rx_data == 10'b0));
    endproperty

    a_reset_outputs:     assert property(p_reset_outputs) else $error("SVA ERROR: Outputs not reset to 0!");
    cv_reset_outputs:    cover property(p_reset_outputs);


    // 2. Write Sequences
    property p_wr_addr_data_seq;
        @(posedge clk) disable iff (~rstn)
        ($fell(ss_n) ##1 (mosi == 1'b0) ##1 (mosi == 1'b0) ##1 (mosi == 1'b0 || mosi == 1'b1)) |-> ##10 $rose(rx_valid) ##[0:$]  $rose(ss_n);
    endproperty

    a_wr_addr_data_seq:  assert property(p_wr_addr_data_seq) else $error("SVA ERROR: Write rx_valid , ss_n timing failed!");
    cv_wr_addr_data_seq: cover property(p_wr_addr_data_seq);


    // 3. Read Sequences
    property p_rd_addr_seq;
        @(posedge clk) disable iff (~rstn)
        $fell(ss_n) ##1 (mosi == 1'b1) ##1 (mosi == 1'b1) ##1 (mosi == 1'b0 ) |-> ##10 $rose(rx_valid) ##[0:$]  $rose(ss_n);
    endproperty

    a_rd_addr_seq:  assert property(p_rd_addr_seq) else $error("SVA ERROR: Read addr rx_valid , ss_n timing failed!");
    cv_rd_addr_seq: cover property(p_rd_addr_seq);

    property p_rd_data_seq;
        @(posedge clk) disable iff (~rstn)
        $fell(ss_n) ##1 (mosi == 1'b1) ##1 (mosi == 1'b1) ##1 (mosi == 1'b1 ) |-> ##10 $rose(rx_valid) ##[0:$]  $rose(ss_n);
    endproperty

    a_rd_data_seq:  assert property(p_rd_data_seq) else $error("SVA ERROR: Read data rx_valid , ss_n timing failed!");
    cv_rd_data_seq: cover property(p_rd_data_seq);

endmodule

