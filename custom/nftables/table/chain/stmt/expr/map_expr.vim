" File: map_expr.vim
" Directory: custom/nftables/table/chain/stmt/expr/
"
let s:map_expr_list_filepaths_semantic_early = []
let s:map_expr_list_filepaths_semantic_later = []

if exists('b:did_nftables_map_expr')
  call nftables#syntax#log('INFO', 'Skipped map_expr (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:map_expr_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading map_expr syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "



"***************** BEGIN 'map' rhs_expr ************************************
hi link   nft_map_expr_rhs_expr_concat_rhs_expr nftHL_Keyword
syn match nft_map_expr_rhs_expr_concat_rhs_expr 'x' skipwhite contained

hi link    nft_map_expr_rhs_expr_set_expr nftHL_BlockDelimitersSet
syn region nft_map_expr_rhs_expr_set_expr start=+{+ end=+}+ skipwhite contained
\ nextgroup=
\    nft_stmt_separator,
\    nft_EOL,
\    nft_Error

hi link   nft_map_expr_rhs_expr_set_ref_symbol_expr nftHL_Keyword
syn match nft_map_expr_rhs_expr_set_ref_symbol_expr 'y' skipwhite contained

syn cluster nft_c_map_expr_rhs_expr
\ contains=
\    nft_map_expr_rhs_expr_concat_rhs_expr,
\    nft_map_expr_rhs_expr_set_expr,
\    nft_map_expr_rhs_expr_set_ref_symbol_expr_keyword_at_identifier,
\    nft_map_expr_rhs_expr_primary_expr,
\    nft_map_expr_rhs_expr_range_rhs_expr_basic_rhs_expr_exclusive_or_rhs_expr_and_rhs_expr_shift_rhs_expr_primary_rhs_expr_integer_expr,
"***************** END 'map' rhs_expr **************************************

  for s:this_semantic_file in s:map_expr_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded map_expr for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define map_expr.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_map_expr = v:true
