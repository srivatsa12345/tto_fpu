class tto_fpu_rst_agent extends uvm_agent;

    `uvm_component_utils(tto_fpu_rst_agent)

    function new(string name="tto_fpu_rst_agent",uvm_component parent);
        super.new(name,parent);
    endfunction

    tto_fpu_rst_sequencer sqr;
    tto_fpu_rst_driver drv;
    tto_fpu_out_mon mon;
    tto_fpu_config cfg;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(tto_fpu_config)::get(this,"","Config Object",cfg))
            `uvm_fatal(get_type_name(),"Couldn't get the config object")
        mon=tto_fpu_out_mon::type_id::create("mon",this);

        if(cfg.tto_rst_agent==UVM_ACTIVE) begin
            drv=tto_fpu_rst_driver::type_id::create("drv",this);
            sqr=tto_fpu_rst_sequencer::type_id::create("sqr",this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(cfg.tto_rst_agent==UVM_ACTIVE)
            drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass

 
