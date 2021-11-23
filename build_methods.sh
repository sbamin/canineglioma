#!/bin/bash

## strict check
set -euo pipefail

DOCDIR="$HOME"/dbjax/code/gitrepos/github/cgp_keystone/canineglioma
#### DANGER ####
## MAKE SURE TO HAVE VALID PATH HERE AS SCRIPT WILL NOT CHECK FOR PATH
## rsync may overwrite or worse, delete files on remote node.

if [[ ! -d "$DOCDIR" || ! -x "$DOCDIR" ]]; then
	echo -e "\nERROR: DOCDIR does not exists or not accesible at $DOCDIR\n" >&2
	exit 1
fi

## build docs
cd "$DOCDIR" && \
mkdocs build --clean && echo -e "\nINFO: Built updated docs\n" && \
mkdocs gh-deploy --clean -m "published using commit: {sha} and mkdocs {version}"

## Build hook
## curl -X POST -d {} https://api.netlify.com/build_hooks/***
## END ##
