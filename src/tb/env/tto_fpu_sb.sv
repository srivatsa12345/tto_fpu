class tto_fpu_sb extends uvm_scoreboard;
	
    `uvm_component_utils(tto_fpu_sb)

    uvm_analysis_imp #(tto_fpu_seq_item, tto_fpu_sb) in_mon;
	uvm_analysis_imp_out #(tto_fpu_seq_item, tto_fpu_sb) out_mon;

    tto_fpu_seq_item in_q[$],out_q[$];

    int TOTAL,MISMATCH,MATCH;
    int count;
    bit [(1+`EXP_W+`MAN_W)-1:0] opa, opb, result;
    bit prev_wr_en, prev_prev_wr_en, prev_rd_en, prev_prev_rd_en, prev_prev_start, prev_start, prev_op, next_wr;
    bit [($clog2((1+`EXP_W+`MAN_W)/8))-1:0] rd_pt;

    function new(string name="tto_fpu_sb", uvm_component parent);
        super.new(name,parent);
        in_mon=new("in_mon",this);
        out_mon=new("out_mon",this);
    endfunction
    
    virtual function void write(tto_fpu_seq_item tx);
		in_q.push_back(tx);
	endfunction

    virtual function void write_out(tto_fpu_seq_item tx);
		out_q.push_back(tx);
	endfunction

    task run_phase(uvm_phase phase);
    	tto_fpu_seq_item inp_mon_xn;
		tto_fpu_seq_item out_mon_xn;
        tto_fpu_seq_item exp=tto_fpu_seq_item::type_id::create("exp");
		forever begin
            wait((in_q.size()!=0)&&(out_q.size()!=0)) begin
                if (inp_mon_xn==null) begin
					inp_mon_xn=in_q.pop_front();
					void'(out_q.pop_front());
                end else begin
					out_mon_xn=out_q.pop_front();
                    predictor(inp_mon_xn, exp);
                    inp_mon_xn=in_q.pop_front();
                    if (!inp_mon_xn.rst_n) begin
                        reset_values(exp);
                    end
                    validate_outputs(out_mon_xn, exp);
                end				
			end
		end
    endtask

	task validate_outputs(tto_fpu_seq_item inp, tto_fpu_seq_item out);
    	++TOTAL;
		if((out.uio_oe==8'hFF)&&(out.uio_oe==inp.uio_oe)) begin
            if(inp.compare(out)) begin
	    		++MATCH;
		    	`uvm_info("SCOREBOARD",$sformatf("\nDUT: uio_oe:%0h, uio_out:%0h, uo_out:%0h\nREF: uio_oe:%0h, uio_out:%0h, uo_out:%0h\n", inp.uio_oe, inp.uio_out, inp.uo_out, out.uio_oe, out.uio_out, out.uo_out),UVM_MEDIUM)
		    end else begin
			    ++MISMATCH;
			    `uvm_info("SCOREBOARD",$sformatf("\nDUT: uio_oe:%0h, uio_out:%0h, uo_out:%0h\nREF: uio_oe:%0h, uio_out:%0h, uo_out:%0h\n_______________________________________________________________________________________________________________________________________",inp.uio_oe, inp.uio_out, inp.uo_out, out.uio_oe, out.uio_out, out.uo_out),UVM_NONE)
            end
        end else begin
            if((inp.uio_oe==out.uio_oe)&&(inp.uo_out==out.uo_out)) begin
	    		++MATCH;
		    	`uvm_info("SCOREBOARD",$sformatf("\nDUT: uio_oe:%0h, uio_out:%0h, uo_out:%0h\nREF: uio_oe:%0h, uio_out:%0h, uo_out:%0h\n", inp.uio_oe, inp.uio_out, inp.uo_out, out.uio_oe, out.uio_out, out.uo_out),UVM_MEDIUM)
		    end else begin
			    ++MISMATCH;
			    `uvm_info("SCOREBOARD",$sformatf("\nDUT: uio_oe:%0h, uio_out:%0h, uo_out:%0h\nREF: uio_oe:%0h, uio_out:%0h, uo_out:%0h\n_______________________________________________________________________________________________________________________________________",inp.uio_oe, inp.uio_out, inp.uo_out, out.uio_oe, out.uio_out, out.uo_out),UVM_NONE)
            end
        end
    endtask

	task predictor(tto_fpu_seq_item inp, tto_fpu_seq_item tr);
		if(!inp.rst_n) begin
            reset_values(tr);
        end else begin
            tr.uio_oe=0;
			if ((!tr.uo_out[0])&&(!prev_prev_start)&&(prev_start)&&(tr.uo_out[3])) begin
				tr.uo_out[2:0]=3'b001;
				tr.uio_oe=8'h00;
				rd_pt=0;
				prev_op=inp.ui_in[3];
			end
            if (!tr.uo_out[0]) begin
                if ((prev_prev_rd_en)&&(!prev_rd_en)) begin
                    rd_pt++;
                end 
				if (next_wr) begin
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
				end
                if ((inp.ui_in[2])&&(tr.uo_out[3])&&(!prev_start)) begin
					check_latency();
                    tr.uio_oe=8'h00;
					if ((!next_wr)&&(!prev_wr_en)&&(!inp.ui_in[0])&&(inp.ui_in[1])) begin
                    	tr.uio_oe=8'hFF;
                    	tr.uio_out=result[rd_pt*8+:8];
					end
				end else if ((!next_wr)&&(!prev_prev_wr_en)&&(prev_wr_en)) begin
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
				end else if ((!next_wr)&&(!prev_wr_en)&&(!inp.ui_in[0])&&(inp.ui_in[1])) begin
                    tr.uio_oe=8'hFF;
                    tr.uio_out=result[rd_pt*8+:8];
				end else if ((!next_wr)&&(!inp.ui_in[1])) begin
                    tr.uio_oe=8'h00;
                end
				next_wr=0;
            end else begin
                tr.uio_oe=8'h00;
                if (count!=0) begin
                     count--;
                end else begin
					perform_operation(tr);
					if ((inp.ui_in[2])&&(tr.uo_out[3])&&(!prev_start)) begin
						check_latency();
                    	tr.uio_oe=8'h00;
					end else if ((!prev_wr_en)&&(inp.ui_in[0])) begin
                    	next_wr=1;
					end else if (inp.ui_in[1]) begin
                	    tr.uio_oe=8'hFF;
                	    tr.uio_out=result[rd_pt*8+:8];
					end else if (!inp.ui_in[1]) begin
                	    tr.uio_oe=8'h00;
                	end
                end
            end
			prev_prev_wr_en=prev_wr_en;
			prev_prev_rd_en=prev_rd_en;
			prev_prev_start=prev_start;
            prev_wr_en=inp.ui_in[0];
            prev_rd_en=inp.ui_in[1];
            prev_start=inp.ui_in[2];
        end
    endtask

    task reset_values(tto_fpu_seq_item txn);
        txn.uio_oe=0;
        txn.uio_out=0;
        txn.uo_out=0;
        prev_wr_en=0;
		prev_prev_wr_en=0;
		next_wr=0;
        prev_rd_en=0;
		prev_prev_rd_en=0;
        prev_start=0;
		prev_prev_start=0;
        prev_op=0;
        rd_pt=0;
        count=0;
        opa=0;
        opb=0;
        result=0;
    endtask

    task check_latency();
        if ((opa[(`EXP_W+`MAN_W)-1:`MAN_W]=={`EXP_W{1'b1}})||(opb[(`EXP_W+`MAN_W)-1:`MAN_W]=={`EXP_W{1'b1}})||(opa[(`EXP_W+`MAN_W)-1:`MAN_W]=={`EXP_W{1'b0}})||(opb[(`EXP_W+`MAN_W)-1:`MAN_W]=={`EXP_W{1'b0}})) begin
            count=2;
        end else begin
            count=3;
        end
    endtask

	task perform_operation(tto_fpu_seq_item txn);
        bit opa_sign=opa[(`EXP_W+`MAN_W)];
        bit opb_sign=opb[(`EXP_W+`MAN_W)];
        bit [`MAN_W:0] man_opa={1'b1, opa[(`MAN_W-1):0]};
        bit [`MAN_W:0] man_opb={1'b1, opb[(`MAN_W-1):0]};
        bit [`MAN_W:0] man_l, man_s;
        bit [`EXP_W-1:0] exp_opa=opa[(`EXP_W+`MAN_W)-1:`MAN_W];
        bit [`EXP_W-1:0] exp_opb=opb[(`EXP_W+`MAN_W)-1:`MAN_W];
        bit eff_op;
        int exp_diff;
        bit res_sign;
        bit signed [`EXP_W:0] res_exp;
        bit [`MAN_W+1:0] res_man;
        if ((exp_opa=={`EXP_W{1'b1}})||(exp_opb=={`EXP_W{1'b1}})||((exp_opa==0)&&(opa[`MAN_W-1:0]!=0))||((exp_opb==0)&&(opb[`MAN_W-1:0]!=0))) begin
            txn.uo_out[2:0]=3'b110;
            result=0;
        end else if (exp_opb == 0) begin
            txn.uo_out[2:0]=3'b010;
            result=opa;
        end else if (exp_opa==0) begin
            txn.uo_out[2:0]=3'b010;
            result=(prev_op)?{~opb_sign,opb[`EXP_W+`MAN_W-1:0]}:opb;
        end else begin
            txn.uo_out[2:0]=3'b010;
            if (prev_op) begin
                opb_sign=~opb_sign;
            end
            if (opa_sign==opb_sign) begin
                eff_op=0;
            end else begin
                eff_op=1;
            end
            if(opa[(`EXP_W+`MAN_W)-1:0]>opb[(`EXP_W+`MAN_W)-1:0]) begin
                res_sign=opa_sign;
                exp_diff=exp_opa-exp_opb;
                man_opb=(man_opb)>>exp_diff;
                res_exp=exp_opa;
            end else begin
                res_sign=opb_sign;
                exp_diff=exp_opb-exp_opa;
                man_opa=(man_opa)>>exp_diff;
                res_exp=exp_opb;
            end
            if (man_opa<man_opb) begin
                man_s=man_opa;
                man_l=man_opb;
            end else begin
                man_s=man_opb;
                man_l=man_opa;
            end
            if (eff_op) begin
                res_man=man_l-man_s;
            end else begin
                res_man=man_l+man_s;
            end
            if (res_man[`MAN_W+1]) begin
                res_exp=res_exp+1;
                res_man=res_man>>1;
            end else begin
                if (res_man!=0) begin
                    while (res_man[`MAN_W]==0) begin
                        res_man=res_man<<1;
                        res_exp=res_exp-1;
                    end
                end 
            end
            if (res_exp>((1<<(`EXP_W))-2)) begin
                result={res_sign, {`EXP_W{1'b1}}, {`MAN_W{1'b0}}};
            end else if (res_man==0) begin
                result={1'b0, {`EXP_W{1'b0}}, {`MAN_W{1'b0}}};
            end else if (res_exp<1) begin
                result={res_sign, {`EXP_W{1'b0}}, {`MAN_W{1'b0}}};
            end else begin
                result={res_sign, res_exp[`EXP_W-1:0], res_man[`MAN_W-1:0]};
            end
        end
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SCOREBOARD",$sformatf("\nTotal Test cases ran:%0d\nTotal testcases passed:%0d\nTotal testcases failed:%0d\n",TOTAL,MATCH,MISMATCH),UVM_NONE);
    endfunction
endclass
