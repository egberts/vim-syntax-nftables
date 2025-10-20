" File: payload_expr.vim
" Directory: custom/nftables/table/chain/stmt/expr/
"
let s:payload_expr_list_filepaths_semantic_early = []
let s:payload_expr_list_filepaths_semantic_later = []

if exists('b:did_nftables_payload_expr')
  call nftables#syntax#log('INFO', 'Skipped payload_expr (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:payload_expr_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading payload_expr syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

" ************************* BEGIN payload_expr' *************************
" ************************* BEGIN ip_hdr_expr' *************************
hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_option_type nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_option_type '\v(lsrr|ssrr|ra|rr)' skipwhite contained

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_keyword_option nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_keyword_option '\voption' skipwhite contained
\ nextgroup=
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_option_type,
\    nft_chainError

hi link   nft_close_scope_ip_primary_expr_constant_expr_int_hex_4b nftHL_Integer
syn match nft_close_scope_ip_primary_expr_constant_expr_int_hex_4b '\v((0x[0-9a-fA-F]{1})|([0-9]{1,2}))' skipwhite contained
hi link   nft_close_scope_ip_primary_expr_constant_expr_int_hex_8b nftHL_Integer
syn match nft_close_scope_ip_primary_expr_constant_expr_int_hex_8b '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))' skipwhite contained
hi link   nft_close_scope_ip_primary_expr_constant_expr_int_hex_16b nftHL_Integer
syn match nft_close_scope_ip_primary_expr_constant_expr_int_hex_16b '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))' skipwhite contained
hi link   nft_close_scope_ip_primary_expr_constant_expr_int_hex_32b nftHL_Integer
syn match nft_close_scope_ip_primary_expr_constant_expr_int_hex_32b '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))' skipwhite contained
hi link   nft_close_scope_ip_primary_expr_constant_expr_at_setname nftHL_AtSetname
syn match nft_close_scope_ip_primary_expr_constant_expr_at_setname '\v\@[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
hi link   nft_close_scope_ip_primary_expr_constant_expr_ip nftHL_Integer
syn match nft_close_scope_ip_primary_expr_constant_expr_ip '\v[0-9]{1,3}(\.([0-9]{1,3})){3}' skipwhite contained

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_hdrlength nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_hdrlength '\vhdrlength' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_constant_expr_int_hex_4b

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_checksum nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_checksum '\vchecksum' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_constant_expr_int_hex_16b

syn match nft_datatype_ip_protocol '\v((udplite|icmpv6|comp|dccp|icmp|sctp|esp|tcp|udp|ah)|(0x[0-9a-zA-F]{1,2})|([0-9]{1,3}))' skipwhite contained


hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_protocol nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_protocol '\vprotocol\ze[ \t]{1,5}' keepend skipwhite contained
\ nextgroup=
\    nft_datatype_ip_protocol,
\    nft_close_scope_ip_primary_expr_constant_expr_int_hex_8b,
\    nft_Error

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_frag_off nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_frag_off '\vfrag\-off' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_constant_expr_int_hex_16b

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_version nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_version '\vversion' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_constant_expr_int_hex_8b

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_length nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_length '\vlength' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_map_expr_keyword_map,
\    nft_close_scope_ip_primary_expr_constant_expr_int_hex_16b

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_daddr nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_daddr '\vdaddr' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_constant_expr_ip

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_saddr nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_saddr '\vsaddr' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_constant_expr_at_setname,
\    nft_close_scope_ip_primary_expr_constant_expr_ip

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_dscp nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_dscp '\vdscp' skipwhite contained

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_ecn nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_ecn '\vecn' skipwhite contained

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_ttl nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_ttl '\vttl' skipwhite contained

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_id nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_id '\vid' skipwhite contained

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field '\v(hdrlength|checksum|protocol|frag\-off|version|length|daddr|saddr|dscp|ecn|ttl|id)' skipwhite contained

" ip nexthdr: tcp, udp, icmp, igmp, esp, ah, sctp, dccp, gre, ipip, ipv6.
" ip protocol: tcp, udp, icmp, igmp, esp, ah, sctp, dccp, gre, ipip, ipv6.
" icmp protocol: echo-reply, destination-unreachable, source-quench, redirect, echo-request, router-advertisement, router-solicitation, time-exceeded, parameter-problem, timestamp-request, timestamp-reply, info-request, info-reply, address-mask-request, address-mask-reply.
" Takeaway: corresponding 'ip[6] nexthdr' and 'ip[6] protocol' are identical
" Enforce 'ip protocol' and 'ip6 nexthdr'
hi link   nft_primary_stmt_expr_payload_expr_keyword_ip nftHL_Statement
syn match nft_primary_stmt_expr_payload_expr_keyword_ip '\vip' skipwhite contained
\ nextgroup=
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_hdrlength,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_checksum,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_protocol,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_frag_off,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_version,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_length,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_keyword_option,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_daddr,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_saddr,
\    nft_payload_expr_ip_protocol_keyword_dccp,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_dscp,
\    nft_payload_expr_ip_protocol_keyword_icmp,
\    nft_payload_expr_ip_protocol_keyword_igmp,
\    nft_payload_expr_ip_protocol_keyword_ipip,
\    nft_payload_expr_ip_protocol_keyword_ipv6,
\    nft_payload_expr_ip_protocol_keyword_sctp,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_ecn,
\    nft_payload_expr_ip_protocol_keyword_esp,
\    nft_payload_expr_ip_protocol_keyword_gre,
\    nft_payload_expr_ip_protocol_keyword_tcp,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_ttl,
\    nft_payload_expr_ip_protocol_keyword_udp,
\    nft_payload_expr_ip_protocol_keyword_ah,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_id,
\    nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip_hdr_expr_named_set,
\    nft_chainError
" ************************* END ip_hdr_expr' *************************

" ************************* BEGIN ip6_hdr_expr' *************************
" ************************* BEGIN ip6 flowlabel' *************************
hi link   nft_payload_expr_ip6_flowlabel_hex_value nftHL_Integer
syn match nft_payload_expr_ip6_flowlabel_hex_value '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,10}))' skipwhite contained

hi link   nft_payload_expr_ip6_flowlabel_in_set_block nftHL_BlockDelimitersSet
syn region nft_payload_expr_ip6_flowlabel_in_set_block start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_ip6_flowlabel_hex_value
hi link   nft_payload_expr_ip6_flowlabel_keyword_in nftHL_Keyword
syn match nft_payload_expr_ip6_flowlabel_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_flowlabel_in_set_block

hi link   nft_payload_expr_ip6_flowlabel_operator_1char nftHL_Expression
syn match nft_payload_expr_ip6_flowlabel_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_flowlabel_hex_value,
\    nft_chainError

hi link   nft_payload_expr_ip6_flowlabel_operator_2char nftHL_Expression
syn match nft_payload_expr_ip6_flowlabel_operator_2char '\v([\>\<])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_flowlabel_hex_value,
\    nft_chainError

hi link   nft_payload_expr_ip6_flowlabel_keyword_not nftHL_Operator
syn match nft_payload_expr_ip6_flowlabel_keyword_not '\vnot' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_flowlabel_hex_value,
\    nft_chainError

hi link   nft_payload_expr_ip6_flowlabel_named_set nftHL_AtSetname
syn match nft_payload_expr_ip6_flowlabel_named_set '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_flowlabel nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_flowlabel '\vflowlabel' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_flowlabel_keyword_not,
\    nft_payload_expr_ip6_flowlabel_named_set,
\    nft_payload_expr_ip6_flowlabel_keyword_in,
\    nft_payload_expr_ip6_flowlabel_operator_2char,
\    nft_payload_expr_ip6_flowlabel_hex_value,
\    nft_payload_expr_ip6_flowlabel_operator_1char,
\    nft_chainError
" ************************* END ip6 flowlabel' *************************

" ************************* BEGIN ip6 hoplimit' *************************
hi link   nft_payload_expr_ip6_hoplimit_hex_value nftHL_Integer
syn match nft_payload_expr_ip6_hoplimit_hex_value '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,10}))' skipwhite contained

hi link   nft_payload_expr_ip6_hoplimit_in_set_block nftHL_BlockDelimitersSet
syn region nft_payload_expr_ip6_hoplimit_in_set_block start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_ip6_hoplimit_hex_value

hi link   nft_payload_expr_ip6_hoplimit_keyword_in nftHL_Keyword
syn match nft_payload_expr_ip6_hoplimit_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_hoplimit_in_set_block

hi link   nft_payload_expr_ip6_hoplimit_operator_1char nftHL_Expression
syn match nft_payload_expr_ip6_hoplimit_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_hoplimit_hex_value,
\    nft_chainError

hi link   nft_payload_expr_ip6_hoplimit_operator_2char nftHL_Expression
syn match nft_payload_expr_ip6_hoplimit_operator_2char '\v([\>\<])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_hoplimit_hex_value,
\    nft_chainError

hi link   nft_payload_expr_ip6_hoplimit_keyword_not nftHL_Operator
syn match nft_payload_expr_ip6_hoplimit_keyword_not '\vnot' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_hoplimit_hex_value,
\    nft_chainError

hi link   nft_payload_expr_ip6_hoplimit_named_set nftHL_AtSetname
syn match nft_payload_expr_ip6_hoplimit_named_set '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_hoplimit nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_hoplimit '\vhoplimit' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_hoplimit_keyword_not,
\    nft_payload_expr_ip6_hoplimit_named_set,
\    nft_payload_expr_ip6_hoplimit_keyword_in,
\    nft_payload_expr_ip6_hoplimit_operator_2char,
\    nft_payload_expr_ip6_hoplimit_hex_value,
\    nft_payload_expr_ip6_hoplimit_operator_1char,
\    nft_chainError
" ************************* END ip6 hoplimit' *************************

" ************************* BEGIN ip6 nexthdr' *************************
" this section covers options specific to ip6 nexthdr'
" ************************* BEGIN ip6 nexthdr hop-by-hop' *************************
hi link   nft_payload_expr_ip6_nexthdr_hop_by_hop_hex_value nftHL_Integer
syn match nft_payload_expr_ip6_nexthdr_hop_by_hop_hex_value '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,10}))\ze[ \t;\n]' skipwhite contained

hi link   nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_data nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_data '\vopt\-data\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_hop_by_hop_hex_value,
\    nft_Error

hi link   nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_type nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_type '\vopt\-type\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_length_integer_expr_num,
\    nft_Error

hi link   nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_len nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_len '\vopt\-len\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_length_integer_expr_num,
\    nft_Error

hi link   nft_payload_expr_ip6_nexthdr_keyword_hop_by_hop nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_keyword_hop_by_hop '\vhop\-by\-hop\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_data,
\    nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_type,
\    nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_len,
\    nft_chainError
" ************************* END ip6 nexthdr hop-by-hop' *************************

" ************************* BEGIN ip6 nexthdr fragment' *************************
" ip6 nexthdr fragment: offset, more-fragments, id
hi link   nft_payload_expr_ip6_named_set_fragment_id nftHL_Integer
syn match nft_payload_expr_ip6_named_set_fragment_id '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,10}))\ze[ \t\n;,]' skipwhite contained

hi link   nft_payload_expr_ip6_fragment_id nftHL_Integer
syn match nft_payload_expr_ip6_fragment_id '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,10}))\ze[ \t\n;]' skipwhite contained

hi link   nft_payload_expr_ip6_fragment_dash_symbol nftHL_Integer
syn match nft_payload_expr_ip6_fragment_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_ip6_fragment_id,
\    nft_Error

hi link   nft_payload_expr_ip6_fragment_id_or_id_range nftHL_Integer
syn match nft_payload_expr_ip6_fragment_id_or_id_range '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,10}))' contained
\ nextgroup=
\    nft_payload_expr_ip6_fragment_dash_symbol

hi link   nft_payload_expr_ip6_fragment_in_set_block nftHL_BlockDelimitersSet
syn region nft_payload_expr_ip6_fragment_in_set_block start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_ip6_named_set_fragment_id

hi link   nft_payload_expr_ip6_fragment_keyword_in nftHL_Keyword
syn match nft_payload_expr_ip6_fragment_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_fragment_in_set_block

hi link   nft_payload_expr_ip6_fragment_operator_1char nftHL_Expression
syn match nft_payload_expr_ip6_fragment_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_fragment_id_or_id_range,
\    nft_chainError

hi link   nft_payload_expr_ip6_fragment_operator_2char nftHL_Expression
syn match nft_payload_expr_ip6_fragment_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_fragment_id_or_id_range,
\    nft_chainError

hi link   nft_payload_expr_ip6_fragment_keyword_more_fragments nftHL_Keyword
syn match nft_payload_expr_ip6_fragment_keyword_more_fragments '\vmore\-fragments\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_fragment_operator_2char,
\    nft_payload_expr_ip6_fragment_keyword_in,
\    nft_payload_expr_ip6_fragment_named_set,
\    nft_payload_expr_ip6_fragment_id_or_id_range,
\    nft_payload_expr_ip6_fragment_operator_1char,
\    nft_chainError

hi link   nft_payload_expr_ip6_fragment_keyword_offset nftHL_Keyword
syn match nft_payload_expr_ip6_fragment_keyword_offset '\voffset\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_fragment_operator_2char,
\    nft_payload_expr_ip6_fragment_keyword_in,
\    nft_payload_expr_ip6_fragment_named_set,
\    nft_payload_expr_ip6_fragment_id_or_id_range,
\    nft_payload_expr_ip6_fragment_operator_1char,
\    nft_chainError

hi link   nft_payload_expr_ip6_fragment_keyword_id nftHL_Keyword
syn match nft_payload_expr_ip6_fragment_keyword_id '\vid\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_fragment_operator_2char,
\    nft_payload_expr_ip6_fragment_keyword_in,
\    nft_payload_expr_ip6_fragment_named_set,
\    nft_payload_expr_ip6_fragment_id_or_id_range,
\    nft_payload_expr_ip6_fragment_operator_1char,
\    nft_chainError

