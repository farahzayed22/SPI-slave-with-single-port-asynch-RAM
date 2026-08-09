package wrapper_read_write_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import wrapper_seq_item_pkg::*;

    class wrapper_read_write_seq extends uvm_sequence #(wrapper_seq_item);
        `uvm_object_utils(wrapper_read_write_seq)

        wrapper_seq_item seq_item;
        op_e prev_op =WR_ADDR; // Initialize to WR_ADDR for the first iteration;
        function new(string name="wrapper_read_write_seq");
            super.new(name);
        endfunction

        task body;
            seq_item = wrapper_seq_item::type_id::create("read_write_seq_item");

            repeat (5000) begin
                start_item(seq_item);

                assert(seq_item.randomize() with {
                    rstn== 1'b1;
                    // 1. After Write Address -> Write Address or Write Data
                    if (prev_op == WR_ADDR) {
                        opcode inside {WR_ADDR, WR_DATA};
                    } 
                    // 2. After Write Data -> 60% Read Addr, 40% Write Addr
                    else if (prev_op == WR_DATA) {
                        opcode dist {RD_ADDR := 60, WR_ADDR := 40};
                    } 
                    // 3. After Read Address -> Read Data
                    else if (prev_op == RD_ADDR) {
                        opcode == RD_DATA;
                    } 
                    // 4. After Read Data -> 60% Write Addr, 40% Read Addr
                    else if (prev_op == RD_DATA) {
                        opcode dist {WR_ADDR := 60, RD_ADDR := 40};
                    }
                });

                    prev_op = seq_item.opcode;
                
                finish_item(seq_item);
            
            end
        endtask
    endclass
endpackage