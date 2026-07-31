module SPI_slave(mosi, ss_n ,rx_data, rx_valid, clk, rstn, tx_data, tx_valid, miso);
    input mosi, ss_n, clk, rstn;
    input [7:0]tx_data;
    input tx_valid;
    output reg [9:0] rx_data;
    output reg rx_valid, miso;

    localparam IDLE=3'b000;
    localparam WRITE=3'b001;
    localparam READ_DATA=3'b010;
    localparam READ_ADD=3'b011;
    localparam CHK_CMD=3'b100;

    reg [2:0] current_state, next_state;
    reg [3:0] counter;
    reg [9:0] serial2Parallel;
    reg addr_received;

    always @(posedge clk) begin
        if(~rstn)
            current_state<=IDLE;
        else
            current_state<=next_state;
    end

    always @(*) begin 
        case(current_state)
        IDLE:begin
            if(ss_n) next_state<=IDLE;
            else next_state<=CHK_CMD;
        end
        WRITE:begin
            if(ss_n) next_state<=IDLE;
            else next_state<=WRITE;
        end
        READ_DATA:begin
            if(ss_n) next_state<=IDLE;
            else next_state<=READ_DATA;
        end
        READ_ADD:begin
            if(ss_n) next_state<=IDLE;
            else next_state<=READ_ADD;
        end
        CHK_CMD:begin
            if(ss_n) next_state<=IDLE;
            else begin
                if(~mosi) next_state<=WRITE;
                else begin
                    if(addr_received) next_state<=READ_DATA;
                    else next_state<=READ_ADD;
                end
            end 
        end
        default: next_state<=IDLE;
        endcase
    end


    always @(posedge clk) begin
        if(~rstn)begin
            counter<=0;
            serial2Parallel<=0;
            addr_received<=0;
            rx_data<=0;
            rx_valid<=0;
            miso<=1'b0;
        end 
        else begin
            case(current_state)
            IDLE:begin
                counter<=0;
                serial2Parallel<=0;
                addr_received<=0;
                rx_valid<=0;
                miso<=1'b0;
            end

            WRITE:begin
                if(counter<10)begin
                    serial2Parallel<={serial2Parallel[8:0],mosi};
                    counter<=counter+1;
                    rx_valid<=0;
                end
                else begin
                    rx_data<=serial2Parallel;
                    rx_valid<=1;
                    counter<=0;
                end
            end

            READ_DATA:begin
                if(tx_valid)begin
                    rx_valid<=0;
                    if(counter<8)begin
                        miso<=tx_data[7-counter];
                        counter<=counter+1;
                    end
                    else begin
                        addr_received<=0;
                        counter<=0;
                    end  
                end 
                else begin
                    if(counter<10)begin
                        serial2Parallel<={serial2Parallel[8:0],mosi};
                        counter<=counter+1;
                        rx_valid<=0;
                    end
                    else begin
                        rx_data<=serial2Parallel;
                        rx_valid<=1;
                        counter<=0;
                    end
                end 
            end

            READ_ADD:begin
                if(counter<10)begin
                    serial2Parallel<={serial2Parallel[8:0],mosi};
                    counter<=counter+1;
                    rx_valid<=0;
                end
                else begin
                    rx_data<=serial2Parallel;
                    rx_valid<=1;
                    addr_received<=1;
                    counter<=0;
                end
            end
            CHK_CMD:begin
                counter<=0;
                addr_received<=0;
                rx_valid<=0;
                miso<=1'b0;
            end
            default:begin
                counter<=0;
                serial2Parallel<=0;
                addr_received<=0;
                rx_data<=0;
                rx_valid<=0;
                miso<=1'b0;
            end
            endcase
        end 
    end 
endmodule