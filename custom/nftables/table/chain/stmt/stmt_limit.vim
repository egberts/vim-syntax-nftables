" File: stmt_limit.vim
" Directory: custom/nftables/
" The actual start of 'stmt' statements for starting 'limit' token/keyword
"
"  The 'limit' keyword is the focus here within this file
"  (and not the 'payload_expr' semantic action that it appears to emulate).
"
" Some overlays for 'limit' keywords as the token opener of statements are:
"
"    - keyword_expr (simplest 'limit')
"    - payload_stmt is a write and has a 'set' keyword
"    - primary_expr (includes payload_expr) is a read-only  ('limit protocol icmp')
"    - primary_stmt_expr is this run-on, add-ons of additional 'expr' for each 'stmt'
"    - concat_stmt_expr is this 'glueless' run-on of 'primary_stmt_expr' together.
"    - payload_stmt_expr is may be surrounded by parenthesis during 'glueless'
"          concat_stmt_expr chaining, e.g., 'limit protocol icmp (icmp type echo-request)'
"
" For expression, see 'limit_expr.vim'
"
"  By staying true to LL(1) (or keyword-centric, we avoid clashes by semantic actions)

let s:stmt_limit_list_filepaths_semantic_early = []
let s:stmt_limit_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_limit')
  call nftables#syntax#log('INFO', 'Skipped stmt_limit (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_limit_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_limit syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

" 'limit' 'rate' [ 'over'|'until' ]
" limit_mode->limit_stmt->stateful_stmt
hi link   nft_limit_stmt_limit_config_limit_mode nftHL_Action
syn match nft_limit_stmt_limit_config_limit_mode "\v(over|until)" skipwhite contained
\ nextgroup=
\    nft_limit_stmt_limit_rate_pktsbytes_num



" ********************** BEGIN 'limit rate' **************************
" ***************** BEGIN 'limit rate [ 'over'|'until' ] *************
\    nft_stateful_stmt_limit_stmt_limit_rate_pkts_keyword_SLASH,
hi link   nft_stateful_stmt_limit_stmt_limit_rate_pkts_num_32b nftHL_Integer
syn match nft_stateful_stmt_limit_stmt_limit_rate_pkts_num_32b '\v[0-9]{1,11}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stateful_stmt_limit_stmt_limit_rate_pkts_keyword_SLASH,
\    nft_Error

" 'limit' 'rate' [ 'over'|'until' ]
" limit_mode->'limit'->set_elem_stmt->set_elem_expr_alloc
hi link   nft_stateful_stmt_limit_stmt_limit_mode nftHL_Action
syn match nft_stateful_stmt_limit_stmt_limit_mode "\v(over|until)\ze[ \t\n]" skipwhite contained
\ nextgroup=
\    nft_stateful_stmt_limit_stmt_limit_rate_pkts_num_32b,
\    nft_Error
" ******************* END 'limit rate [ 'over'|'until' ] *************

" 'rate'->limit_stmt->stateful_stmt
hi link   nft_stateful_stmt_limit_stmt_keyword_rate nftHL_Statement
syn match nft_stateful_stmt_limit_stmt_keyword_rate "rate" skipwhite contained
\ nextgroup=
\    nft_stateful_stmt_limit_stmt_limit_mode,
\    nft_stateful_stmt_limit_stmt_limit_rate_pktsbytes_num,
\    nft_Error
" ************************ END 'limit rate' **************************

" ********************** BEGIN 'limit' *******************************
" this is not an expression but THE opening statement 'limit' keyword
hi link   nft_stateful_stmt_limit_stmt_declarative_keyword_limit  nftHL_Command
syn match nft_stateful_stmt_limit_stmt_declarative_keyword_limit  '\vlimit\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stateful_stmt_limit_stmt_keyword_rate

" this is an expression
hi link   nft_add_rule_imperative_keyword_limit  nftHL_Command
syn match nft_add_rule_imperative_keyword_limit  '\vlimit\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stateful_stmt_limit_stmt_keyword_rate


" 'limit'
" 'limit'->limit_stmt->stateful_stmt
hi link   nft_limit_stmt nftHL_Statement
syn match nft_limit_stmt "limit" skipwhite contained
\ nextgroup=
\    nft_stateful_stmt_limit_stmt_keyword_rate

" ********************** BEGIN 'limit' *******************************


  for s:this_semantic_file in s:stmt_limit_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_limit for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_limit.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_limit = v:true
