
" IPv6 address patterns for nftables
" Simplistic static patterns
syn match nft_payload_expr_ip6_addr '\v::[0-9a-fA-F]{1,4}\ze[ \t\n;]' skipwhite contained
syn match nft_payload_expr_ip6_addr '\v::\ze[ \t\n;]' skipwhite contained
syn match nft_payload_expr_ip6_addr '\v[0-9a-fA-F]{1,4}::\ze[ \t\n;]' skipwhite contained
syn match nft_payload_expr_ip6_addr '\v::ffff:[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\ze[ \t\n;]' skipwhite contained

" Complex wildcardy patterns
syn match nft_payload_expr_ip6_addr '\v([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\ze[ \t\n;]' skipwhite contained
syn match nft_payload_expr_ip6_addr '\v::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){6}\ze[ \t\n;]' skipwhite contained
syn match nft_payload_expr_ip6_addr '\v([0-9a-fA-F]{1,4}:){1}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){5}\ze[ \t\n;]' skipwhite contained
syn match nft_payload_expr_ip6_addr '\v([0-9a-fA-F]{1,4}:){2}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){4}\ze[ \t\n;]' skipwhite contained
syn match nft_payload_expr_ip6_addr '\v([0-9a-fA-F]{1,4}:){3}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){3}\ze[ \t\n;]' skipwhite contained
syn match nft_payload_expr_ip6_addr '\v([0-9a-fA-F]{1,4}:){4}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){2}\ze[ \t\n;]' skipwhite contained
syn match nft_payload_expr_ip6_addr '\v([0-9a-fA-F]{1,4}:){5}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){1}\ze[ \t\n;]' skipwhite contained
syn match nft_payload_expr_ip6_addr '\v([0-9a-fA-F]{1,4}:){6}::[0-9a-fA-F]{1,4}\ze[ \t\n;]' skipwhite contained
syn match nft_payload_expr_ip6_addr '\v[0-9a-fA-F]{1,4}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){6}\ze[ \t\n;]' skipwhite contained

" Fallback for compressed IPv6
syn match nft_payload_expr_ip6_addr '\v[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){0,6}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){0,6}\ze[ \t\n;]' skipwhite contained

" IPv6/CIDR address patterns for nftables
" Simplistic static patterns
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_2 '\v::(\/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9]))){0,1}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_3 '\v::[0-9a-fA-F]{1,4}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9]))){0,1}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr,
\    @nft_c_stmt
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_1 '\v[0-9a-fA-F]{1,4}::(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9]))){0,1}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_8h '\v::ffff:[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9]))){0,1}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" Complex wildcardy patterns
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_8f '\v([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9]))){0,1}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_2b6 '\v::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){6}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9]))){0,1}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_4a1 '\v([0-9a-fA-F]{1,4}:){1}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){5}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9]))){0,1}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_2a2 '\v([0-9a-fA-F]{1,4}:){2}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){4}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9]))){0,1}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_2a3 '\v([0-9a-fA-F]{1,4}:){3}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){3}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9]))){0,1}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_2a4 '\v([0-9a-fA-F]{1,4}:){4}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){2}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9]))){0,1}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_2a5 '\v([0-9a-fA-F]{1,4}:){5}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){1}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9]))){0,1}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_2a6 '\v([0-9a-fA-F]{1,4}:){6}::[0-9a-fA-F]{1,4}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9]))){0,1}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_3a7 '\v[0-9a-fA-F]{1,4}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){6}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9]))){0,1}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" Fallback for compressed IPv6
syn match nft_payload_expr_ip6_addr_optional_cidr_suffix_2x2 '\v[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){0,6}::[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){0,6}(/((12[0-8])|(1[0-1][0-9])|([1-9][0-9])|([0-9]))){0,1}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

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
\    nft_close_scope_ip_primary_expr_constant_expr_at_setname,
\    nft_payload_expr_ip6_addr_optional_cidr_suffix,
\    @nft_c_primary_stmt_expr,
\    @nft_c_map_expr_rhs_expr,
\    nft_stmt_expr_map_stmt_expr_keyword_map,
\    nft_Error

