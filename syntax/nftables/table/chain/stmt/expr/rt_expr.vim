


hi link   nft_rt_expr_rt_key nftHL_Command
syn match nft_rt_expr_rt_key '\v(classid|nexthop|ipsec|mtu)\ze[ \t]' skipwhite contained

" ****************** BEGIN 'rt classid' ******************************
hi link   nft_rt_expr_rt_key_keyword_classid_close_scope_rt_constant_num nftHL_Integer
syn match nft_rt_expr_rt_key_keyword_classid_close_scope_rt_constant_num '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_rt_expr_rt_key_keyword_classid_close_scope_rt_relational_expr_relational_op_keyword_op_2char nftHL_Operator
syn match nft_rt_expr_rt_key_keyword_classid_close_scope_rt_relational_expr_relational_op_keyword_op_2char '\v(ne|gt|le|eq|lt|ge|\>\=|\<\=|\!\=|\=\=)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_expr_rt_key_keyword_classid_close_scope_rt_constant_num,
\    nft_Error

hi link   nft_rt_expr_rt_key_keyword_classid_close_scope_rt_relational_expr_relational_op_keyword_op_1char nftHL_Operator
syn match nft_rt_expr_rt_key_keyword_classid_close_scope_rt_relational_expr_relational_op_keyword_op_1char '\v(\!|\<|\>)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_expr_rt_key_keyword_classid_close_scope_rt_constant_num,
\    nft_Error

hi link   nft_rt_expr_rt_key_keyword_classid_close_scope_rt_inline_set nftHL_Define
syn match nft_rt_expr_rt_key_keyword_classid_close_scope_rt_inline_set '\v(0x([A-Fa-f0-9]{1,4})|6553[0-5]|655[0-2]\d|65[0-4]\d\d|6[0-4]\d\d\d|[1-5]\d{4}|\d{1,4})\ze[ \t\n,]' skipwhite contained

hi link    nft_rt_expr_rt_key_keyword_classid_close_scope_rt_set_expr_inline_set_delimiters nftHL_BlockDelimitersSet
syn region nft_rt_expr_rt_key_keyword_classid_close_scope_rt_set_expr_inline_set_delimiters start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_rt_expr_rt_key_keyword_classid_close_scope_rt_inline_set,
\    nft_Error
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_rt_expr_rt_key_keyword_classid_close_scope_rt_constant_expr_at_setname nftHL_AtSetname
syn match nft_rt_expr_rt_key_keyword_classid_close_scope_rt_constant_expr_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t]' skipwhite contained

hi link   nft_rt_expr_rt_key_keyword_classid_close_scope_rt_relational_expr_relational_op_keyword_in nftHL_Operator
syn match nft_rt_expr_rt_key_keyword_classid_close_scope_rt_relational_expr_relational_op_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_expr_rt_key_keyword_classid_close_scope_rt_constant_expr_at_setname,
\    nft_rt_expr_rt_key_keyword_classid_close_scope_rt_set_expr_inline_set_delimiters,
\    nft_Error

hi link   nft_rt_expr_rt_key_keyword_classid_close_scope_rt_relational_expr_relational_op_keyword_not nftHL_Operator
syn match nft_rt_expr_rt_key_keyword_classid_close_scope_rt_relational_expr_relational_op_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_expr_rt_key_keyword_classid_close_scope_rt_relational_expr_relational_op_keyword_in,
\    nft_rt_expr_rt_key_keyword_classid_close_scope_rt_constant_expr_at_setname,
\    nft_rt_expr_rt_key_keyword_classid_close_scope_rt_constant_num,
\    nft_Error

