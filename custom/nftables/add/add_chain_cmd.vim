" File: add_chain_cmd.vim
" Directory: custom/nftables/add/
" The imperative part of 'add chain'
" Not the declarative part of 'chain <chain_id> { ... }'
"
if exists('b:did_nftables_add_chain_cmd')
  call nftables#syntax#log('INFO', 'Skipped add_chain_cmd (already loaded for buffer: ' . bufname('%') . ')')
  finish
endif

" save the filespec of this script into a stack for logging purpose
let s:filepath_this_script = resolve(expand('<sfile>:p'))
call nftables#syntax#push(s:filepath_this_script)
" now we can use nftables#syntax#log()

call nftables#syntax#log('OK', 'Begin.')

" BEGIN OF 'syntax' statements
"

" INSERT 'syntax match' here
" INSERT 'syntax region' here
" INSERT 'syntax cluster' here
try
  call nftables#syntax#debug('Loading add_chain_cmd.vim ...')

  hi link    nft_add_cmd_chain_imperative_chain_block_delimiters nftHL_BlockDelimitersChain
  syn region nft_add_cmd_chain_imperative_chain_block_delimiters start=+{+ end=+}+ skip='#.*$' skipwhite contained
  \ contains=
  \    nft_add_cmd_keyword_table_table_block_chain_chain_block_policy_spec_keyword_policy,
  \    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_keyword_type,
  \    nft_line_separator,

  hi link   nft_add_cmd_chain_imperative_chain_spec_identifier nftHL_Identifier
  syn match nft_add_cmd_chain_imperative_chain_spec_identifier '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
  \ nextgroup=
  \    nft_add_cmd_chain_imperative_chain_block_delimiters,
  \    nft_ExpectedEOL,
  \    nft_line_separator,
  \    nft_line_nonidentifier_error,
  \    nft_line_nonvariable_error,
  \    nft_UnexpectedCurrencySign,
  \    nft_UnexpectedCaret,
  \    nft_Error

  hi link   nft_add_cmd_chain_imperative_chain_spec_table_spec_identifier nftHL_Identifier
  syn match nft_add_cmd_chain_imperative_chain_spec_table_spec_identifier '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
  \ nextgroup=
  \    nft_add_cmd_chain_imperative_chain_spec_identifier,
  \    nft_line_nonidentifier_error,
  \    nft_line_nonvariable_error,
  \    nft_UnexpectedCurrencySign,
  \    nft_UnexpectedCaret,
  \    nft_ExpectedEOL,
  \    nft_UnexpectedCurlyBrace,
  \    nft_Error

  hi link   nft_add_cmd_chain_imperative_chain_spec_table_spec_family_spec_family_spec_explicit_defines nftHL_Family
  syn match nft_add_cmd_chain_imperative_chain_spec_table_spec_family_spec_family_spec_explicit_defines '\v(bridge|netdev|inet|arp|ip6|ip)' skipwhite contained
\ nextgroup=
\    nft_add_cmd_chain_imperative_chain_spec_table_spec_identifier,
\    nft_UnexpectedCurrencySign,
\    nft_Error

  hi link   nft_base_cmd_add_cmd_keyword_chain_imperative nftHL_Keyword
  syn match nft_base_cmd_add_cmd_keyword_chain_imperative '\vchain\ze\s' skipwhite contained
\ nextgroup=
\    nft_add_cmd_chain_imperative_chain_spec_table_spec_family_spec_family_spec_explicit_defines,
\    nft_add_cmd_chain_imperative_chain_spec_table_spec_identifier,
\    nft_UnexpectedCurrencySign,
\    nft_Error

  "syntax match nft_base_cmd_add_cmd_keyword_table '\vtable\ze\s' contained nextgroup=nft_add_cmd_table_spec_identifier
  call nftables#syntax#debug('Loaded add_chain_cmd.vim ...')
catch
  call nftables#syntax#log('ERROR', 'Failed to load add_chain_cmd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry

" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_add_chain_cmd = v:true