hi link   nft_XXX_close_scope_ZZZ_YYY_string_expr_string_ip4_cidr_prefix nftHL_Integer
syn match nft_XXX_close_scope_ZZZ_YYY_string_expr_string_ip4_cidr_prefix '\v(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])(/(3[0-2]|[12][0-9]|[0-9])){0,1}\ze[ \t\n;]' skipwhite contained

hi link   nft_XXX_close_scope_ZZZ_YYY_payload_expr_string_ip4 nftHL_Integer
syn match nft_XXX_close_scope_ZZZ_YYY_payload_expr_string_ip4 '\v(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\ze[ \t\n;]' skipwhite contained

hi link   nft_XXX_close_scope_ZZZ_YYY_range_stmt_expr_symbol_dash nftHL_elements
syn match nft_XXX_close_scope_ZZZ_YYY_range_stmt_expr_symbol_dash '\-' contained
\ nextgroup=
\    nft_XXX_close_scope_ZZZ_YYY_payload_expr_string_ip4,
\    nft_Error

hi link   nft_XXX_close_scope_ZZZ_YYY_payload_expr_string_ip4_range nftHL_Integer
syn match nft_XXX_close_scope_ZZZ_YYY_payload_expr_string_ip4_range '\v(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\ze\-' contained
\ nextgroup=
\    nft_XXX_close_scope_ZZZ_YYY_range_stmt_expr_symbol_dash,
\    nft_Error

" INTEGER
hi link   nft_meta_expr_close_scope_meta_random_integer_expr_uint32 nftHL_Integer
syn match nft_meta_expr_close_scope_meta_random_integer_expr_uint32 '\v429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}\ze[ \t\n;]' skipwhite contained

hi link   nft_constant_expr_integer_uint16 nftHL_Integer
syn match nft_constant_expr_integer_uint16 '\v(6553[0-5]|655[0-2]\d|65[0-4]\d\d|6[0-4]\d\d\d|[1-5]\d{4}|\d{1,4})\ze[ \t]'  skipwhite contained

hi link   nft_constant_expr_integer_uint8 nftHL_Integer
syn match nft_constant_expr_integer_uint8 '\v(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\ze[ \t]' skipwhite contained


