# Set up GitHub on your new Mac

Use this checklist after you've moved to the new Mac. (On your old Mac first, use OLD-MAC-BEFORE-YOU-SWITCH.md to push to GitHub.) Your current Git identity: **thedoctorj** / **jjonessm@gmail.com**.

---

## 1. Install Git (if needed)

```bash
# Check if Git is installed
git --version
```

If not installed: install Xcode Command Line Tools (`xcode-select --install`) or install Git via Homebrew (`brew install git`).

---

## 2. Set your Git identity (global)

```bash
git config --global user.name "thedoctorj"
git config --global user.email "jjonessm@gmail.com"
```

---

## 3. Set up SSH for GitHub

### 3a. Generate a new SSH key (one per machine)

```bash
ssh-keygen -t ed25519 -C "jjonessm@gmail.com"
```

- Press Enter for default path (`~/.ssh/id_ed25519`).
- Use a passphrase (recommended) or leave empty.

### 3b. Start ssh-agent and add your key (with Keychain)

```bash
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

If you use a passphrase, enter it when prompted; macOS will store it in Keychain.

### 3c. Create or edit `~/.ssh/config`

```bash
mkdir -p ~/.ssh
touch ~/.ssh/config
chmod 600 ~/.ssh/config
```

Add or merge this block (e.g. with `nano ~/.ssh/config` or Cursor):

```
Host github.com
  HostName github.com
  User git
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
```

### 3d. Add the public key to GitHub

1. Copy your public key to the clipboard:
   ```bash
   pbcopy < ~/.ssh/id_ed25519.pub
   ```
2. In the browser: **GitHub → Settings → SSH and GPG keys**  
   https://github.com/settings/keys
3. Click **New SSH key**.
4. Title: e.g. `MacBook 2025` or your new machine name.
5. Paste (Cmd+V) and save.

### 3e. Test the connection

```bash
ssh -T git@github.com
```

You should see: **Hi thedoctorJJ! You've successfully authenticated...** (GitHub shows your actual username.)

---

## 4. Use SSH for existing repos (if they use HTTPS)

If you clone with HTTPS, Git will use HTTPS. To use SSH instead, update the remote:

```bash
cd /path/to/repo
git remote -v
# If origin is https://github.com/..., switch to SSH:
git remote set-url origin git@github.com:OWNER/REPO.git
```

Example for a repo under `thedoctorJJ`:

```bash
git remote set-url origin git@github.com:thedoctorJJ/ai-agent-factory.git
```

---

## 5. Optional: GitHub CLI

```bash
brew install gh
gh auth login
```

Choose **GitHub.com**, **SSH**, and **Login with a web browser** (or paste a token). Then `gh auth status` to confirm.

---

## Quick reference

| Step              | Command / action                          |
|-------------------|--------------------------------------------|
| Git identity      | `git config --global user.name "thedoctorj"` and same for `user.email` |
| New SSH key       | `ssh-keygen -t ed25519 -C "jjonessm@gmail.com"` |
| Add key to agent  | `ssh-add --apple-use-keychain ~/.ssh/id_ed25519` |
| Copy public key   | `pbcopy < ~/.ssh/id_ed25519.pub`           |
| Add key on GitHub | GitHub → Settings → SSH and GPG keys       |
| Test SSH          | `ssh -T git@github.com`                    |

After this, clone your 14 repos from GitHub into `~/Repositories` (see **REPOS-TO-SYNC-REVIEW.md** for the list). Use SSH URLs, e.g. `git clone git@github.com:thedoctorJJ/REPO_NAME.git`.
