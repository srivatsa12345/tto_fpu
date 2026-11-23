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
    `include "../sequences/write_read_simul_seq.sv"
    `include "../sequences/assert_wr_en_seq.sv"
    `include "../sequences/assert_start_pulse_seq.sv"
    `include "../sequences/assert_read_en_seq.sv"
    `include "../sequences/opcode_0_seq.sv"
    `include "../sequences/opcode_1_seq.sv"
    `include "../sequences/load_0_seq.sv"
    `include "../sequences/load_1_max_seq.sv"
    `include "../sequences/load_1_min_seq.sv"
    `include "../sequences/load_1_nan_seq.sv"
    `include "../sequences/load_2_inf_seq.sv"
    `include "../sequences/load_2_max_seq.sv"
    `include "../sequences/load_2_neg_5_seq.sv"
    `include "../sequences/load_2_neg_inf_seq.sv"
    `include "../sequences/load_2_neg_max_seq.sv"
    `include "../sequences/load_4_5_val_1_seq.sv"
    `include "../sequences/load_5_seq.sv"
    `include "../sequences/load_exp_28_seq.sv"
    `include "../sequences/load_shift_1_seq.sv"
    `include "../sequences/load_shift_2_seq.sv"
    `include "../sequences/mantissa_alignment_load_1_seq.sv"
    `include "../sequences/mantissa_alignment_load_2_seq.sv"
    `include "../sequences/mantissa_alignment_load_4_seq.sv"
    `include "../sequences/load_01010111_seq.sv"
    `include "../sequences/load_11110011_seq.sv"
    `include "../sequences/load_01111001_seq.sv"
    `include "../sequences/load_00011100_seq.sv"
    `include "../sequences/assert_start_read_simul_seq.sv"
    `include "../sequences/assert_read_write_simul_seq.sv"
    `include "../sequences/assert_start_write_read_simul_seq.sv"
    `include "../sequences/assert_start_write_simul_seq.sv"

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
    `include "../tests/sanity2.sv"
    `include "../tests/add_sub_zero_operand_test.sv"
    `include "../tests/add_zero_invalid_operand_test.sv"
    `include "../tests/add_zero_operand_test.sv"
    `include "../tests/back_to_back_op_test.sv"
    `include "../tests/back_to_back_read_test.sv"
    `include "../tests/exact_cancellation_add_test.sv"
    `include "../tests/exact_cancellation_test.sv"
    `include "../tests/flag_test.sv"
    `include "../tests/inf_input_test.sv"
    `include "../tests/load_incomplete_test.sv"
    `include "../tests/mantissa_alignment_test.sv"
    `include "../tests/mantissa_normalization_sub_test.sv"
    `include "../tests/mantissa_normalization_test.sv"
    `include "../tests/nan_input_test.sv"
    `include "../tests/normal_addition_test.sv"
    `include "../tests/normal_subtraction_test.sv"
    `include "../tests/overflow_diff_exp_test.sv"
    `include "../tests/overflow_max_test.sv"
    `include "../tests/overflow_neg_max_test.sv"
    `include "../tests/read_before_op_test.sv"
    `include "../tests/read_pointer_reset_test.sv"
    `include "../tests/read_write_in_between_test.sv"
    `include "../tests/shift_out_test.sv"
    `include "../tests/start_busy_test.sv"
    `include "../tests/start_high_test.sv"
    `include "../tests/subnormal_input_test.sv"
    `include "../tests/sub_zero_invalid_operand_test.sv"
    `include "../tests/sub_zero_operand_A_test.sv"
    `include "../tests/sub_zero_operand_B_test.sv"
    `include "../tests/underflow_min_test.sv"
    `include "../tests/write_busy_test.sv"
    `include "../tests/write_read_in_between_test.sv"
    `include "../tests/write_read_test.sv"
endpackage : tto_fpu_package

// DUT
`include "../../dut/fpu_core.v"
`include "../../dut/tt_um_project_fpu.v"

// Interface & Assertions
`include "../tto_fpu_if.sv"
`include "../tto_fpu_assertions.sv"

// Top-level Module
`include "../tto_fpu_top.sv"
