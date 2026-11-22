class nan_input_test extends uvm_test ;
    `uvm_component_utils(nan_input_test)
    
    tto_fpu_env env;
    tto_fpu_config cfg;

    reset_seq rst;
    assert_wr_en_seq wr;
    load_1_nan_seq inf1;
    load_2_inf_seq inf2;
    no_op_seq no_op;  
    assert_read_en_seq rd;
    assert_start_pulse_seq st;
    opcode_0_seq add;
    
    function new (string name="nan_input_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    
        cfg = tto_fpu_config::type_id::create("cfg");
        env = tto_fpu_env::type_id::create("env", this);
    
        if(!uvm_config_db#(virtual tto_fpu_if)::get(this, "", "Virtual Interface", cfg.vif))
            `uvm_fatal(get_type_name(), "Failed to get Virtual interface")
      
        cfg.tto_act_agent = UVM_ACTIVE;
        cfg.tto_rst_agent = UVM_ACTIVE;
    
        uvm_config_db#(tto_fpu_config)::set(this, "*", "Config Object", cfg);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        rst=reset_seq::type_id::create("rst");
        no_op=no_op_seq::type_id::create("no");
        st=assert_start_pulse_seq::type_id::create("st");
        wr=assert_wr_en_seq::type_id::create("wr");
        rd=assert_read_en_seq::type_id::create("rd");
        inf1=load_1_nan_seq::type_id::create("inf1");
        inf2=load_2_inf_seq::type_id::create("inf2");
        add=opcode_0_seq::type_id::create("add");

        fork
            begin
                repeat(`rst_times) begin
                    rst.start(env.rst_ag.sqr);
                end
            end
            begin
                repeat(`n) begin
                    wr.start(env.act.sqr);
                    inf1.start(env.act.sqr);
                    wr.start(env.act.sqr);
                    inf2.start(env.act.sqr);
                    wr.start(env.act.sqr);
                    no_op.start(env.act.sqr);
                    wr.start(env.act.sqr);
                    no_op.start(env.act.sqr);
                    st.start(env.act.sqr);
                    add.start(env.act.sqr);

                    repeat(4) no_op.start(env.act.sqr);
           
                    rd.start(env.act.sqr);
                    no_op.start(env.act.sqr);
                    rd.start(env.act.sqr);
                    no_op.start(env.act.sqr);
                end
            end
        join
        
        phase.phase_done.set_drain_time(this, 10ns); 
        phase.drop_objection(this);
    endtask

endclass