" Operators ************************************************************************************
" a list of data types that can handle 'in' and 'not in' (limited)
" | Category                            | Data type keyword                          | Example of membership use                   |
" | ----------------------------------- | ------------------------------------------ | ------------------------------------------- |
" | **Network addresses**               | `ipv4_addr`                                | `ip saddr in { 192.168.1.1, 10.0.0.1 }`     |
" |                                     | `ipv6_addr`                                | `ip6 saddr in { fd00::1, 2001:db8::1 }`     |
" | **Address prefixes**                | `ipv4_addr` (with mask/range)              | `ip saddr in { 192.168.0.0/24 }`            |
" |                                     | `ipv6_addr` (with mask/range)              | `ip6 saddr in { fd00::/64 }`                |
" | **Port numbers**                    | `inet_service`                             | `tcp dport in { 22, 80, 443 }`              |
" | **Marks / integer flags**           | `mark` (`meta mark`, `ct mark`)            | `meta mark in { 0x1, 0x2 }`                 |
" | **Connection tracking states**      | `ct_state`                                 | `ct state in { established, related }`      |
" | **Connection tracking status bits** | `ct_status`                                | `ct status in { expected, confirmed }`      |
" | **Connection tracking direction**   | `ct_dir`                                   | `ct dir in { original }`                    |
" | **Connection tracking event bits**  | `ct_event`                                 | `ct event in { new, destroy }`              |
" | **Connection tracking labels**      | `ct_label`                                 | `ct label in { 1, 2 }`                      |
" | **Interface names**                 | `iifname`, `oifname`, `meta iifname`       | `iifname in { "eth0", "enp*" }`             |
" | **Packet types**                    | `pkttype`                                  | `pkttype in { host, broadcast }`            |
" | **ICMP / ICMPv6 type enums**        | `icmp_type`, `icmpv6_type`                 | `icmp type in { echo-request, echo-reply }` |
" | **Transport protocol numbers**      | `inet_proto`                               | `ip protocol in { tcp, udp }`               |
" | **DSCP / TOS / ECN bits**           | `dscp`, `tos`, `ecn`                       | `ip dscp in { af11, af12 }`                 |
" | **VLAN identifiers**                | `vlan_id`                                  | `vlan id in { 10, 20 }`                     |
" | **Bridge port indices / names**     | `ibrport`, `obrport`, `ibrname`, `obrname` | `meta obrname in { "br0", "br1" }`          |
" | **Security labels / secmark**       | `secmark`                                  | `meta secmark in { 0x10, 0x20 }`            |
" | **Cgroup ID**                       | `cgroup`                                   | `meta cgroup in { 1234, 5678 }`             |
"
"
hi link   nft_XXX_close_scope_ZZZ_YYY_set_ref_expr_set_ref_symbol_expr_at_setname nftHL_Variable
syn match nft_XXX_close_scope_ZZZ_YYY_set_ref_expr_set_ref_symbol_expr_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_XXX_close_scope_ZZZ_YYY_symbol_expr_variable_expr nftHL_Variable
syn match nft_XXX_close_scope_ZZZ_YYY_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link    nft_XXX_close_scope_ZZZ_YYY_symbol_expr_string_quoted nftHL_String
syn region nft_XXX_close_scope_ZZZ_YYY_symbol_expr_string_quoted start='\"' end='\"' skipwhite contained

hi link    nft_XXX_close_scope_ZZZ_YYY_symbol_expr_string_asterisk nftHL_String
syn region nft_XXX_close_scope_ZZZ_YYY_symbol_expr_string_asterisk  start='\"' end='\"' skipwhite contained

hi link   nft_SSS_close_scope_ZZZ_YYY_set_ref_expr_set_ref_symbol_expr_at_setname nftHL_Variable
syn match nft_XXX_close_scope_ZZZ_YYY_set_ref_expr_set_ref_symbol_expr_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" BEGIN Operators - Set membership
hi link   nft_XXX_close_scope_ZZZ_YYY_set_ref_symbol_expr_keyword_at_identifier nftHL_Variable
syn match nft_XXX_close_scope_ZZZ_YYY_set_ref_symbol_expr_keyword_at_identifier '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_XXX_close_scope_ZZZ_YYY_set_list_member_expr_symbol_expr_string_keyword_defines nftHL_Define
syn match nft_XXX_close_scope_ZZZ_YYY_set_list_member_expr_symbol_expr_string_keyword_defines '\vabc|def' skipwhite contained

hi link    nft_XXX_YYY_set_expr_inline_set nftHL_BlockDelimitersDDD
syn region nft_XXX_YYY_set_expr_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_XXX_close_scope_ZZZ_YYY_set_list_member_expr_symbol_expr_string_keyword_defines,
\    nft_XXX_close_scope_ZZZ_YYY_set_list_member_expr_string_expr_string_ip4_opt_cidr_prefix,
\    nft_XXX_close_scope_ZZZ_YYY_set_list_member_expr_payload_expr_string_ip4_range,
\    nft_XXX_close_scope_ZZZ_YYY_set_list_member_expr_payload_expr_string_ip4,
\    nft_XXX_close_scope_ZZZ_YYY_set_list_member_expr_symbol_expr_string_quoted,
\    nft_XXX_close_scope_ZZZ_YYY_set_list_member_expr_symbol_expr_string_asterisk,
\    nft_XXX_close_scope_ZZZ_YYY_set_list_member_expr_integer_expr_num_uint64_hex,
\    nft_XXX_close_scope_ZZZ_YYY_set_list_member_expr_integer_expr_num_uint8_hex

