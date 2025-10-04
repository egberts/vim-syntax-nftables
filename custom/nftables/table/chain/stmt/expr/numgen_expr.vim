" File: numgen_expr.vim
" Directory: custom/nftables/
" TODO: Replace 'numgen_expr' with filename of this script
"
let s:numgen_expr_list_filepaths_semantic_early = []
let s:numgen_expr_list_filepaths_semantic_later = []

if exists('b:did_nftables_numgen_expr')
  call nftables#syntax#log('INFO', 'Skipped numgen_expr (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:numgen_expr_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading numgen_expr syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "



" ***************** BEGIN numgen_expr ********************************
" numgen_expr -> primary_expr
" numgen_expr -> primary_stmt_expr

hi link   nft_numgen_expr_num nftHL_Integer
syn match nft_numgen_expr_num '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,10}))' skipwhite contained
\ nextgroup=
\    nft_map_expr_keyword_map,
\    nft_Error

hi link   nft_numgen_expr_keyword_mod nftHL_Statement
syn match nft_numgen_expr_keyword_mod '\vmod\ze\s' skipwhite contained
\ nextgroup=
\    nft_numgen_expr_num,
\    nft_Error

hi link   nft_numgen_expr_types nftHL_Keyword
syn match nft_numgen_expr_types '\v(random|inc)\ze\s' skipwhite contained
\ nextgroup=
\    nft_numgen_expr_keyword_mod,
\    nft_Error

hi link   nft_chain_block_primary_expr_numgen_expr_keyword_numgen nftHL_Command
syn match nft_chain_block_primary_expr_numgen_expr_keyword_numgen '\vnumgen\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_numgen_expr_types,
\    nft_Error
" **************** END numgen_expr ***********************************

  for s:this_semantic_file in s:numgen_expr_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded numgen_expr for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define numgen_expr.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_numgen_expr = v:true
