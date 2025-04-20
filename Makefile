SHELL := /bin/bash
VALID_BRANCHES := main dev
.DEFAULT_GOAL := help

## 📖 Show this help message
help: ## 📖 Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?##' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "🛠  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

## 🧪 Run test suite with Bats
test: ## 🧪 Run test suite with Bats
	bats ../bash-test-tools/tests/test_split_subdir_to_repo.bats

## 🧼 Run ShellCheck on main script
lint: ## 🧼 Run ShellCheck on main script
	shellcheck bin/split_subdir_to_repo.sh

## 🔐 Apply protection to a branch (main or dev)
protect-%: ## 🔐 Apply full protection rules to % branch
	@echo "🔐 Applying protection rules to branch: $*"
	@if ! echo "$(VALID_BRANCHES)" | grep -qw "$*"; then \
		echo "❌ Invalid branch '$*'. Allowed: $(VALID_BRANCHES)"; exit 1; \
	fi
	gh api --method PUT -H "Accept: application/vnd.github.v3+json" \
	  repos/:owner/:repo/branches/$*/protection \
	  --input .github/protection/$*.json

## 🧪 Temporarily relax protection rules (e.g., allow direct commits)
relax-%: ## 🧪 Relax protection rules for % branch
	@echo "🧪 Relaxing protection rules for branch: $*"
	@if ! echo "$(VALID_BRANCHES)" | grep -qw "$*"; then \
		echo "❌ Invalid branch '$*'. Allowed: $(VALID_BRANCHES)"; exit 1; \
	fi
	gh api --method PUT -H "Accept: application/vnd.github.v3+json" \
	  repos/:owner/:repo/branches/$*/protection \
	  --input .github/protection/$*-open.json

## 🕵️ View branch protection state (usage: make status-main)
status-%: ## 🕵️ Show branch protection config for % branch
	@echo "🔍 Fetching protection for '$*'..."
	@if ! echo "$(VALID_BRANCHES)" | grep -qw "$*"; then \
		echo "❌ Invalid branch '$*'. Allowed: $(VALID_BRANCHES)"; exit 1; \
	fi
	gh api repos/:owner/:repo/branches/$*/protection | jq

## 🚀 Push dev branch to origin
push-dev: ## 🚀 Push dev branch
	git push origin dev

## 🔐 Shortcut to apply protection to main
lock-main: protect-main ## 🔐 Shortcut to lock main

## 🧪 Shortcut to relax protection on main
unlock-main: relax-main ## 🧪 Shortcut to unlock main

## 🔐 Shortcut to apply protection to dev
lock-dev: protect-dev ## 🔐 Shortcut to lock dev

## 🧪 Shortcut to relax protection on dev
unlock-dev: relax-dev ## 🧪 Shortcut to unlock dev

## 🏷️ Create and push a git tag (usage: make release TAG=rev4.3)
release: ## 🏷️ Create and push a git tag (TAG=revX.Y)
ifndef TAG
	$(error ❌ Must provide TAG=revX.Y)
endif
	git tag $(TAG)
	git push origin $(TAG)

.PHONY: help test lint protect-% relax-% status-% push-dev lock-main unlock-main lock-dev unlock-dev release
