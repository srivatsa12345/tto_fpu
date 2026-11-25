class sub_zero_operand_B_vseq extends uvm_sequence;
    `uvm_object_utils(sub_zero_operand_B_vseq)
    `uvm_declare_p_sequencer(tto_fpu_virtual_sequencer)

    reset_seq rst;
    load_0_seq zo1;
    mantissa_alignment_load_1_seq zo2;
    mantissa_alignment_load_2_seq zo3;
    opcode_1_seq sub;
    no_op_seq no_op;
    assert_read_en_seq rd;
    assert_start_pulse_seq st;
    assert_wr_en_seq wr;

    function new(string name="sub_zero_operand_B_vseq");
        super.new(name);
    endfunction

    task body();
        rst=reset_seq::type_id::create("rst");
        no_op=no_op_seq::type_id::create("no");
        st=assert_start_pulse_seq::type_id::create("st");
        rd=assert_read_en_seq::type_id::create("rd");
        zo1=load_0_seq::type_id::create("zo1");
        zo2=mantissa_alignment_load_1_seq::type_id::create("zo2");
        zo3=mantissa_alignment_load_2_seq::type_id::create("zo3");
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
                    zo2.start(p_sequencer.act_sqr);
                    wr.start(p_sequencer.act_sqr);
                    zo3.start(p_sequencer.act_sqr);
                    wr.start(p_sequencer.act_sqr);
                    zo1.start(p_sequencer.act_sqr);
                    wr.start(p_sequencer.act_sqr);
                    zo1.start(p_sequencer.act_sqr);
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
