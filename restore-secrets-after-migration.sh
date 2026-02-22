#!/usr/bin/env bash
# Restore secrets from ~/Repositories-secrets-export into ~/Repositories.
# Run on the NEW Mac after you have cloned all repos into ~/Repositories.
# Usage: bash restore-secrets-after-migration.sh
# Expects: ~/Repositories-secrets-export/ (from export-secrets-for-migration.sh on old Mac)

set -e
BASE="${HOME}/Repositories"
SRC="${HOME}/Repositories-secrets-export"

if [[ ! -d "$SRC" ]]; then
  echo "Error: $SRC not found. Unzip your secrets export there first (e.g. unzip Repositories-secrets-export.zip -d ~)."
  exit 1
fi

echo "Restoring secrets from $SRC into $BASE ..."
echo ""

copy_into() {
  local rel="$1"
  if [[ -e "$SRC/$rel" ]]; then
    mkdir -p "$(dirname "$BASE/$rel")"
    cp -R "$SRC/$rel" "$BASE/$rel" 2>/dev/null || cp "$SRC/$rel" "$BASE/$rel"
    echo "  restored: $rel"
  fi
}

for rel in \
  finance-agents/amortization/.env \
  finance-agents/amortization/data \
  tellen_client_news_agent/.env \
  tellen_client_news_agent/data/article_history.json \
  tellen_client_news_agent/data/clients.json \
  tellen_client_news_agent/data/settings.json \
  tellen_client_news_agent/data/users.json \
  ai-agent-factory/config/api-secrets.enc \
  ai-agent-factory/config/env \
  ai-agent-factory/.env \
  ai-agent-factory/scripts/mcp/.env \
  workforce-agent-proposal-generator/credentials \
  workforce-agent-proposal-generator/workforce-agent-proposal-generator/credentials \
  product-management/.env \
  auditor-job-posting-agent/.env \
  token-discovery/.claude/settings.local.json \
  App/.env \
  ; do
  copy_into "$rel"
done

echo ""
echo "Done. Verify each repo has the expected .env and data; see SECRETS-TRANSFER.md."
