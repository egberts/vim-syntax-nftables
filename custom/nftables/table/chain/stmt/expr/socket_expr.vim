" File: socket_expr.vim
" Directory: custom/nftables/table/chain/stmt/expr/
"
let s:socket_expr_list_filepaths_semantic_early = []
let s:socket_expr_list_filepaths_semantic_later = []

if exists('b:did_nftables_socket_expr')
  call nftables#syntax#log('INFO', 'Skipped socket_expr (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:socket_expr_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading socket_expr syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
" Form                                              Valid   Explanation
" socket cgroupv2 level 5 accept                        ✅   Normal numeric match
" socket cgroupv2 level 5 in { 1, 2, 3 }                ✅   Set membership
" socket cgroupv2 level 5 map { 1 : accept, 2 : drop }  ✅   Map by numeric key
" socket cgroupv2 map { 1 : accept }                    ❌   Invalid grammar
" socket cgroupv2 level 5 'user.slice' accept           ❌   Invalid syntax
"
" **************** BEGIN socket_expr ********************************
" socket_expr -> primary_expr
" socket_expr -> primary_stmt_expr


" socket_key->socket_expr->(primary_expr|primary_stmt_expr)
hi link   nft_socket_expr_socket_key_keyword_transparent nftHL_Substatement
syn match nft_socket_expr_socket_key_keyword_transparent '\vtransparent\ze[ \t\n;]' skipwhite contained

hi link   nft_socket_expr_socket_key_keyword_wildcard nftHL_Substatement
syn match nft_socket_expr_socket_key_keyword_wildcard '\vwildcard\ze[ \t\n;]' skipwhite contained

hi link   nft_socket_expr_socket_key_keyword_mark nftHL_Substatement
syn match nft_socket_expr_socket_key_keyword_mark '\vmark\ze[ \t\n;]' skipwhite contained

" 'cgroupv2' <num>->socket_expr->(primary_expr|primary_stmt_expr)
hi link   nft_socket_expr_cgroupv2_num nftHL_Number
syn match nft_socket_expr_cgroupv2_num '\v(6[0-3]|[1-5][0-9]|[0-9])\ze[ \t\n;]' skipwhite contained

" 'level'->socket_expr->(primary_expr|primary_stmt_expr)
hi link   nft_socket_expr_keyword_level nftHL_Substatement
syn match nft_socket_expr_keyword_level '\vlevel\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_socket_expr_cgroupv2_num,
\    nft_Error

" 'cgroupv2'->socket_expr->(primary_expr|primary_stmt_expr)
hi link   nft_socket_expr_keyword_cgroupv2 nftHL_Substatement
syn match nft_socket_expr_keyword_cgroupv2 '\vcgroupv2\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_socket_expr_keyword_level,
\    nft_Error

" socket_expr->(primary_expr|primary_stmt_expr)

hi link   nft_socket_expr_keyword_socket nftHL_Command
syn match nft_socket_expr_keyword_socket '\vsocket\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_socket_expr_socket_key_keyword_transparent,
\    nft_socket_expr_keyword_cgroupv2,
\    nft_socket_expr_socket_key_keyword_wildcard,
\    nft_socket_expr_socket_key_keyword_mark,
\    nft_Error
" ***************** END socket_expr **********************************



  for s:this_semantic_file in s:socket_expr_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded socket_expr for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define socket_expr.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_socket_expr = v:true
