#!/usr/bin/env bash

# View most recent work log entry 
#
# Usage
# > parse_work_log.sh FILENAME

source $SCRIPTS_PATH/colors.sh

log_file=$1
delimiter="##"
allowed_delimiter=1

if [ -z $log_file ]; then
  echo -e "${BRed}Must specify log file to view${RCol}"
  exit 1
fi

delimiter_lines=( $(grep -n -m 2 $delimiter $log_file | sed -e 's/:.*//gi') )
last_line=$(( ${delimiter_lines[1]} - 1 ))
lines=$(IFS="\n" head -n ${last_line} $log_file)

while IFS= read -r line ; do
  # TODO: Figure out why indentation is being lost
  formatted=$(echo $line | sed -e "s/\[/`echo -e ${BRed}`\[/g" -e "s/\]/\]`echo -e ${RCol}`/g" -e "s/^\(##.*\)\$/`echo -e ${ICya}`\1`echo -e ${RCol}`/g" -e "s/^\(#.*\)\$/`echo -e ${BIYel}`\1`echo -e ${RCol}`/g" -e "s/\(\`.*\`\)/`echo -e ${BBlu}`\1`echo -e ${RCol}`/g")
  echo -e $formatted
done < <(head -n ${last_line} $log_file)

#echo -e "${lines}" 

