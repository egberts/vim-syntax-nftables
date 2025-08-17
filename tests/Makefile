
NFT ?= nft

export MAKE
export NFT

SUBDIRS := tp
NFT_FILES := $(wildcard *.nft)
VIM_FILES := $(wildcard *.vim)

highlight: $(SUBDIRS)
	@for f in $^; do \
		echo "Running highlight in subdirectory $$f"; \
		make -C $$f highlight;  \
	done

check: $(SUBDIRS)
	@for f in $^; do \
		echo "Running check in subdirectory $$f"; \
		make -C $$f check;  \
	done

test: $(SUBDIRS)
	@for f in $^; do \
		echo "Running test in subdirectory $$f"; \
		make -C $$f test;  \
	done

# Optional lint rule if you use a linter like `nftables` checker or `shellcheck`
lint: $(VIM_FILES)
	@for f in $^; do \
		echo "Checking $$f"; \
		vint "$$f" || exit 1; \
	done



