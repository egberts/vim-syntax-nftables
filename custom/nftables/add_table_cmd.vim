" File: ~/.vim/custom/nftables/add_table_cmd.vim
" The imperative part of 'add table'
" Not the declarative part of 'table <table_id> { ... }'
"
let s:list_filepaths_semantic_early = []
let s:list_filepaths_semantic_later = []

if exists('b:did_nftables_add_table_cmd')
  call nftables#syntax#log('INFO', 'Skipped add_table_cmd (already loaded for buffer: ' . bufname('%') . ')')
  finish
endif

" save the filespec of this script into a stack for logging purpose
let s:filepath_this_script = resolve(expand('<sfile>:p'))
call nftables#syntax#push(s:filepath_this_script)
" now we can use nftables#syntax#log()

call nftables#syntax#log('OK', 'Begin.')

" BEGIN OF 'syntax' statements
"
try
  " non-terminal semantic action processing
  for s:this_semantic_file in s:list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading add_table_cmd syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
try
  hi link   nft_add_cmd_table_imperative_table_spec_identifier nftHL_Identifier
  syn match nft_add_cmd_table_imperative_table_spec_identifier '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
  \ nextgroup=
  \    nft_line_separator,
  \    nft_line_nonidentifier_error,
  \    nft_line_nonvariable_error,
  \    nft_UnexpectedCurrencySign,
  \    nft_UnexpectedCaret,
  \    nft_ExpectedEOL,
  \    nft_UnexpectedCurlyBrace,
  \    nft_Error

  hi link   nft_add_cmd_table_imperative_table_spec_family_spec_family_spec_explicit_identifier nftHL_Family
  syn match nft_add_cmd_table_imperative_table_spec_family_spec_family_spec_explicit_identifier '\v(bridge|netdev|inet|arp|ip6|ip)\ze\s' skipwhite contained
  \ nextgroup=
  \    nft_add_cmd_table_imperative_table_spec_identifier,
  \    nft_Error

  hi link   nft_base_cmd_add_cmd_keyword_table_imperative nftHL_Keyword
  syn match nft_base_cmd_add_cmd_keyword_table_imperative '\vtable\ze\s' skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_imperative_table_spec_family_spec_family_spec_explicit_identifier,
\    nft_add_cmd_table_imperative_table_spec_identifier,
\    nft_Error

  "syntax match nft_base_cmd_add_cmd_keyword_table '\vtable\ze\s' contained nextgroup=nft_add_cmd_table_spec_identifier
  call nftables#syntax#debug('Loading add_table_cmd.vim ...')
catch
  call nftables#syntax#log('ERROR', 'Failed to load sub-syntax in ' . expand('<sfile>:t') . ': ' . v:exception)
endtry

  for s:this_semantic_file in s:list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded add_table_cmd for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define table.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_add_table_cmd = v:true
