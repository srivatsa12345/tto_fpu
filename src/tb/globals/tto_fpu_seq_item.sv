class tto_fpu_seq_item extends uvm_sequence_item;
  
    `uvm_object_utils(tto_fpu_seq_item)
  
    function new(string name="tto_fpu_seq_item");
        super.new(name);
    endfunction
  
    logic [7:0] ui_in, uio_in;
    logic [7:0] uio_oe, uio_out, uo_out;
  
endclass
