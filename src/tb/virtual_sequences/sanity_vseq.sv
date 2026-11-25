class sanity_vseq extends uvm_sequence;
    `uvm_object_utils(sanity_vseq)
    `uvm_declare_p_sequencer(tto_fpu_virtual_sequencer)

    reset_seq rst;
    assert_wr_en_seq wr;
    assert_start_pulse_seq st;
    no_op_seq no;
    assert_read_en_seq rd;

    function new(string name="sanity_vseq");
        super.new(name);
    endfunction

    task body();
        rst=reset_seq::type_id::create("rst");
        wr=assert_wr_en_seq::type_id::create("wr");
        st=assert_start_pulse_seq::type_id::create("st");
        no=no_op_seq::type_id::create("no");
        rd=assert_read_en_seq::type_id::create("rd");
        fork
            begin
                repeat(`rst_times) begin
                    rst.start(p_sequencer.rst_sqr);
                end
            end
            begin
                repeat(`n) begin
                    repeat(4) begin
                        wr.start(p_sequencer.act_sqr);
                        no.start(p_sequencer.act_sqr);
                    end
                    st.start(p_sequencer.act_sqr);
                    repeat(4) no.start(p_sequencer.act_sqr);
                    repeat(2) begin
                        rd.start(p_sequencer.act_sqr);
                        no.start(p_sequencer.act_sqr);
                    end
                    repeat(2) no.start(p_sequencer.act_sqr);
                end
            end
        join
    endtask

endclass
