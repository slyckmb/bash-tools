# 🧠 Rehydration Log — `split_subdir_to_repo.sh`

**File:** `split_subdir_to_repo.sh`  
**Project:** [bash-tools](https://github.com/slyckmb/bash-tools)  
**Purpose:** Extract a subdirectory from a monorepo into a standalone GitHub repo with full history preserved and optional virtualenv support.

---

## 📜 Full Revision History

### ✅ rev1 — Initial Version (glider-config)
- Origin: `glider-config/bin/split_subdir_to_repo.sh`
- Features:
  - Extract a subdirectory using `git filter-repo`
  - Optional `.venv` copy support
  - Publish to GitHub via `gh repo create`
  - `--dryrun` supported

---

### ✅ rev2 — CLI Enhancements
- Adds:
  - `--repo <path>` argument
  - Tool validation: `gh`, `git`, `git-filter-repo`
  - Dry run output fixes
  - Safer argument parsing

---

### ✅ rev3 — Historical Extraction & Layout Fix
- Used `git filter-repo --path` to extract with history
- Flattened from `bash-tools/bin` to root
- No functional changes

---

### ✅ rev4 — Hardened Script + `--target-dir`
- Flag: `--target-dir <path>` lets user define destination directory
- Bash safety: `set -euo pipefail`, shell-quoting
- Tool check messages + fallback logic for `gh`
- CI-safe behavior
- Fully backward-compatible

**Stable CI Baseline**: [`rev4.2`](https://github.com/slyckmb/bash-tools/releases/tag/rev4.2)

---

## ✅ Test Coverage Summary

- Test file: `tests/test_split_subdir_to_repo.bats`
- Framework: [`bats-core`](https://github.com/bats-core/bats-core)
- Executed via [`bash-test-tools`](https://github.com/slyckmb/bash-test-tools)

### Covered Scenarios
- ✅ `--repo`, `--target-dir`, `--dryrun`
- ✅ Missing tool detection
- ✅ Output safety in CI workflows

---

## 🔮 rev5 (Planned): Full Historical Mode

Problem:  
`--subdirectory-filter` drops file history across path changes.

Proposed Fix:
```bash
git filter-repo \
  --path bin/foo.sh:foo.sh \
  --path tools/foo.sh:foo.sh
```

Optional CLI:
```bash
--merge-paths "bin/foo.sh:foo.sh" "tools/foo.sh:foo.sh"
```

---

## 🗂 Recommended Layout

```txt
bash-tools/
├── split_subdir_to_repo.sh
├── tests/test_split_subdir_to_repo.bats
├── Makefile
├── README.md
└── .history/REHYDRATION.md  ⬅ this file
```

---

## 🔗 Related Projects

- 🧪 [`bash-test-tools`](https://github.com/slyckmb/bash-test-tools)
- 🧰 [`glider-config`](https://github.com/slyckmb/glider-config)
