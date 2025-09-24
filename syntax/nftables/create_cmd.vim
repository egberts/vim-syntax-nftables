
if exists('g:nft_did_create_cmd')
  finish
endif
let g:nft_did_create_cmd = v:true

if exists('b:current_syntax') && b:current_syntax ==# 'nftables'
  finish
endif
let s:script_dir = expand('<sfile>:p:h')
call nftables#syntax#debug('create_cmd.vim: Loading create_cmd.vim ...' )
