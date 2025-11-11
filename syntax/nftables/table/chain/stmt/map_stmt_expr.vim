" File: map_stmt_expr.vim
" Directory: custom/nftables/table/chain/stmt/expr/
"
let s:map_stmt_expr_list_filepaths_semantic_early = []
let s:map_stmt_expr_list_filepaths_semantic_later = []

if exists('b:did_nftables_map_stmt_expr')
  call nftables#syntax#log('INFO', 'Skipped payload_stmt_expr (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:map_stmt_expr_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading payload_expr syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
"*************** BEGIN map_stmt_expr *******************************
" map_stmt_expr includes map_stmt_expr_set_expr
" map_stmt_expr includes map_stmt_expr_set_ref_expr
"
" All first-order, first-encountered keywords from all the semantic actions
" above are then placed inside 'contains=' in decreasing order of length of
" its lexical token then in least-to-most permissive regex order.
"
hi link    nft_map_stmt_expr_map_stmt_expr_set_set_expr_block_delimiters nftHL_BlockDelimiterMap
syn region nft_map_stmt_expr_map_stmt_expr_set_set_expr_block_delimiters start=+{+ end=+}+ skipwhite contained

hi link   nft_map_stmt_expr_keyword_map nftHL_Write
syn match nft_map_stmt_expr_keyword_map '\vmap\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_map_stmt_expr_map_stmt_expr_set_set_expr_block_delimiters
"*************** END map_stmt_expr *******************************


  for s:this_semantic_file in s:map_stmt_expr_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded payload_expr for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define map_stmt_expr.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_map_stmt_expr = v:true
