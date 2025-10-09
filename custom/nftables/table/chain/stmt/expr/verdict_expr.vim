" File: verdict_expr.vim
" Directory: custom/nftables/table/chain/stmt/expr/
"
let s:verdict_expr_list_filepaths_semantic_early = []
let s:verdict_expr_list_filepaths_semantic_later = []

if exists('b:did_nftables_verdict_expr')
  call nftables#syntax#log('INFO', 'Skipped verdict_expr (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:verdict_expr_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading verdict_expr syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

hi link    nft_chain_stmt_delimiters nftHL_Delimiters
syn region nft_chain_stmt_delimiters start=+{+ end=+}+ skipwhite contained
\ contains=
\    @nft_c_rule


"******************** BEGIN verdict_stmt ******************************
hi link   nft_verdict_expr_chain_expr_identifier nftHL_Chain
syn match nft_verdict_expr_chain_expr_identifier '\v(\$)?[a-zA-Z][a-zA-Z0-9_]{0,63}' skipwhite contained
\ contains=
\    nft_identifier,
\    nft_identifier_last,
\    nft_variable_identifier,
\    nft_chain_stmt_delimiters,
\    nft_rule_cluster_Error

hi link   nft_verdict_expr_keyword_continue nftHL_Statement
syn match nft_verdict_expr_keyword_continue "\vcontinue\ze[ \t\n;]" skipwhite contained
\ nextgroup=
\    nft_chain_stmt_delimiters
" there is no nextgroup=nft_Error here, it can optionally end here for rule 'redirect'

hi link   nft_verdict_expr_keyword_accept nftHL_Statement
syn match nft_verdict_expr_keyword_accept '\vaccept\ze[ \t;\n]' skipwhite contained
\ nextgroup=
\    nft_chain_stmt_delimiters

hi link   nft_verdict_expr_keyword_return nftHL_Statement
syn match nft_verdict_expr_keyword_return '\vreturn\ze[ \t;\n]' skipwhite contained
\ nextgroup=
\    nft_chain_stmt_delimiters

hi link   nft_verdict_expr_keyword_drop nftHL_Statement
syn match nft_verdict_expr_keyword_drop '\vdrop\ze[ \t;\n]' skipwhite contained
\ nextgroup=
\    nft_chain_stmt_delimiters

hi link   nft_verdict_expr_keyword_goto nftHL_Statement
syn match nft_verdict_expr_keyword_goto '\vgoto\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    nft_verdict_expr_chain_expr_identifier,
\    nft_chain_stmt_delimiters,
\    nft_rule_cluster_Error

hi link   nft_verdict_expr_keyword_jump nftHL_Statement
syn match nft_verdict_expr_keyword_jump '\vjump\ze[ \t]' keepend skipwhite contained
\ nextgroup=
\    nft_verdict_expr_chain_expr_identifier,
\    nft_rule_cluster_Error

syn cluster nft_c_verdict_expr
\ contains=
\    nft_verdict_expr_keyword_continue,
\    nft_verdict_expr_keyword_accept,
\    nft_verdict_expr_keyword_return,
\    nft_verdict_expr_keyword_drop,
\    nft_verdict_expr_keyword_goto,
\    nft_verdict_expr_keyword_jump

"******************** BEGIN verdict_stmt ******************************


  for s:this_semantic_file in s:verdict_expr_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded verdict_expr for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define verdict_expr.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_verdict_expr = v:true
