" File: primary_expr.vim
" Directory: custom/nftables/table/chain/stmt/expr/
"
let s:primary_expr_list_filepaths_semantic_early = []
let s:primary_expr_list_filepaths_semantic_later = []

if exists('b:did_nftables_primary_expr')
  call nftables#syntax#log('INFO', 'Skipped primary_expr (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:primary_expr_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading primary_expr syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
" ************************* BEGIN fib' expression *************************
" fib (Forward Information Base) is about routing decision.
hi link   nft_primary_expr_fib_named_set nftHL_Set
syn match nft_primary_expr_fib_named_set '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib
" fib expression can only handle one field per 'fib'
" no expressions cluster needed if sharing the same 'fib' expression as multiple fibs on same line

" ************************* BEGIN fib oifname' expression *************************
" oifname	Output interface name (string).
"  'fib [key] oifname in { 1,127,255 }'
" no wildcard device name (asterisk) support within inline set; just regular device name
hi link   nft_primary_expr_fib_oifname_inline_set_interface nftHL_Device
syn match nft_primary_expr_fib_oifname_inline_set_interface '\v[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t,\}\n]' skipwhite contained

"  'fib [key] oifname in { }'
hi link    nft_primary_expr_fib_oifname_inline_set nftHL_BlockDelimitersSet
syn region nft_primary_expr_fib_oifname_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_primary_expr_fib_oifname_inline_set_interface,
\    nft_Error
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib

"   fib [key] oifname 'br*'
hi link   nft_primary_expr_fib_oifname_device_interface_wildcard nftHL_String
syn match nft_primary_expr_fib_oifname_device_interface_wildcard '\v\"[a-zA-Z][a-zA-Z0-9\-_\*]{0,63}\"\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,

"   'fib [key] oifname eth0'
hi link   nft_primary_expr_fib_oifname_device_interface_name nftHL_Device
syn match nft_primary_expr_fib_oifname_device_interface_name '\v[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,

"  'fib [key] oifname in'
hi link   nft_primary_expr_fib_oifname_keyword_in nftHL_Keyword
syn match nft_primary_expr_fib_oifname_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_oifname_inline_set

"  fib [key] oifname >
hi link   nft_primary_expr_fib_oifname_operator_1char nftHL_Expression
syn match nft_primary_expr_fib_oifname_operator_1char '\v\!' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_oifname_device_interface_wildcard,
\    nft_primary_expr_fib_oifname_device_interface_name,
\    nft_chainError

"  fib [key] oifname >=
hi link   nft_primary_expr_fib_oifname_operator_2char nftHL_Expression
syn match nft_primary_expr_fib_oifname_operator_2char '\v[\!\=]\=' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_oifname_device_interface_wildcard,
\    nft_primary_expr_fib_oifname_device_interface_name,
\    nft_chainError

"  'fib [key] oifname not in'
hi link   nft_primary_expr_fib_oifname_keyword_not nftHL_Operator
syn match nft_primary_expr_fib_oifname_keyword_not '\vnot' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_oifname_keyword_in

"  fib [key] oifname
hi link   nft_primary_expr_fib_oifname_keyword_oifname nftHL_Keyword
syn match nft_primary_expr_fib_oifname_keyword_oifname '\voifname\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_oifname_keyword_not,
\    nft_primary_expr_fib_named_set,
\    nft_primary_expr_fib_oifname_operator_2char,
\    nft_primary_expr_fib_oifname_keyword_in,
\    nft_primary_expr_fib_oifname_operator_1char,
\    nft_primary_expr_fib_oifname_inline_set,
\    nft_primary_expr_fib_oifname_device_interface_wildcard,
\    nft_primary_expr_fib_oifname_device_interface_name,
\    nft_chainError
" ************************* END fib oifname' expression *************************

" ************************* BEGIN fib daddr' expression *************************
"  fib daddr
hi link   nft_primary_expr_fib_keyword_daddr nftHL_Keyword
syn match nft_primary_expr_fib_keyword_daddr '\vdaddr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_oifname_keyword_oifname,
\    nft_primary_expr_fib_flags_keyword_flags,
\    nft_primary_expr_fib_scope_keyword_scope,
\    nft_primary_expr_fib_mark_keyword_mark,
\    nft_primary_expr_fib_type_keyword_type,
\    nft_primary_expr_fib_oif_keyword_oif,
\    nft_chainError
" ************************* END fib daddr' expression *************************

