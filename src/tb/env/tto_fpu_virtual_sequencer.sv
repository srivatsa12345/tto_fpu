class tto_fpu_virtual_sequencer extends uvm_sequencer;
    `uvm_component_utils(tto_fpu_virtual_sequencer)

    tto_fpu_active_sequencer act_sqr;
    tto_fpu_rst_sequencer rst_sqr;

    function new(string name="tto_fpu_virtual_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction

endclass
