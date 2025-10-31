" File: stmt_meta.vim
" Directory: custom/nftables/table/chain/stmt/
"
let s:stmt_meta_list_filepaths_semantic_early = []
let s:stmt_meta_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_meta')
  call nftables#syntax#log('INFO', 'Skipped stmt_meta (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_meta_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_meta syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
" ***************** BEGIN meta_stmt ***************
" If it's followed by a set, it's likely meta_stmt. If it's
" followed by a field name and then a comparison (==, <, etc.),
" it's meta_expr.
" meta_stmt is followed by a set.
" meta_expr is followed by a comparison.
" meta_expr is followed by a field name.

hi link   nft_meta_stmt_keyword_set nftHL_Write
syn match nft_meta_stmt_keyword_set '\vset' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_meta_key_qualified_priority_keyword_none,
\    nft_meta_stmt_meta_key_qualified_priority_number,
\    @nft_c_stmt_expr

hi link   nft_meta_stmt_keyword_mark_keyword_set nftHL_Write
syn match nft_meta_stmt_keyword_mark_keyword_set '\vset' skipwhite contained
\ nextgroup=
\    @nft_c_stmt_expr

" ********** BEGIN meta_stmt 'iif' ******************************
" handled by nft_meta_expr_meta_key_unqualified_keyword_iif
" ************ END meta_stmt 'iif' ******************************

" ********** BEGIN meta_stmt 'oif' ******************************
" handled by nft_meta_expr_meta_key_unqualified_keyword_oif
" ************ END meta_stmt 'oif' ******************************

" **************** BEGIN meta_stmt 'rtclassid' ******************
hi link   nft_meta_stmt_meta_key_unqualified_keyword_rtclassid nftHL_Error
syn match nft_meta_stmt_meta_key_unqualified_keyword_rtclassid '\vrtclassid' skipwhite contained
\ nextgroup=
\    nft_Error
" ****************** END meta_stmt 'rtclassid' ******************

" **************** BEGIN meta_stmt 'ibriport' *******************
hi link   nft_meta_stmt_meta_key_unqualified_keyword_ibriport nftHL_Error
syn match nft_meta_stmt_meta_key_unqualified_keyword_ibriport '\vibriport' skipwhite contained
\ nextgroup=
\    nft_Error
" ****************** END meta_stmt 'ibriport' *******************

" **************** BEGIN meta_stmt 'iifgroup' *******************
hi link   nft_meta_stmt_meta_key_unqualified_keyword_iifgroup nftHL_Error
syn match nft_meta_stmt_meta_key_unqualified_keyword_iifgroup '\viifgroup' skipwhite contained
\ nextgroup=
\    nft_Error
" ****************** END meta_stmt 'iifgroup' ********************

" **************** BEGIN meta_stmt 'obriport' *******************
hi link   nft_meta_stmt_meta_key_unqualified_keyword_obriport nftHL_Error
syn match nft_meta_stmt_meta_key_unqualified_keyword_obriport '\vobriport' skipwhite contained
\ nextgroup=
\    nft_Error
" ****************** END meta_stmt 'obriport' ********************

" **************** BEGIN meta_stmt 'oifgroup' *******************
hi link   nft_meta_stmt_meta_key_unqualified_keyword_oifgroup nftHL_Error
syn match nft_meta_stmt_meta_key_unqualified_keyword_oifgroup '\voifgroup' skipwhite contained
\ nextgroup=
\    nft_Error
" ****************** END meta_stmt 'oifgroup' ********************

" **************** BEGIN meta_stmt 'priority' *******************
hi link   nft_meta_stmt_meta_key_qualified_priority_keyword_none nftHL_Define
syn match nft_meta_stmt_meta_key_qualified_priority_keyword_none '\vnone\ze[ \t;]' skipwhite contained

