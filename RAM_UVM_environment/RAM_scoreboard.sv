package RAM_scoreboard_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import RAM_seq_item_pkg::*;

    class RAM_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(RAM_scoreboard)
       
        uvm_analysis_export #(RAM_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(RAM_seq_item) sb_RAM;
        RAM_seq_item seq_item_sb;
        
        localparam MEM_DEPTH=256;
        localparam ADDR_SIZE=8;

        logic [ADDR_SIZE-1:0] wr_addr, rd_addr;
        logic [7:0]           mem [0:MEM_DEPTH-1];

        logic [7:0] dout_ref;
        logic tx_valid_ref;
        int error_count, correct_count;
        
        function new (string name = "RAM_scoreboard", uvm_component parent = null);
            super.new(name, parent);
            dout_ref=0;
            tx_valid_ref=0;
            error_count=0;
            correct_count=0;
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export", this);
            sb_RAM = new("sb_RAM", this);
        endfunction
        
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_RAM.analysis_export);
        endfunction
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_RAM.get(seq_item_sb);
                check_data(seq_item_sb);
            end
        endtask

        function void reference_model(RAM_seq_item item);
                if(~ item.rstn)begin
                    dout_ref=0;
                    tx_valid_ref=0;
                    wr_addr=0;
                    rd_addr=0;
                end
                else begin
                    if(item.rx_valid)begin
                        case(item.din[9:8])
                        2'b00:begin 
                            wr_addr=item.din[7:0];
                            tx_valid_ref=0;
                        end
                        2'b01:begin
                            mem[wr_addr]=item.din[7:0];
                            tx_valid_ref=0;
                        end
                        2'b10:begin 
                            rd_addr=item.din[7:0]; 
                            tx_valid_ref=0;
                        end
                        2'b11: begin 
                            dout_ref=(mem[rd_addr]=== 8'hxx)? 8'h0 : mem[rd_addr];
                            tx_valid_ref=1'b1;
                        end
                        default:begin
                            dout_ref=0; tx_valid_ref=0;
                        end
                        endcase
                    end
                    else begin tx_valid_ref=0;  end
                end
        endfunction

        
        function void check_data(RAM_seq_item item);
           reference_model(item);
            if(item.dout !== dout_ref && item.tx_valid === tx_valid_ref) begin
                `uvm_error("check_data", $sformatf("Data mismatch: dout_ref %0h, dout actual %0h , tx_valid_ref %0h, tx_valid actual %0h", 
                dout_ref, item.dout, tx_valid_ref, item.tx_valid))
                error_count++;
            end
            else begin
                correct_count++;
            end
        endfunction
        
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("total_success %0d", correct_count), UVM_LOW);
            `uvm_info("report_phase", $sformatf("total_fail %0d", error_count), UVM_LOW);
        endfunction
    endclass
endpackage

