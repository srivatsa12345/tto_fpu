class exact_cancellation_vseq extends uvm_sequence;
    `uvm_object_utils(exact_cancellation_vseq)
    `uvm_declare_p_sequencer(tto_fpu_virtual_sequencer)

    reset_seq rst;
    load_0_seq ec1;
    load_5_seq ec2;
    opcode_1_seq sub;
    no_op_seq no_op;
    assert_read_en_seq rd;
    assert_start_pulse_seq st;
    assert_wr_en_seq wr;

    function new(string name="exact_cancellation_vseq");
        super.new(name);
    endfunction

    task body();
        rst=reset_seq::type_id::create("rst");
        no_op=no_op_seq::type_id::create("no");
        st=assert_start_pulse_seq::type_id::create("st");
        rd=assert_read_en_seq::type_id::create("rd");
        ec1=load_0_seq::type_id::create("ec1");
        ec2=load_5_seq::type_id::create("ec2");
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
                    ec1.start(p_sequencer.act_sqr);
                    wr.start(p_sequencer.act_sqr);
                    ec2.start(p_sequencer.act_sqr);
                    wr.start(p_sequencer.act_sqr);
                    ec1.start(p_sequencer.act_sqr);
                    wr.start(p_sequencer.act_sqr);
                    ec2.start(p_sequencer.act_sqr);
                    st.start(p_sequencer.act_sqr);
                    sub.start(p_sequencer.act_sqr);
