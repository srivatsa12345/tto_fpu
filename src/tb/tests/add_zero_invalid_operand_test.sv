class add_zero_invalid_operand_test extends uvm_test;
    `uvm_component_utils(add_zero_invalid_operand_test)

    tto_fpu_env env;
    tto_fpu_config cfg;
    add_zero_invalid_operand_vseq v_seq;

    function new(string name="add_zero_invalid_operand_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        cfg=tto_fpu_config::type_id::create("cfg");
        env=tto_fpu_env::type_id::create("env", this);

        if(!uvm_config_db#(virtual tto_fpu_if)::get(this, "", "Virtual Interface", cfg.vif))
            `uvm_fatal(get_type_name(), "Failed to get Virtual interface")

        cfg.tto_act_agent=UVM_ACTIVE;
        cfg.tto_rst_agent=UVM_ACTIVE;

        uvm_config_db#(tto_fpu_config)::set(this, "*", "Config Object", cfg);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        v_seq=add_zero_invalid_operand_vseq::type_id::create("v_seq");
        v_seq.start(env.v_sqr);
        phase.phase_done.set_drain_time(this, 10ns);
        phase.drop_objection(this);
    endtask

endclass
