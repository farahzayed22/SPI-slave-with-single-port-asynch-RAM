package RAM_read_only_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import RAM_seq_item_pkg::*;

    class RAM_read_only_seq extends uvm_sequence #(RAM_seq_item);
        `uvm_object_utils(RAM_read_only_seq)

        RAM_seq_item seq_item;
        function new(string name="RAM_read_only_seq");
            super.new(name );
        endfunction

        task body;
            seq_item=RAM_seq_item::type_id::create("read_only_seq_item");
            repeat (1000) begin
    
            start_item(seq_item);
            assert(seq_item.randomize() with {
                rstn     == 1'b1;
                rx_valid == 1'b1;
                din[9:8] == 2'b10; 
                });
                finish_item(seq_item);

            // Step 2: Send Read Command (2'b11)
            start_item(seq_item);
            assert(seq_item.randomize() with {
                rstn     == 1'b1;
                rx_valid == 1'b1;
                din[9:8] == 2'b11; 
                });
            finish_item(seq_item);
            
            // Drive Idle Cycle to force tx_valid low on the next clock
            start_item(seq_item);
            assert(seq_item.randomize() with { rx_valid == 0; rstn == 1; });
            finish_item(seq_item);
            end
        endtask
    endclass
endpackage 

