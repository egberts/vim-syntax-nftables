


.PHONY: all test lint check highlight

export MAKE
export NFT

SUBDIRS := ftdetect ftplugin indent autoload custom syntax

NFT := /usr/sbin/nft

# Run lint in tests/ subdirectory
highlight:
	@echo "Running highlight in tests ..."
	$(MAKE) -C tests highlight

check:
	@echo "Running lint in tests ..."
	$(MAKE) -C tests check

# Run test in tests/ subdirectory
test:
	@echo "Running test in tests ..."
	$(MAKE) -C tests test
#
#   # Run linter in parent and tests directories
lint:
	$(MAKE) -C syntax lint
	$(MAKE) -C ftdetect lint
	$(MAKE) -C ftplugin lint
	$(MAKE) -C indent lint
	$(MAKE) -C tests lint

install:
	for dir in $(SUBDIRS); do \
	    $(MAKE) -C $$dir install DESTDIR=$(DESTDIR); \
	done

uninstall:
	for dir in $(SUBDIRS); do \
	    $(MAKE) -C $$dir uninstall DESTDIR=$(DESTDIR); \
	done

help:
	@echo "Help for vim-syntax-nftables"
	@echo " "
	@echo "   install - Install this into your ~/vim/*"
	@echo "   test    - Test the Vim syntax files against 'nft -c' checker"
	@echo "   check    - Test the Vim syntax files"
	@echo "   highlight - Test the Vim highlight files"
	@echo "   test    - Test the Vim syntax files"
	@echo "   help    - Show this help"

