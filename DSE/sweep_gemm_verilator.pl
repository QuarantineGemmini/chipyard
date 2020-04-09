#!/usr/bin/env perl

use strict;
use warnings;

my $GEMM_WORKLOAD_ID = 10;
my @hw_configs = (
  ["-hw_g2_dse1", "-hw_tiler"],
  ["-hw_g2_dse2", "-hw_tiler"], 
  ["-hw_g2_dse3", "-hw_tiler"],
  ["-hw_g2_dse4", "-hw_tiler"],
  ["-hw_g2_dse5", "-hw_tiler"],
  ["-hw_g2_dse6", "-hw_tiler"],
  ["-hw_g2_dse7", "-hw_tiler"],
  ["-hw_g2_dse8", "-hw_tiler"],
);
my @mnks = (
  [1024,   1,  1],    # GEMV
  [1024,   1,  4],    # GEMV
  [1024,   1, 16],    # GEMV
  [1024,   1, 64],    # GEMV
  [1024,   1,256],    # GEMV
  [ 256,   4,  1],    # tall/skinny
  [ 256,   4,  4],    # tall/skinny
  [ 256,   4, 16],    # tall/skinny
  [ 256,   4, 64],    # tall/skinny
  [ 256,   4,256],    # tall/skinny
  [  64,  16,  1],    # tallish 
  [  64,  16,  4],    # tallish
  [  64,  16, 16],    # tallish
  [  64,  16, 64],    # tallish
  [  64,  16,256],    # tallish
  [  32,  32,  1],    # square 
  [  32,  32,  4],    # square
  [  32,  32, 16],    # square
  [  32,  32, 64],    # square
  [  32,  32,256],    # square
  [  16,  64,  1],    # widish 
  [  16,  64,  4],    # widish
  [  16,  64, 16],    # widish
  [  16,  64, 64],    # widish
  [  16,  64,256],    # widish
  [   4, 256,  1],    # short/wide
  [   4, 256,  4],    # short/wide 
  [   4, 256, 16],    # short/wide
  [   4, 256, 64],    # short/wide
  [   4, 256,256],    # short/wide
  [   1,1024,  1],    # GEMV 
  [   1,1024,  4],    # GEMV
  [   1,1024, 16],    # GEMV
  [   1,1024, 64],    # GEMV
  [   1,1024,256],    # GEMV
);

my $failed = 0;
sub runsweepfunc {
  my ($func) = @_;
  foreach my $hw_config (@hw_configs) {
    foreach my $mnk (@mnks) {
      my ($m, $n, $k) = @{$mnk};
      $func->($hw_config, $m, $n, $k);
    }
  }
}

runsweepfunc(sub {
  my ($hw_config, $m, $n, $k) = @_;
  my $cmd = "runsim_gemmini @{$hw_config} -verilator -pk ".
            "-noisy -args '$m $n $k -verify' $GEMM_WORKLOAD_ID 2>&1";
  print("starting: $cmd .............. ");
  my @output = `$cmd`;
  my $status = ${^CHILD_ERROR_NATIVE};
  if($status != 0) {
    $failed = 1;
    printf("CMD FAILED: $cmd\n");
  } else {
    my $cpu_line     = (grep {s/^cpu:\s*(\d+)\s*.*$/$1/} @output)[0];
    my $gemmini_line = (grep {s/^gemmini:\s*(\d+)\s*.*$/$1/} @output)[0];
    chomp($cpu_line);
    chomp($gemmini_line);
    printf("mnk: $m $n $k cpu: $cpu_line gemmini: $gemmini_line\n");
  }
});

exit($failed);
