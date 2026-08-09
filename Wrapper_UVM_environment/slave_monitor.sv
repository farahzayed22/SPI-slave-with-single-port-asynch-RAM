package slave_monitor_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import slave_seq_item_pkg::*;
  class slave_monitor extends uvm_monitor ;
  `uvm_component_utils(slave_monitor)

  virtual slave_Interface slave_monitor_vif;
  slave_seq_item mn_seq_item;

  uvm_analysis_port #(slave_seq_item) mon_ap;
  function new(string name="slave_driver",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_ap=new("mon_ap",this);
    mn_seq_item=slave_seq_item::type_id::create("mn_seq_item");
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
      forever begin   
          @(negedge slave_monitor_vif.clk) ;
          mn_seq_item.mosi=slave_monitor_vif.mosi;
          mn_seq_item.ss_n=slave_monitor_vif.ss_n;
          mn_seq_item.rstn=slave_monitor_vif.rstn;
          mn_seq_item.tx_data=slave_monitor_vif.tx_data;
          mn_seq_item.tx_valid=slave_monitor_vif.tx_valid;
          mn_seq_item.rx_data=slave_monitor_vif.rx_data;
          mn_seq_item.rx_valid=slave_monitor_vif.rx_valid;
          mn_seq_item.miso=slave_monitor_vif.miso;
          mn_seq_item.rx_data_ref=slave_monitor_vif.rx_data_ref;
          mn_seq_item.rx_valid_ref=slave_monitor_vif.rx_valid_ref;
          mn_seq_item.miso_ref=slave_monitor_vif.miso_ref;
          mon_ap.write(mn_seq_item);
          `uvm_info("monitor run_phase",mn_seq_item.convert2string_stimulus(),UVM_HIGH) 
      end
  endtask
  endclass
endpackage
