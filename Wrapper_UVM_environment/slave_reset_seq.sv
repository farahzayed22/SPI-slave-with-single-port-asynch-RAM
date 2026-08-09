package slave_reset_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import slave_seq_item_pkg::*;

    class slave_reset_seq extends uvm_sequence #(slave_seq_item);
        `uvm_object_utils(slave_reset_seq)

        slave_seq_item seq_item;

        function new(string name="slave_reset_seq");
            super.new(name);
        endfunction

        task body;
            seq_item=slave_seq_item::type_id::create("reset_seq_item");
            start_item(seq_item);
            seq_item.rstn=0;
            seq_item.tx_valid=0;
            seq_item.tx_data=0;
            seq_item.mosi=0;
             seq_item.ss_n=1;
            finish_item(seq_item);
        endtask
    endclass

endpackage 