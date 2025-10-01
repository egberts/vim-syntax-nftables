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

" 'meta' keyword is almost always followed by a value (except for 'random', 'nftrace', 'ipsec')
hi link   nft_route_class_id Define
syn match nft_route_class_id '\v[0-9]{1,10}\ze[ \t;]' skipwhite contained
hi link   nft_route_class_keyword_set nftHL_Write
syn match nft_route_class_keyword_set '\vset\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_route_class_id
hi link   nft_route_class_named_set Define
syn match nft_route_class_named_set '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}[\ze[ \t;]' skipwhite contained
hi link   nft_route_class_any nftHL_Operator
syn match nft_route_class_any '\vany\ze[ \t;]' skipwhite contained
hi link   nft_nf_protocol Define
syn match nft_nf_protocol '\v([0-9]{1,3})|(bridge|netdev|unspec|inet|arp|ip6|ip)\ze[ \t;]' skipwhite contained
hi link   nft_l4_protocol Define
syn match nft_l4_protocol '\v(([0-9]{1,3})|(mobility\-header|mpls\-in\-ip|ipv6\-route|idpr\-cmtp|ipv6\-frag|ipv6\-icmp|ipv6\-nonxt|ipv6\-opts|ethernet|ipencap|iso\-tp4|udplite|xns\-idp|hopopt|ipcomp|ax\.25|eigrp|encap|manet|mptcp|shim6|dccp|icmp|idrp|igmp|ipv6|isis|l2tp|ospf|rohc|rspf|rsvp|sctp|skip|vrrp|vmtp|wesp|ddp|egp|esp|gre|hip|hmp|igp|ggp|pim|pup|rdp|tcp|udp|xtp|ah|fc|ip))\ze[ \t;]' skipwhite contained

" *****
syntax match nft_meta_stmt_mark_missing '\v\ze[ \t]*[;\n]'  contained
hi link nft_meta_stmt_mark_missing nftHL_Error

hi link   nft_socket_t_integer nftHL_Integer
syn match nft_socket_t_integer '\v[0-9]{1,10}' skipwhite contained
syn match nft_socket_t_integer '\v0x[0-9a-f]{1,8}' skipwhite contained

hi link   nft_socket_t_operators_relational_1char nftHL_Operator
syn match nft_socket_t_operators_relational_1char '\v(\<|\>)' skipwhite contained
\ nextgroup=
\    nft_socket_t_integer, nft_Error
hi link   nft_socket_t_operators_relational_2char nftHL_Operator
syn match nft_socket_t_operators_relational_2char '\v(\<|\>)\=' skipwhite contained
\ nextgroup=
\    nft_socket_t_integer, nft_Error
hi link   nft_socket_t_operators_equality nftHL_Operator
syn match nft_socket_t_operators_equality '\v(\!|\=)\=' skipwhite contained
\ nextgroup=
\    nft_socket_t_integer,
\    nft_socket_t_named_set,
\    nft_socket_t_set_block,
\    nft_Error

hi link   nft_socket_t_integer_operand nftHL_Integer
syn match nft_socket_t_integer_operand '\v(0x)?[0-9a-f]{1,10}' skipwhite contained
\ nextgroup=
\    nft_socket_t_operators_relational_2char,
\    nft_socket_t_operators_equality,
\    nft_socket_t_operators_relational_1char

hi link   nft_socket_t_operator_mask nftHL_Operator
syn match nft_socket_t_operator_mask '\v\&' skipwhite contained
\ nextgroup=
\    nft_socket_t_integer_operand,
\    nft_Error
hi link   nft_socket_t_set_block_element_integer nftHL_Integer
syn match nft_socket_t_set_block_element_integer '\v[0-9]{1,10}' skipwhite contained
syn match nft_socket_t_set_block_element_integer '\v0x[0-9a-f]{1,8}' skipwhite contained
\ nextgroup=
\    nft_socket_t_set_block_element_separator,
\    nft_Error

hi link   nft_socket_t_set_block_element_separator nftHL_Separator
syn match nft_socket_t_set_block_element_separator /,/ skipwhite contained
\ nextgroup=
\    nft_socket_t_set_block_element_integer

hi link    nft_socket_t_set_block nftHL_BlockDelimitersSet
syn region nft_socket_t_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_socket_t_set_block_element_integer,
\    nft_Error

hi link   nft_socket_t_named_set nftHL_Set
syn match nft_socket_t_named_set '\v\@[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained


hi link   nft_socket_t_set_membership_keyword_in nftHL_Operator
syn match nft_socket_t_set_membership_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_socket_t_named_set,
\    nft_socket_t_set_block,
\    nft_Error

hi link   nft_socket_t_set_membership_keyword_not nftHL_Operator
syn match nft_socket_t_set_membership_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_socket_t_set_membership_keyword_in,
\    nft_Error

syn cluster nft_c_socket_t
\ contains=
\    nft_socket_t_set_membership_keyword_not,
\    nft_socket_t_set_membership_keyword_in,
\    nft_socket_t_operators_equality,
\    nft_socket_t_operators_relational_2char,
\    nft_socket_t_operator_mask,
\    nft_socket_t_operators_discrete_only_1char,
\    nft_socket_t_operators_relational_1char,
\    nft_socket_t_integer,
" *****

hi link   nft_packet_type Define
syn match nft_packet_type '\v(broadcast|multicast|unicast|other|host)\ze[ \t\n;]' skipnl skipwhite contained

