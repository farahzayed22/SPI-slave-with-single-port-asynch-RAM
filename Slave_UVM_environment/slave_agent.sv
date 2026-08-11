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

        slave_driver agt_dv;
        slave_monitor agt_mon;
        slave_sequencer agt_sqr;
        slave_Config agt_cnfg_ob;
        uvm_analysis_port #(slave_seq_item) agt_ap;

        function new(string name="slave_agent",uvm_component parent=null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agt_dv=slave_driver::type_id::create("agt_dv",this);
            agt_mon=slave_monitor::type_id::create("agt_mon",this);
            agt_sqr=slave_sequencer::type_id::create("agt_sqr",this);
            agt_ap=new("agt_ap",this);

            if(!uvm_config_db#(slave_Config)::get(this,"","CFG",agt_cnfg_ob))
                `uvm_fatal("agent build_phase","unable to get configuration object")
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agt_dv.slave_driver_vif= agt_cnfg_ob.slave_config_vif;
            agt_mon.slave_monitor_vif= agt_cnfg_ob.slave_config_vif;
            agt_dv.seq_item_port.connect(agt_sqr.seq_item_export);
            agt_mon.mon_ap.connect(agt_ap);
        endfunction
    endclass

endpackage
