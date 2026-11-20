class opcode_0_seq extends base_seq;
    `uvm_object_utils(opcode_0_seq)
	
    function new(string name="opcode_0_seq");
        super.new(name);
    endfunction

    task body();	
		tto_fpu_seq_item tr;
        tr=tto_fpu_seq_item::type_id::create("tr");
		start_item(tr);
		if(tr.randomize() with {ui_in[3]==0;}) begin
         	`uvm_info(get_type_name(),$sformatf("ui_in:%0h, uio_in:%0h, uio_oe:%0h, uio_out:%0h, uo_out:%0h", tr.ui_in, tr.uio_in, tr.uio_oe, tr.uio_out, tr.uo_out),UVM_MEDIUM)
		end else begin
	      	`uvm_fatal(get_type_name(),"Randomization failed")
		end
 	    finish_item(tr);
		
    endtask
endclass
