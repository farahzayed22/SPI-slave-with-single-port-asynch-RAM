package wrapper_write_only_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import wrapper_seq_item_pkg::*;

    class wrapper_write_only_seq extends uvm_sequence #(wrapper_seq_item);
        `uvm_object_utils(wrapper_write_only_seq)

        wrapper_seq_item seq_item;
        op_e prev_op =WR_ADDR; // Initialize to WR_ADDR for the first iteration; 
        function new(string name="wrapper_write_only_seq");
            super.new(name);
        endfunction

        task body;
            seq_item = wrapper_seq_item::type_id::create("write_only_seq_item");

            repeat (1000) begin
                start_item(seq_item);
                
                assert(seq_item.randomize() with {
                    rstn== 1'b1;
                    // If prev was Write Address (2'b00), next must be 2'b00 or 2'b01
                    if (prev_op == WR_ADDR) {
                        opcode inside {WR_ADDR, WR_DATA};
                    } else {
                        opcode inside {WR_ADDR, WR_DATA}; // Write ops only
                    }
                });
               
                    prev_op = seq_item.opcode;
                
                finish_item(seq_item);
            end
        endtask
    endclass
endpackage 

