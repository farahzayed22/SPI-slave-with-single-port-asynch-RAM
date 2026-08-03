package RAM_Config_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

class RAM_Config extends uvm_object;
    `uvm_object_utils(RAM_Config)

    virtual RAM_Interface RAM_config_vif;
    function new(string name="RAM_Config");
        super.new(name);
    endfunction
endclass
endpackage