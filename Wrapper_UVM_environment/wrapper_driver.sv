package wrapper_driver_pkg;
  import wrapper_seq_item_pkg::*;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  class wrapper_driver extends uvm_driver #(wrapper_seq_item);
  `uvm_component_utils(wrapper_driver)

  virtual wrapper_Interface wrapper_driver_vif;
  wrapper_seq_item dv_seq_item;
  function new(string name="wrapper_driver",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    dv_seq_item=wrapper_seq_item::type_id::create("dv_seq_item");
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
          wrapper_driver_vif.mosi=0;
          wrapper_driver_vif.ss_n=1;
          wrapper_driver_vif.rstn=0;
      forever begin
        @(negedge wrapper_driver_vif.clk) ;
          seq_item_port.get_next_item(dv_seq_item);    
          wrapper_driver_vif.mosi=dv_seq_item.mosi;
          wrapper_driver_vif.ss_n=dv_seq_item.ss_n;
          wrapper_driver_vif.rstn=dv_seq_item.rstn;
          seq_item_port.item_done();
          `uvm_info("driver run_phase",dv_seq_item.convert2string_stimulus(),UVM_HIGH) 
      end
  endtask
  endclass
endpackage

