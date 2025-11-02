
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
	install -v -D -d ~/.vim/custom
	install -v -D -d ~/.vim/custom/nftables
	install -v -D -d ~/.vim/custom/nftables/add
	install -v -D -d ~/.vim/custom/nftables/limit
	install -v -D -d ~/.vim/custom/nftables/set
	install -v -D -d ~/.vim/custom/nftables/table
	install -v -D -d ~/.vim/custom/nftables/table/chain
	install -v -D -d ~/.vim/custom/nftables/table/chain/stmt
	install -v -D -d ~/.vim/custom/nftables/table/chain/stmt/expr
	install -v -D -d ~/.vim/custom/nftables/table/table_block
	cp -R nftables/* ~/.vim/custom/nftables/

uninstall:
	rm -r ~/.vim/custom/nftables
