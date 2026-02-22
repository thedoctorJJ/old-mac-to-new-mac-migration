# New Mac setup — step-by-step

Do these steps **on the new Mac** after you've switched from the old one. You'll need the **Repositories-secrets-export.zip** file (AirDropped or otherwise transferred).

---

## 1. Install Git (if needed)

```bash
git --version
```

If not installed: run `xcode-select --install` or `brew install git`.

---

## 2. Set Git identity

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

### 3b. Add key to ssh-agent (with Keychain)

```bash
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

### 3c. Add this to `~/.ssh/config`

```bash
mkdir -p ~/.ssh
touch ~/.ssh/config
chmod 600 ~/.ssh/config
```

Open `~/.ssh/config` and add (or merge):

```
Host github.com
  HostName github.com
  User git
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
```

### 3d. Add the new Mac’s key to GitHub

1. Copy your public key:
   ```bash
   pbcopy < ~/.ssh/id_ed25519.pub
   ```
2. In the browser: **GitHub → Settings → SSH and GPG keys** → https://github.com/settings/keys
3. Click **New SSH key**, title e.g. "MacBook 2025", paste (Cmd+V), save.

### 3e. Test

```bash
ssh -T git@github.com
```

You should see: **Hi thedoctorJJ! You've successfully authenticated...**

---

## 4. Clone the migration repo first

```bash
mkdir -p ~/Repositories && cd ~/Repositories
git clone git@github.com:thedoctorJJ/old-mac-to-new-mac-migration.git
cd old-mac-to-new-mac-migration
```

All steps below assume you're using this repo’s docs/scripts.

---

## 5. Clone the 14 project repos

From `~/Repositories`, clone each (use SSH URLs). **Owner** is either your account (`thedoctorJJ`) or the org shown.

| Repo | Clone command |
|------|----------------|
| App | `git clone git@github.com:tellenai/App.git` |
| ai-agent-factory | `git clone git@github.com:thedoctorJJ/ai-agent-factory.git` |
| auditor-job-posting-agent | `git clone git@github.com:thedoctorJJ/auditor-job-posting-agent.git` |
| canton | `git clone git@github.com:thedoctorJJ/canton.git` |
| finance-agents | `git clone git@github.com:thedoctorJJ/finance-agents.git` |
| md2googleslides | `git clone git@github.com:thedoctorJJ/md2googleslides.git` |
| product-management | `git clone git@github.com:USIG-Digital/product-management.git` |
| skeletonapp | `git clone git@github.com:tellenai/skeletonapp.git` |
| tellen-design-system-css | `git clone git@github.com:thedoctorJJ/tellen-design-system-css.git` |
| tellen_client_news_agent | `git clone git@github.com:thedoctorJJ/Slack_client_news_agent.git tellen_client_news_agent` |
| token-discovery | `git clone git@github.com:USIG-Digital/token-discovery.git` |
| usig-testnet-one-pager | `git clone git@github.com:thedoctorJJ/usig-testnet-one-pager.git` |
| usig-token-lifecycle-diagrams | `git clone git@github.com:thedoctorJJ/usig-token-lifecycle-diagrams.git` |
| workforce-agent-proposal-generator | `git clone git@github.com:thedoctorJJ/workforce-agent-proposal-generator.git` |

**Repos that use backup branch first** (had no `main` on old Mac — checkout backup after clone):

- **tellen-design-system-css:**  
  `cd tellen-design-system-css && git checkout backup-2025-02-22`
- **usig-testnet-one-pager:**  
  `cd usig-testnet-one-pager && git checkout backup-2025-02-22`
- **usig-token-lifecycle-diagrams:**  
  `cd usig-token-lifecycle-diagrams && git checkout backup-2025-02-22`

**Optional — inner project** (if you use it):

```bash
git clone git@github.com:thedoctorJJ/workforce-agent-proposal-generator-inner.git
```

You can put it inside `workforce-agent-proposal-generator/workforce-agent-proposal-generator/` or keep it separate.

---

## 6. Restore secrets and .env files

1. Put **Repositories-secrets-export.zip** on the new Mac (e.g. AirDrop to Downloads).

2. Unzip it into your home directory:
   ```bash
   cd ~
   unzip ~/Downloads/Repositories-secrets-export.zip
   ```
   This creates `~/Repositories-secrets-export/` with the same folder layout as the repos.

3. Run the restore script (after the 14 repos are cloned into `~/Repositories`):
   ```bash
   cd ~/Repositories/old-mac-to-new-mac-migration
   bash restore-secrets-after-migration.sh
   ```

4. Optionally remove the export folder and zip after you’ve verified everything:
   ```bash
   rm -rf ~/Repositories-secrets-export ~/Downloads/Repositories-secrets-export.zip
   ```

---

## 7. Quick check

- In a few repos: `git status` and `git branch` to confirm branch and no surprises.
- Confirm `.env` / `config/env` / `credentials` exist where you expect (see **SECRETS-TRANSFER.md**).

---

## Reference

| Doc | Use |
|-----|-----|
| **GITHUB-SETUP-NEW-MAC.md** | Full Git + SSH setup details |
| **REPOS-TO-SYNC-REVIEW.md** | List of 14 repos and skip list |
| **BACKUP-RUN-SUMMARY.md** | What was backed up and any caveats |
| **BACKUP-VERIFICATION-REPORT.md** | Repo-by-repo backup verification |
| **SECRETS-TRANSFER.md** | What’s in the secrets export and other transfer options |

You’re done. Use **backup-before-migration.sh** and **github-remotes-to-ssh.sh** from the migration repo when you need them in the future.