hi link   nft_meta_stmt_meta_key_qualified_priority_number nftHL_Integer
"syn match nft_meta_stmt_meta_key_qualified_priority_number '\v(0[xX][0-9a-fA-F]{1,8}|429496729[0-5]|42949672[0-9][0-9]|4294967[0-2][0-9][0-9]|429496[0-7][0-9][0-9][0-9][0-9]|42949[0-5][0-9]{5}429[0-4][0-9]{7}|4[0-2][0-9]{8})\ze[ \t\n;]' skipwhite contained
syn match nft_meta_stmt_meta_key_qualified_priority_number '\v((0[xX][0-9a-fA-F]{1,8})|(429496729[0-5])|4294967[0-1][0-9][0-9]|429496[0-6][0-9][0-9][0-9]|42949[0-5][0-9]{4}|429[0-3][0-9]{6}|4[0-1][0-9]{8}|[0-3][0-9]{9}|[0-9]{1,8})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_keyword_set,
\    nft_Error

hi link   nft_meta_stmt_priority_set_block_elements_separator nftHL_Separator
syn match nft_meta_stmt_priority_set_block_elements_separator /,/ skipwhite contained
\ nextgroup=
\    nft_meta_stmt_priority_set_block_elements_protocol_types,
\    nft_meta_stmt_priority_set_block_elements_protocol_number,
\    nft_Error

hi link   nft_meta_stmt_priority_set_block_elements_protocol_number nftHL_Integer
syn match nft_meta_stmt_priority_set_block_elements_protocol_number '\v[0-9]{1,5}' skipwhite contained
syn match nft_meta_stmt_priority_set_block_elements_protocol_number '\v\c0x[0-9a-f]{1,4}' skipwhite contained
\ nextgroup= nft_meta_stmt_priority_set_block_elements_separator, nft_Error

hi link   nft_meta_stmt_priority_set_block_elements_protocol_types nftHL_Identifier
syn match nft_meta_stmt_priority_set_block_elements_protocol_types '\v(loopback|mpls_mc|mpls_uc|(802_1q)|pppoe|lldp|qinq|arp|ip6|ip)' skipwhite contained

hi link    nft_meta_stmt_priority_set_block nftHL_BlockDelimitersSet
syn region nft_meta_stmt_priority_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\     nft_meta_stmt_priority_set_block_elements_protocol_identifier,
\     nft_meta_stmt_priority_set_block_elements_protocol_types,
\     nft_meta_stmt_priority_set_block_elements_protocol_number,
\     nft_Error

hi link   nft_meta_stmt_priority_any nftHL_Operator
syn match nft_meta_stmt_priority_any '\vany\ze[ \t;]' skipwhite contained

hi link   nft_meta_stmt_priority_identifier nftHL_Define
syn match nft_meta_stmt_priority_identifier '\v(loopback|mpls_mc|mpls_uc|(802_1q)|pppoe|lldp|qinq|any|arp|ip6|ip)' skipwhite contained
\ contains=nft_meta_stmt_priority_any

hi link   nft_meta_stmt_priority_operators_2char nftHL_Operator
syn match nft_meta_stmt_priority_operators_2char '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_priority_identifier,
\    nft_meta_stmt_priority_set_block,
\    nft_meta_stmt_meta_key_qualified_priority_number,
\    nft_Error
hi link   nft_meta_stmt_priority_operators_1char nftHL_Operator
syn match nft_meta_stmt_priority_operators_1char '\v(\<|\>)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_priority_identifier,
\    nft_meta_stmt_priority_set_block,
\    nft_meta_stmt_priority_set_identifier,
\    nft_meta_stmt_meta_key_qualified_priority_number,
\    nft_Error
hi link   nft_meta_key_qualified_priority_operators_discrete nftHL_Operator
syn match nft_meta_key_qualified_priority_operators_discrete '\v(\<|\>)\=' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_meta_key_qualified_priority_number,
\    nft_Error
hi link   nft_meta_stmt_priority_set_operator_in nftHL_Operator
syn match nft_meta_stmt_priority_set_operator_in '\vin\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_priority_set_identifier,
\    nft_meta_stmt_priority_set_block,
\    nft_Error

