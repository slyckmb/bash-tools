
---

### ⚙️ 2. `Makefile`

```bash
cat > Makefile <<'EOF'
SHELL := /bin/bash

test:
	bats tests

lint:
	shellcheck split_subdir_to_repo.sh

.PHONY: test lint
EOF
