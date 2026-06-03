" File: icmp6_hdr_expr.vim
"
" Called by: payload_expr
" Called by: inner_inet_expr
" File: icmp6_hdr_expr.vim
" Directory: custom/nftables/
" The actual start of 'stmt' statements for starting 'icmpv6' token/keyword
"
"  The 'icmpv6' keyword is the focus here within this file
"  (and not the 'payload_expr' semantic action that it appears to emulate).
"
" Some overlays for 'icmpv6' keywords as the token opener of statements are:
"
"    - keyword_expr (simplest 'icmpv6')
"    - payload_stmt is a write and has a 'set' keyword
"    - primary_expr (includes payload_expr) is a read-only  ('icmpv6 protocol icmpv6')
"    - primary_stmt_expr is this run-on, add-ons of additional 'expr' for each 'stmt'
"    - concat_stmt_expr is this 'glueless' run-on of 'primary_stmt_expr' together.
"    - payload_stmt_expr is may be surrounded by parenthesis during 'glueless'
"          concat_stmt_expr chaining, e.g., 'icmpv6 protocol icmpv6 (icmpv6 type echo-request)'
"
" For expression, see 'icmpv6_expr.vim'
"
" stmt
" └── expr_stmt
"      └── expr
"           └── primary_expr
"                └── payload_expr
"                     └── icmp6_hdr_expr
"
"  By staying true to LL(1) (or keyword-centric, we avoid clashes by semantic actions)
"
" ✅ Predefined ICMPv6 type enums (nftables v1.1.4)
" Symbolic name	Type value	Description
" destination-unreachable	1	Destination Unreachable
" packet-too-big	2	Packet Too Big
" time-exceeded	3	Time Exceeded
" parameter-problem	4	Parameter Problem
" echo-request	128	Echo Request
" echo-reply	129	Echo Reply
" mld-listener-query	130	Multicast Listener Query
" mld-listener-report	131	Multicast Listener Report v1
" mld-listener-done	132	Multicast Listener Done
" router-solicitation	133	Router Solicitation
" router-advertisement	134	Router Advertisement
" neighbour-solicitation	135	Neighbor Solicitation
" neighbour-advertisement	136	Neighbor Advertisement
" redirect	137	Redirect Message
" router-renumbering	138	Router Renumbering
" ni-query	139	Node Information Query
" ni-reply	140	Node Information Reply
" mldv2-listener-report	143	Multicast Listener Report v2
" extended-echo-request	160	Extended Echo Request
" extended-echo-reply	161	Extended Echo Reply
"
" (Aliases like neighbor-* and neighbour-* are both accepted depending on nftables build options.)
"
" All values come from the Linux kernel headers (include/uapi/linux/icmpv6.h) and corresponding RFCs (4443, 4861, 8335, etc.).
"
" Type 1 — Destination Unreachable
" Symbolic name	Code	Meaning
" no-route	0	No route to destination
" admin-prohibited	1	Communication administratively prohibited
" beyond-scope	2	Beyond scope of source address
" address-unreachable	3	Address unreachable
" port-unreachable	4	Port unreachable
" policy-fail	5	Source address failed ingress/egress policy
" reject-route	6	Reject route to destination
" source-routing-failed	7	Error in Source Routing Header
"
"
let s:icmp6_hdr_expr_list_filepaths_semantic_early = []
let s:icmp6_hdr_expr_list_filepaths_semantic_later = []

if exists('b:did_nftables_icmp6_hdr_expr')
  call nftables#syntax#log('INFO', 'Skipped icmp6_hdr_expr (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:icmp6_hdr_expr_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading icmp6_hdr_expr syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
" ************************* BEGIN icmp6_hdr_expr ***********************
" Often prepended with 'ip6 nexthdr icmpv6'
" type, code, checksum, type-specific fields (e.g., id, sequence)
hi link   nft_icmpv6_named_set nftHL_AtSetname
syn match nft_icmpv6_named_set '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained

" ************ BEGIN icmp6_hdr_expr 'icmpv6 id' ****************
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_id_set_ref_symbol_expr_setname nftHL_AtSetname
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_id_set_ref_symbol_expr_setname "\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]" skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" ip6 nexthdr icmpv6 id in { 1,127,255 }
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_id_set_expr_integer_expr_num nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_id_set_expr_integer_expr_num '\v(0x([A-Fa-f0-9]{1,4}))|(6553[0-5])|(655[0-2][0-9])|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([1-5][0-9]{4})|([0-9]{1,4})\ze[ \t\n,\}]' skipwhite contained


