
NFT_FILES := $(wildcard *.nft)
VIM_FILES := $(wildcard *.vim)

test: $(NFT_FILES)
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


install:
	install -v -D -d ~/.vim/autoload
	install -v -D -d ~/.vim/autoload/nftables
	install -v nftables/syntax.vim ~/.vim/autoload/nftables

uninstall:
	rm -r ~/.vim/autoload/nftables
