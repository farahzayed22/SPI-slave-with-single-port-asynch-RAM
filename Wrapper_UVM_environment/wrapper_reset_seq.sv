package wrapper_reset_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import wrapper_seq_item_pkg::*;

    class wrapper_reset_seq extends uvm_sequence #(wrapper_seq_item);
        `uvm_object_utils(wrapper_reset_seq)

        wrapper_seq_item seq_item;

        function new(string name="wrapper_reset_seq");
            super.new(name);
        endfunction

        task body;
            seq_item=wrapper_seq_item::type_id::create("reset_seq_item");
            repeat (10) begin
                start_item(seq_item);
                assert(seq_item.randomize() with {
                    rstn     == 1'b0;
                    opcode == WR_ADDR;
                });
                finish_item(seq_item);
            end

        endtask
    endclass

endpackage 

