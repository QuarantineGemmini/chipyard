#!/usr/bin/env bash

# Sets up FireSim for use as a library within REBAR

set -e
set -o pipefail

DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
CHIPYARD_DIR="$(dirname "$DIR")"

cd "${CHIPYARD_DIR}"

# Reenable the FireSim submodule
git config --unset submodule.sims/firesim.update || true
git submodule update --init sims/firesim
cd sims/firesim
./build-setup.sh "$@" --library
