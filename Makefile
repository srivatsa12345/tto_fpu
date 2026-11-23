# Variables for easy modification
MASTER_FILE = src/tb/globals/tto_fpu_package.sv
INCDIRS = +incdir+src/tb/globals
TESTNAME ?= flag_test
COV_FLAGS = -cm line+cond+fsm+tgl+branch+assert
OUT_DIR = log_folder

# Wait in queue if Synopsys licenses are busy (applies to vcs, simv, urg, verdi)
export SNPSLMD_QUEUE := 1
LIC_FLAGS = -licqueue

# List of tests to run in a regression
TEST_LIST = \
	add_sub_zero_operand_test \
	add_zero_invalid_operand_test \
	add_zero_operand_test \
	back_to_back_op_test \
	back_to_back_read_test \
	exact_cancellation_add_test \
	exact_cancellation_test \
	inf_input_test \
	load_incomplete_test \
	mantissa_alignment_test \
	mantissa_normalization_sub_test \
	mantissa_normalization_test \
	nan_input_test \
	normal_addition_test \
	normal_subtraction_test \
	overflow_diff_exp_test \
	overflow_max_test \
	overflow_neg_max_test \
	read_before_op_test \
	read_pointer_reset_test \
	read_write_in_between_test \
	sanity2 \
	sanity_test \
	shift_out_test \
	start_busy_test \
	start_high_test \
	subnormal_input_test \
	sub_zero_invalid_operand_test \
	sub_zero_operand_A_test \
	sub_zero_operand_B_test \
	tto_base_test \
	underflow_min_test \
	write_busy_test \
	write_read_in_between_test \
	write_read_test \
	flag_test

# ==============================================================================
# Regression Variables
# ==============================================================================
JOBS ?= 4
SEED_LIST ?= 1234 5678 9012 3456 7890
REGRESS_TARGETS = $(foreach t,$(TEST_LIST),$(foreach s,$(SEED_LIST),regress_run_$(t).$(s)))

.PHONY: all start compile sim cov regression wave clean git

.DEFAULT_GOAL := all

# 1. Run the entire flow for a single test (Compile, Sim, Coverage)
all: compile sim cov

start:
	/bin/csh -c "source /fetools/synopsys/source/source.sh && exec /bin/csh"

# 2. Compile the design
compile:
	mkdir -p $(OUT_DIR)
	rm -rf $(OUT_DIR)/*.vdb
	vcs -full64 -sverilog -timescale=1ns/1ps -ntb_opts uvm-1.2 \
	$(LIC_FLAGS) -debug_access+all -kdb $(COV_FLAGS) $(INCDIRS) \
	-Mdir=$(OUT_DIR)/csrc -o $(OUT_DIR)/simv -cm_dir $(OUT_DIR)/simv.vdb \
	-cm_log $(OUT_DIR)/cm_compile.log \
	-l $(OUT_DIR)/compile.log $(MASTER_FILE)

# 3. Run the Simulation (Used for standalone / single test runs)
# Note: Changing into the log folder first forces all hardcoded logs to drop there
sim:
	cd $(OUT_DIR) && ./simv $(LIC_FLAGS) -l $(TESTNAME)_simulate.log $(COV_FLAGS) \
	-cm_dir simv.vdb -cm_name $(TESTNAME) \
	-cm_log cm_sim.log -key ucli.key \
	+fsdbfile+dump.fsdb \
	+UVM_TESTNAME=$(TESTNAME)

# 4. Generate the Merged HTML Coverage Report
cov:
	cd $(OUT_DIR) && rm -rf merged.vdb covReport && \
	urg -full64 -dir *.vdb -dbname merged.vdb -report covReport -log urg.log

# 5. Run Regression (Compiles once, runs all tests x all seeds in parallel)
regression: compile
	@echo "=========================================================="
	@echo " RUNNING $(words $(TEST_LIST)) TESTS x $(words $(SEED_LIST)) SEEDS"
	@echo " Total Simulation Jobs: $(words $(REGRESS_TARGETS)) (Running $(JOBS) parallel jobs)"
	@echo "=========================================================="
	-$(MAKE) -k -j$(JOBS) $(REGRESS_TARGETS)
	@echo "=========================================================="
	@echo " GENERATING MERGED COVERAGE"
	@echo "=========================================================="
	$(MAKE) cov

# Pattern rule to execute individual test/seed combinations during regression
$(REGRESS_TARGETS): regress_run_%:
	@TNAME=$$(echo $* | cut -d'.' -f1); \
	SEED=$$(echo $* | cut -d'.' -f2); \
	echo "-> Running $$TNAME [Seed: $$SEED]"; \
	cd $(OUT_DIR) && ./simv $(LIC_FLAGS) -l $${TNAME}_$${SEED}_simulate.log $(COV_FLAGS) \
	-cm_dir $${TNAME}_$${SEED}.vdb -cm_name $${TNAME}_$${SEED} \
	-cm_log $${TNAME}_$${SEED}_cm.log \
	-key $${TNAME}_$${SEED}_ucli.key \
	+fsdbfile+$${TNAME}_$${SEED}.fsdb \
	+UVM_TESTNAME=$$TNAME +ntb_random_seed=$$SEED > /dev/null

# 6. Open the Waveform in Verdi
wave:
	cd $(OUT_DIR) && verdi -ssf dump.fsdb &

# 7. Clean up generated files to start fresh
clean:
	rm -rf $(OUT_DIR)/simv* $(OUT_DIR)/csrc* $(OUT_DIR)/*.log $(OUT_DIR)/*.vpd \
	$(OUT_DIR)/*.fsdb $(OUT_DIR)/*.vdb $(OUT_DIR)/*ucli.key $(OUT_DIR)/verdiLog \
	$(OUT_DIR)/novas* $(OUT_DIR)/covReport DVEfiles

# 8. Git automation (stages all files across all directories, including log_folder)
git:
	@echo "Enter your git commit message:"; \
	read msg; \
	git add -A; \
	git commit -m "$$msg"; \
	git push