" ip6 nexthdr icmpv6 id in {  }
hi link    nft_icmpv6_hdr_expr_close_scope_icmp6_id_set_expr nftHL_BlockDelimitersSet
syn region nft_icmpv6_hdr_expr_close_scope_icmp6_id_set_expr start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_id_set_expr_integer_expr_num
\ nextgroup=
\    @nft_c_icmpv6_expressions

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_id_integer_expr_num nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_id_integer_expr_num '\v(0x[A-Fa-f0-9]{1,4}|6553[0-5]|655[0-2][0-9]|65[0-4][0-9][0-9]|6[0-4][0-9][0-9][0-9]|[1-5][0-9]{4}|[0-9]{1,4})\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_icmpv6_expressions

" ip6 nexthdr icmpv6 id >
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_id_relational_expr_operator_1_char nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_id_relational_expr_operator_1_char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_id_integer_expr_num,
\    nft_chainError

" ip6 nexthdr icmpv6 id >=
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_id_relational_expr_operator_2_char nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_id_relational_expr_operator_2_char '\v([\=\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_id_integer_expr_num,
\    nft_chainError

" ip6 nexthdr icmpv6 id in
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_id_keyword_in nftHL_Keyword
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_id_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_id_set_expr,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_id_set_ref_symbol_expr_setname,
\    nft_Error

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_id_relational_expr_keyword_not nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_id_relational_expr_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_id_keyword_in,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_id_set_expr,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_id_integer_expr_num,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_id_set_ref_symbol_expr_setname,
\    nft_chainError

hi link   nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_id nftHL_Substatement
syn match nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_id '\vid\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_id_relational_expr_keyword_not,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_id_relational_expr_operator_2_char,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_id_keyword_in,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_id_relational_expr_operator_1_char,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_id_integer_expr_num,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_id_relational_expr_rhs_expr_set_ref_symbol_expr_keyword_at,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_id_set_expr,
\    nft_chainError
" ************ END icmp6_hdr_expr 'icmpv6 id' ****************

" ************ BEGIN icmp6_hdr_expr 'icmpv6 mtu' ****************
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_set_ref_symbol_expr_setname nftHL_AtSetname
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_set_ref_symbol_expr_setname "\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]" skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" ip6 nexthdr icmpv6 mtu in { 1,127,255 }
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_set_integer_expr_num nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_set_integer_expr_num '\v(0x[0-9A-Fa-f]{1,8}|(429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}))\ze[ \t\n,\}]' skipwhite contained

" ip6 nexthdr icmpv6 mtu in {  }
hi link    nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_set_expr nftHL_BlockDelimitersSet
syn region nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_set_expr start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_set_integer_expr_num
\ nextgroup=
\    @nft_c_icmpv6_expressions

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_integer_expr_num nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_integer_expr_num '\v(0x[0-9A-Fa-f]{1,8}|(429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}))\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_icmpv6_expressions

" ip6 nexthdr icmpv6 mtu >
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_relational_expr_operator_1_char nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_relational_expr_operator_1_char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_integer_expr_num,
\    nft_chainError

" ip6 nexthdr icmpv6 mtu >=
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_relational_expr_operator_2_char nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_relational_expr_operator_2_char '\v([\=\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_integer_expr_num,
\    nft_chainError

" ip6 nexthdr icmpv6 mtu in
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_keyword_in nftHL_Keyword
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_set_expr,
\    nft_Error

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_relational_expr_keyword_not nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_relational_expr_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_keyword_in,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_set_expr,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_integer_expr_num,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_set_ref_symbol_expr_setname,
\    nft_chainError

hi link   nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_mtu nftHL_Substatement
syn match nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_mtu '\vmtu\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_relational_expr_keyword_not,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_relational_expr_operator_2_char,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_keyword_in,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_relational_expr_operator_1_char,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_integer_expr_num,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_relational_expr_rhs_expr_set_ref_symbol_expr_keyword_at,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_mtu_set_expr,
\    nft_chainError
" ************ END icmp6_hdr_expr 'icmpv6 mtu' ****************

