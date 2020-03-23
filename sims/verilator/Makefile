#########################################################################################
# verilator makefile
#########################################################################################

#########################################################################################
# general path variables
#########################################################################################
base_dir=$(abspath ../..)
sim_dir=$(abspath .)

#########################################################################################
# include shared variables
#########################################################################################
include $(base_dir)/variables.mk

#########################################################################################
# name of simulator (used to generate *.f arguments file)
#########################################################################################
sim_name = verilator

#########################################################################################
# vcs simulator types and rules
#########################################################################################
sim_prefix = simulator
sim = $(sim_dir)/$(sim_prefix)-$(MODEL_PACKAGE)-$(CONFIG)
sim_debug = $(sim_dir)/$(sim_prefix)-$(MODEL_PACKAGE)-$(CONFIG)-debug

PERMISSIVE_ON=
PERMISSIVE_OFF=

WAVEFORM_FLAG=-v$(sim_out_name).vcd

.PHONY: default debug
default: $(sim)
debug: $(sim_debug)

#########################################################################################
# import other necessary rules and variables
#########################################################################################
include $(base_dir)/common.mk
include $(sim_dir)/verilator.mk

#############################################################################
# selectively enabling printfs
#############################################################################
ENABLE_PRINTF_PATTERN ?=
sim_vsrcs_printf := $(sim_vsrcs:.v=.printf.v)

#########################################################################################
# verilator binary and flags
#########################################################################################
# NOTE: can't use -Wall, firrtl spits out 1000's of warnings that flag as erros
#VERILATOR := $(INSTALLED_VERILATOR) --cc --exe -Wall
VERILATOR := $(INSTALLED_VERILATOR) --cc --exe

RUNTIME_PROFILING_CFLAGS := 
RUNTIME_PROFILING_VFLAGS := 
#RUNTIME_PROFILING_CFLAGS := -p -gp
#RUNTIME_PROFILING_VFLAGS := --prof-cfuncs --prof-threads

# 4 total speed settings: slow-mode, medium-mode, fast-mode, fast-mode+LTO
#CMODE := -g
#CMODE := -O1
#CMODE := -O3
#CMODE := -O3 -fbranch-probabilities
CMODE := -O3 -fbranch-probabilities -flto

CXXFLAGS := $(CXXFLAGS) \
						$(RUNTIME_PROFILING_CFLAGS) \
						$(CMODE) \
						-std=c++11 \
						-I$(RISCV)/include \
						-D__STDC_FORMAT_MACROS \
						-DTEST_HARNESS=V$(VLOG_MODEL) \
						-DVERILATOR \
						-I$(build_dir) \
						-include $(build_dir)/$(long_name).plusArgs \
						-include $(build_dir)/verilator.h

LDFLAGS	:=	$(LDFLAGS) \
						$(CMODE) \
						-L$(RISCV)/lib \
						-Wl,-rpath,$(RISCV)/lib \
						-L$(sim_dir) \
						-lfesvr \
						-lpthread

VERILATOR_CC_OPTS := -CFLAGS "$(CXXFLAGS)" -LDFLAGS "$(LDFLAGS)"

#----------------------------------------------------------------------------
# bwrc threads
#RUNTIME_THREADS := 
#RUNTIME_THREADS := --threads 4 --threads-dpi none
#RUNTIME_THREADS := --threads 4 --threads-dpi all
RUNTIME_THREADS := --threads 20 --threads-dpi all

# slow mode, fast mode
#VMODE := -O0 --assert 
#VMODE := --assert --output-split 10000 --output-split-cfuncs 10000
VMODE := -O3 --x-assign fast --x-initial fast --noassert --output-split 10000 --output-split-cfuncs 10000

VERILATOR_NONCC_OPTS := \
	$(RUNTIME_PROFILING_VFLAGS) \
	$(RUNTIME_THREADS) \
	$(VMODE) \
	--top-module $(VLOG_MODEL) \
	+define+PRINTF_COND=\$$c\(\"verbose\",\"\&\&\"\,\"done_reset\"\) \
	+define+STOP_COND=\$$c\(\"done_reset\"\) \
	$(sim_vsrcs_printf) \
	-f $(sim_common_files)

VERILATOR_OPTS := $(VERILATOR_CC_OPTS) $(VERILATOR_NONCC_OPTS)

#########################################################################################
# verilator build paths and file names
#########################################################################################
model_dir = $(build_dir)/$(long_name)
model_dir_debug = $(build_dir)/$(long_name).debug

model_header = $(model_dir)/V$(VLOG_MODEL).h
model_header_debug = $(model_dir_debug)/V$(VLOG_MODEL).h

model_mk = $(model_dir)/V$(VLOG_MODEL).mk
model_mk_debug = $(model_dir_debug)/V$(VLOG_MODEL).mk

#############################################################################
# selectively enable verbose logging
#############################################################################
# see GNU Make static patterns
$(sim_vsrcs_printf) : %.printf.v : %.v
	$(base_dir)/scripts/sim/enable_printfs $< $@ "$(ENABLE_PRINTF_PATTERN)"

#########################################################################################
# build makefile fragment that builds the verilator sim rules
#########################################################################################

$(model_mk): $(sim_vsrcs_printf) $(sim_common_files) $(INSTALLED_VERILATOR)
	rm -rf $(build_dir)/$(long_name)
	mkdir -p $(build_dir)/$(long_name)
	$(VERILATOR) $(VERILATOR_OPTS) -o $(sim) -Mdir $(model_dir) -CFLAGS "-include $(model_header)"
	touch $@

$(model_mk_debug): $(sim_vsrcs_printf) $(sim_common_files) $(INSTALLED_VERILATOR)
	rm -rf $(build_dir)/$(long_name)
	mkdir -p $(build_dir)/$(long_name).debug
	$(VERILATOR) $(VERILATOR_OPTS) -o $(sim_debug) --trace -Mdir $(model_dir_debug) -CFLAGS "-include $(model_header_debug)"
	touch $@

#########################################################################################
# invoke make to make verilator sim rules
#########################################################################################
$(sim): $(model_mk)
	$(MAKE) VM_PARALLEL_BUILDS=1 -C $(model_dir) -f V$(VLOG_MODEL).mk

$(sim_debug): $(model_mk_debug)
	$(MAKE) VM_PARALLEL_BUILDS=1 -C $(model_dir_debug) -f V$(VLOG_MODEL).mk

#########################################################################################
# create a verilator vpd rule
#########################################################################################
.PRECIOUS: $(output_dir)/%.vpd %.vcd
$(output_dir)/%.vpd: $(output_dir)/% $(sim_debug)
	rm -f $@.vcd && mkfifo $@.vcd
	vcd2vpd $@.vcd $@ > /dev/null &
	(set -o pipefail && $(sim_debug) $(PERMISSIVE_ON) +max-cycles=$(timeout_cycles) $(SIM_FLAGS) $(VERBOSE_FLAGS) -v$@.vcd $(PERMISSIVE_OFF) $< 2> >(spike-dasm > $<.out) | tee $<.log)

#########################################################################################
# general cleanup rule
#########################################################################################
.PHONY: clean
clean:
	rm -rf $(gen_dir) $(sim_prefix)-*
