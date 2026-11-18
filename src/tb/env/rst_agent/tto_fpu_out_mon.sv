class tto_fpu_out_mon extends uvm_monitor;
    `uvm_component_utils(tto_fpu_out_mon)

    function new(string name="tto_fpu_out_mon", uvm_component parent);
        super.new(name, parent);
    endfunction

    tto_fpu_seq_item tr;
    virtual tto_fpu_if.OUT_MON vif;
    uvm_analysis_port#(tto_fpu_seq_item) mon_port;
    tto_fpu_config cfg;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_port=new("mon_port", this);
        if (!uvm_config_db#(tto_fpu_config)::get(this, " ", "Config Object", cfg))
            `uvm_fatal(get_type_name(), "Failed to get Config Object")
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif=cfg.vif;
    endfunction

    task run_phase(uvm_phase phase);
        repeat(1) @(vif.out_mon_cb);
        forever begin
            tr=tto_fpu_seq_item::type_id::create("tr");
            @(vif.out_mon_cb);
            tr.uio_oe=vif.out_mon_cb.uio_oe;
            tr.uio_out=vif.out_mon_cb.uio_out;
            tr.uo_out=vif.out_mon_cb.uo_out;
            `uvm_info("OUT_MON", $sformatf("Sampled data:uio_oe:%0h, uio_out:%0h, uo_out:%0h", tr.uio_oe, tr.uio_out, tr.uo_out), UVM_LOW)
            mon_port.write(tr);
        end
    endtask
endclass
