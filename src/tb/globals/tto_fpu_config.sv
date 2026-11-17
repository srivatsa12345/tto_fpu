class tto_fpu_config extends uvm_object;

    `uvm_object_utils(tto_fpu_config)
    function new(string name="tto_fpu_config");
        super.new(name);
    endfunction
    
    virtual tto_fpu_if vif;

    uvm_active_passive_enum tto_act_agent;
    uvm_active_passive_enum tto_rst_agent;

endclass
 
