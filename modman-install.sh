#!/bin/sh

# USAGE:
# alias mi='/home/factoryx/git-utils/modman-install.sh'
# mi FactoryX_CmApi

# get param to lowercase
MODULE=$1
MODULE=$(echo "$MODULE" | sed 's/\(.*\)/\L\1/')

echo "installing $MODULE"

# test url 401 Unauthorized is OK
URL=https://bincani@bitbucket.org/factoryx-developers/$MODULE.git

RCODE=$(wget --server-response $URL 2>&1 | awk '/^  HTTP/{print $2}')
#echo "$RCODE"

# if wget $URL >/dev/null 2>&1 ; then
if [[ "$RCODE" == 404 ]]; then
    echo "cannot find repo $URL $RCODE"
    exit 1
else
    REPO=git@bitbucket.org:factoryx-developers/$MODULE.git    
fi

if [ -z "$(git status --porcelain)" ]; then 
    CBRANCH=$(git -C .modman/$MODULE symbolic-ref --short -q HEAD)
    if [[ "$CBRANCH" != 'master' ]]; then
        echo "$MODULE is on t he master branch (current: $CBRANCH)"
        exit 1
    fi
    git pull
    modman clone $REPO
    modman update $MODULE --force --copy
    git add .
    git commit -m "update $MODULE"
    git push  
else 
    echo "Cannot install $MODULE as there are Uncommitted changes!"
    git status --porcelain
fi