hi link   nft_payload_expr_ip6_fragment_keyword_not nftHL_Operator
syn match nft_payload_expr_ip6_fragment_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_fragment_keyword_more_fragments,
\    nft_payload_expr_ip6_fragment_keyword_offset,
\    nft_payload_expr_ip6_fragment_keyword_id,
\    nft_chainError

hi link   nft_payload_expr_ip6_fragment_named_set nftHL_AtSetname
syn match nft_payload_expr_ip6_fragment_named_set '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained

hi link   nft_payload_expr_ip6_nexthdr_keyword_fragment nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_keyword_fragment '\vfragment\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_fragment_keyword_more_fragments,
\    nft_payload_expr_ip6_fragment_keyword_offset,
\    nft_payload_expr_ip6_fragment_keyword_not,
\    nft_payload_expr_ip6_fragment_keyword_id,
\    nft_chainError
" ************************* END ip6 nexthdr fragment' *************************

" ************************* BEGIN ip6 nexthdr no-next' *************************
hi link   nft_payload_expr_ip6_nexthdr_keyword_no_next nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_keyword_no_next '\vno\-next\ze[ \t]' skipwhite contained
" ************************* END ip6 nexthdr no-next' *************************

" ************************* BEGIN ip6 nexthdr routing' *************************
" ip6 nexthdr routing: type, segments-left, addr
" ip6 nexthdr routing type 1
hi link   nft_payload_expr_ip6_nexthdr_routing_named_set nftHL_AtSetname
syn match nft_payload_expr_ip6_nexthdr_routing_named_set '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained

hi link   nft_payload_expr_ip6_nexthdr_routing_type nftHL_Integer
syn match nft_payload_expr_ip6_nexthdr_routing_type '\v((0x[0-9a-fA-F]{1,1})|([0-9]{1,3}))\ze[ \t\n;]' skipwhite contained

" ip6 nexthdr routing type in { 1 }
hi link   nft_payload_expr_ip6_nexthdr_routing_type_set_block nftHL_BlockDelimitersSet
syn region nft_payload_expr_ip6_nexthdr_routing_type_set_block start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_ip6_nexthdr_routing_type

" ip6 nexthdr routing type in
hi link   nft_payload_expr_ip6_nexthdr_routing_type_keyword_in nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_routing_type_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_type_set_block

" ip6 nexthdr routing type >
hi link   nft_payload_expr_ip6_nexthdr_routing_type_operator_1char nftHL_Expression
syn match nft_payload_expr_ip6_nexthdr_routing_type_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_type,
\    nft_chainError

" ip6 nexthdr routing type >=
hi link   nft_payload_expr_ip6_nexthdr_routing_type_operator_2char nftHL_Expression
syn match nft_payload_expr_ip6_nexthdr_routing_type_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_type,
\    nft_chainError

" ip6 nexthdr routing type
hi link   nft_payload_expr_ip6_nexthdr_routing_keyword_type nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_routing_keyword_type '\vtype\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_type_operator_2char,
\    nft_payload_expr_ip6_nexthdr_routing_type_keyword_in,
\    nft_payload_expr_ip6_nexthdr_routing_named_set,
\    nft_payload_expr_ip6_nexthdr_routing_type,
\    nft_payload_expr_ip6_nexthdr_routing_type_operator_1char,
\    nft_chainError

hi link   nft_payload_expr_ip6_nexthdr_routing_segments_left nftHL_Integer
syn match nft_payload_expr_ip6_nexthdr_routing_segments_left '\v((0x[0-9a-fA-F]{1,1})|([0-9]{1,3}))\ze[ \t\n;]' skipwhite contained

" ip6 nexthdr routing segments_left in { 1 }
hi link   nft_payload_expr_ip6_nexthdr_routing_segments_left_set_block nftHL_BlockDelimitersSet
syn region nft_payload_expr_ip6_nexthdr_routing_segments_left_set_block start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_ip6_nexthdr_routing_segments_left

" ip6 nexthdr routing segments_left in
hi link   nft_payload_expr_ip6_nexthdr_routing_segments_left_keyword_in nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_routing_segments_left_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_segments_left_set_block

" ip6 nexthdr routing segments_left >
hi link   nft_payload_expr_ip6_nexthdr_routing_segments_left_operator_1char nftHL_Expression
syn match nft_payload_expr_ip6_nexthdr_routing_segments_left_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_segments_left,
\    nft_chainError

" ip6 nexthdr routing segments_left >=
hi link   nft_payload_expr_ip6_nexthdr_routing_segments_left_operator_2char nftHL_Expression
syn match nft_payload_expr_ip6_nexthdr_routing_segments_left_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_segments_left,
\    nft_chainError

" ip6 nexthdr routing segments_left
hi link   nft_payload_expr_ip6_nexthdr_routing_keyword_segments_left nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_routing_keyword_segments_left '\vsegments\-left\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_segments_left_operator_2char,
\    nft_payload_expr_ip6_nexthdr_routing_segments_left_keyword_in,
\    nft_payload_expr_ip6_nexthdr_routing_named_set,
\    nft_payload_expr_ip6_nexthdr_routing_segments_left,
\    nft_payload_expr_ip6_nexthdr_routing_segments_left_operator_1char,
\    nft_chainError

hi link   nft_payload_expr_ip6_nexthdr_routing_keyword_segments_left nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_routing_keyword_segments_left '\vsegments\-left\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_segments_left_operator_2char,
\    nft_payload_expr_ip6_nexthdr_routing_segments_left_keyword_in,
\    nft_payload_expr_ip6_nexthdr_routing_named_set,
\    nft_payload_expr_ip6_nexthdr_routing_segments_left,
\    nft_payload_expr_ip6_nexthdr_routing_segments_left_operator_1char,
\    nft_chainError

hi link   nft_payload_expr_ip6_nexthdr_routing_addr_ip6_addr_or_addr_prefix nftHL_Integer
syn match nft_payload_expr_ip6_nexthdr_routing_addr_ip6_addr_or_addr_prefix '\v([0-9a-fA-F]{1,4}::{0,7}){1,7}[0-9a-fA-F]{1,4}' skipwhite contained

" ip6 nexthdr routing addr in { fffe:::1 }
hi link   nft_payload_expr_ip6_nexthdr_routing_addr_set_block nftHL_BlockDelimitersSet
syn region nft_payload_expr_ip6_nexthdr_routing_addr_set_block start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_ip6_nexthdr_routing_addr_ip6_addr_or_addr_prefix

" ip6 nexthdr routing addr in
hi link   nft_payload_expr_ip6_nexthdr_routing_addr_keyword_in nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_routing_addr_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_addr_set_block

" ip6 nexthdr routing addr >
hi link   nft_payload_expr_ip6_nexthdr_routing_addr_operator_1char nftHL_Expression
syn match nft_payload_expr_ip6_nexthdr_routing_addr_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_addr_ip6_addr_or_addr_prefix,
\    nft_chainError

" ip6 nexthdr routing addr >=
hi link   nft_payload_expr_ip6_nexthdr_routing_addr_operator_2char nftHL_Expression
syn match nft_payload_expr_ip6_nexthdr_routing_addr_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_addr_ip6_addr_or_addr_prefix,
\    nft_chainError

hi link   nft_payload_expr_ip6_nexthdr_routing_keyword_addr nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_routing_keyword_addr '\vaddr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_addr_operator_2char,
\    nft_payload_expr_ip6_nexthdr_routing_addr_keyword_in,
\    nft_payload_expr_ip6_nexthdr_routing_named_set,
\    nft_payload_expr_ip6_nexthdr_routing_addr_operator_1char,
\    nft_payload_expr_ip6_nexthdr_routing_addr_ip6_addr_or_addr_prefix,
\    nft_chainError

hi link   nft_payload_expr_ip6_nexthdr_routing_keyword_not nftHL_Operator
syn match nft_payload_expr_ip6_nexthdr_routing_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_keyword_segments_left,
\    nft_payload_expr_ip6_nexthdr_routing_keyword_offset,
\    nft_payload_expr_ip6_nexthdr_routing_keyword_id,
\    nft_chainError

hi link   nft_payload_expr_ip6_nexthdr_keyword_routing nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_keyword_routing '\vrouting\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_keyword_segments_left,
\    nft_payload_expr_ip6_nexthdr_routing_keyword_addr,
\    nft_payload_expr_ip6_nexthdr_routing_keyword_type,
\    nft_payload_expr_ip6_nexthdr_routing_keyword_not,
\    nft_chainError
" ************************* END ip6 nexthdr routing' *************************

" ************************* BEGIN icmp' expression *************************
" Often prepended with 'ip6 nexthdr icmp'
" type, code, checksum, type-specific fields (e.g., id, sequence)
hi link   nft_payload_expr_icmp_named_set nftHL_AtSetname
syn match nft_payload_expr_icmp_named_set '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained

" ************************* BEGIN icmp checksum' expression *************************
hi link   nft_payload_expr_icmp_checksum_inline_set_checksum nftHL_Integer
syn match nft_payload_expr_icmp_checksum_inline_set_checksum '\v(0x[0-9a-fA-F]{1,8})|([0-9]{1,10})\ze[ \t\n,\}]' skipwhite contained

syn cluster nft_c_payload_expr_icmp_expressions
\ contains=
\    nft_payload_expr_icmp_keyword_checksum,
\    nft_payload_expr_icmp_keyword_sequence,
\    nft_payload_expr_icmp_keyword_gateway,
\    nft_payload_expr_icmp_keyword_code,
\    nft_payload_expr_icmp_keyword_type,
\    nft_payload_expr_icmp_keyword_mtu,
\    nft_payload_expr_icmp_keyword_id,

" 'icmp checksum in { 1 }'
hi link   nft_payload_expr_icmp_checksum_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_icmp_checksum_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_icmp_checksum_inline_set_checksum
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" 'icmp checksum in'
hi link   nft_payload_expr_icmp_checksum_keyword_in nftHL_Keyword
syn match nft_payload_expr_icmp_checksum_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_checksum_inline_set

" 'icmp code 1'
hi link   nft_payload_expr_icmp_checksum nftHL_Integer
syn match nft_payload_expr_icmp_checksum '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" 'icmp checksum >'
hi link   nft_payload_expr_icmp_checksum_operator_1char nftHL_Expression
syn match nft_payload_expr_icmp_checksum_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_checksum,
\    nft_chainError

" 'icmp checksum >='
hi link   nft_payload_expr_icmp_checksum_operator_2char nftHL_Expression
syn match nft_payload_expr_icmp_checksum_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_checksum,
\    nft_chainError

" 'icmp checksum'
hi link   nft_payload_expr_icmp_keyword_checksum nftHL_Keyword
syn match nft_payload_expr_icmp_keyword_checksum '\vchecksum\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_checksum_operator_2char,
\    nft_payload_expr_icmp_checksum_keyword_in,
\    nft_payload_expr_icmp_checksum_operator_1char,
\    nft_payload_expr_icmp_checksum_inline_set,
\    nft_payload_expr_icmp_named_set,
\    nft_payload_expr_icmp_checksum,
\    nft_chainError
" ************************* END icmp checksum' expression *************************

" ************************* BEGIN icmp gateway' expression *************************
hi link   nft_payload_expr_icmp_gateway_inline_set_gateway nftHL_Integer
syn match nft_payload_expr_icmp_gateway_inline_set_gateway '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\n,\}]' skipwhite contained

" 'icmp gateway in { 1 }'
hi link    nft_payload_expr_icmp_gateway_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_icmp_gateway_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_icmp_gateway_inline_set_gateway
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" 'icmp gateway in'
hi link   nft_payload_expr_icmp_gateway_keyword_in nftHL_Keyword
syn match nft_payload_expr_icmp_gateway_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_gateway_inline_set

" 'icmp code 1'
hi link   nft_payload_expr_icmp_gateway nftHL_Integer
syn match nft_payload_expr_icmp_gateway '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" 'icmp gateway >'
hi link   nft_payload_expr_icmp_gateway_operator_1char nftHL_Expression
syn match nft_payload_expr_icmp_gateway_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_gateway,
\    nft_chainError

" 'icmp gateway >='
hi link   nft_payload_expr_icmp_gateway_operator_2char nftHL_Expression
syn match nft_payload_expr_icmp_gateway_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_gateway,
\    nft_chainError

" 'icmp gateway'
hi link   nft_payload_expr_icmp_keyword_gateway nftHL_Keyword
syn match nft_payload_expr_icmp_keyword_gateway '\vgateway\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_gateway_operator_2char,
\    nft_payload_expr_icmp_gateway_keyword_in,
\    nft_payload_expr_icmp_gateway_operator_1char,
\    nft_payload_expr_icmp_gateway_inline_set,
\    nft_payload_expr_icmp_named_set,
\    nft_payload_expr_icmp_gateway,
\    nft_chainError
" ************************* END icmp gateway' expression *************************

" ************************* BEGIN icmp sequence' expression *************************
hi link   nft_payload_expr_icmp_sequence_inline_set_sequence nftHL_Integer
syn match nft_payload_expr_icmp_sequence_inline_set_sequence '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\n,\}]' skipwhite contained

" 'icmp sequence in { 1 }'
hi link    nft_payload_expr_icmp_sequence_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_icmp_sequence_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_icmp_sequence_inline_set_sequence
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" 'icmp sequence in'
hi link   nft_payload_expr_icmp_sequence_keyword_in nftHL_Keyword
syn match nft_payload_expr_icmp_sequence_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_sequence_inline_set

