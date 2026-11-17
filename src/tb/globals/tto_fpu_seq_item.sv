class tto_fpu_seq_item extends uvm_sequence_item;

    rand logic rst_n;
    rand logic [7:0] ui_in, uio_in;
    logic [7:0] uio_oe, uio_out, uo_out;
    
    function new(string name="tto_fpu_seq_item");
        super.new(name);
    endfunction

    `uvm_object_utils_begin(tto_fpu_seq_item)
		`uvm_field_int(rst_n, UVM_ALL_ON | UVM_NOCOMPARE)
		`uvm_field_int(ui_in, UVM_ALL_ON | UVM_NOCOMPARE)
		`uvm_field_int(uio_in, UVM_ALL_ON | UVM_NOCOMPARE)
		`uvm_field_int(uio_oe, UVM_ALL_ON)
		`uvm_field_int(uio_out, UVM_ALL_ON)
		`uvm_field_int(uo_out, UVM_ALL_ON)
	`uvm_object_utils_end
    
endclass
