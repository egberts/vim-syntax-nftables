" File: verdict_map_expr.vim
" Directory: custom/nftables/table/chain/stmt/expr/
"
let s:verdict_map_expr_list_filepaths_semantic_early = []
let s:verdict_map_expr_list_filepaths_semantic_later = []

if exists('b:did_nftables_verdict_map_expr')
  call nftables#syntax#log('INFO', 'Skipped verdict_map_expr (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:verdict_map_expr_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading verdict_map_expr syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
" **************** BEGIN verdict_map_expr ****************************
hi link    nft_verdict_stmt_verdict_map_stmt_verdict_map_expr_delimiters nftHL_BlockDelimitersSet
syn region nft_verdict_stmt_verdict_map_stmt_verdict_map_expr_delimiters start=+{+ end=+}+ keepend skipwhite contained

hi link   nft_verdict_stmt_verdict_map_stmt_keyword_vmap nftHL_Keyword
syn match nft_verdict_stmt_verdict_map_stmt_keyword_vmap '\vvmap' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_verdict_map_expr_delimiters
" **************** END verdict_map_expr ******************************



  for s:this_semantic_file in s:verdict_map_expr_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded verdict_map_expr for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define verdict_map_expr.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_verdict_map_expr = v:true
