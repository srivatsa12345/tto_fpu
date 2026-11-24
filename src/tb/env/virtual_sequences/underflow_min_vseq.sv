class underflow_min_vseq extends uvm_sequence;
    `uvm_object_utils(underflow_min_vseq)
    `uvm_declare_p_sequencer(tto_fpu_virtual_sequencer)

    reset_seq rst;
    assert_wr_en_seq wr;
    mantissa_alignment_load_1_seq mi1;
    load_1_min_seq mi2;
    no_op_seq no_op;
    assert_read_en_seq rd;
    assert_start_pulse_seq st;
    opcode_1_seq sub;

    function new(string name="underflow_min_vseq");
        super.new(name);
    endfunction

    task body();
        rst=reset_seq::type_id::create("rst");
        no_op=no_op_seq::type_id::create("no");
        st=assert_start_pulse_seq::type_id::create("st");
        wr=assert_wr_en_seq::type_id::create("wr");
        rd=assert_read_en_seq::type_id::create("rd");
        mi1=mantissa_alignment_load_1_seq::type_id::create("mi1");
        mi2=load_1_min_seq::type_id::create("mi2");
        sub=opcode_1_seq::type_id::create("sub");

        fork
            begin
                repeat(`rst_times) begin
                    rst.start(p_sequencer.rst_sqr);
                end
            end
            begin
                repeat(`n) begin
                    wr.start(p_sequencer.act_sqr);
                    mi1.start(p_sequencer.act_sqr);
                    wr.start(p_sequencer.act_sqr);
                    mi2.start(p_sequencer.act_sqr);
                    wr.start(p_sequencer.act_sqr);
                    mi1.start(p_sequencer.act_sqr);
                    wr.start(p_sequencer.act_sqr);
                    mi2.start(p_sequencer.act_sqr);
                    st.start(p_sequencer.act_sqr);
                    sub.start(p_sequencer.act_sqr);

                    repeat(4) no_op.start(p_sequencer.act_sqr);

                    rd.start(p_sequencer.act_sqr);
                    no_op.start(p_sequencer.act_sqr);
                    rd.start(p_sequencer.act_sqr);
                    no_op.start(p_sequ
