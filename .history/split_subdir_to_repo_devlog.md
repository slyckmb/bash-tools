# 🧾 Dev Log — `split_subdir_to_repo.sh` Evolution (Chat Summary)

**Date:** 2025-04-12  
**Context:** Refactor, extract, and modernize script from `glider-config` into a standalone `bash-tools` repo.

---

## ✅ Key Milestones

### 1. Finalized File Movement
- Moved `split_subdir_to_repo.sh` from `glider-config/bin/` into its own `bash-tools/` folder.
- Preserved commit history using `git filter-repo` with `--path`.
- Verified full history available via `git log --follow`.

---

### 2. Created New Repo: `bash-tools`
- Used the script itself to extract its own folder from `glider-config`.
- Validated using `--dryrun`, then executed live.
- Created `bash-tools-repo`, relocated it to `/mnt/projects/bash-tools`.

---

### 3. Cleaned Directory Structure
- Removed unnecessary `bash-tools/bash-tools/` nesting.
- Committed with:
  ```
  normalize: move split_subdir_to_repo.sh to repo root after nested filter-repo layout
  ```

---

### 4. GitHub Remote Setup
- Deleted prior `bash-tools` GitHub repo.
- Recreated with `gh repo create`.
- Fixed missing `origin` remote and completed push with full history.

---

### 5. Project Scaffold
- Added:
  - `.gitignore`
  - `Makefile`
  - `README.md`
- Commit message:
  ```
  docs: add README, Makefile, and .gitignore scaffolding
  ```

---

### 6. Rev4: Added `--target-dir`
- New flag `--target-dir` lets user define where to create the target repo.
- Falls back to parent of source repo if not specified.
- Patch-only change, fully backward-compatible.

---

### 7. Planned Rev5: Full History Rehydration
- Identified that `--subdirectory-filter` omits history across folder moves.
- Proposed:
  ```bash
  git filter-repo \
    --path bin/split_subdir_to_repo.sh:split_subdir_to_repo.sh \
    --path bash-tools/split_subdir_to_repo.sh:split_subdir_to_repo.sh \
    --force
  ```
- Optional future:
  - `--merge-paths` flag
  - Auto-discovery of paths using `git log --follow`

---

### 8. Created `bash-test-tools` Repo
- Extracted reusable Bats helpers from `/mnt/projects/scripts/tests/test_helper/`.
- Removed embedded `.git/` folders and cleaned structure.
- Re-added `bats-assert` and `bats-support` as regular folders.
- Final structure:
  ```
  tests/test_helper/
    ├── bats-assert/
    └── bats-support/
  ```
- Created for reuse via submodule or bind in testable Bash scripts.

---

## 🔗 Repositories Affected

- **`glider-config`** – original source repo
- **`bash-tools`** – current home of `split_subdir_to_repo.sh`
- **`bash-test-tools`** – Bats testing helper libraries

