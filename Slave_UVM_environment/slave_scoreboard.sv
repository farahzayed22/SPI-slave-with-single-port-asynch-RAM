package slave_scoreboard_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import slave_seq_item_pkg::*;
    
    class slave_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(slave_scoreboard)
       
        uvm_analysis_export #(slave_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(slave_seq_item) sb_fifo;
        slave_seq_item seq_item_sb;

        int error_count = 0;
        int correct_count = 0;

        function new(string name = "slave_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export", this);
            sb_fifo = new("sb_fifo", this);
        endfunction
        
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                sb_fifo.get(seq_item_sb);

                if (seq_item_sb.rx_valid !== seq_item_sb.rx_valid_ref ||seq_item_sb.rx_data !== seq_item_sb.rx_data_ref || seq_item_sb.miso !== seq_item_sb.miso_ref) begin
                    `uvm_error("scoreboard run_phase",$sformatf("rx_valid comparison: DUT rx_valid=%0b, reference rx_valid_ref=%0b, \
                                rx_valid_data comparison: DUT rx_valid_data=%0h, reference rx_data_ref=%0h, \
                                miso comparison:DUT miso=%0b, reference miso_ref=%0b, transaction=%s",
                                seq_item_sb.rx_valid , seq_item_sb.rx_valid_ref , seq_item_sb.rx_data, seq_item_sb.rx_data_ref ,
                                seq_item_sb.miso , seq_item_sb.miso_ref , seq_item_sb.convert2string()))
                    error_count++;
                end
                else
                    correct_count++;
                end
        endtask
        
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("total_success %0d", correct_count), UVM_LOW);
            `uvm_info("report_phase", $sformatf("total_fail %0d", error_count), UVM_LOW);
        endfunction
    endclass
endpackage

