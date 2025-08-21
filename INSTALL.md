# Installing vim-nftables Syntax Files (Gentoo Style)

Guide to get vim-nftables syntax highlighting up and running on Gentoo.

## Setup Vim Config

Ensure your `~/.vim` directory exists:

```bash
mkdir -p ~/.vim
```

Create necessary subdirs:

```bash
mkdir -p ~/.vim/{indent,ftdetect,ftplugin,syntax}
```

## Fetch and Install

Clone the repo from GitHub and copy files:

```bash
cd ~/src
git clone https://github.com/egberts/vim-nftables.git
cp -R vim-nftables/{indent,ftdetect,ftplugin,syntax}/* ~/.vim/{indent,ftdetect,ftplugin,syntax}/
```

## Verify Highlighting

Test the syntax highlighting with the provided file:

```bash
vim ~/src/vim-nftables/test/all-syntaxes-good.nft
```
