This README covers the 'tests' subdirectory.

Notable subdirectories are:

  tp, true-positive - Error-free highlighted NFT script that are properly CLI-valid.
  tn, true-negative - Red highlighted NFT script that failed CLI validity.
  fn, false-negative - Red highlighted NFT script that are properly CLI-valid.
  fp, false-positive - Error-free highlighted NFT script that failed CLI validitiy.

Most test files' naming convention are derived from the
semantic action label defined in the Bison parser:

    netfilters/nftable/src/parser_bison.y source file.

Validate vim-syntax-nftables:

    cd tests
    make test

