# Finish all work on the old Mac

Do these steps **on the old Mac** before switching to the new one. Run commands in **Terminal** or Cursor's terminal (not the Cursor agent).

---

## 1. Create the migration repo on GitHub

1. Open **https://github.com/new**
2. **Repository name:** `old-mac-to-new-mac-migration`
3. **Description (optional):** e.g. `Setup docs and scripts for old Mac to new Mac migration`
4. Leave **Add a README**, .gitignore, and license **unchecked**
5. Click **Create repository**

---

## 2. Push this folder to GitHub

In Terminal:

```bash
cd /Users/jason/Repositories/old-mac-to-new-mac-migration
git init
git add .
git commit -m "Setup docs and scripts for old Mac to new Mac migration"
git remote add origin git@github.com:thedoctorJJ/old-mac-to-new-mac-migration.git
git branch -M main
git push -u origin main
```

If you see "repository not found", create the repo in step 1 first and use the exact name `old-mac-to-new-mac-migration`.

---

## 3. Optional: Spot-check backup branches on GitHub

- In your browser, open a few of your 14 repos on GitHub.
- Confirm branch **backup-2025-02-22** exists where you expect it (repos that had local changes and were backed up).

---

## Done on the old Mac

After step 2 (and optionally step 3), you're finished on the old Mac. Switch to the new Mac and follow the **README.md** in this repo (clone the repo, then follow GITHUB-SETUP-NEW-MAC.md and REPOS-TO-SYNC-REVIEW.md).
