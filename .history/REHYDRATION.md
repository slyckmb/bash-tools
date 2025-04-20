# 🧠 Rehydration Log — `split_subdir_to_repo.sh`

**File:** `split_subdir_to_repo.sh`  
**Project:** [bash-tools](https://github.com/slyckmb/bash-tools)  
**Purpose:** Extract a subdirectory from a monorepo into a standalone GitHub repo with full history preserved and optional virtualenv support.

---

## 📜 Full Revision History

### ✅ rev1 — Initial Version (glider-config)
- **Origin:** `glider-config/bin/split_subdir_to_repo.sh`
- **Features:**
  - Extract subdirectory via `git filter-repo`
  - Optional `.venv` copy support
  - Auto-publish to GitHub using `gh repo create`
  - `--dryrun` support for safe previews

---

### ✅ rev2 — CLI Enhancements
- **Adds:**
  - `--repo <path>` and `--target-dir <path>` arguments
  - CLI tool validation (`gh`, `git`, `git-filter-repo`)
  - Safer quoting and argument parsing
  - Better `--dryrun` UX and messages

---

### ✅ rev3 — Layout + History Fix
- Migrated script to `bash-tools/` root
- Confirmed historical extraction via `--path` preserved history
- **No functional changes**, just layout and clarity

---

### ✅ rev4 — Hardened Script + Target Control
- Introduced: `--target-dir` for output control
- Bash: `set -euo pipefail` added
- Added fallbacks and guidance for `gh` availability
- Improved CI compatibility
- **Stable CI Baseline:** [`rev4.2`](https://github.com/slyckmb/bash-tools/releases/tag/rev4.2)

---

## ✅ Test Coverage Summary

- **Test File:** `tests/test_split_subdir_to_repo.bats`
- **Test Framework:** [`bats-core`](https://github.com/bats-core/bats-core)
- **Runner:** [`bash-test-tools`](https://github.com/slyckmb/bash-test-tools)

### Covered Scenarios
- ✅ `--repo`, `--target-dir`, `--dryrun`
- ✅ Missing tool handling
- ✅ Output validation in CI-safe mode
- ✅ Full end-to-end clone + split preview flow

---

## 🔮 rev5 (Planned) — True Historical Extraction

**Problem:**  
`--subdirectory-filter` erases history across `git mv` and renamed paths.

**Goal:**  
Extract the _true full history_ for a set of related files using manual path rewrites.

**Proposed Fix:**
```bash
git filter-repo \
  --path bin/foo.sh:foo.sh \
  --path tools/foo.sh:foo.sh
```

**Optional CLI Flag Idea:**
```bash
--merge-paths "bin/foo.sh:foo.sh" "tools/foo.sh:foo.sh"
```

🛡 This would allow preserving full Git lineage across directory moves.

---

## 🗂 Recommended Layout

```txt
bash-tools/
├── split_subdir_to_repo.sh
├── tests/test_split_subdir_to_repo.bats
├── Makefile
├── README.md
└── .history/
    └── REHYDRATION.md  ⬅ this file
```

---

## 🔗 Related Projects

- 🧪 [`bash-test-tools`](https://github.com/slyckmb/bash-test-tools)
- 🧰 [`glider-config`](https://github.com/slyckmb/glider-config)
- 🛠️ [`infra`](https://github.com/slyckmb/infra) — downstream result of subdir extraction
