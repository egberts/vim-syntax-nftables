This document details the unit testing of passing arguments to the nftables syntax highlighting using:

1.  Vim editor `-c` and `--cmd` command line arguments.
2.  ~/.vimrc settings
3.  ~/.vim/syntax/nftables.vim hardcoded

The goal is to ensure that the following are user-definable:

- `nft_debug`
- `colorscheme`
- `background`

Typical passing of user-defined settings are done:


    vim --cmd 'colorscheme desert' test.txt

    vim --cmd 'let nft_debug=1' test.txt

    vim --cmd 'set background=dark' test.txt

And combination thereof.

Test Plan - Colorscheme
====

By CLI
----
To pass a user-selected colorscheme to Vim, execute:

    vim --cmd 'colorscheme desert' test.txt

At editor prompt ':', execute `colorscheme` (or `colo`).

If result matches what CLI received, then it is a pass.

By Config
----
To pass a user-selected colorscheme via Vim configuration file, execute:

```bash
vim ~/.vimrc
```

Insert in file:

```vim
colorscheme elford
```

In a second console, edit any text file.

At editor prompt ':', execute `colorscheme` (or `colo`).

If result matches what the configuration file has set, then it is a pass.

By Nftables plugin
----
TBD


