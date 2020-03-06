#!/bin/bash

# TODO:!!!!! don't let the buildsim_gemmini* scripts source this sourceme...

DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
CURHOST="$(hostname -f | awk '{print tolower($0)}')"

if [[ "$CURHOST" =~ ^eda-.*.eecs.berkeley.edu$ ]] ; then
  #---------------------------------------------------------------------------
  # cory eda-* machines
  #---------------------------------------------------------------------------
  source /home/ff/ee290-2/chipyard-env.sh

  # for viewing rtl schematic in dc_shell
  export PATH="$PATH:/share/instsww/synopsys/J-2014.09-SP3/bin"

  # use for debug-spike builds
  #source /home/ff/ee290-2/chipyard-debug-env.sh
else
  #---------------------------------------------------------------------------
  # local-machine builds
  #---------------------------------------------------------------------------
  source $DIR/env.sh
fi

# add convenience gemmini scripts
export PATH="$PATH:$DIR/generators/gemmini/software/sim_scripts"

for d in "$DIR" "$DIR/generators/gemmini" \
    "$DIR/generators/gemmini/software/gemmini-rocc-tests"; do
  cd $d
  git checkout cs252_ee290_project
done
cd "$DIR"

