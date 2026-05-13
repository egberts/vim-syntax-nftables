# Installing vim-nftables Syntax Files

Guide to get vim-nftables syntax highlighting up and running on a Linux platform.

## Fetch and Install

Clone the repo from GitHub and copy files:

```bash
cd /tmp
git clone https://github.com/egberts/vim-syntax-nftables.git
cd vim-syntax-nftables
```

## Setup 
You can install this either using 'make' or manual copying.

No support for live update because my network is offline.

## Setup

I offer two ways to set this up: manually or `make`.


### Setup (via Makefile)

To have Makefile install the Vim script files throughout your `~/.vim` subdirectories using only the `nftables.*` files, execute:

```bash
cd /tmp/vim-syntax-nftables
make install
```

### Setup (via Manual Copying)

Ensure your `~/.vim` directory exists:

```bash
mkdir -p ~/.vim
```

Create necessary subdirs:

```bash
mkdir -p ~/.vim/{indent,ftdetect,ftplugin,syntax}
```

## Copy the Files

Copy files:

```bash
cd /tmp/vim-syntax-nftables
cp -R vim-syntax-nftables/{indent,ftdetect,ftplugin,syntax}/* ~/.vim/{indent,ftdetect,ftplugin,syntax}/
```

## Verify Highlighting

Test the syntax highlighting with the provided file:

```bash
vim /tmp/vim-syntax-nftables/test/*.nft
```
or using your nftables configuration file:
```bash
vim /etc/nftables.conf
```

## Uninstalling

Hey, thank you for trying it out. I too offer a clean undo of what got installed, but I shall not delete any subdirectories because we never know which other Vim plugins went in and populated it.

Only Vimscript files installed by this package get deleted.

Maybe you also want to remove any global variable settings from your `~/.vimrc` or `~/.vim/*` setup script files, like `nft_debug=`, `nftables_syntax_disabled=`, `g:nft_colorscheme=`; I won't do those for you. :-D

```bash
make uninstall
```