hi link   nft_meta_stmt_meta_key_qualified_keyword_priority nftHL_Error
syn match nft_meta_stmt_meta_key_qualified_keyword_priority '\vpriority' skipwhite contained
\ nextgroup=nft_Error

" ****************** END meta_stmt 'priority' *******************

" **************** BEGIN meta_stmt 'protocol' *******************
hi link   nft_meta_stmt_meta_key_qualified_keyword_protocol nftHL_Error
syn match nft_meta_stmt_meta_key_qualified_keyword_protocol '\v(protocol|l4proto)' skipwhite contained
\ nextgroup=
\    nft_Error
" 'protocol is read-only, no 'set' supported
" ****************** END meta_stmt 'protocol' *******************

" ************ BEGIN meta_stmt 'ibrname' ************************
hi link   nft_meta_stmt_meta_key_unqualified_keyword_ibrname nftHL_Error
syn match nft_meta_stmt_meta_key_unqualified_keyword_ibrname '\vibrname' skipwhite contained
\ nextgroup=
\    nft_Error
" *************** END meta_stmt 'ibrname' ***********************

" ************ BEGIN meta_stmt 'ifgroup' ************************
hi link   nft_meta_stmt_meta_key_unqualified_keyword_oifgroup nftHL_Error
syn match nft_meta_stmt_meta_key_unqualified_keyword_oifgroup '\voifgroup' skipwhite contained
\ nextgroup=
\    nft_Error
" ************** END meta_stmt 'ifgroup' ************************

" ************ BEGIN meta_stmt 'iifname' ************************
" handled by nft_meta_expr_meta_key_unqualified_keyword_iifname
" ************** END meta_stmt 'iifname' ************************

" ************ BEGIN meta_stmt 'iiftype' ************************
" handled by nft_meta_expr_meta_key_unqualified_keyword_iiftype
" ************ END meta_stmt 'iiftype' **************************

" ********** BEGIN meta_stmt 'nftrace' **************************
hi link   nft_meta_stmt_meta_key_unqualified_keyword_nftrace nftHL_Error
syn match nft_meta_stmt_meta_key_unqualified_keyword_nftrace '\vnftrace' skipwhite contained
\ nextgroup=
\    nft_Error
" ************ END meta_stmt 'nftrace' **************************

" ********** BEGIN meta_stmt 'obrname' **************************
hi link   nft_meta_stmt_meta_key_unqualified_keyword_obrname nftHL_Error
syn match nft_meta_stmt_meta_key_unqualified_keyword_obrname '\vobrname\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_Error
" ************ END meta_stmt 'obrname' **************************

" ********** BEGIN meta_stmt 'oifname' **************************
hi link   nft_meta_stmt_meta_key_unqualified_keyword_oifname nftHL_Error
syn match nft_meta_stmt_meta_key_unqualified_keyword_oifname '\voifname\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_Error
" ************ END meta_stmt 'oifname' **************************

" ********** BEGIN meta_stmt 'oiftype' **************************
hi link   nft_meta_stmt_meta_key_unqualified_keyword_oiftype nftHL_Error
syn match nft_meta_stmt_meta_key_unqualified_keyword_oiftype '\voiftype\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_Error
" ************ END meta_stmt 'oiftype' **************************

" ********** BEGIN meta_stmt 'pkttype' **************************
" handled by nft_meta_expr_meta_key_unqualified_keyword_pkttype
" ************ END meta_stmt 'pkttype' **************************

" ********** BEGIN meta_stmt 'secmark' **************************
hi link   nft_meta_stmt_meta_key_qualified_keyword_secmark nftHL_Error
syn match nft_meta_stmt_meta_key_qualified_keyword_secmark '\vsecmark' skipwhite contained
\ nextgroup=
\    nft_Error
" ************ END meta_stmt 'secmark' **************************

" ********** BEGIN meta_stmt 'cgroup' ***************************
hi link   nft_meta_stmt_meta_key_unqualified_keyword_cgroup nftHL_Error
syn match nft_meta_stmt_meta_key_unqualified_keyword_cgroup '\vcgroup' skipwhite contained
\ nextgroup=nft_Error
" ************ END meta_stmt 'cgroup' ***************************

