package RAM_driver_pkg;
  import RAM_seq_item_pkg::*;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  class RAM_driver extends uvm_driver #(RAM_seq_item);
  `uvm_component_utils(RAM_driver)

  virtual RAM_Interface RAM_driver_vif;
  RAM_seq_item dv_seq_item;

  function new(string name="RAM_driver",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    dv_seq_item=RAM_seq_item::type_id::create("dv_seq_item");
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
          RAM_driver_vif.din=0;
          RAM_driver_vif.rstn=0;
          RAM_driver_vif.rx_valid=0;
      forever begin
        @(negedge RAM_driver_vif.clk) ;
          seq_item_port.get_next_item(dv_seq_item);    
          RAM_driver_vif.din=dv_seq_item.din;
          RAM_driver_vif.rstn=dv_seq_item.rstn;
          RAM_driver_vif.rx_valid=dv_seq_item.rx_valid;
          seq_item_port.item_done();
          `uvm_info("driver run_phase",dv_seq_item.convert2string_stimulus(),UVM_HIGH) 
      end
  endtask
  endclass
endpackage