hi link   nft_rt_expr_rt_key_keyword_classid nftHL_Substatement
syn match nft_rt_expr_rt_key_keyword_classid '\vclassid\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_expr_rt_key_keyword_classid_close_scope_rt_relational_expr_relational_op_keyword_not,
\    nft_rt_expr_rt_key_keyword_classid_close_scope_rt_relational_expr_relational_op_keyword_op_2char,
\    nft_rt_expr_rt_key_keyword_classid_close_scope_rt_relational_expr_relational_op_keyword_in,
\    nft_rt_expr_rt_key_keyword_classid_close_scope_rt_relational_expr_relational_op_keyword_op_1char,
\    nft_rt_expr_rt_key_keyword_classid_close_scope_rt_set_expr_inline_set_delimiters,
\    nft_rt_expr_rt_key_keyword_classid_close_scope_rt_constant_expr_at_setname,
\    nft_rt_expr_rt_key_keyword_classid_close_scope_rt_constant_num,
\    nft_Error
" ****************** BEGIN 'rt classid' ******************************

" ****************** BEGIN 'rt nexthop' ******************************
hi link   nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_addr_with_cidr nftHL_Define
syn match nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_addr_with_cidr '\v(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|[0-9])\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|[0-9])\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|[0-9])\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|[0-9])(/(3[0-2]|[12]\d|\d)){0,1}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_relational_expr_relational_op_keyword_op_2char nftHL_Operator
syn match nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_relational_expr_relational_op_keyword_op_2char '\v(gt|ge|le|lt|eq|ne|\>\=|\<\=|\!\=|\=\=)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_addr_with_cidr,
\    nft_Error

hi link   nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_relational_expr_relational_op_keyword_op_1char nftHL_Operator
syn match nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_relational_expr_relational_op_keyword_op_1char '\v(\!|\<|\>)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_addr_with_cidr,
\    nft_Error

hi link   nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_inline_set_addr_with_cidr nftHL_Define
syn match nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_inline_set_addr_with_cidr '\v(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|[0-9])\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|[0-9])\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|[0-9])\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|[0-9])(/(3[0-2]|[12]\d|\d)){0,1}\ze[ \t]' skipwhite contained


hi link    nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_set_expr_inline_set_delimiters nftHL_BlockDelimitersSet
syn region nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_set_expr_inline_set_delimiters start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_inline_set_addr_with_cidr
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_constant_expr_at_setname nftHL_AtSetname
syn match nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_constant_expr_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t]' skipwhite contained

hi link   nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_relational_expr_relational_op_keyword_in nftHL_Operator
syn match nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_relational_expr_relational_op_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_constant_expr_at_setname,
\    nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_set_expr_inline_set_delimiters,
\    nft_Error

hi link   nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_relational_expr_relational_op_keyword_not nftHL_Operator
syn match nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_relational_expr_relational_op_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_relational_expr_relational_op_keyword_in,
\    nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_constant_expr_at_setname,
\    nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_addr_with_cidr,
\    nft_Error

hi link   nft_rt_expr_rt_key_keyword_nexthop nftHL_Substatement
syn match nft_rt_expr_rt_key_keyword_nexthop '\vnexthop\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_relational_expr_relational_op_keyword_not,
\    nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_relational_expr_relational_op_keyword_op_2char,
\    nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_relational_expr_relational_op_keyword_in,
\    nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_relational_expr_relational_op_keyword_op_1char,
\    nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_set_expr_inline_set_delimiters,
\    nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_constant_expr_at_setname,
\    nft_rt_expr_rt_key_keyword_nexthop_close_scope_rt_addr_with_cidr,
\    nft_Error
" ******************* END 'rt nexthop' *******************************

" ***************** BEGIN 'rt ipsec' *******************************
hi link   nft_rt_expr_rt_key_keyword_ipsec_close_scope_rt_boolean_expr nftHL_Define
syn match nft_rt_expr_rt_key_keyword_ipsec_close_scope_rt_boolean_expr '\v(missing|exists|0|1)\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_rt_expr_rt_key_keyword_ipsec_close_scope_rt_relational_expr_relational_op_keyword_not nftHL_Operator
syn match nft_rt_expr_rt_key_keyword_ipsec_close_scope_rt_relational_expr_relational_op_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_expr_rt_key_keyword_ipsec_close_scope_rt_boolean_expr

