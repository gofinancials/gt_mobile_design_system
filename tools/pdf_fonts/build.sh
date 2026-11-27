#!/usr/bin/env bash
# Regenerates the TrueType Open Runde builds in assets/fonts/ from the OTFs
# beside them.
#
# The `pdf` package embeds TrueType outlines only, and Open Runde ships as
# CFF-flavoured OpenType, so documents carry their own TrueType builds of the
# two weights the document specs use, cut down to the Latin-1 range
# gtPdfSafeText confines document text to.
#
# Usage: tools/pdf_fonts/build.sh   (from the repo root; needs python3)
set -euo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

python3 -m venv "$work/venv"
"$work/venv/bin/pip" install --quiet fonttools

for weight in Medium Semibold; do
  "$work/venv/bin/python" -I "$root/tools/pdf_fonts/otf2ttf.py" \
    "$root/assets/fonts/OpenRunde-$weight.otf" "$work/OpenRunde-$weight.ttf"
  "$work/venv/bin/pyftsubset" "$work/OpenRunde-$weight.ttf" \
    --unicodes="U+0020-007E,U+00A0-00FF" \
    --layout-features='' \
    --drop-tables+=GSUB,GPOS,GDEF \
    --name-IDs='*' \
    --notdef-outline \
    --output-file="$root/assets/fonts/OpenRunde-$weight.ttf"
done
