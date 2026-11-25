class read_in_between_vseq extends uvm_sequence;
    `uvm_object_utils(read_in_between_vseq)
    `uvm_declare_p_sequencer(tto_fpu_virtual_sequencer)

    reset_seq rst;
    assert_wr_en_seq wr_1;
    no_op_seq no_op;
    assert_start_pulse_seq st;
    assert_read_en_seq rd;

    function new(string name="read_in_between_vseq");
        super.new(name);
    endfunction

    task body();
        rst=reset_seq::type_id::create("rst");
        no_op=no_op_seq::type_id::create("no");
        wr_1=assert_wr_en_seq::type_id::create("wr_1");
        st=assert_start_pulse_seq::type_id::create("st");
        rd=assert_read_en_seq::type_id::create("rd");

        fork
            begin
                repeat(`rst_times) begin
                    rst.start(p_sequencer.rst_sqr);
                end
            end
            begin
                repeat(`n) begin
                    wr_1.start(p_sequencer.act_sqr);
                    no_op.start(p_sequencer.act_sqr);
                    wr_1.start(p_sequencer.act_sqr);
                    no_op.start(p_sequencer.act_sqr);
                    wr_1.start(p_sequencer.act_sqr);
                    rd.start(p_sequencer.act_sqr);
                    no_op.start(p_sequencer.act_sqr);
                    rd.start(p_sequencer.act_sqr);
                    no_op.start(p_sequencer.act_sqr);
                    wr_1.start(p_sequencer.act_sqr);
                    no_op.start(p_sequencer.act_sqr);
                    wr_1.start(p_sequencer.act_sqr);
                    no_op.start(p_sequencer.act_sqr);

                    st.start(p_sequencer.act_sqr);

                    repeat(4) no_op.start(p_sequencer.act_sqr);

                    wr_1.start(p_sequencer.act_sqr);
                    rd.start(p_sequencer.act_sqr);
                    no_op.start(p_sequencer.act_sqr);
                    rd.start(p_sequencer.act_sqr);
                    no_op.start(p_sequencer.act_sqr);
                end
            end
        join
    endtask

endclass
