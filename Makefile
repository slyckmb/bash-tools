
---

### ⚙️ 2. `Makefile`

```bash
cat > Makefile <<'EOF'
SHELL := /bin/bash

test:
	bats ../bash-test-tools/tests/test_split_subdir_to_repo.bats

lint:
	shellcheck split_subdir_to_repo.sh

.PHONY: test lint
EOF
