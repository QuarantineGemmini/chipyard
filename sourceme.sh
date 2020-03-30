#!/bin/bash

DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
CURHOST="$(hostname -f | awk '{print tolower($0)}')"

# control which sockets and cores are used for multithreading on each host
export PATH="$PATH:$DIR/bin"
export NUMACTL="$(numa_prefix)"

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
  #export VCS_HOME="/tools/synopsys/vcs/N-2017.12-SP1-1"
  export VCS_HOME="/tools/synopsys/vcs/P-2019.06-SP1/vcs/P-2019.06-SP1"
  export DVE_HOME="/tools/synopsys/vcs/P-2019.06-SP1/gui/dve"
  export GENUS_HOME="/tools/cadence/GENUS/GENUS1813"
  export DC_HOME="/tools/synopsys/syn/P-2019.03-SP4"
  export PATH="$VCS_HOME/bin:$DVE_HOME/bin:$GENUS_HOME/bin:$DC_HOME/bin:$PATH"
elif [[ "$CURHOST" =~ ^.*\.us-.*-[0-9]+\.compute\.internal$ ]] ; then
  #---------------------------------------------------------------------------
  # firesim-manager
  #---------------------------------------------------------------------------
  # NOTE! install numactl and devtoolset-8 manually!
  source $DIR/env.sh
else
  #---------------------------------------------------------------------------
  # local-machine envs
  #---------------------------------------------------------------------------
  source $DIR/env.sh
fi

#source firesim if its available
if [ -f "$DIR/sims/firesim/sourceme-f1-manager.sh" ]; then
  cd "$DIR/sims/firesim"
  set +u
  source sourceme-f1-manager.sh
  cd "$DIR"
fi

# add convenience gemmini scripts
export PATH="$PATH:$DIR/generators/gemmini/software/sim_scripts"