" 'icmp code 1'
hi link   nft_payload_expr_icmp_sequence nftHL_Integer
syn match nft_payload_expr_icmp_sequence '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" 'icmp sequence >'
hi link   nft_payload_expr_icmp_sequence_operator_1char nftHL_Expression
syn match nft_payload_expr_icmp_sequence_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_sequence,
\    nft_chainError

" 'icmp sequence >='
hi link   nft_payload_expr_icmp_sequence_operator_2char nftHL_Expression
syn match nft_payload_expr_icmp_sequence_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_sequence,
\    nft_chainError

" 'icmp sequence'
hi link   nft_payload_expr_icmp_keyword_sequence nftHL_Keyword
syn match nft_payload_expr_icmp_keyword_sequence '\vsequence\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_sequence_operator_2char,
\    nft_payload_expr_icmp_sequence_keyword_in,
\    nft_payload_expr_icmp_sequence_operator_1char,
\    nft_payload_expr_icmp_sequence_inline_set,
\    nft_payload_expr_icmp_named_set,
\    nft_payload_expr_icmp_sequence,
\    nft_chainError
" ************************* END icmp sequence' expression *************************

" ************************* BEGIN icmp code' expression *************************
" 'icmp code { 1 }'
hi link   nft_payload_expr_icmp_code_inline_set_num nftHL_Integer
syn match nft_payload_expr_icmp_code_inline_set_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t\n,\}]' skipwhite contained

" 'icmp code in { }'
hi link    nft_payload_expr_icmp_code_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_icmp_code_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_icmp_code_inline_set_num
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" 'icmp code in'
hi link   nft_payload_expr_icmp_code_keyword_in nftHL_Keyword
syn match nft_payload_expr_icmp_code_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_code_inline_set

" 'icmp code 1'
hi link   nft_payload_expr_icmp_code_num nftHL_Integer
syn match nft_payload_expr_icmp_code_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" 'icmp code >'
hi link   nft_payload_expr_icmp_code_operator_1char nftHL_Expression
syn match nft_payload_expr_icmp_code_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_code_num,
\    nft_chainError

" 'icmp code >='
hi link   nft_payload_expr_icmp_code_operator_2char nftHL_Expression
syn match nft_payload_expr_icmp_code_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_code_num,
\    nft_chainError

" 'icmp code'
hi link   nft_payload_expr_icmp_keyword_code nftHL_Keyword
syn match nft_payload_expr_icmp_keyword_code '\vcode\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_code_operator_2char,
\    nft_payload_expr_icmp_code_keyword_in,
\    nft_payload_expr_icmp_code_operator_1char,
\    nft_payload_expr_icmp_code_inline_set,
\    nft_payload_expr_icmp_named_set,
\    nft_payload_expr_icmp_code_num,
\    nft_chainError
" ************************* END icmp code' expression *************************

" ************************* BEGIN icmp type' expression *************************
hi link   nft_payload_expr_close_scope_icmp_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_icmp_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
" ip6 nexthdr icmp type <type_name>
hi link   nft_payload_expr_icmp_type_inline_set_type_num Define
syn match nft_payload_expr_icmp_type_inline_set_type_num '\v[0-9]{1,3}\ze[ \t\n,\}]' skipwhite contained

hi link   nft_payload_expr_icmp_type_inline_set_type_defines Define
syn match nft_payload_expr_icmp_type_inline_set_type_defines '\v(destination\-unreachable|address\-mask\-request|router\-advertisement|info\-request|router\-solicitation|address\-mask\-reply|info\-reply|parameter\-problem|timestamp\-request|timestamp\-reply|source\-quench|time\-exceeded|echo\-request|echo\-reply|redirect)\ze[ \t\n,\}]' skipwhite contained

" ip6 nexthdr icmp type in { 1 }
hi link    nft_payload_expr_icmp_type_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_icmp_type_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_icmp_type_inline_set_type_defines,
\    nft_payload_expr_icmp_type_inline_set_type_num
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions,
\    @nft_c_primary_stmt_expr,
\    @nft_c_stmt


" ip6 nexthdr icmp type in
hi link   nft_payload_expr_icmp_type_keyword_in nftHL_Keyword
syn match nft_payload_expr_icmp_type_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_type_inline_set

hi link   nft_payload_expr_icmp_type_num Define
syn match nft_payload_expr_icmp_type_num '\v[0-9]{1,3}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

hi link   nft_payload_expr_icmp_type_defines Define
syn match nft_payload_expr_icmp_type_defines '\v(destination\-unreachable|address\-mask\-request|router\-advertisement|info\-request|router\-solicitation|address\-mask\-reply|info\-reply|parameter\-problem|timestamp\-request|timestamp\-reply|source\-quench|time\-exceeded|echo\-request|echo\-reply|redirect)\ze[ \t]' skipwhite contained
\ skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" 'ip6 nexthdr icmp type >'
hi link   nft_payload_expr_icmp_type_operator_1char nftHL_Expression
syn match nft_payload_expr_icmp_type_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_type_defines,
\    nft_payload_expr_icmp_type_num,
\    nft_chainError

" 'icmp type >='
hi link   nft_payload_expr_icmp_type_operator_2char nftHL_Expression
syn match nft_payload_expr_icmp_type_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_type_defines,
\    nft_payload_expr_icmp_type_num,
\    nft_chainError

" 'icmp type'
hi link   nft_payload_expr_icmp_keyword_type nftHL_Keyword
syn match nft_payload_expr_icmp_keyword_type '\vtype\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_type_defines,
\    nft_payload_expr_icmp_type_operator_2char,
\    nft_payload_expr_icmp_type_keyword_in,
\    nft_payload_expr_icmp_type_operator_1char,
\    nft_payload_expr_icmp_type_inline_set,
\    nft_payload_expr_named_set,
\    nft_payload_expr_close_scope_icmp_variable_expr,
\    nft_payload_expr_icmp_type_num,
\    nft_chainError
" ************************* END icmp type' expression *************************

" ************************* BEGIN 'ip6 nexthdr icmp mtu' expression *************************
" ip6 nexthdr icmp mtu in { 1,127,255 }
hi link   nft_payload_expr_icmp_inline_set_mtu nftHL_Integer
syn match nft_payload_expr_icmp_inline_set_mtu '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\n,\}]' skipwhite contained

" ip6 nexthdr icmp mtu in {  }
hi link    nft_payload_expr_icmp_mtu_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_icmp_mtu_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_icmp_inline_set_mtu
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" ip6 nexthdr icmp mtu in
hi link   nft_payload_expr_icmp_mtu_keyword_in nftHL_Keyword
syn match nft_payload_expr_icmp_mtu_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_mtu_inline_set

hi link   nft_payload_expr_icmp_mtu_num nftHL_Integer
syn match nft_payload_expr_icmp_mtu_num '\v[0-9]{1,5}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" ip6 nexthdr icmp mtu >
hi link   nft_payload_expr_icmp_mtu_operator_1char nftHL_Expression
syn match nft_payload_expr_icmp_mtu_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_mtu_num,
\    nft_chainError

" ip6 nexthdr icmp mtu >=
hi link   nft_payload_expr_icmp_mtu_operator_2char nftHL_Expression
syn match nft_payload_expr_icmp_mtu_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_mtu_num,
\    nft_chainError

" ip6 nexthdr icmp mtu
hi link   nft_payload_expr_icmp_keyword_mtu nftHL_Keyword
syn match nft_payload_expr_icmp_keyword_mtu '\vmtu\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_mtu_operator_2char,
\    nft_payload_expr_icmp_mtu_keyword_in,
\    nft_payload_expr_icmp_mtu_operator_1char,
\    nft_payload_expr_icmp_named_set,
\    nft_payload_expr_icmp_mtu_inline_set,
\    nft_payload_expr_icmp_mtu_num,
\    nft_chainError
" ************************* END icmp mtu' expression *************************

" ************************* BEGIN icmp id' expression *************************
" ip6 nexthdr icmp id in { 1,127,255 }
hi link   nft_payload_expr_icmp_id_inline_set_num nftHL_Integer
syn match nft_payload_expr_icmp_id_inline_set_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t\n,]' skipwhite contained

" ip6 nexthdr icmp id in {  }
hi link    nft_payload_expr_icmp_id_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_icmp_id_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_icmp_id_inline_set_num
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" ip6 nexthdr icmp id in
hi link   nft_payload_expr_icmp_id_keyword_in nftHL_Keyword
syn match nft_payload_expr_icmp_id_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_id_inline_set

hi link   nft_payload_expr_icmp_id_num nftHL_Integer
syn match nft_payload_expr_icmp_id_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions
" ip6 nexthdr icmp id >
hi link   nft_payload_expr_icmp_id_operator_1char nftHL_Expression
syn match nft_payload_expr_icmp_id_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_id_num,
\    nft_chainError

" ip6 nexthdr icmp id >=
hi link   nft_payload_expr_icmp_id_operator_2char nftHL_Expression
syn match nft_payload_expr_icmp_id_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_id_num,
\    nft_chainError

" ip6 nexthdr icmp id
hi link   nft_payload_expr_icmp_keyword_id nftHL_Keyword
syn match nft_payload_expr_icmp_keyword_id '\vid\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_id_operator_2char,
\    nft_payload_expr_icmp_id_keyword_in,
\    nft_payload_expr_icmp_id_operator_1char,
\    nft_payload_expr_icmp_id_inline_set,
\    nft_payload_expr_icmp_named_set,
\    nft_payload_expr_icmp_id_num,
\    nft_chainError
" ************************* END icmp id' expression *************************

" icmp nexthdr: echo-reply, destination-unreachable, source-quench, redirect, echo-request, router-advertisement, router-solicitation, time-exceeded, parameter-problem, timestamp-request, timestamp-reply, info-request, info-reply, address-mask-request, address-mask-reply.
" 'icmp': type, code, checksum, id, sequence, gateway, mtu
hi link   nft_payload_expr_icmp_hdr_expr_keyword_icmp nftHL_Command
syn match nft_payload_expr_icmp_hdr_expr_keyword_icmp '\vicmp\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_keyword_sequence,
\    nft_payload_expr_icmp_keyword_checksum,
\    nft_payload_expr_icmp_keyword_gateway,
\    nft_payload_expr_icmp_keyword_code,
\    nft_payload_expr_icmp_keyword_type,
\    nft_payload_expr_icmp_keyword_mtu,
\    nft_payload_expr_icmp_keyword_id,
\    nft_chainError
" ************************* END icmp' expression *************************

" ************************* BEGIN dccp' expression *************************
" dccp: sport, dport, type, checksum

" ************************* BEGIN dccp checksum' *************************
" 'dccp checksum 0xffffffff'
hi link   nft_payload_expr_dccp_checksum nftHL_Integer
syn match nft_payload_expr_dccp_checksum '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_keyword_checksum,
\    nft_payload_expr_dccp_keyword_sport,
\    nft_payload_expr_dccp_keyword_type,

" 'dccp checksum in { 1,127,255 }"
hi link   nft_payload_expr_dccp_inline_set_checksum nftHL_Integer
syn match nft_payload_expr_dccp_inline_set_checksum '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\n,;\}]' skipwhite contained

" 'dccp checksum in {  }'
hi link    nft_payload_expr_dccp_checksum_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_dccp_checksum_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_dccp_inline_set_checksum

" 'dccp checksum in'
hi link   nft_payload_expr_dccp_checksum_keyword_in nftHL_Keyword
syn match nft_payload_expr_dccp_checksum_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_checksum_inline_set

" 'dccp checksum >'
hi link   nft_payload_expr_dccp_checksum_operator_1char nftHL_Expression
syn match nft_payload_expr_dccp_checksum_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_checksum,
\    nft_chainError

" 'dccp checksum >='
hi link   nft_payload_expr_dccp_checksum_operator_2char nftHL_Expression
syn match nft_payload_expr_dccp_checksum_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_checksum,
\    nft_chainError

" 'dccp checksum'
hi link   nft_payload_expr_dccp_keyword_checksum nftHL_Keyword
syn match nft_payload_expr_dccp_keyword_checksum '\vchecksum\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_checksum_operator_2char,
\    nft_payload_expr_dccp_checksum_keyword_in,
\    nft_payload_expr_dccp_checksum_operator_1char,
\    nft_payload_expr_dccp_checksum,
\    nft_payload_expr_named_set,
\    nft_chainError
" ************************* END ip6 nexthdr dccp checksum' *************************

" ************************* BEGIN ip6 nexthdr dccp dport' *************************
" 'dccp dport'
hi link   nft_payload_expr_dccp_dport nftHL_Integer
syn match nft_payload_expr_dccp_dport '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_keyword_checksum,
\    nft_payload_expr_dccp_keyword_sport,
\    nft_payload_expr_dccp_keyword_type,

" 'dccp dport in { 1,127,255 }'
hi link   nft_payload_expr_dccp_inline_set_dport nftHL_Integer
syn match nft_payload_expr_dccp_inline_set_dport '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\n,;\}]' skipwhite contained

" 'dccp dport in {  }'
hi link    nft_payload_expr_dccp_dport_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_dccp_dport_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_dccp_inline_set_dport

" 'dccp dport in'
hi link   nft_payload_expr_dccp_dport_keyword_in nftHL_Keyword
syn match nft_payload_expr_dccp_dport_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_dport_inline_set

" 'dccp dport >'
hi link   nft_payload_expr_dccp_dport_operator_1char nftHL_Expression
syn match nft_payload_expr_dccp_dport_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_dport,
\    nft_chainError

" 'dccp dport >='
hi link   nft_payload_expr_dccp_dport_operator_2char nftHL_Expression
syn match nft_payload_expr_dccp_dport_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_dport,
\    nft_chainError

