" File: meta_expr.vim
" Directory: custom/nftables/table/chain/stmt/expr/
"
let s:meta_expr_list_filepaths_semantic_early = []
let s:meta_expr_list_filepaths_semantic_later = []

if exists('b:did_nftables_meta_expr')
  call nftables#syntax#log('INFO', 'Skipped meta_expr (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:meta_expr_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading meta_expr syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
" ************************ BEGIN meta_expr ***************************



" nft_c_string must be the LAST contains= (via nft_unquoted_string)
hi link   nft_meta_expr_close_scope_meta_device_index_set_element_separator nftHL_Separator
syn match nft_meta_expr_close_scope_meta_device_index_set_element_separator /,/ skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_device_index_set_quoted_identifier,
\    nft_meta_expr_close_scope_meta_device_index_set_number,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_device_index_set_quoted_identifier nftHL_String
syn match nft_meta_expr_close_scope_meta_device_index_set_quoted_identifier '\v\"[a-zA-Z][a-zA-Z0-9\-_]{0,63}\"' skipwhite contained
\ nextgroup= nft_meta_expr_close_scope_meta_device_index_set_element_separator, nft_Error
\ nextgroup=
\    nft_meta_expr_close_scope_meta_device_index_set_element_separator,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_keyword_set,
\    nft_Error

syn match nft_meta_expr_close_scope_meta_device_index_set_quoted_identifier '\v\'[a-zA-Z][a-zA-Z0-9\-_]{0,63}\'' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_device_index_set_element_separator,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_keyword_set,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_device_index_set_number Define
syn match nft_meta_expr_close_scope_meta_device_index_set_number '\v[0-9]{1,5}' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_device_index_set_element_separator,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_keyword_set,
\    nft_Error

hi link    nft_meta_expr_close_scope_meta_device_index_set_block nftHL_BlockDelimitersSet
syn region nft_meta_expr_close_scope_meta_device_index_set_block start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_keyword_set
\ contains=
\     nft_meta_expr_close_scope_meta_device_index_set_quoted_identifier,
\     nft_meta_expr_close_scope_meta_device_index_set_number,
\     nft_Error

