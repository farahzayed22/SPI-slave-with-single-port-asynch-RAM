package RAM_Test_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import RAM_Env_pkg::*;
    import RAM_Config_pkg::*;
    import RAM_write_only_seq_pkg::*;
    import RAM_read_write_seq_pkg::*;
    import RAM_read_only_seq_pkg::*;
    import RAM_reset_seq_pkg::*;
    class RAM_Test extends uvm_test;
        `uvm_componenet_utils(RAM_Test)

        RAM_Env env;
        RAM_Config cfg;
        //virtual RAM_if RAM_vif;
        RAM_write_only_seq write_seq;
        RAM_read_only_seq read_seq;
        RAM_read_write_seq read_write_seq;
        RAM_reset_seq reset_seq;

        function new(string name="RAM_Test", uvm_component parent=null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env=RAM_Env::type_id::create("env",this);
            cfg=RAM_Config::type_id::create("cfg",this);
            write_seq=RAM_write_only_seq::type_id::create("write_seq");
            read_seq=RAM_read_only_seq::type_id::create("read_seq");
            read_write_seq=RAM_read_write_seq::type_id::create("read_write_seq");
            reset_seq=RAM_reset_seq::type_id::create("reset_seq");

            if(!uvm_config_db#(virtual RAM_Interface)::get(this,"","RAMif",cfg.RAM_config_vif)) begin
                `uvm_fatal("build_phase","unable to get the virtual interface");
            end

            uvm_config_db#(RAM_Config)::set(this,"*","CFG",cfg);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("RAM_Test","Reset asserted",UVM_LOW);
            reset_seq.start(env.agent.agt_sqr); 
            `uvm_info("run_phase","Stimulus generation started: write phase", UVM_LOW);
            write_seq.start(env.agent.agt_sqr);
            `uvm_info("run_phase","Stimulus generation started: read phase", UVM_LOW);
            read_seq.start(env.agent.agt_sqr);
            `uvm_info("run_phase","Stimulus generation started: read/write phase", UVM_LOW);
            read_write_seq.start(env.agent.agt_sqr);
            `uvm_info("run_phase","Stimulus generation ended", UVM_LOW);
            phase.drop_objection(this);
        endtask
    endclass
endpackage