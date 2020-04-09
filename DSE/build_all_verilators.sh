#!/bin/bash

FORCE=
#FORCE=-force 

buildsim_gemmini $FORCE -noisy -vl8_threads $MYCORES \
  -hw_g1_dse1 verilator \
  -hw_g1_dse2 verilator \
  -hw_g1_dse3 verilator \
  -hw_g1_dse4 verilator \
  -hw_g1_dse5 verilator \
  -hw_g1_dse6 verilator \
  -hw_g1_dse7 verilator \
  -hw_g1_dse8 verilator \

#buildsim_gemmini $FORCE -noisy -vl8_threads $MYCORES \
#  -hw_g2_dse1 verilator \
#  -hw_g2_dse2 verilator \
#  -hw_g2_dse3 verilator \
#  -hw_g2_dse4 verilator \
#  -hw_g2_dse5 verilator \
#  -hw_g2_dse6 verilator \
#  -hw_g2_dse7 verilator \
#  -hw_g2_dse8 verilator \
