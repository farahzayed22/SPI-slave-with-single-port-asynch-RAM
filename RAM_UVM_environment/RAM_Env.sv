package RAM_Env_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import RAM_agent_pkg::*;
    import RAM_scoreboard_pkg::*;
    import RAM_coverage_collector_pkg::*;

    class RAM_Env extends uvm_env;
    `uvm_component_utils(RAM_Env)
      RAM_agent agent;
      RAM_scoreboard sb;
      RAM_coverage_collector cov;

    function new(string name="RAM_Env", uvm_component parent=null);
      super.new(name,parent);
    endfunction
      
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agent =RAM_agent::type_id::create("agent",this);
      sb=RAM_scoreboard::type_id::create("sb",this);
      cov=RAM_coverage_collector::type_id::create("cov",this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      agent.agt_ap.connect(sb.sb_export);
      agent.agt_ap.connect(cov.cov_export);
    endfunction
    endclass
endpackage 

