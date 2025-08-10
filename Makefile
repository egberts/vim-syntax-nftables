


.PHONY: all test lint

# Run tests in tests/ subdirectory
test:
	$(MAKE) -C tests test
#
#   # Run linter in parent and tests directories
lint:
	$(MAKE) -C syntax lint
	$(MAKE) -C ftdetect lint
	$(MAKE) -C ftplugin lint
	$(MAKE) -C indent lint
	$(MAKE) -C tests lint



