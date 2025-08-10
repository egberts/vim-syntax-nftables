" MIT License. Copyright (c) 2025 Egbert Network et al.
if exists('b:did_ftplugin')
    finish
endif
let b:did_ftplugin = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

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

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim: et ts=2 sts=2 sw=2
