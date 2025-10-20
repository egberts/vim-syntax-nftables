" File: stmt_set.vim
" Directory: custom/nftables/table/chain/stmt/
"
let s:stmt_set_list_filepaths_semantic_early = []
let s:stmt_set_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_set')
  call nftables#syntax#log('INFO', 'Skipped stmt_set (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_set_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_set syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

" ************************* BEGIN set_stmt ***************************
hi link    nft_set_stmt_and_map_stmt_delimiters nftHL_BlockDelimitersSet
syn region nft_set_stmt_and_map_stmt_delimiters start=+{+ end=+}+ keepend skipnl skipwhite contained

hi link   nft_map_stmt_set_ref_expr_set_ref_symbol_expr_keyword_at_identifier nftHL_AtSetname
syn match nft_map_stmt_set_ref_expr_set_ref_symbol_expr_keyword_at_identifier '\v\@[a-zA-Z][a-zA-Z0-9\_-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_set_stmt_and_map_stmt_delimiters

hi link   nft_map_stmt_set_ref_expr_set_variable nftHL_Variable
syn match nft_map_stmt_set_ref_expr_set_variable '\v\$[a-zA-Z][a-zA-Z0-9\_-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_set_stmt_and_map_stmt_delimiters

hi link   nft_stmt_set_stmt_set_stmt_op_keyword_delete nftHL_Statement
syn match nft_stmt_set_stmt_set_stmt_op_keyword_delete '\vdelete' skipwhite contained
\ nextgroup=
\    nft_map_stmt_set_ref_expr_set_ref_symbol_expr_keyword_at_identifier,
\    nft_map_stmt_set_ref_expr_set_variable

hi link   nft_stmt_set_stmt_set_stmt_op_keyword_update nftHL_Statement
syn match nft_stmt_set_stmt_set_stmt_op_keyword_update '\vupdate' skipwhite contained
\ nextgroup=
\    nft_map_stmt_set_ref_expr_set_ref_symbol_expr_keyword_at_identifier,
\    nft_map_stmt_set_ref_expr_set_variable

hi link   nft_stmt_set_stmt_set_stmt_op_keyword_add nftHL_Statement
syn match nft_stmt_set_stmt_set_stmt_op_keyword_add '\vadd\ze ' skipwhite contained
\ nextgroup=
\    nft_map_stmt_set_ref_expr_set_ref_symbol_expr_keyword_at_identifier,
\    nft_map_stmt_set_ref_expr_set_variable
" ************************* END set_stmt *****************************



  for s:this_semantic_file in s:stmt_set_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_set for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_set.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_set = v:true
