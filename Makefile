


.PHONY: all test lint check highlight

export MAKE
export NFT

SUBDIRS := ftdetect ftplugin indent autoload custom syntax doc

NFT := /usr/sbin/nft

# Run lint in tests/ subdirectory
highlight:
	@echo "Running highlight in tests ..."
	$(MAKE) -C test highlight

check:
	@echo "Running lint in tests ..."
	$(MAKE) -C test check

# Run test in tests/ subdirectory
test:
	@echo "Running test in tests ..."
	$(MAKE) -C test test
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

install-test:
	$(MAKE) -C test install DESTDIR=$(DESTDIR)

uninstall:
	for dir in $(SUBDIRS); do \
	    $(MAKE) -C $$dir uninstall DESTDIR=$(DESTDIR); \
	done

help:
	@echo "Help for vim-syntax-nftables"
	@echo " "
	@echo "   install - Install this into your ~/vim/* (except 'test' subdirectory)"
	@echo "   install-test - Install test nftables file into your ~/vim/test"
	@echo "   test    - Test the Vim syntax files against 'nft -c' checker"
	@echo "   check    - Test the Vim syntax files"
	@echo "   highlight - Test the Vim highlight files"
	@echo "   test    - Test the Vim syntax files"
	@echo "   help    - Show this help"

