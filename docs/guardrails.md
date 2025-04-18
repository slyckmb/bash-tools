# 🛡️ `guardrails.md` — Project Policies & Branch Protections

> Version-controlled governance for the [`bash-tools`](https://github.com/slyckmb/bash-tools) repo.  
> Tracks branch protection, CI practices, workflow policies, and repo standards.

---

## ✅ Active Branch Protections

### 🔐 `main` branch
- PRs required (no direct pushes)
- Dismiss stale reviews: ✅
- Admin enforcement: ✅
- Force pushes: ❌
- Deletion: ❌

🔧 Config File: `.github/protection/main.json`

### 🧪 `dev` branch
- PRs optional
- Force pushes: ✅
- No review required
- Admin enforcement: ❌

🔧 Config File: `.github/protection/dev.json`

---

## 📁 Policy File Structure

```txt
.github/
└── protection/
    ├── main.json         # Active protection rules
    ├── main-open.json    # Relaxed state (for direct commits)
    ├── dev.json          # Dev branch protection config
```

---

## 🧪 GitHub Actions CI

| Check         | Status   |
|---------------|----------|
| Bats Tests    | ✅       |
| ShellCheck    | ✅       |
| Lint + Test   | Triggered on every PR to `main` |

---

## 🛠️ Makefile Targets

Run tests:

```bash
make test
```

Apply protection:

```bash
make protect-main
make protect-dev
```

Temporarily relax protection:

```bash
make relax-main
```

Parameterized rules:

```bash
make protect-dev
make relax-main
```

Tag a release:

```bash
make release TAG=rev4.2
```

---

## 🔁 Automation Workflow (Solo Dev)

```bash
make relax-main      # allow direct commits
# make your changes, commits
make protect-main    # lock it back up
```

---

## 📚 CI Workflow File

Located at: `.github/workflows/test.yml`  
Contains:

- `bats` unit tests
- `shellcheck` linting
- CI badge shown in `README.md`

---

## 🔍 Branch Protection Review

To view current protection state:

```bash
gh api repos/:owner/:repo/branches/main/protection | jq
gh api repos/:owner/:repo/branches/dev/protection | jq
```

---

## 🔐 Enforcement Philosophy

- `main` is production: always gated, reviewed, test-verified
- `dev` is sandbox: flexibility for rapid iteration
- All rules tracked in Git for auditability
- Guards are automated via `Makefile` and GitHub CLI

---

## 🧠 Notes

- This system is optimized for a **solo developer** with discipline
- Future: tie enforcement to CI outputs for auto-harden/relax detection
- Updates to protection logic must be committed

---

## 🗂 Related Files

- `README.md`: High-level usage, CI badge, test info
- `CHANGELOG.md`: Semantic revision tracking
- `REHYDRATION.md`: Historical evolution of the script

