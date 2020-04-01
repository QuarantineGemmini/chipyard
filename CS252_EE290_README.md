-----------------------------------------------------------------------------
provisioning non-firesim node (0.5 hours)
=============================================================================
- initial checkout (5 minutes)
  - git-clone chipyard into ~/chipyard
  - git checkout top-level simulation/dev branch
  - ./scripts/init-submodules-no-init.sh

- build toolchains (30 minutes)
  - source sourceme.sh
  - ./scripts/build-toolchains esp-tools

- checkout branch (1 minutes)
  - source sourceme.sh
  - multi-git checkout <your-branch>

-----------------------------------------------------------------------------
provisioning firesim-manager (1.5 hours)
=============================================================================
- do aws-console administrative stuff (30 minutes)
  - follow https://docs.fires.im/en/latest/Initial-Setup/index.html
  - do everything up through section 2.3.1.1 "Access your instance"

- initial checkout (10 minutes)
  - scp firesim.pem
  - start a fresh terminal
  - install devtoolset-8 and numactl
  - git init/clone home-repo-configs, and update VimPlug, install sdkman
  - chmod go-rwx .ssh/*
  - git-clone chipyard into ~/chipyard
  - git checkout top-level simulation/dev branch
  - ./scripts/init-submodules-no-init.sh

- build toolchains (30 minutes)
  - start a fresh terminal
  - source sourceme.sh
  - ./scripts/build-toolchains esp-tools

- bootstrap firesim-infra (20 minutes) (do in parallel with build toolchains)
  - start a fresh terminal
  - DO NOT SOURCE sourceme.sh
  - ./scripts/firesim-setup.sh

- install firemarshall (10 minutes) (do in parallel with build toolchains)
  - start a fresh terminal
  - source sourceme.sh
  - cd ./sims/firesim/sw/firesim-software
  - ./init-submodules.sh (NOTE: make sure iceblk-driver and icenet-driver are populated!)

- checkout branch and configure aws (1 minutes)
  - start a fresh terminal
  - source sourceme.sh
  - firesim managerinit
  - multi-git checkout simulation/dev branch

-----------------------------------------------------------------------------
spike/verilator build and simulation (30 minutes)
=============================================================================
- build workloads for spike/verilator (1 minute)
  - source sourceme.sh
  - buildworkload_gemmini -noisy -force orig_tiler

- run workload on spike (1 minute)
  - source sourceme.sh
  - runsim_gemmini -bare -orig_tiler -spike -noisy 4
  - runsim_gemmini -pk -orig_tiler -spike -noisy 4

- build verilator-simulator (12 minutes)
  - source sourceme.sh
  - buildsim_gemmini -noisy -force -lab3 -vl8_threads 16 verilator 

- run workload on verilator-simulator (2 minutes)
  - source sourceme.sh
  - runsim_gemmini -bare -orig_tiler -verilator -noisy 4
  - runsim_gemmini -pk -orig_tiler -verilator -noisy 4

-----------------------------------------------------------------------------
firesim build and simulation (7 hours)
=============================================================================
- build firesim-simulator (6 hours at 90MHz, ?? hours at 60MHz)
  - source sourceme.sh
  - buildsim_gemmini -force -noisy firesim

- build workloads for firesim (20 minutes first time, 2 minutes after)
  - source sourceme.sh
  - buildworkload_gemmini -noisy -force -firesim orig_tiler

- run workload on firesim-simulator (15 minutes)
  - source sourceme.sh
  - runsim_gemmini -noisy -firesim lab3_orig_tiler

-----------------------------------------------------------------------------
Outstanding Bugs
=============================================================================
- spike sp_matrices and accum_rows might not match the gemmini_params.h
  for a given workload, which will cause orig_tiler and fsm_tiler to produce
  inaccurate results (or at least throw an invalid index exception

- repeating_bias isa insn is currently hacky, 
  maybe include it into the config_ex insn

- the reference implementation of cifar-10 is broken. when you enable 
  CHECK_RESULTS, they returned matrix is not what is expected!

## Resolved Issues
(DONE) - emulator.cc is broken but thats in rocket-chip, so doubt i'll get my 
  patch upstreamed

(DONE) - run everything on PK, and get rid of "baremetal" in workload names, 
  since they are really just tethered
  - if we really wanted baremetal (which we don't), then we should not use 
    TSI/DTM to load the elf and proxy write() syscalls...
  - gemmini is currently targeted only to run on linux, so use pk to exploit
    full file-system capabilities

(DONE) - verilator-binary install is serialized on bwrc despite -j40 in MAKEFLAGS?

(DONE) - verilator is super slow compared to vcs. need to debug why.

(DONE) - verilator multithreading support broken

(DONE) - ee290 only supports weight-stationary mode, so template fails on 
  verilator! also, its nefarious becuase no error is propagated back to the 
  user, and no $display() is printed for debugging

(DONE) - support arbitrary sized matrices in hardware. need to pull in the 
  patch that hasan made. we will need these when comparing our model against 
  the reference model