" ************ BEGIN icmp6_hdr_expr 'icmpv6 code' ****************
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_code_set_ref_symbol_expr_setname nftHL_AtSetname
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_code_set_ref_symbol_expr_setname "\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]" skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" ip6 nexthdr icmpv6 code in { 1,127,255 }
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_code_set_expr_integer_expr_num nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_code_set_expr_integer_expr_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t\n,\}]' skipwhite contained

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_code_set_symbol_expr_string nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_code_set_symbol_expr_string '\v(frag\-reassembly\-time\-exceeded|source\-routing\-failed|address\-unreachable|no\-such\-table\-entry|multiple\-interfaces|no\-such\-interface|admin\-prohibited|port\-unreachable|malformed\-query|beyond\-scope|reject\-route|policy\-fail|hop\-limit\-exceeded|next\-header|ipv6\-query|ipv4\-query|name\-query|hdr\-field|no\-error|no\-route|option|no\-op|ipv4|zero)\ze[ \t\n\;]' skipwhite contained
\ nextgroup=
\    @nft_c_icmpv6_expressions

" ip6 nexthdr icmpv6 code in {  }
hi link    nft_icmpv6_hdr_expr_close_scope_icmp6_code_set_expr nftHL_BlockDelimitersSet
syn region nft_icmpv6_hdr_expr_close_scope_icmp6_code_set_expr start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_code_set_symbol_expr_string,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_code_set_expr_integer_expr_num
\ nextgroup=
\    @nft_c_icmpv6_expressions

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_code_integer_expr_num nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_code_integer_expr_num '\v(0x([A-Fa-f][0-9]|[A-Fa-f]{2}|[0-9A-Fa-f])|25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_icmpv6_expressions

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_code_symbol_expr_string nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_code_symbol_expr_string '\v(frag\-reassembly\-time\-exceeded|source\-routing\-failed|address\-unreachable|no\-such\-table\-entry|multiple\-interfaces|no\-such\-interface|admin\-prohibited|port\-unreachable|malformed\-query|beyond\-scope|reject\-route|policy\-fail|hop\-limit\-exceeded|next\-header|ipv6\-query|ipv4\-query|name\-query|hdr\-field|no\-error|no\-route|option|no\-op|ipv4|zero)\ze[ \t\n\;]' skipwhite contained
\ nextgroup=
\    @nft_c_icmpv6_expressions

" ip6 nexthdr icmpv6 code >
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_code_relational_expr_operator_1_char nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_code_relational_expr_operator_1_char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_code_symbol_expr_string,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_code_integer_expr_num,
\    nft_chainError

" ip6 nexthdr icmpv6 code >=
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_code_relational_expr_operator_2_char nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_code_relational_expr_operator_2_char '\v([\=\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_code_symbol_expr_string,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_code_integer_expr_num,
\    nft_chainError

" ip6 nexthdr icmpv6 code in
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_code_keyword_in nftHL_Keyword
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_code_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_code_set_expr,
\    nft_Error

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_code_relational_expr_keyword_not nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_code_relational_expr_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_code_symbol_expr_string,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_code_keyword_in,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_code_set_expr,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_code_integer_expr_num,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_code_set_ref_symbol_expr_setname,
\    nft_chainError

hi link   nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_code nftHL_Substatement
syn match nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_code '\vcode\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_code_symbol_expr_string,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_code_relational_expr_keyword_not,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_code_relational_expr_operator_2_char,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_code_keyword_in,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_code_relational_expr_operator_1_char,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_code_integer_expr_num,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_code_relational_expr_rhs_expr_set_ref_symbol_expr_keyword_at,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_code_set_expr,
\    nft_chainError
" ************ END icmp6_hdr_expr 'icmpv6 code' ****************

" ************ BEGIN icmp6_hdr_expr 'icmpv6 type' ****************
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_type_set_ref_symbol_expr_setname nftHL_AtSetname
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_type_set_ref_symbol_expr_setname "\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]" skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" ip6 nexthdr icmpv6 type in { 1,127,255 }
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_type_set_expr_integer_expr_num nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_type_set_expr_integer_expr_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t\n,\}]' skipwhite contained

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_type_set_symbol_expr nftHL_Define
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_type_set_symbol_expr '\v(destination\-unreachable|neighbour\-advertisement|neighbor\-advertisement|neighbour\-solicitation|neighbor\-solicitation|mldv2\-listener\-report|extended\-echo\-request|router\-advertisement|extended\-echo\-reply|mld\-listener\-report|nd\-neighbor\-solicit|router\-solicitation|nd\-neighbor\-advert|router\-renumbering|mld\-listener\-query|mld\-listener\-done|parameter\-problem|nd\-router\-advert|packet\-too\-big|time\-exceeded|echo\-request|echo\-reply|ni\-query|ni\-reply|redirect)\ze[ \t\n,\}]' skipwhite contained

