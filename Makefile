# Variables for easy modification
MASTER_FILE = src/tb/globals/tto_fpu_package.sv
INCDIRS = +incdir+src/tb/globals
TESTNAME ?= sanity_test
COV_FLAGS = -cm line+cond+fsm+tgl+branch+assert

# List of tests to run in a regression
TEST_LIST = sanity_test tto_base_test

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
# Note: Added -kdb for Verdi integration and FSDB dumping support
compile:
	vcs -full64 -sverilog -timescale=1ns/1ps -ntb_opts uvm-1.2 \
	-debug_access+all -kdb $(COV_FLAGS) $(INCDIRS) -l compile.log $(MASTER_FILE)

# 3. Run the Simulation (Used for standalone / single test runs)
# Note: Added -cm_name to keep coverage distinct for regressions
sim:
	./simv -l $(TESTNAME)_simulate.log $(COV_FLAGS) -cm_name $(TESTNAME) +UVM_TESTNAME=$(TESTNAME)

# 4. Generate the HTML Coverage Report
cov:
	urg -full64 -dir simv.vdb -report covReport

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
	./simv -l $${TNAME}_$${SEED}_simulate.log $(COV_FLAGS) -cm_name $${TNAME}_$${SEED} +UVM_TESTNAME=$$TNAME +ntb_random_seed=$$SEED +FSDB_NAME=$${TNAME}_$${SEED}.fsdb > /dev/null

# 6. Open the Waveform in Verdi
wave:
	verdi -ssf dump.fsdb &

# 7. Clean up generated files to start fresh
clean:
	rm -rf simv* csrc* *.log *.vpd *.fsdb *.vdb ucli.key verdiLog novas* covReport DVEfiles

# 8. Git automation
git:
	@echo "Enter your git commit message:"; \
	read msg; \
	git add src/ Makefile *.md; \
	git commit -m "$$msg"; \
	git push
