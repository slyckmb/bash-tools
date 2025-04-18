SHELL := /bin/bash
VALID_BRANCHES := main dev

## 🧪 Run test suite with Bats
test:
	bats ../bash-test-tools/tests/test_split_subdir_to_repo.bats

## 🧼 Run ShellCheck on main script
lint:
	shellcheck split_subdir_to_repo.sh

## 🔐 Apply protection to a branch (main or dev)
protect-%:
	@echo "🔐 Applying protection rules to branch: $*"
	@if ! echo "$(VALID_BRANCHES)" | grep -qw "$*"; then \
		echo "❌ Invalid branch '$*'. Allowed: $(VALID_BRANCHES)"; exit 1; \
	fi
	gh api --method PUT -H "Accept: application/vnd.github.v3+json" \
	  repos/:owner/:repo/branches/$*/protection \
	  --input .github/protection/$*.json

## 🧪 Temporarily relax protection rules (e.g., allow direct commits)
relax-%:
	@echo "🧪 Relaxing protection rules for branch: $*"
	@if ! echo "$(VALID_BRANCHES)" | grep -qw "$*"; then \
		echo "❌ Invalid branch '$*'. Allowed: $(VALID_BRANCHES)"; exit 1; \
	fi
	gh api --method PUT -H "Accept: application/vnd.github.v3+json" \
	  repos/:owner/:repo/branches/$*/protection \
	  --input .github/protection/$*-open.json

## 🕵️ View branch protection state (usage: make status-main)
status-%:
	@echo "🔍 Fetching protection for '$*'..."
	@if ! echo "$(VALID_BRANCHES)" | grep -qw "$*"; then \
		echo "❌ Invalid branch '$*'. Allowed: $(VALID_BRANCHES)"; exit 1; \
	fi
	gh api repos/:owner/:repo/branches/$*/protection | jq

## 🚀 Push dev branch to origin
push-dev:
	git push origin dev

## 🏷️ Tag a release (usage: make release TAG=rev4.3)
release:
ifndef TAG
	$(error ❌ Must provide TAG=revX.Y)
endif
	git tag $(TAG)
	git push origin $(TAG)

.PHONY: test lint protect-% relax-% push-dev release
