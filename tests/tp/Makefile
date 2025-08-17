

.PHONY: check

NFT_FILES := $(wildcard *.tp.nft)
VIM_FILES := $(wildcard *.vim)

highlight: $(NFT_FILES)
	@for f in $^; do \
		echo "Highlight-checking $$NFT $$f (disabled)"; \
	done



check: $(NFT_FILES)
	@for f in $^; do \
		echo "Checking $$f"; \
		sudo /opt/nftables/sbin/nft --version; \
		if ! sudo -v >/dev/null 2>&1; then \
			echo "Need sudo for 'nft -c' check."; \
		fi; \
		sudo /opt/nftables/sbin/nft -c -f "$$f" || exit 1; \
	done

test: $(NFT_FILES)
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



