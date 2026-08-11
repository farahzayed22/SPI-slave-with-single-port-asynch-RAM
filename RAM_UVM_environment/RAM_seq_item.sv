package RAM_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class RAM_seq_item extends uvm_sequence_item;
        `uvm_object_utils(RAM_seq_item)

        rand logic[9:0] din;
        rand logic rx_valid;
        logic[7:0] dout;
        logic tx_valid;
        rand logic rstn;
        
        function new(string name="RAM_seq_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("din=%0h, rx_valid=%0b, dout=%0h, tx_valid=%0b",din,rx_valid,dout,tx_valid);
        endfunction

        function string convert2string_stimulus();
             return $sformatf("din=%0h, rx_valid=%0b",din,rx_valid);
        endfunction

        // constraints
        constraint reset_deassertion{
            rstn dist{0:/5 , 1:/95};
        }
        
        constraint rx_valid_assertion{
            rx_valid dist{0:/20 , 1:/80};
        }
        
    endclass
endpackage