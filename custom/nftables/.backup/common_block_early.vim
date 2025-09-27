
if exists('g:nft_did_common_block_early')
  finish
endif

if exists('b:current_syntax') && b:current_syntax ==# 'nftables'
  finish
endif
let s:script_dir = expand('<sfile>:p:h')
call nftables#syntax#debug('common_block_early.vim: Loading common_block_early.vim ...' )

" Error if unexpected token appears after 'last'
hi link   nft_common_block_undefine_error nftHL_Error
syn match nft_common_block_undefine_error '\v[A-Za-z_][A-Za-z0-9_]{0,63}' contained

hi link   nft_common_block_stmt_separator nftHL_Separator
syn match nft_common_block_stmt_separator /;/ skipwhite contained


let g:nft_did_common_block_early = v:true
