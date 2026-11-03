#!/bin/bash

DOCDIR="$HOME"/sync/dbjax/code/gitrepos/github/cgp_keystone/canineglioma

if [[ ! -d "$DOCDIR" || ! -x "$DOCDIR" ]]; then
	echo -e "\nERROR: DOCDIR does not exists or not accesible at $DOCDIR\n" >&2
	exit 1
fi

## activate env
mkdocs() { pixi run --manifest-path "$HOME"/.config/pixi-global/pixi.toml -e sitebuilder mkdocs "$@"; }

## strict check
set -euo pipefail

cd "$DOCDIR" && echo -e "\nWorkdir is $DOCDIR\n"
mkdocs -q serve -a localhost:4000

## END ##
