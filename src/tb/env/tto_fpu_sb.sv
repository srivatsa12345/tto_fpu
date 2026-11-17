class tto_fpu_sb extends uvm_scoreboard;
	
    `uvm_component_utils(tto_fpu_sb)

    uvm_tlm_analysis_fifo #(tto_fpu_seq_item) in_fifo;
    uvm_tlm_analysis_fifo #(tto_fpu_seq_item) out_fifo;

    int TOTAL,MISMATCH,MATCH;

    function new(string name="tto_fpu_sb", uvm_component parent);
        super.new(name,parent);
        in_fifo=new("in_fifo",this);
        out_fifo=new("out_fifo",this);
    endfunction
    
    task run_phase(uvm_phase phase);
    
    endtask

    task validate_outputs(qspi_seq_item apb, qspi_seq_item flash);
    
    endtask

    task ref_task(qspi_seq_item apb, qspi_seq_item flash);
   
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SCOREBOARD",$sformatf("\nTotal Test cases ran:%0d\n Total testcases passed:%0d\n Total testcases failed:%0d\n",TOTAL,MATCH,MISMATCH),UVM_NONE);
    endfunction
endclass
