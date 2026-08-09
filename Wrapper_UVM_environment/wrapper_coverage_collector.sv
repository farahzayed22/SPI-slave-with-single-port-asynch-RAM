package wrapper_coverage_collector_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import wrapper_seq_item_pkg::*;

    class wrapper_coverage_collector extends uvm_component;
        `uvm_component_utils(wrapper_coverage_collector)

        uvm_analysis_export #(wrapper_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(wrapper_seq_item) cov_wrapper;
        wrapper_seq_item seq_item_cov;

        covergroup wrapper_cvg_gp;
            
            ss_n_cp: coverpoint seq_item_cov.ss_n{
                bins normal_ops_trns= (1=> 0[*13] => 1);
                bins rd_data_op_trns= (1=> 0[*23] => 1);
            }

            mosi_cp: coverpoint seq_item_cov.mosi{
                bins wr_addr= (0 => 0 => 0);
                bins wr_data= (0 => 0 => 1);
                bins rd_addr= (1 => 1 => 0);
                bins rd_data= (1 => 1 => 1);
            }
            
            crs_cove_ssn_mosi: cross mosi_cp , ss_n_cp{
                ignore_bins normal_ops_with_rddata=  binsof (mosi_cp.rd_data) && binsof (ss_n_cp.normal_ops_trns);
                ignore_bins wr_addr_with_rddata_trs= binsof (mosi_cp.wr_addr) && binsof (ss_n_cp.rd_data_op_trns);
                ignore_bins wr_data_with_rddata_trs= binsof (mosi_cp.wr_data) && binsof (ss_n_cp.rd_data_op_trns);
                ignore_bins rd_addr_with_rddata_trs= binsof (mosi_cp.rd_addr) && binsof (ss_n_cp.rd_data_op_trns);
            }

        endgroup


        function new(string name = "wrapper_coverage_collector", uvm_component parent = null);
            super.new(name, parent);
             wrapper_cvg_gp=new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export", this);
            cov_wrapper = new("cov_wrapper", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_wrapper.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_wrapper.get(seq_item_cov);
                wrapper_cvg_gp.sample();
            end
        endtask
    endclass
endpackage