#!/usr/bin/env bash

set -euo pipefail

DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
CHIPYARD_DIR="$(dirname "$DIR")"

#-----------------------------------------------------------------------------
# utilities
#-----------------------------------------------------------------------------
usage() {
    echo "usage: ${0} [OPTIONS] [riscv-tools | esp-tools]"
    echo ""
    echo "Installation Types"
    echo "   riscv-tools: builds the riscv-tools' spike (this is also the default)"
    echo "   esp-tools: builds esp-tools' spike (with hwacha and gemmini)"
    echo ""
    echo "Options"
    echo "   --prefix PREFIX : Install destination. If unset, defaults to $(pwd)/riscv-tools-install"
    echo "                     or $(pwd)/esp-tools-install"
    echo "   --help -h       : Display this message"
    exit "$1"
}

error() {
    echo "${0##*/}: ${1}" >&2
}
die() {
    error "$1"
    exit "${2:--1}"
}

#-----------------------------------------------------------------------------
# defaults
#-----------------------------------------------------------------------------
export TOOLCHAIN="riscv-tools"
export RISCV=""

#-----------------------------------------------------------------------------
# parse args
#-----------------------------------------------------------------------------
while [ "$#" -ne "0" ]; do
  case $1 in
    -h | --help | help )
      usage 3 ;;
    -p | --prefix )
      shift
      export RISCV=$(realpath $1) ;;
    riscv-tools | esp-tools)
      export TOOLCHAIN=$1 ;;
    * )
      error "invalid option $1"
      usage 1 ;;
  esac
  shift
done

if [ -z "$RISCV" ] ; then
  INSTALL_DIR="$TOOLCHAIN-install"
  RISCV="$CHIPYARD_DIR/$INSTALL_DIR"
fi

#-----------------------------------------------------------------------------
# install spike, fesvr, and pk
#-----------------------------------------------------------------------------
echo "Installing toolchain to $RISCV"
cd "${CHIPYARD_DIR}"

SRCDIR="$(pwd)/toolchains/${TOOLCHAIN}"
[ -d "${SRCDIR}" ] || die "unsupported toolchain: ${TOOLCHAIN}"
source "${DIR}/build-util.sh"

echo '==>  Installing spike and libfesvr'
module_all riscv-isa-sim --prefix="${RISCV}"

# create specific env.sh
cat > env-$TOOLCHAIN.sh <<EOF
export CHIPYARD_TOOLCHAIN_SOURCED=1
export RISCV=$(printf '%q' "$RISCV")
export PATH=\${RISCV}/bin:\${PATH}
export LD_LIBRARY_PATH=\${RISCV}/lib\${LD_LIBRARY_PATH:+":\${LD_LIBRARY_PATH}"}
EOF

# create general env.sh
ln -sf env-$TOOLCHAIN.sh env.sh
echo "isa-sim Build Complete!"
