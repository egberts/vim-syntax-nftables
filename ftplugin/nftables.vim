" ~/.vim/ftplugin/nftables.vim
"echom '[~/.vim/ftplugin/nftables][OK] Begin'
if exists('b:did_ftplugin')
  echomsg 'ftplugin/nftables.vim: Skipped (already loaded for buffer: ' . bufname('%') . ')'
  finish
endif

" don't put 'syntax enable'/'syntax sync fromstart' here, put it in syntax/nftables.vim
" echomsg 'ftplugin/nftables.vim: Applied for buffer: ' . bufname('%')

setlocal smartindent nocindent
setlocal commentstring=#%s
setlocal formatoptions-=t formatoptions+=croqnlj
setlocal comments=b:#
setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
setlocal textwidth=99

let b:undo_ftplugin = '
    \ setlocal formatoptions< comments< commentstring<
    \|setlocal tabstop< shiftwidth< softtabstop< expandtab< textwidth<
    \'

nnoremap <silent> <F12> :call nftables#syntax#reload()<CR>

let b:did_ftplugin = 1
"echom '[~/.vim/ftplugin/nftables][OK] End'
" vim: et ts=2 sts=2 sw=2
