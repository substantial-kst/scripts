#!usr/bin/env bash

set -euo pipefail

source $SCRIPTS_PATH/colors.sh

function format_tags() {
  formatted=$(echo -e $formatted | sed -e "s/\(\[.*\]\)/`echo -e ${BRed}`\1`echo -e ${RCol}`/g")
}

function format_top_heading() {
  formatted=$(echo -e $formatted | sed -e "s/\(#.*\)\$/`echo -e ${BIYel}`\1`echo -e ${RCol}`/g")
}

function format_entry_heading() {
  formatted=$(echo -e $formatted | sed -e "s/^\(##.*\)\$/`echo -e ${ICya}`\1`echo -e ${RCol}`/g")
}

function format_markdown() {
  local formatted="$*"
  format_tags
  format_top_heading
  format_entry_heading
  echo -e "$formatted"
}

