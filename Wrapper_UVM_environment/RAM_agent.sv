package RAM_agent_pkg;
    import RAM_driver_pkg::*;
    import RAM_monitor_pkg::*;
    import RAM_sequencer_pkg::*;
    import RAM_Config_pkg::*;
    import RAM_seq_item_pkg::*;
    import uvm_pkg::*;
        `include "uvm_macros.svh"
    
    class RAM_agent extends uvm_agent;
        `uvm_component_utils(RAM_agent)

        RAM_driver RAM_agt_dv;
        RAM_monitor RAM_agt_mon;
        RAM_sequencer RAM_agt_sqr;
        RAM_Config RAM_agt_cnfg_ob;
        uvm_analysis_port #(RAM_seq_item) RAM_agt_ap;

        function new(string name="RAM_agent",uvm_component parent=null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
             if(!uvm_config_db#(RAM_Config)::get(this,"","ram_CFG",RAM_agt_cnfg_ob))
                `uvm_fatal("agent build_phase","unable to get configuration object")
            if(RAM_agt_cnfg_ob.is_active_ram==UVM_ACTIVE) begin
            RAM_agt_dv=RAM_driver::type_id::create("RAM_agt_dv",this);
            RAM_agt_sqr=RAM_sequencer::type_id::create("RAM_agt_sqr",this);
            end
            RAM_agt_mon=RAM_monitor::type_id::create("RAM_agt_mon",this);
            RAM_agt_ap=new("RAM_agt_ap",this);
           
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            
            if(RAM_agt_cnfg_ob.is_active_ram==UVM_ACTIVE) begin
            RAM_agt_dv.RAM_driver_vif= RAM_agt_cnfg_ob.RAM_config_vif;
            RAM_agt_dv.seq_item_port.connect(RAM_agt_sqr.seq_item_export);
            end

            RAM_agt_mon.RAM_monitor_vif= RAM_agt_cnfg_ob.RAM_config_vif;
            RAM_agt_mon.mon_ap.connect(RAM_agt_ap);
        endfunction
    endclass

endpackage