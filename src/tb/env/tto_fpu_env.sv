class tto_fpu_env extends uvm_env;
    `uvm_component_utils(tto_fpu_env)

    tto_fpu_active_agent act;
    tto_fpu_pass_agent pass;
    tto_fpu_sb scb;
    tto_fpu_sub sub;
    tto_fpu_config cfg;

    function new(string name="qspi_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        act = tto_fpu_active_agent::type_id::create("act", this);
        pass = tto_fpu_pass_agent::type_id::create("pass", this);
        scb = tto_fpu_sb::type_id::create("scb", this);
        sub = tto_fpu_sub::type_id::create("sub", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        act.mon.mon_port.connect(scb.in_mon);
        act.mon.mon_port.connect(sub.analysis_export);
        pass.mon.mon_port.connect(scb.flash_mon);
        pass.mon.mon_port.connect(sub.flash_out);
    endfunction

endclass
