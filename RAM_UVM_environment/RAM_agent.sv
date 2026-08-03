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

        RAM_driver agt_dv;
        RAM_monitor agt_mon;
        RAM_sequencer agt_sqr;
        RAM_Config agt_cnfg_ob;
        uvm_analysis_port #(RAM_seq_item) agt_ap;

        function new(string name="RAM_agent",uvm_component parent=null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agt_dv=RAM_driver::type_id::create("agt_dv",this);
            agt_mon=RAM_monitor::type_id::create("agt_mon",this);
            agt_sqr=RAM_sequencer::type_id::create("agt_sqr",this);
            agt_ap=new("agt_ap",this);

            if(!uvm_config_db#(RAM_Config)::get(this,"","CFG",agt_cnfg_ob))
                `uvm_fatal("agent build_phase","unable to get configuration object")
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agt_dv.RAM_driver_vif= agt_cnfg_ob.RAM_config_vif;
            agt_mon.RAM_monitor_vif= agt_cnfg_ob.RAM_config_vif;
            agt_dv.seq_item_port.connect(agt_sqr.seq_item_export);
            agt_mon.mon_ap.connect(agt_ap);
        endfunction
    endclass

endpackage