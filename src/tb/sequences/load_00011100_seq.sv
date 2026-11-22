class load_00011100_seq extends base_seq;
    `uvm_object_utils(load_00011100_seq)

    function new(string name="load_00011100_seq");
        super.new(name);
    endfunction

    task body();
                tto_fpu_seq_item tr;
        tr=tto_fpu_seq_item::type_id::create("tr");
                start_item(tr);
        if(tr.randomize() with {uio_in==8'b00011100;ui_in[2:0]==3'b000;}) begin
                `uvm_info(get_type_name(),$sformatf("ui_in:%0h, uio_in:%0h, uio_oe:%0h, uio_out:%0h, uo_out:%0h", tr.ui_in, tr.uio_in, tr.uio_oe, tr.uio_out, tr.uo_out),UVM_MEDIUM)
                end else begin
                `uvm_fatal(get_type_name(),"Randomization failed")
                end
            finish_item(tr);
    endtask
endclass
