#!/bin/bash

set -e

# This combination of hscolour and pandoc cannot easily produce an output
# document with neither bird tracks nor latex code blocks. As such, jump
# through hoops by converting bird tracks to latex for colourization, then
# stripping out the latex prior to passing to pandoc.

mkdir -p pkg

# awk ensures at least one blank line between each file, ensuring a break in
# any code blocks or other syntax that may be present.
awk 'FNR==1{print ""}{print}' \
  src/preamble.lhs src/euler_*.lhs src/postamble.lhs | \
  bin/replace_bird_tracks.rb |
  bin/format_math > pkg/euler.lhs

hscolour -lit -css -partial pkg/euler.lhs | \
  ruby -ne 'print $_.gsub(%r[\\(begin|end){code}], "")' > pkg/euler.md

pandoc -s \
  --css euler.css \
  --smart \
  --no-wrap \
  -f markdown \
  -t html \
  --template assets/template.html \
  pkg/euler.md > pkg/euler.html

cp assets/euler.css pkg/
echo "Compiled to pkg/euler.{lhs,md,html}"
