package RAM_read_only_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import RAM_seq_item_pkg::*;

    class RAM_read_only_seq extends uvm_sequence #(RAM_seq_item);
        `uvm_component_utils(RAM_read_only_seq)

        RAM_seq_item seq_item;

        function new(string name="RAM_read_only_seq");
            super.new(name );
        endfunction

        task body;
            seq_item=RAM_seq_item::type_id::create("read_only_seq_item");
            start_item(seq_item);
            assert(seq_item.randomize() with {seq_item.rx_valid=1; seq_item.din[9]=1;});
            finish_item(seq_item);
        endtask
    endclass

endpackage 