hi link   nft_meta_expr_close_scope_meta_device_index_at_setname nftHL_AtSetname
syn match nft_meta_expr_close_scope_meta_device_index_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}[\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_keyword_set

hi link   nft_meta_expr_close_scope_meta_device_index_number nftHL_Integer
syn match nft_meta_expr_close_scope_meta_device_index_number '\v[0-9]{1,3}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_keyword_set

hi link   nft_meta_expr_close_scope_meta_device_index_quoted_identifier nftHL_String
syn match nft_meta_expr_close_scope_meta_device_index_quoted_identifier '\v\"[a-zA-Z][a-zA-Z0-9\-_\*]{0,63}\"[\ze[ \t\n;]' skipwhite contained
syn match nft_meta_expr_close_scope_meta_device_index_quoted_identifier '\v\'[a-zA-Z][a-zA-Z0-9\-_\*]{0,63}\'[\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_keyword_set

hi link   nft_meta_expr_close_scope_meta_device_index_identifier nftHL_Identifier
syn match nft_meta_expr_close_scope_meta_device_index_identifier '\v[a-zA-Z][a-zA-Z0-9\-_]{0,63}[\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_keyword_set

" equality operators support scalar, inline set
hi link   nft_meta_expr_close_scope_meta_device_index_operators_equality nftHL_Operator
syn match nft_meta_expr_close_scope_meta_device_index_operators_equality '\v(\!|\=)\=' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_device_index_at_setname,
\    nft_meta_expr_close_scope_meta_device_index_quoted_identifier,
\    nft_meta_expr_close_scope_meta_device_index_set_block,
\    nft_meta_expr_close_scope_meta_device_index_identifier,
\    nft_meta_expr_close_scope_meta_device_index_number,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_device_index_set_operator_in nftHL_Operator
syn match nft_meta_expr_close_scope_meta_device_index_set_operator_in '\vin\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_device_index_at_setname,
\    nft_meta_expr_close_scope_meta_device_index_set_block,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_device_index_operator_keyword_not nftHL_Operator
syn match nft_meta_expr_close_scope_meta_device_index_operator_keyword_not '\vnot\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_device_index_set_operator_in,
\    nft_meta_expr_close_scope_meta_device_index_set_block,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_device_index_keyword_any nftHL_Operator
syn match nft_meta_expr_close_scope_meta_device_index_keyword_any '\vany\ze[ \t;]' skipwhite contained
\ nextgroup=
\     nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_keyword_set


syn cluster nft_c_device_index
\ contains=
\    nft_meta_expr_close_scope_meta_device_index_keyword_any,
\    nft_meta_expr_close_scope_meta_device_index_operator_keyword_not,
\    nft_meta_expr_close_scope_meta_device_index_operators_equality,
\    nft_meta_expr_close_scope_meta_device_index_set_operator_in,
\    nft_meta_expr_close_scope_meta_device_index_quoted_identifier,
\    nft_meta_expr_close_scope_meta_device_index_identifier,
\    nft_meta_expr_close_scope_meta_device_index_number,




" ********************** BEGIN 'ip rtclassid' ************************
hi link   nft_meta_expr_close_scope_meta_nf_protocols Define
syn match nft_meta_expr_close_scope_meta_nf_protocols '\v([0-9]{1,3})|(bridge|netdev|unspec|inet|arp|ip6|ip)\ze[ \t;]' skipwhite contained

" 'meta' keyword is almost always followed by a value (except for 'random', 'nftrace', 'ipsec')
hi link   nft_meta_expr_close_scope_meta_route_class_integer_id nftHL_Define
syn match nft_meta_expr_close_scope_meta_route_class_integer_id '\v[0-9]{1,10}\ze[ \t;]' skipwhite contained


hi link   nft_meta_expr_close_scope_meta_route_class_at_setname nftHL_AtSetname
syn match nft_meta_expr_close_scope_meta_route_class_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}[\ze[ \t;]' skipwhite contained

hi link   nft_meta_expr_close_scope_meta_route_class_enum_any nftHL_Operator
syn match nft_meta_expr_close_scope_meta_route_class_enum_any '\vany\ze[ \t;]' skipwhite contained


hi link   nft_meta_expr_close_scope_meta_route_class_keyword_set nftHL_Write
syn match nft_meta_expr_close_scope_meta_route_class_keyword_set '\vset\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_route_class_integer_id

hi link   nft_meta_expr_meta_key_unqualified_keyword_rtclassid nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_rtclassid '\vrtclassid\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_route_class_keyword_set,
\    nft_meta_expr_close_scope_meta_route_class_enum_any,
\    nft_meta_expr_close_scope_meta_route_class_at_setname,
\    nft_meta_expr_close_scope_meta_route_class_integer_id,
\    nft_Error
" ************************ END 'meta rtclassid' **********************

" ********************** START 'meta ibriport' ***********************
hi link   nft_interface_name_regex_string_quoted nftHL_String
syn match nft_interface_name_regex_string_quoted '\v\"\S{1,64}\"' skipwhite contained
syn match nft_interface_name_regex_string_quoted '\v\'\S{1,64}\'' skipwhite contained

hi link   nft_interface_name_operator_regex_match nftHL_Operator
syn match nft_interface_name_operator_regex_match '\v\~' skipwhite contained
\ nextgroup= nft_interface_name_regex_string_quoted, nft_Error

hi link   nft_interface_name_operator_regex_not_match nftHL_Operator
syn match nft_interface_name_operator_regex_not_match '\v\!\~' skipwhite contained
\ nextgroup= nft_interface_name_regex_string_quoted, nft_Error

hi link   nft_interface_name_operator_special_any nftHL_Operator
syn match nft_interface_name_operator_special_any '\vany' skipwhite contained

hi link   nft_interface_name_set_element_separator nftHL_Separator
syn match nft_interface_name_set_element_separator /,/ skipwhite contained
\ nextgroup= nft_interface_name_set_block_element_string_quoted, nft_Error

hi link   nft_interface_name_set_block_element_string_quoted nftHL_String
syn match nft_interface_name_set_block_element_string_quoted '\v\"[a-zA-Z][a-zA-Z0-9\-_]{0,63}\"' skipwhite contained
\ nextgroup= nft_interface_name_set_element_separator, nft_Error

syn match nft_interface_name_set_block_element_string_quoted '\v\'[a-zA-Z][a-zA-Z0-9\-_]{0,63}\'' skipwhite contained
\ nextgroup= nft_interface_name_set_element_separator, nft_Error

hi link    nft_interface_name_set_block  nftHL_BlockDelimitersSet
syn region nft_interface_name_set_block start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_interface_name_set_block_element_string_quoted,
\    nft_Error
" 'any' keyword is not supported inside a set

hi link   nft_interface_name_namedset  nftHL_Identifier
syn match nft_interface_name_namedset '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_interface_name_quote_string_asterisk  nftHL_String
syn match nft_interface_name_quote_string_asterisk '\v\"[a-zA-Z][a-zA-Z0-9\-_\*]{0,15}\"\ze[ \t;]' skipwhite contained
syn match nft_interface_name_quote_string_asterisk '\v\'[a-zA-Z][a-zA-Z0-9\-_\*]{0,15}\'\ze[ \t;]' skipwhite contained

hi link   nft_interface_name_quote_mandatory  nftHL_String
syn match nft_interface_name_quote_mandatory '\v\"[a-zA-Z][a-zA-Z0-9\-_]{0,15}\"\ze[ \t;]' skipwhite contained
syn match nft_interface_name_quote_mandatory '\v\'[a-zA-Z][a-zA-Z0-9\-_]{0,15}\'\ze[ \t;]' skipwhite contained

hi link   nft_interface_name_operators_equality nftHL_Operator
syn match nft_interface_name_operators_equality '\v(\!|\=)\=' skipwhite contained
\ nextgroup=
\    nft_interface_name_quote_mandatory,
\    nft_interface_name_namedset,
\    nft_interface_name_set_block,
\    nft_Error

syn cluster nft_c_meta_expr_close_scope_meta_interface_name
\ contains=
\    nft_interface_name_operator_special_any,
\    nft_interface_name_operators_equality,
\    nft_interface_name_operator_regex_not_match,
\    nft_interface_name_operator_regex_match,
\    nft_interface_name_quote_string_asterisk

hi link   nft_meta_expr_meta_key_unqualified_keyword_ibriport nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_ibriport '\vibriport\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_meta_expr_close_scope_meta_interface_name,
\    nft_Error
" ************************ END 'meta ibriport' ***********************

" ********************** START 'meta iifgroup' ***********************
hi link   nft_ifgroup_index_integer nftHL_Integer
syn match nft_ifgroup_index_integer '\v[0-9]{1,10}\ze[ \t;]' skipwhite contained

hi link   nft_ifgroup_index_set_block_member_separator nftHL_Separator
syn match nft_ifgroup_index_set_block_member_separator /,/ skipwhite contained
\ nextgroup=
\    nft_ifgroup_index_set_block_member_integer,
\    nft_Error

hi link   nft_ifgroup_index_set_block_member_integer nftHL_Integer
syn match nft_ifgroup_index_set_block_member_integer '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_ifgroup_index_set_block_member_separator

hi link    nft_ifgroup_index_set_block nftHL_BlockDelimitersSet
syn region nft_ifgroup_index_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_ifgroup_index_set_block_member_integer

hi link   nft_ifgroup_index_at_setnamenamed_set_identifier nftHL_AtSetname
syn match nft_ifgroup_index_named_set_identifier '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_ifgroup_index_operator_set_keyword_in nftHL_Operator
syn match nft_ifgroup_index_operator_set_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ifgroup_index_set_block,
\    nft_ifgroup_index_named_set_identifier,
\    nft_Error

hi link   nft_ifgroup_index_operator_set_keyword_not nftHL_Operator
syn match nft_ifgroup_index_operator_set_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ifgroup_index_operator_set_keyword_in

hi link   nft_ifgroup_index_operators_relational_1char nftHL_Operator
syn match nft_ifgroup_index_operators_relational_1char '\v(\<|\>)' skipwhite contained
\ nextgroup=
\    nft_ifgroup_index_named_set_identifier,
\    nft_ifgroup_index_set_block,
\    nft_ifgroup_index_integer,
\    nft_Error

hi link   nft_ifgroup_index_operators_equality nftHL_Operator
syn match nft_ifgroup_index_operators_equality '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ifgroup_index_named_set_identifier,
\    nft_ifgroup_index_set_block,
\    nft_ifgroup_index_integer,
\    nft_Error

hi link   nft_ifgroup_index_operators_relational_2char nftHL_Operator
syn match nft_ifgroup_index_operators_relational_2char '\v(\<|\>)\=' skipwhite contained
\ nextgroup=
\    nft_ifgroup_index_named_set_identifier,
\    nft_ifgroup_index_set_block,
\    nft_ifgroup_index_integer,
\    nft_Error

syn cluster nft_c_ifgroup_index
\ contains=
\    nft_ifgroup_index_operator_set_keyword_not,
\    nft_ifgroup_index_operator_set_keyword_in,
\    nft_ifgroup_index_operators_relational_2char,
\    nft_ifgroup_index_operator_set_keyword_equality,
\    nft_ifgroup_index_operators_relational_1char,
\    nft_ifgroup_index_operators_equality,
\    nft_ifgroup_index_integer,
hi link   nft_time_interval_type Define

hi link   nft_meta_expr_meta_key_unqualified_keyword_iifgroup nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_iifgroup '\viifgroup\ze[ \t]' skipwhite contained
\ nextgroup= @nft_c_ifgroup_index, nft_Error
" ************************ END 'meta iifgroup' ***********************


" ********************** START 'meta obriport' ***********************
hi link   nft_meta_expr_meta_key_unqualified_keyword_obriport nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_obriport '\vobriport\ze[ \t]' skipwhite contained
\ nextgroup= @nft_c_meta_expr_close_scope_meta_interface_name, nft_Error
" ************************ END 'meta obriport' ***********************

" ********************** START 'meta ibrname' ************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_ibrname nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_ibrname '\vibrname\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_not,
\    nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_in,
\    @nft_c_meta_expr_close_scope_meta_interface_name_quoted_device_name,
\    nft_Error
" ************************ END 'meta ibrname' ************************

" ********************** START 'meta iifname' ************************
hi link   nft_meta_expr_close_scope_meta_ifname_integer nftHL_Integer
syn match nft_meta_expr_close_scope_meta_ifname_integer '\v[0-9]{1,10}' skipwhite contained
syn match nft_meta_expr_close_scope_meta_ifname_integer '\v0x[0-9a-f]{1,8}' skipwhite contained

hi link   nft_meta_expr_close_scope_meta_ifname_operators_relational_1char nftHL_Operator
syn match nft_meta_expr_close_scope_meta_ifname_operators_relational_1char '\v(\<|\>)' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_ifname_integer, nft_Error

hi link   nft_meta_expr_close_scope_meta_ifname_operators_relational_2char nftHL_Operator
syn match nft_meta_expr_close_scope_meta_ifname_operators_relational_2char '\v(\<|\>)\=' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_ifname_integer, nft_Error

hi link   nft_meta_expr_close_scope_meta_ifname_at_setname nftHL_AtSetname
syn match nft_meta_expr_close_scope_meta_ifname_at_setname '\v\@[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_meta_expr_close_scope_meta_ifname_operators_equality nftHL_Operator
syn match nft_meta_expr_close_scope_meta_ifname_operators_equality '\v(\!|\=)\=' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_ifname_integer,
\    nft_meta_expr_close_scope_meta_ifname_at_setname,
\    nft_meta_expr_close_scope_meta_ifname_set_block,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_ifname_integer_operand nftHL_Integer
syn match nft_meta_expr_close_scope_meta_ifname_integer_operand '\v(0x)?[0-9a-f]{1,10}' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_ifname_operators_relational_2char,
\    nft_meta_expr_close_scope_meta_ifname_operators_equality,
\    nft_meta_expr_close_scope_meta_ifname_operators_relational_1char

hi link   nft_meta_expr_close_scope_meta_ifname_operator_mask nftHL_Operator
syn match nft_meta_expr_close_scope_meta_ifname_operator_mask '\v\&' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_ifname_integer_operand,
\    nft_Error

hi link   nft_meta_expr_meta_key_unqualified_keyword_iifname nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_iifname '\viifname\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_not,
\    nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_in,
\    @nft_c_meta_expr_close_scope_meta_interface_name_quoted_device_name,
\    nft_Error
" ************************ END 'meta iifname' ************************

" ********************** START 'meta iiftype' ************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_iiftype nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_iiftype '\viiftype\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_interface_type,
\    nft_Error
" ************************ END 'meta iiftype' ************************

" ********************** START 'meta nfproto' ************************
hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_internal_string_keyword_nfproto_set nftHL_Write
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_internal_string_keyword_nfproto_set '\vset\ze[ \t]' skipwhite contained
\ nextgroup= nft_meta_expr_close_scope_meta_nf_protocols, nft_Error

hi link   nft_meta_expr_close_scope_meta_nfproto_id nftHL_Integer
syn match nft_meta_expr_close_scope_meta_nfproto_id '\v[0-9]{1,5}\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_internal_string_keyword_nfproto_set,
\    nft_stmt_separator

hi link   nft_meta_expr_close_scope_meta_nfproto_enum nftHL_Define
syn match nft_meta_expr_close_scope_meta_nfproto_enum '\v(bridge|netdev|inet|arp|ip6|ip)\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_internal_string_keyword_nfproto_set,
\    nft_stmt_separator

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_internal_string_keyword_nfproto nftHL_Substatement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_internal_string_keyword_nfproto '\vnfproto\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_meta_expr_close_scope_meta_nfproto_enum,
\    nft_meta_expr_close_scope_meta_nfproto_id,
\    nft_Error
" ************************ END 'meta nfproto' ************************
" ********************** START 'meta nftrace' ************************

" 'meta nftrace'
hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_value nftHL_Number
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_value '\v[0-1]{1}\ze[ \t;]' skipwhite contained
hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_comparison nftHL_Operator
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_comparison '\v(\<|\>|\!|\=)\=\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_value

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_set_elements nftHL_BlockDelimitersSet
syn region nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_set_elements start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_value
hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_set nftHL_Write
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_set '\vset\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_value,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_set_elements,
\    nft_Error

hi link   nft_meta_expr_meta_key_unqualified_keyword_nftrace nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_nftrace '\vnftrace\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_set,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_value,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_comparison,
\    nft_Error
" ************************ END 'meta nftrace' ************************

" ********************** START 'meta obrname' ************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_obrname nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_obrname '\vobrname\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_not,
\    nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_in,
\    @nft_c_meta_expr_close_scope_meta_interface_name_quoted_device_name,
\    nft_Error
" ************************ END 'meta obrname' ************************

" ********************** START 'meta obrname' ************************
hi link   nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_in nftHL_Operator
syn match nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_ifname_at_setname,
\    nft_interface_name_set_block,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_not nftHL_Operator
syn match nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_in,
\    nft_Error

hi link   nft_meta_expr_meta_key_unqualified_keyword_oifname nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_oifname '\voifname\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_not,
\    nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_in,
\    @nft_c_meta_expr_close_scope_meta_interface_name_quoted_device_name,
\    nft_Error
" ************************ END 'meta obrname' ************************

" ********************** START 'meta oiftype' ************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_oiftype nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_oiftype '\voiftype\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_interface_type, nft_Error
" ************************ END 'meta oiftype' ************************

" ********************** START 'meta pkttype' ************************
hi link   nft_pkttype_at_setname nftHL_AtSetname
syn match nft_pkttype_at_setname '\v\@[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_packet_type_keyword_set nftHL_Write
syn match nft_packet_type_keyword_set '\vset\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_packet_type,
\    nft_Error

hi link   nft_meta_pkttype_set_symbol_comma nftHL_Element
syn match nft_meta_pkttype_set_symbol_comma '\v,' skipnl contained
\ nextgroup=
\    nft_meta_pkttype_set_symbol_element_packet_type

hi link   nft_meta_pkttype_set_element_packet_type nftHL_Define
syn match nft_meta_pkttype_set_element_packet_type '\v(broadcast|fastroute|multicast|otherhost|loopback|outgoing|unicast|host)' skipnl contained
\ nextgroup=
\    nft_meta_pkttype_set_symbol_comma

hi link   nft_packet_type Define
syn match nft_packet_type '\v(broadcast|fastroute|multicast|otherhost|loopback|outgoing|unicast|host)\ze[ \t\n;]' skipnl contained
\ nextgroup=
\    @nft_c_primary_stmt_expr,
\    nft_stmt_separator

hi link    nft_meta_pkttype_inline_set nftHL_BlockDelimitersSet
syn region nft_meta_pkttype_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_meta_pkttype_set_element_packet_type

hi link   nft_pkttype_set_membership_keyword_in nftHL_Operator
syn match nft_pkttype_set_membership_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_packet_type,
\    nft_packet_type_keyword_set,
\    nft_packet_type_operators_equality,
\    nft_meta_pkttype_inline_set,
\    nft_pkttype_at_setname,
\    nft_Error

hi link   nft_pkttype_set_membership_keyword_not nftHL_Operator
syn match nft_pkttype_set_membership_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_pkttype_set_membership_keyword_in,
\    nft_Error

hi link   nft_packet_type_operators_equality nftHL_Operator
syn match nft_packet_type_operators_equality '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_packet_type,
\    nft_meta_pkttype_inline_set,
\    nft_Error

hi link   nft_meta_expr_meta_key_unqualified_keyword_pkttype nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_pkttype '\vpkttype\ze[ \t\n]' skipnl skipwhite contained
\ nextgroup=
\    nft_packet_type,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_pkttype_set_membership_keyword_not,
\    nft_pkttype_set_membership_keyword_in,
\    nft_packet_type_operators_equality,
\    nft_packet_type_keyword_set,
\    nft_Error
" ************************ END 'meta pkttype' ************************

" ********************** START 'meta cgroup' ************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_cgroup nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_cgroup '\vcgroup\ze[ \t]' skipwhite contained
\ nextgroup= @nft_c_cgroup_index, nft_Error
" ************************ END 'meta cgroup' ************************

" ********************** BEGIN 'meta ipsec' *************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_ipsec nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_ipsec '\vipsec\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_special_keywords,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_keyword_not,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_keyword_spi,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_keyword_out,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_keyword_in,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_operators_relational,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_operators_equality,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_keyword_exclaimation,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_value_integer,
\    nft_Error
" ************************ END 'meta ipsec' *************************

" ********************** BEGIN 'meta skuid' *************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_skuid nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_skuid '\vskuid\ze[ \t]' skipwhite contained
\ nextgroup= @nft_c_socket_t, nft_Error
" ************************ END 'meta skuid' *************************

" ********************** BEGIN 'meta skgid' *************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_skgid nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_skgid '\vskgid\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_socket_t, nft_Error
" ************************ END 'meta skgid' *************************

" ********************** BEGIN 'meta hour' *************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_hour nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_hour '\vhour\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_hour_type, nft_Error
" ************************ END 'meta hour' *************************

" ********************** BEGIN 'meta mark' *************************
syntax match nft_meta_stmt_mark_missing '\v\ze[ \t]*[;\n]'  contained
hi link nft_meta_stmt_mark_missing nftHL_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_integer nftHL_Integer
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_integer '\v((0x[0-9a-f]{1,8})|([0-9]{1,10}))\ze[ \t\n;]' skipwhite contained

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_named_set nftHL_AtSetname
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_integer '\v\@[a-zA-Z][a-zA-Z0-9]{0,63}' skipwhite contained

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operators_relational_1char nftHL_Operator
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operators_relational_1char '\v(\<|\>)' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_integer, nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operators_equality nftHL_Operator
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operators_equality '\v(\!|\=)\=' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_integer,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_named_set,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_set_block,
\    nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operators_relational_2char nftHL_Operator
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operators_relational_2char '\v((\<|\>)(\=|\<|\>))' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_integer, nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_integer_operand nftHL_Integer
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_integer_operand '\v(0x)?[0-9a-f]{1,10}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operators_relational_2char,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operators_equality,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operators_relational_1char

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operator_mask nftHL_Operator
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operator_mask '\v\&' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_integer_operand,
\    nft_Error
hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_set_block_element_integer nftHL_Integer
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_set_block_element_integer '\v[0-9]{1,10}' skipwhite contained
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_set_block_element_integer '\v0x[0-9a-f]{1,8}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_set_block_element_separator,
\    nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_set_block_element_separator nftHL_Separator
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_set_block_element_separator /,/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_set_block_element_integer

hi link    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_set_block nftHL_BlockDelimitersSet
syn region nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_set_block_element_integer,
\    nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_named_set nftHL_AtSetname
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_named_set '\v\@[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_keyword_set nftHL_Write
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_keyword_set '\vset\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_named_set,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_integer,
\    nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_keyword_in nftHL_Operator
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_set_block,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_integer,
\    nft_Error

syn cluster nft_c_mark
\ contains=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_keyword_set,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_keyword_in,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operators_equality,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operators_relational_2char,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operator_mask,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operators_discrete_only_1char,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operators_relational_1char,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_named_set,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_integer,

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_keyword_not nftHL_Operator
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_mark,
\    nft_Error


hi link   nft_meta_expr_meta_key_unqualified_keyword_mark nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_mark '\vmark\ze[ \t]' skipnl skipwhite contained
\ nextgroup=
\    nft_map_expr_keyword_map,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_keyword_not,
\    @nft_c_mark,
\    nft_Error
" ************************ END 'meta mark' *************************

" ********************** BEGIN 'meta time' *************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_time nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_time '\vtime\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_time_type, nft_Error
" ************************ END 'meta time' *************************

" ********************** BEGIN 'meta cpu' *************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_cpu nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_cpu '\vcpu\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_cpu_index, nft_Error
" ************************ END 'meta cpu' *************************

" ********************** BEGIN 'meta day' *************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_day nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_day '\vday\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_day_of_week, nft_Error
" ************************ END 'meta day' *************************

" ********************** BEGIN 'meta iif' *************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_iif nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_iif '\viif\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_device_index_keyword_any,
\    nft_meta_expr_close_scope_meta_device_index_operator_keyword_not,
\    nft_meta_expr_close_scope_meta_device_index_operators_equality,
\    nft_meta_expr_close_scope_meta_device_index_set_operator_in,
\    nft_meta_expr_close_scope_meta_device_index_quoted_identifier,
\    nft_meta_expr_close_scope_meta_device_index_identifier,
\    nft_meta_expr_close_scope_meta_device_index_number,
\    nft_Error
" ************************ END 'meta iif' *************************

" ********************** BEGIN 'meta oif' *************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_oif nftHL_Substatement
syn match nft_meta_expr_meta_key_unqualified_keyword_oif '\voif\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_device_index_keyword_any,
\    nft_meta_expr_close_scope_meta_device_index_operator_keyword_not,
\    nft_meta_expr_close_scope_meta_device_index_operators_equality,
\    nft_meta_expr_close_scope_meta_device_index_set_operator_in,
\    nft_meta_expr_close_scope_meta_device_index_quoted_identifier,
\    nft_meta_expr_close_scope_meta_device_index_identifier,
\    nft_meta_expr_close_scope_meta_device_index_number,
\    nft_Error
" ************************ END 'meta oif' *************************


syn cluster nft_c_meta_key_qualified
\ contains=
\    nft_meta_key_qualified_keyword_protocol,
\    nft_meta_key_qualified_keyword_priority,
\    nft_meta_key_qualified_keyword_secmark,
\    nft_meta_key_qualified_keyword_length,
\    nft_meta_key_qualified_keyword_random

syn cluster nft_c_meta_key_unqualified
\ contains=
\    nft_meta_key_unqualified_keyword_rtclassid,
\    nft_meta_key_unqualified_keyword_iifgroup,
\    nft_meta_key_unqualified_keyword_oifgroup,
\    nft_meta_key_unqualified_keyword_ibrname,
\    nft_meta_key_unqualified_keyword_ibrport,
\    nft_meta_key_unqualified_keyword_iifname,
\    nft_meta_key_unqualified_keyword_iiftype,
\    nft_meta_key_unqualified_keyword_nftrace,
\    nft_meta_key_unqualified_keyword_obrname,
\    nft_meta_key_unqualified_keyword_obrport,
\    nft_meta_key_unqualified_keyword_oifname,
\    nft_meta_key_unqualified_keyword_oiftype,
\    nft_meta_key_unqualified_keyword_pkttype,
\    nft_meta_key_unqualified_keyword_cgroup,
\    nft_meta_key_unqualified_keyword_ipsec,
\    nft_meta_key_unqualified_keyword_skgid,
\    nft_meta_key_unqualified_keyword_skuid,
\    nft_meta_key_unqualified_keyword_hour,
\    nft_meta_key_unqualified_keyword_mark,
\    nft_meta_key_unqualified_keyword_time,
\    nft_meta_key_unqualified_keyword_cpu,
\    nft_meta_key_unqualified_keyword_day,
\    nft_meta_key_unqualified_keyword_iif,
\    nft_meta_key_unqualified_keyword_oif

" meta_key, used by meta_expr & meta_stmt
hi link   nft_meta_expr_string nftHL_String
syn match nft_meta_expr_string '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_meta_expr_keyword_meta nftHL_Command
syn match nft_meta_expr_keyword_meta '\vmeta\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_key_unqualified_keyword_rtclassid,
\    nft_meta_key_unqualified_keyword_iifgroup,
\    nft_meta_key_unqualified_keyword_oifgroup,
\    nft_meta_key_qualified_keyword_protocol,
\    nft_meta_key_qualified_keyword_priority,
\    nft_meta_key_unqualified_keyword_ibrname,
\    nft_meta_key_unqualified_keyword_ibrport,
\    nft_meta_key_unqualified_keyword_iifname,
\    nft_meta_key_unqualified_keyword_iiftype,
\    nft_meta_key_unqualified_keyword_nftrace,
\    nft_meta_key_unqualified_keyword_obrname,
\    nft_meta_key_unqualified_keyword_obrport,
\    nft_meta_key_unqualified_keyword_oifname,
\    nft_meta_key_unqualified_keyword_oiftype,
\    nft_meta_key_unqualified_keyword_pkttype,
\    nft_meta_key_qualified_keyword_secmark,
\    nft_meta_key_unqualified_keyword_cgroup,
\    nft_meta_key_qualified_keyword_length,
\    nft_meta_key_qualified_keyword_random,
\    nft_meta_key_unqualified_keyword_ipsec,
\    nft_meta_key_unqualified_keyword_skgid,
\    nft_meta_key_unqualified_keyword_skuid,
\    nft_meta_key_unqualified_keyword_hour,
\    nft_meta_key_unqualified_keyword_mark,
\    nft_meta_key_unqualified_keyword_time,
\    nft_meta_key_unqualified_keyword_cpu,
\    nft_meta_key_unqualified_keyword_day,
\    nft_meta_key_unqualified_keyword_iif,
\    nft_meta_key_unqualified_keyword_oif,
\    nft_meta_expr_string

syn cluster nft_c_meta_expr
\ contains=
\    nft_meta_key_unqualified_keyword_rtclassid,
\    nft_meta_key_unqualified_keyword_ibriport,
\    nft_meta_key_unqualified_keyword_iifgroup,
\    nft_meta_key_unqualified_keyword_obriport,
\    nft_meta_key_unqualified_keyword_oifgroup,
\    nft_meta_key_unqualified_keyword_ibrname,
\    nft_meta_key_unqualified_keyword_iifname,
\    nft_meta_key_unqualified_keyword_iiftype,
\    nft_meta_key_unqualified_keyword_nftrace,
\    nft_meta_key_unqualified_keyword_obrname,
\    nft_meta_key_unqualified_keyword_oifname,
\    nft_meta_key_unqualified_keyword_oiftype,
\    nft_meta_key_unqualified_keyword_pkttype,
\    nft_meta_key_unqualified_keyword_cgroup,
\    nft_meta_key_unqualified_keyword_ipsec,
\    nft_meta_key_unqualified_keyword_skgid,
\    nft_meta_key_unqualified_keyword_skuid,
\    nft_meta_key_unqualified_keyword_hour,
\    nft_meta_key_unqualified_keyword_mark,
\    nft_meta_expr_keyword_meta,
\    nft_meta_key_unqualified_keyword_time,
\    nft_meta_key_unqualified_keyword_cpu,
\    nft_meta_key_unqualified_keyword_day,
\    nft_meta_key_unqualified_keyword_iif,
\    nft_meta_key_unqualified_keyword_oif,
\    nft_meta_expr_string
" ***************** END meta_expr ************************************

  for s:this_semantic_file in s:meta_expr_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded meta_expr for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define meta_expr.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_meta_expr = v:true
