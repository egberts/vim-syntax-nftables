" File: stmt_verdict.vim
" Directory: custom/nftables/table/chain/stmt/
"
let s:stmt_verdict_list_filepaths_semantic_early = []
let s:stmt_verdict_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_verdict')
  call nftables#syntax#log('INFO', 'Skipped stmt_verdict (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_verdict_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_verdict syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

hi link    nft_chain_stmt_delimiters nftHL_Delimiters
syn region nft_chain_stmt_delimiters start=+{+ end=+}+ skipwhite contained
\ contains=
\    @nft_c_rule


"******************** BEGIN verdict_stmt ******************************
hi link   nft_verdict_expr_chain_expr_identifier nftHL_Chain
syn match nft_verdict_expr_chain_expr_identifier '\v(\$)?[a-zA-Z][a-zA-Z0-9_]{0,63}' skipwhite contained
\ contains=
\    nft_identifier,
\    nft_identifier_last,
\    nft_variable_identifier,
\    nft_rule_cluster_Error

hi link   nft_chain_stmt_verdict_expr_keyword_jump nftHL_Command
syn match nft_chain_stmt_verdict_expr_keyword_jump '\vjump\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_expr_chain_expr_identifier

hi link    nft_verdict_map_expr_block_delimiters nftHL_BlockDelimitersVerdict
syn region nft_verdict_map_expr_block_delimiters start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_set_elem_expr
\ nextgroup=
\    nft_stmt_separator

hi link   nft_verdict_map_expr_set_ref_symbol_expr nftHL_AtSetname
syn match nft_verdict_map_expr_set_ref_symbol_expr '\v\@[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_stmt_separator

hi link   nft_verdict_map_expr_variable_expr nftHL_Variable
syn match nft_verdict_map_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze[ \t\n;]' skipwhite contained

syn cluster nft_c_verdict_map_expr_set_ref_expr
\ contains=
\    nft_verdict_map_expr_set_ref_symbol_expr,
\    nft_verdict_map_expr_variable_expr,
\    nft_stmt_separator


syn cluster nft_c_verdict_map_expr
\ contains=
\    @nft_c_verdict_map_expr_set_ref_expr,
\    nft_verdict_map_expr_block_delimiters

hi link   nft_verdict_map_stmt_keyword_vmap nftHL_Substatement
syn match nft_verdict_map_stmt_keyword_vmap '\vvmap\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_map_expr_set_ref_symbol_expr,
\    nft_verdict_map_expr_variable_expr,
\    nft_verdict_map_expr_block_delimiters,
\    nft_Error

syn cluster nft_c_verdict_stmt
\ contains=
\    nft_verdict_expr_keyword_continue,
\    nft_verdict_expr_keyword_accept,
\    nft_verdict_expr_keyword_return,
\    nft_verdict_expr_keyword_drop,
\    nft_verdict_expr_keyword_goto,
\    nft_verdict_expr_keyword_jump

"******************** BEGIN verdict_stmt ******************************

  for s:this_semantic_file in s:stmt_verdict_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_verdict for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_verdict.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_verdict = v:true