hi link   nft_packet_type_keyword_set nftHL_Write
syn match nft_packet_type_keyword_set '\vset\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_packet_type,
\    nft_Error

hi link   nft_packet_type_operators_equality nftHL_Operator
syn match nft_packet_type_operators_equality '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_packet_type,
\    nft_Error

syn cluster nft_c_packet_type
\ contains=
\    nft_packet_type,
\    nft_packet_type_keyword_set,
\    nft_packet_type_operators_equality,

" *******
hi link   nft_packet_length_integer nftHL_Integer
syn match nft_packet_length_integer '\v0x[0-9a-fA-F]{1,8}\ze[ \t;]' skipwhite contained
syn match nft_packet_length_integer '\v[0-9]{1,10}\ze[ \t;]' skipwhite contained

hi link   nft_packet_length_set_block_member_separator nftHL_Integer
syn match nft_packet_length_set_block_member_separator /,/ skipwhite contained
\ nextgroup=
\    nft_packet_length_set_block_member_integer,
\    nft_Error

hi link   nft_packet_length_set_block_member_integer nftHL_Integer
syn match nft_packet_length_set_block_member_integer '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_packet_length_set_block_member_separator
syn match nft_packet_length_set_block_member_integer '\v0x[0-9a-fA-F]{1,8}' skipwhite contained
\ nextgroup=
\    nft_packet_length_set_block_member_separator

hi link    nft_packet_length_set_block nftHL_BlockDelimitersSet
syn region nft_packet_length_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_packet_length_set_block_member_integer

hi link   nft_packet_length_named_set_identifier nftHL_Set
syn match nft_packet_length_named_set_identifier '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_packet_length_operator_set_keyword_in nftHL_Operator
syn match nft_packet_length_operator_set_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_packet_length_set_block,
\    nft_packet_length_named_set_identifier,
\    nft_Error

hi link   nft_packet_length_operator_set_keyword_not nftHL_Operator
syn match nft_packet_length_operator_set_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_packet_length_operator_set_keyword_in

hi link   nft_packet_length_operators_relational_2char nftHL_Operator
syn match nft_packet_length_operators_relational_2char '\v(\<|\>)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_packet_length_named_set_identifier,
\    nft_packet_length_set_block,
\    nft_packet_length_integer,
\    nft_Error

hi link   nft_packet_length_operators_relational_1char nftHL_Operator
syn match nft_packet_length_operators_relational_1char '\v(\<|\>)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_packet_length_named_set_identifier,
\    nft_packet_length_set_block,
\    nft_packet_length_integer,
\    nft_Error

hi link   nft_packet_length_operators_equality nftHL_Operator
syn match nft_packet_length_operators_equality '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_packet_length_integer,
\    nft_Error

syn cluster nft_c_packet_length
\ contains=
\    nft_packet_length_operator_set_keyword_not,
\    nft_packet_length_operator_set_keyword_in,
\    nft_packet_length_operators_relational_2char,
\    nft_packet_length_operators_equality,
\    nft_packet_length_operators_relational_1char,
\    nft_packet_length_integer,

hi link   nft_cpu_index_integer nftHL_Integer
syn match nft_cpu_index_integer '\v[0-9]{1,5}\ze[ \t;]' skipwhite contained

hi link   nft_cpu_index_set_block_member_separator nftHL_Integer
syn match nft_cpu_index_set_block_member_separator /,/ skipwhite contained
\ nextgroup=
\    nft_cpu_index_set_block_member_integer,
\    nft_Error

hi link   nft_cpu_index_set_block_member_integer nftHL_Integer
syn match nft_cpu_index_set_block_member_integer '\v[0-9]{1,5}' skipwhite contained
\ nextgroup=
\    nft_cpu_index_set_block_member_separator

hi link    nft_cpu_index_set_block nftHL_BlockDelimitersSet
syn region nft_cpu_index_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_cpu_index_set_block_member_integer

hi link   nft_cpu_index_named_set_identifier nftHL_Set
syn match nft_cpu_index_named_set_identifier '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_cpu_index_operator_set_keyword_in nftHL_Operator
syn match nft_cpu_index_operator_set_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_cpu_index_set_block,
\    nft_cpu_index_named_set_identifier,
\    nft_Error

hi link   nft_cpu_index_operator_set_keyword_not nftHL_Operator
syn match nft_cpu_index_operator_set_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_cpu_index_operator_set_keyword_in

hi link   nft_cpu_index_operators_equality nftHL_Operator
syn match nft_cpu_index_operators_equality '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_cpu_index_named_set_identifier,
\    nft_cpu_index_set_block,
\    nft_cpu_index_integer,
\    nft_Error

syn cluster nft_c_cpu_index
\ contains=
\    nft_cpu_index_operator_set_keyword_not,
\    nft_cpu_index_operator_set_keyword_in,
\    nft_cpu_index_operators_equality,
\    nft_cpu_index_integer,

" ******
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

hi link   nft_ifgroup_index_named_set_identifier nftHL_Set
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

" ******
hi link   nft_time_type_integer nftHL_Integer
syn match nft_time_type_integer '\v[0-9]{1,10}\ze[ \t;]' skipwhite contained
syn match nft_time_type_integer '\v0x[0-9a-fA-F]{1,32}\ze[ \t;]' skipwhite contained