" ************************* BEGIN fib flags' expression *************************
" flags	Route flags (dynamic, dead, onlink, etc. — bitmask from kernel fib flags).
hi link   nft_primary_expr_fib_flags_inline_set_defines nftHL_Define
syn match nft_primary_expr_fib_flags_inline_set_defines '\v(unreachable|blackhole|broadcast|multicast|prohibit|anycast|offload|unicast|unspec|local|dead|dyn)\ze[ ,\t\n\}]' skipwhite contained

"  fib [key] flags in {  }
hi link    nft_primary_expr_fib_flags_inline_set nftHL_BlockDelimitersSet
syn region nft_primary_expr_fib_flags_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_primary_expr_fib_flags_inline_set_defines
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib

"  fib [key] flags in
hi link   nft_primary_expr_fib_flags_keyword_in nftHL_Keyword
syn match nft_primary_expr_fib_flags_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_flags_inline_set

hi link   nft_primary_expr_fib_flags_defines nftHL_Define
syn match nft_primary_expr_fib_flags_defines '\v(unreachable|blackhole|broadcast|multicast|prohibit|anycast|offload|unicast|unspec|local|dead|dyn)\ze[ ,\t\n\}]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,

"  'fib [key] flags !'
hi link   nft_primary_expr_fib_flags_operator_1char nftHL_Expression
syn match nft_primary_expr_fib_flags_operator_1char '\v\!' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_flags_defines,
\    nft_chainError

"  fib [key] flags >=
hi link   nft_primary_expr_fib_flags_operator_2char nftHL_Expression
syn match nft_primary_expr_fib_flags_operator_2char '\v[\!\=]\=' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_flags_defines,
\    nft_chainError

hi link   nft_primary_expr_fib_flags_keyword_not nftHL_Operator
syn match nft_primary_expr_fib_flags_keyword_not '\vnot' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_flags_keyword_in,

"  fib [key] flags
hi link   nft_primary_expr_fib_flags_keyword_flags nftHL_Keyword
syn match nft_primary_expr_fib_flags_keyword_flags '\vflags\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_flags_keyword_not,
\    nft_primary_expr_fib_flags_operator_2char,
\    nft_primary_expr_fib_flags_keyword_in,
\    nft_primary_expr_fib_flags_operator_1char,
\    nft_primary_expr_fib_named_set,
\    nft_primary_expr_fib_flags_inline_set,
\    nft_primary_expr_fib_flags_defines,
\    nft_chainError
" ************************* END fib flags' expression *************************

" ************************* BEGIN fib saddr' expression *************************
"  tcp doff
hi link   nft_primary_expr_fib_keyword_saddr nftHL_Keyword
syn match nft_primary_expr_fib_keyword_saddr '\vsaddr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_oifname_keyword_oifname,
\    nft_primary_expr_fib_flags_keyword_flags,
\    nft_primary_expr_fib_scope_keyword_scope,
\    nft_primary_expr_fib_mark_keyword_mark,
\    nft_primary_expr_fib_type_keyword_type,
\    nft_primary_expr_fib_oif_keyword_oif,
\    nft_chainError
" ************************* END fib saddr' expression *************************

" ************************* BEGIN fib [key] scope' expression *************************
" scope	Route scope (host, link, site, universe).
hi link   nft_primary_expr_fib_scope_inline_set_defines nftHL_Define
syn match nft_primary_expr_fib_scope_inline_set_defines '\v(universe|nowhere|global|host|link|site)\ze[ ,\t\n\}]' skipwhite contained

hi link   nft_primary_expr_fib_scope_inline_set_num nftHL_Define
syn match nft_primary_expr_fib_scope_inline_set_num '\v[0-9]{1,3}\ze[ ,\t\n\}]' skipwhite contained

"  fib scope in {  }
hi link    nft_primary_expr_fib_scope_inline_set nftHL_BlockDelimitersSet
syn region nft_primary_expr_fib_scope_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_primary_expr_fib_scope_inline_set_defines,
\    nft_primary_expr_fib_scope_inline_set_num
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib

"  fib scope in
hi link   nft_primary_expr_fib_scope_keyword_in nftHL_Keyword
syn match nft_primary_expr_fib_scope_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_scope_inline_set