" 'dccp dport'
hi link   nft_payload_expr_dccp_keyword_dport nftHL_Keyword
syn match nft_payload_expr_dccp_keyword_dport '\vdport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_dport_operator_2char,
\    nft_payload_expr_dccp_dport_keyword_in,
\    nft_payload_expr_dccp_dport_operator_1char,
\    nft_payload_expr_dccp_dport,
\    nft_payload_expr_named_set,
\    nft_chainError
" ************************* END dccp dport' *************************

" ************************* BEGIN dccp sport' *************************
" 'dccp sport"
hi link   nft_payload_expr_dccp_sport nftHL_Integer
syn match nft_payload_expr_dccp_sport '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_keyword_checksum,
\    nft_payload_expr_dccp_keyword_dport,
\    nft_payload_expr_dccp_keyword_type,

" 'dccp sport in { 1,127,255 }'
hi link   nft_payload_expr_dccp_inline_set_sport nftHL_Integer
syn match nft_payload_expr_dccp_inline_set_sport '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\n,;\}]' skipwhite contained

" 'dccp sport in {  }'
hi link    nft_payload_expr_dccp_sport_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_dccp_sport_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_dccp_inline_set_sport

" 'dccp sport in'
hi link   nft_payload_expr_dccp_sport_keyword_in nftHL_Keyword
syn match nft_payload_expr_dccp_sport_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_sport_inline_set

" 'dccp sport >'
hi link   nft_payload_expr_dccp_sport_operator_1char nftHL_Expression
syn match nft_payload_expr_dccp_sport_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_sport,
\    nft_chainError

" 'dccp sport >='
hi link   nft_payload_expr_dccp_sport_operator_2char nftHL_Expression
syn match nft_payload_expr_dccp_sport_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_sport,
\    nft_chainError

" 'dccp sport"
hi link   nft_payload_expr_dccp_keyword_sport nftHL_Keyword
syn match nft_payload_expr_dccp_keyword_sport '\vsport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_sport_operator_2char,
\    nft_payload_expr_dccp_sport_keyword_in,
\    nft_payload_expr_dccp_sport_operator_1char,
\    nft_payload_expr_dccp_sport,
\    nft_payload_expr_named_set,
\    nft_chainError
" ************************* END dccp sport' *************************

" ************************* BEGIN dccp type' *************************
hi link   nft_payload_expr_dccp_type nftHL_Define
syn match nft_payload_expr_dccp_type '\v(closereq|response|dataack|request|syncack|close|reset|data|sync|ack)' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_keyword_checksum,
\    nft_payload_expr_dccp_keyword_dport,
\    nft_payload_expr_dccp_keyword_sport,

" ' dccp type 14'
hi link   nft_payload_expr_dccp_type_int nftHL_Integer
syn match nft_payload_expr_dccp_type_int '\v((0x[0-9a-fA-F]{1,1})|([0-9]{1,1}))\ze[ \t\n,;\}]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_keyword_checksum,
\    nft_payload_expr_dccp_keyword_dport,
\    nft_payload_expr_dccp_keyword_sport,

" 'dccp type in { 1,127,255 }'
hi link   nft_payload_expr_dccp_inline_set_type nftHL_Define
syn match nft_payload_expr_dccp_inline_set_type '\v(closereq|response|dataack|request|syncack|close|reset|data|sync|ack)' skipwhite contained
hi link   nft_payload_expr_dccp_inline_set_type_int nftHL_Integer
syn match nft_payload_expr_dccp_inline_set_type_int '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t\n,;\}]' skipwhite contained

" ip6 nexthdr dccp type in {  }
hi link    nft_payload_expr_dccp_type_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_dccp_type_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_dccp_inline_set_type,
\    nft_payload_expr_dccp_inline_set_type_int

" 'dccp type in'
hi link   nft_payload_expr_dccp_type_keyword_in nftHL_Keyword
syn match nft_payload_expr_dccp_type_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_type_inline_set

" 'dccp type >'
hi link   nft_payload_expr_dccp_type_operator_1char nftHL_Expression
syn match nft_payload_expr_dccp_type_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_type,
\    nft_payload_expr_dccp_type_int,
\    nft_chainError

" 'dccp type >='
hi link   nft_payload_expr_dccp_type_operator_2char nftHL_Expression
syn match nft_payload_expr_dccp_type_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_type,
\    nft_payload_expr_dccp_type_int,
\    nft_chainError

" 'dccp type'
hi link   nft_payload_expr_dccp_keyword_type nftHL_Keyword
syn match nft_payload_expr_dccp_keyword_type '\vtype\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_type,
\    nft_payload_expr_dccp_type_operator_2char,
\    nft_payload_expr_dccp_type_keyword_in,
\    nft_payload_expr_named_set,
\    nft_payload_expr_dccp_type_operator_1char,
\    nft_payload_expr_dccp_type_int,
\    nft_chainError
" ************************* END dccp type' *************************

hi link   nft_payload_expr_dccp_hdr_expr_keyword_dccp nftHL_Statement
syn match nft_payload_expr_dccp_hdr_expr_keyword_dccp '\vdccp' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_keyword_checksum,
\    nft_payload_expr_dccp_keyword_dport,
\    nft_payload_expr_dccp_keyword_sport,
\    nft_payload_expr_dccp_keyword_type,
\    nft_chainError
" ************************* END dccp' *************************

" ************************* BEGIN dest' *************************
"  dest: opt-type, opt-len, opt-data
hi link   nft_payload_expr_ip6_nexthdr_keyword_dest nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_keyword_dest '\vdest\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_data,
\    nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_type,
\    nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_len,
\    nft_chainError
" ************************* END dest' *************************

" ************************* BEGIN sctp' payload expression *************************
"  sctp: sport, dport, vtag, checksum
" ************************* BEGIN sctp checksum' *************************
"  sctp checksum
hi link   nft_payload_expr_sctp_checksum_second nftHL_Integer
syn match nft_payload_expr_sctp_checksum_second '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_keyword_dport,
\    nft_payload_expr_sctp_keyword_sport,
\    nft_payload_expr_sctp_keyword_vtag

hi link   nft_payload_expr_sctp_checksum_dash_symbol nftHL_Expression
syn match nft_payload_expr_sctp_checksum_dash_symbol '\v\-' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_checksum_second,
\    nft_chainError

hi link   nft_payload_expr_sctp_checksum nftHL_Integer
syn match nft_payload_expr_sctp_checksum '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\n;\-]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_checksum_dash_symbol,
\    nft_payload_expr_sctp_keyword_dport,
\    nft_payload_expr_sctp_keyword_sport,
\    nft_payload_expr_sctp_keyword_vtag,

"  'sctp checksum in { 1,127,255 }'
hi link   nft_payload_expr_sctp_inline_set_checksum nftHL_Integer
syn match nft_payload_expr_sctp_inline_set_checksum '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\n,;\}]' skipwhite contained

" 'sctp checksum in {  }'
hi link    nft_payload_expr_sctp_checksum_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_sctp_checksum_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_sctp_inline_set_checksum

" 'sctp checksum in'
hi link   nft_payload_expr_sctp_checksum_keyword_in nftHL_Keyword
syn match nft_payload_expr_sctp_checksum_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_checksum_inline_set

" 'sctp checksum >'
hi link   nft_payload_expr_sctp_checksum_operator_1char nftHL_Expression
syn match nft_payload_expr_sctp_checksum_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_checksum,
\    nft_chainError

" 'sctp checksum >='
hi link   nft_payload_expr_sctp_checksum_operator_2char nftHL_Expression
syn match nft_payload_expr_sctp_checksum_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_checksum,
\    nft_chainError

" 'sctp checksum'
hi link   nft_payload_expr_sctp_keyword_checksum nftHL_Keyword
syn match nft_payload_expr_sctp_keyword_checksum '\vchecksum\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_checksum_operator_2char,
\    nft_payload_expr_sctp_checksum_keyword_in,
\    nft_payload_expr_sctp_checksum_operator_1char,
\    nft_payload_expr_sctp_checksum,
\    nft_payload_expr_named_set,
\    nft_chainError
" ************************* END sctp checksum' *************************

" ************************* BEGIN sctp dport' *************************
" 'sctp dport'
hi link   nft_payload_expr_sctp_dport nftHL_Integer
syn match nft_payload_expr_sctp_dport '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_keyword_checksum,
\    nft_payload_expr_sctp_keyword_sport,
\    nft_payload_expr_sctp_keyword_vtag,

" 'sctp dport in { 1,127,255 }'
hi link   nft_payload_expr_sctp_inline_set_dport nftHL_Integer
syn match nft_payload_expr_sctp_inline_set_dport '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\n,;\}]' skipwhite contained

" 'sctp dport in {  }'
hi link    nft_payload_expr_sctp_dport_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_sctp_dport_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_sctp_inline_set_dport

" 'sctp dport in'
hi link   nft_payload_expr_sctp_dport_keyword_in nftHL_Keyword
syn match nft_payload_expr_sctp_dport_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_dport_inline_set

" 'sctp dport >'
hi link   nft_payload_expr_sctp_dport_operator_1char nftHL_Expression
syn match nft_payload_expr_sctp_dport_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_dport,
\    nft_chainError

" 'sctp dport >='
hi link   nft_payload_expr_sctp_dport_operator_2char nftHL_Expression
syn match nft_payload_expr_sctp_dport_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_dport,
\    nft_chainError

" 'sctp dport'
hi link   nft_payload_expr_sctp_keyword_dport nftHL_Keyword
syn match nft_payload_expr_sctp_keyword_dport '\vdport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_dport_operator_2char,
\    nft_payload_expr_sctp_dport_keyword_in,
\    nft_payload_expr_sctp_dport_operator_1char,
\    nft_payload_expr_sctp_dport,
\    nft_payload_expr_named_set,
\    nft_chainError
" ************************* END  sctp dport' *************************

" ************************* BEGIN  sctp sport' *************************
" 'sctp sport'
hi link   nft_payload_expr_sctp_sport nftHL_Integer
syn match nft_payload_expr_sctp_sport '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_keyword_checksum,
\    nft_payload_expr_sctp_keyword_dport,
\    nft_payload_expr_sctp_keyword_vtag,

" 'sctp sport in { 1,127,255 }'
hi link   nft_payload_expr_sctp_inline_set_sport nftHL_Integer
syn match nft_payload_expr_sctp_inline_set_sport '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\n,;\}]' skipwhite contained

" 'sctp sport in {  }'
hi link    nft_payload_expr_sctp_sport_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_sctp_sport_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_sctp_inline_set_sport

" 'sctp sport in'
hi link   nft_payload_expr_sctp_sport_keyword_in nftHL_Keyword
syn match nft_payload_expr_sctp_sport_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_sport_inline_set

" 'sctp sport >'
hi link   nft_payload_expr_sctp_sport_operator_1char nftHL_Expression
syn match nft_payload_expr_sctp_sport_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_sport,
\    nft_chainError

" 'sctp sport >='
hi link   nft_payload_expr_sctp_sport_operator_2char nftHL_Expression
syn match nft_payload_expr_sctp_sport_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_sport,
\    nft_chainError

" 'sctp sport'
hi link   nft_payload_expr_sctp_keyword_sport nftHL_Keyword
syn match nft_payload_expr_sctp_keyword_sport '\vsport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_sport_operator_2char,
\    nft_payload_expr_sctp_sport_keyword_in,
\    nft_payload_expr_sctp_sport_operator_1char,
\    nft_payload_expr_sctp_sport,
\    nft_payload_expr_named_set,
\    nft_chainError
" ************************* END sctp sport' *************************

" ************************* BEGIN sctp vtag' *************************
" 'sctp vtag 1-2'
hi link   nft_payload_expr_sctp_vtag_second nftHL_Integer
syn match nft_payload_expr_sctp_vtag_second '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_keyword_dport,
\    nft_payload_expr_sctp_keyword_sport,
\    nft_payload_expr_sctp_keyword_vtag

" 'sctp vtag 1-'
hi link   nft_payload_expr_sctp_vtag_dash_symbol nftHL_Expression
syn match nft_payload_expr_sctp_vtag_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_sctp_vtag_second,
\    nft_chainError

" 'sctp vtag 1'
hi link   nft_payload_expr_sctp_vtag nftHL_Integer
syn match nft_payload_expr_sctp_vtag '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))' contained
\ nextgroup=
\    nft_payload_expr_sctp_keyword_checksum,
\    nft_payload_expr_sctp_keyword_dport,
\    nft_payload_expr_sctp_keyword_vtag,
\    nft_payload_expr_sctp_vtag_dash_symbol,

" 'sctp vtag in { 1,127,255 }'
hi link   nft_payload_expr_sctp_inline_set_vtag nftHL_Integer
syn match nft_payload_expr_sctp_inline_set_vtag '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\n,;\}]' contained

" 'sctp vtag in {  }'
hi link    nft_payload_expr_sctp_vtag_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_sctp_vtag_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_sctp_inline_set_vtag,

" 'sctp vtag in'
hi link   nft_payload_expr_sctp_vtag_keyword_in nftHL_Keyword
syn match nft_payload_expr_sctp_vtag_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_vtag_inline_set

" 'sctp vtag >'
hi link   nft_payload_expr_sctp_vtag_operator_1char nftHL_Expression
syn match nft_payload_expr_sctp_vtag_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_vtag,
\    nft_chainError

" 'sctp vtag >='
hi link   nft_payload_expr_sctp_vtag_operator_2char nftHL_Expression
syn match nft_payload_expr_sctp_vtag_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_vtag,
\    nft_chainError

" 'sctp vtag'
hi link   nft_payload_expr_sctp_keyword_vtag nftHL_Keyword
syn match nft_payload_expr_sctp_keyword_vtag '\vvtag\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_vtag_operator_2char,
\    nft_payload_expr_sctp_vtag_keyword_in,
\    nft_payload_expr_sctp_vtag_operator_1char,
\    nft_payload_expr_sctp_vtag,
\    nft_payload_expr_named_set,
\    nft_chainError
" ************************* END sctp vtag' *************************

