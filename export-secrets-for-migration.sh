#!/usr/bin/env bash
# Export secrets, .env files, and local data from ~/Repositories into a single folder
# for secure transfer to the new Mac. Run on the OLD Mac.
# Usage: bash export-secrets-for-migration.sh
# Creates: ~/Repositories-secrets-export/ (same directory layout as under Repositories)

set -e
BASE="${HOME}/Repositories"
OUT="${HOME}/Repositories-secrets-export"
rm -rf "$OUT"
mkdir -p "$OUT"

copy_if_exists() {
  local src="$1"
  local dest="$2"
  if [[ -e "$BASE/$src" ]]; then
    mkdir -p "$(dirname "$OUT/$dest")"
    cp -R "$BASE/$src" "$OUT/$dest" 2>/dev/null || cp "$BASE/$src" "$OUT/$dest"
    echo "  copied: $src"
  fi
}

echo "Exporting secrets from $BASE to $OUT ..."
echo ""

# finance-agents
copy_if_exists "finance-agents/amortization/.env" "finance-agents/amortization/.env"
[[ -d "$BASE/finance-agents/amortization/data" ]] && copy_if_exists "finance-agents/amortization/data" "finance-agents/amortization/data"

# tellen_client_news_agent
copy_if_exists "tellen_client_news_agent/.env" "tellen_client_news_agent/.env"
for f in article_history.json clients.json settings.json users.json; do
  copy_if_exists "tellen_client_news_agent/data/$f" "tellen_client_news_agent/data/$f"
done

# ai-agent-factory
copy_if_exists "ai-agent-factory/config/api-secrets.enc" "ai-agent-factory/config/api-secrets.enc"
[[ -d "$BASE/ai-agent-factory/config/env" ]] && copy_if_exists "ai-agent-factory/config/env" "ai-agent-factory/config/env"
copy_if_exists "ai-agent-factory/.env" "ai-agent-factory/.env"
copy_if_exists "ai-agent-factory/scripts/mcp/.env" "ai-agent-factory/scripts/mcp/.env"

# workforce-agent-proposal-generator (outer)
[[ -d "$BASE/workforce-agent-proposal-generator/credentials" ]] && copy_if_exists "workforce-agent-proposal-generator/credentials" "workforce-agent-proposal-generator/credentials"
# inner project
[[ -d "$BASE/workforce-agent-proposal-generator/workforce-agent-proposal-generator/credentials" ]] && copy_if_exists "workforce-agent-proposal-generator/workforce-agent-proposal-generator/credentials" "workforce-agent-proposal-generator/workforce-agent-proposal-generator/credentials"

# product-management
copy_if_exists "product-management/.env" "product-management/.env"

# auditor-job-posting-agent
copy_if_exists "auditor-job-posting-agent/.env" "auditor-job-posting-agent/.env"

# token-discovery
copy_if_exists "token-discovery/.claude/settings.local.json" "token-discovery/.claude/settings.local.json"

# App (only if you have a real .env, not just .env.sample)
[[ -f "$BASE/App/.env" ]] && copy_if_exists "App/.env" "App/.env"

echo ""
echo "Done. Export is in: $OUT"
echo "Next: zip it (e.g. zip -er ~/Repositories-secrets-export.zip Repositories-secrets-export) and transfer to the new Mac."
echo "On the new Mac, use restore-secrets-after-migration.sh (after cloning repos) or copy paths manually; see SECRETS-TRANSFER.md."
