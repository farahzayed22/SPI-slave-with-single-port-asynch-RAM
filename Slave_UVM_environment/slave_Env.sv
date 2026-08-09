package slave_Env_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import slave_agent_pkg::*;
    import slave_scoreboard_pkg::*;
    import slave_coverage_collector_pkg::*;

    class slave_Env extends uvm_env;
    `uvm_component_utils(slave_Env)
      slave_agent agent;
      slave_scoreboard sb;
      slave_coverage_collector cov;

    function new(string name="slave_Env", uvm_component parent=null);
      super.new(name,parent);
    endfunction
      
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agent =slave_agent::type_id::create("agent",this);
      sb=slave_scoreboard::type_id::create("sb",this);
      cov=slave_coverage_collector::type_id::create("cov",this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      agent.agt_ap.connect(sb.sb_export);
      agent.agt_ap.connect(cov.cov_export);
    endfunction
    endclass
endpackage 