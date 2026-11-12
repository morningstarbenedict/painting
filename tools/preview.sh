#!/bin/bash
# preview.sh <session> : rebuild form from lua/head.lua and render value map
S=${1:-sketch1}; SP=/tmp/claude-0/-home-user-painting/e60d5951-9ae5-57b0-951a-53ede3f731ee/scratchpad
./e -s $S do -f lua/head.lua >/dev/null && ./e -s $S do 'F = build_form()' >/dev/null && ./e -s $S do -f lua/s_dump.lua > $SP/d.txt && python3 dump2png.py $SP/d.txt $SP/${2:-d}.png && echo ok