hi link   nft_payload_expr_sctp_hdr_expr_keyword_sctp nftHL_Statement
syn match nft_payload_expr_sctp_hdr_expr_keyword_sctp '\vsctp' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_keyword_checksum,
\    nft_payload_expr_sctp_keyword_dport,
\    nft_payload_expr_sctp_keyword_sport,
\    nft_payload_expr_sctp_keyword_vtag,
\    nft_chainError
" ************************* END  sctp' *************************



" ************************* Begin payload_expr esp_hdr_expr *********
"  esp: spi, sequence
" ************************* BEGIN  esp sequence' ****************
"  esp sequence
hi link   nft_payload_expr_esp_sequence_second nftHL_Integer
syn match nft_payload_expr_esp_sequence_second '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\n;]' contained
\ nextgroup=
\    nft_payload_expr_esp_keyword_spi,

hi link   nft_payload_expr_esp_sequence_dash_symbol nftHL_Expression
syn match nft_payload_expr_esp_sequence_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_esp_sequence_second,
\    nft_chainError

hi link   nft_payload_expr_esp_sequence nftHL_Integer
syn match nft_payload_expr_esp_sequence '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))' contained
\ nextgroup=
\    nft_payload_expr_esp_keyword_spi,
\    nft_payload_expr_esp_sequence_dash_symbol

"  esp sequence in { 1,127,255 }
hi link   nft_payload_expr_esp_inline_set_sequence nftHL_Integer
syn match nft_payload_expr_esp_inline_set_sequence '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\n,;\}]' contained

"  esp sequence in {  }
hi link    nft_payload_expr_esp_sequence_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_esp_sequence_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_esp_inline_set_sequence

"  esp sequence in
hi link   nft_payload_expr_esp_sequence_keyword_in nftHL_Keyword
syn match nft_payload_expr_esp_sequence_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_sequence_inline_set

"  esp sequence >
hi link   nft_payload_expr_esp_sequence_operator_1char nftHL_Expression
syn match nft_payload_expr_esp_sequence_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_sequence,
\    nft_chainError

"  esp sequence >=
hi link   nft_payload_expr_esp_sequence_operator_2char nftHL_Expression
syn match nft_payload_expr_esp_sequence_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_sequence,
\    nft_chainError

"  esp sequence
hi link   nft_payload_expr_esp_keyword_sequence nftHL_Keyword
syn match nft_payload_expr_esp_keyword_sequence '\vsequence\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_sequence_operator_2char,
\    nft_payload_expr_esp_sequence_keyword_in,
\    nft_payload_expr_esp_sequence_operator_1char,
\    nft_payload_expr_esp_sequence,
\    nft_payload_expr_named_set,
\    nft_chainError
" ************************* END  esp sequence' *************************

" ************************* BEGIN  esp spi' *************************
"  esp spi
hi link   nft_payload_expr_esp_spi_second nftHL_Integer
syn match nft_payload_expr_esp_spi_second '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_keyword_sequence,

hi link   nft_payload_expr_esp_spi_dash_symbol nftHL_Expression
syn match nft_payload_expr_esp_spi_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_esp_spi_second,
\    nft_chainError

hi link   nft_payload_expr_esp_spi nftHL_Integer
syn match nft_payload_expr_esp_spi '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))' contained
\ nextgroup=
\    nft_payload_expr_esp_keyword_sequence,
\    nft_payload_expr_esp_spi_dash_symbol,

"  esp spi in { 1,127,255 }
hi link   nft_payload_expr_esp_inline_set_spi nftHL_Integer
syn match nft_payload_expr_esp_inline_set_spi '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\n,;\}]' contained

"  esp spi in {  }
hi link    nft_payload_expr_esp_spi_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_esp_spi_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_esp_inline_set_spi,

"  esp spi >
hi link   nft_payload_expr_esp_spi_operator_1char nftHL_Expression
syn match nft_payload_expr_esp_spi_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_spi,
\    nft_chainError

"  esp spi >=
hi link   nft_payload_expr_esp_spi_operator_2char nftHL_Expression
syn match nft_payload_expr_esp_spi_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_spi,
\    nft_chainError

"  esp spi in
hi link   nft_payload_expr_esp_spi_keyword_in nftHL_Keyword
syn match nft_payload_expr_esp_spi_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_spi_inline_set

"  esp spi
hi link   nft_payload_expr_esp_keyword_spi nftHL_Keyword
syn match nft_payload_expr_esp_keyword_spi '\vspi' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_spi_operator_2char,
\    nft_payload_expr_esp_spi_keyword_in,
\    nft_payload_expr_esp_spi_operator_1char,
\    nft_payload_expr_esp_spi,
\    nft_payload_expr_named_set,
\    nft_chainError
" ************************* END  esp spi' *************************

hi link   nft_payload_expr_esp_hdr_expr_keyword_esp nftHL_Statement
syn match nft_payload_expr_esp_hdr_expr_keyword_esp '\vesp\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_keyword_sequence,
\    nft_payload_expr_esp_keyword_spi,
\    nft_chainError
" ************************* END  esp' *************************

" ************************* BEGIN  tcp' *************************
"  tcp: sport, dport, sequence, ackseq, doff, flags, window, checksum, urgptr
syn cluster nft_c_payload_expr_tcp_expressions
\ contains=
\    nft_payload_expr_tcp_keyword_sequence,
\    nft_payload_expr_tcp_keyword_ackseq,
\    nft_payload_expr_tcp_keyword_urgptr,
\    nft_payload_expr_tcp_keyword_window,
\    nft_payload_expr_tcp_keyword_dport,
\    nft_payload_expr_tcp_keyword_flags,
\    nft_payload_expr_tcp_keyword_sport,
\    nft_payload_expr_tcp_keyword_doff

hi link   nft_payload_expr_tcp_named_set nftHL_AtSetname
syn match nft_payload_expr_tcp_named_set '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

hi link   nft_payload_expr_primary_expr_symbol_expr nftHL_Variable
syn match nft_payload_expr_primary_expr_symbol_expr '\v[\$\@][a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

" ************************* BEGIN tcp checksum' *************************
"  tcp checksum in { 1,127,255 }
hi link   nft_payload_expr_tcp_inline_set_checksum nftHL_Integer
syn match nft_payload_expr_tcp_inline_set_checksum '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t,\}n]' skipwhite contained

"  tcp checksum in {  }
hi link    nft_payload_expr_tcp_checksum_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_checksum_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_inline_set_checksum
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

"  tcp checksum in
hi link   nft_payload_expr_tcp_checksum_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_checksum_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_checksum_inline_set

"  tcp checksum
hi link   nft_payload_expr_tcp_checksum_num2 nftHL_Integer
syn match nft_payload_expr_tcp_checksum_num2 '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

hi link   nft_payload_expr_tcp_checksum_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_checksum_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_checksum_num2,
\    nft_chainError

hi link   nft_payload_expr_tcp_checksum_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_checksum_num_or_range '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions,
\    nft_payload_expr_tcp_checksum_dash_symbol

"  tcp checksum >
hi link   nft_payload_expr_tcp_checksum_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_checksum_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_checksum_num_or_range,
\    nft_chainError

"  tcp checksum >=
hi link   nft_payload_expr_tcp_checksum_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_checksum_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_checksum_num_or_range,
\    nft_chainError

"  tcp checksum
hi link   nft_payload_expr_tcp_keyword_checksum nftHL_Keyword
syn match nft_payload_expr_tcp_keyword_checksum '\vchecksum\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_checksum_operator_2char,
\    nft_payload_expr_tcp_checksum_keyword_in,
\    nft_payload_expr_tcp_checksum_operator_1char,
\    nft_payload_expr_tcp_named_set,
\    nft_payload_expr_tcp_checksum_inline_set,
\    nft_payload_expr_tcp_checksum_num_or_range,
\    nft_chainError
" ************************* END  tcp checksum' *************************

" ************************* BEGIN  tcp sequence' *************************
"  tcp sequence in { 1,127,255 }
hi link   nft_payload_expr_tcp_inline_set_sequence nftHL_Integer
syn match nft_payload_expr_tcp_inline_set_sequence '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t,\}\n]' skipwhite contained

"  tcp sequence in {  }
hi link    nft_payload_expr_tcp_sequence_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_sequence_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_inline_set_sequence
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

"  tcp sequence in
hi link   nft_payload_expr_tcp_sequence_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_sequence_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_sequence_inline_set

hi link   nft_payload_expr_tcp_sequence_num2 nftHL_Integer
syn match nft_payload_expr_tcp_sequence_num2 '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

hi link   nft_payload_expr_tcp_sequence_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_sequence_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_sequence_num2,
\    nft_chainError

hi link   nft_payload_expr_tcp_sequence_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_sequence_num_or_range '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\-]' contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions,
\    nft_payload_expr_tcp_sequence_dash_symbol

"  tcp sequence >
hi link   nft_payload_expr_tcp_sequence_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_sequence_operator_1char '\v([\>\<\!])'  skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_sequence_num_or_range,
\    nft_chainError

"  tcp sequence >=
hi link   nft_payload_expr_tcp_sequence_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_sequence_operator_2char '\v([\>\<\!])\='  skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_sequence_num_or_range,
\    nft_chainError

"  tcp sequence
hi link   nft_payload_expr_tcp_keyword_sequence nftHL_Keyword
syn match nft_payload_expr_tcp_keyword_sequence '\vsequence\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_sequence_operator_2char,
\    nft_payload_expr_tcp_sequence_keyword_in,
\    nft_payload_expr_tcp_sequence_operator_1char,
\    nft_payload_expr_tcp_named_set,
\    nft_payload_expr_tcp_sequence_inline_set,
\    nft_payload_expr_tcp_sequence_num_or_range,
\    nft_chainError
" ************************* END  tcp sequence' *************************

" ************************* BEGIN  tcp ackseq' *************************
"  tcp ackseq in { 1,127,255 }
hi link   nft_payload_expr_tcp_inline_set_ackseq nftHL_Integer
syn match nft_payload_expr_tcp_inline_set_ackseq '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t,\}\n]' skipwhite contained

"  tcp ackseq in {  }
hi link    nft_payload_expr_tcp_ackseq_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_ackseq_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_inline_set_ackseq
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

"  tcp ackseq in
hi link   nft_payload_expr_tcp_ackseq_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_ackseq_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_ackseq_inline_set

hi link   nft_payload_expr_tcp_ackseq_num2 nftHL_Integer
syn match nft_payload_expr_tcp_ackseq_num2 '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

hi link   nft_payload_expr_tcp_ackseq_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_ackseq_dash_symbol '\v\-\ze[0-9]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_ackseq_num2,
\    nft_chainError

hi link   nft_payload_expr_tcp_ackseq_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_ackseq_num_or_range '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions,
\    nft_payload_expr_tcp_ackseq_dash_symbol

"  tcp ackseq >
hi link   nft_payload_expr_tcp_ackseq_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_ackseq_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_ackseq_num_or_range,
\    nft_chainError

"  tcp ackseq >=
hi link   nft_payload_expr_tcp_ackseq_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_ackseq_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_ackseq_num_or_range,
\    nft_chainError

"  tcp ackseq
hi link   nft_payload_expr_tcp_keyword_ackseq nftHL_Keyword
syn match nft_payload_expr_tcp_keyword_ackseq '\vackseq\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_ackseq_operator_2char,
\    nft_payload_expr_tcp_ackseq_keyword_in,
\    nft_payload_expr_tcp_ackseq_operator_1char,
\    nft_payload_expr_tcp_named_set,
\    nft_payload_expr_tcp_ackseq_inline_set,
\    nft_payload_expr_tcp_ackseq_num_or_range,
\    nft_chainError
" ************************* END  tcp ackseq' *************************

" ************************* BEGIN  tcp urgptr' *************************
"  tcp urgptr in { 1,127,255 }
hi link   nft_payload_expr_tcp_inline_set_urgptr nftHL_Integer
syn match nft_payload_expr_tcp_inline_set_urgptr '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  tcp urgptr in {  }
hi link    nft_payload_expr_tcp_urgptr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_urgptr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_inline_set_urgptr
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

"  tcp urgptr in
hi link   nft_payload_expr_tcp_urgptr_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_urgptr_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_urgptr_inline_set

hi link   nft_payload_expr_tcp_urgptr_num2 nftHL_Integer
syn match nft_payload_expr_tcp_urgptr_num2 '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

hi link   nft_payload_expr_tcp_urgptr_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_urgptr_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_urgptr_num2,
\    nft_chainError

"  tcp urgptr
hi link   nft_payload_expr_tcp_urgptr_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_urgptr_num_or_range '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\-]' contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions,
\    nft_payload_expr_tcp_urgptr_dash_symbol

"  tcp urgptr >
hi link   nft_payload_expr_tcp_urgptr_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_urgptr_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_urgptr_num_or_range,
\    nft_chainError

"  tcp urgptr >=
hi link   nft_payload_expr_tcp_urgptr_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_urgptr_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_urgptr_num_or_range,
\    nft_chainError

"  tcp urgptr
hi link   nft_payload_expr_tcp_keyword_urgptr nftHL_Keyword
syn match nft_payload_expr_tcp_keyword_urgptr '\vurgptr\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_urgptr_operator_2char,
\    nft_payload_expr_tcp_urgptr_keyword_in,
\    nft_payload_expr_tcp_urgptr_operator_1char,
\    nft_payload_expr_tcp_named_set,
\    nft_payload_expr_tcp_urgptr_inline_set,
\    nft_payload_expr_tcp_urgptr_num_or_range,
\    nft_chainError
" ************************* END  tcp urgptr' *************************