" ip6 nexthdr icmpv6 type in {  }
hi link    nft_icmpv6_hdr_expr_close_scope_icmp6_type_set_expr nftHL_BlockDelimitersSet
syn region nft_icmpv6_hdr_expr_close_scope_icmp6_type_set_expr start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_set_symbol_expr,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_set_expr_integer_expr_num
\ nextgroup=
\    @nft_c_icmpv6_expressions,
\    @nft_c_stmt

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_type_integer_expr_num nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_type_integer_expr_num '\v(0x([A-Fa-f][0-9]|[A-Fa-f]{2}|[0-9A-Fa-f])|25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_icmpv6_expressions

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_type_symbol_expr_string nftHL_Define
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_type_symbol_expr_string '\v(destination\-unreachable|neighbour\-advertisement|neighbor\-advertisement|neighbour\-solicitation|neighbor\-solicitation|mldv2\-listener\-report|extended\-echo\-request|router\-advertisement|extended\-echo\-reply|mld\-listener\-report|router\-solicitation|router\-renumbering|mld\-listener\-query|mld\-listener\-done|parameter\-problem|packet\-too\-big|time\-exceeded|echo\-request|echo\-reply|ni\-query|ni\-reply|redirect)\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_icmpv6_expressions,
\    @nft_c_stmt

" ip6 nexthdr icmpv6 type >
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_type_relational_expr_operator_1_char nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_type_relational_expr_operator_1_char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_symbol_expr_string,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_integer_expr_num,
\    nft_chainError

" ip6 nexthdr icmpv6 type >=
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_type_relational_expr_operator_2_char nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_type_relational_expr_operator_2_char '\v([\=\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_symbol_expr_string,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_integer_expr_num,
\    nft_chainError

" ip6 nexthdr icmpv6 type in
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_type_keyword_in nftHL_Keyword
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_type_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_symbol_expr_string,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_set_ref_symbol_expr_setname,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_set_expr,
\    nft_Error

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_type_relational_expr_keyword_not nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_type_relational_expr_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_symbol_expr_string,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_keyword_in,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_set_expr,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_integer_expr_num,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_set_ref_symbol_expr_setname,
\    nft_chainError

hi link   nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_type nftHL_Substatement
syn match nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_type '\vtype\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_symbol_expr_string,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_relational_expr_keyword_not,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_relational_expr_operator_2_char,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_keyword_in,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_relational_expr_operator_1_char,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_integer_expr_num,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_relational_expr_rhs_expr_set_ref_symbol_expr_keyword_at,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_type_set_expr,
\    nft_chainError
" ************ END icmp6_hdr_expr 'icmpv6 type' ****************

" ************ BEGIN icmp6_hdr_expr 'icmpv6 daddr' ****************
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_set_ref_symbol_expr_setname nftHL_AtSetname
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_set_ref_symbol_expr_setname "\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]" skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" ip6 nexthdr icmpv6 daddr { 1,127,255 }
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_set_expr_integer_expr_num nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_set_expr_integer_expr_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t\n,\}]' skipwhite contained

" ip6 nexthdr icmpv6 daddr {  }
hi link    nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_set_expr nftHL_BlockDelimitersSet
syn region nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_set_expr start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_set_expr_integer_expr_num
\ nextgroup=
\    @nft_c_icmpv6_expressions

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_integer_expr_num nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_integer_expr_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_icmpv6_expressions

" ip6 nexthdr icmpv6 daddr
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_relational_expr_operator_1_char nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_relational_expr_operator_1_char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_integer_expr_num,
\    nft_chainError

" ip6 nexthdr icmpv6 daddr
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_relational_expr_operator_2_char nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_relational_expr_operator_2_char '\v([\=\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_integer_expr_num,
\    nft_chainError

" ip6 nexthdr icmpv6 daddr
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_keyword_in nftHL_Keyword
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_set_expr,
\    nft_Error

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_relational_expr_keyword_not nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_relational_expr_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_keyword_in,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_set_expr,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_integer_expr_num,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_set_ref_symbol_expr_setname,
\    nft_chainError

