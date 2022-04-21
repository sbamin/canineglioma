#!/bin/bash

## strict check
set -euo pipefail

DOCDIR="$HOME"/dbjax/code/gitrepos/github/cgp_keystone/canineglioma

if [[ ! -d "$DOCDIR" || ! -x "$DOCDIR" ]]; then
	echo -e "\nERROR: DOCDIR does not exists or not accesible at $DOCDIR\n" >&2
	exit 1
fi

## activate python3
cd "$DOCDIR" && echo -e "\nWorkdir is $DOCDIR\n"
mkdocs serve

## END ##
