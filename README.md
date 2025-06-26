# GitHub Anonymity Script (A.K.A. Anonimify 3000)

Removes your email address from your GitHub commits, I guess.  
Because you committed like it's 2015 and forgot GitHub exposes your email or you didn't sign a repo or something so for some reason it leaks ur email lol..

---

## Usage  
### 🐧 Linux / MacOS

#### 1. Requirements

- `bash`
- `jq`
- `git`
- [A GitHub Personal Access Token (PAT)](https://github.com/settings/tokens) with `repo` access (just allow everything if ur gonna delete it after)

#### 2. Configuration

Edit the top of the script (`github-anonimity-script.sh`) to set your personal info:

```bash
GITHUB_USERNAME="yourusername"
OLD_EMAIL="you@leakedemail.com"
NEW_NAME="replace by ur github username"
NEW_EMAIL="whatever you want to put for your new email"
GITHUB_TOKEN="" # generate @ https://github.com/settings/tokens (choose classic)
````

You can also export your token:

```bash
export GITHUB_TOKEN=your_github_token_here
```

#### 3. Run the script yes finally privacy yay

Open a terminal emulator

```bash
chmod +x github-anonimity-script.sh
./github-anonimity-script.sh
```

It's going to ask for your username and password for every repo it finds a leak so it can push the corrected version, but you have to put your GitHub API key instead of your password in a lot of cases because GitHub is strange so just for that (you can use the one you put in the script).

### 🪟 Windows

#### 1. Requirements

- `powershell 5.1+`
- `jq`
- `git`
- [A GitHub Personal Access Token (PAT)](https://github.com/settings/tokens) with `repo` access (just allow everything if ur gonna delete it after)

#### 2. Configuration

Edit the top of the script (`github-anonimity-script.ps1`) to set your personal info:

```bash
$GITHUB_USERNAME = "yourusername"
$OLD_EMAIL = "you@leakedemail.com"
$NEW_NAME = "replace by ur github username"
$NEW_EMAIL = "whatever you want to put for your new email"
$GITHUB_TOKEN = ""  # generate @ https://github.com/settings/tokens (choose classic)
````

#### 3. Run the script yes finally privacy yay

Open Powershell as administrator

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\anonimify.ps1
```

It's going to ask for your username and password for every repo it finds a leak so it can push the corrected version, but you have to put your GitHub API key instead of your password in a lot of cases because GitHub is strange so just for that (you can use the one you put in the script).

---

What this ~~shit~~ perfect script does :3

* Fetch all commits authored by your old email across your GitHub repos.
* Clone the affected repos.
* Rewrites the author & committer identity in all relevant commits.
* Force-push the cleaned history to GitHub.

---

## ⚠️ Warning

* This **rewrites git history** and force-pushes it. So if others cloned the repo, it will break their local history, and ur cooked.
* Your commits can still be cached or archived externally so to make sure contact support I guess
* I made it which means it is poo poo on a stick so please be careful with it you might end up breaking ur stuff
* You can get rate limited by GitHub's API if you have a big big amount of repos and I can't do anything about that

## License

idk and idc just don't be a scumbag