hi link   nft_time_type_set_block_member_separator nftHL_Separator
syn match nft_time_type_set_block_member_separator /,/ skipwhite contained
\ nextgroup=
\    nft_time_type_set_block_member_integer,
\    nft_Error

hi link   nft_time_type_set_block_member_integer nftHL_Integer
syn match nft_time_type_set_block_member_integer '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_time_type_set_block_member_separator
syn match nft_time_type_set_block_member_integer '\v0x[0-9a-fA-F]{1,8}' skipwhite contained
\ nextgroup=
\    nft_time_type_set_block_member_separator

hi link    nft_time_type_set_block nftHL_BlockDelimitersSet
syn region nft_time_type_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_time_type_set_block_member_integer

hi link   nft_time_type_named_set_identifier nftHL_Set
syn match nft_time_type_named_set_identifier '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_time_type_operator_set_keyword_in nftHL_Operator
syn match nft_time_type_operator_set_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_time_type_set_block,
\    nft_time_type_named_set_identifier,
\    nft_Error

hi link   nft_time_type_operator_set_keyword_not nftHL_Operator
syn match nft_time_type_operator_set_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_time_type_operator_set_keyword_in

hi link   nft_time_type_operators_relational_2char nftHL_Operator
syn match nft_time_type_operators_relational_2char '\v(\<|\>)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_time_type_integer,
\    nft_Error

hi link   nft_time_type_operators_relational_1char nftHL_Operator
syn match nft_time_type_operators_relational_1char '\v(\<|\>)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_time_type_integer,
\    nft_Error

hi link   nft_time_type_operators_equality nftHL_Operator
syn match nft_time_type_operators_equality '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_time_type_named_set_identifier,
\    nft_time_type_set_block,
\    nft_time_type_integer,
\    nft_Error

syn cluster nft_c_time_type
\ contains=
\    nft_time_type_operator_set_keyword_not,
\    nft_time_type_operator_set_keyword_in,
\    nft_time_type_operators_relational_2char,
\    nft_time_type_operators_equality,
\    nft_time_type_operators_relational_1char,
\    nft_time_type_integer,

" ******
hi link   nft_hour_type_integer nftHL_Integer
syn match nft_hour_type_integer '\v[0-9]{1,10}\ze[ \t;]' skipwhite contained
syn match nft_hour_type_integer '\v0x[0-9a-fA-F]{1,8}\ze[ \t;]' skipwhite contained

hi link   nft_hour_type_set_block_member_separator nftHL_Integer
syn match nft_hour_type_set_block_member_separator /,/ skipwhite contained
\ nextgroup=
\    nft_hour_type_set_block_member_integer,
\    nft_Error

hi link   nft_hour_type_set_block_member_integer nftHL_Integer
syn match nft_hour_type_set_block_member_integer '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_hour_type_set_block_member_separator
syn match nft_hour_type_set_block_member_integer '\v0x[0-9a-fA-F]{1,8}' skipwhite contained
\ nextgroup=
\    nft_hour_type_set_block_member_separator

hi link    nft_hour_type_set_block nftHL_BlockDelimitersSet
syn region nft_hour_type_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_hour_type_set_block_member_integer

hi link   nft_hour_type_named_set_identifier nftHL_Set
syn match nft_hour_type_named_set_identifier '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_hour_type_operator_set_keyword_in nftHL_Operator
syn match nft_hour_type_operator_set_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_hour_type_set_block,
\    nft_hour_type_named_set_identifier,
\    nft_Error

hi link   nft_hour_type_operator_set_keyword_not nftHL_Operator
syn match nft_hour_type_operator_set_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_hour_type_operator_set_keyword_in

hi link   nft_hour_type_operators_relational_2char nftHL_Operator
syn match nft_hour_type_operators_relational_2char '\v(\<|\>)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_hour_type_named_set_identifier,
\    nft_hour_type_set_block,
\    nft_hour_type_integer,
\    nft_Error

hi link   nft_hour_type_operators_relational_1char nftHL_Operator
syn match nft_hour_type_operators_relational_1char '\v(\<|\>)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_hour_type_named_set_identifier,
\    nft_hour_type_set_block,
\    nft_hour_type_integer,
\    nft_Error

hi link   nft_hour_type_operators_equality nftHL_Operator
syn match nft_hour_type_operators_equality '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_hour_type_integer,
\    nft_Error

syn cluster nft_c_hour_type
\ contains=
\    nft_hour_type_operator_set_keyword_not,
\    nft_hour_type_operator_set_keyword_in,
\    nft_hour_type_operators_relational_2char,
\    nft_hour_type_operators_equality,
\    nft_hour_type_operators_relational_1char,
\    nft_hour_type_integer,
" ******\"

hi link   nft_day_of_week_integer nftHL_Integer
syn match nft_day_of_week_integer '\v[0-6]{1}' skipwhite contained

hi link   nft_day_of_week_symbolic_constants Define
syn match nft_day_of_week_symbolic_constants '\v(Saturday|Wednesday|Thursday|Tuesday|Friday|Monday|Sunday)\ze[ \t;]' skipwhite contained

hi link   nft_day_of_week_set_block_element_separator nftHL_Separator
syn match nft_day_of_week_set_block_element_separator /,/ skipwhite contained
\ nextgroup=
\    nft_day_of_week_set_block_element_integer,
\    nft_day_of_week_set_block_element_symbolic_constants,
\    nft_Error