hi link   nft_primary_expr_fib_scope_defines nftHL_Define
syn match nft_primary_expr_fib_scope_defines '\v(universe|nowhere|global|host|link|site)\ze[ ,\t\n\}]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,

hi link   nft_primary_expr_fib_scope_num nftHL_Integer
syn match nft_primary_expr_fib_scope_num '\v[0-9]{1,3}\ze[ ,\t\n\}]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,

"  'fib scope !'
hi link   nft_primary_expr_fib_scope_operator_1char nftHL_Expression
syn match nft_primary_expr_fib_scope_operator_1char '\v[\!\>\<]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_scope_defines,
\    nft_primary_expr_fib_scope_num,
\    nft_chainError

"  tcp doff >=
hi link   nft_primary_expr_fib_scope_operator_2char nftHL_Expression
syn match nft_primary_expr_fib_scope_operator_2char '\v[\>\<\!\=]\=' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_scope_defines,
\    nft_primary_expr_fib_scope_num,
\    nft_chainError

hi link   nft_primary_expr_fib_scope_keyword_not nftHL_Operator
syn match nft_primary_expr_fib_scope_keyword_not '\vnot' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_scope_keyword_in,

"  fib [key] scope
hi link   nft_primary_expr_fib_scope_keyword_scope nftHL_Keyword
syn match nft_primary_expr_fib_scope_keyword_scope '\vscope\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_scope_defines,
\    nft_primary_expr_fib_scope_keyword_not,
\    nft_primary_expr_fib_scope_operator_2char,
\    nft_primary_expr_fib_scope_keyword_in,
\    nft_primary_expr_fib_scope_operator_1char,
\    nft_primary_expr_fib_named_set,
\    nft_primary_expr_fib_scope_inline_set,
\    nft_primary_expr_fib_scope_num,
\    nft_chainError
" ************************* END fib scope' expression *************************

" ************************* BEGIN fib mark' expression *************************
" mark	Routing mark lookup (uses fwmark, useful with policy routing).
"  fib mark in { 0x80000001  }
hi link   nft_primary_expr_fib_mark_inline_set_num nftHL_Integer
syn match nft_primary_expr_fib_mark_inline_set_num '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t,\}\n]' skipwhite contained

"  fib mark in {  }
hi link    nft_primary_expr_fib_mark_inline_set nftHL_BlockDelimitersSet
syn region nft_primary_expr_fib_mark_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_primary_expr_fib_mark_inline_set_num
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,

"  fib mark in
hi link   nft_primary_expr_fib_mark_keyword_in nftHL_Keyword
syn match nft_primary_expr_fib_mark_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_mark_inline_set

hi link   nft_primary_expr_fib_mark_num2 nftHL_Integer
syn match nft_primary_expr_fib_mark_num2 '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib

hi link   nft_primary_expr_fib_mark_dash_symbol nftHL_Expression
syn match nft_primary_expr_fib_mark_dash_symbol '\v\-\ze[0-9]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_mark_num2,
\    nft_chainError

hi link   nft_primary_expr_fib_mark_num_or_range nftHL_Integer
syn match nft_primary_expr_fib_mark_num_or_range '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,
\    nft_primary_expr_fib_mark_dash_symbol

"  fib mark >
hi link   nft_primary_expr_fib_mark_operator_1char nftHL_Expression
syn match nft_primary_expr_fib_mark_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_mark_num_or_range,
\    nft_chainError

"  fib mark >=
hi link   nft_primary_expr_fib_mark_operator_2char nftHL_Expression
syn match nft_primary_expr_fib_mark_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_mark_num_or_range,
\    nft_chainError

"  fib [key] mark
hi link   nft_primary_expr_fib_mark_keyword_mark nftHL_Keyword
syn match nft_primary_expr_fib_mark_keyword_mark '\vmark\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_mark_operator_2char,
\    nft_primary_expr_fib_mark_keyword_in,
\    nft_primary_expr_fib_mark_operator_1char,
\    nft_primary_expr_fib_named_set,
\    nft_primary_expr_fib_mark_inline_set,
\    nft_primary_expr_fib_mark_num_or_range,
\    nft_chainError

