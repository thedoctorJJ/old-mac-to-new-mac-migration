#!/usr/bin/env bash
# Backup all Git repos in ~/Repositories before machine migration.
# Run this script from your terminal (not from Cursor sandbox) so git write and push work.
# Usage: bash backup-before-migration.sh   (run from ~/Repositories or set BASE below)

set -e
BACKUP_DATE="2025-02-22"
BACKUP_BRANCH="backup-${BACKUP_DATE}"
# Uses ~/Repositories so it works on any Mac (edit if your path is different)
BASE="${HOME}/Repositories"
REPORT_CLEAN=()
REPORT_BACKED_UP=()
REPORT_EXCLUDED_SECRETS=()

# Only these repos will be processed (from REPOS-TO-SYNC-REVIEW.md). No others.
SYNC_REPOS=(
  "App"
  "ai-agent-factory"
  "auditor-job-posting-agent"
  "canton"
  "finance-agents"
  "md2googleslides"
  "product-management"
  "skeletonapp"
  "tellen-design-system-css"
  "tellen_client_news_agent"
  "token-discovery"
  "usig-testnet-one-pager"
  "usig-token-lifecycle-diagrams"
  "workforce-agent-proposal-generator"
)

# Exclude patterns: do not stage .env, secrets, node_modules, .pyc, __pycache__, .DS_Store, local data
# Repo-specific: workforce-agent-proposal-generator has a nested repo of the same name — do not add as gitlink
reset_excluded() {
  local repo="${1:-}"
  git diff --cached --name-only | grep -E 'node_modules|\.env$|\.env\.|\.pyc$|/__pycache__|\.DS_Store$|/\.DS_Store$|\.claude/settings\.local\.json|amortization/data|^data/.*\.json$' | while read -r f; do git reset -- "$f" 2>/dev/null; done
  git reset -- .env .DS_Store .claude/settings.local.json 2>/dev/null || true
  git diff --cached --name-only | grep -E '^\.env\.' | while read -r f; do git reset -- "$f" 2>/dev/null; done
  git reset -- amortization/.env amortization/data data/article_history.json data/clients.json data/settings.json 2>/dev/null || true
  # Do not add nested repo as gitlink (avoids "embedded git repository" and push conflicts)
  [[ "$repo" == "workforce-agent-proposal-generator" ]] && git reset -- workforce-agent-proposal-generator 2>/dev/null || true
}

do_backup() {
  local repo="$1"
  local dir="$BASE/$repo"
  if [[ ! -d "$dir/.git" ]]; then return; fi
  cd "$dir"
  local current_branch
  current_branch=$(git branch --show-current)
  # Check if there's anything to back up: uncommitted or untracked (excluding excluded)
  local status
  status=$(git status -s)
  local unpushed
  unpushed=$(git log "origin/${current_branch}"..HEAD --oneline 2>/dev/null || true)
  if [[ -z "$status" && -z "$unpushed" ]]; then
    REPORT_CLEAN+=("$repo")
    return
  fi
  # Create backup branch from current
  git checkout -b "$BACKUP_BRANCH" 2>/dev/null || git checkout "$BACKUP_BRANCH"
  git add -A
  reset_excluded "$repo"
  if ! git diff --cached --quiet; then
    git commit -m "Backup snapshot before moving to new machine"
    if git push -u origin "$BACKUP_BRANCH"; then
      REPORT_BACKED_UP+=("$repo")
    else
      echo "  -> push FAILED for $repo (see above)"
    fi
  else
    # Had changes but all were excluded (e.g. tellen_client_news_agent, token-discovery)
    case "$repo" in
      finance-agents) REPORT_EXCLUDED_SECRETS+=("$repo (amortization/.env, amortization/data/, __pycache__)");;
      token-discovery) REPORT_EXCLUDED_SECRETS+=("$repo (.claude/settings.local.json)");;
      tellen_client_news_agent) REPORT_EXCLUDED_SECRETS+=("$repo (data/*.json, __pycache__, .pyc)");;
    esac
    git rev-parse --verify "$current_branch" &>/dev/null && git checkout "$current_branch" || true
    git branch -D "$BACKUP_BRANCH" 2>/dev/null || true
    return
  fi
  # Excluded secrets report for repos we know have .env or similar (when we did commit)
  case "$repo" in
    finance-agents) REPORT_EXCLUDED_SECRETS+=("$repo (amortization/.env, amortization/data/, __pycache__)");;
    token-discovery) REPORT_EXCLUDED_SECRETS+=("$repo (.claude/settings.local.json)");;
    tellen_client_news_agent) REPORT_EXCLUDED_SECRETS+=("$repo (data/*.json, __pycache__, .pyc)");;
  esac
  # Switch back to original branch only if it exists (e.g. repos with no commits on main yet)
  git rev-parse --verify "$current_branch" &>/dev/null && git checkout "$current_branch" || true
}

# Process only the 14 repos in SYNC_REPOS.
for repo in "${SYNC_REPOS[@]}"; do
  echo "=== Processing $repo ==="
  do_backup "$repo" || echo "Warning: $repo had issues"
done

echo ""
echo "========== REPORT =========="
echo "Already clean (nothing to back up):"
printf '  %s\n' "${REPORT_CLEAN[@]}"
echo ""
echo "Backup branches created and pushed:"
printf '  %s\n' "${REPORT_BACKED_UP[@]}"
echo ""
echo "Repositories with potential secrets intentionally excluded from commit:"
printf '  %s\n' "${REPORT_EXCLUDED_SECRETS[@]}"
echo "========================================"
