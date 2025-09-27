" ~/.vim/syntax/nftables/create_cmd.vim
if exists('b:did_nftables_create_cmd')
  echomsg 'syntax/nftables/create_cmd.vim: Skipped (already loaded for buffer: ' . bufname('%') . ')'
  finish
endif
let b:did_nftables_create_cmd = 1

try
  syntax match nft_base_cmd_create_cmd_keyword_table '\vtable\ze\s' contained nextgroup=nft_create_cmd_table_spec_identifier
  syntax match nft_create_cmd_table_spec_identifier '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' contained
  call nftables#syntax#debug('Loading create_cmd.vim ...')
  echomsg 'syntax/nftables/create_cmd.vim: Loaded for buffer: ' . bufname('%')
catch
  echomsg 'syntax/nftables/create_cmd.vim: ERROR: ' . v:exception . ' at ' . v:throwpoint
endtry
