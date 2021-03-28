#!/usr/bin/env bash

export LC_ALL=C
TOPDIR=${TOPDIR:-$(git rev-parse --show-toplevel)}
BUILDDIR=${BUILDDIR:-$TOPDIR}

BINDIR=${BINDIR:-$BUILDDIR/src}
MANDIR=${MANDIR:-$TOPDIR/doc/man}

DANECOIND=${DANECOIND:-$BINDIR/danecoind}
DANECOINCLI=${DANECOINCLI:-$BINDIR/danecoin-cli}
DANECOINTX=${DANECOINTX:-$BINDIR/danecoin-tx}
DANECOINQT=${DANECOINQT:-$BINDIR/qt/danecoin-qt}

[ ! -x $DANECOIND ] && echo "$DANECOIND not found or not executable." && exit 1

# The autodetected version git tag can screw up manpage output a little bit
DANEVER=($($DANECOINCLI --version | head -n1 | awk -F'[ -]' '{ print $6, $7 }'))

# Create a footer file with copyright content.
# This gets autodetected fine for danecoind if --version-string is not set,
# but has different outcomes for danecoin-qt and danecoin-cli.
echo "[COPYRIGHT]" > footer.h2m
$DANECOIND --version | sed -n '1!p' >> footer.h2m

for cmd in $DANECOIND $DANECOINCLI $DANECOINTX $DANECOINQT; do
  cmdname="${cmd##*/}"
  help2man -N --version-string=${DANEVER[0]} --include=footer.h2m -o ${MANDIR}/${cmdname}.1 ${cmd}
  sed -i "s/\\\-${DANEVER[1]}//g" ${MANDIR}/${cmdname}.1
done

rm -f footer.h2m
