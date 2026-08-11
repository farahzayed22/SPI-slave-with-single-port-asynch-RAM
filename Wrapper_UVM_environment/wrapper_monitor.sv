package wrapper_monitor_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import wrapper_seq_item_pkg::*;
  class wrapper_monitor extends uvm_monitor ;
  `uvm_component_utils(wrapper_monitor)

  virtual wrapper_Interface wrapper_monitor_vif;
  wrapper_seq_item mn_seq_item;

  uvm_analysis_port #(wrapper_seq_item) mon_ap;
  function new(string name="wrapper_driver",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_ap=new("mon_ap",this);
    mn_seq_item=wrapper_seq_item::type_id::create("mn_seq_item");
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
      forever begin   
          @(negedge wrapper_monitor_vif.clk) ;
          mn_seq_item.mosi=wrapper_monitor_vif.mosi;
          mn_seq_item.ss_n=wrapper_monitor_vif.ss_n;
          mn_seq_item.rstn=wrapper_monitor_vif.rstn;
          mn_seq_item.miso=wrapper_monitor_vif.miso;
          mn_seq_item.miso_ref=wrapper_monitor_vif.miso_ref;
          mon_ap.write(mn_seq_item);
          `uvm_info("monitor run_phase",mn_seq_item.convert2string_stimulus(),UVM_HIGH) 
      end
  endtask
  endclass
endpackage


