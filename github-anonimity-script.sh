#!/bin/bash

# CONFIG - fill these with your info
GITHUB_USERNAME="yourusername"
OLD_EMAIL="you@leakedemail.com"
NEW_NAME="replace by ur github username"
NEW_EMAIL="whatever you want to put for your new email"
GITHUB_TOKEN="" # generate @ https://github.com/settings/tokens (choose classic)

# base dir for local clones
BASE_DIR="$HOME/github_repos"

mkdir -p "$BASE_DIR"

# query GitHub API to find commits with old email
echo "Fetching commits authored by $OLD_EMAIL from GitHub..."

commits_json=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/search/commits?q=author-email:$OLD_EMAIL+author:$GITHUB_USERNAME" \
  -H "Accept: application/vnd.github.cloak-preview" \
  -H "User-Agent: script")

# get repo names
repos=$(echo "$commits_json" | jq -r '.items[].repository.full_name' | sort -u)

echo "Found repos with commits to fix:"
echo "$repos"
echo

for repo_full in $repos; do
  echo "Processing $repo_full"

  repo_dir="$BASE_DIR/$(basename $repo_full)"

  # clone or update repo
  if [ -d "$repo_dir/.git" ]; then
    echo "Repo exists locally, fetching latest..."
    git -C "$repo_dir" fetch --all
  else
    echo "Cloning repo..."
    git clone "https://github.com/$repo_full.git" "$repo_dir"
  fi

  cd "$repo_dir" || { echo "Failed to cd to $repo_dir"; continue; }

  # run git filter-branch to fix commits
  echo "Rewriting author/committer info in $repo_full..."

  git filter-branch --env-filter "
    if [ \"\$GIT_COMMITTER_EMAIL\" = \"$OLD_EMAIL\" ]; then
      export GIT_COMMITTER_NAME=\"$NEW_NAME\"
      export GIT_COMMITTER_EMAIL=\"$NEW_EMAIL\"
    fi
    if [ \"\$GIT_AUTHOR_EMAIL\" = \"$OLD_EMAIL\" ]; then
      export GIT_AUTHOR_NAME=\"$NEW_NAME\"
      export GIT_AUTHOR_EMAIL=\"$NEW_EMAIL\"
    fi
  " --tag-name-filter cat -- --branches --tags

  # cleanup idk
  git reflog expire --expire=now --all
  git gc --prune=now --aggressive

  # force push allat
  echo "Force pushing to GitHub..."
  git push --force --all
  git push --force --tags

  echo "Finished processing $repo_full"
  echo "-----------------------------"
done

echo "yay no leak now yippeh"
