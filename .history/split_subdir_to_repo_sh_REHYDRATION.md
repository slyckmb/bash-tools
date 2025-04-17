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

### 🛠️ rev4 — `--target-dir` Flag (In Progress)
- Purpose: Allow user-defined destination for the extracted repo
- New Flag:
  ```
  --target-dir <path>
  ```
- Behavior:
  - If set: override default parent directory
  - If not set: fallback to `dirname($SRC_REPO_ROOT)`
- Backward-compatible and additive
- Included in banner + dry run logic
- Integrated without breaking default GitHub publish behavior

---

### 🔮 rev5 — Full History Rehydration Mode (Planned)

#### 🔍 Problem:
Using:
```bash
git filter-repo --subdirectory-filter "$SUBDIR"
```
drops file history from earlier folders if a file has moved directories.

#### ✅ Proposed Fix:
Use `--path` and `--path-rename` instead:
```bash
git filter-repo \
  --path bin/split_subdir_to_repo.sh:split_subdir_to_repo.sh \
  --path bash-tools/split_subdir_to_repo.sh:split_subdir_to_repo.sh \
  --force
```

#### 🧠 Future Enhancements:
- Add `--merge-paths <src1:dest1> <src2:dest2>` flag to generalize path rehydration
- Auto-discover all historical paths using:
  ```bash
  git log --follow --name-only --pretty=format:
  ```
- Integrate commit-count verification after filtering for diagnostics
- Optionally generate a rehydration report post-split

---

## 🗂 Suggested Repo Organization

```
bash-tools/
├── split_subdir_to_repo.sh        # Main script
├── tests/
│   └── test_split_subdir_to_repo.bats
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

