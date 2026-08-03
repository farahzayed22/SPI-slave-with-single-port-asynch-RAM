module asynch_ram(din,clk,rstn,rx_valid,dout,tx_valid);
    parameter MEM_DEPTH=256;
    parameter ADDR_SIZE=8;
    input [9:0] din;
    input clk,rstn,rx_valid;
    output reg [7:0] dout;
    output reg tx_valid;
    
    reg [ADDR_SIZE-1:0]wr_addr,rd_addr;
    reg [ADDR_SIZE-1:0] mem [0:MEM_DEPTH-1];

    always @(posedge clk) begin 
        if(~rstn)begin
            dout<=0;
            tx_valid<=0;
            wr_addr<=0;
            rd_addr<=0;
        end
        else begin
            if(rx_valid)begin
                case(din[9:8])
                2'b00:begin 
                    wr_addr<=din[7:0];
                end
                2'b01:begin
                    mem[wr_addr]<=din[7:0];
                end
                2'b10:begin 
                    rd_addr<=din[7:0];
                end
                2'b11: begin 
                    dout<=mem[rd_addr];
                end
                default:begin
                    dout<=0;
                    
                end
                endcase
            end 
            else dout<=0;
            tx_valid<= (din[9:8]==2'b11 && rx_valid) ? 1'b1 : 1'b0;
        end
    end
endmodule