hi link   nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_daddr nftHL_Substatement
syn match nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_daddr '\vdaddr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_relational_expr_keyword_not,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_relational_expr_operator_2_char,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_keyword_in,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_relational_expr_operator_1_char,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_integer_expr_num,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_relational_expr_rhs_expr_set_ref_symbol_expr_keyword_at,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_daddr_set_expr,
\    nft_chainError
" ************ END icmp6_hdr_expr 'icmpv6 daddr' ****************

" ************ BEGIN icmp6_hdr_expr 'icmpv6 taddr' ****************
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_set_ref_symbol_expr_setname nftHL_AtSetname
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_set_ref_symbol_expr_setname "\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]" skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" ip6 nexthdr icmpv6 taddr { 1,127,255 }
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_set_expr_integer_expr_num nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_set_expr_integer_expr_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t\n,\}]' skipwhite contained

" ip6 nexthdr icmpv6 taddr {  }
hi link    nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_set_expr nftHL_BlockDelimitersSet
syn region nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_set_expr start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_set_expr_integer_expr_num
\ nextgroup=
\    @nft_c_icmpv6_expressions

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_integer_expr_num nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_integer_expr_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_icmpv6_expressions

" ip6 nexthdr icmpv6 taddr
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_relational_expr_operator_1_char nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_relational_expr_operator_1_char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_integer_expr_num,
\    nft_chainError

" ip6 nexthdr icmpv6 taddr
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_relational_expr_operator_2_char nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_relational_expr_operator_2_char '\v([\=\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_integer_expr_num,
\    nft_chainError

" ip6 nexthdr icmpv6 taddr
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_keyword_in nftHL_Keyword
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_set_expr,
\    nft_Error

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_relational_expr_keyword_not nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_relational_expr_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_keyword_in,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_set_expr,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_integer_expr_num,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_set_ref_symbol_expr_setname,
\    nft_chainError

hi link   nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_taddr nftHL_Substatement
syn match nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_taddr '\vtaddr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_relational_expr_keyword_not,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_relational_expr_operator_2_char,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_keyword_in,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_relational_expr_operator_1_char,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_integer_expr_num,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_relational_expr_rhs_expr_set_ref_symbol_expr_keyword_at,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_taddr_set_expr,
\    nft_chainError

" ************ END icmp6_hdr_expr 'icmpv6 taddr' ****************

" ************ BEGIN icmp6_hdr_expr 'icmpv6 checksum' ****************
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_set_ref_symbol_expr_setname nftHL_AtSetname
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_set_ref_symbol_expr_setname "\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]" skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" ip6 nexthdr icmpv6 checksum { 1,127,255 }
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_set_expr_integer_expr_num nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_set_expr_integer_expr_num '\v(0x([A-Fa-f0-9]{1,4}))|(6553[0-5])|(655[0-2][0-9])|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([1-5][0-9]{4})|([0-9]{1,4})\ze[ \t\n,\}]' skipwhite contained

" ip6 nexthdr icmpv6 checksum {  }
hi link    nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_set_expr nftHL_BlockDelimitersSet
syn region nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_set_expr start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_set_expr_integer_expr_num
\ nextgroup=
\    @nft_c_icmpv6_expressions

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_integer_expr_num nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_integer_expr_num '\v(0x[A-Fa-f0-9]{1,4}|6553[0-5]|655[0-2][0-9]|65[0-4][0-9][0-9]|6[0-4][0-9][0-9][0-9]|[1-5][0-9]{4}|[0-9]{1,4})\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_icmpv6_expressions

" ip6 nexthdr icmpv6 checksum
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_relational_expr_operator_1_char nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_relational_expr_operator_1_char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_integer_expr_num,
\    nft_chainError

" ip6 nexthdr icmpv6 checksum
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_relational_expr_operator_2_char nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_relational_expr_operator_2_char '\v([\=\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_integer_expr_num,
\    nft_chainError

" ip6 nexthdr icmpv6 checksum
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_keyword_in nftHL_Keyword
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_set_expr,
\    nft_Error

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_relational_expr_keyword_not nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_relational_expr_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_keyword_in,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_set_expr,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_integer_expr_num,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_set_ref_symbol_expr_setname,
\    nft_chainError

hi link   nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_checksum nftHL_Substatement
syn match nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_checksum '\vchecksum\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_relational_expr_keyword_not,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_relational_expr_operator_2_char,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_keyword_in,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_relational_expr_operator_1_char,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_integer_expr_num,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_relational_expr_rhs_expr_set_ref_symbol_expr_keyword_at,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_checksum_set_expr,
\    nft_chainError
" ************ END icmp6_hdr_expr 'icmpv6 checksum' ****************

