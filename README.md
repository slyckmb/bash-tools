# bash-tools

CLI scripts for Bash automation and tooling.

This repo currently contains:

- **`split_subdir_to_repo.sh`**  
  Extracts a subdirectory from a Git monorepo into a new standalone GitHub repository, preserving history and optionally copying a virtualenv.

---

## 🔍 Test Coverage

- `split_subdir_to_repo.sh` — [`rev4.2`](https://github.com/slyckmb/bash-tools/releases/tag/rev4.2)
- Framework: [bats-core](https://github.com/bats-core/bats-core)
- Location: `bash-test-tools/tests/test_split_subdir_to_repo.bats`
- CI-safe: `gh`, `git`, and `git-filter-repo` calls stubbed  
- ✅ Last verified at [`rev4.2`](https://github.com/slyckmb/bash-tools/releases/tag/rev4.2)

---

## ✅ CI Status

[![CI](https://github.com/slyckmb/bash-tools/actions/workflows/test.yml/badge.svg)](https://github.com/slyckmb/bash-tools/actions/workflows/test.yml)

---

## 🛠️ Tool Usage

```bash
./split_subdir_to_repo.sh <subdir> <target-dir-name> <github-repo-name> [--repo <path>] [--target-dir <dir>] [--dryrun]
```

### Positional Args:
- `<subdir>`: Subdirectory inside monorepo to extract
- `<target-dir-name>`: Folder name to use for new extracted repo
- `<github-repo-name>`: Name of the GitHub repo to create via `gh`

### Optional Flags:
- `--repo <path>`: Path to source repo (defaults to current dir)
- `--target-dir <dir>`: Override where the extracted repo is created
- `--dryrun`: Print actions without executing them

### Example:
```bash
./split_subdir_to_repo.sh foo foo-repo slyckmb/foo-repo \
  --repo ~/src/monorepo \
  --target-dir /tmp/export \
  --dryrun
```
