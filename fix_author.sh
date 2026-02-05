#!/bin/sh

# 1. ENTER YOUR CORRECT DETAILS HERE
CORRECT_NAME="Nikolaos Lavidas"
CORRECT_EMAIL="nikolaos.lavidas@gmail.com"

# 2. ENTER THE WRONG DETAILS TO FIND AND REPLACE
# (This looks for any commit made by "Claude")
WRONG_NAME="Claude"

git filter-branch --env-filter '

if [ "$GIT_AUTHOR_NAME" = "$WRONG_NAME" ]; then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_COMMITTER_NAME" = "$WRONG_NAME" ]; then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi

' --tag-name-filter cat -- --branches --tags