" ************ BEGIN icmp6_hdr_expr 'icmpv6 sequence' ****************
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_set_ref_symbol_expr_setname nftHL_AtSetname
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_set_ref_symbol_expr_setname "\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]" skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" ip6 nexthdr icmpv6 sequence { 1,127,255 }
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_set_expr_integer_expr_num nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_set_expr_integer_expr_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t\n,\}]' skipwhite contained

" ip6 nexthdr icmpv6 sequence {  }
hi link    nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_set_expr nftHL_BlockDelimitersSet
syn region nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_set_expr start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_set_expr_integer_expr_num
\ nextgroup=
\    @nft_c_icmpv6_expressions

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_integer_expr_num nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_integer_expr_num '\v(0x[A-Fa-f0-9]{1,4}|6553[0-5]|655[0-2][0-9]|65[0-4][0-9][0-9]|6[0-4][0-9][0-9][0-9]|[1-5][0-9]{4}|[0-9]{1,4})\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_icmpv6_expressions

" ip6 nexthdr icmpv6 sequence
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_relational_expr_operator_1_char nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_relational_expr_operator_1_char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_integer_expr_num,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedAtSymbol,
\    nft_chainError

" ip6 nexthdr icmpv6 sequence
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_relational_expr_operator_2_char nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_relational_expr_operator_2_char '\v([\=\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_integer_expr_num,
\    nft_chainError

" ip6 nexthdr icmpv6 sequence
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_keyword_in nftHL_Keyword
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_set_ref_symbol_expr_setname,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_set_expr,
\    nft_Error

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_relational_expr_keyword_not nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_relational_expr_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_keyword_in,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_set_expr,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_integer_expr_num,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_set_ref_symbol_expr_setname,
\    nft_chainError

hi link   nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_sequence nftHL_Substatement
syn match nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_sequence '\vsequence\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_relational_expr_keyword_not,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_relational_expr_operator_2_char,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_keyword_in,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_relational_expr_operator_1_char,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_integer_expr_num,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_relational_expr_rhs_expr_set_ref_symbol_expr_keyword_at,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_sequence_set_expr,
\    nft_chainError
" ************ END icmp6_hdr_expr 'icmpv6 sequence' ****************

" ************ BEGIN icmp6_hdr_expr 'icmpv6 max-delay' ****************
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_set_ref_symbol_expr_setname nftHL_AtSetname
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_set_ref_symbol_expr_setname "\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]" skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" ip6 nexthdr icmpv6 max-delay { 1,127,255 }
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_set_expr_integer_expr_num nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_set_expr_integer_expr_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t\n,\}]' skipwhite contained

" ip6 nexthdr icmpv6 max-delay {  }
hi link    nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_set_expr nftHL_BlockDelimitersSet
syn region nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_set_expr start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_set_expr_integer_expr_num
\ nextgroup=
\    @nft_c_icmpv6_expressions

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_integer_expr_num nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_integer_expr_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_icmpv6_expressions

" ip6 nexthdr icmpv6 max-delay
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_relational_expr_operator_1_char nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_relational_expr_operator_1_char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_integer_expr_num,
\    nft_chainError

" ip6 nexthdr icmpv6 max-delay
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_relational_expr_operator_2_char nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_relational_expr_operator_2_char '\v([\=\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_integer_expr_num,
\    nft_chainError

" ip6 nexthdr icmpv6 max-delay
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_keyword_in nftHL_Keyword
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_set_expr,
\    nft_Error

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_relational_expr_keyword_not nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_relational_expr_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_keyword_in,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_set_expr,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_integer_expr_num,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_set_ref_symbol_expr_setname,
\    nft_chainError

hi link   nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_max_delay nftHL_Substatement
syn match nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_max_delay '\vmax\-delay\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_relational_expr_keyword_not,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_relational_expr_operator_2_char,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_keyword_in,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_relational_expr_operator_1_char,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_integer_expr_num,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_relational_expr_rhs_expr_set_ref_symbol_expr_keyword_at,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_maxdelay_set_expr,
\    nft_chainError
" ************ END icmp6_hdr_expr 'icmpv6 max-delay' ****************

