#!/usr/bin/env bash

# View most recent work log entry 
#
# Usage
# > parse_work_log.sh FILENAME

set -euo pipefail

source $SCRIPTS_PATH/colors.sh

log_file=$1
delimiter="##"
allowed_delimiter=1

if [ -z $log_file ]; then
  echo -e "${BRed}Must specify log file to view${RCol}"
  exit 1
fi

source $SCRIPTS_PATH/format-markdown-line.sh

delimiter_lines=( $(grep -n -m 2 $delimiter $log_file | sed -e 's/:.*//gi') )
last_line=$(( ${delimiter_lines[1]} - 1 ))
lines=$(IFS="\n" head -n ${last_line} $log_file)

IFS=
while read -r line ; do
  format_markdown "${line}"
done < <(head -n ${last_line} $log_file)

