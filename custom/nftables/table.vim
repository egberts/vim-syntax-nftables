" File: table.vim
" Directory: custom/nftables/
"
let s:list_filepaths_semantic_early = [
\    'table/chain.vim',
\    'table/table_block.vim'
\ ]
let s:list_filepaths_semantic_later = []

if exists('b:did_nftables_table')
  call nftables#syntax#log('INFO', 'Skipped table (already loaded for buffer: ' . bufname('%') . ')')
  finish
endif

" save the filespec of this script into a stack for logging purpose
let s:filepath_this_script = resolve(expand('<sfile>:p'))
call nftables#syntax#push(s:filepath_this_script)
" now we can use nftables#syntax#log()

call nftables#syntax#log('OK', 'Begin.')

" BEGIN OF 'syntax' statements

try
  " Load companion syntax files to extend the LL(1) syntax tree.
  call nftables#syntax#log('OK', 'List of semantic files: ' . string(s:list_filepaths_semantic_early))
  for s:this_semantic_file in s:list_filepaths_semantic_early
    try
      call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
      call nftables#syntax#load(s:this_semantic_file)
      call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
    catch
      call nftables#syntax#log('ERROR', 'Error loading: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
    endtry
  endfor
catch
  call nftables#syntax#log('ERROR', 'Failed to define table.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry

call nftables#syntax#log('INFO', 'Loaded table for buffer: ' . bufname('%'))



" base_cmd add_cmd 'table' table_spec family_spec identifier
hi link   nft_table_spec_identifier nftHL_Identifier
syn match nft_table_spec_identifier '\v[a-zA-Z][A-Za-z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_delimiters,
\    nft_comment_inline,
\    nft_EOS,
\    nft_line_nonidentifier_error,
\    nft_line_separator

" base_cmd add_cmd 'table' table_spec family_spec family_spec_explicit
hi link   nft_table_spec_family_spec_valid nftHL_Family
syn match nft_table_spec_family_spec_valid '\v(bridge|netdev|inet|ip6|arp|ip)' skipwhite skipnl skipempty contained
\ nextgroup=
\    nft_table_spec_identifier,
\    nft_UnexpectedVariableName,
\    nft_UnexpectedAtSymbol,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedHash,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd add_cmd 'table' table_spec family_spec identifier
hi link   nft_table_spec_variable_expr nftHL_Variable
syn match nft_table_spec_variable_expr "\v\$[a-zA-Z][A-Za-z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_delimiters,
\    nft_comment_inline,
\    nft_EOS,
\    nft_line_separator,
\    nft_line_nonidentifier_error,

" base_cmd add_cmd 'add' 'table' table_spec family_spec identifier
hi link   nft_add_table_spec_identifier nftHL_Identifier
syn match nft_add_table_spec_identifier '\v[a-zA-Z][A-Za-z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_comment_inline,
\    nft_line_separator,
\    nft_EOS,
\    nft_line_nonidentifier_error,

" base_cmd add_cmd 'add' 'table' table_spec family_spec family_spec_explicit
hi link   nft_add_table_spec_family_spec_valid nftHL_Family
syn match nft_add_table_spec_family_spec_valid '\v(bridge|netdev|inet|arp|ip6|ip)' skipwhite skipnl skipempty contained
\ nextgroup=
\    nft_add_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" IMPERATIVE: nft> add table <table_id>
" 'table'->add_cmd->'add'->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_table_imperative nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_table_imperative '\vtable\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_table_spec_family_spec_valid,
\    nft_add_table_spec_identifier,
\    nft_comment_inline,
\    nft_line_nonidentifier_error

" DECLARATIVE: nft> table <table_id> ;
" 'table'->add_cmd->base_cmd->line
hi link   nft_base_cmd_keyword_table_declarative nftHL_Command
syn match nft_base_cmd_keyword_table_declarative '\vtable\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_table_spec_family_spec_valid,
\    nft_table_spec_variable_expr,
\    nft_table_spec_identifier,
\    nft_line_nonvariable_error,
\    nft_UnexpectedNonIdentifier,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedVariableName,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_table = v:true