class tto_fpu_rst_driver extends uvm_driver#(tto_fpu_seq_item);
 
    `uvm_component_utils(tto_fpu_rst_driver)
 
    virtual tto_fpu_if.RST_DRV vif;
    tto_fpu_config cfg;
 
    function new(string name="tto_fpu_rst_driver",uvm_component parent);
        super.new(name,parent);
    endfunction
 
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(tto_fpu_config)::get(this,"","Config Object",cfg))
            `uvm_fatal(get_type_name(),"Failed to get Config Object")
    endfunction
 
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif=cfg.vif;
    endfunction
 
    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            vif.rst_n<=req.rst_n;
            `uvm_info("RST_DRV", $sformatf("RESET ASSERTED"), UVM_LOW)
            repeat(3) @(vif.rst_drv_cb);
            vif.rst_n<=!req.rst_n;
            `uvm_info("RST_DRV", $sformatf("RESET DE-ASSERTED"), UVM_LOW)
            repeat(`rst) @(vif.rst_drv_cb);
            seq_item_port.item_done();
        end
    endtask
endclass
