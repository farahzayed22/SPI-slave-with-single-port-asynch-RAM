package RAM_write_only_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import RAM_seq_item_pkg::*;

    class RAM_write_only_seq extends uvm_sequence #(RAM_seq_item);
        `uvm_object_utils(RAM_write_only_seq)

        RAM_seq_item seq_item;
        typedef enum logic [1:0] {WR_ADDR = 2'b00, WR_DATA = 2'b01} op_e;
        op_e prev_op = WR_DATA; 
        
        function new(string name="RAM_write_only_seq");
            super.new(name);
        endfunction

        task body;
            seq_item = RAM_seq_item::type_id::create("write_only_seq_item");

            repeat (1000) begin
                start_item(seq_item);
                
                assert(seq_item.randomize() with {
                    rstn     == 1'b1;
                    rx_valid == 1'b1;
                    
                    // If prev was Write Address (2'b00), next must be 2'b00 or 2'b01
                    if (prev_op == WR_ADDR) {
                        din[9:8] inside {2'b00, 2'b01};
                    } else {
                        din[9:8] inside {2'b00, 2'b01}; // Write ops only
                    }
                });
                
                prev_op = op_e'(seq_item.din[9:8]);
                finish_item(seq_item);
            end
        endtask
    endclass

endpackage 