class shift_out_vseq extends uvm_sequence;
    `uvm_object_utils(shift_out_vseq)
    `uvm_declare_p_sequencer(tto_fpu_virtual_sequencer)

    reset_seq rst;
    assert_wr_en_seq wr;
    mantissa_alignment_load_1_seq so1;
    load_shift_1_seq so2;
    load_shift_2_seq so3;
    no_op_seq no_op;
    assert_read_en_seq rd;
    assert_start_pulse_seq st;
    opcode_0_seq add;

    function new(string name="shift_out_vseq");
        super.new(name);
    endfunction

    task body();
        rst=reset_seq::type_id::create("rst");
        no_op=no_op_seq::type_id::create("no");
        st=assert_start_pulse_seq::type_id::create("st");
        wr=assert_wr_en_seq::type_id::create("wr");
        rd=assert_read_en_seq::type_id::create("rd");
        so1=mantissa_alignment_load_1_seq::type_id::create("so1");
        so2=load_shift_1_seq::type_id::create("so2");
        so3=load_shift_2_seq::type_id::create("so3");
        add=opcode_0_seq::type_id::create("add");

        fork
            begin
                repeat(`rst_times) begin
                    rst.start(p_sequencer.rst_sqr);
                end
            end
            begin
                repeat(`n) begin
                    wr.start(p_sequencer.act_sqr);
                    so1.start(p_sequencer.act_sqr);
                    wr.start(p_sequencer.act_sqr);
                    so2.start(p_sequencer.act_sqr);
                    wr.start(p_sequencer.act_sqr);
                    so1.start(p_sequencer.act_sqr);
                    wr.start(p_sequencer.act_sqr);
                    so3.start(p_sequencer.act_sqr);
                    st.start(p_sequencer.act_sqr);
                    add.start(p_sequencer.act_sqr);

                    repeat(4) no_op.start(p_sequencer.act_sqr);

                    rd
