# Changelog

All notable changes to this project will be documented here.

---

## [rev4.2] - 2025-04-16

### Changed
- 🔁 Refactored `split_subdir_to_repo.sh` to remove unused variable `SRC_REPO_NAME`
- ✅ Confirmed CI workflow runs via GitHub Actions
- 🛠 Resolved merge conflict artifacts in script body
- 🔖 Tagged as [`rev4.2`](https://github.com/slyckmb/bash-tools/releases/tag/rev4.2)

---

## [rev4.1] - 2025-04-15

### Added
- 🧪 Added GitHub Actions CI support via `test.yml`
- 🧰 Installed `git-filter-repo` dependency for CI-safe testing

### Changed
- 🪛 Hardened Makefile with real tab characters

---

## [rev4.0] - 2025-04-15

### Added
- ➕ `--target-dir` flag for custom output directory override
- 📦 `set -euo pipefail` safety
- ❓ Tool validation (e.g., `gh`, `git`, `git-filter-repo`) with install hints

### Changed
- 🧹 Defensive quoting, inline comments
- 🧼 Dryrun behavior and output consistency

---

## [rev3] - 2025-04-14

### Added
- 📚 Full history extracted via `git filter-repo`
- 📂 File moved from nested `bash-tools/` into repo root

---

## [rev2] - 2025-04-13

### Added
- 🏗 Support for `--repo` external repo path injection
- 🧪 Improved testability and portability

---

## [rev1] - 2025-04-12

### Initial
- 🚀 `split_subdir_to_repo.sh` created
- ✅ Dryrun support and `.venv` copy
- 🧠 Purpose: Split subdir into new GitHub repo with full commit history

---

[rev4.2]: https://github.com/slyckmb/bash-tools/releases/tag/rev4.2
[rev4.1]: https://github.com/slyckmb/bash-tools/releases/tag/rev4.1
[rev4.0]: https://github.com/slyckmb/bash-tools/releases/tag/rev4.0
[rev3]: https://github.com/slyckmb/bash-tools/releases/tag/rev3
[rev2]: https://github.com/slyckmb/bash-tools/releases/tag/rev2
[rev1]: https://github.com/slyckmb/bash-tools/releases/tag/rev1
