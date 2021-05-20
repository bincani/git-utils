#!/bin/sh

# USAGE:
# alias cu='/home/factoryx/git-utils/composer-update.sh'
# cu

if [ -z "$(git status --porcelain)" ]; then
    CBRANCH=$(git -C .modman/$MODULE symbolic-ref --short -q HEAD)
    if [ "$CBRANCH" != 'master' ]; then
        echo "You must be on the master branch to update (current: $CBRANCH)"
        exit 1
    fi
    git pull
    composer update
    git add .
    git commit -m "composer update"
    git push
else
    echo "Cannot update as there are Uncommitted changes!"
    git status --porcelain
fi

