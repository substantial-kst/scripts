#!usr/bin/env bash

set -euo pipefail

source $SCRIPTS_PATH/colors.sh

function format_links {
  formatted=$(echo -e $formatted | sed -e "s/\(\[.*\]\)\((.*)\)/\1`echo -e ${UGre}`\2`echo -e ${RCol}`/g")
}

function format_tags {
  formatted=$(echo -e $formatted | sed -e "s/\(\[.*\][^\(]\)/`echo -e ${BRed}`\1`echo -e ${RCol}`/g")
}

function format_top_heading {
  formatted=$(echo -e $formatted | sed -e "s/^\(#[^#.]*\)\$/`echo -e ${BICya}`\1`echo -e ${RCol}`/g")
}

function format_entry_heading {
  formatted=$(echo -e $formatted | sed -e "s/^\(##.*\)\$/`echo -e ${BYel}`\1`echo -e ${RCol}`/g")
}

function format_code {
  formatted=$(echo -e $formatted | sed -e "s/\(\`[^\`.]*\`\)/`echo -e ${BIBlu}`\1`echo -e ${RCol}`/g")
}

function format_markdown() {
  local formatted="$*"
  format_tags
  format_links
  format_top_heading
  format_entry_heading
  format_code
  echo -e "$formatted"
}

