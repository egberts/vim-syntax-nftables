" File: stmt_policy.vim
" Directory: custom/nftables/table/chain/
"
let s:stmt_policy_list_filepaths_semantic_early = []
let s:stmt_policy_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_policy')
  call nftables#syntax#log('INFO', 'Skipped stmt_policy (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_policy_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_policy syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "


"**** BEGIN of table <identifier> { chain <identifier> {"
" add 'table' table_block chain_block hook_spec
" add_cmd 'table' table_block 'chain' chain_block ';'
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_separator nftHL_Separator
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_separator /;/ skipwhite contained
\ nextgroup=
\    nft_comment_inline



" chain_policy->policy_expr->'policy'->policy_spec->chain_block->'{'->
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_policy_spec_policy_expr_chain_policy nftHL_Keyword
syn match nft_add_cmd_keyword_table_table_block_chain_chain_policy_spec_policy_expr_chain_policy "\v(accept|drop)" skipwhite contained
\ nextgroup=
\    nft_MissingSemicolon,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_separator,

" chain_policy->policy_expr->'policy'->policy_spec->chain_block->'{'->
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_policy_spec_policy_expr_variable_expr nftHL_Variable
syn match nft_add_cmd_keyword_table_table_block_chain_chain_policy_spec_policy_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

" policy_expr->'policy'->policy_spec->chain_block->'{'->
syn cluster nft_c_add_cmd_keyword_table_table_block_chain_chain_policy_spec_policy_expr
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_chain_policy_spec_policy_expr_chain_policy,
\    nft_add_cmd_keyword_table_table_block_chain_chain_policy_spec_policy_expr_variable_expr

hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_policy_spec_keyword_policy nftHL_Command
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_policy_spec_keyword_policy "policy" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_table_table_block_chain_chain_policy_spec_policy_expr,
\    nft_Semicolon,
\    nft_EOL,
\    nft_Error

  for s:this_semantic_file in s:stmt_policy_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_policy for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_policy.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_policy = v:true
