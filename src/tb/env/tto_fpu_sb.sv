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
    	my_transaction inp_mon_xn,inp_mon_hold;
		my_transaction out_mon_xn;
		forever begin
			fork 
				in_fifo.get(inp_mon_xn);
				out_fifo.get(out_mon_xn);
			join
			if (inp_mon_hold==null) begin
				inp_mon_hold=inp_mon_xn;
			end else begin
				ref_model(inp_mon_hold);
				validate_outputs(inp_mon_hold,out_mon_xn);
				inp_mon_hold=inp_mon_xn;
			end
		end
    endtask

	task validate_outputs(tto_fpu_seq_item inp, tto_fpu_seq_item out);
    	++TOTAL;
		if(inp.compare(out)) begin
			++MATCH;
			`uvm_info("SCOREBOARD",$sformatf("\nDUT: uio_oe:%0h, uio_out:%0h, uo_out:%0h\nREF: uio_oe:%0h, uio_out:%0h, uo_out:%0h\n", inp.uio_oe, inp.uio_out, inp.uo_out, out.uio_oe, out.uio_out, out.uo_out),UVM_MEDIUM)
		end else begin
			++MISMATCH;
			`uvm_info("SCOREBOARD",$sformatf("\nDUT: uio_oe:%0h, uio_out:%0h, uo_out:%0h\nREF: uio_oe:%0h, uio_out:%0h, uo_out:%0h\n_______________________________________________________________________________________________________________________________________",inp.uio_oe, inp.uio_out, inp.uo_out, out.uio_oe, out.uio_out, out.uo_out),UVM_NONE)
		end
    endtask

	task predictor(tto_fpu_seq_item inp);
		
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SCOREBOARD",$sformatf("\nTotal Test cases ran:%0d\n Total testcases passed:%0d\n Total testcases failed:%0d\n",TOTAL,MATCH,MISMATCH),UVM_NONE);
    endfunction
endclass
