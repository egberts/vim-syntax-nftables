To test the nftables.vim syntax highlighting, debugging scopes are divided into:

* script file execution
* syntax debugging
* colorization

Script File Execution
----
Simplest way to test is to expand logging:

```bash
vim --cmd 'let g:nft_debug=1' test_file.nft
```
Or make it permanent in your ~/.vimrc or ~/.vimrc/syntax/nftables.vim by adding:

```vim
let g:nft_debug=1
```

| log level | Details |
|----|----|
|  4 | emergency |
| 3 | error |
| 2 | notice |
| 1 | info |
| 0 | debug |

Syntax Debugging
---

Cannot do effective syntax debugging without the ~/.vim/plugin/Decho.vim. 

Download and install Decho from [here](https://www.vim.org/scripts/script.php?script_id=120).

Insert the Decho via <F10> function key in your ~/.vimrc:

```vim
" Hilinks.vim F10 key remapped
" This F10 key is MOST USEFUL in troubleshooting Vim syntax highlight logics
map <F10> : echo 'hi<'
\ . synIDattr(synID(line('.'),col('.'),1),'name') . '> trans<'
\ . synIDattr(synID(line('.'),col('.'),0),'name') . '> lo<'
\ . synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name') . '>'<CR>
set laststatus=2
```
`<F10>` shows you WHICH syntax line are caught and used at that particular cursor position of yours.  Also shows you which color highlighter is used.

`<F10>` assists you in tweaking your regex until "somethng clicks"; I liken this to Jenga blocks 

```vim
" Toggle reload of syntax files
" This F12 key is MOST USEFUL in reloading new/updated Vim syntax highlight file
noremap <F12> <Esc>:call <SID>nftables#syntax#reload()<CR>
inoremap <F12> <C-o>:call <SID>nftables#syntax#reload()<CR>
```

Your REPL is:

1. Vim-edit your firewall file (i.e., `/etc/nftables.conf`) for viewing-only
2. In second terminal console, Vim-edit your semantic file for tweaking (`~/.vim/syntax/nftables.vim` or its `custom/*.vim semantic file`)
3. Make the `syntax` or `highlight` change
4. Save change to semantic file.
5. Back to first terminal, the firewall viewing session, press `<F12>` button to reload syntax file
6. See result, go back to step 3 if not pretty enough