hi link   nft_day_of_week_set_block_element_integer nftHL_Integer
syn match nft_day_of_week_set_block_element_integer '\v[0-6]{1}' skipwhite contained
\ nextgroup=
\    nft_day_of_week_set_block_element_separator,

hi link   nft_day_of_week_set_block_element_symbolic_constants Define
syn match nft_day_of_week_set_block_element_symbolic_constants '\v(Saturday|Wednesday|Thursday|Tuesday|Friday|Monday|Sunday)\ze[ \t,]' skipwhite contained
\ nextgroup=
\    nft_day_of_week_set_block_element_separator,

hi link    nft_day_of_week_set_block nftHL_BlockDelimitersSet
syn region nft_day_of_week_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_day_of_week_set_block_element_symbolic_constants,
\    nft_day_of_week_set_block_element_integer,

hi link   nft_day_of_week_operator_set_keyword_in nftHL_Operator
syn match nft_day_of_week_operator_set_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_day_of_week_set_block,
\    nft_Error

hi link   nft_day_of_week_operator_set_keyword_not nftHL_Operator
syn match nft_day_of_week_operator_set_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_day_of_week_operator_set_keyword_in,
\    nft_Error

hi link   nft_day_of_week_operators_equality nftHL_Operator
syn match nft_day_of_week_operators_equality '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_day_of_week_symbolic_constants,
\    nft_day_of_week_integer,
\    nft_Error

hi link   nft_day_of_week_operators_equality nftHL_Operator
syn match nft_day_of_week_operators_equality '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_day_of_week_symbolic_constants,
\    nft_day_of_week_integer,
\    nft_Error

syn cluster nft_c_day_of_week
\ contains=
\    nft_day_of_week_symbolic_constants,
\    nft_day_of_week_operator_set_keyword_not,
\    nft_day_of_week_operator_set_keyword_in,
\    nft_day_of_week_operators_equality,
\    nft_day_of_week_integer,

hi link   nft_protocol_type_set_block_element_separator nftHL_Separator
syn match nft_protocol_type_set_block_element_separator /,/ skipwhite contained
\ nextgroup=
\    nft_protocol_type_set_block_element_protocol_types,
\    nft_protocol_type_set_block_element_protocol_number,
\    nft_Error

hi link   nft_protocol_type_set_block_element_protocol_number Define
syn match nft_protocol_type_set_block_element_protocol_number '\v[0-9]{1,5}' skipwhite contained
syn match nft_protocol_type_set_block_element_protocol_number '\v\c0x[0-9a-f]{1,4}' skipwhite contained
\ nextgroup= nft_protocol_type_set_block_element_separator, nft_Error

hi link   nft_protocol_type_set_block_element_protocol_types nftHL_Identifier
syn match nft_protocol_type_set_block_element_protocol_types '\v(8021ad|8021q|vlan|arp|ip6|ip)' skipwhite contained

hi link    nft_protocol_type_set_block nftHL_BlockDelimitersSet
syn region nft_protocol_type_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\     nft_protocol_type_set_block_element_protocol_identifier,
\     nft_protocol_type_set_block_element_protocol_types,
\     nft_protocol_type_set_block_element_protocol_number,
\     nft_Error
hi link   nft_protocol_type_set_identifier nftHL_Set
syn match nft_protocol_type_set_identifier '\v\@[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_protocol_type_number nftHL_Integer
syn match nft_protocol_type_number '\v\c0x[0-9a-fA-F]{1,4}\ze[ \t;]' skipwhite contained
syn match nft_protocol_type_number '\v[0-9]{1,5}\ze[ \t;]' skipwhite contained
hi link   nft_protocol_type_identifier nftHL_Define
syn match nft_protocol_type_identifier '\v(8021ad|8021q|vlan|arp|ip6|ip)' skipwhite contained
\ contains=nft_protocol_type_any
hi link   nft_protocol_type_any nftHL_Operator
syn match nft_protocol_type_any '\vany\ze[ \t;]' skipwhite contained

hi link   nft_protocol_type_operators nftHL_Operator
syn match nft_protocol_type_operators '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_protocol_type_identifier,
\    nft_protocol_type_set_block,
\    nft_protocol_type_set_identifier,
\    nft_protocol_type_number,
\    nft_Error
hi link   nft_protocol_type_operators_discrete nftHL_Operator
syn match nft_protocol_type_operators_discrete '\v(\<|\>)\=' skipwhite contained
\ nextgroup=
\    nft_protocol_type_number,
\    nft_Error
hi link   nft_protocol_type_set_operator_in nftHL_Operator
syn match nft_protocol_type_set_operator_in '\vin\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_protocol_type_set_identifier,
\    nft_protocol_type_set_block,
\    nft_Error
hi link   nft_protocol_type_keyword_any nftHL_Operator
syn match nft_protocol_type_keyword_any '\vany\ze[ \t;]' skipwhite contained

syn cluster nft_c_protocol_type
\ contains=
\    nft_protocol_type_keyword_any,
\    nft_protocol_type_operators_discrete,
\    nft_protocol_type_operators,
\    nft_protocol_type_set_operator_in,
\    nft_protocol_type_identifier,
\    nft_protocol_type_number,

hi link   nft_ethernet_protocol_type nftHL_Member

" 'meta iifgroup 42' value is set by 'ip link set dev eth0 group 42' CLI command
hi link   nft_interface_group_index nftHL_Integer
syn match nft_interface_group_index '\v(([0-9]{1,10})|(0x[0-9a-fA-F]{1,8}))\ze[ \t;]' skipwhite contained


