class start_high_vseq extends uvm_sequence;
    `uvm_object_utils(start_high_vseq)
    `uvm_declare_p_sequencer(tto_fpu_virtual_sequencer)

    reset_seq rst;
    assert_wr_en_seq wr;
    no_op_seq no_op;
    assert_start_pulse_seq st;
    assert_read_en_seq rd;

    function new(string name="start_high_vseq");
        super.new(name);
    endfunction

    task body();
        rst=reset_seq::type_id::create("rst");
        no_op=no_op_seq::type_id::create("no");
        wr=assert_wr_en_seq::type_id::create("wr");
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
                    wr.start(p_sequencer.act_sqr);
                    no_op.start(p_sequencer.act_sqr);
                    wr.start(p_sequ
