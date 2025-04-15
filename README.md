cat > README.md <<'EOF'
# bash-tools

CLI scripts for Bash automation and tooling.

This repo currently contains:

- **`split_subdir_to_repo.sh`**  
  Extract a subdirectory from a Git monorepo into a new standalone GitHub repository, preserving history and optionally copying a virtualenv.

## 🛠️ Tool Usage

```bash
./split_subdir_to_repo.sh <subdir> <target-dir-name> <github-repo-name> [--repo <path>] [--dryrun]

### ✅ Test Coverage

- `split_subdir_to_repo.sh` — rev4
- Framework: [bats-core](https://github.com/bats-core/bats-core)
- Location: `bash-test-tools/tests/test_split_subdir_to_repo.bats`
- CI-safe: `gh`, `git`, and `git-filter-repo` calls stubbed

🧪 Covered:
- [x] --repo flag
- [x] --dryrun logic
- [x] --target-dir path override
- [x] Required tool validation

[![CI](https://github.com/slyckmb/bash-tools/actions/workflows/test.yml/badge.svg)](https://github.com/slyckmb/bash-tools/actions/workflows/test.yml)
