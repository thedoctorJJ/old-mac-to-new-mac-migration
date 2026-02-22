# Backup run summary (old Mac → GitHub)

**→ Repo-by-repo verification:** See **BACKUP-VERIFICATION-REPORT.md** (run 2025-02-22).

## ✅ Backup branches created and pushed (9 repos)

| Repo | Branch on GitHub |
|------|------------------|
| ai-agent-factory | `backup-2025-02-22` |
| finance-agents | `backup-2025-02-22` |
| md2googleslides | `backup-2025-02-22` |
| skeletonapp | `backup-2025-02-22` |
| tellen-design-system-css | `backup-2025-02-22` |
| tellen_client_news_agent | `backup-2025-02-22` |
| usig-testnet-one-pager | `backup-2025-02-22` |
| workforce-agent-proposal-generator | `backup-2025-02-22` |
| usig-token-lifecycle-diagrams | **pushed failed** (see below) |

---

## ⚠️ Issues to be aware of

### 1. usig-token-lifecycle-diagrams — push failed

- **Message:** `remote: Repository not found` for `https://github.com/USIG-Digital/usig-token-lifecycle-diagrams.git`
- **Meaning:** The backup commit exists **locally** on branch `backup-2025-02-22`, but it was **not** pushed to GitHub (repo missing, private, or you don’t have access).
- **What to do:**  
  - If you have access under a different org/user, update the remote and push:  
    `git remote set-url origin git@github.com:OWNER/usig-token-lifecycle-diagrams.git` then `git push -u origin backup-2025-02-22`.  
  - If the repo was deleted or you no longer need it, you can leave it; the backup is only on this Mac.

### 2. tellen-design-system-css & usig-testnet-one-pager — “pathspec 'main' did not match”

- **Meaning:** Those repos had **no commits on `main`** (first commit was on `backup-2025-02-22`). The script pushed the backup branch, then tried to switch back to `main` and failed.
- **Result:** Backup branch **is** on GitHub. Locally you’re still on `backup-2025-02-22` in those two repos. No data lost.
- **On the new Mac:** When you clone, use the branch you care about (e.g. `git clone -b backup-2025-02-22 ...` or clone then `git checkout backup-2025-02-22`). You can create `main` from that branch on GitHub if you want.

### 3. workforce-agent-proposal-generator — nested git repo

- **Meaning:** There is a folder `workforce-agent-proposal-generator` **inside** the repo that is itself a Git repo. Git added it as a **submodule** (reference only), not as full file content.
- **Result:** The backup branch on GitHub does **not** contain the inner project’s files; it only has a pointer. Cloning the outer repo on the new Mac will not give you the inner repo’s contents.
- **What to do (if you need that inner project on the new Mac):**  
  - Either clone the inner repo separately (if it has its own remote), or  
  - Copy the inner folder’s contents some other way (e.g. zip, cloud) before you leave this Mac.

### 4. token-discovery — no backup branch

- **Meaning:** The only local change was `.claude/settings.local.json`, which the script correctly **excluded**. So there was nothing left to commit; the script created then deleted `backup-2025-02-22`.
- **Result:** No backup branch for token-discovery. If you’re okay that the only difference was the excluded settings file, no action needed. If you had other local changes you wanted saved, they were not included.

### 5. ai-agent-factory — pre-commit SSL warning

- **Meaning:** Pre-commit tried to install a Node env and hit `SSL: CERTIFICATE_VERIFY_FAILED` (common with Python 3.13 on macOS). The **commit and push still succeeded**.
- **Result:** Backup is on GitHub. You can fix SSL/certs later (e.g. “Install Certificates.command” for Python) if you use pre-commit on this repo again.

---

## ✅ Skipped (as intended)

- generative-ai-for-beginners  
- tellen-marketing-june  
- vlc-fundraising-event-planner  

## ✅ Already clean (no backup needed)

- App  
- auditor-job-posting-agent  
- canton  
- product-management  

## 🔒 Excluded from commits (secrets / local data)

- **finance-agents:** amortization/.env, amortization/data/, __pycache__  
- **tellen_client_news_agent:** data/*.json, __pycache__, .pyc  

---

## Action checklist before you leave this Mac

1. **usig-token-lifecycle-diagrams:** If you still need this on GitHub, fix the remote (or create the repo) and run:  
   `cd /Users/jason/Repositories/usig-token-lifecycle-diagrams && git push -u origin backup-2025-02-22`
2. **workforce-agent-proposal-generator:** If you need the **inner** project’s files on the new Mac, copy or push that inner repo (or its contents) separately.
3. **token-discovery:** If you had important local changes besides `.claude/settings.local.json`, back them up manually (e.g. copy files or create a small commit and push to a branch).

After that, you’re set to switch to the new Mac and use **GITHUB-SETUP-NEW-MAC.md** and **OLD-MAC-BEFORE-YOU-SWITCH.md** as needed.
