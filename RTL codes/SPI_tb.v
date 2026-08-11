module SPI_tb();
    reg clk, rstn, mosi, ss_n;
    wire miso;

    reg [7:0] rd_wr_address;
    integer i;

    SPI_wrapper dut (clk, rstn, mosi, miso, ss_n);
    
    localparam WR_ADDR = 3'b000;
    localparam WR_DATA = 3'b001;
    localparam RD_ADDR = 3'b110;
    localparam RD_DATA = 3'b111;

    reg [2:0] current_op;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $readmemh("mem.dat", dut.ram.mem);
        i = 0;
        rd_wr_address = 0;
        current_op = WR_ADDR;

        assert_reset();
        // 1. Write Address
        start_comm(); 
        current_op = WR_ADDR;
        for (i = 2; i >= 0; i = i - 1) begin
            @(negedge clk);
            mosi = current_op[i]; 
        end
        for (i = 7; i >= 0; i = i - 1) begin 
            @(negedge clk);
            mosi = $random;
            rd_wr_address[i] = mosi;
        end
        end_comm();
        
        // 2. Write Data
        start_comm();
        current_op = WR_DATA;
        for (i = 2; i >= 0; i = i - 1) begin
            @(negedge clk);
            mosi = current_op[i]; 
        end
        repeat(8) begin
            @(negedge clk);
            mosi = $random; 
        end
        end_comm();
        

        // 3. Read Address
        start_comm();
        current_op = RD_ADDR;
        for (i = 2; i >= 0; i = i - 1) begin
            @(negedge clk);
            mosi = current_op[i]; 
        end
        for (i = 7; i >= 0; i = i - 1) begin 
            @(negedge clk);
            mosi = rd_wr_address[i]; 
        end
        end_comm();
        
        // 4. Read Data 
        start_comm();
        current_op = RD_DATA;
        for (i = 2; i >= 0; i = i - 1) begin
            @(negedge clk);
            mosi = current_op[i]; 
        end
        repeat(8) begin
            @(negedge clk);
            mosi = $random; // Dummy bits
        end
        repeat(8) @(negedge clk);
        end_comm();
        repeat(5) @(negedge clk);
        $stop;
    end

    task assert_reset;
    begin
        ss_n = 1;
        rstn = 0;
        mosi = 0;
        @(negedge clk);
        rstn = 1;
        @(negedge clk);
    end
    endtask

    task start_comm();
    begin
        @(negedge clk);
        ss_n = 0;
    end
    endtask

    task end_comm();
    begin
        @(negedge clk);
        ss_n = 1; 
        @(negedge clk);
    end
    endtask

endmodule