- emulator.cc
  - this contains code to enable multithreaded verilator. the original 
    emulator.cc doesn't support multithreaded HTIF
  - the verilator Makefile copies this into generated-src every build
- verilated_threads.h
  - this contains non-yielding multithreaded verilator code
  - i found it runs faster than code that yields when its not busy
  - the buildsim_gemmini -verilator has a -vl8_cpu_hog that will copy this
    to the verilator install directory before running a build. if you don't
    specify the -vl8_cpu_hog, then the original src verilated_threads.h is
    copied to the install dir to revert any previous changes.
