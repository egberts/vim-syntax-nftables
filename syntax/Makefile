# Makefile for the syntax subdirectory
.PHONY: all test lint install uninstall help check highlight

# Default to ~/.vim/syntax, but respect DESTDIR for packaging
VIM_BASE_DIR := $(DESTDIR)/.vim
VIM_SYNTAX_DIR := $(VIM_BASE_DIR)/syntax
INSTALL_DIR_SYNTAX_COMPONENTS := $(VIM_SYNTAX_DIR)/nftables

# Files to manage (assuming test files are in the syntax dir for this Makefile)
NFT_FILES := $(wildcard *.nft)
VIM_FILES := $(wildcard *.vim)

# --- Installation Targets ---

install:
	@echo "Installing main syntax files into $(VIM_SYNTAX_DIR)"
	# 1. Create target directories
	install -v -D -d $(INSTALL_DIR_SYNTAX_COMPONENTS)
	
	# 2. Install main syntax file (nftables.vim) into the parent directory
	# This file is what Vim's filetype detection will load first.
	install -v nftables.vim $(VIM_SYNTAX_DIR)
	
	# 3. Install all component files from the 'nftables/' subdirectory
	# These are the 42+ files sourced by nftables.vim
	cp -R nftables/*.vim $(INSTALL_DIR_SYNTAX_COMPONENTS)

uninstall:
	@echo "Uninstalling syntax files from $(VIM_SYNTAX_DIR)"
	# Remove the main syntax file
	rm -f $(VIM_SYNTAX_DIR)/nftables.vim
	# Remove the component directory (rm -rf is necessary for subdirectories)
	rm -rf $(INSTALL_DIR_SYNTAX_COMPONENTS)

# --- Testing Targets ---

# Use the exported $(NFT) variable for checking
test: $(NFT_FILES)
	@echo "Testing syntax files with $(NFT)"
	# Execute the nftables checker using the path passed from the root Makefile
	@for f in $^; do \
		echo "Checking $$f"; \
		sudo $(NFT) -c -f "$$f" || exit 1; \
	done

lint: $(VIM_FILES)
	@echo "Linting Vim files..."
	@for f in $^; do \
		echo "Checking $$f"; \
		vint "$$f" || exit 1; \
	done

# Placeholder targets required by the parent Makefile loop (to prevent failure)
check highlight:
	@echo "$@ not implemented for $(@D) subdirectory."
	@exit 0

help:
	@echo "Help for syntax subdirectory"
	@echo " "
	@echo "   install   - Install nftables.vim and all component files."
	@echo "   uninstall - Remove all installed files."
	@echo "   test      - Run 'nft -c' checks using the exported NFT binary."
	@echo "   lint      - Run vint linter on all Vimscript files."
