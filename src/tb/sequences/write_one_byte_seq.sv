class write_one_byte_seq extends base_seq;
    `uvm_object_utils(write_one_byte_seq)
	
    function new(string name="write_one_byte_seq");
        super.new(name);
    endfunction

    task body();	
		tto_fpu_seq_item tr;
        tr=tto_fpu_seq_item::type_id::create("tr");
		for (int i=0;i<=1;i++) begin
			start_item(tr);
			if (i==0) begin
				if(tr.randomize() with {ui_in[2:0]==3'b001;}) begin
            		`uvm_info(get_type_name(),$sformatf("ui_in:%0h, uio_in:%0h, uio_oe:%0h, uio_out:%0h, uo_out:%0h", tr.ui_in, tr.uio_in, tr.uio_oe, tr.uio_out, tr.uo_out),UVM_MEDIUM)
				end else begin
	        		`uvm_fatal(get_type_name(),"Randomization failed")
				end
			end else begin
				tr.ui_in[0]=0;
				`uvm_info(get_type_name(),$sformatf("ui_in:%0h, uio_in:%0h, uio_oe:%0h, uio_out:%0h, uo_out:%0h", tr.ui_in, tr.uio_in, tr.uio_oe, tr.uio_out, tr.uo_out),UVM_MEDIUM)
			end
 	    	finish_item(tr);
		end
		
    endtask
endclass
