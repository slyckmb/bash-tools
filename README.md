cat > README.md <<'EOF'
# bash-tools

CLI scripts for Bash automation and tooling.

This repo currently contains:

- **`split_subdir_to_repo.sh`**  
  Extract a subdirectory from a Git monorepo into a new standalone GitHub repository, preserving history and optionally copying a virtualenv.

## 🛠️ Tool Usage

```bash
./split_subdir_to_repo.sh <subdir> <target-dir-name> <github-repo-name> [--repo <path>] [--dryrun]
