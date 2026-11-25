class flag_vseq extends uvm_sequence;
    `uvm_object_utils(flag_vseq)
    `uvm_declare_p_sequencer(tto_fpu_virtual_sequencer)

    reset_seq rst;
    assert_start_write_read_simul_seq swr;
    assert_start_read_simul_seq sr;
    assert_start_write_read_simul_seq rw;
    assert_wr_en_seq wr;
    assert_start_pulse_seq st;
    no_op_seq no;
    assert_read_en_seq rd;

    function new(string name="flag_vseq");
        super.new(name);
    endfunction

    task body();
        rst=reset_seq::type_id::create("rst");
        wr=assert_wr_en_seq::type_id::create("wr");
        st=assert_start_pulse_seq::type_id::create("st");
        no=no_op_seq::type_id::create("no");
        rd=assert_read_en_seq::type_id::create("rd");
        swr=assert_start_write_read_simul_seq::type_id::create("swr");
        rw=assert_start_write_read_simul_seq::type_id::create("rw");
        sr=assert_start_read_simul_seq::type_id::create("sr");
        fork
            begin
                repeat(`rst_times) begin
                    rst.start(p_sequencer.rst_sqr);
                end
            end
            begin
                repeat(`n) begin
                    repeat(5) swr.start(p_sequencer.act_sqr);
                    repeat(5) sr.start(p_sequencer.act_sqr);
                    repeat(3) begin
                        swr.start(p_sequencer.act_sqr);
                        sr.start(p_sequencer.act_sqr);
                    end
                    no.start(p_sequencer.act_sqr);
                    repeat(10) begin
                        swr.start(p_sequencer.act_sqr);
                    end
                    repeat(4) rw.start(p_sequencer.act_sqr);
                    repeat(5) swr.start(p_sequencer.act_sqr);
                    repeat(2) begin
                        rd.start(p_sequencer.act_sqr);
                        no.start(p_sequencer.act_sqr);
                    end
                    repeat(2) wr.start(p_sequencer.act_sqr);
                    repeat(2) begin
                        rd.start(p_sequencer.act_sqr);
                        no.start(p_sequencer.act_sqr);
                    end
                    wr.start(p_sequencer.act_sqr);
                    no.start(p_sequencer.act_sqr);
                    swr.start(p_sequencer.act_sqr);
                    no.start(p_sequencer.act_sqr);
                    swr.start(p_sequencer.act_sqr);
                    repeat(2) no.start(p_sequencer.act_sqr);
                end
            end
        join
    endtask

endclass
