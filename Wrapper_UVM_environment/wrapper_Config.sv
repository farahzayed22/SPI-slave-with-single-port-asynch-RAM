package wrapper_Config_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

class wrapper_Config extends uvm_object;
    `uvm_object_utils(wrapper_Config)

    virtual wrapper_Interface wrapper_config_vif;
    uvm_active_passive_enum is_active_wrapper;

    function new(string name="wrapper_Config");
        super.new(name);
    endfunction
endclass
endpackage