hi link   nft_primary_expr_fib_keyword_mark nftHL_Keyword
syn match nft_primary_expr_fib_keyword_mark '\vmark\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_oifname_keyword_oifname,
\    nft_primary_expr_fib_flags_keyword_flags,
\    nft_primary_expr_fib_scope_keyword_scope,
\    nft_primary_expr_fib_mark_keyword_mark,
\    nft_primary_expr_fib_type_keyword_type,
\    nft_primary_expr_fib_oif_keyword_oif,
\    nft_chainError
" ************************* END fib mark' expression *************************

" ************************* BEGIN fib [key] type' expression *************************
"  fib [key] type
hi link   nft_primary_expr_fib_type_keyword_type nftHL_Keyword
syn match nft_primary_expr_fib_type_keyword_type '\vtype\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_flags_defines,
\    nft_primary_expr_fib_flags_keyword_not,
\    nft_primary_expr_fib_flags_operator_2char,
\    nft_primary_expr_fib_flags_keyword_in,
\    nft_primary_expr_fib_flags_operator_1char,
\    nft_primary_expr_fib_named_set,
\    nft_primary_expr_fib_flags_inline_set,
\    nft_primary_expr_fib_flags_num,
\    nft_chainError
" ************************* END fib [key] type' expression *************************

" ************************* BEGIN fib iif' expression *************************
" iif	Input interface index.
"  fib iif in { 0x80000001  }
hi link   nft_primary_expr_fib_iif_inline_set_num nftHL_Integer
syn match nft_primary_expr_fib_iif_inline_set_num '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t,\}\n]' skipwhite contained

"  fib iif in {  }
hi link    nft_primary_expr_fib_iif_inline_set nftHL_BlockDelimitersSet
syn region nft_primary_expr_fib_iif_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_primary_expr_fib_iif_inline_set_num
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,

"  fib iif in
hi link   nft_primary_expr_fib_iif_keyword_in nftHL_Keyword
syn match nft_primary_expr_fib_iif_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_iif_inline_set

hi link   nft_primary_expr_fib_iif_num2 nftHL_Integer
syn match nft_primary_expr_fib_iif_num2 '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib

hi link   nft_primary_expr_fib_iif_dash_symbol nftHL_Expression
syn match nft_primary_expr_fib_iif_dash_symbol '\v\-\ze[0-9]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_iif_num2,
\    nft_chainError

hi link   nft_primary_expr_fib_iif_num_or_range nftHL_Integer
syn match nft_primary_expr_fib_iif_num_or_range '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,
\    nft_primary_expr_fib_iif_dash_symbol

"  fib iif >
hi link   nft_primary_expr_fib_iif_operator_1char nftHL_Expression
syn match nft_primary_expr_fib_iif_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_iif_num_or_range,
\    nft_chainError

"  fib iif >=
hi link   nft_primary_expr_fib_iif_operator_2char nftHL_Expression
syn match nft_primary_expr_fib_iif_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_iif_num_or_range,
\    nft_chainError

"  fib iif
hi link   nft_primary_expr_fib_iif_keyword_iif nftHL_Keyword
syn match nft_primary_expr_fib_iif_keyword_iif '\viif\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_iif_operator_2char,
\    nft_primary_expr_fib_iif_keyword_in,
\    nft_primary_expr_fib_iif_operator_1char,
\    nft_primary_expr_fib_named_set,
\    nft_primary_expr_fib_iif_inline_set,
\    nft_primary_expr_fib_iif_num_or_range,
\    nft_chainError

"  fib iif
hi link   nft_primary_expr_fib_keyword_iif nftHL_Keyword
syn match nft_primary_expr_fib_keyword_iif '\viif\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_oifname_keyword_oifname,
\    nft_primary_expr_fib_flags_keyword_flags,
\    nft_primary_expr_fib_scope_keyword_scope,
\    nft_primary_expr_fib_mark_keyword_mark,
\    nft_primary_expr_fib_type_keyword_type,
\    nft_primary_expr_fib_oif_keyword_oif,
\    nft_chainError
" ************************* END fib iif' expression *************************

" ************************* BEGIN fib oif' expression *************************
" oif	Output interface index.
"  fib iif
hi link   nft_primary_expr_fib_oif_keyword_oif nftHL_Keyword
syn match nft_primary_expr_fib_oif_keyword_oif '\voif\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_iif_operator_2char,
\    nft_primary_expr_fib_iif_keyword_in,
\    nft_primary_expr_fib_iif_operator_1char,
\    nft_primary_expr_fib_named_set,
\    nft_primary_expr_fib_iif_inline_set,
\    nft_primary_expr_fib_iif_num_or_range,
\    nft_chainError