" ********** BEGIN meta_stmt 'length' ***************************
hi link   nft_meta_stmt_meta_key_qualified_keyword_length nftHL_Error
syn match nft_meta_stmt_meta_key_qualified_keyword_length '\vlength' skipwhite contained
\ nextgroup=nft_Error
" ************ END meta_stmt 'length' ***************************

" ********** BEGIN meta_stmt 'random' ***************************
" meta_stmt 'random' is read-only
hi link   nft_meta_stmt_meta_key_qualified_keyword_random nftHL_Error
syn match nft_meta_stmt_meta_key_qualified_keyword_random '\vrandom' skipwhite contained
\ nextgroup=
\    nft_Error
" ************ END meta_stmt 'random' ***************************

" ********** BEGIN meta_stmt 'ipsec' ****************************
" You cannot use set with ipsec in reqid in nftables v1.1.4.
" Use set literals {} or direct values in rules.
" reqid is not a packet field — it's a policy attribute
hi link   nft_meta_stmt_meta_key_unqualified_keyword_ipsec nftHL_Statement
syn match nft_meta_stmt_meta_key_unqualified_keyword_ipsec '\vipsec\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_xfrm_expr_xfrm_dir_keyword_out,
\    nft_xfrm_expr_xfrm_dir_keyword_in,
" ************ END meta_stmt 'ipsec' ****************************

" ********** BEGIN meta_stmt 'skgid' ****************************
hi link   nft_meta_stmt_meta_key_unqualified_keyword_skgid nftHL_Error
syn match nft_meta_stmt_meta_key_unqualified_keyword_skgid '\vskgid' skipwhite contained
\ nextgroup=nft_Error
" ************ END meta_stmt 'skgid' ****************************

" ********** BEGIN meta_stmt 'skuid' ****************************
hi link   nft_meta_stmt_meta_key_unqualified_keyword_skuid nftHL_Error
syn match nft_meta_stmt_meta_key_unqualified_keyword_skuid '\vskuid' skipwhite contained
\ nextgroup=nft_Error
" ************ END meta_stmt 'skuid' ****************************

" ********** BEGIN meta_stmt 'flow' *****************************
hi link   nft_meta_stmt_set_ref_symbol_expr_at_identifier nftHL_AtSetname
syn match nft_meta_stmt_set_ref_symbol_expr_at_identifier '\v\@[a-zA-Z0-9_\-]+\ze[ \t;]' contained

hi link   nft_meta_stmt_offload_add_keywords nftHL_Keyword
syn match nft_meta_stmt_offload_add_keywords '\v(offload|add)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_set_ref_symbol_expr_at_identifier,
\    nft_Error


hi link   nft_meta_stmt_keyword_flow nftHL_Statement
syn match nft_meta_stmt_keyword_flow '\vflow\ze[ \t]' skipwhite contained
\ nextgroup=
\     nft_meta_stmt_offload_add_keywords,
\     nft_UnexpectedSymbol,
\     nft_Error
" no error, because 'flow' alone means enable
" ************ END meta_stmt 'flow' *****************************

" ********** BEGIN meta_stmt 'hour' *****************************
" handled by nft_meta_expr_meta_key_unqualified_keyword_hour
" ************ END meta_stmt 'hour' *****************************

" ********** BEGIN meta_stmt 'mark' *****************************
hi link   nft_meta_stmt_meta_key_unqualified_keyword_mark nftHL_Error
syn match nft_meta_stmt_meta_key_unqualified_keyword_mark '\vmark' skipwhite contained
\ nextgroup=
\    nft_Error
" ************ END meta_stmt 'mark' *****************************

" ********** BEGIN meta_stmt 'time' *****************************
" handled by nft_meta_expr_meta_key_unqualified_keyword_time
" ************ END meta_stmt 'time' *****************************

