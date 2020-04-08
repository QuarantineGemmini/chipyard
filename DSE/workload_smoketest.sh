#!/bin/bash
#============================================================================
# Description: sanity test that all 3 software workload configurations run
#              correctly on spike models. This will minimize time spent
#              debugging hardware when software was the real issue
#============================================================================
set -euo pipefail

#============================================================================
# template
#============================================================================
runsim_gemmini -spike -hw_lab3 -bare -orig_tiler 3
runsim_gemmini -spike -hw_lab3 -bare -fsm_tiler  3
runsim_gemmini -spike -hw_g2   -bare -hw_tiler   3

runsim_gemmini -spike -hw_lab3 -pk -orig_tiler 3
runsim_gemmini -spike -hw_lab3 -pk -fsm_tiler  3
runsim_gemmini -spike -hw_g2   -pk -hw_tiler   3

#============================================================================
# large_matmul
#============================================================================
runsim_gemmini -spike -hw_lab3 -bare -orig_tiler 4
runsim_gemmini -spike -hw_lab3 -bare -fsm_tiler  4
runsim_gemmini -spike -hw_g2   -bare -hw_tiler   4

runsim_gemmini -spike -hw_lab3 -pk -orig_tiler 4
runsim_gemmini -spike -hw_lab3 -pk -fsm_tiler  4
runsim_gemmini -spike -hw_g2   -pk -hw_tiler   4

#============================================================================
# cifar_quant
#============================================================================
runsim_gemmini -spike -hw_lab3 -bare -orig_tiler 7
runsim_gemmini -spike -hw_lab3 -bare -fsm_tiler  7
runsim_gemmini -spike -hw_g2   -bare -hw_tiler   7

runsim_gemmini -spike -hw_lab3 -pk -orig_tiler 7
runsim_gemmini -spike -hw_lab3 -pk -fsm_tiler  7
runsim_gemmini -spike -hw_g2   -pk -hw_tiler   7

#============================================================================
# gemm (various configs)
#============================================================================
runsim_gemmini -spike -hw_lab3 -pk -orig_tiler -args "1 1 1 -verify" 10
runsim_gemmini -spike -hw_lab3 -pk -fsm_tiler  -args "1 1 1 -verify" 10
runsim_gemmini -spike -hw_g2   -pk -hw_tiler   -args "1 1 1 -verify" 10

runsim_gemmini -spike -hw_lab3 -pk -orig_tiler -args "100 1 1 -verify" 10
runsim_gemmini -spike -hw_lab3 -pk -fsm_tiler  -args "100 1 1 -verify" 10
runsim_gemmini -spike -hw_g2   -pk -hw_tiler   -args "100 1 1 -verify" 10

runsim_gemmini -spike -hw_lab3 -pk -orig_tiler -args "1 100 1 -verify" 10
runsim_gemmini -spike -hw_lab3 -pk -fsm_tiler  -args "1 100 1 -verify" 10
runsim_gemmini -spike -hw_g2   -pk -hw_tiler   -args "1 100 1 -verify" 10

runsim_gemmini -spike -hw_lab3 -pk -orig_tiler -args "1 1 100 -verify" 10
runsim_gemmini -spike -hw_lab3 -pk -fsm_tiler  -args "1 1 100 -verify" 10
runsim_gemmini -spike -hw_g2   -pk -hw_tiler   -args "1 1 100 -verify" 10

runsim_gemmini -spike -hw_lab3 -pk -orig_tiler -args "63 55 29 -verify" 10
runsim_gemmini -spike -hw_lab3 -pk -fsm_tiler  -args "63 55 29 -verify" 10
runsim_gemmini -spike -hw_g2   -pk -hw_tiler   -args "63 55 29 -verify" 10

#============================================================================
# success
#============================================================================
echo "ALL SPIKE TESTS PASSED!"
