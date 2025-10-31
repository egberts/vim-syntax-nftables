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


"******************** BEGIN verdict_stmt ******************************
hi link   nft_verdict_stmt_verdict_map_stmt_keyword_vmap nftHL_Write
syn match nft_verdict_stmt_verdict_map_stmt_keyword_vmap '\vvmap' skipwhite contained
\ nextgroup=
\    nft_verdict_map_expr_block_delimiters

hi link   nft_verdict_map_stmt_keyword_vmap nftHL_Substatement
syn match nft_verdict_map_stmt_keyword_vmap '\vvmap\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_map_expr_set_ref_expr_set_ref_symbol_expr_at_identifier,
\    nft_verdict_map_expr_set_ref_expr_variable_expr,
\    nft_verdict_map_expr_block_delimiters,
\    nft_Error


hi link   nft_verdict_stmt_verdict_expr_keyword_goto nftHL_Statement
syn match nft_verdict_stmt_verdict_expr_keyword_goto '\vgoto\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    nft_verdict_expr_chain_expr_variable_expr,
\    nft_verdict_expr_chain_expr_identifier,
\    nft_chain_stmt_block_delimiters,
\    nft_rule_cluster_Error

hi link   nft_verdict_stmt_verdict_expr_keyword_jump nftHL_Statement
syn match nft_verdict_stmt_verdict_expr_keyword_jump '\vjump\ze[ \t]' keepend skipwhite contained
\ nextgroup=
\    nft_verdict_expr_chain_expr_variable_expr,
\    nft_verdict_expr_chain_expr_identifier,
\    nft_chain_stmt_block_delimiters,
\    nft_rule_cluster_Error

" verdict_stmt->stmt
" verdict_stmt covers:
"    'accept'
"    'drop'
"    'continue'
"    'goto <identifier>'  verdict_stmt->verdict_expr->chain_expr->identifier
"    'goto $VARIABLE'  verdict_stmt->verdict_expr->chain_expr->variable_expr
"    'goto' { stmt }
"    'jump' { stmt }
"    'return'
"    concat_expr 'vmap'  verdict_stmt->verdict_map_stmt->'vmap'->verdict_map_expr

syn cluster nft_c_verdict_stmt
\ contains=
\    nft_verdict_expr_keyword_continue,
\    nft_verdict_expr_keyword_accept,
\    nft_verdict_expr_keyword_return,
\    nft_verdict_expr_keyword_drop,
\    nft_verdict_expr_keyword_goto,
\    nft_verdict_expr_keyword_jump
" do not include 'vmap' in 'verdict_stmt' as concat_expr in verdict_map_stmt comes before that

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
