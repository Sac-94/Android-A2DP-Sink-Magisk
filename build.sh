#!/usr/bin/env sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
OUT="$ROOT/release/A2DP-Sink-Android15-Magisk.zip"
rm -f "$OUT"
(cd "$ROOT/module" && zip -9 -r "$OUT" . -x '*.DS_Store')
echo "Built: $OUT"
