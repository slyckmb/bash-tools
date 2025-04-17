# 🧠 Rehydration Log — `split_subdir_to_repo.sh`

**File:** `split_subdir_to_repo.sh`  
**Project:** [bash-tools](https://github.com/slyckmb/bash-tools)  
**Purpose:** Extract a subdirectory from a monorepo into a standalone GitHub repo with full history preserved and optional virtualenv support.

---

## 📜 Full Revision History

### ✅ rev1 — Initial Version (glider-config)
- Location: `glider-config/bin/split_subdir_to_repo.sh`
- Features:
  - Extracts a subdirectory into a new Git repo using `git filter-repo`
  - Optional `.venv` folder copy
  - Uses `gh repo create` to publish to GitHub
  - Supports `--dryrun` mode
- Commit Message:
  ```
  split_subdir_to_repo.sh rev1
  Purpose: Extract a Git subdirectory into a new repo with full history,
           optionally copy a .venv, and publish to GitHub using `gh`.
  ```

---

### ✅ rev2 — CLI Improvements
- Refactored to support:
  - `--repo <path>`: Allow script to run from outside the source repo
  - Improved tool validation (check for `git`, `gh`, `git-filter-repo`)
  - Proper handling of dry run output and path validation
  - Introduced strict CLI argument parsing
- Commit Message:
  ```
  split_subdir_to_repo.sh rev2: add --repo flag, tool check ordering, dryrun fix
  ```

---

### ✅ rev3 — Extracted with Full Git History
- Used `git filter-repo` with `--path` to preserve all revisions from:
  - `bin/split_subdir_to_repo.sh`
  - `bash-tools/split_subdir_to_repo.sh`
- Flattened nested layout after initial history import
- Commit Messages:
  ```
  rev3: extracted from glider-config with full history preserved
  normalize: move split_subdir_to_repo.sh to repo root after nested filter-repo layout
  ```

---

### ✅ rev4 — `--target-dir` Support + Hardened Script
- Status: **COMMITTED**
- Type: **Patch-Level Enhancement**
- Purpose: Allow user-defined destination for the extracted repo
- Flag Added:
  ```bash
  --target-dir <path>
  ```
- Behavior:
  - If set: override default target parent directory
  - If not set: fallback to `dirname($SRC_REPO_ROOT)`
- Additional Improvements:
  - `set -euo pipefail` added for bash safety
  - Tool check messages include install hints
  - Defensive quoting for all variables
  - Dry run output aligned and made shell-safe
  - GitHub URL fallback if `gh repo view` fails
- All changes documented in-place with `# rev4:` comments
- Maintains 100% backward compatibility with rev2/3

---

## 🧪 Bats Test Coverage (rev2 → rev4)

**Test File:** `tests/test_split_subdir_to_repo.bats`  
**Test Framework:** [`bash-test-tools`](https://github.com/slyckmb/bash-test-tools)

### ✅ Covered Scenarios
- Dry run output shows all planned commands (`--dryrun`)
- Invalid subdir handling shows clear error
- Missing tool simulation with `PATH=""`

### ✅ Enhancements in rev4 Tests
- Portable script path detection (`SCRIPT_PATH`)
- Dry run output includes `.venv` copy check
- All test state isolated in `mktemp` workspace
- Git repo initialized with mock `.venv` and content

### 📂 Structure
```txt
tests/
└── test_split_subdir_to_repo.bats
```

### 🔍 Sample Invocation
```bash
bats tests/test_split_subdir_to_repo.bats
```

---

## 🔮 rev5 — Full History Rehydration Mode (Planned)

### 🔍 Problem
Using:
```bash
git filter-repo --subdirectory-filter "$SUBDIR"
```
drops file history from earlier paths if a file moved directories.

### ✅ Proposed Fix
Use `--path` and `--path-rename`:
```bash
git filter-repo \
  --path bin/split_subdir_to_repo.sh:split_subdir_to_repo.sh \
  --path bash-tools/split_subdir_to_repo.sh:split_subdir_to_repo.sh \
  --force
```

### 🚧 Flag Proposal
```bash
--merge-paths "bin/foo.sh:foo.sh" "tools/foo.sh:foo.sh"
```

### 🧠 Future Enhancements
- Auto-discover historical file paths via `git log --follow`
- Add commit count diagnostics
- Generate a rehydration report

---

## 🗂 Suggested Repo Layout

```txt
bash-tools/
├── split_subdir_to_repo.sh        # Main script (rev4)
├── tests/
│   └── test_split_subdir_to_repo.bats  # Bats tests
├── Makefile
├── README.md
├── .gitignore
└── REHYDRATION.md                 # ← This file
```

---

## 🔗 Related Repos

- 📦 [`glider-config`](https://github.com/slyckmb/glider-config): original monorepo source  
- 🧪 [`bash-test-tools`](https://github.com/slyckmb/bash-test-tools): reusable Bats helpers  
- 🧰 [`bash-tools`](https://github.com/slyckmb/bash-tools): current home of this script