hi link   nft_primary_expr_fib_keyword_oif nftHL_Keyword
syn match nft_primary_expr_fib_keyword_oif '\voif\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_oifname_keyword_oifname,
\    nft_primary_expr_fib_flags_keyword_flags,
\    nft_primary_expr_fib_scope_keyword_scope,
\    nft_primary_expr_fib_mark_keyword_mark,
\    nft_primary_expr_fib_type_keyword_type,
\    nft_primary_expr_fib_oif_keyword_oif,
\    nft_chainError
" **************** END fib oif' expression *************

hi link   nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib '\vfib\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_keyword_daddr,
\    nft_primary_expr_fib_keyword_saddr,
\    nft_primary_expr_fib_keyword_mark,
\    nft_primary_expr_fib_keyword_iif,
\    nft_primary_expr_fib_keyword_oif
" **************** END fib_expr **************************************

" **************** BEGIN primary_expr ********************************
syn cluster nft_c_primary_expr
\ contains=
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_rtclassid,
\    nft_verdict_expr_keyword_continue,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_oifgroup,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_iifgroup,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_obriport,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_ibriport,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_ibrname,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_iifname,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_iiftype,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_nftrace,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_obrname,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_oifname,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_oiftype,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_pkttype,
\    nft_payload_expr_hash_expr_keyword_symhash,
\    nft_payload_expr_udplite_hdr_expr_keyword_udplite,
\    nft_verdict_expr_keyword_accept,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_cgroup,
\    nft_payload_expr_geneve_hdr_expr_keyword_geneve,
\    nft_payload_expr_gretap_hdr_expr_keyword_gretap,
\    nft_payload_expr_icmpv6_hdr_expr_keyword_icmpv6,
\    nft_verdict_expr_keyword_return,
\    nft_payload_expr_numgen_expr_keyword_numgen,
\    nft_payload_expr_keyword_expr_keyword_ether,
\    nft_payload_expr_hash_expr_keyword_jhash,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_ipsec,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_skuid,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_skgid,
\    nft_payload_expr_vxlan_hdr_expr_keyword_vxlan,
\    nft_payload_expr_comp_hdr_expr_keyword_comp,
\    nft_payload_expr_dccp_hdr_expr_keyword_dccp,
\    nft_verdict_expr_keyword_drop,
\    nft_verdict_expr_keyword_goto,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_hour,
\    nft_payload_expr_icmp_hdr_expr_keyword_icmp,
\    nft_payload_expr_igmp_hdr_expr_keyword_igmp,
\    nft_verdict_expr_keyword_jump,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_mark,
\    nft_payload_expr_meta_expr_keyword_meta,
\    nft_payload_expr_sctp_hdr_expr_keyword_sctp,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_time,
\    nft_keyword_expr_keyword_vlan,
\    nft_keyword_expr_keyword_arp,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_cpu,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_day,
\    nft_payload_expr_esp_hdr_expr_keyword_esp,
\    nft_payload_expr_gre_hdr_expr_keyword_gre,
\    nft_meta_expr_meta_key_unqualified_keyword_iif,
\    nft_payload_expr_ip6_hdr_expr_keyword_ip6,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_oif,
\    nft_payload_expr_tcp_hdr_expr_keyword_tcp,
\    nft_payload_expr_udp_hdr_expr_keyword_udp,
\    nft_payload_expr_auth_hdr_expr_keyword_ah,
\    nft_payload_expr_ct_expr_keyword_ct,
\    nft_keyword_expr_keyword_ip,
\    nft_payload_expr_rt_expr_keyword_rt,
\    nft_payload_expr_th_hdr_expr_keyword_th,
\    nft_payload_expr_payload_raw_expr_keyword_at,
\    nft_stmt_primary_stmt_expr_symbol_expr_variable_expr,
\    nft_stmt_primary_stmt_expr_integer_expr_num,
\    nft_stmt_primary_stmt_expr_symbol_expr_string
" **************** END primary_expr **********************************

  for s:this_semantic_file in s:primary_expr_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded primary_expr for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define primary_expr.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_primary_expr = v:true
