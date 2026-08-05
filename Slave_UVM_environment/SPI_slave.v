module SPI_slave(mosi, ss_n, rx_data, rx_valid, clk, rstn, tx_data, tx_valid, miso);
    input mosi, ss_n, clk, rstn;
    input [7:0] tx_data;
    input tx_valid;
    output reg [9:0] rx_data;
    output reg rx_valid, miso;

    localparam IDLE      = 3'b000;
    localparam WRITE     = 3'b001;
    localparam READ_DATA = 3'b010;
    localparam READ_ADD  = 3'b011;
    localparam CHK_CMD   = 3'b100;

    reg [2:0] current_state, next_state;
    reg [3:0] counter;
    // reg [9:0] serial2Parallel;
    // reg [7:0] parallel2Serial;
    // reg tx_busy;
    reg addr_received;

    
    always @(posedge clk) begin
        if (~rstn)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

   
     always @(*) begin 
        case (current_state)
            IDLE: begin
                if (ss_n) next_state = IDLE;
                else      next_state = CHK_CMD;
            end
            WRITE: begin
                if (ss_n) next_state = IDLE;
                else      next_state = WRITE;
            end
            READ_DATA: begin
                if (ss_n) next_state = IDLE;
                else      next_state = READ_DATA;
            end
            READ_ADD: begin
                if (ss_n) next_state = IDLE;
                else      next_state = READ_ADD;
            end
            CHK_CMD: begin
                if (ss_n) next_state = IDLE;
                else begin
                    if (~mosi) next_state = WRITE;
                    else begin
                        if (addr_received) next_state = READ_DATA;
                        else               next_state = READ_ADD;
                    end
                end 
            end
            default: next_state = IDLE;
        endcase
    end

    
    always @(posedge clk) begin 
    if (~rstn) begin 
        rx_data <= 0;
        rx_valid <= 0;
        addr_received <= 0;
        miso <= 0; 
        counter <= 0;
    end
    else begin
        case (current_state)
            IDLE : begin
                rx_valid <= 0;
                miso<=0;
            end
            CHK_CMD : begin
                counter <= 10;  
                miso<=0;    
            end
            WRITE : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= mosi;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                end
            end
            READ_ADD : begin
                if (counter > 0 ) begin
                    rx_data[counter-1] <= mosi;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                    addr_received <= 1;
                end
            end
            READ_DATA : begin
                if (tx_valid) begin
                    rx_valid <= 0;
                    if (counter > 0 ) begin
                        miso <= tx_data[counter-1]; 
                        counter <= counter - 1;
                    end
                    else begin
                        addr_received <= 0;
                    end
                end
                else begin
                    if (counter > 0) begin
                        rx_data[counter-1] <= mosi;
                        counter <= counter - 1;
                    end
                    else begin
                        rx_valid <= 1;
                        counter <= 8;  /// BUG FIXED
                    end
                end
                
            end
            default : begin
                counter <= 0;
                miso <= 1'b0;
            end
        endcase
        end
    end

    `ifdef SIM

        // -------------------------------------------------------------------------
        // 1. IDLE -> CHK_CMD
        // -------------------------------------------------------------------------
        property p_trans_from_idle_to_cmd;
            @(posedge clk) disable iff (~rstn)
            (current_state == IDLE && ~ss_n) |=> (current_state == CHK_CMD);
        endproperty 

        a_trans_from_idle_to_cmd: assert property(p_trans_from_idle_to_cmd) 
            else $error("SVA ERROR: transition from IDLE to CHK_CMD failed");
        c_trans_from_idle_to_cmd: cover property(p_trans_from_idle_to_cmd);


        // -------------------------------------------------------------------------
        // 2. CHK_CMD -> WRITE
        // -------------------------------------------------------------------------
        property p_trans_from_cmd_to_write;
            @(posedge clk) disable iff (~rstn)
            (current_state == CHK_CMD && ~mosi && ~ss_n) |=> (current_state == WRITE);
        endproperty

        a_trans_from_cmd_to_write: assert property(p_trans_from_cmd_to_write) 
            else $error("SVA ERROR: transition from CHK_CMD to WRITE failed");
        c_trans_from_cmd_to_write: cover property(p_trans_from_cmd_to_write);


        // -------------------------------------------------------------------------
        // 3. CHK_CMD -> READ_ADD
        // -------------------------------------------------------------------------
        property p_trans_from_cmd_to_read_address;
            @(posedge clk) disable iff (~rstn)
            (current_state == CHK_CMD && mosi && ~addr_received && ~ss_n) |=> (current_state == READ_ADD);
        endproperty

        a_trans_from_cmd_to_read_address: assert property(p_trans_from_cmd_to_read_address) 
            else $error("SVA ERROR: transition from CHK_CMD to READ_ADD failed");
        c_trans_from_cmd_to_read_address: cover property(p_trans_from_cmd_to_read_address);


        // -------------------------------------------------------------------------
        // 4. CHK_CMD -> READ_DATA
        // -------------------------------------------------------------------------
        property p_trans_from_cmd_to_read_data;
            @(posedge clk) disable iff (~rstn)
            (current_state == CHK_CMD && mosi && addr_received && ~ss_n) |=> (current_state == READ_DATA);
        endproperty

        a_trans_from_cmd_to_read_data: assert property(p_trans_from_cmd_to_read_data) 
            else $error("SVA ERROR: transition from CHK_CMD to READ_DATA failed");
        c_trans_from_cmd_to_read_data: cover property(p_trans_from_cmd_to_read_data);


        // -------------------------------------------------------------------------
        // 5. WRITE -> IDLE
        // -------------------------------------------------------------------------
        property p_trans_from_write_to_idle;
            @(posedge clk) disable iff (~rstn)
            (current_state == WRITE && ss_n) |=> (current_state == IDLE);
        endproperty

        a_trans_from_write_to_idle: assert property(p_trans_from_write_to_idle) 
            else $error("SVA ERROR: transition from WRITE to IDLE failed");
        c_trans_from_write_to_idle: cover property(p_trans_from_write_to_idle);


        // -------------------------------------------------------------------------
        // 6. READ_ADD -> IDLE
        // -------------------------------------------------------------------------
        property p_trans_from_read_address_to_idle;
            @(posedge clk) disable iff (~rstn)
            (current_state == READ_ADD && ss_n) |=> (current_state == IDLE);
        endproperty

        a_trans_from_read_address_to_idle: assert property(p_trans_from_read_address_to_idle) 
            else $error("SVA ERROR: transition from READ_ADD to IDLE failed");
        c_trans_from_read_address_to_idle: cover property(p_trans_from_read_address_to_idle);


        // -------------------------------------------------------------------------
        // 7. READ_DATA -> IDLE
        // -------------------------------------------------------------------------
        property p_trans_from_read_data_to_idle;
            @(posedge clk) disable iff (~rstn)
            (current_state == READ_DATA && ss_n) |=> (current_state == IDLE);
        endproperty

        a_trans_from_read_data_to_idle: assert property(p_trans_from_read_data_to_idle) 
            else $error("SVA ERROR: transition from READ_DATA to IDLE failed");
        c_trans_from_read_data_to_idle: cover property(p_trans_from_read_data_to_idle);

    `endif
endmodule