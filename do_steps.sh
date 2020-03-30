#!/bin/bash
#===========================================================================
# NOTE: ssh <ip-addr> then `screen -r fsim0` to view results live
# - use `ctrl-a ctrl-d` to exist screen
#===========================================================================

set -euo pipefail

#===========================================================================
# configuration
#===========================================================================
DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
CYDIR="${DIR}"
GEMMINI_SW_DIR="${CYDIR}/generators/gemmini/software"

# user-modifiable
DO_BUILD_AGFI=0
DO_BUILD_WORKLOADS=1
DO_MANAGER_INIT=0
DO_LAUNCH_RUNFARM=1
DO_SEND_CONFIGS_TO_RUNFARM=1
DO_RUN_WORKLOAD=1

BUILD_CONFIG="${GEMMINI_SW_DIR}/firesim-configs/config_build.ini"
RECIPES_CONFIG="${GEMMINI_SW_DIR}/firesim-configs/config_build_recipes.ini"
HWDB_CONFIG="${GEMMINI_SW_DIR}/firesim-configs/config_hwdb.ini"
RUNTIME_CONFIG="${GEMMINI_SW_DIR}/firesim-configs/config_runtime_ee290.ini"

WORKLOAD=fsm_tiler

#  :%!sed 's/\x1b\[[0-9;]*m//g; s/\x1b\[K//g'

#===========================================================================
# helpers
#===========================================================================

banner() {
cat <<EOF
#============================================================================
# $@
#============================================================================
EOF
}

#===========================================================================
# tasks
#===========================================================================

banner "setup chipyard environment"
cd "${CYDIR}"
source sourceme.sh

banner "setup firesim environment"
cd "${CYDIR}/sims/firesim"
set +u
source sourceme-f1-manager.sh
set -u

if [ $DO_BUILD_AGFI -eq 1 ] ; then
  banner "build the afi"
  cd "${CYDIR}/sims/firesim"
  firesim buildafi -b "$BUILD_CONFIG" -r "$RECIPES_CONFIG"
fi

if [ $DO_BUILD_WORKLOADS -eq 1 ] ; then
  banner "build the workloads"
  cd "$GEMMINI_SW_DIR"
  ./build-ee290-firesim-workload.sh $WORKLOAD
fi

if [ $DO_MANAGER_INIT -eq 1 ] ; then
  banner "doing manager-init"
  firesim managerinit
fi

if [ $DO_LAUNCH_RUNFARM -eq 1 ] ; then
  banner "launch run-farm"
  firesim launchrunfarm -c "$RUNTIME_CONFIG" -a "$HWDB_CONFIG"
fi

if [ $DO_SEND_CONFIGS_TO_RUNFARM -eq 1 ]; then
  banner "send configuration to run-farm"
  firesim infrasetup -c "$RUNTIME_CONFIG" -a "$HWDB_CONFIG"
fi

if [ $DO_RUN_WORKLOAD -eq 1 ]; then
  banner "run workloads on farm"
  firesim runworkload -c "$RUNTIME_CONFIG" -a "$HWDB_CONFIG" 
fi
