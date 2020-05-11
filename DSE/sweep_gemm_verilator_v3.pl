#!/usr/bin/env perl

use strict;
use warnings;

my $GEMM_WORKLOAD_ID = 10;
my @hw_configs = (
  #  ["-hw_g1_dse5", "-orig_tiler"],
  #  ["-hw_g1_dse6", "-orig_tiler"],
  #  ["-hw_g1_dse7", "-orig_tiler"],
    ["-hw_g1_dse8", "-orig_tiler"],

  #  ["-hw_g1_dse5", "-fsm_tiler"],
  #  ["-hw_g1_dse6", "-fsm_tiler"],
  #  ["-hw_g1_dse7", "-fsm_tiler"],
    ["-hw_g1_dse8", "-fsm_tiler"],
 
  #  ["-hw_g2_dse1", "-hw_tiler"],
  #  ["-hw_g2_dse2", "-hw_tiler"], 
  #  ["-hw_g2_dse3", "-hw_tiler"],
  #  ["-hw_g2_dse4", "-hw_tiler"],
  #  ["-hw_g2_dse5", "-hw_tiler"],
  #  ["-hw_g2_dse6", "-hw_tiler"],
  #  ["-hw_g2_dse7", "-hw_tiler"],
    ["-hw_g2_dse8", "-hw_tiler"],

    ["-hw_fg_dse3", "-hw_tiler"],
  #  ["-hw_fg_dse6", "-hw_tiler"],
);
my @mnks = (
  [   2,    2,    2], 
  [   4,    4,    4], 
  [   8,    8,    8], 
  [  16,   16,   16], 
  [  32,   32,   32],
  [  64,   64,   64],
  [  96,   96,   96],
  [ 128,  128,  128],
  [ 192,  192,  192],
  [ 256,  256,  256],
  [ 320,  320,  320],
  [ 384,  384,  384],
  [ 448,  448,  448],
  [ 512,  512,  512],
  [ 576,  576,  576],
  [ 640,  640,  640],
  [ 704,  704,  704],
  [ 768,  768,  768],
  [ 832,  832,  832],
  [ 896,  896,  896],
  [ 960,  960,  960],
  [1024, 1024, 1024],
);
my $sizes = join(" ", (map {join(" ", @{$_})} @mnks));

my $status = 0;
foreach my $hw_config (@hw_configs) {
  my $cmd = "runsim_gemmini @{$hw_config} -verilator -pk ".
            #"-debug -noisy -args '-verify $sizes' $GEMM_WORKLOAD_ID 2>&1";
            #"-noisy -args '-zeros -verify $sizes' $GEMM_WORKLOAD_ID 2>&1";
            #"-noisy -args '-verify $sizes' $GEMM_WORKLOAD_ID 2>&1";
            "-debug -noisy -args '-zeros $sizes' $GEMM_WORKLOAD_ID 2>&1";
  $status = $status || system($cmd);
}

exit($status);
