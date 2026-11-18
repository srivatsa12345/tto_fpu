class tto_fpu_in_mon extends uvm_monitor;
    `uvm_component_utils(tto_fpu_in_mon)

    function new(string name="tto_fpu_in_mon", uvm_component parent);
        super.new(name, parent);
    endfunction

    tto_fpu_seq_item tr;
    virtual tto_fpu_if.IN_MON vif;
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
        //@(vif.in_mon_cb);
        forever begin
            tr=tto_fpu_seq_item::type_id::create("tr");
            @(vif.in_mon_cb);
            tr.rst_n=vif.in_mon_cb.rst_n;
            tr.ui_in=vif.in_mon_cb.ui_in;
            tr.uio_in=vif.in_mon_cb.uio_in;
            `uvm_info("INPUT_MON", $sformatf("Sampled data:RESET:%0b, ui_in:%0h, uio_in:%0h", tr.rst_n, tr.ui_in, tr.uio_in), UVM_LOW)
            mon_port.write(tr);
        end
    endtask
endclass
