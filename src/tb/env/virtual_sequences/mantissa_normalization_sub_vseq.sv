class mantissa_normalization_sub_vseq extends uvm_sequence;
    `uvm_object_utils(mantissa_normalization_sub_vseq)
    `uvm_declare_p_sequencer(tto_fpu_virtual_sequencer)

    reset_seq rst;
    mantissa_alignment_load_1_seq mn1;
    mantissa_alignment_load_2_seq mn2;
    opcode_1_seq sub;
    no_op_seq no_op;
    assert_read_en_seq rd;
    assert_start_pulse_seq st;
    assert_wr_en_seq wr;

    function new(string name="mantissa_normalization_sub_vseq");
        super.new(name);
    endfunction

    task body();
        rst=reset_seq::type_id::create("rst");
        no_op=no_op_seq::type_id::create("no");
        st=assert_start_pulse_seq::type_id::create("st");
        rd=assert_read_en_seq::type_id::create("rd");
        mn1=mantissa_alignment_load_1_seq::type_id::create("mn1");
        mn2=mantissa_alignment_load_2_seq::type_id::create("mn2");
        sub=opcode_1_seq::type_id::create("sub");
        wr=assert_wr_en_seq::type_id::create("wr");
        fork
            begin
                repeat(`rst_times) begin
                    rst.start(p_sequencer.rst_sqr);
                end
            end
            begin
                repeat(`n) begin
                    wr.start(p_sequencer.act_sqr);
                    mn1.start(p_sequencer.act_sqr);
                    wr.start(p_sequencer.act_sqr);
                    mn2.start(p_sequencer.act_sqr);
                    wr.start(p_sequencer.act_sqr);
                    mn1.start(p_sequencer.act_sqr);
                    wr.start(p_sequencer.act_sqr);
                    mn2.start(p_sequencer.act_sqr);
                    st.start(p_sequencer.act_sqr);
                    sub.start(p_sequencer.act_sqr);
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
