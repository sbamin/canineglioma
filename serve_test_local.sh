#!/bin/bash

DOCDIR="$HOME"/dbjax/code/gitrepos/github/cgp_keystone/canineglioma

if [[ ! -d "$DOCDIR" || ! -x "$DOCDIR" ]]; then
	echo -e "\nERROR: DOCDIR does not exists or not accesible at $DOCDIR\n" >&2
	exit 1
fi

#### Activate CONDA in subshell ####
## Read https://github.com/conda/conda/issues/7980
CONDA_BASE=$(conda info --base) && \
source "${CONDA_BASE}"/etc/profile.d/conda.sh && \
conda activate ruby
#### END CONDA SETUP ####

## strict check
set -euo pipefail

cd "$DOCDIR" && echo -e "\nWorkdir is $DOCDIR\n"
mkdocs -q serve

## END ##
