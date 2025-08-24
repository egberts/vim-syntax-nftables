
# File: tests/fn/Makefile
# Description:
# Usage:
#    make (implied 'check')
#    make check  # all fn.nft files
#    make check add-counter.fn.nft
#    make lint
#    make highlight
#    make test (defaults to 'check')

.PHONY: check

DEFAULT_NFT_FILES := $(wildcard *.fn.nft)
VIM_FILES := $(wildcard *.vim)

check:
	@if ! sudo -v >/dev/null 2>&1; then \
		sudo /opt/nftables/sbin/nft --version; \
		echo "Need sudo for 'nft -c' check."; \
	fi; \
	if [ $(words $(MAKECMDGOALS)) -eq 2 ]; then \
		FILE="$(word 2, $(MAKECMDGOALS))"; \
		echo "Checking file: $$FILE"; \
		sudo /opt/nftables/sbin/nft -c -f "$$FILE"; \
	else \
		if [ -z "$(DEFAULT_NFT_FILES)" ]; then \
			echo "No .fn.nft file found."; \
			exit 1; \
		else \
			echo "Checking corpus test file(s): $(DEFAULT_NFT_FILES)"; \
			for f in $(DEFAULT_NFT_FILES); do \
				echo "Checking $$f"; \
				sudo /opt/nftables/sbin/nft -c -f "$$f" || exit 1; \
			done; \
		fi; \
	fi


test: $(DEFAULT_NFT_FILES)
	@for f in $^; do \
		echo "Checking $$NFT $$f"; \
		sudo /opt/nftables/sbin/nft --version; \
		sudo /opt/nftables/sbin/nft -c -f "$$f" || exit 1; \
	done

# Optional lint rule if you use a linter like `nftables` checker or `shellcheck`
lint: $(VIM_FILES)
	@for f in $^; do \
		echo "Checking $$f"; \
		vint "$$f" || exit 1; \
	done

highlight: $(DEFAULT_NFT_FILES)
	@for f in $^; do \
		echo "Highlight-checking $$NFT $$f (disabled)"; \
	done





# Prevent Make from trying to treat the filename as a Make target
%:
	@:

