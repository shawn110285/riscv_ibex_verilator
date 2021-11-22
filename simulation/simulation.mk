## ===============================================================================
## Purpose:	Builds the hello world tutorial project
## Targets:
##	The (default) or all target will build a verilator simulation for hello world.
##	clean	Removes all build products
## ================================================================================

.PHONY: all
.DELETE_ON_ERROR:

CC      = g++
AR      = ar 
ARFLAGS = -r
LD      = ld
LDFLAGS = 


## Find the directory containing the Verilog sources.  This is given from
## calling: "verilator -V" and finding the VERILATOR_ROOT output line from
## within it.  From this VERILATOR_ROOT value, we can find all the components
## we need here--in particular, the verilator include directory
VERILATOR = verilator
VERILATOR_ROOT ?= $(shell bash -c '$(VERILATOR) -V|grep VERILATOR_ROOT | head -1 | sed -e "s/^.*=\s*//"')

VINC = $(VERILATOR_ROOT)/include
VINC1 = $(VERILATOR_ROOT)/include/vltstd
VERILOG_OBJ_DIR = ../rtl/obj_dir

# Modern versions of Verilator and C++ may require an -faligned-new flag
CFLAGS = -g -Wall -faligned-new -c -I$(VINC) -I$(VINC1) -I$(VERILOG_OBJ_DIR) -DTOPLEVEL_NAME="ibex_simple_system"


# the linked lib 
STANDARD_LIBS     = -lrt -lm -lpthread -lelf
STANDARD_LIBS_DIR = /usr/lib/x86_64-linux-gnu/

TARGET_DIR = ./obj_dir

objects = $(TARGET_DIR)/ibex_simple_system_main.o $(TARGET_DIR)/ibex_simple_system.o $(TARGET_DIR)/dpi_memutil.o  $(TARGET_DIR)/sv_scoped.o  \
			$(TARGET_DIR)/ibex_pcounts.o $(TARGET_DIR)/verilated_toplevel.o $(TARGET_DIR)/verilator_memutil.o  $(TARGET_DIR)/verilator_sim_ctrl.o \
			$(TARGET_DIR)/mem_area.o $(TARGET_DIR)/verilated_vcd_c.o $(TARGET_DIR)/verilated.o $(TARGET_DIR)/verilated_dpi.o

target  = $(TARGET_DIR)/libtb.a


$(TARGET_DIR)/ibex_simple_system_main.o: ibex_simple_system_main.cc
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

$(TARGET_DIR)/ibex_simple_system.o: ibex_simple_system.cc
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

$(TARGET_DIR)/dpi_memutil.o: dpi_memutil.cc
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

$(TARGET_DIR)/sv_scoped.o: sv_scoped.cc
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

$(TARGET_DIR)/ibex_pcounts.o: ibex_pcounts.cc
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

$(TARGET_DIR)/verilated_toplevel.o: verilated_toplevel.cc
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

$(TARGET_DIR)/verilator_memutil.o: verilator_memutil.cc
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

$(TARGET_DIR)/verilator_sim_ctrl.o: verilator_sim_ctrl.cc
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

$(TARGET_DIR)/mem_area.o: mem_area.cc
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

$(TARGET_DIR)/verilated_vcd_c.o: $(VINC)/verilated_vcd_c.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

$(TARGET_DIR)/verilated.o: $(VINC)/verilated.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

$(TARGET_DIR)/verilated_dpi.o: $(VINC)/verilated_dpi.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '


# All Target
all: $(target)

$(target): $(objects) 
	@echo "===================add simulation objects into library, start=========================="	
	@echo "add objects [$(objects)] to lib:$(target)"
	@$(AR) $(ARFLAGS) $(target) $(objects)
	@echo "===================add simulation objects into library, end ==========================="	
	@echo ' '

# Other Targets
clean:
	@echo "=========================cleaning simulation objects, start============================"
	$(RM) $(target)
	$(RM) $(objects)
	@echo "=========================cleaning simulation objects, end==============================="


.PHONY: all clean
