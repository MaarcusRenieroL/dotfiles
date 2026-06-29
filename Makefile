DOTFILES := $(HOME)/dotfiles
BREWFILE := $(DOTFILES)/brew/Brewfile

.DEFAULT_GOAL := help

.PHONY: help install link brew brew-check macos doctor update dump clean

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

install: ## Full bootstrap (brew, omz, tpm, links). Prompts for macOS defaults.
	@bash $(DOTFILES)/install.sh

link: ## (Re)create all symlinks only
	@bash $(DOTFILES)/scripts/link.sh

brew: ## Install everything in the Brewfile
	@brew bundle --file $(BREWFILE)

brew-check: ## Report unmet Brewfile dependencies
	@brew bundle check --file $(BREWFILE) --verbose || true

macos: ## Apply macOS system defaults
	@bash $(DOTFILES)/scripts/macos.sh

doctor: ## Run health checks
	@bash $(DOTFILES)/scripts/doctor.sh

update: ## Update brew packages + tmux/nvim plugins
	@brew update && brew upgrade && brew bundle --file $(BREWFILE) && brew cleanup
	@nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
	@"$(HOME)/.tmux/plugins/tpm/bin/update_plugins" all 2>/dev/null || true

dump: ## Snapshot currently-installed brew packages into the Brewfile
	@brew bundle dump --file $(BREWFILE) --force --describe
	@echo "Brewfile updated — review the diff before committing."

clean: ## Remove editor/OS junk from the repo
	@find $(DOTFILES) -name '.DS_Store' -delete -o -name '*.sw[op]' -delete
	@echo "cleaned."
