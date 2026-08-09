package slave_Config_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

class slave_Config extends uvm_object;
    `uvm_object_utils(slave_Config)

    virtual slave_Interface slave_config_vif;
    uvm_active_passive_enum is_active_slave;
    
    function new(string name="slave_Config");
        super.new(name);
    endfunction
endclass
endpackage