class flag_test extends uvm_test;
    `uvm_component_utils(flag_test)
    
    tto_fpu_env env;
    tto_fpu_config cfg;

    reset_seq rst;
    assert_start_write_read_simul_seq swr;
    assert_start_read_simul_seq sr;
    assert_start_write_read_simul_seq rw;
    assert_wr_en_seq wr;
    assert_start_pulse_seq st;
    no_op_seq no;
    assert_read_en_seq rd;
  
    function new (string name, uvm_component parent);
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
		        	rst.start(env.rst_ag.sqr);
				end
            end
            begin
				repeat(`n) begin
                    repeat(5) swr.start(env.act.sqr);
                    repeat(5) sr.start(env.act.sqr);
                    repeat(3) begin
                        swr.start(env.act.sqr);
                        sr.start(env.act.sqr);
                    end
					no.start(env.act.sqr);
                    repeat(10) begin
                        swr.start(env.act.sqr);
					end
                    repeat(4) rw.start(env.act.sqr);
					repeat(5) swr.start(env.act.sqr);
                	repeat(2) begin
                	    rd.start(env.act.sqr);
                    	no.start(env.act.sqr);
                	end
					repeat(2) wr.start(env.act.sqr);
					repeat(2) begin
                	    rd.start(env.act.sqr);
                    	no.start(env.act.sqr);
                	end
					repeat(2) no.start(env.act.sqr);
				end
            end
        join
        phase.phase_done.set_drain_time(this, 10ns); 
        phase.drop_objection(this);
    endtask

endclass