hi link   nft_rt_expr_rt_key_keyword_ipsec nftHL_Substatement
syn match nft_rt_expr_rt_key_keyword_ipsec '\vipsec\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_expr_rt_key_keyword_ipsec_close_scope_rt_boolean_expr,
\    nft_rt_expr_rt_key_keyword_ipsec_close_scope_rt_relational_expr_relational_op_keyword_not
" ******************* END 'rt ipsec' *******************************

" ***************** BEGIN 'rt mtu' *******************************
hi link   nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_constant_num nftHL_Define
syn match nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_constant_num '\v(0x([A-Fa-f0-9]{1,4})|6553[0-5]|655[0-2]\d|65[0-4]\d\d|6[0-4]\d\d\d|[1-5]\d{4}|\d{1,4})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_relational_expr_relational_op_keyword_op_2char nftHL_Operator
syn match nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_relational_expr_relational_op_keyword_op_2char '\v(eq|ne|lt|le|gt|ge|\>\=|\<\=|\!\=|\=\=)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_constant_num,
\    nft_Error

hi link   nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_relational_expr_relational_op_keyword_op_1char nftHL_Operator
syn match nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_relational_expr_relational_op_keyword_op_1char '\v(\!|\<|\>)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_constant_num,
\    nft_Error

hi link   nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_inline_set nftHL_Define
syn match nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_inline_set '\v(0x([A-Fa-f0-9]{1,4})|6553[0-5]|655[0-2]\d|65[0-4]\d\d|6[0-4]\d\d\d|[1-5]\d{4}|\d{1,4})\ze[ \t\n,]' skipwhite contained

hi link    nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_set_expr_inline_set_delimiters nftHL_BlockDelimitersSet
syn region nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_set_expr_inline_set_delimiters start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_inline_set,
\    nft_Error
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_constant_expr_at_setname nftHL_AtSetname
syn match nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_constant_expr_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t]' skipwhite contained

hi link   nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_relational_expr_relational_op_keyword_in nftHL_Operator
syn match nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_relational_expr_relational_op_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_constant_expr_at_setname,
\    nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_set_expr_inline_set_delimiters,
\    nft_Error

hi link   nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_relational_expr_relational_op_keyword_not nftHL_Operator
syn match nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_relational_expr_relational_op_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_relational_expr_relational_op_keyword_in,
\    nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_constant_expr_at_setname,
\    nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_constant_num,
\    nft_Error

hi link   nft_rt_expr_rt_key_keyword_mtu nftHL_Substatement
syn match nft_rt_expr_rt_key_keyword_mtu '\vmtu\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_relational_expr_relational_op_keyword_not,
\    nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_relational_expr_relational_op_keyword_op_2char,
\    nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_relational_expr_relational_op_keyword_in,
\    nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_relational_expr_relational_op_keyword_op_1char,
\    nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_set_expr_inline_set_delimiters,
\    nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_constant_expr_at_setname,
\    nft_rt_expr_rt_key_keyword_mtu_close_scope_rt_constant_num,
\    nft_Error
" ******************* END 'rt mtu' *******************************

hi link   nft_rt_expr_nf_key_proto_keyword_ip6 nftHL_Command
syn match nft_rt_expr_nf_key_proto_keyword_ip6 '\vip6\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_expr_rt_key_keyword_classid,
\    nft_rt_expr_rt_key_keyword_nexthop,
\    nft_rt_expr_rt_key_keyword_ipsec,
\    nft_rt_expr_rt_key_keyword_mtu

hi link   nft_rt_expr_nf_key_proto_keyword_ip nftHL_Command
syn match nft_rt_expr_nf_key_proto_keyword_ip '\vip\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_expr_rt_key_keyword_classid,
\    nft_rt_expr_rt_key_keyword_nexthop,
\    nft_rt_expr_rt_key_keyword_ipsec,
\    nft_rt_expr_rt_key_keyword_mtu


