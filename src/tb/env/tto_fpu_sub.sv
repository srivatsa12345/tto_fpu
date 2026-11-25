class tto_fpu_sub extends uvm_subscriber #(tto_fpu_seq_item);
    `uvm_component_utils(tto_fpu_sub)
    uvm_analysis_imp #(tto_fpu_seq_item,tto_fpu_sub) input_imp;
    uvm_analysis_imp_out #(tto_fpu_seq_item,tto_fpu_sub) output_imp;
    tto_fpu_seq_item drv;
    tto_fpu_seq_item mon;
    covergroup input_cg;
  
        write_en: coverpoint drv.ui_in[0] {
            bins write_0={0};
            bins write_1={1};
        }
        read_en: coverpoint drv.ui_in[1] {
            bins read_0={0};
            bins read_1={1};
        }
        start: coverpoint drv.ui_in[2] {
            bins start_0={0};
            bins start_1={1};
        }
        opcode: coverpoint drv.ui_in[3] {
            bins add={0};
            bins subtract={1};
        }
        uio_in_byte: coverpoint drv.uio_in {
            bins zero={8'h00};
            bins non_zero={[8'h01:8'hFF]};
        }
        unused_pins: coverpoint drv.ui_in[7:4] {
            bins val={[0:15]};
        }
        wr_rd: cross write_en, read_en;
        st_wr: cross start, write_en;
        st_rd: cross start, read_en;
        st_wr_rd: cross start, write_en, read_en;
    endgroup
    covergroup output_cg;
        busy: coverpoint mon.uo_out[0]{
            bins busy_0={0};
            bins busy_1={1};
        }
        done: coverpoint mon.uo_out[1]{
            bins done_0={0};
            bins done_1={1};
        }
        error: coverpoint mon.uo_out[2]{
            bins error_0={0};
            bins error_1={1};
        }
        ready: coverpoint mon.uo_out[3]{
            bins ready_0={0};
            bins ready_1={1};
        }
        wr_ptr: coverpoint mon.uo_out[7:4]{
            bins val_ptr[]={[0:((2*(`FP/8))-1)]};
            illegal_bins val_ptr_other_val={[((2*(`FP/8))):15]};
        }
        uio_oe: coverpoint mon.uio_oe{
            bins input_enable={8'h00};
            bins output_enable={8'hFF};
        }
        done_err: cross done, error {
            bins done_err_00 = binsof(done) intersect {0} && binsof(error) intersect {0};  
            bins done_err_10 = binsof(done) intersect {1} && binsof(error) intersect {0};  
            bins done_err_11 = binsof(done) intersect {1} && binsof(error) intersect {1};  
            illegal_bins done_err_01 = binsof(done) intersect {0} && binsof(error) intersect {1};
        }
        done_ready: cross done, ready {
            bins done_ready_00 = binsof(done) intersect {0} && binsof(ready) intersect {0};  
            bins done_ready_10 = binsof(done) intersect {1} && binsof(ready) intersect {0};  
            bins done_ready_11 = binsof(done) intersect {1} && binsof(ready) intersect {1};  
            bins done_ready_01 = binsof(done) intersect {0} && binsof(ready) intersect {1};
        }
        done_busy: cross done, busy {
            bins done_busy_00 = binsof(done) intersect {0} && binsof(busy) intersect {0};  
            bins done_busy_10 = binsof(done) intersect {1} && binsof(busy) intersect {0};  
            bins done_busy_01 = binsof(done) intersect {0} && binsof(busy) intersect {1};
            illegal_bins done_busy_11 = binsof(done) intersect {1} && binsof(busy) intersect {1};  
        }
    endgroup
    function new(string name="tto_fpu_sub",uvm_component parent=null);
        super.new(name,parent);
        input_imp=new("input_imp",this);
        output_imp=new("output_imp",this);
        input_cg=new();
        output_cg=new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction
  
    virtual function void write(tto_fpu_seq_item t);
        if(!$cast(drv,t))
            `uvm_fatal(get_type_name(), "Casting failed from input monitor");
        input_cg.sample();
    endfunction
    
    virtual function void write_out(tto_fpu_seq_item t);
        if(!$cast(mon,t))
            `uvm_fatal(get_type_name(), "Casting failed from output monitor");
        output_cg.sample();
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
    	`uvm_info(get_name,$sformatf("INPUT COVERAGE = %0f\n",input_cg.get_coverage()),UVM_NONE);
    	`uvm_info(get_name,$sformatf("OUTPUT COVERAGE = %0f\n",output_cg.get_coverage()),UVM_NONE);
  	endfunction
endclass

  
  
