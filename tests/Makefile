
NFT_FILES := $(wildcard *.nft)
TRUE_POSITIVE_NFT_FILES := $(wildcard tp/*.nft)
VIM_FILES := $(wildcard *.vim)

test: $(TRUE_POSITIVE_NFT_FILES)
	@for f in $^; do \
		echo "Checking $$f"; \
		sudo /usr/sbin/nft -c -f "$$f" || exit 1; \
	done

# Optional lint rule if you use a linter like `nftables` checker or `shellcheck`
lint: $(VIM_FILES)
	@for f in $^; do \
		echo "Checking $$f"; \
		vint "$$f" || exit 1; \
	done



