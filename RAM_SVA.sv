module RAM_SVA(din,clk,rstn,rx_valid,dout,tx_valid);
    parameter MEM_DEPTH=256;
    parameter ADDR_SIZE=8;
    input [9:0] din;
    input clk,rstn,rx_valid;
    input [7:0] dout;
    input tx_valid;

    always_comb begin
        if(~rstn) begin
            a_rest_dout:assert final (dout==0) else $error("dout is not reset to 0");
            a_reset_tx_valid:assert final (tx_valid==0) else $error("tx_valid is not reset to 0");
        end
    end

    property low_tx_valid;
        @(posedge clk) disable iff(~rsrn)
         (rx_valid && (din[9:8]==2'b00 || din[9:8]== 2'b01 || din[9:8]==2'b10 )) |=> (tx_valid==0);
    endproperty
    assert_low_tx_valid: assert property(low_tx_valid) 
        else $error("tx_valid is high when rx_valid is high and din[9:8] is 00 or 01 or 10");
    cover_low_tx_valid: cover property(low_tx_valid);


    property high_tx_valid;
        @(posedge clk) disable iff(~rsrn)
         (rx_valid && (din[9:8]==2'b11)) |=> $rose(tx_valid);
    endproperty
    assert_high_tx_valid: assert property(high_tx_valid)
        else $error("tx_valid is not high when rx_valid is high and din[9:8] is 11");               
    cover_high_tx_valid: cover property(high_tx_valid);
    

    property write_addr_then_write_data;
    @(posedge clk) disable iff (~rstn)
    (rx_valid && (din[9:8] == 2'b00)) |-> ##[1:$] (rx_valid && (din[9:8] == 2'b01));
    endproperty
    assert_write_addr_then_write_data: assert property(write_addr_then_write_data)
        else $error("write address is not followed by write data");
    cover_write_addr_then_write_data: cover property(write_addr_then_write_data);


    property read_addr_then_read_data;
    @(posedge clk) disable iff (~rstn)
    (rx_valid && (din[9:8] == 2'b10)) |-> ##[1:$] (rx_valid && (din[9:8] == 2'b11));
    endproperty
    assert_read_addr_then_read_data: assert property(read_addr_then_read_data)
        else $error("read address is not followed by read data");
    cover_read_addr_then_read_data: cover property(read_addr_then_read_data);

    
endmodule