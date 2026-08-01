package RAM_read_write_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import RAM_seq_item_pkg::*;

    class RAM_read_write_seq extends uvm_sequence #(RAM_seq_item);
        `uvm_component_utils(RAM_read_write_seq)

        RAM_seq_item seq_item;

        function new(string name="RAM_read_write_seq");
            super.new(name );
        endfunction

        task body;
            seq_item=RAM_seq_item::type_id::create("read_write_seq_item");
            start_item(seq_item);
            assert(seq_item.randomize() with {
                seq_item.rx_valid=1;
                seq_item.din[9] dist{1:/50, 0:/50};
                seq_item.din[8] dist{1:/50, 0:/50};
            });
            finish_item(seq_item);
        endtask
    endclass

endpackage 