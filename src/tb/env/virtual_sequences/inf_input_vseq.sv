class inf_input_vseq extends uvm_sequence;
    `uvm_object_utils(inf_input_vseq)
    `uvm_declare_p_sequencer(tto_fpu_virtual_sequencer)

    reset_seq rst;
    assert_wr_en_seq wr;
    load_0_seq inf1;
    load_2_inf_seq inf2;
    no_op_seq no_op;
    assert_read_en_seq rd;
    assert_start_pulse_seq st;
    opcode_0_seq add;

    function new(string name="inf_input_vseq");
        super.new(name);
    endfunction

    task body();
        rst=reset_seq::type_id::create("rst");
        no_op=no_op_seq::type_id::create("no");
        st=assert_start_pulse_seq::type_id::create("st");
        wr=assert_wr_en_seq::type_id::create("wr");
        rd=assert_read_en_seq::type_id::create("rd");
        inf1=load_0_seq::type_id::create("inf1");
        inf2=load_2_inf_seq::type_id::create("inf2");
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
                    inf1.start(p_sequencer.act_sqr);
                    wr
