class tto_fpu_driver extends uvm_driver#(tto_fpu_seq_item);
 
    `uvm_component_utils(tto_fpu_driver)
 
    virtual tto_fpu_if.DRV vif;
    tto_fpu_config cfg;
 
    function new(string name="tto_fpu_driver",uvm_component parent);
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
            @(vif.drv_cb);
            if(!vif.drv_cb.rst_n) begin
                do begin
                    vif.drv_cb.ui_in<=0;
                    vif.drv_cb.uio_in<=0;
                    @(vif.drv_cb);
                 end while (vif.drv_cb.rst_n);
            end
            vif.drv_cb.ui_in<=req.ui_in;
            vif.drv_cb.uio_in<=req.uio_in;
         `uvm_info("DRV", $sformatf("Driven data:RESET:%0b, ui_in:%0h, uio_in:%0h", vif.drv_cb.rst_n, req.ui_in, req.uio_in), UVM_LOW)
            seq_item_port.item_done();
        end
    endtask
 
endclass
