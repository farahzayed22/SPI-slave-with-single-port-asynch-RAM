module asynch_ram(din,clk,rstn,rx_valid,dout,tx_valid);
    parameter MEM_DEPTH=256;
    parameter ADDR_SIZE=8;
    input [9:0] din;
    input clk,rstn,rx_valid;
    output reg [7:0] dout;
    output reg tx_valid;
    
    reg [ADDR_SIZE-1:0]wr_addr,rd_addr;
    reg [ADDR_SIZE-1:0] mem [0:MEM_DEPTH-1];

    assign tx_valid= din[9] && din[8]? 1: 0;
    
    always @(posedge clk) begin 
        if(~rstn)begin
            dout<=0;
            tx_valid<=0;
            wr_addr<=0;
            rd_addr<=0;
        end
        else begin
            tx_valid<=0;
            if(rx_valid)begin
                case(din[9:8])
                2'b00: wr_addr<=din[7:0];
                2'b01: mem[wr_addr]<=din[7:0];
                2'b10: rd_addr<=din[7:0];
                2'b11: begin 
                    dout<=mem[rd_addr];
                    tx_valid<=1;
                end
                default:begin
                    dout<=0;
                    tx_valid<=0;
                end
                endcase
            end
        end
    end
endmodule