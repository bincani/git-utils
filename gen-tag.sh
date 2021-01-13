#!/bin/sh

# get latest branch updates
git pull

# generate a tag name with mask YYYYMMDD_release_vM.m.r.p.X
# e.g. 20190117_release_v1.9.3.8.62

DATE=`date +%Y%m%d`
RDIV="_release_v"
MAGE_VERSION=$(php -r "include 'app/Mage.php'; echo Mage::getVersion();")

# get the last tag
LAST_TAG=`git describe --abbrev=0 --tags`

LAST_VER_NBR_REGEX="[0-9]+$"
LAST_VER_NBR=`echo "$LAST_TAG" | grep -Eo "${LAST_VER_NBR_REGEX}"`

# increase version
NEW_VER_NBR=$((LAST_VER_NBR+1))
#echo "$NEW_VER_NBR";

# get current hash and see if it already has a tag
GIT_COMMIT=`git rev-parse HEAD`
NEEDS_TAG=`git describe --contains $GIT_COMMIT`

# new tag
NEW_TAG="$DATE$RDIV$MAGE_VERSION.$NEW_VER_NBR"
echo "$NEW_TAG"

# Only tag if no tag already (would be better if the git describe command above could have a silent option)
if [ -z "$NEEDS_TAG" ]; then
    echo "Tagged with $NEW_TAG (Ignoring fatal:cannot describe - this means commit is untagged) "
    git tag $NEW_TAG
    git push origin $NEW_TAG
else
    echo "Already a tag on this commit"
fi
