#!/bin/bash
#
# =====================================================================
# Script: split_subdir_to_repo.sh
# Purpose: Extract a Git subdirectory into a new repo with full history,
#          optionally copy a .venv, and publish to GitHub using `gh`.
# Usage:   ./split_subdir_to_repo.sh <subdir> <local-repo-name> <gh-repo-name> [-d|--dryrun]
# =====================================================================
SCRIPT_NAME="split_subdir_to_repo.sh"
SCRIPT_REV="rev1"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
DRYRUN=0

# --- Parse args ---
POSITIONAL=()
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dryrun)
            DRYRUN=1
            shift
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
set -- "${POSITIONAL[@]}"  # restore positional args

# --- Arg check ---
if [ "${#POSITIONAL[@]}" -ne 3 ]; then
    echo "Usage: $SCRIPT_NAME <subdir-to-extract> <target-local-repo-name> <github-repo-name> [-d|--dryrun]"
    exit 1
fi

SUBDIR="$1"
TARGET_DIR_NAME="$2"
GITHUB_REPO_NAME="$3"

# --- Paths ---
SRC_REPO_ROOT=$(git rev-parse --show-toplevel)
SRC_REPO_NAME=$(basename "$SRC_REPO_ROOT")
SRC_SUBDIR="$SRC_REPO_ROOT/$SUBDIR"
TARGET_PARENT_DIR=$(dirname "$SRC_REPO_ROOT")
TARGET_CLONE_PATH="$TARGET_PARENT_DIR/$TARGET_DIR_NAME"

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

# --- Dependencies ---
for tool in git-filter-repo gh git; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "❌ Required tool '$tool' is not installed. Exiting."
        exit 1
    fi
done

# --- Sanity checks ---
if [ ! -d "$SRC_SUBDIR" ]; then
    echo "❌ Subdirectory '$SUBDIR' not found at: $SRC_SUBDIR"
    exit 1
fi

if [ -d "$TARGET_CLONE_PATH" ]; then
    echo "❗ Warning: Target path already exists and will be removed: $TARGET_CLONE_PATH"
    if [ "$DRYRUN" -eq 0 ]; then
        rm -rf "$TARGET_CLONE_PATH" || { echo "❌ Failed to remove existing $TARGET_CLONE_PATH"; exit 1; }
        echo "✔ Removed $TARGET_CLONE_PATH"
    fi
fi

# --- Dryrun output ---
if [ "$DRYRUN" -eq 1 ]; then
    echo "🧪 Dry Run: Planned actions"
    echo "-------------------------------------------------"
    echo "rm -rf $TARGET_CLONE_PATH"
    echo "git clone --no-local $SRC_REPO_ROOT $TARGET_CLONE_PATH"
    echo "cd $TARGET_CLONE_PATH"
    echo "git filter-repo --subdirectory-filter $SUBDIR"
    echo "cp -r $SRC_SUBDIR/.venv $TARGET_CLONE_PATH/.venv"
    echo "gh repo create $GITHUB_REPO_NAME --private --source=. --remote=origin --push"
    echo "-------------------------------------------------"
    echo "✅ Dry run complete. No actions were performed."
    echo
    exit 0
fi

# --- Clone repo ---
echo "📦 Cloning source repo to $TARGET_CLONE_PATH..."
git clone --no-local "$SRC_REPO_ROOT" "$TARGET_CLONE_PATH" || { echo "❌ Git clone failed"; exit 1; }
[ -d "$TARGET_CLONE_PATH/.git" ] || { echo "❌ Clone failed — no .git found"; exit 1; }

cd "$TARGET_CLONE_PATH"

# --- Filter repo ---
echo "🔍 Filtering history to subdirectory: $SUBDIR"
git filter-repo --subdirectory-filter "$SUBDIR" || { echo "❌ git filter-repo failed"; exit 1; }

# --- Check result ---
echo "🧪 Post-filter check:"
[ -f "hash_health.py" ] || { echo "❌ Expected file (e.g., hash_health.py) not found — something went wrong."; exit 1; }

# --- Copy venv ---
if [ -d "$SRC_SUBDIR/.venv" ]; then
    echo "📁 Copying .venv from $SRC_SUBDIR to new repo root"
    cp -r "$SRC_SUBDIR/.venv" "$TARGET_CLONE_PATH/.venv" || { echo "❌ Failed to copy .venv"; exit 1; }
    [ -f "$TARGET_CLONE_PATH/.venv/bin/activate" ] || { echo "❌ .venv copied but activate script not found"; exit 1; }
    echo "✔ .venv copied successfully"
else
    echo "ℹ️  No .venv found in source — skipping copy"
fi

# --- Create GitHub repo ---
echo "🌐 Creating GitHub repo and pushing..."
gh repo create "$GITHUB_REPO_NAME" --private --source=. --remote=origin --push || { echo "❌ GitHub repo creation failed"; exit 1; }

echo
echo "====================================================================="
echo "✅ $SCRIPT_NAME ($SCRIPT_REV) completed — $(date '+%Y-%m-%d %H:%M:%S')"
echo " New repo: https://github.com/$(gh repo view "$GITHUB_REPO_NAME" --json owner -q .owner.login)/$GITHUB_REPO_NAME"
echo "====================================================================="
