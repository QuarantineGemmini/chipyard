#============================================================================
# general path variables
#============================================================================
base_dir=$(abspath ../..)
sim_dir=$(abspath .)

#============================================================================
# include shared variables
#============================================================================
include $(base_dir)/variables.mk

#============================================================================
# name of simulator (used to generate *.f arguments file)
#============================================================================
sim_name = vcs

#============================================================================
# vcs simulator types and rules
#============================================================================
sim_prefix = simv
sim = $(sim_dir)/$(sim_prefix)-$(MODEL_PACKAGE)-$(CONFIG)
sim_debug = $(sim_dir)/$(sim_prefix)-$(MODEL_PACKAGE)-$(CONFIG)-debug

PERMISSIVE_ON=+permissive
PERMISSIVE_OFF=+permissive-off

WAVEFORM_FLAG=+vcdplusfile=$(sim_out_name).vpd

.PHONY: default debug
default: $(sim)
debug: $(sim_debug)

#============================================================================
# import other necessary rules and variables
#============================================================================
include $(base_dir)/common.mk

#============================================================================
# selectively enabling printfs
#============================================================================
ENABLE_PRINTF_PATTERN ?=
sim_vsrcs_printf := $(sim_vsrcs:.v=.printf.v)

#============================================================================
# vcs/cxx binary and arguments
#============================================================================
VCS := vcs -full64

#----------------------------------------------------------------------------
# user configs
#----------------------------------------------------------------------------
VCS_THREADS ?= 1

VCS_PROFILE ?= 0
RUNTIME_PROFILING_VMODE := $(if $(filter $(VCS_PROFILE),1),-design_stats,)
RUNTIME_PROFILING_CMODE := $(if $(filter $(VCS_PROFILE),1),-g -pg,)

#----------------------------------------------------------------------------
# verilog translation options
#----------------------------------------------------------------------------
VMODE :=  -j$(VCS_THREADS) -hsopt=j$(VCS_THREADS) \
					-O4 +rad -fgp \
					-sverilog \
					+vcs+lic+wait \
					+vc+list \
					+lint=all,noVCDE,noONGS,noUI \
					-error=PCWM-L \
					-q \

VCS_NONCC_OPTS := \
	$(RUNTIME_PROFILING_VMODE) \
	$(VMODE) \
	-timescale=1ns/10ps \
	-f $(sim_common_files) \
	+incdir+$(build_dir) \
	+define+CLOCK_PERIOD=1.0 \
	+define+PRINTF_COND=$(TB).printf_cond \
	+define+STOP_COND=!$(TB).reset \
	+define+RANDOMIZE_MEM_INIT \
	+define+RANDOMIZE_REG_INIT \
	+define+RANDOMIZE_GARBAGE_ASSIGN \
	+define+RANDOMIZE_INVALID_ASSIGN \
	+libext+.v \
	$(sim_vsrcs_printf) \

#----------------------------------------------------------------------------
# gcc compilation options
#----------------------------------------------------------------------------
CMODE := -O3 -fbranch-probabilities -flto -march=native

CXXFLAGS ?=
VCS_CXXFLAGS := \
	$(CXXFLAGS) \
	$(RUNTIME_PROFILING_CMODE) \
	$(CMODE) \
	-std=c++11 \
	-I$(VCS_HOME)/include \
	-I$(RISCV)/include

LDFLAGS ?=
VCS_LDFLAGS :=	\
	$(LDFLAGS) \
	$(RUNTIME_PROFILING_CMODE) \
	$(CMODE)

EXPLICIT_LIBS := $(RISCV)/lib/libfesvr.a

VCS_CC_OPTS := -CFLAGS "$(VCS_CXXFLAGS)" \
							 -LDFLAGS "$(VCS_LDFLAGS)" \
							 $(EXPLICIT_LIBS)

#----------------------------------------------------------------------------
# full vcs+gcc opts
#----------------------------------------------------------------------------
VCS_OPTS = $(VCS_CC_OPTS) $(VCS_NONCC_OPTS)

#============================================================================
# selectively enable verbose logging
#============================================================================
# see GNU Make static patterns
$(sim_vsrcs_printf) : %.printf.v : %.v
	$(base_dir)/bin/enable_printfs $< $@ "$(ENABLE_PRINTF_PATTERN)"

#============================================================================
# vcs simulator rules
#============================================================================
$(sim): $(sim_vsrcs_printf) $(sim_common_files)
	rm -rf csrc
	$(VCS) $(VCS_OPTS) -o $@

$(sim_debug) : $(sim_vsrcs_printf) $(sim_common_files)
	rm -rf csrc
	$(VCS) $(VCS_OPTS) -o $@ +define+DEBUG +memcbk -debug_access

#============================================================================
# general cleanup rule
#============================================================================
.PHONY: clean
clean:
	rm -rf csrc $(sim_prefix)-* ucli.key vc_hdrs.h
