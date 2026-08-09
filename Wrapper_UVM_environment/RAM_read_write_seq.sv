package RAM_read_write_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import RAM_seq_item_pkg::*;

    class RAM_read_write_seq extends uvm_sequence #(RAM_seq_item);
        `uvm_object_utils(RAM_read_write_seq)

        RAM_seq_item seq_item;
        typedef enum logic [1:0] {
            WR_ADDR = 2'b00,
            WR_DATA = 2'b01,
            RD_ADDR = 2'b10,
            RD_DATA = 2'b11
        } op_e;

        op_e prev_op = WR_DATA; // Initialize state

        function new(string name="RAM_read_write_seq");
            super.new(name);
        endfunction

        task body;
            seq_item = RAM_seq_item::type_id::create("read_write_seq_item");

            repeat (1000) begin
                start_item(seq_item);

                assert(seq_item.randomize() with {
                    rstn     == 1'b1;
                    rx_valid == 1'b1;

                    // 1. After Write Address -> Write Address or Write Data
                    if (prev_op == WR_ADDR) {
                        din[9:8] inside {2'b00, 2'b01};
                    } 
                    // 2. After Write Data -> 60% Read Addr, 40% Write Addr
                    else if (prev_op == WR_DATA) {
                        din[9:8] dist {2'b10 := 60, 2'b00 := 40};
                    } 
                    // 3. After Read Address -> Read Data
                    else if (prev_op == RD_ADDR) {
                        din[9:8] == 2'b11;
                    } 
                    // 4. After Read Data -> 60% Write Addr, 40% Read Addr
                    else if (prev_op == RD_DATA) {
                        din[9:8] dist {2'b00 := 60, 2'b10 := 40};
                    }
                });

                prev_op = op_e'(seq_item.din[9:8]);
                finish_item(seq_item);
            end
             
        endtask
    endclass
endpackage