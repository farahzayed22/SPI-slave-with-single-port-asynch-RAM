package slave_coverage_collector_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import slave_seq_item_pkg::*;

    class slave_coverage_collector extends uvm_component;
        `uvm_component_utils(slave_coverage_collector)

        uvm_analysis_export #(slave_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(slave_seq_item) cov_slave;
        slave_seq_item seq_item_cov;

        covergroup slave_cvg_gp;
            rx_data_cp: coverpoint seq_item_cov.rx_data[9:8]{
                bins WR_ADDR={2'b00};
                bins WR_DATA={2'b01};
                bins RD_ADDR={2'b10};
                bins RD_DATA={2'b11};
                bins trans_00_01 = (2'b00 => 2'b01);//write addreess to write data
                bins trans_10_11 = (2'b10 => 2'b11); //read address to read data
                bins trans_11_00 = (2'b10 => 2'b11); //read data to write address
            }

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
            crs_cove_ssn_rxdata: cross rx_data_cp, ss_n_cp{
                bins rd_data_ssn_trns= binsof (rx_data_cp.RD_DATA)  && binsof (ss_n_cp.rd_data_op_trns);
                bins normal_ops_ssn_trns=  binsof (rx_data_cp) intersect {2'b00 , 2'b01, 2'b10 } && binsof (ss_n_cp.normal_ops_trns);
                ignore_bins ig_trans_00_01= binsof(rx_data_cp.trans_00_01);
                ignore_bins ig_trans_10_11= binsof(rx_data_cp.trans_10_11);
                ignore_bins ig_trans_11_00= binsof(rx_data_cp.trans_11_00);
            }
            
            crs_cove_ssn_mosi: cross mosi_cp , ss_n_cp{
                ignore_bins normal_ops_with_rddata=  binsof (mosi_cp.rd_data) && binsof (ss_n_cp.normal_ops_trns);
                ignore_bins wr_addr_with_rddata_trs= binsof (mosi_cp.wr_addr) && binsof (ss_n_cp.rd_data_op_trns);
                ignore_bins wr_data_with_rddata_trs= binsof (mosi_cp.wr_data) && binsof (ss_n_cp.rd_data_op_trns);
                ignore_bins rd_addr_with_rddata_trs= binsof (mosi_cp.rd_addr) && binsof (ss_n_cp.rd_data_op_trns);
            }

        endgroup


        function new(string name = "slave_coverage_collector", uvm_component parent = null);
            super.new(name, parent);
             slave_cvg_gp=new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export", this);
            cov_slave = new("cov_slave", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_slave.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_slave.get(seq_item_cov);
                slave_cvg_gp.sample();
            end
        endtask
    endclass
endpackage
