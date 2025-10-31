# vim-syntax-nftables

A Vim/Neovim syntax highlighter for [nftables](https://wiki.nftables.org/) configuration and script files.  

It highlights `nft` keywords, catches typos and invalid combinations, and works out-of-the-box with both `.nft` files and `#!nft` shebang scripts.

Railroad diagram for nftables in PDF format are [here](https://github.com/egberts/vim-syntax-nftables/blob/df5aa8805419c25122da15b23190b771513bf729/doc/nftables-railroad-chart.xhtml.pdf)

---

## Features

- Syntax highlighting for `nftables` configuration and script files
- Proactive error highlighting:
  - Invalid combinations and typos are shown in **red**
- Supports both:
  - Files with `.nft` extension
  - Files starting with `#!nft` shebang
- Works with Vim and Neovim
- Tested with dark/light color schemes
- Strictly LL(1), explosive deterministic syntax pathways, but it is complete.

---

## Screenshots

Default colorscheme (`:colorscheme default`, `set background=dark`):

![Screenshot](doc/screenshot.png)

Token-level highlighting:

![Tokens](doc/nftables-tokens-first-level.png)

Demo session:

![Demo](doc/nftables.gif)

Example animation:

![Example](test/nftables.gif "Example")

---

## Installation

See [INSTALL.md](https://github.com/egberts/vim-syntax-nftables/blob/master/INSTALL.md) for instructions on installing this syntax file into your local Vim/Neovim setup.

---

## Usage

Once installed, nftables syntax highlighting is automatically enabled for:

- `/etc/nftables.conf`
- `/etc/nftables*.conf`
- Files ending in `.nft` (anywhere)
- Scripts with a `#!nft` shebang

---

## Bug Reporting

If you run into highlighting issues:

1. Narrow down the problem to the minimal offending line(s).
   - You don’t need to share your entire `nftables.nft`, just delete as many lines as you can until the problem goes away and put that 1 line back in.
   - Please anonymize IP addresses, if needed.
2. Open an [issue](https://github.com/egberts/vim-syntax-nftables/issues) and include:
   - The offending line(s)
   - The incorrect highlight
   - What you expect instead
   - screenshots are best
3. You can also use a Gist to share longer snippets or screenshots.

---

## Debugging Vim Syntax

If you’d like to experiment with or debug the syntax file, see [DEBUG.md](https://github.com/egberts/vim-syntax-bind-named/blob/master/DEBUG.md).  
(Although written for `bind-named`, the debugging techniques apply here as well.)

---

## Notes for Vim Syntax Developers

While prototyping IPv6 address matching, I discovered a limitation in Vim 8.1 (still in v9.0).  
- It only supports a maximum of 9 groups of parentheses in regex matches, even when using `\%( … \)` instead of `\( … \)`.  
- To work around this, IPv6 patterns are duplicated in the syntax files. This workaround is faster in operation, eliminates backtracking, and avoids breaking matches.
- after passing 12,000 lines, it made most sense to start breaking up '.vim' files and adding loader support to each (for quickest error tracking).  Files are organized by its semantic name as explicitly defined in `nftables/src/parser_bison.y`/railroad-diagram to ensure that 100% syntax (via LL(1)) gets achieved.
---
