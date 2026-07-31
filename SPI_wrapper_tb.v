module SPI_wrapper_tb();
    reg clk,rst,MOSI,SS_n;
    wire MISO;

    SPI_wrapper dut (.clk(clk),.rstn(rst),.mosi(MOSI),.miso(MISO),.ss_n(SS_n));
    reg [7:0] randomized_address;
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    integer i;
    initial begin
        // $readmemh ("ram.dat", dut.ram.mem);
        i = 0;
        randomized_address = 0;
        //test reset
        rst = 0;
        MOSI = 0;
        SS_n = 1;
        repeat(10) @(negedge clk);

        //test idle
        rst = 1;
        repeat(10) @(negedge clk);

        //test write address
        SS_n = 0; //initialize communication
        @(negedge clk);
        MOSI = 0;      //select write
        @(negedge clk);
        MOSI = 0;      // sending the control bits "00" (write address)
        @(negedge clk);
        MOSI = 0;
        @(negedge clk);
        for (i = 7; i >= 0; i = i - 1) begin
            MOSI = $random; //sending random 8 bits data
            //save that address to use it again in the tb
            randomized_address[i] = MOSI;
            @(negedge clk);
        end
        SS_n =1; // end of comm
        repeat(2) @(negedge clk);

        //test write data
        SS_n = 0; //initialize communication
        @(negedge clk);
        MOSI = 0; //select write
        @(negedge clk);
        MOSI = 0;      // sending the control bits "01" (write data)
        @(negedge clk);
        MOSI = 1;
        @(negedge clk);
        repeat(8) begin
            MOSI = $random; //sending random 8 bits data
            @(negedge clk);
        end
        SS_n =1; // end of comm
        repeat(2) @(negedge clk);

        //test read address
        SS_n = 0; //initialize communication
        @(negedge clk);
        MOSI = 1; //select read
        @(negedge clk);
        MOSI = 1;      // sending the control bits "10" (read address)
        @(negedge clk);
        MOSI = 0;
        @(negedge clk);
        for (i = 7; i >= 0; i = i - 1) begin
            MOSI = randomized_address[i];
            //send the address we generated earlier bits data
            @(negedge clk);
        end
        SS_n =1; // end of comm
        repeat(2) @(negedge clk);

        //test read data
        SS_n = 0; //initialize communication
        @(negedge clk);
        MOSI = 1; //select read
        @(negedge clk);
        MOSI = 1;      // sending the control bits "11" (write data)
        @(negedge clk);
        MOSI = 1;
        @(negedge clk);
        repeat(8) begin
            MOSI = $random; //sending random 8 bits data (DUMMY BITS)
            @(negedge clk);
        end
        repeat(8) @(negedge clk); // get the data of tx
        SS_n =1; // end of comm
        repeat(5) @(negedge clk);

        $stop;
    end
endmodule