" ********** BEGIN meta_stmt 'cpu' ******************************
hi link   nft_meta_stmt_meta_key_unqualified_keyword_cpu nftHL_Error
syn match nft_meta_stmt_meta_key_unqualified_keyword_cpu '\vcpu' skipwhite contained
\ nextgroup=nft_Error
" ************ END meta_stmt 'cpu' ******************************

" ********** BEGIN meta_stmt 'day' ******************************
" handled by nft_meta_expr_meta_key_unqualified_keyword_day
" ************ END meta_stmt 'day' ******************************

" ********************************************************************
"  Here after, is the 'meta XXXXXX', what was before is without the 'meta'
" ********************************************************************

" **************** BEGIN meta_stmt 'meta rtclassid' ******************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_rtclassid nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_rtclassid '\vrtclassid' skipwhite contained
\ nextgroup=
\    nft_Error
" ****************** END meta_stmt 'meta rtclassid' ******************

" **************** BEGIN meta_stmt 'meta ibriport' *******************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_ibriport nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_ibriport '\vibriport' skipwhite contained
\ nextgroup=
\    nft_Error
" ****************** END meta_stmt 'meta ibriport' *******************

" **************** BEGIN meta_stmt 'meta iifgroup' *******************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_iifgroup nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_iifgroup '\viifgroup' skipwhite contained
\ nextgroup=
\    nft_Error
" ****************** END meta_stmt 'meta iifgroup' ********************

" **************** BEGIN meta_stmt 'meta obriport' *******************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_obriport nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_obriport '\vobriport' skipwhite contained
\ nextgroup=
\    nft_Error
" ****************** END meta_stmt 'meta obriport' ********************

" **************** BEGIN meta_stmt 'meta oifgroup' *******************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_oifgroup nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_oifgroup '\voifgroup' skipwhite contained
\ nextgroup=
\    nft_Error
" ****************** END meta_stmt 'meta oifgroup' ********************

" **************** BEGIN meta_stmt 'meta priority' *******************
hi link   nft_meta_stmt_meta_key_meta_key_qualified_priority_keyword_none nftHL_Define
syn match nft_meta_stmt_meta_key_meta_key_qualified_priority_keyword_none '\vnone\ze[ \t;]' skipwhite contained

hi link   nft_meta_stmt_meta_key_meta_key_qualified_priority_number nftHL_Integer
"syn match nft_meta_stmt_meta_key_meta_key_qualified_priority_number '\v(0[xX][0-9a-fA-F]{1,8}|429496729[0-5]|42949672[0-9][0-9]|4294967[0-2][0-9][0-9]|429496[0-7][0-9][0-9][0-9][0-9]|42949[0-5][0-9]{5}429[0-4][0-9]{7}|4[0-2][0-9]{8})\ze[ \t\n;]' skipwhite contained
syn match nft_meta_stmt_meta_key_meta_key_qualified_priority_number '\v((0[xX][0-9a-fA-F]{1,8})|(429496729[0-5])|4294967[0-1][0-9][0-9]|429496[0-6][0-9][0-9][0-9]|42949[0-5][0-9]{4}|429[0-3][0-9]{6}|4[0-1][0-9]{8}|[0-3][0-9]{9}|[0-9]{1,8})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_keyword_set,
\    nft_Error

hi link   nft_meta_stmt_priority_set_block_elements_separator nftHL_Separator
syn match nft_meta_stmt_priority_set_block_elements_separator /,/ skipwhite contained
\ nextgroup=
\    nft_meta_stmt_priority_set_block_elements_protocol_types,
\    nft_meta_stmt_priority_set_block_elements_protocol_number,
\    nft_Error

hi link   nft_meta_stmt_priority_set_block_elements_protocol_number nftHL_Integer
syn match nft_meta_stmt_priority_set_block_elements_protocol_number '\v[0-9]{1,5}' skipwhite contained
syn match nft_meta_stmt_priority_set_block_elements_protocol_number '\v\c0x[0-9a-f]{1,4}' skipwhite contained
\ nextgroup= nft_meta_stmt_priority_set_block_elements_separator, nft_Error

