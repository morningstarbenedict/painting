#!/bin/bash
# Re-render the portrait from its painting log on your own machine.
# Needs: git, Rust (rustup), a C compiler (Xcode command line tools on macOS).
# Usage: ./render.sh [output.png]       (about 8 GB of RAM at peak)
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
OUT="${1:-$HERE/portrait_render.png}"
PAINT="${CLAUDE_PAINT_DIR:-$HERE/.claude-paint}"
if [ ! -d "$PAINT/.git" ]; then
  git clone --depth 1 https://github.com/aliceisjustplaying/claude-paint "$PAINT"
fi
# build from inside the checkout so its .cargo/config (the fixed Lua seed) applies
(cd "$PAINT" && cargo build --release -p easel)
EASEL="$PAINT/target/release/easel"
# the log names its own tube box and engine; replay paints the same canvas
mkdir -p "$HERE/render"
cp "$HERE/painting_log.lua" "$HERE/render/painting_log.lua"
cd "$HERE/render"
time "$EASEL" run painting_log.lua --out "$OUT" \
  --checkpoint-out "$HERE/render/portrait.ckpt"
# the varnished and aged finishes, from the replay's final state
"$EASEL" finish "$HERE/render/portrait.ckpt" "${OUT%.png}_varnished.png" --log painting_log.lua --no-cracks
"$EASEL" finish "$HERE/render/portrait.ckpt" "${OUT%.png}_aged.png" --log painting_log.lua
echo "done: $OUT and its _varnished / _aged versions"
