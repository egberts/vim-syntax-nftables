" ~/.vim/ftdetect/nftables.vim
" Filetype detection for nftables files
" Detects files with .nft or nftables.conf extensions, or those with a #!/bin/nft shebang

" echom '[~/.vim/ftdetect/nftables][OK] Begin'
augroup nftables
  " echom "running autgroup nftables ~/.vim/ftdetect/nftables.vim Grok-as-is 20250925-1421CDT"
  autocmd!
  autocmd BufRead,BufNewFile *.nft,nftables.conf setlocal filetype=nftables

  " Looking for 'nft' shebang isn't worth it, commented out.
  " autocmd BufRead,BufNewFile * if getline(1) =~# '^#!\s*\%\(\/\S\+\)\?\/\%\(s\)\?bin\/\%\(env\s\+\)\?nft\>' | setlocal filetype=nftables | endif
augroup END

" echom '[~/.vim/ftdetect/nftables][OK] End'
