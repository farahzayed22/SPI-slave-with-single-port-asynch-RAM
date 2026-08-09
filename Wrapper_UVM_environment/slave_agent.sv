package slave_agent_pkg;
    import slave_driver_pkg::*;
    import slave_monitor_pkg::*;
    import slave_sequencer_pkg::*;
    import slave_Config_pkg::*;
    import slave_seq_item_pkg::*;
    import uvm_pkg::*;
        `include "uvm_macros.svh"
    
    class slave_agent extends uvm_agent;
        `uvm_component_utils(slave_agent)

        slave_driver slave_agt_dv;
        slave_monitor slave_agt_mon;
        slave_sequencer slave_agt_sqr;
        slave_Config slave_agt_cnfg_ob;
        uvm_analysis_port #(slave_seq_item) slave_agt_ap;

        function new(string name="slave_agent",uvm_component parent=null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db#(slave_Config)::get(this,"","slave_CFG",slave_agt_cnfg_ob))
                `uvm_fatal("agent build_phase","unable to get configuration object")
            if(slave_agt_cnfg_ob.is_active_slave==UVM_ACTIVE) begin
            slave_agt_dv=slave_driver::type_id::create("slave_agt_dv",this);
            slave_agt_sqr=slave_sequencer::type_id::create("slave_agt_sqr",this);
            end
            slave_agt_mon=slave_monitor::type_id::create("slave_agt_mon",this);
            slave_agt_ap=new("slave_agt_ap",this);
            
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            
            if(slave_agt_cnfg_ob.is_active_slave==UVM_ACTIVE) begin
            slave_agt_dv.slave_driver_vif= slave_agt_cnfg_ob.slave_config_vif;
            slave_agt_dv.seq_item_port.connect(slave_agt_sqr.seq_item_export);
            end

            slave_agt_mon.slave_monitor_vif= slave_agt_cnfg_ob.slave_config_vif;
            slave_agt_mon.mon_ap.connect(slave_agt_ap);
        endfunction
    endclass

endpackage