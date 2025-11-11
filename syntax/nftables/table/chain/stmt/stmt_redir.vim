" File: stmt_redir.vim
" Directory: custom/nftables/table/chain/stmt/
"
let s:stmt_redir_list_filepaths_semantic_early = []
let s:stmt_redir_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_redir')
  call nftables#syntax#log('INFO', 'Skipped stmt_redir (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_redir_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_redir syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "



" ***************** START redir_stmt ***************
hi link   nft_add_cmd_rule_rule_alloc_stmt_redir_stmt_redir_stmt_arg_symbol_colon nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_redir_stmt_redir_stmt_arg_symbol_colon ':' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_redir_stmt_redir_stmt_arg_stmt_expr

hi link   nft_add_cmd_rule_rule_alloc_stmt_redir_stmt_redir_stmt_arg_keyword_to nftHL_Write
syn match nft_add_cmd_rule_rule_alloc_stmt_redir_stmt_redir_stmt_arg_keyword_to '\vto\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_redir_stmt_redir_stmt_arg_symbol_colon,
\    nft_add_cmd_rule_rule_alloc_stmt_redir_stmt_redir_stmt_arg_stmt_expr

hi link   nft_add_cmd_rule_rule_alloc_stmt_redir_stmt_redir_stmt_arg_nf_nat_flags_comma nftHL_Delimiters
syn match nft_add_cmd_rule_rule_alloc_stmt_redir_stmt_redir_stmt_arg_nf_nat_flags_comma /,/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_redir_stmt_redir_stmt_arg_nf_nat_flags_cluster

hi link nft_add_cmd_rule_rule_alloc_stmt_redir_stmt_redir_stmt_arg_nf_nat_flags_cluster nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_redir_stmt_redir_stmt_arg_nf_nat_flags_cluster "\v(fully\-random|random|persistent)" skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_redir_stmt_redir_stmt_arg_nf_nat_flags_comma

hi link   nft_add_cmd_rule_rule_alloc_stmt_redir_stmt_redir_stmt_alloc_keyword_redirect nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_redir_stmt_redir_stmt_alloc_keyword_redirect "\vredirect\ze[ \t\n]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_redir_stmt_redir_stmt_arg_nf_nat_flags_cluster,
\    nft_add_cmd_rule_rule_alloc_stmt_redir_stmt_redir_stmt_arg_keyword_to
" there is no nextgroup=nft_Error here, it can optionally end here for rule 'redirect'
" ***************** END redir_stmt ***************


  for s:this_semantic_file in s:stmt_redir_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_redir for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_redir.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_redir = v:true
