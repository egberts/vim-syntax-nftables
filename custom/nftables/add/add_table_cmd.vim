" File: ~/.vim/custom/nftables/add_table_cmd.vim
" The imperative part of 'add table'
" Not the declarative part of 'table <table_id> { ... }'
"
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

" INSERT 'syntax match' here
" INSERT 'syntax region' here
" INSERT 'syntax cluster' here
try
  call nftables#syntax#debug('Loading add_table_cmd.vim ...')

  " ------------- BEGIN 'table' -------------
" ******************* BEGIN 'table' *************
" ************* BEGIN table_block table_options ***************
" base_cmd add_cmd 'table' table_block table_options ';'
hi link   nft_add_cmd_keyword_table_table_block_table_options_semicolon nftHL_Separator
syn match nft_add_cmd_keyword_table_table_block_table_options_semicolon ";" skipwhite contained

" table_block 'chain' (via table_block)
" hi link   nft_chain_identifier_keyword nftHL_Command
" syn match nft_chain_identifier_keyword ^\vchain skipnl skipwhite contained


" [ [ 'add' ] 'table' ] table_id '{' ';'
" ';'->stmt_separator->table_block->'table'->add_cmd->'add'->base_cmd->line
hi link   nft_table_block_stmt_separator nftHL_Separator
syn match nft_table_block_stmt_separator "\v(\n|;)" skipwhite contained

hi link   nft_add_cmd_keyword_table_table_options_comment_spec_string_content nftHL_Comment
syn match nft_add_cmd_keyword_table_table_options_comment_spec_string_content '\v[ \tA-Za-z0-9_!@#$%^\&*()\[\]\{\}\|:\<\>,./?`~\\\+\=\-]{1,65}' skipwhite contained

hi link   nft_add_cmd_keyword_table_table_options_comment_spec_string_quoted nftHL_Comment
syn region nft_add_cmd_keyword_table_table_options_comment_spec_string_quoted start='"' end='"' skip='\\\"' skipnl skipwhite contained
\ contains=
\    nft_add_cmd_keyword_table_table_options_comment_spec_string_content
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_table_options_semicolon

syn region nft_add_cmd_keyword_table_table_options_comment_spec_string_quoted start="'" end="'" skip="\\\'" skipwhite contained
\ contains=
\    nft_add_cmd_keyword_table_table_options_comment_spec_string_content
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_table_options_semicolon

hi link   nft_add_cmd_keyword_table_table_options_comment_spec_string_raw nftHL_Comment
syn match nft_add_cmd_keyword_table_table_options_comment_spec_string_raw '\v[A-Za-z0-9_!@#$%^\&*()\[\]\{\}\|:\<\>,./?`~\\\+\=\-]{1,65}' skipwhite contained
\ nextgroup= nft_add_cmd_keyword_table_table_block_table_options_semicolon, nft_Error

hi link   nft_add_cmd_keyword_table_table_options_comment_spec_keyword_comment nftHL_Statement
syn match nft_add_cmd_keyword_table_table_options_comment_spec_keyword_comment '\vcomment' skipwhite contained
\ nextgroup=
\     nft_add_cmd_keyword_table_table_options_comment_spec_string_quoted,
\     nft_add_cmd_keyword_table_table_options_comment_spec_string_raw,
\     nft_Error
" ************* END table_block table_options ***************

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
\    nft_UnexpectedCurrencySign,
\    nft_Error

  "syntax match nft_base_cmd_add_cmd_keyword_table '\vtable\ze\s' contained nextgroup=nft_add_cmd_table_spec_identifier
  call nftables#syntax#debug('Loaded add_table_cmd.vim ...')
catch
  call nftables#syntax#log('ERROR', 'Failed to load add_table_cmd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry

" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_add_table_cmd = v:true
