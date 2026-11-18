package tto_fpu_package;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `uvm_analysis_imp_decl(_out)
    // Globals
    `include "tto_fpu_defines.svh"
    `include "tto_fpu_config.sv"
    `include "tto_fpu_seq_item.sv"
    // Sequences
    `include "../sequences/base_seq.sv"
    `include "../sequences/reset_seq.sv"
    `include "../sequences/no_op_seq.sv"
    `include "../sequences/write_one_byte_seq.sv"
    `include "../sequences/assert_start_pulse_seq.sv"
    `include "../sequences/assert_read_en_seq.sv"
    // Active Agent 
    `include "../env/active_agent/tto_fpu_sequencer.sv"
    `include "../env/active_agent/tto_fpu_driver.sv"
    `include "../env/active_agent/tto_fpu_in_mon.sv"
    `include "../env/active_agent/tto_fpu_active_agent.sv"
    // Reset / Output Agent 
    `include "../env/rst_agent/tto_fpu_rst_sequencer.sv"
    `include "../env/rst_agent/tto_fpu_rst_driver.sv"
    `include "../env/rst_agent/tto_fpu_out_mon.sv"
    `include "../env/rst_agent/tto_fpu_rst_agent.sv"
    // Environment
    `include "../env/tto_fpu_sub.sv"
    `include "../env/tto_fpu_sb.sv"
    `include "../env/tto_fpu_env.sv"
    // Tests
    `include "../tests/tto_base_test.sv"
    `include "../tests/sanity_test.sv"
endpackage : tto_fpu_package
// DUT
`include "../../dut/fpu_core.v"
`include "../../dut/tt_um_project_fpu.v"
// Interface & Assertions
`include "../tto_fpu_if.sv"
`include "../tto_fpu_assertions.sv"
// Top-level Module
`include "../tto_fpu_top.sv"
