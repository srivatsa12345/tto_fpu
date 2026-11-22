class sanity2 extends uvm_test;
    `uvm_component_utils(sanity2)
    
    tto_fpu_env env;
    tto_fpu_config cfg;

    reset_seq rst;
    assert_wr_en_seq wr;
    assert_start_pulse_seq st;
    load_01010111_seq opal;
    load_11110011_seq opam;
    load_01111001_seq opbl;
    load_00011100_seq opbm;
    opcode_0_seq op;
    assert_read_en_seq rd;
	no_op_seq no;
  
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
        opal=load_01010111_seq::type_id::create("opal");
        opam=load_11110011_seq::type_id::create("opam");
        opbl=load_01111001_seq::type_id::create("opbl");
        opbm=load_00011100_seq::type_id::create("opbm");
        rd=assert_read_en_seq::type_id::create("rd");
        op=opcode_0_seq::type_id::create("op");
        fork
            begin
				repeat(`rst_times) begin
		        	rst.start(env.rst_ag.sqr);
				end
            end
            begin
				repeat(6) begin
					repeat(1) begin
						wr.start(env.act.sqr);
						opal.start(env.act.sqr);
                        wr.start(env.act.sqr);
						opam.start(env.act.sqr);
                        wr.start(env.act.sqr);
						opbl.start(env.act.sqr);
                        wr.start(env.act.sqr);
						opbm.start(env.act.sqr);
					end
                	st.start(env.act.sqr);
                    op.start(env.act.sqr);
					repeat(3) no.start(env.act.sqr);
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
