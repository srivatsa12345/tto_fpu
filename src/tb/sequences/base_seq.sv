class base_seq extends uvm_sequence#(tto_fpu_seq_item);
    `uvm_object_utils(base_seq)
	
    function new(string name="base_seq");
        super.new(name);
    endfunction

    task body();	
		tto_fpu_seq_item tr;
        tr=tto_fpu_seq_item::type_id::create("tr");
 	    start_item(tr);
        if(tr.randomize())
            `uvm_info(get_type_name(),$sformatf("RESET:%0b, ui_in:%0h, uio_in:%0h, uio_oe:%0h, uio_out:%0h, uo_out:%0h", tr.rst_n, tr.ui_in, tr.uio_in, tr.uio_oe, tr.uio_out, tr.uo_out),UVM_MEDIUM)
        else
	        `uvm_fatal(get_type_name(),"Randomization failed")
 	    finish_item(tr);
    endtask
endclass

