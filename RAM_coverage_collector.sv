package RAM_coverage_collector_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import RAM_seq_item_pkg::*;

    class RAM_coverage_collector extends uvm_component;
        `uvm_component_utils(RAM_coverage_collector)

        uvm_analysis_export #(RAM_seq_item) cov_export;
        uvm_tlm_analysis_RAM #(RAM_seq_item) cov_RAM;
        RAM_seq_item seq_item_cov;

        covergroup RAM_cvg_gp;

               
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
            super.connect_phase(phase); // Fixed: was super.build_phase
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