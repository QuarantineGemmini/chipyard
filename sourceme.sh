#!/bin/bash

DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
CURHOST="$(hostname -f | awk '{print tolower($0)}')"

# control which sockets and cores are used for multithreading on each host
export NUMACTL=""

# pull the multi-git into path
export PATH="$PATH:$DIR"

if [[ "$CURHOST" =~ ^eda-.*.eecs.berkeley.edu$ ]] ; then
  #---------------------------------------------------------------------------
  # cory eda-* envs
  #---------------------------------------------------------------------------
  source /home/ff/ee290-2/chipyard-env.sh

  # for viewing rtl schematic in dc_shell
  export PATH="$PATH:/share/instsww/synopsys/J-2014.09-SP3/bin"

  # use for debug-spike builds
  #source /home/ff/ee290-2/chipyard-debug-env.sh
elif [[ "$CURHOST" =~ ^bwrc.*.eecs.berkeley.edu$ ]] ; then
  #---------------------------------------------------------------------------
  # bwrc envs
  #---------------------------------------------------------------------------
  source $DIR/env.sh

  source /tools/flexlm/flexlm.sh
  export VCS_HOME="/tools/synopsys/vcs/N-2017.12-SP1-1"
  export GENUS_HOME="/tools/cadence/GENUS/GENUS1813"
  export DC_HOME="/tools/synopsys/syn/P-2019.03-SP4"
  export PATH="$PATH:$VCS_HOME/bin:$GENUS_HOME/bin:$DC_HOME/bin"

  if [ "$(hostname)" == "bwrcrdsl-1.eecs.berkeley.edu" ] ; then
    export NUMACTL="numactl -m 0 -C 0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38 --"
  fi
else
  #---------------------------------------------------------------------------
  # local-machine envs
  #---------------------------------------------------------------------------
  source $DIR/env.sh
fi

# add convenience gemmini scripts
export PATH="$PATH:$DIR/generators/gemmini/software/sim_scripts"

for d in "$DIR" "$DIR/generators/gemmini" \
    "$DIR/toolchains/esp-tools/riscv-isa-sim" \
    "$DIR/generators/gemmini/software/gemmini-rocc-tests"; do
  #cd $d
  #git checkout cs252_ee290_project
  true;
done
cd "$DIR"

