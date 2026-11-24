class normal_subtraction_vseq extends uvm_sequence;
    `uvm_object_utils(normal_subtraction_vseq)
    `uvm_declare_p_sequencer(tto_fpu_virtual_sequencer)

    reset_seq rst;
    assert_wr_en_seq wr;
    no_op_seq no_op;
    opcode_1_seq sub;
    assert_start_pulse_seq st;
    assert_read_en_seq rd;

    function new(string name="normal_subtraction_vseq");
        super.new(name);
    endfunction

    task body();
        rst=reset_seq::type_id::create("rst");
        no_op=no_op_seq::type_id::create("no");
        wr=assert_wr_en_seq::type_id::create("wr");
        sub=opcode_1_seq::type_id::create("opcode_1_seq");
        st=assert_start_pulse_seq::type_id::create("st");
        rd=assert_read_en_seq
