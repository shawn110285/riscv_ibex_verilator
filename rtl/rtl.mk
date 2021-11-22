## ===============================================================================
## Purpose:	Builds the hello world tutorial project
## Targets:
##	The (default) or all target will build a verilator simulation for hello world.
##	clean	Removes all build products
## ================================================================================

.PHONY: all
.DELETE_ON_ERROR:


ROOT_DIR := /var/cpu_testbench/ibex

# the rtl files of the cpu core
RTL_DIR :=$(ROOT_DIR)/rtl/core
TB_DIR :=$(ROOT_DIR)/rtl/tb
INC_DIR :=$(ROOT_DIR)/rtl/include

CORE_RTL_FILES := $(RTL_DIR)/ibex_pkg.sv           $(RTL_DIR)/ibex_tracer_pkg.sv      $(RTL_DIR)/ibex_controller.sv          $(RTL_DIR)/ibex_cs_registers.sv  \
				  $(RTL_DIR)/ibex_fetch_fifo.sv    $(RTL_DIR)/ibex_multdiv_fast.sv    $(RTL_DIR)/ibex_register_file_ff.sv    $(RTL_DIR)/ibex_csr.sv   \
				  $(RTL_DIR)/ibex_icache.sv        $(RTL_DIR)/ibex_multdiv_slow.sv    $(RTL_DIR)/ibex_register_file_fpga.sv  $(RTL_DIR)/ibex_tracer.sv   \
				  $(RTL_DIR)/ibex_alu.sv           $(RTL_DIR)/ibex_core.sv            $(RTL_DIR)/ibex_decoder.sv             $(RTL_DIR)/ibex_id_stage.sv  \
				  $(RTL_DIR)/ibex_wb_stage.sv      $(RTL_DIR)/ibex_branch_predict.sv  $(RTL_DIR)/ibex_prefetch_buffer.sv     $(RTL_DIR)/ibex_register_file_latch.sv \
				  $(RTL_DIR)/ibex_dummy_instr.sv   $(RTL_DIR)/ibex_if_stage.sv        $(RTL_DIR)/ibex_compressed_decoder.sv  $(RTL_DIR)/ibex_top_tracing.sv \
				  $(RTL_DIR)/ibex_pmp.sv           $(RTL_DIR)/ibex_counter.sv         $(RTL_DIR)/ibex_ex_block.sv            $(RTL_DIR)/ibex_load_store_unit.sv\
				  $(RTL_DIR)/ibex_simple_system.sv $(RTL_DIR)/ibex_lockstep.sv        $(RTL_DIR)/ibex_top.sv      	          

TB_RTL_FILES := $(TB_DIR)/prim_ram_1p_pkg.sv  $(TB_DIR)/prim_ram_2p_pkg.sv  $(TB_DIR)/prim_pkg.sv  $(TB_DIR)/prim_util_pkg.sv  $(TB_DIR)/prim_clock_gating.sv  \
			    $(TB_DIR)/prim_generic_clock_gating.sv  $(TB_DIR)/bus.sv  $(TB_DIR)/ram_2p.sv \
				$(TB_DIR)/simulator_ctrl.sv   $(TB_DIR)/timer.sv    $(TB_DIR)/prim_ram_2p.sv  $(TB_DIR)/prim_generic_ram_2p.sv

VERILOG_FILES :=  $(TB_RTL_FILES)  \
	              $(CORE_RTL_FILES)  
	   
            
TOP_MOD = ibex_simple_system
VERILOG_OBJ_DIR = ./obj_dir
LOG_DIR = ./log

VERILATOR = verilator

#-Wall                      Enable all style warnings
#-Wno-style                 Disable all style warnings
#-Werror-<message>          Convert warnings to errors
#-Wno-lint                  Disable all lint warnings
#-Wno-<message>             Disable warning
#-I<dir>                    Directory to search for includes

# INCLUDE_DIR := ../ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_assert.sv
# VFLAGS := --cc -trace -Wall 
VFLAGS = -DRVFI --cc -trace -Wno-style -Wno-IMPLICIT -Wno-WIDTH -Wno-CASEINCOMPLETE

## Find the directory containing the Verilog sources.  This is given from
## calling: "verilator -V" and finding the VERILATOR_ROOT output line from
## within it.  From this VERILATOR_ROOT value, we can find all the components
## we need here--in particular, the verilator include directory
VERILATOR_ROOT ?= $(shell bash -c '$(VERILATOR) -V|grep VERILATOR_ROOT | head -1 | sed -e "s/^.*=\s*//"')

# covert the verilog file into the cpp file
$(VERILOG_OBJ_DIR)/V$(TOP_MOD).cpp: $(VERILOG_FILES)
	@echo "===================compile RTL into cpp files, start=========================="	
	$(VERILATOR) $(VFLAGS) -I$(INC_DIR) --top-module $(TOP_MOD) $(VERILOG_FILES) V$(TOP_MOD).cpp
	@echo "===================compile RTL into cpp files, end ==========================="

# create the c++ lib from the above cpp file
$(VERILOG_OBJ_DIR)/V$(TOP_MOD)__ALL.a: $(VERILOG_OBJ_DIR)/V$(TOP_MOD).cpp
	@echo "===============add rtl object files into cpp files, start======================"
#	make --no-print-directory -C $(VERILOG_OBJ_DIR) -f V$(TOP_MOD).mk
	make -C $(VERILOG_OBJ_DIR) -f V$(TOP_MOD).mk	
	@echo "===============add rtl object files into cpp files, end======================"

all: $(VERILOG_OBJ_DIR)/V$(TOP_MOD)__ALL.a

.PHONY: clean
clean:
	@echo "=========================cleaning RTL objects, start============================"
	rm -rf $(VERILOG_OBJ_DIR)/ 
	rm -rf $(LOG_DIR)/ 
	rm -rf $(TBFILE) 
	@echo "=========================cleaning RTL objects, end============================"

