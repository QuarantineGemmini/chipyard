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
my @mnks1 = (
    256, 1,  1, 
    512, 1,  1, 
   1024, 1,  1, 
   2048, 1,  1, 
   4096, 1,  1, 
   8192, 1,  1, 
  16384, 1,  1, 
  32768, 1,  1, 
  65536, 1,  1, 
 131072, 1,  1, 

    256, 1,  4, 
    512, 1,  4, 
   1024, 1,  4, 
   2048, 1,  4, 
   4096, 1,  4, 
   8192, 1,  4, 
  16384, 1,  4, 
  32768, 1,  4, 
  65536, 1,  4, 
 131072, 1,  4, 

    256, 1, 32, 
    512, 1, 32, 
   1024, 1, 32, 
   2048, 1, 32, 
   4096, 1, 32, 
   8192, 1, 32, 
  16384, 1, 32, 
  32768, 1, 32, 
  65536, 1, 32, 
 131072, 1, 32, 

    256, 4,  4, 
    512, 4,  4, 
   1024, 4,  4, 
   2048, 4,  4, 
   4096, 4,  4, 
   8192, 4,  4, 
  16384, 4,  4, 
  32768, 4,  4, 
  65536, 4,  4, 
 131072, 4,  4, 
);

my @mnks2 = (
 1,     256, 1, 
 1,     512, 1, 
 1,    1024, 1, 
 1,    2048, 1, 
 1,    4096, 1, 
 1,    8192, 1, 
 1,   16384, 1, 
 1,   32768, 1, 
 1,   65536, 1, 
 1,  131072, 1, 
    
 1,     256, 4, 
 1,     512, 4, 
 1,    1024, 4, 
 1,    2048, 4, 
 1,    4096, 4, 
 1,    8192, 4, 
 1,   16384, 4, 
 1,   32768, 4, 
 1,   65536, 4, 
 1,  131072, 4, 
    
 1,    256, 32, 
 1,    512, 32, 
 1,   1024, 32, 
 1,   2048, 32, 
 1,   4096, 32, 
 1,   8192, 32, 
 1,  16384, 32, 
 1,  32768, 32, 
 1,  65536, 32, 
 1, 131072, 32, 

 4,     256, 4, 
 4,     512, 4, 
 4,    1024, 4, 
 4,    2048, 4, 
 4,    4096, 4, 
 4,    8192, 4, 
 4,   16384, 4, 
 4,   32768, 4, 
 4,   65536, 4, 
 4,  131072, 4,
);

my $sizes1 = join(" ", @mnks1);
my $sizes2 = join(" ", @mnks2);

my $status = 0;
foreach my $hw_config (@hw_configs) {
  foreach my $sizes ($sizes1, $sizes2) {
    my $cmd = "runsim_gemmini @{$hw_config} -verilator -pk ".
              #"-debug -noisy -args '-verify $sizes' $GEMM_WORKLOAD_ID 2>&1";
              #"-noisy -args '-zeros -verify $sizes' $GEMM_WORKLOAD_ID 2>&1";
              #"-noisy -args '-verify $sizes' $GEMM_WORKLOAD_ID 2>&1";
              "-noisy -args '-zeros $sizes' $GEMM_WORKLOAD_ID 2>&1";
    $status = $status || system($cmd);
  }
}

exit($status);