hi link   nft_rt_hdr_field_constant_expr_num_8b_hex nftHL_Integer
syn match nft_rt_hdr_field_constant_expr_num_8b_hex '\v(0x([A-Fa-f]\d|[A-Fa-f]{2}|[0-9A-Fa-f])|25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)\ze[ \t\n;]' skipwhite contained

hi link   nft_rt_hdr_field_constant_expr_enum_protocol_types nftHL_Define
syn match nft_rt_hdr_field_constant_expr_enum_protocol_types '\v(mobility\-header|mpls\-in\-ip|ipv6\-route|idpr\-cmtp|ipv6\-frag|ipv6\-icmp|ipv6\-nonxt|ipv6\-opts|ethernet|ipencap|iso\-tp4|udplite|xns\-idp|hopopt|ipcomp|ax\.25|eigrp|encap|manet|mptcp|shim6|dccp|icmp|idrp|igmp|ipv6|isis|l2tp|ospf|rohc|rspf|rsvp|sctp|skip|vrrp|vmtp|wesp|ddp|egp|esp|gre|hip|hmp|igp|ggp|pim|pup|rdp|tcp|udp|xtp|ah|fc|ip)\ze[ \t\n;]' skipwhite contained

hi link   nft_rt_hdr_field_constant_expr_string_inline_set_protocol_types nftHL_Define
syn match nft_rt_hdr_field_constant_expr_string_inline_set_protocol_types '\v(mobility\-header|mpls\-in\-ip|ipv6\-route|idpr\-cmtp|ipv6\-frag|ipv6\-icmp|ipv6\-nonxt|ipv6\-opts|ethernet|ipencap|iso\-tp4|udplite|xns\-idp|hopopt|ipcomp|ax\.25|eigrp|encap|manet|mptcp|shim6|dccp|icmp|idrp|igmp|ipv6|isis|l2tp|ospf|rohc|rspf|rsvp|sctp|skip|vrrp|vmtp|wesp|ddp|egp|esp|gre|hip|hmp|igp|ggp|pim|pup|rdp|tcp|udp|xtp|ah|fc|ip)\ze[ \t\n,]' skipwhite contained

hi link    nft_rt_hdr_field_constant_expr_string_inline_set_delimiters nftHL_BlockDelimiterSet
syn region nft_rt_hdr_field_constant_expr_string_inline_set_delimiters start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_rt_hdr_field_constant_expr_string_inline_set_protocol_types,
\    nft_rt_hdr_field_constant_expr_num_8b_hex,
\    nft_Error

hi link   nft_primary_expr_exthdr_expr_rt_hdr_expr_rt_hdr_field_keyword_hdrlength nftHL_Substatement
syn match nft_primary_expr_exthdr_expr_rt_hdr_expr_rt_hdr_field_keyword_hdrlength '\vhdrlength\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_hdr_field_constant_expr_num_8b_hex,
\    nft_Error

hi link   nft_primary_expr_exthdr_expr_rt_hdr_expr_rt_hdr_field_keyword_seg_left nftHL_Substatement
syn match nft_primary_expr_exthdr_expr_rt_hdr_expr_rt_hdr_field_keyword_seg_left '\vseg\-left\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_hdr_field_constant_expr_num_8b_hex,
\    nft_Error

hi link   nft_primary_expr_exthdr_expr_rt_hdr_expr_rt_hdr_field_keyword_nexthdr nftHL_Substatement
syn match nft_primary_expr_exthdr_expr_rt_hdr_expr_rt_hdr_field_keyword_nexthdr '\vnexthdr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_hdr_field_constant_expr_enum_protocol_types,
\    nft_rt_hdr_field_constant_expr_string_inline_set_delimiters,
\    nft_rt_hdr_field_constant_expr_num_8b_hex,
\    nft_Error

