
DESTDIR ?= ~

.PHONY: all test lint check highlight

export MAKE
export NFT

SUBDIRS := ftdetect ftplugin indent autoload syntax

NFT ?= /usr/sbin/nft
#    (Implemented, allowing easy user override.)

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
	$(MAKE) -C test test NFT=$(NFT)
#
#   # Run linter in parent and tests directories
lint:
	$(MAKE) -C syntax lint
	$(MAKE) -C ftdetect lint
	$(MAKE) -C ftplugin lint
	$(MAKE) -C indent lint

install:
	for dir in $(SUBDIRS); do \
	    @echo "Installing ${dir}/nftables.vim ..."; \
	    $(MAKE) -C $$dir install DESTDIR=$(DESTDIR); \
	done

install-test:
	$(MAKE) -C test install DESTDIR=$(DESTDIR)

uninstall:
	$(MAKE) -C syntax uninstall
	$(MAKE) -C ftdetect uninstall
	$(MAKE) -C ftplugin uninstall
	$(MAKE) -C indent uninstall
# Do not remove subdirectory here, leave those behind

help:
	@echo "rm is ${RM} Help for vim-syntax-nftables"
	@echo "make is ${MAKE} Help for vim-syntax-nftables"
	@echo "Help for vim-syntax-nftables"
	@echo " "
	@echo "   install - Install this into your ~/vim/* (except 'test' subdirectory)"
	@echo "   install-test - Install test nftables files into your ~/vim/test"
	@echo "   test         - Test the Vim syntax files against 'nft -c' checker."
	@echo "                  To use a custom binary, run: make test NFT=/path/to/my/nft"
	@echo "   check    - Test the Vim syntax files"
	@echo "   highlight - Test the Vim highlight files"
	@echo "   test    - Test the Vim syntax files"
	@echo "   help    - Show this help"

