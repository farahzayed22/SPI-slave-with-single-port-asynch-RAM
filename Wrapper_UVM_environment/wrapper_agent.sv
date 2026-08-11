package wrapper_agent_pkg;
    import wrapper_driver_pkg::*;
    import wrapper_monitor_pkg::*;
    import wrapper_sequencer_pkg::*;
    import wrapper_Config_pkg::*;
    import wrapper_seq_item_pkg::*;
    import uvm_pkg::*;
        `include "uvm_macros.svh"
    
    class wrapper_agent extends uvm_agent;
        `uvm_component_utils(wrapper_agent)

        wrapper_driver wrapper_agt_dv;
        wrapper_monitor wrapper_agt_mon;
        wrapper_sequencer wrapper_agt_sqr;
        wrapper_Config wrapper_agt_cnfg_ob;
        uvm_analysis_port #(wrapper_seq_item) wrapper_agt_ap;

        function new(string name="wrapper_agent",uvm_component parent=null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db#(wrapper_Config)::get(this,"","wrapper_CFG",wrapper_agt_cnfg_ob))
                `uvm_fatal("agent build_phase","unable to get configuration object")
            if(wrapper_agt_cnfg_ob.is_active_wrapper==UVM_ACTIVE) begin
            wrapper_agt_dv=wrapper_driver::type_id::create("wrapper_agt_dv",this);
            wrapper_agt_sqr=wrapper_sequencer::type_id::create("wrapper_agt_sqr",this);
            end
            wrapper_agt_mon=wrapper_monitor::type_id::create("wrapper_agt_mon",this);
            wrapper_agt_ap=new("wrapper_agt_ap",this);
            
            
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            
            if(wrapper_agt_cnfg_ob.is_active_wrapper==UVM_ACTIVE) begin
            wrapper_agt_dv.wrapper_driver_vif= wrapper_agt_cnfg_ob.wrapper_config_vif;
            wrapper_agt_dv.seq_item_port.connect(wrapper_agt_sqr.seq_item_export);
            end

            wrapper_agt_mon.wrapper_monitor_vif= wrapper_agt_cnfg_ob.wrapper_config_vif;
            wrapper_agt_mon.mon_ap.connect(wrapper_agt_ap);
        endfunction
    endclass

endpackage