hi link   nft_XXX_close_scope_ZZZ_YYY_internal_set_expr_keyword_in nftHL_Operator
syn match nft_XXX_close_scope_ZZZ_YYY_internal_set_expr_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_XXX_close_scope_ZZZ_YYY_symbol_expr_variable_expr,
\    nft_XXX_close_scope_ZZZ_YYY_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_XXX_YYY_set_expr_inline_set,
\    nft_Error
" no scalar (integer) after 'in' keyword

" END Operators - Set membership

" BEGIN Operators - Scalar
hi link   nft_XXX_close_scope_ZZZ_YYY_boolean_expr_boolean_keys_keywords nftHL_Define
syn match nft_XXX_close_scope_ZZZ_YYY_boolean_expr_boolean_keys_keywords '\vmissing|exists' skipwhite contained
\ nextgroup=
\    @nft_c_ZZZ

hi link   nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint8_hex nftHL_Integer
syn match nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint8_hex '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9][0-9])|[0-9]\ze[ \t\n-;] skipwhite contained
\ nextgroup=
\    @nft_c_ZZZ

hi link   nft_XXX_close_scope_YYY_ZZZ_integer_expr_num_uint13_hex nftHL_Integer
syn match nft_XXX_close_scope_YYY_ZZZ_integer_expr_num_uint13_hex '\v(0x1[fF]{3}|0x1[fF][0-9a-eA-E][0-9a-fA-F]|0x1[0-9a-eA-E][0-9a-fA-F]{2}|0x[0-9a-fA-F]{1,3}|819[0-1]|81[0-8][0-9]|80[0-9]{2}|[1-7][0-9]{3}|[1-9][0-9]{0,2}|0)\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_ZZZ

hi link   nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint16_hex nftHL_Integer
syn match nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint16_hex '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9][0-9][0-9][0-9])|[0-9][0-9][0-9][0-9]|[0-9][0-9][0-9]|[0-9][0-9]|[0-9]\ze[ \t\n\-;]' skipwhite contained
\ nextgroup=
\    @nft_c_ZZZ

hi link   nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint32_hex nftHL_Integer
syn match nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint32_hex '\v0x[0-9a-fA-F]{1,8}|429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_ZZZ

hi link   nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint64_hex nftHL_Integer
syn match nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint64_hex '\v0x[0-9a-fA-F]{1,16}|[0-9]{20}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_ZZZ

hi link   nft_XXX_close_scope_ZZZ_YYY_string_expr_string_ip4_opt_cidr nftHL_Integer
syn match nft_XXX_close_scope_ZZZ_YYY_string_expr_string_ip4_opt_cidr '\v(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])(/(3[0-2]|[12][0-9]|[0-9])){0,1}\ze[ \t]' skipwhite contained

hi link   nft_XXX_close_scope_ZZZ_YYY_payload_expr_string_ip4 nftHL_Integer
syn match nft_XXX_close_scope_ZZZ_YYY_payload_expr_string_ip4 '\v(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\ze[ \t]' skipwhite contained

hi link   nft_XXX_close_scope_ZZZ_YYY_symbol_expr_string_keyword_defines nftHL_Define
syn match nft_XXX_close_scope_ZZZ_YYY_symbol_expr_string_keyword_defines '\v(abc|def)\ze[ \t\n;,]' skipwhite contained
\ nextgroup=
\    @nft_c_ZZZ
" END Operators - Scalar