" ************************* BEGIN  tcp window' *************************
"  tcp window in { 1,127,255 }
hi link   nft_payload_expr_tcp_window_inline_set_num nftHL_Integer
syn match nft_payload_expr_tcp_window_inline_set_num '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  tcp window in {  }
hi link    nft_payload_expr_tcp_window_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_window_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_window_inline_set_num
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

"  tcp window in
hi link   nft_payload_expr_tcp_window_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_window_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_window_inline_set

hi link   nft_payload_expr_tcp_window_num2 nftHL_Integer
syn match nft_payload_expr_tcp_window_num2 '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

hi link   nft_payload_expr_tcp_window_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_window_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_window_num2,
\    nft_chainError

hi link   nft_payload_expr_tcp_window_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_window_num_or_range '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\-]' contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions,
\    nft_payload_expr_tcp_sequence_dash_symbol

"  tcp window >
hi link   nft_payload_expr_tcp_window_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_window_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_window_num_or_range,
\    nft_chainError

"  tcp window >=
hi link   nft_payload_expr_tcp_window_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_window_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_window_num_or_range,
\    nft_chainError

"  tcp window
hi link   nft_payload_expr_tcp_keyword_window nftHL_Keyword
syn match nft_payload_expr_tcp_keyword_window '\vwindow\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_window_operator_2char,
\    nft_payload_expr_tcp_window_keyword_in,
\    nft_payload_expr_tcp_window_operator_1char,
\    nft_payload_expr_tcp_named_set,
\    nft_payload_expr_tcp_window_inline_set,
\    nft_payload_expr_tcp_window_num_or_range,
\    nft_chainError
" ************************* END  tcp window' *************************

" ************************* BEGIN  tcp dport' *************************
"  tcp dport in { 1,127,255 }
hi link   nft_payload_expr_tcp_inline_set_dport nftHL_Integer
syn match nft_payload_expr_tcp_inline_set_dport '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  tcp dport in {  }
hi link    nft_payload_expr_tcp_dport_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_dport_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_inline_set_dport
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

"  tcp dport in
hi link   nft_payload_expr_tcp_dport_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_dport_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_dport_inline_set

hi link   nft_payload_expr_tcp_dport_num2 nftHL_Integer
syn match nft_payload_expr_tcp_dport_num2 '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

hi link   nft_payload_expr_tcp_dport_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_dport_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_dport_num2,
\    nft_chainError

hi link   nft_payload_expr_tcp_dport_enums nftHL_Define
syn match nft_payload_expr_tcp_dport_enums '\v(clc\-build\-daemon|kerberos\-master|afs3\-fileserver|zabbix\-trapper|passwd\-server|ms\-wbt\-server|gsigatekeeper|f5\-globalsite|dhcpv6\-server|dhcpv6\-client|afs3\-vlserver|afs3\-prserver|afs3\-kaserver|afs3\-callback|zabbix\-agent|moira\-update|microsoft\-ds|kerberos\-adm|iscsi\-target|gnutella\-svc|gnutella\-rtr|font\-service|xmpp\-server|xmpp\-client|submissions|sge\-qmaster|sa\-msg\-port|rpc2portmap|rmiregistry|radmin\-port|radius\-acct|ptp\-general|netbios\-ssn|netbios\-dgm|mysql\-proxy|ipsec\-nat\-t|datametrics|afs3\-volser|afs3\-update|afs3\-rmtsys|zephyr\-srv|zephyr\-clt|syslog\-tls|supfilesrv|supfiledbg|submission|rtcm\-sc104|postgresql|netbios\-ns|moira\-ureg|ingreslock|cvspserver|codasrv\-se|cmip\-agent|cisco\-sccp|bacula\-dir|afpovertcp|zephyr\-hm|snmp\-trap|sge\-execd|sane\-port|ptp\-event|lotusnote|kerberos4|groupwise|ftps\-data|f5\-iquery|dircproxy|codaauth2|clearcase|bacula\-sd|bacula\-fd|amidxtape|amandaidx|zope\-ftp|zebrasrv|venus\-se|sgi\-crsd|sgi\-cmsd|poppassd|ms\-sql\-s|ms\-sql\-m|moira\-db|krb\-prop|kerberos|iso\-tsap|http\-alt|ftp\-data|domain\-s|cmip\-man|cfengine|asf\-rmcp|afs3\-bos|acr\-nema|telnets|skkserv|sip\-tls|sgi\-gcd|sgi\-cad|printer|predict|pawserv|ospfapi|openvpn|omniorb|netstat|kpasswd|kamanda|hylafax|gsidcap|freeciv|discard|daytime|codasrv|chargen|xinetd|webmin|tproxy|telnet|tcpmux|tacacs|systat|sysrqd|syslog|svrloc|sunrpc|rmtcfg|ripngd|remctl|radius|puppet|proofd|ospf6d|kshell|klogin|kermit|isakmp|ircs\-u|gsiftp|gopher|gnunet|gds\-db|gdomap|finger|domain|distcc|db\-lsp|csync2|bootps|bootpc|amanda|zserv|zebra|z3950|xtelw|xmms2|xdmcp|x11\-7|x11\-6|x11\-5|x11\-4|x11\-3|x11\-2|x11\-1|whois|venus|tfido|suucp|spamd|socks|sieve|shell|rsync|rplay|route|rootd|redis|pop3s|ospfd|ntske|ntalk|nntps|mysql|munin|mailq|login|ldaps|isisd|iprop|imaps|imap2|icpv2|https|epmap|dicom|coaps|canna|binkp|babel|amqps|zope|xtel|wnn6|uucp|tinc|time|tftp|talk|snpp|snmp|smux|smtp|silc|saft|rtsp|rtmp|ripd|qotd|qmtp|qmqp|pop3|nsca|nrpe|nntp|mdns|ldap|isns|ircd|http|gris|gpsd|ftps|fido|exec|epmd|echo|dict|dcap|daap|coap|biff|bgpd|auth|amqp|zip|x11|who|svn|ssh|sip|nut|ntp|nqs|nfs|nbp|nbd|mtn|mon|ldp|l2f|ipx|ipp|iax|hkp|git|ftp|fsp|fax|bgp|bbs|asp)' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions,
\    nft_payload_expr_tcp_dport_dash_symbol

"   tcp dport
hi link   nft_payload_expr_tcp_dport_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_dport_num_or_range '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\-]' skipwhite contained

"  tcp dport >
hi link   nft_payload_expr_tcp_dport_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_dport_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_dport_num_or_range,
\    nft_chainError

"  tcp dport >=
hi link   nft_payload_expr_tcp_dport_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_dport_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_dport_num_or_range,
\    nft_chainError

" tcp dport map ...
hi link   nft_stmt_expr_map_stmt_expr_keyword_map nftHL_Write
syn match nft_stmt_expr_map_stmt_expr_keyword_map '\vmap' skipwhite contained
\ nextgroup=
\    @nft_c_map_expr_rhs_expr

"  tcp dport
hi link   nft_payload_expr_tcp_keyword_dport nftHL_Keyword
syn match nft_payload_expr_tcp_keyword_dport '\vdport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_dport_enums,
\    nft_stmt_expr_map_stmt_expr_keyword_map,
\    nft_payload_expr_tcp_dport_operator_2char,
\    nft_payload_expr_tcp_dport_keyword_in,
\    nft_payload_expr_tcp_dport_operator_1char,
\    nft_payload_expr_tcp_named_set,
\    nft_payload_expr_primary_expr_symbol_expr,
\    nft_payload_expr_tcp_dport_inline_set,
\    nft_payload_expr_tcp_dport_num_or_range,
\    nft_chainError
" ************************* END  tcp dport' *************************

" ************************* BEGIN  tcp flags' *************************
" flags: syn, ack, fin, rst, psh, urg, ecn, cwr or 0 to 0xFF.
"  tcp flags in { 1,127,255 }
hi link   nft_payload_expr_tcp_flags_inline_set_defines nftHL_Define
syn match nft_payload_expr_tcp_flags_inline_set_defines '\v(syn|ack|fin|rst|psh|urg|ecn|cwr)\ze[ \t,\}\n]'  skipwhite contained

hi link   nft_payload_expr_tcp_flags_inline_set_num nftHL_Integer
syn match nft_payload_expr_tcp_flags_inline_set_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t,\}\n]' skipwhite contained

"  tcp flags in {  }
hi link    nft_payload_expr_tcp_flags_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_flags_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_flags_inline_set_defines,
\    nft_payload_expr_tcp_flags_inline_set_num
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

"  tcp flags in
hi link   nft_payload_expr_tcp_flags_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_flags_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_flags_inline_set

hi link   nft_payload_expr_tcp_flags_num2 nftHL_Integer
syn match nft_payload_expr_tcp_flags_num2 '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

hi link   nft_payload_expr_tcp_flags_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_flags_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_flags_num2,
\    nft_chainError

hi link   nft_payload_expr_tcp_flags_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_flags_num_or_range '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t\-]'  skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions,
\    nft_payload_expr_tcp_sequence_dash_symbol

hi link   nft_payload_expr_tcp_flags_defines nftHL_Define
syn match nft_payload_expr_tcp_flags_defines '\v(syn|ack|fin|rst|psh|urg|ecn|cwr)\ze[ \t]'  contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

"  tcp flags >
hi link   nft_payload_expr_tcp_flags_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_flags_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_flags_defines,
\    nft_payload_expr_tcp_flags_num_or_range,
\    nft_chainError

"  tcp flags >=
hi link   nft_payload_expr_tcp_flags_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_flags_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_flags_defines,
\    nft_payload_expr_tcp_flags_num_or_range,
\    nft_chainError

hi link   nft_payload_expr_tcp_keyword_flags nftHL_Keyword
syn match nft_payload_expr_tcp_keyword_flags '\vflags\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_flags_defines,
\    nft_payload_expr_tcp_flags_operator_2char,
\    nft_payload_expr_tcp_flags_keyword_in,
\    nft_payload_expr_tcp_flags_operator_1char,
\    nft_payload_expr_tcp_named_set,
\    nft_payload_expr_tcp_flags_inline_set,
\    nft_payload_expr_tcp_flags_num_or_range,
\    nft_chainError
" ************************* END tcp flags' *************************

" ************************* BEGIN tcp sport' *************************
"  tcp sport in { 1,127,255 }
hi link   nft_payload_expr_tcp_inline_set_sport nftHL_Integer
syn match nft_payload_expr_tcp_inline_set_sport '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  tcp sport in {  }
hi link    nft_payload_expr_tcp_sport_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_sport_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_inline_set_sport
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

"  tcp sport in
hi link   nft_payload_expr_tcp_sport_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_sport_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_sport_inline_set

hi link   nft_payload_expr_tcp_sport_num2 nftHL_Integer
syn match nft_payload_expr_tcp_sport_num2 '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

hi link   nft_payload_expr_tcp_sport_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_sport_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_sport_num2,
\    nft_chainError

"   tcp sport
hi link   nft_payload_expr_tcp_sport_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_sport_num_or_range '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions,
\    nft_payload_expr_tcp_sport_dash_symbol,
\    @nft_c_primary_expr,

"  tcp sport >
hi link   nft_payload_expr_tcp_sport_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_sport_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_sport_num_or_range,
\    nft_chainError

"  tcp sport >=
hi link   nft_payload_expr_tcp_sport_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_sport_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_sport_num_or_range,
\    nft_chainError

"  tcp sport
hi link   nft_payload_expr_tcp_keyword_sport nftHL_Keyword
syn match nft_payload_expr_tcp_keyword_sport '\vsport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_sport_operator_2char,
\    nft_payload_expr_tcp_sport_keyword_in,
\    nft_payload_expr_tcp_sport_operator_1char,
\    nft_payload_expr_tcp_named_set,
\    nft_payload_expr_tcp_sport_inline_set,
\    nft_payload_expr_tcp_sport_num_or_range,
\    nft_chainError
" ************************* END tcp sport' *************************

" ************************* BEGIN  tcp doff' *************************
"  tcp doff in { 1,127,255 }
hi link   nft_payload_expr_tcp_inline_set_doff nftHL_Integer
syn match nft_payload_expr_tcp_inline_set_doff '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  tcp doff in {  }
hi link    nft_payload_expr_tcp_doff_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_doff_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_inline_set_doff
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

"  tcp doff in
hi link   nft_payload_expr_tcp_doff_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_doff_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_doff_inline_set

hi link   nft_payload_expr_tcp_doff_num2 nftHL_Integer
syn match nft_payload_expr_tcp_doff_num2 '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

hi link   nft_payload_expr_tcp_doff_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_doff_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_doff_num2,
\    nft_chainError

"   tcp doff
hi link   nft_payload_expr_tcp_doff_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_doff_num_or_range '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions,
\    nft_payload_expr_tcp_doff_dash_symbol

"  tcp doff >
hi link   nft_payload_expr_tcp_doff_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_doff_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_doff_num_or_range,
\    nft_chainError

"  tcp doff >=
hi link   nft_payload_expr_tcp_doff_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_doff_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_doff_num_or_range,
\    nft_chainError

"  tcp doff
hi link   nft_payload_expr_tcp_keyword_doff nftHL_Keyword
syn match nft_payload_expr_tcp_keyword_doff '\vdoff\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_doff_operator_2char,
\    nft_payload_expr_tcp_doff_keyword_in,
\    nft_payload_expr_tcp_doff_operator_1char,
\    nft_payload_expr_tcp_named_set,
\    nft_payload_expr_tcp_doff_inline_set,
\    nft_payload_expr_tcp_doff_num_or_range,
\    nft_chainError
" *************** End of payload_expr tcp_hdr_expr 'tcp doff' *************************

