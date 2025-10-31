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


" set_elem_stmt->set_elem_expr_alloc->set_elem_expr->verdict_map_list_member_expr->verdict_map_expr
syn cluster nft_c_verdict_map_list_expr_set_elem_expr_set_elem_expr_alloc_set_elem_key_expr_set_elem_stmt
\ contains=
\    nft_c_verdict_map_list_expr_set_elem_expr_set_elem_expr_alloc_set_elem_key_expr_set_elem_stmt_keyword_counter,
\    nft_c_verdict_map_list_expr_set_elem_expr_set_elem_expr_alloc_set_elem_key_expr_set_elem_stmt_keyword_limit,
\    nft_c_verdict_map_list_expr_set_elem_expr_set_elem_expr_alloc_set_elem_key_expr_set_elem_stmt_keyword_ct,
\    nft_c_verdict_map_list_expr_set_elem_expr_set_elem_expr_alloc_set_elem_key_expr_set_elem_stmt_keyword_quota,
\    nft_c_verdict_map_list_expr_set_elem_expr_set_elem_expr_alloc_set_elem_key_expr_set_elem_stmt_keyword_last,

" '*'->set_elem_key_expr->set_elem_expr_alloc->set_elem_expr->verdict_map_list_member_expr->verdict_map_expr
syn match nft_verdict_map_list_expr_set_elem_expr_set_elem_expr_alloc_set_elem_key_expr_asterisk '\*' skipwhite contained
\ nextgroup=
\    nft_verdict_map_list_expr_set_elem_expr_set_elem_expr_alloc_set_elem_key_expr_set_elem_stmt

" set_lhs_expr->set_elem_key_expr->set_elem_expr_alloc->set_elem_expr->verdict_map_list_member_expr->verdict_map_expr
syn cluster nft_c_verdict_map_list_expr_set_elem_expr_set_elem_expr_alloc_set_elem_key_expr_set_lhs_expr
\ contains=
\    nft_nothing

" set_elem_key_expr->set_elem_expr_alloc->set_elem_expr->verdict_map_list_member_expr->verdict_map_expr
syn cluster nft_c_verdict_map_list_expr_set_elem_expr_set_elem_expr_alloc_set_elem_key_expr
\ contains=
\    nft_c_verdict_map_list_expr_set_elem_expr_set_elem_expr_alloc_set_elem_key_expr_set_lhs_expr

" set_elem_expr_alloc->set_elem_expr->verdict_map_list_member_expr->verdict_map_expr
syn cluster nft_c_verdict_map_list_expr_set_elem_expr_set_elem_expr_alloc
\ contains=
\    nft_c_verdict_map_list_expr_set_elem_expr_set_elem_expr_alloc_set_elem_key_expr

" cannot use nft_c_set_elem_expr here,
" MUST CLONE IT ALL because we continue on with ':'
syn cluster nft_c_verdict_map_list_expr_set_elem_expr_alloc
\ contains=
\    nft_c_verdict_map_list_expr_set_elem_expr_set_elem_expr_alloc


hi link    nft_verdict_map_expr_block_delimiters nftHL_BlockDelimitersMap
syn region nft_verdict_map_expr_block_delimiters start=+{+ end=+}+ skipwhite contained
\ contains=
\    @nft_c_verdict_map_list_member_expr,
\    nft_set_elem_expr
\ nextgroup=
\    @nft_c_stmt,
\    nft_stmt_separator

hi link   nft_verdict_map_expr_set_ref_expr_set_ref_symbol_expr_at_identifier nftHL_AtSetname
syn match nft_verdict_map_expr_set_ref_expr_set_ref_symbol_expr_at_identifier '\v\@[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt,
\    nft_stmt_separator

hi link   nft_verdict_map_expr_set_ref_expr_variable_expr nftHL_Variable
syn match nft_verdict_map_expr_set_ref_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt,
\    nft_stmt_separator

syn cluster nft_c_verdict_map_expr_set_ref_expr
\ contains=
\    nft_verdict_map_expr_set_ref_expr_set_ref_symbol_expr_at_identifier,
\    nft_verdict_map_expr_set_ref_expr_variable_expr,
\    nft_stmt_separator

syn cluster nft_c_verdict_map_expr
\ contains=
\    nft_verdict_map_expr_set_ref_expr_set_ref_symbol_expr_at_identifier,
\    nft_verdict_map_expr_set_ref_expr_variable_expr,
\    nft_verdict_map_expr_block_delimiters,
\    nft_stmt_separator


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