hi link   nft_XXX_close_scope_ZZZ_YYY_relational_op_discrete_1char nftHL_Operator
syn match nft_XXX_close_scope_ZZZ_YYY_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_XXX_close_scope_ZZZ_YYY_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_XXX_close_scope_ZZZ_YYY_symbol_expr_variable_expr,
\    nft_XXX_close_scope_ZZZ_YYY_string_expr_string_ip4_opt_cidr_prefix,
\    nft_XXX_close_scope_ZZZ_YYY_payload_expr_string_ip4_range,
\    nft_XXX_close_scope_ZZZ_YYY_payload_expr_string_ip4,
\    nft_XXX_close_scope_ZZZ_YYY_symbol_expr_string_quoted,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint64_hex,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint32_hex,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint16_hex,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint8_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint8_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
# \    nft_XXX_YYY_set_expr_inline_set_not_integer,
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_XXX_close_scope_ZZZ_YYY_relational_op_discrete_2char nftHL_Operator
syn match nft_XXX_close_scope_ZZZ_YYY_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_XXX_close_scope_ZZZ_YYY_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_XXX_close_scope_ZZZ_YYY_string_expr_string_ip4_opt_cidr_prefix,
\    nft_XXX_close_scope_ZZZ_YYY_payload_expr_string_ip4_range,
\    nft_XXX_close_scope_ZZZ_YYY_payload_expr_string_ip4
\    nft_XXX_close_scope_ZZZ_YYY_symbol_expr_variable_expr,
\    nft_XXX_close_scope_ZZZ_YYY_symbol_expr_string_quoted,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint64_hex,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint32_hex,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint16_hex,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint8_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint8_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
"\    nft_XXX_YYY_set_expr_inline_set_not_integer,
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string


hi link   nft_XXX_close_scope_ZZZ_YYY_relational_expr_relational_op_symbol_exclamation nftHL_Operator
syn match nft_XXX_close_scope_ZZZ_YYY_relational_expr_relational_op_symbol_exclamation '\v\!\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_XXX_close_scope_ZZZ_YYY_symbol_expr_variable_expr,
\    nft_XXX_close_scope_ZZZ_YYY_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_XXX_YYY_set_expr_inline_set,
\    nft_XXX_close_scope_ZZZ_YYY_string_expr_string_ip4_opt_cidr_prefix,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint8_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_payload_expr_string_ip4,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint64_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint64_hex,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint32_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint32_hex,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint16_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint16_hex,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint8_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint8_hex,
" 'not' operator is most flexible with scalar but never directly to a set membership ('not in' ok)



hi link   nft_XXX_close_scope_ZZZ_YYY_relational_op_non_equality_2char nftHL_Operator
syn match nft_XXX_close_scope_ZZZ_YYY_relational_op_non_equality_2char '\v(\!\=)|(ne\ze[ \t\n;])' skipwhite contained
\ nextgroup=
\    nft_XXX_close_scope_ZZZ_YYY_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_XXX_close_scope_ZZZ_YYY_string_expr_string_ip4_opt_cidr_prefix,
\    nft_XXX_close_scope_ZZZ_YYY_payload_expr_string_ip4_range,
\    nft_XXX_close_scope_ZZZ_YYY_payload_expr_string_ip4,
\    nft_XXX_close_scope_ZZZ_YYY_symbol_expr_variable_expr,
\    nft_XXX_YYY_set_expr_inline_set,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint64_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint64_hex,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint32_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint32_hex,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint16_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint16_hex,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint8_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint8_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)



hi link   nft_XXX_close_scope_ZZZ_YYY_relational_op_equality_2char nftHL_Operator
syn match nft_XXX_close_scope_ZZZ_YYY_relational_op_equality_2char '\v\=\=' skipwhite contained
\ nextgroup=
\    nft_XXX_close_scope_ZZZ_YYY_boolean_expr_boolean_keys_keywords,
\    nft_XXX_close_scope_ZZZ_YYY_symbol_expr_string_keyword_defines,
\    nft_XXX_close_scope_ZZZ_YYY_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_XXX_close_scope_ZZZ_YYY_string_expr_string_ip4_opt_cidr_prefix,
\    nft_XXX_close_scope_ZZZ_YYY_payload_expr_string_ip4_range,
\    nft_XXX_close_scope_ZZZ_YYY_payload_expr_string_ip4,
\    nft_XXX_close_scope_ZZZ_YYY_symbol_expr_variable_expr,
\    nft_XXX_YYY_set_expr_inline,
\    nft_XXX_close_scope_ZZZ_YYY_symbol_expr_string_quoted,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint64_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint64_hex,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint32_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint32_hex,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint16_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint16_hex,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint8_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint8_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

