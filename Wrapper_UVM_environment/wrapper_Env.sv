package wrapper_Env_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import wrapper_agent_pkg::*;
    import wrapper_scoreboard_pkg::*;
    import wrapper_coverage_collector_pkg::*;

    class wrapper_Env extends uvm_env;
    `uvm_component_utils(wrapper_Env)
      wrapper_agent agent;
      wrapper_scoreboard sb;
      wrapper_coverage_collector cov;

    function new(string name="wrapper_Env", uvm_component parent=null);
      super.new(name,parent);
    endfunction
      
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agent =wrapper_agent::type_id::create("agent",this);
      sb=wrapper_scoreboard::type_id::create("sb",this);
      cov=wrapper_coverage_collector::type_id::create("cov",this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      agent.wrapper_agt_ap.connect(sb.sb_export);
      agent.wrapper_agt_ap.connect(cov.cov_export);
    endfunction
    endclass
endpackage 