" ************ BEGIN icmp6_hdr_expr 'icmpv6 parameter-problem' ****************
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_set_ref_symbol_expr_setname nftHL_AtSetname
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_set_ref_symbol_expr_setname "\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]" skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" ip6 nexthdr icmpv6 param-problem { 1,127,255 }
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_set_integer_expr_num nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_set_integer_expr_num '\v(0x[0-9A-Fa-f]{1,8}|(429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}))\ze[ \t\n,\}]' skipwhite contained

" ip6 nexthdr icmpv6 param-problem {  }
hi link    nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_set_expr nftHL_BlockDelimitersSet
syn region nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_set_expr start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_set_expr_integer_expr_num
\ nextgroup=
\    @nft_c_icmpv6_expressions

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_integer_expr_num nftHL_Integer
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_integer_expr_num '\v(0x[0-9A-Fa-f]{1,8}|(429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}))\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_icmpv6_expressions

" ip6 nexthdr icmpv6 param-problem
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_relational_expr_operator_1_char nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_relational_expr_operator_1_char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_integer_expr_num,
\    nft_chainError

" ip6 nexthdr icmpv6 param-problem
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_relational_expr_operator_2_char nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_relational_expr_operator_2_char '\v([\=\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_integer_expr_num,
\    nft_chainError

" ip6 nexthdr icmpv6 param-problem
hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_keyword_in nftHL_Keyword
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_set_expr,
\    nft_Error

hi link   nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_relational_expr_keyword_not nftHL_Expression
syn match nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_relational_expr_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_keyword_in,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_set_expr,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_integer_expr_num,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_set_ref_symbol_expr_setname,
\    nft_chainError

syn match nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_parameter_problem '\v(parameter\-problem|param\-problem)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_relational_expr_keyword_not,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_relational_expr_operator_2_char,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_keyword_in,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_relational_expr_operator_1_char,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_integer_expr_num,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_relational_expr_rhs_expr_set_ref_symbol_expr_keyword_at,
\    nft_icmpv6_hdr_expr_close_scope_icmp6_paramproblem_set_expr,
\    nft_chainError
" ************ END icmp6_hdr_expr 'icmpv6 parameter-problem' ****************


syn cluster nft_c_icmpv6_expressions
\ contains=
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_parameter_problem,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_max_delay,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_sequence,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_checksum,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_daddr,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_taddr,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_code,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_type,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_mtu,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_id

" icmp6_hdr_expr (via inner_inet_expr, payload_expr)
hi link   nft_icmp6_hdr_expr_icmp6_hdr_field_keyword_icmp6 nftHL_Action
syn match nft_icmp6_hdr_expr_icmp6_hdr_field_keyword_icmp6 "\vicmpv6\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_parameter_problem,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_max_delay,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_sequence,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_checksum,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_daddr,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_taddr,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_code,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_type,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_mtu,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_id

" stmt
" └── expr_stmt
"      └── expr
"           └── primary_expr
"                └── payload_expr
"                     └── icmp6_hdr_expr
hi link   nft_payload_expr_icmp6_hdr_expr_icmp6_hdr_field_keyword_icmp6 nftHL_Statement
syn match nft_payload_expr_icmp6_hdr_expr_icmp6_hdr_field_keyword_icmp6 "\v(ipv6\-icmp|icmpv6)\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_parameter_problem,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_max_delay,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_sequence,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_checksum,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_daddr,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_taddr,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_code,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_type,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_mtu,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_id

" icmp6_hdr_expr->inner_inet_expr->inner_expr->(vxlan_hdr_expr|gretap_hdr_expr|geneve_hdr_expr)
hi link   nft_inner_inet_expr_icmp6_hdr_expr_icmp6_hdr_field_keyword_icmp6 nftHL_Action
syn match nft_inner_inet_expr_icmp6_hdr_expr_icmp6_hdr_field_keyword_icmp6 "\v(ipv6\-icmp|icmpv6)\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_parameter_problem,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_max_delay,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_sequence,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_checksum,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_daddr,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_taddr,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_code,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_type,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_mtu,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_id

" icmp6_hdr_expr->gre_hdr_expr->payload_expr->(payload_stmt|primary_expr|primary_stmt_expr)

hi link   nft_icmp6_hdr_expr nftHL_Statement
syn match nft_icmp6_hdr_expr "\vicmpv6\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_icmp6_hdr_field


  for s:this_semantic_file in s:icmp6_hdr_expr_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded icmp6_hdr_expr for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define icmp6_hdr_expr.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_icmp6_hdr_expr = v:true