hi link   nft_payload_expr_tcp_hdr_expr_keyword_tcp nftHL_Statement
syn match nft_payload_expr_tcp_hdr_expr_keyword_tcp '\v[ \t]\zstcp' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_keyword_checksum,
\    nft_payload_expr_tcp_keyword_sequence,
\    nft_payload_expr_tcp_keyword_ackseq,
\    nft_payload_expr_tcp_keyword_urgptr,
\    nft_payload_expr_tcp_keyword_window,
\    nft_payload_expr_tcp_keyword_dport,
\    nft_payload_expr_tcp_keyword_flags,
\    nft_payload_expr_tcp_keyword_sport,
\    nft_payload_expr_tcp_keyword_doff,
\    nft_chainError
" *************** End of payload_expr tcp_hdr_expr 'tcp' *************************

" ************************* BEGIN  udp' *************************
"  udp: sport, dport, length, checksum
syn cluster nft_c_payload_expr_udp_expressions
\ contains=
\    nft_payload_expr_udp_keyword_checksum,
\    nft_payload_expr_udp_keyword_length,
\    nft_payload_expr_udp_keyword_dport,
\    nft_payload_expr_udp_keyword_sport

hi link   nft_payload_expr_udp_named_set nftHL_AtSetname
syn match nft_payload_expr_udp_named_set '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions

" ************************* BEGIN  udp checksum' *************************
"  udp checksum in { 1,127,255 }
hi link   nft_payload_expr_udp_checksum_inline_set_num nftHL_Integer
syn match nft_payload_expr_udp_checksum_inline_set_num '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  udp checksum in {  }
hi link    nft_payload_expr_udp_checksum_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_udp_checksum_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_udp_checksum_inline_set_num
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions

"  udp checksum in
hi link   nft_payload_expr_udp_checksum_keyword_in nftHL_Keyword
syn match nft_payload_expr_udp_checksum_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_checksum_inline_set

hi link   nft_payload_expr_udp_checksum_num2 nftHL_Integer
syn match nft_payload_expr_udp_checksum_num2 '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions

hi link   nft_payload_expr_udp_checksum_dash_symbol nftHL_Expression
syn match nft_payload_expr_udp_checksum_dash_symbol '\v\-\ze[0-9]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_checksum_num2,
\    nft_chainError

hi link   nft_payload_expr_udp_checksum_num_or_range nftHL_Integer
syn match nft_payload_expr_udp_checksum_num_or_range '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\-]' contained
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions,
\    nft_payload_expr_udp_checksum_dash_symbol

"  udp checksum >
hi link   nft_payload_expr_udp_checksum_operator_1char nftHL_Expression
syn match nft_payload_expr_udp_checksum_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_checksum_num_or_range,
\    nft_chainError

"  udp checksum >=
hi link   nft_payload_expr_udp_checksum_operator_2char nftHL_Expression
syn match nft_payload_expr_udp_checksum_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_checksum_num_or_range,
\    nft_chainError

"  udp checksum
hi link   nft_payload_expr_udp_keyword_checksum nftHL_Keyword
syn match nft_payload_expr_udp_keyword_checksum '\vchecksum\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_checksum_operator_2char,
\    nft_payload_expr_udp_checksum_keyword_in,
\    nft_payload_expr_udp_checksum_operator_1char,
\    nft_payload_expr_udp_checksum_inline_set,
\    nft_payload_expr_udp_checksum_num_or_range,
\    nft_payload_expr_udp_named_set,
\    nft_chainError
" ************************* END  udp checksum' *************************

" ************************* BEGIN  udp length' *************************
"  udp length in { 1,127,255 }
hi link   nft_payload_expr_udp_length_inline_set_num nftHL_Integer
syn match nft_payload_expr_udp_length_inline_set_num '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  udp length in {  }
hi link    nft_payload_expr_udp_length_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_udp_length_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_udp_length_inline_set_num
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions

"  udp length in
hi link   nft_payload_expr_udp_length_keyword_in nftHL_Keyword
syn match nft_payload_expr_udp_length_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_length_inline_set

"  udp length
hi link   nft_payload_expr_udp_length_num2 nftHL_Integer
syn match nft_payload_expr_udp_length_num2 '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions

hi link   nft_payload_expr_udp_length_dash_symbol nftHL_Expression
syn match nft_payload_expr_udp_length_dash_symbol '\v\-\ze[0-9]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_length_num2,
\    nft_chainError

hi link   nft_payload_expr_udp_length_num_or_range nftHL_Integer
syn match nft_payload_expr_udp_length_num_or_range '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\-]' contained
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions,
\    nft_payload_expr_udp_length_dash_symbol

"  udp length >
hi link   nft_payload_expr_udp_length_operator_1char nftHL_Expression
syn match nft_payload_expr_udp_length_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_length_num_or_range,
\    nft_chainError

"  udp length >=
hi link   nft_payload_expr_udp_length_operator_2char nftHL_Expression
syn match nft_payload_expr_udp_length_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_length_num_or_range,
\    nft_chainError

"  udp length
hi link   nft_payload_expr_udp_keyword_length nftHL_Keyword
syn match nft_payload_expr_udp_keyword_length '\vlength\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_length_operator_2char,
\    nft_payload_expr_udp_length_keyword_in,
\    nft_payload_expr_udp_length_operator_1char,
\    nft_payload_expr_udp_length_inline_set,
\    nft_payload_expr_udp_length_num_or_range,
\    nft_payload_expr_udp_named_set,
\    nft_chainError
" ************************* END  udp length' *************************

" ************************* BEGIN  udp dport' *************************
"  udp dport in { 1,127,255 }
hi link   nft_payload_expr_udp_dport_inline_set_num nftHL_Integer
syn match nft_payload_expr_udp_dport_inline_set_num '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  udp dport in {  }
hi link    nft_payload_expr_udp_dport_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_udp_dport_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_udp_dport_inline_set_num
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions

"  udp dport in
hi link   nft_payload_expr_udp_dport_keyword_in nftHL_Keyword
syn match nft_payload_expr_udp_dport_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_dport_inline_set

hi link   nft_payload_expr_udp_dport_num2 nftHL_Integer
syn match nft_payload_expr_udp_dport_num2 '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions

hi link   nft_payload_expr_udp_dport_dash_symbol nftHL_Expression
syn match nft_payload_expr_udp_dport_dash_symbol '\v\-\ze[0-9]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_dport_num2,
\    nft_chainError

"   udp dport
hi link   nft_payload_expr_udp_dport_num_or_range nftHL_Integer
syn match nft_payload_expr_udp_dport_num_or_range '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions,
\    nft_payload_expr_tcp_dport_dash_symbol

"  udp dport >
hi link   nft_payload_expr_udp_dport_operator_1char nftHL_Expression
syn match nft_payload_expr_udp_dport_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_dport_num_or_range,
\    nft_chainError

"  udp dport >=
hi link   nft_payload_expr_udp_dport_operator_2char nftHL_Expression
syn match nft_payload_expr_udp_dport_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_dport_num_or_range,
\    nft_chainError

"  udp dport
hi link   nft_payload_expr_udp_keyword_dport nftHL_Keyword
syn match nft_payload_expr_udp_keyword_dport '\vdport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_dport_operator_2char,
\    nft_payload_expr_udp_dport_keyword_in,
\    nft_payload_expr_udp_dport_operator_1char,
\    nft_payload_expr_udp_dport_inline_set,
\    nft_payload_expr_udp_dport_num_or_range,
\    nft_payload_expr_udp_named_set,
\    nft_chainError
" ************************* END udp dport' *************************

" ************************* BEGIN udp sport' *************************
"  udp sport in { 1,127,255 }
hi link   nft_payload_expr_udp_sport_inline_set_num nftHL_Integer
syn match nft_payload_expr_udp_sport_inline_set_num '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  udp sport in {  }
hi link    nft_payload_expr_udp_sport_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_udp_sport_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_udp_sport_inline_set_num
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions

"  udp sport in
hi link   nft_payload_expr_udp_sport_keyword_in nftHL_Keyword
syn match nft_payload_expr_udp_sport_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_sport_inline_set

hi link   nft_payload_expr_udp_sport_num2 nftHL_Integer
syn match nft_payload_expr_udp_sport_num2 '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions

hi link   nft_payload_expr_udp_sport_dash_symbol nftHL_Expression
syn match nft_payload_expr_udp_sport_dash_symbol '\v\-\ze[0-9]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_sport_num2,
\    nft_chainError

"   udp sport
hi link   nft_payload_expr_udp_sport_num_or_range nftHL_Integer
syn match nft_payload_expr_udp_sport_num_or_range '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions,
\    nft_payload_expr_tcp_sport_dash_symbol

"  udp sport >
hi link   nft_payload_expr_udp_sport_operator_1char nftHL_Expression
syn match nft_payload_expr_udp_sport_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_sport_num_or_range,
\    nft_chainError

"  udp sport >=
hi link   nft_payload_expr_udp_sport_operator_2char nftHL_Expression
syn match nft_payload_expr_udp_sport_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_sport_num_or_range,
\    nft_chainError

"  udp sport
hi link   nft_payload_expr_udp_keyword_sport nftHL_Keyword
syn match nft_payload_expr_udp_keyword_sport '\vsport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_sport_operator_2char,
\    nft_payload_expr_udp_sport_keyword_in,
\    nft_payload_expr_udp_sport_operator_1char,
\    nft_payload_expr_udp_sport_inline_set,
\    nft_payload_expr_udp_sport_num_or_range,
\    nft_payload_expr_udp_named_set,
\    nft_chainError
" ************************* END  udp sport' *************************

hi link   nft_payload_expr_udp_hdr_expr_keyword_udp nftHL_Statement
syn match nft_payload_expr_udp_hdr_expr_keyword_udp '\v[ \t]\zsudp' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_keyword_checksum,
\    nft_payload_expr_udp_keyword_length,
\    nft_payload_expr_udp_keyword_dport,
\    nft_payload_expr_udp_keyword_sport,
\    nft_chainError
" ************************* END  udp' *************************

" ************************* BEGIN  ah' *************************
"  ah: spi, sequence
hi link   nft_payload_expr_ah_hdr_expr_keyword_ah nftHL_Statement
syn match nft_payload_expr_ah_hdr_expr_keyword_ah '\vah\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_keyword_sequence,
\    nft_payload_expr_esp_keyword_spi,
\    nft_chainError
" ************************* END  ah' *************************

" ************************* BEGIN ip6 nexthdr' *************************
" WOW, duplicate this, rename w/o 'nexthdr',
" make it point to new one,
" then stick all of the originals back into the chain_block
" It is not a payload_stmt (has a required 'set' keyword)

" ip6 protocol: tcp, udp, icmpv6, sctp, dccp, esp, ah, hop-by-hop, dest, routing, fragment, no-next.
" Explicit form
" nexthdr = Protocol selector
" following identical keyword is begin of protocol expression"

" 'ip6 nexthdr 47'
hi link   nft_payload_expr_ip6_nexthdr_num nftHL_Integer
syn match nft_payload_expr_ip6_nexthdr_num '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))' skipwhite contained

" 'ip6 nexthdr <option-less-header>'
hi link   nft_payload_raw_expr_payload_base_spec_optionless_keywords nftHL_Define
syn match nft_payload_raw_expr_payload_base_spec_optionless_keywords '\v(ipv6-icmp|no\-next|icmpv6|dccp|sctp|esp|tcp|udp|ah)' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link    nft_payload_expr_ip6_nexthdr_set_block_delimiters nftHL_BlockDelimitersSet
syn region nft_payload_expr_ip6_nexthdr_set_block_delimiters start=+{+ end=+}+ skipwhite contained

" 'ip6 nexthdr' and their follow-on options
hi link   nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_nexthdr nftHL_Substatement
syn match nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_nexthdr '\vnexthdr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_keyword_hop_by_hop,
\    nft_payload_expr_ip6_nexthdr_keyword_fragment,
\    nft_payload_raw_expr_payload_base_spec_optionless_keywords,
\    nft_payload_expr_ip6_nexthdr_keyword_no_next,
\    nft_payload_expr_ip6_nexthdr_keyword_routing,
\    nft_payload_expr_ip6_nexthdr_keyword_dest,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_payload_expr_ip6_nexthdr_keyword_tcp,
\    nft_payload_expr_ip6_nexthdr_keyword_udp,
\    nft_payload_expr_ip6_nexthdr_keyword_ah,
\    nft_payload_expr_ip6_nexthdr_relational_expr_keyword_any,
\    nft_payload_expr_ip6_nexthdr_relational_expr_operator_prefix_keyword_not,
\    nft_payload_expr_ip6_nexthdr_relational_expr_operators_equality,
\    nft_payload_expr_ip6_nexthdr_relational_expr_set_operator_in,
\    nft_payload_expr_ip6_nexthdr_relational_expr_protocol_types,
\    nft_payload_expr_ip6_nexthdr_set_block_delimiters,
\    nft_payload_expr_ip6_nexthdr_num,
\    nft_Error_Quotes
" ************************* END ip6 nexthdr' *************************

" ************************* BEGIN ip6 version' *************************
" formerly nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_version
hi link   nft_payload_expr_ip6_version nftHL_Integer
syn match nft_payload_expr_ip6_version '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t\n;]' skipwhite contained

hi link   nft_payload_expr_ip6_keyword_version nftHL_Keyword
syn match nft_payload_expr_ip6_keyword_version '\vversion\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_version,
\    nft_Error
" ************************* END ip6 version' *************************

" ************************* BEGIN ip6 length' *************************
hi link   nft_payload_expr_ip6_length nftHL_Integer
syn match nft_payload_expr_ip6_length '\v((0x[0-9a-fA-F]{1,1})|([0-9]{1,1}))\ze[ \t\n;]' skipwhite contained

hi link   nft_payload_expr_ip6_keyword_length nftHL_Keyword
syn match nft_payload_expr_ip6_keyword_length '\vlength\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_length,
\    nft_Error
" ************************* END ip6 length' *************************

