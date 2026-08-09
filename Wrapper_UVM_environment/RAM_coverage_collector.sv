package RAM_coverage_collector_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import RAM_seq_item_pkg::*;

    class RAM_coverage_collector extends uvm_component;
        `uvm_component_utils(RAM_coverage_collector)

        uvm_analysis_export #(RAM_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(RAM_seq_item) cov_RAM;
        RAM_seq_item seq_item_cov;

        covergroup RAM_cvg_gp;
            din_cp: coverpoint seq_item_cov.din[9:8] {
                bins write_addr = {2'b00};
                bins write_data = {2'b01};
                bins read_addr = {2'b10};
                bins read_data = {2'b11};
            }
            
            wr_data_after_addr_cp: coverpoint seq_item_cov.din[9:8] {
                bins write_data_after_addr = (2'b00 => 2'b01);
            }

            rd_data_after_addr_cp: coverpoint seq_item_cov.din[9:8] {
                bins read_data_after_addr = (2'b10 => 2'b11);
            }

            rx_valid_cp: coverpoint seq_item_cov.rx_valid {
                bins rx_valid_high = {1'b1};
                bins rx_valid_low = {1'b0};
            }
            tx_valid_cp: coverpoint seq_item_cov.tx_valid {
                bins tx_valid_high = {1'b1};
                bins tx_valid_low = {1'b0};
            }
            crs_din_rx_cp: cross din_cp, rx_valid_cp {
                ignore_bins ignore = binsof(rx_valid_cp) intersect {0} && binsof(din_cp);
            }

            crs_read_tx_cp: cross din_cp, tx_valid_cp {
                bins read_data_with_h_tx = binsof(tx_valid_cp) intersect {1'b1} && binsof(din_cp) intersect {2'b11};
                ignore_bins ignored=  binsof(tx_valid_cp) intersect {1'b1} && binsof(din_cp) intersect {2'b00, 2'b01, 2'b10};
            }

        endgroup


        function new(string name = "RAM_coverage_collector", uvm_component parent = null);
            super.new(name, parent);
             RAM_cvg_gp=new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export", this);
            cov_RAM = new("cov_RAM", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_RAM.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_RAM.get(seq_item_cov);
                RAM_cvg_gp.sample();
            end
        endtask
    endclass
endpackage