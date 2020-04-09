#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($RealBin);

my $CPU_SW_CONFIG = "fsm_tiler";
my $CPU_HW_CONFIG = "hw_g1_dse5";

my @data = ();
my $outputfile = "$RealBin/results.csv";

foreach my $file (glob("$RealBin/*.log")) {
  my ($swconfig, $hwconfig);
  if($file =~ /\/[\d\-_]+pk__(\S+_tiler)__(\S+)__gemm-pk.log$/) {
    ($swconfig, $hwconfig) = ($1, $2);
  } else {
    die("could not parse filename: $file\n");
  }

  my @lines = map {chomp; $_} `cat $file`;
  my ($m, $n, $k, $cpu, $gemmini);
  while(defined(my $line = shift(@lines))) {
    if($line =~ /^SUMMARY FOR MNK: (\d+) (\d+) (\d+)$/) {
      ($m, $n, $k) = ($1, $2, $3);
      $cpu = undef;
      $gemmini = undef;
    } 
    elsif($line =~ /^gemmini:\s*(\d+)\s/) {
      $gemmini = $1;
      push(@data, [$hwconfig, $swconfig, $m, $n, $k, $gemmini]);
    }
    elsif($line =~ /^cpu:\s*(\d+)\s/) {
      if(($hwconfig eq $CPU_HW_CONFIG) && ($swconfig eq $CPU_SW_CONFIG)) {
        
      }
      $cpu = $1;
    }
  }
}

@data = sort { ($a->[0] cmp $b->[0]) ||
               ($a->[1] cmp $b->[1]) ||
               ($a->[2] <=> $b->[2]) ||
               ($a->[3] <=> $b->[3]) ||
               ($a->[4] <=> $b->[4]) } @data;

open(my $OFH, "> $outputfile") || die("open $outputfile: $!\n");
$OFH->print(join("\t", qw(swconfig hwconfig m n k cpu gemmini))."\n");
foreach my $line (@data) {
  $OFH->print(join("\t", @{$line})."\n");
}
close($OFH) || die("close $outputfile: $!\n");
