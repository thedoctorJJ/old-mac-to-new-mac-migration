#!/usr/bin/env bash
# List Git remotes in ~/Repositories and optionally switch origin from HTTPS to SSH.
# Usage:
#   bash github-remotes-to-ssh.sh                    # list all repos
#   bash github-remotes-to-ssh.sh --switch           # switch all HTTPS → SSH
#   bash github-remotes-to-ssh.sh --sync-only        # list only the 14 sync repos
#   bash github-remotes-to-ssh.sh --sync-only --switch  # switch only the 14 sync repos

# Uses ~/Repositories so it works on any Mac (edit if your path is different)
BASE="${HOME}/Repositories"
SWITCH=false
SYNC_ONLY=false
for arg in "$@"; do
  [[ "$arg" == "--switch" ]] && SWITCH=true
  [[ "$arg" == "--sync-only" ]] && SYNC_ONLY=true
done

# Same 14 repos as backup-before-migration.sh / REPOS-TO-SYNC-REVIEW.md
SYNC_REPOS=(App ai-agent-factory auditor-job-posting-agent canton finance-agents md2googleslides product-management skeletonapp tellen-design-system-css tellen_client_news_agent token-discovery usig-testnet-one-pager usig-token-lifecycle-diagrams workforce-agent-proposal-generator)

get_repos() {
  if [[ "$SYNC_ONLY" == true ]]; then
    printf '%s\n' "${SYNC_REPOS[@]}"
  else
    for dir in "$BASE"/*/; do
      [[ -d "$dir/.git" ]] || continue
      basename "$dir"
    done
  fi
}

while IFS= read -r repo; do
  dir="$BASE/$repo"
  [[ -d "$dir/.git" ]] || continue
  origin=$(cd "$dir" && git remote get-url origin 2>/dev/null) || continue
  if [[ "$origin" == https://github.com/* ]]; then
    # https://github.com/OWNER/REPO.git -> git@github.com:OWNER/REPO.git
    ssh_url="git@github.com:${origin#https://github.com/}"
    ssh_url="${ssh_url%.git}.git"
    echo "$repo"
    echo "  current: $origin"
    echo "  SSH:     $ssh_url"
    if [[ "$SWITCH" == true ]]; then
      (cd "$dir" && git remote set-url origin "$ssh_url" && echo "  -> switched to SSH")
    fi
    echo ""
  elif [[ "$origin" == git@github.com:* ]]; then
    echo "$repo (already SSH)"
    echo "  $origin"
    echo ""
  fi
done < <(get_repos)

if [[ "$SWITCH" == false ]]; then
  if [[ "$SYNC_ONLY" == true ]]; then
    echo "To switch these remotes to SSH, run: bash $0 --sync-only --switch"
  else
    echo "To switch all HTTPS remotes to SSH, run: bash $0 --switch"
  fi
fi
