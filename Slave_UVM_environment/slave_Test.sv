package slave_Test_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import slave_Env_pkg::*;
    import slave_Config_pkg::*;
    import slave_reset_seq_pkg::*;
    import slave_main_seq_pkg::*;


    class slave_Test extends uvm_test;
        `uvm_component_utils(slave_Test)

        slave_Env env;
        slave_Config cfg;
        virtual slave_if slave_vif;
        slave_main_seq main_seq;
        slave_reset_seq reset_seq;

        function new(string name="slave_Test", uvm_component parent=null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env=slave_Env::type_id::create("env",this);
            cfg=slave_Config::type_id::create("cfg",this);
            main_seq=slave_main_seq::type_id::create("main_seq");
            reset_seq=slave_reset_seq::type_id::create("reset_seq");

            if(!uvm_config_db#(virtual slave_Interface)::get(this,"","slaveif",cfg.slave_config_vif)) begin
                `uvm_fatal("build_phase","unable to get the virtual interface");
            end

            uvm_config_db#(slave_Config)::set(this,"*","CFG",cfg);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("slave_Test","Reset asserted",UVM_LOW);
            reset_seq.start(env.agent.agt_sqr); 
            `uvm_info("run_phase","Stimulus generation started: main phase", UVM_LOW);
            main_seq.start(env.agent.agt_sqr);
            `uvm_info("run_phase","Stimulus generation ended", UVM_LOW);
            phase.drop_objection(this);
        endtask
    endclass
endpackage