hi link   nft_meta_stmt_priority_set_block_elements_protocol_types nftHL_Identifier
syn match nft_meta_stmt_priority_set_block_elements_protocol_types '\v(loopback|mpls_mc|mpls_uc|(802_1q)|pppoe|lldp|qinq|arp|ip6|ip)' skipwhite contained

hi link    nft_meta_stmt_priority_set_block nftHL_BlockDelimitersSet
syn region nft_meta_stmt_priority_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\     nft_meta_stmt_priority_set_block_elements_protocol_identifier,
\     nft_meta_stmt_priority_set_block_elements_protocol_types,
\     nft_meta_stmt_priority_set_block_elements_protocol_number,
\     nft_Error

hi link   nft_meta_stmt_priority_any nftHL_Operator
syn match nft_meta_stmt_priority_any '\vany\ze[ \t;]' skipwhite contained

hi link   nft_meta_stmt_priority_identifier nftHL_Identifier
syn match nft_meta_stmt_priority_identifier '\v(loopback|mpls_mc|mpls_uc|(802_1q)|pppoe|lldp|qinq|any|arp|ip6|ip)' skipwhite contained
\ contains=nft_meta_stmt_priority_any

hi link   nft_meta_stmt_priority_operators_2char nftHL_Operator
syn match nft_meta_stmt_priority_operators_2char '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_priority_identifier,
\    nft_meta_stmt_priority_set_block,
\    nft_meta_stmt_meta_key_meta_key_qualified_priority_number,
\    nft_Error
hi link   nft_meta_stmt_priority_operators_1char nftHL_Operator
syn match nft_meta_stmt_priority_operators_1char '\v(\<|\>)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_priority_identifier,
\    nft_meta_stmt_priority_set_block,
\    nft_meta_stmt_priority_set_identifier,
\    nft_meta_stmt_meta_key_meta_key_qualified_priority_number,
\    nft_Error
hi link   nft_meta_key_qualified_priority_operators_discrete nftHL_Operator
syn match nft_meta_key_qualified_priority_operators_discrete '\v(\<|\>)\=' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_meta_key_meta_key_qualified_priority_number,
\    nft_Error
hi link   nft_meta_stmt_priority_set_operator_in nftHL_Operator
syn match nft_meta_stmt_priority_set_operator_in '\vin\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_priority_set_identifier,
\    nft_meta_stmt_priority_set_block,
\    nft_Error

hi link   nft_meta_stmt_meta_key_meta_key_qualified_keyword_priority nftHL_Substatement
syn match nft_meta_stmt_meta_key_meta_key_qualified_keyword_priority '\vpriority\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_keyword_set,
\    nft_Error
" ****************** END meta_stmt 'meta priority' *******************

" **************** BEGIN meta_stmt 'meta protocol' *******************
hi link   nft_meta_stmt_meta_key_meta_key_qualified_keyword_protocol nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_qualified_keyword_protocol '\v(protocol|l4proto)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_Error
" 'meta protocol is read-only, no 'set' supported
" ****************** END meta_stmt 'meta protocol' *******************

" ************ BEGIN meta_stmt 'meta ibrname' ************************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_ibrname nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_ibrname '\vibrname\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_Error
" *************** END meta_stmt 'meta ibrname' ***********************

" ************ BEGIN meta_stmt 'meta ifgroup' ************************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_oifgroup nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_oifgroup '\voifgroup\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_Error
" ************** END meta_stmt 'meta ifgroup' ************************

" ************ BEGIN meta_stmt 'meta iifname' ************************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_iifname nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_iifname '\v[ \t\n]\zsiifname\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_Error
" ************** END meta_stmt 'meta iifname' ************************

" ************ BEGIN meta_stmt 'meta iiftype' ************************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_iiftype nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_iiftype '\v[ \t\n]iiftype\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_Error
" ************ END meta_stmt 'meta iiftype' **************************

" ********** BEGIN meta_stmt 'meta nftrace' **************************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_nftrace nftHL_Substatement
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_nftrace '\vnftrace\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_keyword_set,
\    nft_Error
" ************ END meta_stmt 'meta nftrace' **************************

