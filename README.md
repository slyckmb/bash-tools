# bash-tools

CLI scripts for Bash automation and tooling.

This repo currently contains:

- **`split_subdir_to_repo.sh`**  
  Extracts a subdirectory from a Git monorepo into a new standalone GitHub repository, preserving history and optionally copying a virtualenv.

---

## ✅ CI Status

[![CI](https://github.com/slyckmb/bash-tools/actions/workflows/test.yml/badge.svg)](https://github.com/slyckmb/bash-tools/actions/workflows/test.yml)

---

## 🛠️ Tool Usage

```bash
./split_subdir_to_repo.sh <subdir> <target-dir-name> <github-repo-name> [--repo <path>] [--dryrun]
