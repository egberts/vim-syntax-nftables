" File: payload_raw_expr.vim
" Directory: custom/nftables/table/chain/stmt/expr
"
let s:payload_raw_expr_list_filepaths_semantic_early = []
let s:payload_raw_expr_list_filepaths_semantic_later = []

if exists('b:did_nftables_payload_raw_expr')
  call nftables#syntax#log('INFO', 'Skipped payload_raw_expr (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:payload_raw_expr_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading payload_raw_expr syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "


" **************** BEGIN payload_raw_expr ***************************
" Inside chain_block
" '@ih,0,8 48'
hi link   nft_payload_raw_expr_payload_raw_len nftHL_Integer
syn match nft_payload_raw_expr_payload_raw_len '\v(0x[0-9a-fA-F]{1,8})|([0-9]{1,10})' skipwhite contained

" '@ih,0,8'
hi link   nft_payload_raw_expr_num2 nftHL_Integer
syn match nft_payload_raw_expr_num2 '\v(0x[0-9a-fA-F]{1,4})|([0-9]{1,5})' skipwhite contained
\ nextgroup=
\    nft_payload_raw_expr_payload_raw_len

" '@ih,0,'
hi link   nft_payload_raw_expr_comma2_symbol nftHL_Element
syn match nft_payload_raw_expr_comma2_symbol '\v,' contained
\ nextgroup=
\    nft_payload_raw_expr_num2

" '@ih,0'
hi link   nft_payload_raw_expr_num1 nftHL_Integer
syn match nft_payload_raw_expr_num1 '\v(0x[0-9a-fA-F]{1,4})|([0-9]{1,5})' contained
\ nextgroup=
\    nft_payload_raw_expr_comma2_symbol

" '@ih,'
hi link   nft_payload_raw_expr_comma1_symbol nftHL_Element
syn match nft_payload_raw_expr_comma1_symbol '\v,' contained
\ nextgroup=
\    nft_payload_raw_expr_num1

" Predefined payload base: @ih, @ll, @nh, @th
" payload_raw_expr/payload_expr/primary_expr/basic_expr/concat_expr/relational_expr/match_stmt/stmt/rule_alloc/rule/chain_block ...
" '@ih,9,9 99'
hi link   nft_payload_raw_expr_payload_base_spec_keyword_at_ih nftHL_Statement
syn match nft_payload_raw_expr_payload_base_spec_keyword_at_ih '\v\@ih' contained
\ nextgroup=
\    nft_payload_raw_expr_comma1_symbol, nft_Error

" '@ll,9,9 99'
hi link   nft_payload_raw_expr_payload_base_spec_keyword_at_ll nftHL_Statement
syn match nft_payload_raw_expr_payload_base_spec_keyword_at_ll '\v\@ll' contained
\ nextgroup=
\    nft_payload_raw_expr_comma1_symbol, nft_Error

" '@nh,9,9 99'
hi link   nft_payload_raw_expr_payload_base_spec_keyword_at_nh nftHL_Statement
syn match nft_payload_raw_expr_payload_base_spec_keyword_at_nh '\v\@nh' contained
\ nextgroup=
\    nft_payload_raw_expr_comma1_symbol, nft_Error

" '@th,9,9 99'
hi link   nft_payload_raw_expr_payload_base_spec_keyword_at_th nftHL_Statement
syn match nft_payload_raw_expr_payload_base_spec_keyword_at_th '\v\@th' contained
\ nextgroup=
\    nft_payload_raw_expr_comma1_symbol, nft_Error

" '@<string>,9,9 99'
hi link   nft_payload_raw_expr_payload_base_spec_keyword_at_string nftHL_AtSetname
syn match nft_payload_raw_expr_payload_base_spec_keyword_at_string '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,15}\ze[ \t,]' contained
\ nextgroup=
\    nft_payload_raw_expr_comma1_symbol, nft_Error
" ************************* END payload_raw_expr' *************************

  for s:this_semantic_file in s:payload_raw_expr_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded payload_raw_expr for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define payload_raw_expr.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_payload_raw_expr = v:true
