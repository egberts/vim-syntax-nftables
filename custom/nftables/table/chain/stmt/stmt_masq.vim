" File: stmt_masq.vim
" Directory: custom/nftables/
" TODO: Replace 'stmt_masq' with filename of this script
"
let s:stmt_masq_list_filepaths_semantic_early = []
let s:stmt_masq_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_masq')
  call nftables#syntax#log('INFO', 'Skipped stmt_masq (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_masq_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_masq syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "



" ***************** START masq_stmt ***************
hi link   nft_add_cmd_rule_rule_alloc_stmt_masq_stmt_masq_stmt_arg_symbol_colon nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_masq_stmt_masq_stmt_arg_symbol_colon ':' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_masq_stmt_masq_stmt_arg_stmt_expr,
\    nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_masq_stmt_masq_stmt_arg_keyword_to nftHL_Write
syn match nft_add_cmd_rule_rule_alloc_stmt_masq_stmt_masq_stmt_arg_keyword_to '\vto\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_masq_stmt_masq_stmt_arg_symbol_colon

hi link   nft_add_cmd_rule_rule_alloc_stmt_masq_stmt_masq_stmt_arg_nf_nat_flags_comma nftHL_Delimiters
syn match nft_add_cmd_rule_rule_alloc_stmt_masq_stmt_masq_stmt_arg_nf_nat_flags_comma /,/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_masq_stmt_masq_stmt_arg_nf_nat_flags_cluster

hi link nft_add_cmd_rule_rule_alloc_stmt_masq_stmt_masq_stmt_arg_nf_nat_flags_cluster nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_masq_stmt_masq_stmt_arg_nf_nat_flags_cluster "\v(fully\-random|random|persistent)" skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_masq_stmt_masq_stmt_arg_nf_nat_flags_comma

hi link   nft_add_cmd_rule_rule_alloc_stmt_masq_keyword_masquerade nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_masq_keyword_masquerade "\vmasquerade\ze[ \t\n]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_masq_stmt_masq_stmt_arg_nf_nat_flags_cluster,
\    nft_add_cmd_rule_rule_alloc_stmt_masq_stmt_masq_stmt_arg_keyword_to
" ***************** END masq_stmt ***************


  for s:this_semantic_file in s:stmt_masq_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_masq for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_masq.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_masq = v:true