" ********** BEGIN meta_stmt 'meta notrack' **************************
hi link   nft_meta_stmt_keyword_notrack nftHL_Statement
syn match nft_meta_stmt_keyword_notrack '\vnotrack\ze(([ \t;])|($))' skipwhite contained
\ nextgroup=
\    nft_line_separator,
\    nft_Error
" ************ END meta_stmt 'meta notrack' **************************

" ********** BEGIN meta_stmt 'meta obrname' **************************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_obrname nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_obrname '\vobrname\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_Error
" ************ END meta_stmt 'meta obrname' **************************

" ********** BEGIN meta_stmt 'meta oifname' **************************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_oifname nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_oifname '\voifname\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_Error
" ************ END meta_stmt 'meta oifname' **************************

" ********** BEGIN meta_stmt 'meta oiftype' **************************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_oiftype nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_oiftype '\voiftype' skipwhite contained
\ nextgroup=
\    nft_Error
" ************ END meta_stmt 'meta oiftype' **************************

" ********** BEGIN meta_stmt 'meta pkttype' **************************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_pkttype nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_pkttype '\vpkttype' skipwhite contained
\ nextgroup=
\    nft_Error
" ************ END meta_stmt 'meta pkttype' **************************

" ********** BEGIN meta_stmt 'meta secmark' **************************
hi link   nft_meta_stmt_meta_key_meta_key_qualified_keyword_secmark nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_qualified_keyword_secmark '\vsecmark' skipwhite contained
\ nextgroup=
\    nft_Error
" ************ END meta_stmt 'meta secmark' **************************

" ********** BEGIN meta_stmt 'meta cgroup' ***************************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_cgroup nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_cgroup '\vcgroup\ze[ \t]' skipwhite contained
\ nextgroup=nft_Error
" ************ END meta_stmt 'meta cgroup' ***************************

" ********** BEGIN meta_stmt 'meta length' ***************************
hi link   nft_meta_stmt_meta_key_meta_key_qualified_keyword_length nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_qualified_keyword_length '\vlength\ze[ \t]' skipwhite contained
\ nextgroup=nft_Error
" ************ END meta_stmt 'meta length' ***************************

" ********** BEGIN meta_stmt 'meta random' ***************************
" meta_stmt 'meta random' is read-only
hi link   nft_meta_stmt_meta_key_meta_key_qualified_keyword_random nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_qualified_keyword_random '\vrandom\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_Error
" ************ END meta_stmt 'meta random' ***************************

" ********** BEGIN meta_stmt 'meta ipsec' ****************************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_ipsec nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_ipsec '\vipsec\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_Error
" ************ END meta_stmt 'meta ipsec' ****************************

" ********** BEGIN meta_stmt 'meta skgid' ****************************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_skgid nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_skgid '\vskgid\ze[ \t]' skipwhite contained
\ nextgroup=nft_Error
" ************ END meta_stmt 'meta skgid' ****************************

" ********** BEGIN meta_stmt 'meta skuid' ****************************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_skuid nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_skuid '\vskuid\ze[ \t]' skipwhite contained
\ nextgroup=nft_Error
" ************ END meta_stmt 'meta skuid' ****************************

" ********** BEGIN meta_stmt 'meta hour' *****************************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_hour nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_hour '\vhour\ze[ \t]' skipwhite contained
\ nextgroup=nft_Error
" ************ END meta_stmt 'meta hour' *****************************

" ********** BEGIN meta_stmt 'meta mark' *****************************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_mark nftHL_Substatement
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_mark '\vmark\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_keyword_mark_keyword_set,
\    nft_meta_stmt_meta_key_meta_key_unqualified_mark_keyword_not,
\    @nft_c_mark,
\    nft_Error
" ************ END meta_stmt 'meta mark' *****************************

" ********** BEGIN meta_stmt 'meta time' *****************************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_time nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_time '\vtime\ze[ \t]' skipwhite contained
\ nextgroup=nft_Error
" ************ END meta_stmt 'meta time' *****************************

