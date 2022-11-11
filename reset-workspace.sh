#!/usr/bin/env bash

# Resets the git workspace, stashing any local changes, and pulling latest
# from the remote integration branch (examples: "main", "master")

source $SCRIPT_DIR/colors.sh

exec 2> /dev/null
# Ensure we're in a git directory to begin with; exit if not
  DIR_TEST="${SCRIPTS_PATH}/test-if-git-dir.sh"
  $DIR_TEST

  DIR_STATUS=$?

  if [ $DIR_STATUS -eq 1 ]
  then
    exit 1
  fi
exec 2>&2

# Get the status of the local workspace (do we need to stash local work)
REPO_STATUS=`git status | sed -n '/nothing to commit/s/.*, //p'`

if [ "$REPO_STATUS" != "working tree clean" ]
then
  NEED_TO_STASH="true"
fi

# Identify whether the local workspace has the integration branch checked out
CURRENT_BRANCH=`git branch --show-current`
INTEGRATION_BRANCH=`git remote show origin | sed -n '/HEAD branch/s/.*: //p'`
if [ $CURRENT_BRANCH != $INTEGRATION_BRANCH ]
then
  ON_INTEGRATION_BRANCH="false"
else
  ON_INTEGRATION_BRANCH="true"
fi

if [ $NEED_TO_STASH == "true" ]
then
# Stash local changes
  echo ""
  echo -e "${BCya}-- Stashing local changes${RCol}"
  git stash
fi

if [ $ON_INTEGRATION_BRANCH == "false" ]
then
# Checkout integration branch
  echo ""
  echo -e "${BCya}-- Checkout integration branch (\"$INTEGRATION_BRANCH\")${RCol}"
  git checkout $INTEGRATION_BRANCH
fi

echo ""
echo -e "${BCya}-- Pulling latest${RCol}"
git pull

if [ $ON_INTEGRATION_BRANCH == "false" ] 
then
# Restore original local branch
  echo ""
  echo -e "${BCya}-- Checking out original branch (\"$CURRENT_BRANCH\")${RCol}"
  git checkout $CURRENT_BRANCH
fi

if [ $NEED_TO_STASH == "true" ]  
then
# Restore local changes
  echo ""
  echo -e "${BCya}-- Popping stashed changes${RCol}"
  git stash pop
fi
