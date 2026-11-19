class reset_seq extends base_seq;
    `uvm_object_utils(reset_seq)
	
    function new(string name="reset_seq");
        super.new(name);
    endfunction

    task body();    
        tto_fpu_seq_item tr;
        tr=tto_fpu_seq_item::type_id::create("tr");
 	    start_item(tr);
        if(tr.randomize() with {rst_n==0;})
            `uvm_info(get_type_name(),$sformatf("RESET:%0b", tr.rst_n),UVM_MEDIUM)
        else
	        `uvm_fatal(get_type_name(),"Randomization failed")
 	    finish_item(tr);
    endtask
endclass
