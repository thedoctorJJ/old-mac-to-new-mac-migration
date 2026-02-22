# Transferring secrets, .env files, and local data (old Mac → new Mac)

These files were **intentionally excluded** from Git backups. You need to move them yourself in a secure way.

---

## What to transfer (by repo)

Paths under `/Users/jason/Repositories/` (or `~/Repositories/`). Only copy files that **exist** on the old Mac.

| Repo | Paths (relative to repo root) |
|------|--------------------------------|
| **finance-agents** | `amortization/.env`, `amortization/data/` (e.g. agreement.pdf, any data files) |
| **tellen_client_news_agent** | `.env`, `data/article_history.json`, `data/clients.json`, `data/settings.json`, `data/users.json` |
| **ai-agent-factory** | `config/api-secrets.enc`, `config/env/.env.local`, `config/env/.env.backup*`, `.env`, `scripts/mcp/.env`; if you use a master key: `config/.master-key` (not in repo, check docs) |
| **workforce-agent-proposal-generator** (outer) | `credentials/*.json` (Google service account keys; do **not** commit) |
| **workforce-agent-proposal-generator-inner** (inner project) | `credentials/*.json` (same; inner repo has its own `credentials/`) |
| **product-management** | `.env` (Atlassian etc.; use `.env.example` as template if missing) |
| **auditor-job-posting-agent** | `.env` if present |
| **token-discovery** | `.claude/settings.local.json` (local Cursor/editor settings) |
| **App** | Only `.env.sample` is in repo; copy any real `.env` or `.env.local` if you have one |

---

## Option A: Export folder (recommended)

On the **old Mac**, run the script that copies all known secret paths into one folder, then zip and transfer.

```bash
cd ~/Repositories/old-mac-to-new-mac-migration
bash export-secrets-for-migration.sh
```

This creates **`~/Repositories-secrets-export`** with the same directory layout (e.g. `finance-agents/amortization/.env`). Then:

1. **Zip it** (use a strong passphrase if you store it in the cloud):
   ```bash
   cd ~
   zip -er Repositories-secrets-export.zip Repositories-secrets-export
   ```
2. **Transfer** the zip via USB drive, or encrypted cloud (iCloud, Dropbox, etc.).
3. **On the new Mac:** Unzip somewhere safe, then copy each subfolder into the right repo under `~/Repositories` after you’ve cloned the repos. Example:
   ```bash
   cp -r ~/Repositories-secrets-export/finance-agents/amortization/.env ~/Repositories/finance-agents/amortization/
   cp -r ~/Repositories-secrets-export/finance-agents/amortization/data ~/Repositories/finance-agents/amortization/
   # ... repeat for each repo
   ```
   Or use the **restore** script if provided (see script header).

---

## Option B: Encrypted tarball

On the **old Mac** (replace `SECRETS_PASSPHRASE` with a strong passphrase you’ll remember):

```bash
cd ~/Repositories
tar cf - \
  finance-agents/amortization/.env \
  finance-agents/amortization/data \
  tellen_client_news_agent/.env \
  tellen_client_news_agent/data \
  ai-agent-factory/config/api-secrets.enc \
  ai-agent-factory/config/env \
  ai-agent-factory/.env \
  ai-agent-factory/scripts/mcp/.env \
  workforce-agent-proposal-generator/credentials \
  workforce-agent-proposal-generator/workforce-agent-proposal-generator/credentials \
  product-management/.env \
  auditor-job-posting-agent/.env \
  token-discovery/.claude/settings.local.json \
  2>/dev/null | openssl enc -aes-256-cbc -out ~/Repositories-secrets.tar.enc
```

You’ll be prompted for a passphrase. Transfer `Repositories-secrets.tar.enc` to the new Mac.

**On the new Mac** (after cloning repos into `~/Repositories`):

```bash
cd ~/Repositories
openssl enc -d -aes-256-cbc -in ~/Repositories-secrets.tar.enc | tar xf -
```

Only copies files that were included in the tarball; paths are relative to `~/Repositories`.

---

## Option C: Manual copy

Copy each path from the table above from the old Mac (USB, AirDrop, or secure cloud) into the same path under `~/Repositories` on the new Mac after cloning. Use `.env.example` in repos that have one (e.g. product-management, tellen_client_news_agent) to recreate `.env` if you prefer to re-enter secrets on the new Mac.

---

## Option D: Password manager or secret store

- Put **contents** of important `.env` files (or key values) into a password manager (1Password, Bitwarden, etc.) on the old Mac.
- On the new Mac, create `.env` from `.env.example` and fill in values from the password manager. Use for API keys, tokens, DB URLs, etc.; not for large binary data (e.g. `amortization/data/` or credential JSON files), which are better transferred via Option A or B.

---

## After transfer

- **ai-agent-factory:** If you copied `config/api-secrets.enc` and use a master key, ensure the master key is available on the new Mac (same path or env the tool expects). Re-run sync/verify if you use cloud secrets: `./scripts/verify-secrets-sync.sh`.
- **workforce-agent-proposal-generator:** Ensure `credentials/*.json` (and inner repo’s `credentials/`) are in place and not committed to Git.
- Delete the export folder or encrypted file from the transfer medium after you’ve restored and verified on the new Mac.
