#!/usr/bin/env bash
# Reproducible build with the TeX Live version of the original submission (2019).
# Requires podman (or docker: export ENGINE=docker).
#   ./build.sh          → build/treemap-categories.pdf                 (paper)
#   ./build.sh slides   → build/slides/treemap-taxonomy-ivapp2020.pdf  (talk slides)
# openout_any=a: let bibtex write into the absolute output directory /out.
set -euo pipefail
cd "$(dirname "$0")"
ENGINE=${ENGINE:-podman}
IMAGE=docker.io/texlive/texlive:TL2019-historic
if [[ ${1:-} == slides ]]; then
  dir=slides out=build/slides main=treemap-taxonomy-ivapp2020.tex
else
  dir=src out=build main=treemap-categories.tex
fi
mkdir -p "$out"
"$ENGINE" run --rm -e openout_any=a -v "$PWD/$dir:/src:ro,Z" -v "$PWD/$out:/out:Z" -w /src "$IMAGE" \
  latexmk -pdf -interaction=nonstopmode -outdir=/out "$main"
