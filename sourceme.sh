#!/bin/bash

DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
CURHOST="$(hostname -f | awk '{print tolower($0)}')"

if [ -n "$CHIPYARD_SOURCEME_SOURCED" ]; then return; fi
CHIPYARD_SOURCEME_SOURCED=1

#=============================================================================
# common setup
#=============================================================================

# add convenience repo and gemmini scripts
export PATH="$PATH:$DIR/bin"
export PATH="$PATH:$DIR/generators/gemmini/software/sim_scripts"

# control which sockets and cores are used for multithreading on each host
export NUMACTL="$(numa_prefix)"

#=============================================================================
# host-specific setup
#=============================================================================
__trysource() {
  local f="$1"
  local origpwd="$PWD"
  if [ -e "$f" ]; then 
    cd "$(dirname "$f")"
    source "$f"
    cd "$origpwd"
  else 
    echo "[INFO]: $f does not exist, not sourcing!"
  fi
}


if [[ "$CURHOST" =~ ^eda-.*.eecs.berkeley.edu$ ]] ; then
  #-----------------
  # cory eda-* envs
  #-----------------
  __trysource "/home/ff/ee290-2/chipyard-env.sh"
  __trysource "$DIR/sims/firesim/sourceme-f1-manager.sh"

  # for viewing rtl schematic in dc_shell
  export PATH="$PATH:/share/instsww/synopsys/J-2014.09-SP3/bin"

elif [[ "$CURHOST" =~ ^bwrc.*.eecs.berkeley.edu$ ]] ; then
  #-----------------
  # bwrc envs
  #-----------------
  __trysource "$DIR/env.sh"
  __trysource "$DIR/sims/firesim/sourceme-f1-manager.sh"

  source /tools/flexlm/flexlm.sh
  export VCS_HOME="/tools/synopsys/vcs/P-2019.06-SP1/vcs/P-2019.06-SP1"
  export DVE_HOME="/tools/synopsys/vcs/P-2019.06-SP1/gui/dve"
  export GENUS_HOME="/tools/cadence/GENUS/GENUS1813"
  export DC_HOME="/tools/synopsys/syn/P-2019.03-SP4"
  export PATH="$VCS_HOME/bin:$DVE_HOME/bin:$GENUS_HOME/bin:$DC_HOME/bin:$PATH"

elif [[ "$CURHOST" =~ ^.*\.us-.*-[0-9]+\.compute\.internal$ ]] ; then
  #-----------------
  # firesim-manager
  #-----------------
  __trysource "$DIR/env.sh"
  __trysource "/opt/rh/devtoolset-8/enable"
  __trysource "$DIR/sims/firesim/sourceme-f1-manager.sh"

else
  #-----------------
  # local-machine envs
  #-----------------
  __trysource "$DIR/env.sh"
  __trysource "$DIR/sims/firesim/sourceme-f1-manager.sh"
fi

