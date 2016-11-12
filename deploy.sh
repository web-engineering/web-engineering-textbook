#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

# Pull requests and commits to other branches shouldn't try to deploy, just build to verify
if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "master" ]; then
    echo "Skipping deploy because ${TRAVIS_PULL_REQUEST} and ${TRAVIS_BRANCH};"
    exit 0
fi

# Save some useful information
REPO=git@github.com:web-engineering/web-engineering.github.io.git
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git log -1 --pretty=%h`
MESSAGE=`git log -1 --pretty=%B`
AUTHOR=`git log -1 --pretty=%an`
EMAIL=`git log -1 --pretty=%ae`
echo "will commit ${AUTHOR} <${EMAIL}>: commit ${SHA} ${MESSAGE}"
echo "to repo ${SSH_REPO}"

# Get the deploy key by using Travis's stored variables to decrypt deploy_key.enc
ENCRYPTED_KEY=$encrypted_480ea2132df2_key
ENCRYPTED_IV=$encrypted_480ea2132df2_iv
 
echo "openssl aes-256-cbc -K $ENCRYPTED_KEY -iv $ENCRYPTED_IV -in deploy_key.enc -out deploy_key -d"
openssl aes-256-cbc -K $ENCRYPTED_KEY -iv $ENCRYPTED_IV -in deploy_key.enc -out deploy_key -d

chmod 600 deploy_key
echo "got the deploy_key:"
echo `file deploy_key`

echo "adding to ssh-agent"
eval `ssh-agent -s`
ssh-add deploy_key

# Clone the existing github pages into out/
echo "git clone $REPO out"
git clone $REPO out

echo "Clean out existing contents"
rm -rf out/**/* || exit 0

echo "Copy over results of build"
cp -a output/* out/

# Now let's go have some fun with the cloned repo
cd out
git config user.name "$AUTHOR via Travis CI"
git config user.email "$EMAIL"

# If there are no changes to the compiled out (e.g. this is a README update) then just bail.
if [ -z `git diff --exit-code` ]; then
    echo "No changes to the output on this build; exiting."
    exit 0
fi

echo 'Commit the "changes", i.e. the new version.'
# The delta will show diffs between new and old versions.
git add .
git commit -m "${MESSAGE} (originally ${SHA})"

# Now that we're all set up, we can push.
echo "git push origin master"
git push origin master