hi link   nft_cpu_index_integer nftHL_Integer
syn match nft_cpu_index_integer '\v[0-9]{1,5}\ze[ \t;]' skipwhite contained

hi link   nft_cpu_index_set_block_member_separator nftHL_Separator
syn match nft_cpu_index_set_block_member_separator /,/ skipwhite contained
\ nextgroup=
\    nft_cpu_index_set_block_member_integer,
\    nft_Error

hi link   nft_cpu_index_set_block_member_integer nftHL_Integer
syn match nft_cpu_index_set_block_member_integer '\v[0-9]{1,5}' skipwhite contained
\ nextgroup=
\    nft_cpu_index_set_block_member_separator

hi link    nft_cpu_index_set_block nftHL_BlockDelimitersSet
syn region nft_cpu_index_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_cpu_index_set_block_member_integer

hi link   nft_cpu_index_named_set_identifier nftHL_Set
syn match nft_cpu_index_named_set_identifier '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_cpu_index_operator_set_keyword_in nftHL_Operator
syn match nft_cpu_index_operator_set_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_cpu_index_set_block,
\    nft_cpu_index_named_set_identifier,
\    nft_Error

hi link   nft_cpu_index_operator_set_keyword_not nftHL_Operator
syn match nft_cpu_index_operator_set_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_cpu_index_operator_set_keyword_in

hi link   nft_cpu_index_operators_relational_2char nftHL_Operator
syn match nft_cpu_index_operators_relational_2char '\v(\<|\>)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_cpu_index_integer,
\    nft_Error

hi link   nft_cpu_index_operators_relational_1char nftHL_Operator
syn match nft_cpu_index_operators_relational_1char '\v(\<|\>)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_cpu_index_integer,
\    nft_Error

hi link   nft_cpu_index_operators_equality nftHL_Operator
syn match nft_cpu_index_operators_equality '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_cpu_index_named_set_identifier,
\    nft_cpu_index_set_block,
\    nft_cpu_index_integer,
\    nft_Error

syn cluster nft_c_interface_group_index
\ contains=
\    nft_cpu_index_operator_set_keyword_not,
\    nft_cpu_index_operator_set_keyword_in,
\    nft_cpu_index_operators_relational_2char,
\    nft_cpu_index_operators_equality,
\    nft_cpu_index_operators_relational_1char,
\    nft_cpu_index_integer,

"******"
hi link   nft_cgroup_index nftHL_Integer
syn match nft_cgroup_index '\v(([0-9]{1,20})|(0x[0-9a-fA-F]{1,8}))\ze[ \t;]' skipwhite contained

hi link   nft_cgroup_index_integer nftHL_Integer
syn match nft_cgroup_index_integer '\v[0-9]{1,20}\ze[ \t;]' skipwhite contained
hi link   nft_cgroup_index_integer nftHL_Integer
syn match nft_cgroup_index_integer '\v0x\c[0-9a-f]{1,16}\ze[ \t;]' skipwhite contained

hi link   nft_cgroup_index_set_block_member_separator nftHL_Separator
syn match nft_cgroup_index_set_block_member_separator /,/ skipwhite contained
\ nextgroup=
\    nft_cgroup_index_set_block_member_integer,
\    nft_Error

hi link   nft_cgroup_index_set_block_member_integer nftHL_Integer
syn match nft_cgroup_index_set_block_member_integer '\v[0-9]{1,20}' skipwhite contained
\ nextgroup=
\    nft_cgroup_index_set_block_member_separator
syn match nft_cgroup_index_set_block_member_integer '\v0x[0-9a-f]{1,16}' skipwhite contained
\ nextgroup=
\    nft_cgroup_index_set_block_member_separator

hi link    nft_cgroup_index_set_block nftHL_BlockDelimitersSet
syn region nft_cgroup_index_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_cgroup_index_set_block_member_integer

hi link   nft_cgroup_index_named_set_identifier nftHL_Set
syn match nft_cgroup_index_named_set_identifier '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_cgroup_index_operator_set_keyword_in nftHL_Operator
syn match nft_cgroup_index_operator_set_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_cgroup_index_set_block,
\    nft_cgroup_index_named_set_identifier,
\    nft_Error

hi link   nft_cgroup_index_operator_set_keyword_not nftHL_Operator
syn match nft_cgroup_index_operator_set_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_cgroup_index_operator_set_keyword_in

hi link   nft_cgroup_index_operators_relational_2char nftHL_Operator
syn match nft_cgroup_index_operators_relational_2char '\v(\<|\>)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_cgroup_index_integer,
\    nft_Error

hi link   nft_cgroup_index_operators_relational_1char nftHL_Operator
syn match nft_cgroup_index_operators_relational_1char '\v(\<|\>)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_cgroup_index_integer,
\    nft_Error

hi link   nft_cgroup_index_operators_equality nftHL_Operator
syn match nft_cgroup_index_operators_equality '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_cgroup_index_named_set_identifier,
\    nft_cgroup_index_set_block,
\    nft_cgroup_index_integer,
\    nft_Error

syn cluster nft_c_cgroup_index
\ contains=
\    nft_cgroup_index_operator_set_keyword_not,
\    nft_cgroup_index_operator_set_keyword_in,
\    nft_cgroup_index_operators_relational_2char,
\    nft_cgroup_index_operators_equality,
\    nft_cgroup_index_operators_relational_1char,
\    nft_cgroup_index_integer,
"******"



hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_internal_qualified_keyword_nfproto_set nftHL_Write
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_internal_qualified_keyword_nfproto_set '\vset\ze[ \t]' skipwhite contained
\ nextgroup= nft_nf_protocol, nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_internal_qualified_keyword_nfproto_id nftHL_Integer
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_internal_qualified_keyword_nfproto_id '\v[0-9]{1,5}\ze[ \t;]' skipwhite contained

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_internal_qualified_keyword_nfproto_enum nftHL_Constant
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_internal_qualified_keyword_nfproto_enum '\v(bridge|netdev|inet|arp|ip6|ip)\ze[ \t;]' skipwhite contained

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_internal_qualified_keyword_nfproto nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_internal_qualified_keyword_nfproto '\vnfproto\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_internal_qualified_keyword_nfproto_enum,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_internal_qualified_keyword_nfproto_id,
\    nft_Error

" used to be 'l4proto', now it is 'protocol'?
hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_internal_qualified_keyword_l4proto nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_internal_qualified_keyword_l4proto '\vl4proto\ze[ \t]' skipwhite contained
\ nextgroup= nft_l4_protocol, nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_rtclassid nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_rtclassid '\vrtclassid\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_route_class_keyword_set,
\    nft_route_class_any,
\    nft_route_class_id,
\    nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ibriport nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ibriport '\vibriport\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_interface_name,
\    nft_Error

hi link   nft_meta_stmt_priority_keyword_none Define
syn match nft_meta_stmt_priority_keyword_none '\vnone\ze[ \t;]' skipwhite contained

hi link   nft_meta_stmt_priority_keyword_set nftHL_Write
syn match nft_meta_stmt_priority_keyword_set '\vset\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_priority_keyword_none,
\    nft_meta_stmt_priority_number

hi link   nft_meta_stmt_priority_set_block_element_separator nftHL_Separator
syn match nft_meta_stmt_priority_set_block_element_separator /,/ skipwhite contained
\ nextgroup=
\    nft_meta_stmt_priority_set_block_element_protocol_types,
\    nft_meta_stmt_priority_set_block_element_protocol_number,
\    nft_Error

hi link   nft_meta_stmt_priority_set_block_element_protocol_number Define
syn match nft_meta_stmt_priority_set_block_element_protocol_number '\v[0-9]{1,5}' skipwhite contained
syn match nft_meta_stmt_priority_set_block_element_protocol_number '\v\c0x[0-9a-f]{1,4}' skipwhite contained
\ nextgroup= nft_meta_stmt_priority_set_block_element_separator, nft_Error

hi link   nft_meta_stmt_priority_set_block_element_protocol_types nftHL_Identifier
syn match nft_meta_stmt_priority_set_block_element_protocol_types '\v(loopback|mpls_mc|mpls_uc|(802_1q)|pppoe|lldp|qinq|arp|ip6|ip)' skipwhite contained

hi link    nft_meta_stmt_priority_set_block nftHL_BlockDelimitersSet
syn region nft_meta_stmt_priority_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\     nft_meta_stmt_priority_set_block_element_protocol_identifier,
\     nft_meta_stmt_priority_set_block_element_protocol_types,
\     nft_meta_stmt_priority_set_block_element_protocol_number,
\     nft_Error

hi link   nft_meta_stmt_priority_number nftHL_Number
syn match nft_meta_stmt_priority_number '\v\c0x[0-9a-fA-F]{1,4}\ze[ \t;]' skipwhite contained
syn match nft_meta_stmt_priority_number '\v[0-9]{1,5}\ze[ \t;]' skipwhite contained

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
\    nft_meta_stmt_priority_number,
\    nft_Error
hi link   nft_meta_stmt_priority_operators_1char nftHL_Operator
syn match nft_meta_stmt_priority_operators_1char '\v(\<|\>)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_priority_identifier,
\    nft_meta_stmt_priority_set_block,
\    nft_meta_stmt_priority_set_identifier,
\    nft_meta_stmt_priority_number,
\    nft_Error
hi link   nft_meta_stmt_priority_operators_discrete nftHL_Operator
syn match nft_meta_stmt_priority_operators_discrete '\v(\<|\>)\=' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_priority_number,
\    nft_Error
hi link   nft_meta_stmt_priority_set_operator_in nftHL_Operator
syn match nft_meta_stmt_priority_set_operator_in '\vin\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_priority_set_identifier,
\    nft_meta_stmt_priority_set_block,
\    nft_Error


syn cluster nft_c_priority
\ contains=
\    nft_meta_stmt_priority_operators_discrete,
\    nft_meta_stmt_priority_keyword_none,
\    nft_meta_stmt_priority_keyword_set,
\    nft_meta_stmt_priority_operators_2char,
\    nft_meta_stmt_priority_set_operator_in,
\    nft_meta_stmt_priority_operators_1char,
\    nft_meta_stmt_priority_identifier,
\    nft_meta_stmt_priority_number,

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_priority nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_priority '\vpriority\ze[ \t]' skipwhite contained
\ nextgroup= @nft_c_priority,
\    nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_protocol nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_protocol '\vprotocol\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_protocol_type, nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oifname nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oifname '\voifname\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_variable_identifier,
\    @nft_c_interface_name,
\    nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iifgroup nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iifgroup '\viifgroup\ze[ \t]' skipwhite contained
\ nextgroup= @nft_c_ifgroup_index, nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_obriport nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_obriport '\vobriport\ze[ \t]' skipwhite contained
\ nextgroup= @nft_c_interface_name, nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oifgroup nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oifgroup '\voifgroup\ze[ \t]' skipwhite contained
\ nextgroup= @nft_c_ifgroup_index, nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_secmark nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_secmark '\vsecmark\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_secmark,
\    nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ibrname nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ibrname '\vibrname\ze[ \t]' skipwhite contained
\ nextgroup= @nft_c_interface_name, nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iifname nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iifname '\viifname\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_variable_identifier,
\    @nft_c_interface_name_or_wildcard,
\    nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iiftype nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iiftype '\viiftype\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_interface_type, nft_Error

