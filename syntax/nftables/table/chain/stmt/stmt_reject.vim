" File: stmt_reject.vim
" Directory: custom/nftables/table/chain/stmt/
"
let s:stmt_reject_list_filepaths_semantic_early = []
let s:stmt_reject_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_reject')
  call nftables#syntax#log('INFO', 'Skipped stmt_reject (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_reject_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_reject syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "


" ************************* BEGIN reject_stmt ************************
hi link   nft_reject_stmt_reject_opts_icmp_integer_expr_num_uint8_hex nftHL_Integer
syn match nft_reject_stmt_reject_opts_icmp_integer_expr_num_uint8_hex '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9]{1,2})\ze[ \t\n;]' skipwhite contained

hi link   nft_reject_stmt_reject_opts_icmpx_types_symbol_expr_enum nftHL_Define
syn match nft_reject_stmt_reject_opts_icmpx_types_symbol_expr_enum
\ '\v(addr\-unreachable|admin\-prohibited|port\-unreachable|not\-neighbor|reject\-route|policy\-fail|prohibited|no\-route)\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_reject_stmt_reject_opts_constant_expr_inline_set_icmpx_types_enum nftHL_Define
syn match nft_reject_stmt_reject_opts_constant_expr_inline_set_icmpx_types_enum
\ '\v(addr\-unreachable|admin\-prohibited|port\-unreachable|not\-neighbor|reject\-route|policy\-fail|prohibited|no\-route)\ze[ \t\n,]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link    nft_reject_stmt_reject_opts_constant_expr_inline_delimiters nftHL_BlockDelimiterSet
syn region nft_reject_stmt_reject_opts_constant_expr_inline_delimiters start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_reject_stmt_reject_opts_constant_expr_inline_set_icmpx_types_enum

hi link   nft_reject_stmt_reject_opts_icmp_types_enum nftHL_Define
syn match nft_reject_stmt_reject_opts_icmp_types_enum
\ '\vfragmentation\-needed|(host\-unreachable\-tos)|precedence\-violation|protocol\-unreachable|net\-unreachable\-tos|source\-route\-failed|precedence\-cutoff|admin\-prohibited|host\-unreachable|port\-unreachable|net\-unreachable|host\-isolated|host\-unknown|net\-unknown|host\-anon|net\-anon\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt


hi link   nft_reject_stmt_reject_opts_icmp_keyword_type nftHL_Keyword
syn match nft_reject_stmt_reject_opts_icmp_keyword_type '\vtype\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_reject_stmt_reject_opts_icmp_types_enum,
\    nft_reject_stmt_reject_opts_icmp_integer_expr_num_uint8_hex,
\    nft_Error

hi link   nft_reject_stmt_reject_opts_icmpx_keyword_type nftHL_Keyword
syn match nft_reject_stmt_reject_opts_icmpx_keyword_type '\vtype\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_reject_stmt_reject_opts_icmpx_types_symbol_expr_enum,
\    nft_reject_stmt_reject_opts_constant_expr_inline_delimiters,
\    nft_reject_stmt_reject_opts_icmp_integer_expr_num_uint8_hex,
\    nft_Error

hi link   nft_reject_stmt_reject_opts_icmpv6_keyword_type nftHL_Keyword
syn match nft_reject_stmt_reject_opts_icmpv6_keyword_type '\vtype' skipwhite contained
\ nextgroup=
\    nft_reject_stmt_reject_opts_icmpx_types_symbol_expr_enum,
\    nft_reject_stmt_reject_opts_constant_expr_inline_delimiters,
\    nft_reject_stmt_reject_opts_icmp_integer_expr_num_uint8_hex,
\    nft_Error

hi link   nft_reject_stmt_reject_opts_keyword_reset nftHL_Substatement
syn match nft_reject_stmt_reject_opts_keyword_reset '\vreset' skipwhite contained

hi link   nft_reject_stmt_reject_opts_keyword_icmp nftHL_Substatement
syn match nft_reject_stmt_reject_opts_keyword_icmp '\vicmp' skipwhite contained
\ nextgroup=
\    nft_reject_stmt_reject_opts_icmp_keyword_type,
\    nft_Error

hi link   nft_reject_stmt_reject_opts_keyword_icmpx nftHL_Substatement
syn match nft_reject_stmt_reject_opts_keyword_icmpx '\vicmpx\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_reject_stmt_reject_opts_icmpx_keyword_type,
\    nft_Error

hi link   nft_reject_stmt_reject_opts_keyword_icmpv6 nftHL_Substatement
syn match nft_reject_stmt_reject_opts_keyword_icmpv6 '\v(ipv6\-icmp|icmpv6)' skipwhite contained
\ nextgroup=
\    nft_reject_stmt_reject_opts_icmpv6_keyword_type,
\    nft_Error

hi link   nft_reject_stmt_reject_opts_keyword_tcp nftHL_Substatement
syn match nft_reject_stmt_reject_opts_keyword_tcp '\vtcp' skipwhite contained
\ nextgroup=
\    nft_reject_stmt_reject_opts_keyword_reset

hi link   nft_reject_stmt_reject_opts_keyword_with nftHL_Keyword
syn match nft_reject_stmt_reject_opts_keyword_with '\vwith' skipwhite contained
\ nextgroup=
\    nft_reject_stmt_reject_opts_keyword_icmpv6,
\    nft_reject_stmt_reject_opts_keyword_icmpx,
\    nft_reject_stmt_reject_opts_keyword_icmp,
\    nft_reject_stmt_reject_opts_keyword_tcp,
\    nft_reject_stmt_reject_opts_icmp_keyword_type,
\    nft_reject_stmt_reject_opts_icmp_types_enum,
\    nft_reject_stmt_reject_opts_icmp_integer_expr_num_uint8_hex,
\    nft_reject_stmt_reject_opts_icmpx_keyword_type,
\    nft_reject_stmt_reject_opts_icmpx_types_symbol_expr_enum,
\    nft_reject_stmt_reject_opts_icmp_integer_expr_num_uint8_hex,
\    nft_Error

hi link   nft_stmt_reject_stmt_reject_stmt_alloc_keyword_reject nftHL_Command
syn match nft_stmt_reject_stmt_reject_stmt_alloc_keyword_reject '\vreject\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_reject_stmt_reject_opts_keyword_with,
\    nft_expected_semicolon_or_new_line
" ************************* END reject_stmt **************************

  for s:this_semantic_file in s:stmt_reject_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_reject for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_reject.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_reject = v:true
