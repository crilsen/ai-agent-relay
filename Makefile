# ai-agent-relay — developer tasks
#
# POSIX make. These targets assume `shellcheck` and `markdownlint-cli2` are
# installed, or run through `npx`/Docker when available.

SHELL := /bin/sh
MDFILES := $(shell find . -name '*.md' -not -path './.git/*' -not -path './node_modules/*')
SHELLSCRIPTS := $(wildcard .ai/adapters/*.sh) $(wildcard .ai/adapters/hooks/*.sh) $(wildcard .ai/adapters/hooks/*/*.sh)
TESTDIR := $(shell mktemp -d 2>/dev/null || echo /tmp/actx-test)

.PHONY: help lint lint-md lint-sh test test-bootstrap test-install clean

help:
	@echo "targets:"
	@echo "  make lint            run markdownlint and shellcheck"
	@echo "  make lint-md         markdownlint only"
	@echo "  make lint-sh         shellcheck only"
	@echo "  make test            run script tests in a temp directory"
	@echo "  make clean           remove temporary test output"

lint: lint-md lint-sh

lint-md:
	npx --yes markdownlint-cli2@0.14.0 "**/*.md" "#node_modules"

lint-sh:
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck $(SHELLSCRIPTS); \
	elif command -v docker >/dev/null 2>&1; then \
		docker run --rm -v "$(PWD):/mnt" -w /mnt koalaman/shellcheck:stable $(SHELLSCRIPTS); \
	else \
		echo "shellcheck not found (install it or Docker)"; exit 1; \
	fi

test: test-bootstrap test-install

test-bootstrap:
	@sh -n .ai/adapters/bootstrap.sh
	@mkdir -p "$(TESTDIR)/bootstrap/proj"
	@sh .ai/adapters/bootstrap.sh "$(TESTDIR)/bootstrap/proj" claude opencode
	@test -f "$(TESTDIR)/bootstrap/proj/AGENTS.md"
	@test -f "$(TESTDIR)/bootstrap/proj/README.md"
	@test -f "$(TESTDIR)/bootstrap/proj/.gitignore"
	@test -d "$(TESTDIR)/bootstrap/proj/.ai"
	@test -f "$(TESTDIR)/bootstrap/proj/.ai/adapters/install.sh"
	@test -f "$(TESTDIR)/bootstrap/proj/CLAUDE.md"
	@printf 'custom context\n' >> "$(TESTDIR)/bootstrap/proj/AGENTS.md"
	@sh .ai/adapters/bootstrap.sh "$(TESTDIR)/bootstrap/proj" claude
	@grep -q 'custom context' "$(TESTDIR)/bootstrap/proj/AGENTS.md"
	@test -f "$(TESTDIR)/bootstrap/proj/CLAUDE.md"
	@echo "bootstrap: ok"

test-install:
	@sh -n .ai/adapters/install.sh
	@mkdir -p "$(TESTDIR)/install/proj"
	@sh .ai/adapters/install.sh "$(TESTDIR)/install/proj" gemini codex cline crush
	@test -f "$(TESTDIR)/install/proj/GEMINI.md"
	@test -f "$(TESTDIR)/install/proj/.cline/rules/agents.md"
	@printf 'sentinel\n' > "$(TESTDIR)/install/proj/GEMINI.md"
	@sh .ai/adapters/install.sh "$(TESTDIR)/install/proj" gemini
	@grep -q sentinel "$(TESTDIR)/install/proj/GEMINI.md"
	@sh .ai/adapters/install.sh "$(TESTDIR)/install/proj" gemini-settings
	@test -f "$(TESTDIR)/install/proj/.gemini/settings.json"
	@sh .ai/adapters/hooks/kiro/install.sh "$(TESTDIR)/install/proj"
	@test -f "$(TESTDIR)/install/proj/.kiro/hooks/ai-agent-relay.json"
	@echo "install: ok"

clean:
	@rm -rf "$(TESTDIR)"
	@echo "cleaned $(TESTDIR)"
