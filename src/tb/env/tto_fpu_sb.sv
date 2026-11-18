class tto_fpu_sb extends uvm_scoreboard;
	
    `uvm_component_utils(tto_fpu_sb)

    uvm_tlm_analysis_fifo #(tto_fpu_seq_item) in_fifo;
    uvm_tlm_analysis_fifo #(tto_fpu_seq_item) out_fifo;

    int TOTAL,MISMATCH,MATCH;
    int count;
    bit [(1+`EXP_W+`MAN_W)-1:0] opa, opb, result;
    real a, b, inter;
    bit prev_wr_en, prev_rd_en, prev_start, prev_op;
    bit [($clog2((1+`EXP_W+`MAN_W)/8))-1:0] rd_pt;

    function new(string name="tto_fpu_sb", uvm_component parent);
        super.new(name,parent);
        in_fifo=new("in_fifo",this);
        out_fifo=new("out_fifo",this);
    endfunction
    
    task run_phase(uvm_phase phase);
    	tto_fpu_seq_item inp_mon_xn,inp_mon_hold;
		tto_fpu_seq_item out_mon_xn;
        tto_fpu_seq_item exp=tto_fpu_seq_item::type_id::create("exp");
		forever begin
			in_fifo.get(inp_mon_xn);
			out_fifo.get(out_mon_xn);
			if (inp_mon_hold==null) begin
				inp_mon_hold=inp_mon_xn;
			end else begin
				predictor(inp_mon_hold, exp);
				validate_outputs(out_mon_xn, exp);
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

	task predictor(tto_fpu_seq_item inp, tto_fpu_seq_item tr);
		if(!inp.rst_n) begin
            tr.uio_oe=0;
            tr.uio_out=0;
            tr.uo_out=0;
            prev_wr_en=0;
            prev_rd_en=0;
            prev_start=0;
            prev_op=0;
            rd_pt=0;
            count=0;
            opa=0;
            opb=0;
            result=0;
            a=0; 
            b=0;
            inter=0;
        end else begin
            tr.uio_oe=0;
            if (!tr.uo_out[0]) begin
                if ((inp.ui_in[2])&&(tr.uo_out[3])&&(!prev_start)) begin
                    check_latency();
                    tr.uo_out[2:0]=3'b001;
                    prev_op=inp.ui_in[3];
                    tr.uio_oe=8'h00;
                end else if ((inp.ui_in[0])&&(!prev_wr_en)) begin
                    tr.uio_oe=8'h00;
                    if (tr.uo_out[7:4]<((1+`EXP_W+`MAN_W)/8)) begin
                        opa[((tr.uo_out[7:4])%((1+`EXP_W+`MAN_W)/8))*8+:8]=inp.uio_in;
                    end else begin
                         opb[((tr.uo_out[7:4])%((1+`EXP_W+`MAN_W)/8))*8+:8]=inp.uio_in;
                    end
                    if (tr.uo_out[7:4]<(((2*(1+`EXP_W+`MAN_W)/8))-1)) begin
                        tr.uo_out[7:4]=tr.uo_out[7:4]+1;
                        tr.uo_out[3]=1'b0;
                    end else begin
                        tr.uo_out[7:4]=4'h0;
                        tr.uo_out[3]=1'b1;
                    end
                end else if(inp.ui_in[1]) begin
                    tr.uio_oe=8'hFF;
                    tr.uio_out=result[rd_pt*8+:8];
                end else if (!inp.ui_in[1]) begin
                    tr.uio_oe=8'h00;
                    tr.uio_out=0;
                end
                if ((!inp.ui_in[1])&&(prev_rd_en)) begin
                    rd_pt++;
                end 
            end else begin
                tr.uio_oe=8'h00;
                if (count!=0) begin
                     count--;
                end else begin
                    perform_operation(tr);
                end
            end
            prev_wr_en=inp.ui_in[0];
            prev_rd_en=inp.ui_in[1];
            prev_start=inp.ui_in[2];
        end
    endtask

    task check_latency();
        if ((opa[(`EXP_W+`MAN_W)-1:`MAN_W]=={`EXP_W{1'b1}})||(opb[(`EXP_W+`MAN_W)-1:`MAN_W]=={`EXP_W{1'b1}})||(opa[(`EXP_W+`MAN_W)-1:`MAN_W]=={`EXP_W{1'b0}})||(opb[(`EXP_W+`MAN_W)-1:`MAN_W]=={`EXP_W{1'b0}})) begin
            count=1;
        end else begin
            count=2;
        end
    endtask

	task perform_operation(tto_fpu_seq_item txn);
        if (opa[(`EXP_W+`MAN_W)-1:`MAN_W]=={`EXP_W{1'b1}}) begin
            txn.uo_out[2:0]=3'b110;
            result=0;
        end else if (opb[(`EXP_W+`MAN_W)-1:`MAN_W]=={`EXP_W{1'b1}}) begin
            txn.uo_out[2:0]=3'b110;
            result=0;
        end else if (opa[(`EXP_W+`MAN_W)-1:`MAN_W]=={`EXP_W{1'b0}}) begin
            if (opa[`MAN_W-1:0]=={`EXP_W{1'b0}}) begin
                txn.uo_out[2:0]=3'b010;
                result=opb;
            end else begin
                txn.uo_out[2:0]=3'b110;
                result=0;
            end
        end else if (opa[(`EXP_W+`MAN_W)-1:`MAN_W]=={`EXP_W{1'b0}}) begin
            if (opb[`MAN_W-1:0]=={`EXP_W{1'b0}}) begin
                txn.uo_out[2:0]=3'b010;
                result=opa;
            end else begin
                txn.uo_out[2:0]=3'b110;
                result=0;
            end
        end else begin
            txn.uo_out[2:0]=3'b010;
            a=convertfp16toreal(opa);
            b=convertfp16toreal(opb);
            if (prev_op) begin
                inter=a-b;
            end else begin
                inter=a+b;
            end
            result=convertrealtofp16(inter);
            if (result[(`EXP_W+`MAN_W)-1:`MAN_W]=={`EXP_W{1'b1}}) begin
				result={result[(1+`EXP_W+`MAN_W)-1], {`EXP_W{1'b1}}, {`MAN_W{1'b0}}};
            end else if (result[(`EXP_W+`MAN_W)-1:`MAN_W]=={`EXP_W{1'b0}}) begin
				result={result[(1+`EXP_W+`MAN_W)-1],{`EXP_W{1'b0}},{`MAN_W{1'b0}}};
            end 
        end
    endtask

    function bit [(1+`EXP_W+`MAN_W)-1:0] convertrealtofp16(real num);
        bit [63:0] fp64;
        int bias;
        fp64 = $realtobits(num);
        if (num == 0.0) return '0;                                    
        bias = (int'(fp64[62:52]) - 1023) + ((1 << (`EXP_W-1)) - 1);  
        if (bias > (1 << `EXP_W) - 2)                                
            return {fp64[63], {`EXP_W{1'b1}}, {`MAN_W{1'b0}}};
        if (bias <= 0)                                            
            return {fp64[63], {(`EXP_W+`MAN_W){1'b0}}};
        return {fp64[63], (`EXP_W)'(bias), fp64[51 -: `MAN_W]};     
    endfunction
    
    function real convertfp16toreal(bit [(1+`EXP_W+`MAN_W)-1:0] fp16);
        int bias = (1 << (`EXP_W-1)) - 1;
        int exp_val = fp16[`EXP_W+`MAN_W-1:`MAN_W] - bias;
        real mant_val = 1.0 + (real'(fp16[`MAN_W-1:0]) / (2.0**`MAN_W));
        real final_val = mant_val * (2.0**exp_val);
        if (fp16[`EXP_W+`MAN_W]) begin
            return -final_val;
        end else begin
            return final_val;
        end
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SCOREBOARD",$sformatf("\nTotal Test cases ran:%0d\n Total testcases passed:%0d\n Total testcases failed:%0d\n",TOTAL,MATCH,MISMATCH),UVM_NONE);
    endfunction
endclass
