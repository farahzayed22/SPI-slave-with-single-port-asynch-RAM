package RAM_reset_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import RAM_seq_item_pkg::*;

    class RAM_reset_seq extends uvm_sequence #(RAM_seq_item);
        `uvm_component_utils(RAM_reset_seq)

        RAM_seq_item seq_item;

        function new(string name="RAM_reset_seq");
            super.new(name);
        endfunction

        task body;
            seq_item=RAM_seq_item::type_id::create("reset_seq_item");
            start_item(seq_item);
            seq_item.rstn=0;
            seq_item.din=0;
            seq_item.rx_valid=0;
            finish_item(seq_item);
        endtask
    endclass

endpackage 