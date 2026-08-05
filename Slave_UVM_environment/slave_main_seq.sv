package slave_main_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import slave_seq_item_pkg::*;

    class slave_main_seq extends uvm_sequence #(slave_seq_item);
        `uvm_object_utils(slave_main_seq)

        slave_seq_item seq_item;
        function new(string name="slave_main_seq");
            super.new(name);
        endfunction

        task body;
            seq_item = slave_seq_item::type_id::create("main_seq_item");
            repeat (1000) begin
                start_item(seq_item);
                assert(seq_item.randomize() );
                finish_item(seq_item);
            end
        endtask
    endclass

endpackage 