#!/bin/bash

## strict check
set -euo pipefail

DOCDIR="$HOME"/sync/dbjax/code/gitrepos/github/cgp_keystone/canineglioma
WEBDIR="$HOME"/tmp/cgpweb

#### DANGER ####
## MAKE SURE TO HAVE VALID PATH HERE AS SCRIPT WILL NOT CHECK FOR PATH
## rsync may overwrite or worse, delete files on remote node.
if [[ ! -d "$DOCDIR" || ! -x "$DOCDIR" ]]; then
	echo -e "\nERROR: DOCDIR does not exists or not accesible at $DOCDIR\n" >&2
	exit 1
fi

## strict check
set -euo pipefail

mkdocs() { pixi run --manifest-path "$HOME"/.config/pixi-global/pixi.toml -e sitebuilder mkdocs "$@"; }

cd "$DOCDIR" && \
echo "Start building..."

## build docs
rm -rf "${WEBDIR}" && \
mkdir -p "${WEBDIR}" && \
mkdocs build --clean --site-dir "${WEBDIR}" && echo -e "\nINFO: Built updated docs\n" && \
mkdocs gh-deploy --clean -m "published using commit: {sha} and mkdocs {version}"

## Build hook
## curl -X POST -d {} https://api.netlify.com/build_hooks/***
## END ##