" ************************* BEGIN ip6 daddr' *************************
hi link   nft_payload_expr_ip6_addr nftHL_Integer
" Highlight group
hi link nft_payload_expr_ip6_addr nftHL_Integer

" IPv6 address patterns for nftables
" Simplistic static patterns
syn match nft_payload_expr_ip6_addr '\v::[0-9a-fA-F]{1,4}\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt
syn match nft_payload_expr_ip6_addr '\v::\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt
syn match nft_payload_expr_ip6_addr '\v[0-9a-fA-F]{1,4}::\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt
syn match nft_payload_expr_ip6_addr '\v::ffff:[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt

" Complex wildcardy patterns
syn match nft_payload_expr_ip6_addr '\v([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt
syn match nft_payload_expr_ip6_addr '\v::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){6}\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt
syn match nft_payload_expr_ip6_addr '\v([0-9a-fA-F]{1,4}:){1}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){5}\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt
syn match nft_payload_expr_ip6_addr '\v([0-9a-fA-F]{1,4}:){2}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){4}\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt
syn match nft_payload_expr_ip6_addr '\v([0-9a-fA-F]{1,4}:){3}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){3}\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt
syn match nft_payload_expr_ip6_addr '\v([0-9a-fA-F]{1,4}:){4}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){2}\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt
syn match nft_payload_expr_ip6_addr '\v([0-9a-fA-F]{1,4}:){5}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){1}\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt
syn match nft_payload_expr_ip6_addr '\v([0-9a-fA-F]{1,4}:){6}::[0-9a-fA-F]{1,4}\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt
syn match nft_payload_expr_ip6_addr '\v[0-9a-fA-F]{1,4}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){6}\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt

" Fallback for compressed IPv6
syn match nft_payload_expr_ip6_addr '\v[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){0,6}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){0,6}\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt

" IPv6/CIDR address patterns for nftables
" Simplistic static patterns
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_2 '\v::(\/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9])))?\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_3 '\v::[0-9a-fA-F]{1,4}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9])))?\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt,nft_Error

syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_1 '\v[0-9a-fA-F]{1,4}::(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9])))?\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_8h '\v::ffff:[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9])))?\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt

" Complex wildcardy patterns
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_8f '\v([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9])))?\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_2b6 '\v::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){6}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9])))?\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_4a1 '\v([0-9a-fA-F]{1,4}:){1}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){5}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9])))?\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_2a2 '\v([0-9a-fA-F]{1,4}:){2}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){4}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9])))?\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_2a3 '\v([0-9a-fA-F]{1,4}:){3}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){3}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9])))?\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_2a4 '\v([0-9a-fA-F]{1,4}:){4}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){2}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9])))?\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_2a5 '\v([0-9a-fA-F]{1,4}:){5}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){1}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9])))?\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_2a6 '\v([0-9a-fA-F]{1,4}:){6}::[0-9a-fA-F]{1,4}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9])))?\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_3a7 '\v[0-9a-fA-F]{1,4}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){6}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9])))?\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt

" Fallback for compressed IPv6
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_2x2 '\v[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){0,6}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){0,6}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9])))?\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt

syn cluster nft_c_payload_expr_ip6_addr_optional_cidr_suffix
\ contains=
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_8h,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_8f,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_4a1,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_3a7,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_3,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2b6,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2a2,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2a3,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2a4,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2a5,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2a6,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2x2,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_1,

hi link   nft_payload_expr_ip6_keyword_daddr nftHL_Keyword
syn match nft_payload_expr_ip6_keyword_daddr '\vdaddr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_map_stmt_keyword_vmap,
\    nft_close_scope_ip_primary_expr_constant_expr_at_setname,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_8h,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_8f,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_4a1,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_3a7,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_3,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2b6,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2a2,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2a3,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2a4,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2a5,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2a6,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2x2,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_1,
\    @nft_c_primary_stmt_expr,
\    @nft_c_map_expr_rhs_expr,
\    nft_stmt_expr_map_stmt_expr_keyword_map,
\    nft_Error

" ************************* END ip6 daddr' *************************

" ************************* BEGIN ip6 saddr' *************************

hi link   nft_payload_expr_ip6_keyword_saddr nftHL_Keyword
syn match nft_payload_expr_ip6_keyword_saddr '\vsaddr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_map_stmt_keyword_vmap,
\    nft_close_scope_ip_primary_expr_constant_expr_at_setname,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_8h,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_8f,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_4a1,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_3a7,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_3,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2b6,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2a2,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2a3,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2a4,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2a5,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2a6,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_2x2,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix_1,
\    @nft_c_primary_stmt_expr,
\    @nft_c_map_expr_rhs_expr,
\    nft_stmt_expr_map_stmt_expr_keyword_map,
\    nft_Error


" ************************* END ip6 saddr' *************************

" ************************* BEGIN ip6 dscp' *************************
hi link   nft_payload_expr_ip6_dscp nftHL_Integer
syn match nft_payload_expr_ip6_dscp '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t\n;]' skipwhite contained

hi link   nft_payload_expr_ip6_keyword_dscp nftHL_Keyword
syn match nft_payload_expr_ip6_keyword_dscp '\vdscp\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_dscp,
\    nft_Error
" ************************* END ip6 dscp' *************************

" ************************* Begin ip6_hdr_expr 'ip6 ecn' *************************
hi link   nft_payload_expr_ip6_ecn nftHL_Integer
syn match nft_payload_expr_ip6_ecn '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,10}))\ze[ \t\n;]' skipwhite contained

hi link   nft_payload_expr_ip6_keyword_ecn nftHL_Keyword
syn match nft_payload_expr_ip6_keyword_ecn '\vecn\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_ecn,
\    nft_Error
" ************************* End ip6_hdr_expr 'ip6 ecn' *************************

"*************** BEGIN th_hdr_expr *******************************
hi link   nft_th_hdr_expr_th_hdr_field_close_scope_th_port_at_setname nftHL_AtSetname
syn match nft_th_hdr_expr_th_hdr_field_close_scope_th_port_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t]' skipwhite contained

hi link    nft_th_hdr_expr_th_hdr_field_close_scope_th_port_inline_set nftHL_BlockDelimitersSet
syn region nft_th_hdr_expr_th_hdr_field_close_scope_th_port_inline_set start=+{+ end=+}+ skipwhite contained

hi link   nft_th_hdr_expr_th_hdr_field_keyword_dport nftHL_Keyword
syn match nft_th_hdr_expr_th_hdr_field_keyword_dport '\vdport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_map_stmt_keyword_vmap,
\    nft_th_hdr_expr_th_hdr_field_close_scope_th_port_at_setname,
\    nft_th_hdr_expr_th_hdr_field_close_scope_th_port_inline_set,

hi link   nft_th_hdr_expr_th_hdr_field_keyword_sport nftHL_Keyword
syn match nft_th_hdr_expr_th_hdr_field_keyword_sport '\vsport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_map_stmt_keyword_vmap,
\    nft_th_hdr_expr_th_hdr_field_close_scope_th_port_at_setname,
\    nft_th_hdr_expr_th_hdr_field_close_scope_th_port_inline_set,

hi link   nft_payload_expr_th_hdr_expr_keyword_th nftHL_Expression
syn match nft_payload_expr_th_hdr_expr_keyword_th '\v[ \t]\zsth\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_th_hdr_expr_th_hdr_field_keyword_dport,
\    nft_th_hdr_expr_th_hdr_field_keyword_sport
"*************** BEGIN th_hdr_expr *******************************

" payload_expr includes payload_raw_expr (done)
" payload_expr includes eth_hdr_expr (done)
" payload_expr includes vlan_hdr_expr (done)
" payload_expr includes arp_hdr_expr (done)
" payload_expr includes ip_hdr_expr (done)
" payload_expr includes icmp_hdr_expr
" payload_expr includes igmp_hdr_expr
" payload_expr includes ip6_hdr_expr
" payload_expr includes icmp6_hdr_expr
" payload_expr includes auth_hdr_expr
" payload_expr includes esp_hdr_expr
" payload_expr includes comp_hdr_expr
" payload_expr includes udp_hdr_expr
" payload_expr includes udplite_hdr_expr
" payload_expr includes tcp_hdr_expr
" payload_expr includes close_scope_tcp
" payload_expr includes dccp_hdr_expr
" payload_expr includes sctp_hdr_expr
" payload_expr includes th_hdr_expr
" payload_expr includes vxlan_hdr_expr
" payload_expr includes geneve_hdr_expr
" payload_expr includes gre_hdr_expr
" payload_expr includes gretap_hdr_expr
"
" All first-order, first-encountered keywords from all the semantic actions
" above are then placed inside 'contains=' in decreasing order of length of
" its lexical token then in least-to-most permissive regex order.

"*************** BEGIN payload_expr *******************************
syn cluster nft_c_payload_expr
\ contains=
\    nft_payload_expr_udplite_hdr_expr_keyword_udplite,
\    nft_payload_expr_geneve_hdr_expr_keyword_geneve,
\    nft_payload_expr_gretap_hdr_expr_keyword_gretap,
\    nft_payload_expr_icmp6_hdr_expr_icmp6_hdr_field_keyword_icmp6,
\    nft_stmt_declarative_keyword_ether,
\    nft_payload_expr_vxlan_hdr_expr_keyword_vxlan,
\    nft_payload_expr_auth_hdr_expr_keyword_auth,
\    nft_payload_expr_dccp_hdr_expr_keyword_dccp,
\    nft_payload_expr_comp_hdr_expr_keyword_comp,
\    nft_payload_expr_icmp_hdr_expr_keyword_icmp,
\    nft_payload_expr_igmp_hdr_expr_keyword_igmp,
\    nft_payload_expr_sctp_hdr_expr_keyword_sctp,
\    nft_keyword_expr_keyword_vlan,
\    nft_payload_raw_expr_payload_base_spec_keyword_at_ih,
\    nft_payload_raw_expr_payload_base_spec_keyword_at_ll,
\    nft_payload_raw_expr_payload_base_spec_keyword_at_nh,
\    nft_payload_raw_expr_payload_base_spec_keyword_at_th,
\    nft_keyword_expr_keyword_arp,
\    nft_payload_expr_esp_hdr_expr_keyword_esp,
\    nft_payload_expr_gre_hdr_expr_keyword_gre,
\    nft_payload_expr_ip6_hdr_expr_keyword_ip6,
\    nft_payload_expr_tcp_hdr_expr_keyword_tcp,
\    nft_payload_expr_udp_hdr_expr_keyword_udp,
\    nft_payload_expr_ip_hdr_expr_keyword_ip,
\    payload_expr_nft_rt_expr_keyword_rt,
\    nft_payload_expr_th_hdr_expr_keyword_th,
"*************** END payload_expr *******************************


"\    nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip_hdr_expr_named_set,
" ************************* END ip6_hdr_expr' *************************

hi link   nft_payload_expr_ip_protocol_keyword_dccp nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_dccp '\vdccp' skipwhite contained
hi link   nft_payload_expr_ip_protocol_keyword_icmp nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_icmp '\vicmp' skipwhite contained
hi link   nft_payload_expr_ip_protocol_keyword_igmp nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_igmp '\vigmp' skipwhite contained
hi link   nft_payload_expr_ip_protocol_keyword_ipip nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_ipip '\vipip' skipwhite contained
hi link   nft_payload_expr_ip_protocol_keyword_ipv6 nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_ipv6 '\vipv6' skipwhite contained
hi link   nft_payload_expr_ip_protocol_keyword_sctp nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_sctp '\vsctp' skipwhite contained
hi link   nft_payload_expr_ip_protocol_keyword_esp nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_esp '\vesp' skipwhite contained
hi link   nft_payload_expr_ip_protocol_keyword_gre nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_gre '\vgre' skipwhite contained
hi link   nft_payload_expr_ip_protocol_keyword_tcp nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_tcp '\vtcp' skipwhite contained
hi link   nft_payload_expr_ip_protocol_keyword_udp nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_udp '\vudp' skipwhite contained
hi link   nft_payload_expr_ip_protocol_keyword_ah nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_ah '\vah' skipwhite contained

hi link   nft_payload_expr_ip_protocol nftHL_Keyword
syn match nft_payload_expr_ip_protocol '\v(dccp|icmp|igmp|ipip|ipv6|sctp|esp|gre|tcp|udp|ah)' skipwhite contained

" NEED TO DUPLICATE in primary_stmt but without nextgroup='set'
" Add 'nextgroup=nft_payload_stmt_set' toward each here
" payload_expr (via payload_stmt, primary_expr, *primary_stmt_expr*)
syn cluster nft_c_payload_expr
\ contains=
\    nft_payload_raw_expr,
\    nft_eth_hdr_expr_keyword_ether,
\    nft_keyword_expr_keyword_vlan,
\    nft_keyword_expr_keyword_arp,
\    nft_ip_hdr_expr,
\    nft_icmp_hdr_expr,
\    nft_igmp_hdr_expr,
\    nft_ip6_hdr_expr,
\    nft_payload_expr_icmp6_hdr_expr_icmp6_hdr_field_keyword_icmp6,
\    nft_auth_hdr_expr,
\    nft_esp_hdr_expr,
\    nft_comp_hdr_expr,
\    nft_udp_hdr_expr,
\    nft_udplite_hdr_expr,
\    nft_tcp_hdr_expr,
\    nft_dccp_hdr_expr,
\    nft_sctp_hdr_expr,
\    nft_th_hdr_expr,
\    nft_vxlan_hdr_expr,
\    nft_geneve_hdr_expr,
\    nft_gre_hdr_expr,
\    nft_gretap_hdr_expr,
\    payload_expr_nft_rt_expr_keyword_rt,
" ************************* END payload_expr' *************************


  for s:this_semantic_file in s:payload_expr_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded payload_expr for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define payload_expr.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_payload_expr = v:true
