#!/usr/bin/env bash

inside_git_repo="$(git rev-parse --is-inside-work-tree 2> /dev/null)"

source $SCRIPT_DIR/colors.sh

if [ "$inside_git_repo" ]; then
  # inside git repo
  exit 0
else
  echo -e "Not a git repo directory: ${BRed}$(pwd)${RCol}"
  exit 1
fi
