class sub_zero_invalid_operand_vseq extends uvm_sequence;
    `uvm_object_utils(sub_zero_invalid_operand_vseq)
    `uvm_declare_p_sequencer(tto_fpu_virtual_sequencer)

    reset_seq rst;
    load_0_seq zo1;
    load_1_nan_seq zo2;
    load_2_inf_seq zo3;
    opcode_1_seq sub;
    no_op_seq no_op;
    assert_read_en_seq rd;
    assert_start_pulse_seq st;
    assert_wr_en_seq wr;

    function new(string name="sub_zero_invalid_operand_vseq");
        super.new(name);
    endfunction

    task body();
        rst=reset_seq::type_id::create("rst");
        no_op=no_op_seq::type_id::create("no");
        st=assert_start_pulse_seq::type_id::create("st");
        rd=assert_read_en_seq::type_id::create("rd");
        zo1=load_0_seq::type_id::create("zo1");
        zo2=load_1_nan_seq::type_id::create("zo2");
        zo3=load_2_inf_seq::type_id::create("zo3");
        sub=opcode_1_seq::type
