package wrapper_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    typedef enum logic [2:0]{
            WR_ADDR = 3'b000,
            WR_DATA = 3'b001, 
            RD_ADDR = 3'b110,
            RD_DATA = 3'b111
        } op_e;

    class wrapper_seq_item extends uvm_sequence_item;
        `uvm_object_utils(wrapper_seq_item)

        rand logic mosi, ss_n, rstn;
        rand logic [7:0] tx_data;
        rand logic tx_valid;
        logic [9:0] rx_data;
        logic rx_valid, miso;
        
        // ref outputs
        logic [9:0] rx_data_ref;
        logic rx_valid_ref, miso_ref;

        // Shared frame tracking across items
        static int cycle_count = 0;

        rand op_e opcode;
        static op_e current_frame_op; // Locks opcode for the entire burst

        function new(string name="wrapper_seq_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("tx_valid=%0b, tx_data=%0h, rx_valid=%0b, rx_valid_ref=%0b, rx_data=%0h, rx_data_ref=%0h, mosi=%0b, miso=%0b, ss_n=%0b, rstn=%0b", 
                             tx_valid, tx_data, rx_valid, rx_valid_ref, rx_data, rx_data_ref, mosi, miso, ss_n, rstn);
        endfunction

        function string convert2string_stimulus();
             return $sformatf("tx_valid=%0b, tx_data=%0h, mosi=%0b, ss_n=%0b, rstn=%0b", tx_valid, tx_data, mosi, ss_n, rstn);
        endfunction

        // Constraints
        constraint reset_deassertion {
            rstn dist {0:/5, 1:/95};
        }

        constraint ss_n_assertion {
            if (opcode == RD_DATA) {
                if (cycle_count <23) ss_n == 0; // Cycle 23 (index 22) high
                else ss_n == 1;
            } else {
                if (cycle_count < 13) ss_n == 0; // Cycle 13 (index 12) high
                else ss_n == 1;
            }
        }

        constraint mosi_randomization {
            if (ss_n == 0) {
                if (cycle_count == 0)      mosi== opcode[2];
                else if (cycle_count == 1) mosi== opcode[1];
                else if (cycle_count == 2) mosi== opcode[0];
    
            }
        }
      
        constraint tx_valid_randomization {
            if (cycle_count >= 15) { tx_valid == 1; }
            else { tx_valid == 0; }
        }

        function void post_randomize();
            super.post_randomize();
            if (cycle_count == 0) begin
                current_frame_op = opcode; // Latch opcode at cycle 0
            end
            if (cycle_count > 0) begin
                opcode = current_frame_op;
            end
            if (ss_n == 1'b1) begin
                cycle_count = 0; // Reset counter when frame completes
            end else begin
                cycle_count++;   
            end
        endfunction
        
    endclass
endpackage
