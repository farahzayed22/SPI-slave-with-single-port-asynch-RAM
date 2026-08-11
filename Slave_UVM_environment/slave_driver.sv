package slave_driver_pkg;
  import slave_seq_item_pkg::*;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  class slave_driver extends uvm_driver #(slave_seq_item);
  `uvm_component_utils(slave_driver)

  virtual slave_Interface slave_driver_vif;
  slave_seq_item dv_seq_item;

  function new(string name="slave_driver",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    dv_seq_item=slave_seq_item::type_id::create("dv_seq_item");
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
          slave_driver_vif.mosi=0;
          slave_driver_vif.ss_n=1;
          slave_driver_vif.rstn=0;
          slave_driver_vif.tx_data=0;
          slave_driver_vif.tx_valid=0;
      forever begin
        @(negedge slave_driver_vif.clk) ;
          seq_item_port.get_next_item(dv_seq_item);    
          slave_driver_vif.mosi=dv_seq_item.mosi;
          slave_driver_vif.ss_n=dv_seq_item.ss_n;
          slave_driver_vif.rstn=dv_seq_item.rstn;
          slave_driver_vif.tx_data=dv_seq_item.tx_data;
          slave_driver_vif.tx_valid=dv_seq_item.tx_valid;
          seq_item_port.item_done();
          `uvm_info("driver run_phase",dv_seq_item.convert2string_stimulus(),UVM_HIGH) 
      end
  endtask
  endclass
endpackage
