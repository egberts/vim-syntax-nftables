" ~/.vim/syntax/nftables/add_table_cmd.vim

echo "~/.viim/syntax/nftables/add_table_cmd.vim: FAILED! Who's loading this?"
if exists('b:did_nftables_add_table_cmd_early')
  call nftables#syntax#log('INFO', 'Skipped add_table_cmd.vim (already loaded for buffer: ' . bufname('%') . ')')
  finish
endif


" Ensure autoload function is available
if !exists('*nftables#syntax#load')
  echomsg '[nftables#syntax][ERROR] Autoload function nftables#syntax#load not found at ' . v:throwpoint
  finish
endif
let b:did_nftables_add_table_cmd = 1

" Sub-file specific syntax
try
  syntax match nft_base_cmd_add_cmd_keyword_table '\vtable\ze\s' contained nextgroup=nft_add_cmd_table_spec_identifier
  syntax match nft_add_cmd_table_spec_identifier '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' contained
  call nftables#syntax#debug('Loading add_table_cmd.vim ...')
  echomsg 'syntax/nftables/add_table_cmd.vim: Loaded for buffer: ' . bufname('%')
catch
  call nftables#syntax#log('ERROR', 'Failed to load sub-syntax in ' . expand('<sfile>:t') . ': ' . v:exception)
endtry
let b:did_nftables_add_table_cmd_early = 1
