-----------------------------------------------------------------------------
How to install a new checkout
=============================================================================

    git checkout git@github.com:ssteffl/ee290hw4ml-lab3-chipyard.git chipyard
    cd chipyard
    ./scripts/init-submodules-no-riscv-tools.sh
    source sourceme.sh

-----------------------------------------------------------------------------
How to install the riscv toolchain and spike simulator locally
=============================================================================
You must have installed the new checkout already.

    source sourceme.sh
    ./script/build-toolchains.sh esp-tools

-----------------------------------------------------------------------------
How to set up a new shell environment
=============================================================================
Run this in any new bash shell. you must have installed the new checkout.
NOTE: this will check out the `cs252_ee290_project` branch on multiple
git submodules so any changes you make won't be to a detached head!

    cd chipyard
    source sourceme.sh

-----------------------------------------------------------------------------
How to build the software workloads
=============================================================================
This is how to build the workloads for the original software-tiler and the
original gemmini isa:

    buildworkload_gemmini -orig_tiler bare

This is how to build the workloads for the new fsm software-tiler and the
original gemmini isa:

    buildworkload_gemmini -fsm_tiler bare

This is how to build the workloads for the new hardware tiler-fsm, and the
new gemmini isa:

    buildworkload_gemmini -new_tiler bare

Each of the above workloads will be placed in different output directories, so
they won't overwrite each other. __But you still must rebuild all of them if you
change any hardware parameters!__.

-----------------------------------------------------------------------------
How to run the workloads on spike
=============================================================================
You have to specify which type of workload you will run. The workload type
must match what you previously passed to `buildworkload_gemmini`. The following
run the workload with id "2" using each of the workload configurations.

    runsim_gemmini -bare -orig_tiler -spike 2
    runsim_gemmini -bare -fsm_tiler -spike 2
    runsim_gemmini -bare -hw_tiler -spike 2

-----------------------------------------------------------------------------
How to rebuild the spike simulator from C++
=============================================================================
You must have installed the new checkout already, and installed the 
riscv-toolchain. You will run this if you modify spike.

    source sourceme.sh
    ./script/build-isa-sim.sh esp-tools

-----------------------------------------------------------------------------
How to rebuild the verilator simulator from Chisel
=============================================================================
TODO

-----------------------------------------------------------------------------
How to rebuild the vcs simulator from Chisel
=============================================================================
TODO

-----------------------------------------------------------------------------
How to rebuild the Firesim simulator from Chisel
=============================================================================
TODO

-----------------------------------------------------------------------------
How to build the vcs simulator
=============================================================================
Instructions to run spike on the eda-* machines in cory, if you have access:
git checkout git@github.com:ssteffl/ee290hw4ml-lab3-chipyard.git chipyard
cd chipyard
source sourceme.sh
buildworkload_gemmini -fsm_tiler bare
runsim_gemmini -bare -spike -lab3 2
ls sims/spike/logs/

I wrote the support scripts buildsim_gemmini, buildworkload_gemmini, and runsim_gemmini to optimize our workflow. check them out to see how to run different workloads, with different gemmini configs, on different simulators. 

If your on the eda-* machines, try running vcs after you get spike working (you need to rebuild the workload after rebuilding a simulator, unfortunately... we need to fix this later):
cd chipyard
source sourceme.sh
buildsim_gemmini -vcs lab3
buildworkload_gemmini -fsm_tiler bare
runsim_gemmini -bare -vcs -lab3 2
ls sims/vcs/logs/

-----------------------------------------------------------------------------
Bugs
=============================================================================
- emulator.cc is broken but thats in rocket-chip, so doubt i'll get my 
  patch upstreamed

- run everything on PK, and get rid of "baremetal" in workload names, since
  they are really just tethered
  - if we really wanted baremetal (which we don't), then we should not use 
    TSI/DTM to load the elf and proxy write() syscalls...
  - gemmini is currently targeted only to run on linux, so use pk to exploit
    full file-system capabilities

- verilator-binary install is serialized on bwrc despite -j40 in MAKEFLAGS?

- verilator is super slow compared to vcs. need to debug why.

- verilator multithreading support broken

- ee290 only supports weight-stationary mode, so template fails on verilator!
  also, its nefarious becuase no error is propagated back to the user, and 
  no $display() is printed for debugging

- spike sp_matrices and accum_rows might not match the gemmini_params.h
  for a given workload, which will cause orig_tiler and fsm_tiler to produce
  inaccurate results (or at least throw an invalid index exception

- repeating_bias isa insn is currently hacky, 
  maybe include it into the config_ex insn

- support arbitrary sized matrices in hardware. need to pull in the patch that
  hasan made. we will need these when comparing our model against the reference
  model

- the reference implementation of cifar-10 is broken. when you enable 
  CHECK_RESULTS, they returned matrix is not what is expected!

- the depthwise-convoluation and im2col are awful (spike mobilenet output for hw_tiler):

    Total cycles: 2214909281
    Matmul cycles: 4399
    Im2col cycles: 20741195
    Pooling cycles: 0
    Depthwise convolution cycles: 2162886994
    Other cycles: 1479722
    PASS

