#!/bin/bash
#
# =====================================================================
# Script: split_subdir_to_repo.sh
# Purpose: Extract a Git subdirectory into its own repo, copy .venv, and push to GitHub
# Rev: rev4.2
# =====================================================================

set -euo pipefail  # rev4: Fail fast and detect unset variables

SCRIPT_NAME="split_subdir_to_repo.sh"
SCRIPT_REV="rev4"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
DRYRUN=0
USER_PROVIDED_REPO=""
USER_PROVIDED_TARGET_DIR=""

# --- Tool checks ---
for tool in git-filter-repo gh git; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "❌ Required tool '$tool' is not installed. Please install it and retry. Exiting."  # rev4: Installation hint
        exit 1
    fi
done

# --- Parse args ---
POSITIONAL=()
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dryrun)
            DRYRUN=1
            shift
            ;;
        -r|--repo)
            USER_PROVIDED_REPO="$2"
            shift 2
            ;;
        --target-dir)  # rev4: allow override of target repo path
            USER_PROVIDED_TARGET_DIR="$2"
            shift 2
            ;;
        -*)
            echo "Unknown option: $1"
            exit 1
            ;;
        *)
            POSITIONAL+=("$1")
            shift
            ;;
    esac
done
set -- "${POSITIONAL[@]}"

# --- Validate positional args ---
if [ "${#POSITIONAL[@]}" -ne 3 ]; then
    echo "Usage: $SCRIPT_NAME [-d|--dryrun] [--repo <path>] [--target-dir <path>] <subdir> <local-repo-name> <gh-repo-name>"
    exit 1
fi

SUBDIR="$1"
TARGET_DIR_NAME="$2"
GITHUB_REPO_NAME="$3"

# --- Determine source Git repo root ---
if [ -n "$USER_PROVIDED_REPO" ]; then
    SRC_REPO_ROOT="$(realpath "$USER_PROVIDED_REPO")"
    if [ ! -d "$SRC_REPO_ROOT/.git" ]; then
        echo "❌ Provided path is not a valid Git repo: $SRC_REPO_ROOT"
        exit 1
    fi
else
    SRC_REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || {
        echo "❌ Could not determine Git repo root. Use --repo <path> or run from inside a repo."
        exit 1
    }
fi

SRC_SUBDIR="$SRC_REPO_ROOT/$SUBDIR"

# --- Determine target path ---
if [ -n "$USER_PROVIDED_TARGET_DIR" ]; then
    TARGET_CLONE_PATH="$(realpath -m "$USER_PROVIDED_TARGET_DIR")/$TARGET_DIR_NAME"  # rev4: custom target base dir
else
    TARGET_PARENT_DIR=$(dirname "$SRC_REPO_ROOT")
    TARGET_CLONE_PATH="$TARGET_PARENT_DIR/$TARGET_DIR_NAME"
fi

# --- Start banner ---
echo "====================================================================="
echo "🛠️  Running $SCRIPT_NAME ($SCRIPT_REV) — $TIMESTAMP"
echo "====================================================================="
echo " Source repo root  : $SRC_REPO_ROOT"
echo " Subdir to extract : $SUBDIR"
echo " Target clone path : $TARGET_CLONE_PATH"
echo " GitHub repo name  : $GITHUB_REPO_NAME"
echo " Dry run mode      : $DRYRUN"
echo

# --- Subdir check ---
if [ ! -d "$SRC_SUBDIR" ]; then
    echo "❌ Subdirectory '$SUBDIR' not found at: $SRC_SUBDIR"
    exit 1
fi

# --- If target already exists ---
if [ -d "$TARGET_CLONE_PATH" ]; then
    echo "❗ Target path already exists and will be removed: $TARGET_CLONE_PATH"
    if [ "$DRYRUN" -eq 0 ]; then
        rm -rf "$TARGET_CLONE_PATH" || { echo "❌ Failed to remove $TARGET_CLONE_PATH"; exit 1; }  # rev4: defensive quoting
        echo "✔ Removed $TARGET_CLONE_PATH"
    fi
fi

# --- Dry run summary ---
if [ "$DRYRUN" -eq 1 ]; then
    printf "%s\n" "🧪 Dry Run: Planned actions"
    printf "%s\n" "-------------------------------------------------"
    printf "rm -rf %s\n" "$TARGET_CLONE_PATH"
    printf "git clone --no-local %s %s\n" "$SRC_REPO_ROOT" "$TARGET_CLONE_PATH"
    printf "cd %s\n" "$TARGET_CLONE_PATH"
    printf "git filter-repo --subdirectory-filter %s\n" "$SUBDIR"
    printf "cp -r %s/.venv %s/.venv\n" "$SRC_SUBDIR" "$TARGET_CLONE_PATH"
    printf "gh repo create %s --private --source=. --remote=origin --push\n" "$GITHUB_REPO_NAME"
    printf "%s\n" "-------------------------------------------------"
    echo "✅ Dry run complete. No actions were performed."
    exit 0
fi

# --- Clone ---
echo "📦 Cloning repo..."
git clone --no-local "$SRC_REPO_ROOT" "$TARGET_CLONE_PATH" || { echo "❌ Git clone failed"; exit 1; }
cd "$TARGET_CLONE_PATH" || exit 1  # rev4: defensive quoting

# --- Filter ---
echo "🔍 Filtering history to subdirectory: $SUBDIR"
git filter-repo --subdirectory-filter "$SUBDIR" || { echo "❌ git filter-repo failed"; exit 1; }

# --- Check result ---
if [ ! -d ".git" ]; then
    echo "❌ Not a valid repo after filtering"
    exit 1
fi

# --- Copy venv ---
if [ -d "$SRC_SUBDIR/.venv" ]; then
    echo "📁 Copying .venv from $SRC_SUBDIR"
    cp -r "$SRC_SUBDIR/.venv" "$TARGET_CLONE_PATH/.venv" || { echo "❌ Failed to copy .venv"; exit 1; }
    echo "✔ .venv copied"
else
    echo "ℹ️  No .venv found in source"
fi

# --- GitHub push ---
echo "🌐 Creating GitHub repo and pushing..."
gh repo create "$GITHUB_REPO_NAME" --private --source=. --remote=origin --push || {
    echo "❌ GitHub repo creation failed"
    exit 1
}

# --- Done ---
GH_USER=$(gh repo view "$GITHUB_REPO_NAME" --json owner -q .owner.login 2>/dev/null || echo "<your-username>")  # rev4: fallback on failure
echo
echo "====================================================================="
echo "✅ $SCRIPT_NAME ($SCRIPT_REV) completed — $(date '+%Y-%m-%d %H:%M:%S')"
echo " New repo: https://github.com/$GH_USER/$GITHUB_REPO_NAME"
echo "====================================================================="