hi link   nft_XXX_close_scope_ZZZ_YYY_relational_expr_relational_op_keyword_not nftHL_Operator
syn match nft_XXX_close_scope_ZZZ_YYY_relational_expr_relational_op_keyword_not '\v(not|\!\=)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_XXX_close_scope_ZZZ_YYY_boolean_expr_boolean_keys_keywords,
\    nft_XXX_close_scope_ZZZ_YYY_symbol_expr_string_keyword_defines,
\    nft_XXX_close_scope_ZZZ_YYY_internal_set_expr_keyword_in,
\    nft_XXX_close_scope_ZZZ_YYY_symbol_expr_variable_expr,
\    nft_XXX_close_scope_ZZZ_YYY_string_expr_string_ip4_opt_cidr_prefix,
\    nft_XXX_close_scope_ZZZ_YYY_payload_expr_string_ip4_range,
\    nft_XXX_close_scope_ZZZ_YYY_payload_expr_string_ip4,
\    nft_XXX_close_scope_ZZZ_YYY_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_XXX_close_scope_ZZZ_YYY_symbol_expr_string_quoted,
\    nft_XXX_close_scope_ZZZ_YYY_symbol_expr_string_asterisk,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint64_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint64_hex,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint32_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint32_hex,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint16_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint16_hex,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint8_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint8,
" 'not' operator is most flexible with scalar but never directly to a set membership ('not in' ok)

hi link   nft_XXX_close_scope_ZZZ_YYY_symbol_expr_string_keyword_any nftHL_Operator
syn match nft_XXX_close_scope_ZZZ_YYY_symbol_expr_string_keyword_any '\vany\ze[ \t;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" 'XXX YYY' implied match
hi link   nft_XXX_keyword_YYY nftHL_Substatement
syn match nft_XXX_keyword_YYY '\vYYY\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_XXX_close_scope_ZZZ_YYY_symbol_expr_string_keyword_defines,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_XXX_close_scope_ZZZ_YYY_string_expr_string_ip4_opt_cidr_prefix,
\    nft_XXX_close_scope_ZZZ_YYY_payload_expr_string_ip4_range,
\    nft_XXX_close_scope_ZZZ_YYY_payload_expr_string_ip4,
\    nft_XXX_close_scope_ZZZ_YYY_symbol_expr_string_keyword_any,
\    nft_map_expr_keyword_map,
\    nft_XXX_close_scope_ZZZ_YYY_relational_expr_relational_op_keyword_not,
\    nft_XXX_close_scope_ZZZ_YYY_relational_op_equality_2char,
\    nft_XXX_close_scope_ZZZ_YYY_relational_op_discrete_2char,
\    nft_XXX_close_scope_ZZZ_YYY_internal_set_expr_keyword_in,
\    nft_XXX_close_scope_ZZZ_YYY_relational_op_discrete_1char,
\    nft_XXX_close_scope_ZZZ_YYY_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_XXX_close_scope_ZZZ_YYY_symbol_expr_variable_expr,
\    nft_XXX_YYY_set_expr_inline_set,
\    nft_XXX_close_scope_ZZZ_YYY_symbol_expr_string_quoted,
\    nft_XXX_close_scope_ZZZ_YYY_symbol_expr_string_asterisk,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint64_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint64_hex,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint32_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint32_hex,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint16_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint16_hex,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint8_hex_range,
\    nft_XXX_close_scope_ZZZ_YYY_integer_expr_num_uint8_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname


