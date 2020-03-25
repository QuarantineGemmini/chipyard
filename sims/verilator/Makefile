#============================================================================
# verilator makefile
#============================================================================

#============================================================================
# general path variables
#============================================================================
base_dir=$(abspath ../..)
sim_dir=$(abspath .)
patch_dir=$(sim_dir)/patch

#============================================================================
# include shared variables
#============================================================================
include $(base_dir)/variables.mk

#============================================================================
# name of simulator (used to generate *.f arguments file)
#============================================================================
sim_name = verilator

#============================================================================
# verilator simulator types and rules
#============================================================================
sim_prefix = simulator
sim = $(sim_dir)/$(sim_prefix)-$(MODEL_PACKAGE)-$(CONFIG)
sim_debug = $(sim_dir)/$(sim_prefix)-$(MODEL_PACKAGE)-$(CONFIG)-debug

PERMISSIVE_ON=
PERMISSIVE_OFF=

WAVEFORM_FLAG=-v$(sim_out_name).vcd

.PHONY: default debug
default: $(sim)
debug: $(sim_debug)

#============================================================================
# import other necessary rules and variables
#============================================================================
include $(base_dir)/common.mk
include $(sim_dir)/verilator.mk

#============================================================================
# selectively enabling printfs
#============================================================================
ENABLE_PRINTF_PATTERN ?=
sim_vsrcs_printf := $(sim_vsrcs:.v=.printf.v)

#============================================================================
# verilator/cxx binary and flags
#============================================================================
# can't use -Wall, firrtl spits out 1000's of warnings that flag as erros
#VERILATOR := $(INSTALLED_VERILATOR) --cc --exe -Wall
VERILATOR := $(INSTALLED_VERILATOR) --cc --exe

#----------------------------------------------------------------------------
# profiling configs
#----------------------------------------------------------------------------
VL8_PROFILE ?= none
RUNTIME_PROFILING_CFLAGS := $(if $(filter $(VL8_PROFILE),all),-g -pg,)
RUNTIME_PROFILING_VFLAGS := $(if $(filter $(VL8_PROFILE),all),\
															--prof-threads --prof-cfuncs,\
															$(if $(filter $(VL8_PROFILE),threads),\
																--prof-threads,))

VL8_THREADS ?= 1
RUNTIME_THREADS := --threads $(VL8_THREADS) --threads-dpi all

VL8_FST_MODE ?= 0
TRACING_OPTS := $(if $(filter $(VL8_FST_MODE),0),--trace,--trace-fst-thread)
TRACING_CFLAGS := $(if $(filter $(VL8_FST_MODE),0),,-DCY_FST_TRACE)

#----------------------------------------------------------------------------
# verilation configuration/optimization
#----------------------------------------------------------------------------
VMODE :=	-O3 --x-assign fast --x-initial fast --noassert \
					--output-split 10000 --output-split-cfuncs 10000

VERILATOR_NONCC_OPTS := \
	$(RUNTIME_PROFILING_VFLAGS) \
	$(RUNTIME_THREADS) \
	$(VMODE) \
	--top-module $(VLOG_MODEL) \
	+define+PRINTF_COND=\$$c\(\"verbose\",\"\&\&\"\,\"done_reset\"\) \
	+define+STOP_COND=\$$c\(\"done_reset\"\) \
	$(sim_vsrcs_printf) \
	-f $(sim_common_files)

#----------------------------------------------------------------------------
# gcc configuration/optimization
#----------------------------------------------------------------------------
CMODE := -O3 -fbranch-probabilities -flto -march=native

CXXFLAGS := $(CXXFLAGS) \
						$(RUNTIME_PROFILING_CFLAGS) \
						$(CMODE) \
						$(TRACING_CFLAGS) \
						-std=c++11 \
						-I$(RISCV)/include \
						-D__STDC_FORMAT_MACROS \
						-DTEST_HARNESS=V$(VLOG_MODEL) \
						-DVERILATOR \
						-I$(build_dir) \
						-include $(build_dir)/$(long_name).plusArgs \
						-include $(build_dir)/verilator.h

LDFLAGS	:=	$(LDFLAGS) \
						$(RUNTIME_PROFILING_CFLAGS) \
						$(CMODE) \
						-L$(RISCV)/lib \
						-Wl,-rpath,$(RISCV)/lib \
						-L$(sim_dir) \
						-lfesvr \
						-lpthread

VERILATOR_CC_OPTS := -CFLAGS "$(CXXFLAGS)" -LDFLAGS "$(LDFLAGS)"

#----------------------------------------------------------------------------
# full verilator+gcc opts
#----------------------------------------------------------------------------
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
	rm -rf $(model_dir)
	mkdir -p $(model_dir)
	# patched emulator.cc supports multithreaded HTIF
	if [ -f $(build_dir)/emulator.cc ]; then rm $(build_dir)/emulator.cc; fi
	cp $(patch_dir)/emulator.cc $(build_dir)/emulator.cc
	$(VERILATOR) $(VERILATOR_OPTS) -o $(sim) \
		-Mdir $(model_dir) -CFLAGS "-include $(model_header)"
	touch $@

$(model_mk_debug): $(sim_vsrcs_printf) $(sim_common_files) $(INSTALLED_VERILATOR)
	rm -rf $(model_dir_debug)
	mkdir -p $(model_dir_debug)
	# patched emulator.cc supports multithreaded HTIF
	if [ -f $(build_dir)/emulator.cc ]; then rm $(build_dir)/emulator.cc; fi
	cp $(patch_dir)/emulator.cc $(build_dir)/emulator.cc
	$(VERILATOR) $(VERILATOR_OPTS) -o $(sim_debug) $(TRACING_OPTS) \
		-Mdir $(model_dir_debug) -CFLAGS "-include $(model_header_debug)"
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
