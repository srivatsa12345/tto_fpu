class read_before_op_vseq extends uvm_sequence;
    `uvm_object_utils(read_before_op_vseq)
    `uvm_declare_p_sequencer(tto_fpu_virtual_sequencer)

    reset_seq rst;
    assert_read_en_seq rd;
    no_op_seq no_op;

    function new(string name="read_before_op_vseq");
        super.new(name);
    endfunction

    task body();
        rst=reset_seq::type_id::create("rst");
        no_op=no_op_seq::type_id::create("no");
        rd=assert_read_en_seq::type_id::create("rd");
        fork
            begin
                repeat(`rst_times) begin
                    rst.start(p_sequencer.rst_sqr);
                end
            end
            begin
                repeat(`n) begin
                    rd.start(p_sequencer.act_sqr);
                    no_op.start(p_sequencer.act_sqr);
                end
            end
        join
    endtask

endclass
