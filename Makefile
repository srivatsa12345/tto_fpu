# ==============================================================================
# Variables for easy modification
# ==============================================================================
MASTER_FILE = src/tb/globals/tto_fpu_package.sv
INCDIRS = +incdir+src/tb/globals
TESTNAME ?= sanity_test
COV_FLAGS = -cm line+cond+fsm+tgl+branch+assert

# Output directory for ALL logs, binaries, and databases
OUT_DIR = log_folder

# List of tests to run in a regression
TEST_LIST = sanity_test tto_base_test

# ==============================================================================
# Regression Variables
# ==============================================================================
JOBS ?= 4
SEED_LIST ?= 1234 5678 9012 3456 7890
REGRESS_TARGETS = $(foreach t,$(TEST_LIST),$(foreach s,$(SEED_LIST),regress_run_$(t).$(s)))

.PHONY: all start compile sim cov regression wave clean git init_dir

.DEFAULT_GOAL := all

# 1. Run the entire flow for a single test (Compile, Sim, Coverage)
all: compile sim cov

start:
	/bin/csh -c "source /fetools/synopsys/source/source.sh && exec /bin/csh"

# Create the output directory if it doesn't exist
init_dir:
	@mkdir -p $(OUT_DIR)

# 2. Compile the design
# Note: Added -o, -Mdir, and -cm_dir to route binaries and coverage to OUT_DIR
compile: init_dir
	vcs -full64 -sverilog -timescale=1ns/1ps -ntb_opts uvm-1.2 \
	-debug_access+all -kdb $(COV_FLAGS)$(INCDIRS) \
	-o $(OUT_DIR)/simv -Mdir=$(OUT_DIR)/csrc -cm_dir$(OUT_DIR)/simv.vdb \
	-l $(OUT_DIR)/compile.log $(MASTER_FILE)

# 3. Run the Simulation (Used for standalone / single test runs)
# Note: Pointing to simv inside OUT_DIR, and routing log/coverage there
sim: init_dir
	$(OUT_DIR)/simv -l$(OUT_DIR)/$(TESTNAME)_simulate.log $(COV_FLAGS) \
	-cm_dir $(OUT_DIR)/simv.vdb -cm_name $(TESTNAME) +UVM_TESTNAME=$(TESTNAME)

# 4. Generate the HTML Coverage Report
cov:
	urg -full64 -dir $(OUT_DIR)/simv.vdb -report$(OUT_DIR)/covReport

# 5. Run Regression (Compiles once, runs all tests x all seeds in parallel)
regression: compile
	@echo "=========================================================="
	@echo " RUNNING $(words$(TEST_LIST)) TESTS x $(words$(SEED_LIST)) SEEDS"
	@echo " Total Simulation Jobs: $(words $(REGRESS_TARGETS)) (Running$(JOBS) parallel jobs)"
	@echo "=========================================================="
	-$(MAKE) -k -j$(JOBS)$(REGRESS_TARGETS)
	@echo "=========================================================="
	@echo " GENERATING MERGED COVERAGE"
	@echo "=========================================================="
	$(MAKE) cov

# Pattern rule to execute individual test/seed combinations during regression
# Note: Fixed the pattern rule syntax for older versions of GNU Make
regress_run_%: init_dir
	@TNAME=$$(echo $* \vert{} cut -d'.' -f1); \ SEED=$$(echo$* | cut -d'.' -f2); \
	echo "-> Running $$TNAME [Seed:$$SEED]"; \
	$(OUT_DIR)/simv -l $(OUT_DIR)/$${TNAME}_$${SEED}_simulate.log $(COV_FLAGS) \
	-cm
