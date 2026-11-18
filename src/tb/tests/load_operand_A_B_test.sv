class load_operand_A_B_test extends base_test;
    `uvm_component_utils(load_operand_A_B_test);
    
    tto_fpu_env env;
    tto_fpu_config cfg;

    reset_seq rst;
    write_one_byte_seq wr;
    no_op_seq no;  
    function new (string name="load_operand_A_B_test", uvm_component parent);
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
        wr=write_one_byte_seq::type_id::create("wr");
        
        rst.start(env.rst_ag.sqr);
        wr.start(env.act.sqr);
        no_op.start(env.act.sqr);
        wr.start(env.act.sqr);
        no_op.start(env.act.sqr);
        wr.start(env.act.sqr);
        no_op.start(env.act.sqr);
        wr.start(env.act.sqr);
        no_op.start(env.act.sqr);
                
        phase.phase_done.set_drain_time(this, 10ns); 
        phase.drop_objection(this);
    endtask

endclass
