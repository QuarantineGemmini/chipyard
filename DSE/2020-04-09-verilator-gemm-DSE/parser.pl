#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($RealBin);

# input/output sizes
my $ITYPE_BYTES = 1;
my $OTYPE_BYTES = 4;

# 64-bit wide SystemBus
my $CPU1_SW_CONFIG = "hw_tiler";
my $CPU1_HW_CONFIG = "hw_g2_dse1";

# 128-bit wide SystemBus
my $CPU2_SW_CONFIG = "hw_tiler";
my $CPU2_HW_CONFIG = "hw_g2_dse5";

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
  my ($m, $n, $k);
  while(defined(my $line = shift(@lines))) {
    if($line =~ /^SUMMARY FOR MNK: (\d+) (\d+) (\d+)$/) {
      ($m, $n, $k) = ($1, $2, $3);
    } 
    elsif($line =~ /^gemmini:\s*(\d+)\s/) {
      my $cycles = $1;
      push(@data, [$hwconfig, $swconfig, $m, $n, $k, $cycles]);
    }
    elsif($line =~ /^cpu:\s*(\d+)\s/) {
      my $cycles = $1;
      if(($hwconfig eq $CPU1_HW_CONFIG) && ($swconfig eq $CPU1_SW_CONFIG)) {
        push(@data, ["cpu1", "cpu", $m, $n, $k, $cycles]);
      }
      elsif(($hwconfig eq $CPU2_HW_CONFIG) && ($swconfig eq $CPU2_SW_CONFIG)) {
        push(@data, ["cpu2", "cpu", $m, $n, $k, $cycles]);
      }
    }
  }
}

@data = sort { ($a->[0] cmp $b->[0]) ||
               ($a->[1] cmp $b->[1]) ||
               ($a->[2] <=> $b->[2]) ||
               ($a->[3] <=> $b->[3]) ||
               ($a->[4] <=> $b->[4]) } @data;

open(my $OFH, "> $outputfile") || die("open $outputfile: $!\n");
$OFH->print(join("\t", qw(hwconfig swconfig m n k bias mn-ratio ops 
                          bytes op/byte cycles op/cycle))."\n");
foreach my $line (@data) {
  my ($hwconfig, $swconfig, $m, $n, $k, $cycles) = @{$line};
  my $bias = "yes";
  my $mn_ratio = sprintf("%.3f", $m/$n);
  my $ops = $m*$n*$k;
  my $bytes = $m*$n*$OTYPE_BYTES + ($m*$k + $k*$n)*$ITYPE_BYTES;
  my $op_per_byte = sprintf("%.3f", $ops/$bytes);
  my $op_per_cycle = sprintf("%.2f", $ops/$cycles);
  $OFH->print(join("\t", $hwconfig, $swconfig, $m, $n, $k, $bias, $mn_ratio,
                   $ops, $bytes, $op_per_byte, $cycles, $op_per_cycle)."\n");
}
close($OFH) || die("close $outputfile: $!\n");

printf("finished generating $outputfile!\n");