hi link   nft_rt_hdr_field_constant_expr_rt_types nftHL_Define
syn match nft_rt_hdr_field_constant_expr_rt_types '\v(rfc2460|type0|srh|rpl)\ze[ \t\n]' skipwhite contained

hi link   nft_primary_expr_exthdr_expr_rt_hdr_expr_rt_hdr_field_keyword_type nftHL_Substatement
syn match nft_primary_expr_exthdr_expr_rt_hdr_expr_rt_hdr_field_keyword_type '\vtype\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_hdr_field_constant_expr_rt_types,
\    nft_rt_hdr_field_constant_expr_num_8b_hex,
\    nft_Error



hi link   primary_expr_exthdr_expr_rt_hdr_expr_keyword_rt nftHL_Statement
syn match primary_expr_exthdr_expr_rt_hdr_expr_keyword_rt '\vrt\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_exthdr_expr_rt_hdr_expr_rt_hdr_field_keyword_hdrlength,
\    nft_primary_expr_exthdr_expr_rt_hdr_expr_rt_hdr_field_keyword_seg_left,
\    nft_primary_expr_exthdr_expr_rt_hdr_expr_rt_hdr_field_keyword_nexthdr,
\    nft_primary_expr_exthdr_expr_rt_hdr_expr_rt_hdr_field_keyword_type,
\    nft_Error

hi link   nft_payload_expr_nft_rt_expr_keyword_rt nftHL_Command
syn match nft_payload_expr_nft_rt_expr_keyword_rt '\v[ \t]zsrt\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_exthdr_expr_rt_hdr_expr_rt_hdr_field_keyword_hdrlength,
\    nft_rt_expr_rt_key_keyword_classid,
\    nft_primary_expr_exthdr_expr_rt_hdr_expr_rt_hdr_field_keyword_nexthdr,
\    nft_rt_expr_rt_key_keyword_nexthop,
\    nft_rt_expr_rt_key_keyword_ipsec,
\    nft_primary_expr_exthdr_expr_rt_hdr_expr_rt_hdr_field_keyword_seg_left,
\    nft_primary_expr_exthdr_expr_rt_hdr_expr_rt_hdr_field_keyword_type,
\    nft_rt_expr_nf_key_proto_keyword_ip6,
\    nft_rt_expr_rt_key_keyword_mtu,
\    nft_rt_expr_nf_key_proto_keyword_ip,
\    nft_Error

hi link   nft_stmt_keyword_rt nftHL_Command
syn match nft_stmt_keyword_rt '\vrt\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_exthdr_expr_rt_hdr_expr_rt_hdr_field_keyword_hdrlength,
\    nft_primary_expr_exthdr_expr_rt_hdr_expr_rt_hdr_field_keyword_seg_left,
\    nft_rt_expr_rt_key_keyword_classid,
\    nft_primary_expr_exthdr_expr_rt_hdr_expr_rt_hdr_field_keyword_nexthdr,
\    nft_rt_expr_rt_key_keyword_nexthop,
\    nft_rt_expr_rt_key_keyword_ipsec,
\    nft_primary_expr_exthdr_expr_rt_hdr_expr_rt_hdr_field_keyword_type,
\    nft_rt_expr_nf_key_proto_keyword_ip6,
\    nft_rt_expr_rt_key_keyword_mtu,
\    nft_rt_expr_nf_key_proto_keyword_ip,
\    nft_Error

hi link   nft_rt_expr_keyword_rt nftHL_Command
syn match nft_rt_expr_keyword_rt '\vrt\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_rt_expr_rt_key_keyword_classid,
\    nft_rt_expr_rt_key_keyword_nexthop,
\    nft_rt_expr_rt_key_keyword_ipsec,
\    nft_rt_expr_nf_key_proto_keyword_ip6,
\    nft_rt_expr_rt_key_keyword_mtu,
\    nft_rt_expr_nf_key_proto_keyword_ip,
\    nft_Error