" 'meta nftrace'
hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_value nftHL_Number
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_value '\v[0-1]{1}\ze[ \t;]' skipwhite contained
hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_comparison nftHL_Operator
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_comparison '\v(\<|\>|\!|\=)\=\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_value

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_set_elements nftHL_Set
syn region nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_set_elements start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_value
hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_set nftHL_Write
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_set '\vset\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_value,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_set_elements,
\    nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace '\vnftrace\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_set,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_value,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace_comparison,
\    nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_obrname nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_obrname '\vobrname\ze[ \t]' skipwhite contained
\ nextgroup= @nft_c_interface_name, nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oiftype nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oiftype '\voiftype\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_interface_type, nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_pkttype nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_pkttype '\vpkttype\ze[ \t\n]' skipnl skipwhite contained
\ nextgroup=
\    @nft_c_packet_type,

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_cgroup nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_cgroup '\vcgroup\ze[ \t]' skipwhite contained
\ nextgroup= @nft_c_cgroup_index, nft_Error

" 'meta random' has '0'/'1'

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_random_match nftHL_Integer
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_random_match '\v[0-9]{1,10}\ze[ \t;]' skipwhite contained

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_random_expr nftHL_Operator
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_random_expr '\v((\<)|(\>)|(\=)|(\!))\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_random_match

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_random_mod_divisor nftHL_Integer
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_random_mod_divisor '\v[0-9]{1,10}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_random_expr

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_random_mod nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_random_mod '\vmod\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_random_mod_divisor

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_set nftHL_Write
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_set '\vset\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_random_mod,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_random_expr,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_random_match

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_random nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_random '\vrandom\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_set,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_random_match

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_length nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_length '\vlength\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_packet_length, nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ipsec_integer nftHL_Integer
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ipsec_integer '\v[0-1]{1,1}\ze[ \t;]' skipwhite contained

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ipsec_operators_relational nftHL_Operator
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ipsec_operators_relational '\v((\<)|(\>)|(\=)|(\!))\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ipsec_integer

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ipsec_special_keywords Define
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ipsec_special_keywords '\v(missing|exists)\ze[ \t;]' skipwhite contained

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ipsec_named_set_identifier Identifier
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ipsec_named_set_identifier '\v\@[a-zA-Z][a-zA-Z0-9\-\_]{0,63}\ze[ \t;]' skipwhite contained

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ipsec_set_block_member_separator  nftHL_Separator
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ipsec_set_block_member_separator  /,/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ipsec_set_block_member_integer,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ipsec_set_block_member_special_keywords

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ipsec_set_block_member_integer nftHL_Integer
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ipsec_set_block_member_integer '\v[0-1]{1,1}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_block_member_separator

hi link    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_block nftHL_BlockDelimitersSet
syn region nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_block start='{' end='}' skipwhite contained
\ contains=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_block_member_special_keywords,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_block_member_integer,

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_block_member_special_keywords nftHL_Define
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_block_member_special_keywords '\v(missing|exists)\ze[ \t;]' skipwhite contained

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_operators_equality nftHL_Operator
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_operators_equality '\v((\=)|(\!))\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ipsec_special_keywords,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ipsec_named_set_identifier,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ipsec_set_block,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ipsec_integer

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_reqid_num nftHL_Integer
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_reqid_num '\v[0-9]{1,10}\ze[ \t]' skipwhite contained

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_keyword_reqid nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_keyword_reqid '\vreqid\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_reqid_num

" ***************** Begin 'ipsec spi num' ***************
hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_spi_num nftHL_Integer
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_spi_num '\v(([0-9]{1,10})|(0[xX][0-9a-fA-F]{1,8}))\ze[ \t]' skipwhite contained

" ipsec [in|out] spi"
hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_keyword_spi nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_keyword_spi '\vspi\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_spi_num
" ***************** End 'ipsec spi num' ***************

