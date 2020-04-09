#!/usr/bin/env perl

use strict;
use warnings;

my $PARSE_FILE

my $GEMM_WORKLOAD_ID = 10;
my @hw_configs = (
  ["-hw_tiler", "-hw_g2_dse8"]
);
my @mn_aspect_ratios = ([16,1],[4,1],[1,1],[1,4],[1,16]);
my @mn_scaling = (1, 8, 64);
my @k_scaling = (1, 8, 64);

my $failed = 0;

sub runsweepfunc {
  my ($func) = @_
  foreach my $hw_config (@hw_configs) {
    foreach my $mn_aspect_ratio (@mn_aspect_ratios) {
      my ($m, $n) = @{$mn_aspect_ratio};
      foreach my $mn_factor (@mn_scaling) {
        my ($m, $n) = ($m*$mn_factor, $n*$mn_factor);
        foreach my $k (@k_scaling) {
          $func->($hw_config, $m, $n, $k);
        }
      }
    }
  }
}

open(my $OFH
runsweepfunc(sub {
        my $cmd = "runsim_gemmini @{$hw_config} -verilator -pk ".
                  "-noisy -args '$m $n $k -verify' $GEMM_WORKLOAD_ID";
        my $output = `$cmd`;
        my $status = ${^CHILD_ERROR_NATIVE};
        if($status != 0) {
          $failed = 1;
          printf("CMD FAILED: $cmd\n");
        } else {
          $output
        }
      }
    }
  }
}

exit($failed);
