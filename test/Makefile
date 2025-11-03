
NFT ?= nft

export MAKE
export NFT

SUBDIRS := tp
NFT_FILES := $(wildcard *.nft)
VIM_FILES := $(wildcard *.vim)

test: $(SUBDIRS)
	@for f in $^; do \
		echo "Running test in subdirectory $$f"; \
		make -C $$f test;  \
	done

check: $(SUBDIRS)
	@for f in $^; do \
		echo "Running check in subdirectory $$f"; \
		make -C $$f check;  \
	done

highlight: $(SUBDIRS)
	@for f in $^; do \
		echo "Running highlight in subdirectory $$f"; \
		make -C $$f highlight;  \
	done

# Optional lint rule if you use a linter like `nftables` checker or `shellcheck`
lint: $(VIM_FILES)
	@for f in $^; do \
		echo "Checking $$f"; \
		vint "$$f" || exit 1; \
	done