" ********** BEGIN meta_stmt 'meta cpu' ******************************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_cpu nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_cpu '\vcpu\ze[ \t]' skipwhite contained
\ nextgroup=nft_Error
" ************ END meta_stmt 'meta cpu' ******************************

" ********** BEGIN meta_stmt 'meta day' ******************************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_day nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_day '\vday\ze[ \t]' skipwhite contained
\ nextgroup=nft_Error
" ************ END meta_stmt 'meta day' ******************************

" ********** BEGIN meta_stmt 'meta iif' ******************************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_iif nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_iif '\v[ \t\n]\zsiif\ze[ \t]' skipwhite contained
\ nextgroup=
\    nftHL_Error
" No error handler here, 'iif' is also a standalone statement keyword
" ************ END meta_stmt 'meta iif' ******************************

" ********** BEGIN meta_stmt 'meta oif' ******************************
hi link   nft_meta_stmt_meta_key_meta_key_unqualified_keyword_oif nftHL_Error
syn match nft_meta_stmt_meta_key_meta_key_unqualified_keyword_oif '\voif\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_Error
" ************ END meta_stmt 'meta oif' ******************************

hi link   nft_meta_stmt_keyword_meta nftHL_Statement
syn match nft_meta_stmt_keyword_meta '\vmeta\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_rtclassid,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_ibriport,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_iifgroup,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_obriport,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_oifgroup,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_priority,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_protocol,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_ibrname,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_iifname,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_iiftype,
\    nft_meta_expr_meta_key_internal_string_keyword_nfproto,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_nftrace,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_obrname,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_oifname,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_oiftype,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_pkttype,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_secmark,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_cgroup,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_length,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_random,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_ipsec,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_skgid,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_skuid,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_hour,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_mark,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_time,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_cpu,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_day,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_iif,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_oif,
\    nft_rule_cluster_Error

syn cluster nft_c_meta_stmt
\ contains=
\    nft_meta_stmt_meta_key_unqualified_keyword_rtclassid,
\    nft_meta_stmt_meta_key_unqualified_keyword_ibriport,
\    nft_meta_stmt_meta_key_unqualified_keyword_iifgroup,
\    nft_meta_stmt_meta_key_unqualified_keyword_obriport,
\    nft_meta_stmt_meta_key_unqualified_keyword_oifgroup,
\    nft_meta_stmt_meta_key_unqualified_keyword_ibrname,
\    nft_meta_stmt_meta_key_unqualified_keyword_iifname,
\    nft_meta_stmt_meta_key_unqualified_keyword_iiftype,
\    nft_meta_stmt_meta_key_unqualified_keyword_nftrace,
\    nft_meta_stmt_keyword_notrack,
\    nft_meta_stmt_meta_key_unqualified_keyword_obrname,
\    nft_meta_stmt_meta_key_unqualified_keyword_oifname,
\    nft_meta_stmt_meta_key_unqualified_keyword_oiftype,
\    nft_meta_stmt_meta_key_unqualified_keyword_pkttype,
\    nft_meta_stmt_meta_key_unqualified_keyword_cgroup,
\    nft_meta_stmt_meta_key_unqualified_keyword_ipsec,
\    nft_meta_stmt_meta_key_unqualified_keyword_skgid,
\    nft_meta_stmt_meta_key_unqualified_keyword_skuid,
\    nft_meta_stmt_keyword_flow,
\    nft_meta_stmt_meta_key_unqualified_keyword_hour,
\    nft_meta_stmt_meta_key_unqualified_keyword_mark,
\    nft_meta_stmt_keyword_meta,
\    nft_meta_stmt_meta_key_unqualified_keyword_time,
\    nft_meta_stmt_meta_key_unqualified_keyword_cpu,
\    nft_meta_stmt_meta_key_unqualified_keyword_day,
\    nft_meta_stmt_meta_key_unqualified_keyword_iif,
\    nft_meta_stmt_meta_key_unqualified_keyword_oif
" ***************** END meta_stmt ***************


  for s:this_semantic_file in s:stmt_meta_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_meta for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_meta.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_meta = v:true
