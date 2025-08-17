


.PHONY: all test lint check highlight

export MAKE
export NFT

NFT := /usr/sbin/nft

# Run lint in tests/ subdirectory
highlight:
	@echo "Running highlight in tests ..."
	$(MAKE) -C tests highlight

check:
	@echo "Running lint in tests ..."
	$(MAKE) -C tests check

lint:
	@echo "Running lint in tests ..."
	$(MAKE) -C tests lint

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



