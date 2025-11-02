
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


install: nftables.vim
	install -D -d ~/.vim/ftplugin
	install nftables.vim ~/.vim/ftplugin/

uninstall: 
	rm ~/.vim/ftplugin/nftables.vim
