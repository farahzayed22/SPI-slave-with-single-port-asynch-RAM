package wrapper_Test_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import wrapper_Env_pkg::*;
    import RAM_Env_pkg::*;
    import slave_Env_pkg::*;
    import wrapper_Config_pkg::*;
    import RAM_Config_pkg::*;
    import slave_Config_pkg::*;
    import wrapper_write_only_seq_pkg::*;
    import wrapper_read_write_seq_pkg::*;
    import wrapper_read_only_seq_pkg::*;
    import wrapper_reset_seq_pkg::*;

    class wrapper_Test extends uvm_test;
        `uvm_component_utils(wrapper_Test)

        wrapper_Env wrapper_env;
        RAM_Env ram_env;
        slave_Env slave_env;
        
        wrapper_Config wrapper_cfg;
        RAM_Config ram_cfg;
        slave_Config slave_cfg;

        virtual wrapper_Interface wrapper_vif;
        virtual RAM_Interface ram_vif;
        virtual slave_Interface slave_vif;

        wrapper_write_only_seq write_seq;
        wrapper_read_only_seq read_seq;
        wrapper_read_write_seq read_write_seq;
        wrapper_reset_seq reset_seq;

        function new(string name="wrapper_Test", uvm_component parent=null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            wrapper_env=wrapper_Env::type_id::create("wrapper_env",this);
            ram_env=RAM_Env::type_id::create("ram_env",this);
            slave_env=slave_Env::type_id::create("slave_env",this);

            wrapper_cfg=wrapper_Config::type_id::create("wrapper_cfg",this);
            ram_cfg=RAM_Config::type_id::create("ram_cfg",this);
            slave_cfg=slave_Config::type_id::create("slave_cfg",this);
            
            wrapper_cfg.is_active_wrapper = UVM_ACTIVE;

            write_seq=wrapper_write_only_seq::type_id::create("write_seq");
            read_seq=wrapper_read_only_seq::type_id::create("read_seq");
            read_write_seq=wrapper_read_write_seq::type_id::create("read_write_seq");
            reset_seq=wrapper_reset_seq::type_id::create("reset_seq");

            if(!uvm_config_db#(virtual wrapper_Interface)::get(this,"","wrapperif",wrapper_cfg.wrapper_config_vif)) begin
                `uvm_fatal("build_phase","unable to get the virtual interface");
            end
            uvm_config_db#(wrapper_Config)::set(this,"*","wrapper_CFG",wrapper_cfg);

            if(!uvm_config_db#(virtual slave_Interface)::get(this,"","slaveif",slave_cfg.slave_config_vif)) begin
                `uvm_fatal("build_phase","unable to get the virtual interface");
            end
            uvm_config_db#(slave_Config)::set(this,"*","slave_CFG",slave_cfg);

            if(!uvm_config_db#(virtual RAM_Interface)::get(this,"","RAMif",ram_cfg.RAM_config_vif)) begin
                `uvm_fatal("build_phase","unable to get the virtual interface");
            end
            uvm_config_db#(RAM_Config)::set(this,"*","ram_CFG",ram_cfg);

        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            #100;
            `uvm_info("wrapper_Test","Reset asserted",UVM_LOW);
            reset_seq.start(wrapper_env.agent.wrapper_agt_sqr); 
            `uvm_info("run_phase","Stimulus generation started: write phase", UVM_LOW);
            write_seq.start(wrapper_env.agent.wrapper_agt_sqr);
            `uvm_info("run_phase","Stimulus generation started: read phase", UVM_LOW);
            read_seq.start(wrapper_env.agent.wrapper_agt_sqr);
            `uvm_info("run_phase","Stimulus generation started: read/write phase", UVM_LOW);
            read_write_seq.start(wrapper_env.agent.wrapper_agt_sqr);
            `uvm_info("run_phase","Stimulus generation ended", UVM_LOW);
            phase.drop_objection(this);
        endtask
    endclass
endpackage