package wrapper_read_only_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import wrapper_seq_item_pkg::*;

    class wrapper_read_only_seq extends uvm_sequence #(wrapper_seq_item);
        `uvm_object_utils(wrapper_read_only_seq)

        wrapper_seq_item seq_item;
        op_e prev_op = WR_ADDR; // Initialize to WR_ADDR for the first iteration
        function new(string name="wrapper_read_only_seq");
            super.new(name );
        endfunction

        task body;
            seq_item=wrapper_seq_item::type_id::create("read_only_seq_item");
            repeat (1000) begin
    
            start_item(seq_item);
            assert(seq_item.randomize() with {
                rstn== 1'b1;
                opcode dist{RD_ADDR := 50 , RD_DATA := 50}; 
                });
                finish_item(seq_item);

            end
        endtask
    endclass

endpackage 