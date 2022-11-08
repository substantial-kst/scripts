#!/usr/bin/env bash

# Find afferent references to current project gem
source $SCRIPTS_PATH/colors.sh

directory=$(pwd)
path_limit=$1
gem_dir=0
gemspec_results=0

if [ -z $path_limit ]; then
  echo -e "${BRed}Path limit must be supplied${RCol} (e.g. ~/Projects)"
  echo -e ""
  echo -e "${Cya}Usage:${RCol} find-gem-afferents.sh PATH_LIMIT"
  exit 1
fi

# Traverse up the directory tree to find the package gemspec
# TODO - This could be its own script
exec 2> /dev/null
while [ $gemspec_results == 0 ]; do
  cwd=$(pwd)
  if [[ $cwd =~ ^$path_limit ]]; then
    results=$(ls *.gemspec)
    if [ -z $results ]; then
      cd ..
    else
      gem_dir=$(eval "echo $cwd | sed -e 's|$path_limit/||g'")
      
      # TODO - We've found the file, but the package name _in the gemspec_ would be a more accurate source of truth
      gemspec_results=$(echo $results | sed -e 's/.gemspec//g')
    fi
  else
    break
  fi
done
exec 2>&2

cd $directory
if [ $gemspec_results == 0 ]; then
  echo -e "${BRed}Could not locate a gemspec in directory tree: ${directory}${RCol}"
  exit 1
fi

echo -e "${Yel}$path_limit/${gem_dir}${RCol}"
for gem_name in ${gemspec_results}; do
  echo ""
  echo -e "${BBlu}${gem_name}${RCol}"
  printf %${#gem_name}s | tr ' ' -
  echo ""

  gemspec_search_pattern="'gem \"$gem_name\"'"
  gemspec_cmd="rg -l $gemspec_search_pattern $path_limit | sort | uniq | sed -e 's|$path_limit||g' -e 's|^/||g' -e 's|/.*$||g'"
  lockfile_cmd="rg -l -F -- \"$gem_name\" $path_limit/*/Gemfile.lock | sort | uniq | sed -e 's|$path_limit||g' -e 's|^/||g' -e 's|/.*$||g'"

  gemspec_matches=()
  IFS=$' ' read -r -d '' -a gemspec_matches < <( eval $gemspec_cmd && printf '\0' )

  lockfile_matches=()
  IFS=$' ' read -r -d '' -a lockfile_matches < <( eval $lockfile_cmd && printf '\0' )

  echo -e "${BCya}Gem Afferents"
  echo -e "-------------${RCol}"

  for match in $gemspec_matches; do
    echo -e "${match}"
  done

  echo ""
  echo -e "${Gre}Lockfile Afferents"
  echo -e "------------------${RCol}"

  for match in $lockfile_matches; do
    if [[ ! ${gemspec_matches[*]} =~ ${match} ]]; then
      if [ ${match} != ${gem_dir} ]; then
        echo -e "${match}"
      fi
    fi
  done
done