" ***************** End 'ipsec spnum num' ***************
" ipsec [in|out] spnum"
hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_keyword_spnum nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_keyword_spnum '\vspnum\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_spnum_num_or_range

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_named_set_identifier nftHL_Set
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_named_set_identifier '\v\@[a-zA-Z]a-zA-Z0-9]{0,63}' skipwhite contained
" ***************** End 'ipsec spnum num' ***************

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_directional_keyword_in nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_directional_keyword_in '\vin\ze[ \t\{]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_named_set_identifier,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_keyword_reqid,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_keyword_spnum,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_keyword_spi,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_block,
\    nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_directional_keyword_out nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_directional_keyword_out '\vout\ze[ \t\{]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_named_set_identifier,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_keyword_spnum,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_keyword_reqid,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_keyword_spi,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_block,
\    nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_keyword_not nftHL_Operator
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_keyword_not '\vnot\ze[ \t\{]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_keyword_out,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_keyword_spi,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_keyword_in,
\    nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_keyword_exclaimation nftHL_Operator
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_keyword_exclaimation '\v\!\ze[ \t\{]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_keyword_out,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_keyword_spi,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_ipsec_set_keyword_in,
\    nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_meta_meta_key_unqualified_ipsec_keyword_exists nftHL_Define
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_meta_meta_key_unqualified_ipsec_keyword_exists '\vexists' skipwhite contained

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_meta_meta_key_unqualified_ipsec_keyword_not nftHL_Expression
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_meta_meta_key_unqualified_ipsec_keyword_not '\vnot' skipwhite contained
\ nextgroup=nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_meta_meta_key_unqualified_ipsec_keyword_exists

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_meta_meta_key_unqualified_ipsec_keyword_exclaimation nftHL_Expression
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_meta_meta_key_unqualified_ipsec_keyword_exclaimation '\v\!' skipwhite contained
\ nextgroup=nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_meta_meta_key_unqualified_ipsec_keyword_exists

" LL(1) maintains distinction between 'meta ipsec' and 'ipsec'
" This here is 'ipsec' (no 'exists' keyword)
" There is no writable ipsec so meta_stmt is not supported here (strictly meta_expr)
" We use condensed 'primary_stmt/primary_stmt_expr' as an anchor for ipsec group name
"    (thereby skipping primary_stmt/concat_primary_expr/meta_expr/stmt_expr/concat_stmt_expr/basic_stmt_expr/exclusive_or_stmt_expr/and_stmt_expr/shift_stmt_expr/primary_stmt_expr/meta_expr)
" keyword_ipsec is split between:
"    - stmt/meta_stmt/stmt_expr and
"    - stmt/primary_stmt/concat_primary_expr/meta_expr/stmt_expr/concat_stmt_expr/basic_stmt_expr/exclusive_or_stmt_expr/and_stmt_expr/shift_stmt_expr/primary_stmt_expr/meta_expr
" The 'ipsec' part (without 'meta' keyword)
hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_ipsec nftHL_Expression
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_ipsec '\vipsec\ze[ \t]' skipwhite contained
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

" The 'meta ipsec' part
hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_meta_meta_key_unqualified_keyword_ipsec nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_meta_meta_key_unqualified_keyword_ipsec '\vipsec\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_meta_meta_key_unqualified_ipsec_keyword_exists,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_meta_meta_key_unqualified_ipsec_keyword_not,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_meta_meta_key_unqualified_ipsec_keyword_exclaimation,
\    nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_skuid nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_skuid '\vskuid\ze[ \t]' skipwhite contained
\ nextgroup= @nft_c_socket_t, nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_skgid nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_skgid '\vskgid\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_socket_t, nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_string nftHL_String
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_string '\v[a-zA-Z0-9_\-]+\ze[ \t;]{1,5}' contained
hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_at nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_at '\vat\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_string
hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_offload_add_keywords nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_offload_add_keywords '\v(offload|add)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_at
hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_flow nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_flow '\vflow\ze[ \t]' skipwhite contained
\ nextgroup=
\     nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_offload_add_keywords,
\     nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_at

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_hour nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_hour '\vhour\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_hour_type, nft_Error

syntax match nft_meta_stmt_mark_missing '\v\ze[ \t]*[;\n]'  contained
hi link nft_meta_stmt_mark_missing nftHL_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_integer nftHL_Integer
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_integer '\v[0-9]{1,10}' skipwhite contained
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_integer '\v0x[0-9a-f]{1,8}' skipwhite contained

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_named_set nftHL_Set
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

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_named_set nftHL_Set
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_named_set '\v\@[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_keyword_set nftHL_Write
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_keyword_set '\vset\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_named_set,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_integer,
\    nft_Error

syn cluster nft_c_mark
\ contains=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_keyword_set,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operators_equality,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operators_relational_2char,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operator_mask,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operators_discrete_only_1char,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operators_relational_1char,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_named_set,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_integer,

syn cluster nft_c_secmark
\ contains=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operators_equality,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operators_relational_2char,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operator_mask,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operators_discrete_only_1char,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_operators_relational_1char,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_mark_integer,

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_mark nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_mark '\vmark\ze[ \t]' skipnl skipwhite contained
\ nextgroup=
\    @nft_c_mark,
\    nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_time nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_time '\vtime\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_time_type, nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_cpu nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_cpu '\vcpu\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_cpu_index, nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_day nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_day '\vday\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_day_of_week, nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iif nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iif '\viif\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_device_index

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oif nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oif '\voif\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_device_index,
\    nft_Error

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_notrack nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_notrack '\vnotrack\ze(([ \t;])|($))' skipwhite contained

hi link   nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_meta nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_meta '\vmeta\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_rtclassid,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ibriport,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iifgroup,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_obriport,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oifgroup,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_priority,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_protocol,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ibrname,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iifname,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iiftype,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_internal_qualified_keyword_l4proto,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_internal_qualified_keyword_nfproto,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_notrack,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_obrname,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oifname,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oiftype,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_pkttype,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_secmark,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_cgroup,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_length,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_qualified_keyword_random,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_meta_meta_key_unqualified_keyword_ipsec,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_skgid,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_skuid,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_flow,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_hour,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_mark,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_time,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_cpu,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_day,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iif,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oif,
\    nft_rule_cluster_Error
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
