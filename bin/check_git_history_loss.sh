#!/bin/bash
# 🛡️ Git History Safety Checker for filter-repo split/move loss

set -euo pipefail
cd "${1:-.}"

echo "# 🔍 Git Rename History Integrity Check"
echo ""
echo "🗂 Repo: $(basename "$PWD")"
echo "📅 Date: $(date)"
echo "---------------------------------------"
echo ""

# Configurable threshold: history should be longer than 2 commits
MIN_COMMITS=3

while IFS= read -r -d '' file; do
  commit_count=$(git log --follow --oneline -- "$file" | wc -l)

  if (( commit_count < MIN_COMMITS )); then
    echo "⚠️  $file — only $commit_count commits (possible history loss)"
    git log --follow --oneline -- "$file" | sed 's/^/    /'
    echo ""
  fi
done < <(find . -type f -not -path "./.git/*" -print0)
