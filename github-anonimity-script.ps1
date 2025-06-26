# CONFIG - fill these with your info
$GITHUB_USERNAME = "yourusername"
$OLD_EMAIL = "you@leakedemail.com"
$NEW_NAME = "replace by ur github username"
$NEW_EMAIL = "whatever you want to put for your new email"
$GITHUB_TOKEN = ""  # generate @ https://github.com/settings/tokens (choose classic)

# base dir for local clones
$BASE_DIR = "$HOME\github_repos"
New-Item -ItemType Directory -Path $BASE_DIR -Force | Out-Null

# query GitHub API to find commits with old email
echo "Fetching commits authored by $OLD_EMAIL from GitHub..."

$headers = @{
    Authorization = "token $GITHUB_TOKEN"
    Accept        = "application/vnd.github.cloak-preview"
    "User-Agent"  = "anonimify-script"
}
$searchURL = "https://api.github.com/search/commits?q=author-email:$OLD_EMAIL+author:$GITHUB_USERNAME"
$response = Invoke-RestMethod -Uri $searchURL -Headers $headers

# get repo names
$repos = $response.items.repository.full_name | Sort-Object -Unique

echo "Found repos with commits to fix:"
$repos | ForEach-Object { echo $_ }
echo ""

foreach ($repo_full in $repos) {
  echo "Processing $repo_full"

  $repo_dir = Join-Path $BASE_DIR ($repo_full -split '/')[1]

  # clone or update repo
  if (Test-Path "$repo_dir\.git") {
    echo "Repo exists locally, fetching latest..."
    git -C $repo_dir fetch --all
  } else {
    echo "Cloning repo..."
    git clone "https://github.com/$repo_full.git" $repo_dir
  }

  Set-Location $repo_dir

  # run git filter-branch to fix commits
  echo "Rewriting author/committer info in $repo_full..."

  git filter-branch --env-filter @"
if [ `"`$GIT_COMMITTER_EMAIL`" = `"$OLD_EMAIL`" ]; then
  export GIT_COMMITTER_NAME=`"$NEW_NAME`"
  export GIT_COMMITTER_EMAIL=`"$NEW_EMAIL`"
fi
if [ `"`$GIT_AUTHOR_EMAIL`" = `"$OLD_EMAIL`" ]; then
  export GIT_AUTHOR_NAME=`"$NEW_NAME`"
  export GIT_AUTHOR_EMAIL=`"$NEW_EMAIL`"
fi
"@ --tag-name-filter cat -- --branches --tags

  # cleanup idk
  git reflog expire --expire=now --all
  git gc --prune=now --aggressive

  # force push allat
  echo "Force pushing to GitHub..."
  git push --force --all
  git push --force --tags

  echo "Finished processing $repo_full"
  echo "-----------------------------"
}

echo "yay no leak now yippeh"
