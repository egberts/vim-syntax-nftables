" ~/.vim/ftdetect/nftables.vim
" Filetype detection for nftables files
" Detects files with .nft or nftables.conf extensions, or those with a #!/bin/nft shebang
" echo 'ftdetect/nftables.vim: BEGIN'

" echom '[~/.vim/ftdetect/nftables][OK] Begin'
augroup nftables
  "echom "running autogroup nftables ~/.vim/ftdetect/nftables.vim"
  autocmd!
  autocmd BufRead,BufNewFile *.nft,nftables*.conf setlocal filetype=nftables

  " Looking for 'nft' shebang isn't worth it, commented out.
  " autocmd BufRead,BufNewFile * if getline(1) =~# '^#!\s*\%\(\/\S\+\)\?\/\%\(s\)\?bin\/\%\(env\s\+\)\?nft\>' | setlocal filetype=nftables | endif
augroup END

" echom '[~/.vim/ftdetect/nftables][OK] Midpoint'
"
" =======================================================
" COLORSCHEME OVERRIDE LOGIC
" =======================================================
" Apply the override ONLY if g:nft_colorscheme is set AND 
" the current colorscheme is still the hardcoded default (g:default_colorscheme),
" indicating no command-line override was used.

autocmd FileType nftables call s:ApplyNftablesColorscheme()

" echom '[~/.vim/ftdetect/nftables][OK] Midpoint 2'
function! s:ApplyNftablesColorscheme() abort
    " echo 'ftdetect/nftables.vim: s:ApplyNftablesColorscheme(): BEGIN'
    " Check 1: Is the override variable defined in ~/.vimrc?
    if !exists('g:nft_colorscheme')
        " echom "ftdetect/nftables.vim: g:nft_colorscheme does not exist; aborting ..."
        return
    endif

    " Check 2 (Command-Line Priority): Is the current colorscheme 
    " the one set by g:default_colorscheme? If not, the command line won.
    if exists('g:selected_colorscheme') && g:colors_name ==# g:selected_colorscheme
        try
            execute 'colorscheme' g:nft_colorscheme
        catch /^Vim:E185/
            echomsg 'Nftables colorscheme "' . g:nft_colorscheme . '" not found.'
        endtry
    endif
    " echo 'ftdetect/nftables.vim: s:ApplyNftablesColorscheme(): END'
endfunction

" echo 'ftdetect/nftables.vim: END'
