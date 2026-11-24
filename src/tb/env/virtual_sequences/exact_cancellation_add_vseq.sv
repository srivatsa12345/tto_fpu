class exact_cancellation_add_vseq extends uvm_sequence;
    `uvm_object_utils(exact_cancellation_add_vseq)
    `uvm_declare_p_sequencer(tto_fpu_virtual_sequencer)

    reset_seq rst;
    load_0_seq ec1;
    load_5_seq ec2;
    load_2_neg_5_seq ec3;
    opcode_0_seq add;
    no_op_seq no_op;
    assert_read_en_seq rd;
    assert_start_pulse_seq st;
    assert_wr_en_seq wr;

    function new(string name="exact_cancellation_add_vseq");
        super.new(name);
    endfunction

    task body();
        rst=reset_seq::type_id::create("rst");
        no_op=no_op_seq::type_id::create("no");
        st=assert_start_pulse_seq::type_id::create("st");
        rd=assert_read_en_seq::type_id::create("rd");
        ec1=load_0_seq::type_id::create("ec1");
        ec2=load_5_seq::type_id::create("ec2");
        ec3=load_2_neg_5_seq::type_id::create("ec3");
        add=opcode_0_seq::type_id::create("add");
        wr
