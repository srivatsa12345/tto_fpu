class mantissa_alignment_vseq extends uvm_sequence;
    `uvm_object_utils(mantissa_alignment_vseq)
    `uvm_declare_p_sequencer(tto_fpu_virtual_sequencer)

    reset_seq rst;
    assert_wr_en_seq wr;
    mantissa_alignment_load_1_seq ma1;
    mantissa_alignment_load_2_seq ma2;
    mantissa_alignment_load_1_seq ma3;
    mantissa_alignment_load_4_seq ma4;
    no_op_seq no_op;
    assert_read_en_seq rd;
    assert_start_pulse_seq st;

    function new(string name="mantissa_alignment_vseq");
        super.new(name);
    endfunction

    task body();
        rst=reset_seq::type_id::create("rst");
        no_op=no_op_seq::type_id::create("no");
        st=assert_start_pulse_seq::type_id::create("st");
        wr=assert_wr_en_seq::type_id::create("wr");
        rd=assert_read_en_seq::type_id::create("rd");
        ma1=mantissa_alignment_load_1_seq::type_id::create("ma1");
        ma2=mantissa_alignment_load_2_seq::type_id::create("ma2");
        ma3=mantissa_alignment_load_1_seq::type_id::create("ma3");
        ma4=mantissa_alignment_load_4_seq::type_id::create("ma4");

        fork
            begin
                repeat(`rst_times) begin
                    rst.start(p_sequencer.rst_sqr);
                end
            end
            begin
                repeat(`n) begin
                    wr.start(p_sequencer.act_sqr);
                    ma1.start(p_sequencer.act_sqr);
                    wr.start(p_sequencer.act_sqr);
                    ma2.start(p_sequencer.act_sqr);
                    wr.start(p_sequencer.act_sqr);
                    ma3.start(p_sequencer.act_sqr);
                    wr.start(p_sequencer.act_sqr);
                    ma4.start(p_sequencer.act_sqr);
                    st.start(p_sequencer.act_sqr);

                    repeat(4) no_op.start(p_sequencer.act_sqr);

                    rd.start(p_sequencer.act_sqr);
                    no_op.start(p_sequencer.act_sqr);
                    rd.start(p_sequencer.act_sqr);
                    no_op.start(p_sequencer.act_sqr);
                end
            end
        join
    endtask

endclass
