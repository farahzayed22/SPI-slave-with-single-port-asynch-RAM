module wrapper_SVA(clk, rstn,mosi,miso,ss_n,rx_data);
    input mosi, ss_n, clk, rstn, miso;
    input [9:0] rx_data;
    // 1. Reset Assertions
    property p_reset_outputs;
        @(posedge clk) 
        (~rstn) |=> (~miso);
    endproperty
    a_reset_outputs:     assert property(p_reset_outputs) else $error("SVA ERROR: Outputs not reset to 0!");
    cv_reset_outputs:    cover property(p_reset_outputs);

    // 2. remain miso with the same value when op is not read_data
    property p_miso_stable;
        @(posedge clk) disable iff(~rstn)
        ((~ss_n) && (rx_data[9:8] != 2'b11)) |-> ##[1:10] ($stable(miso));
    endproperty
    a_miso_stable: assert property(p_miso_stable) else $error("SVA ERROR: miso is not stable when op is not read_data!");
    cv_miso_stable: cover property(p_miso_stable);

endmodule
