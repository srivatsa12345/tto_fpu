class read_write_in_between_vseq extends uvm_sequence;
    `uvm_object_utils(read_write_in_between_vseq)
    `uvm_declare_p_sequencer(tto_fpu_virtual_sequencer)

    reset_seq rst;
    assert_wr_en_seq wr_1;
    write_read_simul_seq wr_rd;
    write_one_byte_seq wr;
    no_op_seq no_op;
    assert_start_pulse_seq st;
    assert_read_en_seq rd;

    function new(string name="read_write_in_between_vseq");
        super.new(name);
    endfunction

    task body();
        rst=reset_seq::type_id::create("rst");
        no_op=no_op_seq::type_id::create("no");
        wr=write_one_byte_seq::type_id::create("wr");
        wr_1=assert_wr_en_seq::type_id::create("wr_1");
        wr_rd=write_read_simul_seq::type_id::create("wr_rd");
        st=assert_start_pulse_seq::type_id::create("st");
        rd=assert_read_en_seq::type_id::create
