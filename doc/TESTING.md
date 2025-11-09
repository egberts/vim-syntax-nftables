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

Colorization
=====

The default colorscheme is 'default', and priority of settings by vim command line or ~/.vimrc is followed as:

| Priority | Scenario | Where it's Set | Affects | Resulting Colorscheme |
|----|----|----|----|----|
| 1 | colorscheme desert passed to CLI via vim --cmd | CLI | All files | desert (Highest priority, overrides all variables and filetype logic). |
| 2 | let g:nft_colorscheme='desert' passed to CLI via vim --cmd | CLI | .nft files | desert (This sets the variable, and the ftdetect logic uses it). |
| 3 | let g:default_colorscheme='desert' passed to CLI via vim --cmd | CLI | All files | desert (Overrides the value in ~/.vimrc for the initial setting). |
| 4 | let g:nft_colorscheme='desert' set in ~/.vimrc | ~/.vimrc | .nft files | desert (If no CLI argument is given, the ftdetect logic uses this). |
| 5 | let g:default_colorscheme='desert' set in ~/.vimrc | ~/.vimrc | All files | desert (If no CLI argument or g:nft_colorscheme is given, ~/.vimrc applies this). |
| 6 | colorscheme desert set without logic in ~/.vimrc | ~/.vimrc | All files | desert (Would normally be priority 3, but our robust logic prevents this from running if the CLI sets a scheme). |
| 7 (Fallback) | Default colorscheme is 'default' | Vim Internal | All files | default (Vim's internal fallback if no file is found). |

Note on Point 1 & 6: A naked colorscheme desert command inside your ~/.vimrc is generally avoided because it makes it impossible for the command line to override it easily. By wrapping the default setting with an if !exists('g:colors_name') check, we elevate the CLI to the highest priority.

An ideal settings in `~/.vimrc` would have the following code snippet:

```vim
" =======================================================
" 1. HARDCODED DEFAULT
" =======================================================
"let g:nft_debug=0

" This is the absolute fallback colorscheme for all TUI-based apps
let g:default_colorscheme = 'desert'

" =======================================================
" 2. OPTIONAL nftables OVERRIDE VARIABLE
" =======================================================
" Uncomment this line if you want to set a specific colorscheme for nftables
" If this exists, the ftdetect script will use it.
" let g:nft_colorscheme = 'elflord'
```
and


`ftdetect/nftables.vim`
----
The nftables-specific filetype detector will handle the `nft_colorscheme` with the following snippet of code:

```vim
" =======================================================
" COLORSCHEME OVERRIDE LOGIC
" =======================================================
" Apply the override ONLY if g:nft_colorscheme is set AND 
" the current colorscheme is still the hardcoded default (g:default_colorscheme),
" indicating no command-line override was used.

autocmd FileType nftables call s:ApplyNftablesColorscheme()

function! s:ApplyNftablesColorscheme() abort
    " Check 1: Is the override variable defined in ~/.vimrc?
    if !exists('g:nft_colorscheme')
        return
    endif
    
    " Check 2 (Command-Line Priority): Is the current colorscheme 
    " the one set by g:default_colorscheme? If not, the command line won.
    if exists('g:default_colorscheme') && g:colors_name ==# g:default_colorscheme
        try
            execute 'colorscheme' g:nft_colorscheme
        catch /^Vim:E185/
            echomsg 'Nftables colorscheme "' . g:nft_colorscheme . '" not found.'
        endtry
    endif
endfunction
```


```bash
vim -c 'colorscheme default' text.nft
```
