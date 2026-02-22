# Old Mac to New Mac migration

This repo holds the docs and scripts you need to set up Git + GitHub and clone your 14 project repos when moving from an old Mac to a new Mac.

**On the new Mac:**

1. Clone this repo first (you’ll need Git + SSH set up once — see step 2):
   ```bash
   mkdir -p ~/Repositories && cd ~/Repositories
   git clone git@github.com:thedoctorJJ/old-mac-to-new-mac-migration.git
   cd old-mac-to-new-mac-migration
   ```
2. **If you don’t have Git/SSH yet:** Open **GITHUB-SETUP-NEW-MAC.md** in this repo (e.g. on [GitHub](https://github.com/thedoctorJJ/old-mac-to-new-mac-migration)) and follow sections 1–3 to install Git, set your identity, and add your new Mac’s SSH key to GitHub. Then clone this repo with the command above.
3. Open **GITHUB-SETUP-NEW-MAC.md** and follow it (Git identity, SSH, test).
4. Use **REPOS-TO-SYNC-REVIEW.md** for the list of 14 repos to clone into `~/Repositories`.
5. Scripts: **backup-before-migration.sh** (for future backups), **github-remotes-to-ssh.sh** (to switch cloned repos from HTTPS to SSH if needed).
6. **BACKUP-RUN-SUMMARY.md** and **BACKUP-VERIFICATION-REPORT.md** — backup status and repo-by-repo verification from the old Mac (which repos have `backup-2025-02-22`, which are clean, which need attention).
7. **Secrets / .env transfer:** **SECRETS-TRANSFER.md** — how to move `.env` files, credentials, and local data from the old Mac to the new (not in Git). On the old Mac run **export-secrets-for-migration.sh** to create `~/Repositories-secrets-export`; zip and transfer it; on the new Mac unzip and run **restore-secrets-after-migration.sh** after cloning repos.

All paths in the scripts use `~/Repositories` so they work on any Mac.

---

**On the old Mac (one-time):** Create the repo on GitHub named **old-mac-to-new-mac-migration**, then from this folder run:

```bash
cd ~/Repositories/old-mac-to-new-mac-migration
git init
git add .
git commit -m "Setup docs and scripts for old Mac to new Mac migration"
git remote add origin git@github.com:thedoctorJJ/old-mac-to-new-mac-migration.git
git branch -M main
git push -u origin main
```

If the repo already exists on GitHub with a README, use `git pull origin main --allow-unrelated-histories` before pushing, or clone the empty repo and copy these files in.
