package RAM_monitor_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import RAM_seq_item_pkg::*;
  class RAM_monitor extends uvm_monitor ;
  `uvm_component_utils(RAM_monitor)

  virtual RAM_Interface RAM_monitor_vif;
  RAM_seq_item mn_seq_item;

  uvm_analysis_port #(RAM_seq_item) mon_ap;
  function new(string name="RAM_driver",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_ap=new("mon_ap",this);
    mn_seq_item=RAM_seq_item::type_id::create("mn_seq_item");
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
      forever begin   
          @(negedge RAM_monitor_vif.clk) ;
          mn_seq_item.din=RAM_monitor_vif.din;
          mn_seq_item.rx_valid=RAM_monitor_vif.rx_valid;
          mn_seq_item.tx_valid=RAM_monitor_vif.tx_valid;
          mn_seq_item.rstn=RAM_monitor_vif.rstn;
          mn_seq_item.dout=RAM_monitor_vif.dout;
          mon_ap.write(mn_seq_item);
          `uvm_info("monitor run_phase",mn_seq_item.convert2string_stimulus(),UVM_HIGH) 
      end
  endtask
  endclass
endpackage
