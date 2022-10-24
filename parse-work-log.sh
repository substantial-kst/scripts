#!/usr/bin/env bash

# View most recent work log entry 
#
# Usage
# > parse_work_log.sh FILENAME [ENTRY_COUNT]

set -eo pipefail

source $SCRIPTS_PATH/colors.sh

log_file=$1
entry_count=$2

if [[ ! -z $entry_count ]]; then
  if [[ "$entry_count" =~ ^[0-9]+$ ]]; then
    allowed_delimiter=$(($entry_count + 1))
  fi
else
  allowed_delimiter=2
fi

delimiter="##"

if [ -z $log_file ]; then
  echo -e "${BRed}Must specify log file to view${RCol}"
  exit 1
fi

source $SCRIPTS_PATH/format-markdown-line.sh

delimiter_lines=( $(grep -n -m $allowed_delimiter $delimiter $log_file | sed -e 's/:.*//gi') )
last_delimiter=${delimiter_lines[${#delimiter_lines[@]}-1]}

last_line=$(( ${last_delimiter} - 1 ))
lines=$(IFS="\n" head -n ${last_line} $log_file)

IFS=
while read -r line ; do
  format_markdown "${line}"
done < <(head -n ${last_line} $log_file)

