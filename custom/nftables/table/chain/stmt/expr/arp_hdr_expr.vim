" File:  arp_hdr_expr.vim
" base_cmd Vim syntax file for nftables configuration file
" Language:     nftables configuration file
" Maintainer:   egberts <egberts@github.com>
" Revision:     2.0
" Initial Date: 2025-04-18
" Last Change:  2025-04-18
" Filenames:    nftables.conf, *.nft
" Location:     https://github.com/egberts/vim-nftables
" License:      MIT license
" Remarks:
" Bug Report:   https://github.com/egberts/vim-nftables/issues
"
"  WARNING:  Do not add online comments using a quote symbol, it ALTERS patterns
"
" Called by: payload_expr
" Called by: inner_inet_expr
"

hi link   nft_arp_hdr_expr_close_scope_constant_expr_ip nftHL_Integer
syn match nft_arp_hdr_expr_close_scope_constant_expr_ip '\v[0-9]{1,3}(\.([0-9]{1,3})){3}' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_arp_hdr_expr_close_scope_arp_macaddr nftHL_Number
syn match nft_arp_hdr_expr_close_scope_arp_macaddr '\v[0-9a-fA-F]{1,2}(:[0-9a-fA-F]{1,2}){5}' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_arp_hdr_expr_close_scope_arp_constant_expr_int_hex_8b nftHL_Integer
syn match nft_arp_hdr_expr_close_scope_arp_constant_expr_int_hex_8b '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_arp_hdr_expr_close_scope_arp_constant_expr_int_hex_16b nftHL_Integer
syn match nft_arp_hdr_expr_close_scope_arp_constant_expr_int_hex_16b '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

" arp_hdr_expr->inner_eth_expr->inner_expr->(vxlan_hdr_expr|gretap_hdr_expr|geneve_hdr_expr)
" arp_hdr_field_addr_ether (via arp_hdr_field)
hi link   nft_arp_hdr_expr_arp_hdr_field_addr_keyword_ether nftHL_Action
syn match nft_arp_hdr_expr_arp_hdr_field_addr_keyword_ether '\vether' skipwhite contained
\ nextgroup=
\    nft_arp_hdr_expr_close_scope_arp_macaddr,
\    nft_Error

" arp_hdr_field_ip_ether (via arp_hdr_field)
hi link   nft_arp_hdr_expr_arp_hdr_field_addr_keyword_ip nftHL_Action
syn match nft_arp_hdr_expr_arp_hdr_field_addr_keyword_ip '\vip' skipwhite contained
\ nextgroup=
\    nft_arp_hdr_expr_close_scope_constant_expr_ip,
\    nft_Error

" arp_hdr_field_addrs 'saddr'/'daddr' (via arp_hdr_field)
hi link   nft_arp_hdr_expr_arp_hdr_field_addrs nftHL_Action
syn match nft_arp_hdr_expr_arp_hdr_field_addrs '\v(saddr|daddr)' skipwhite contained
\ nextgroup=
\    nft_arp_hdr_expr_arp_hdr_field_addr_keyword_ether,
\    nft_arp_hdr_expr_arp_hdr_field_addr_keyword_ip

hi link   nft_arp_hdr_expr_close_scope_arp_constant_expr_operation_code_keyword_request nftHL_Define
syn match nft_arp_hdr_expr_close_scope_arp_constant_expr_operation_code_keyword_request '\vrequest' skipwhite contained

hi link   nft_arp_hdr_expr_close_scope_arp_constant_expr_operation_code_keyword_reply nftHL_Define
syn match nft_arp_hdr_expr_close_scope_arp_constant_expr_operation_code_keyword_reply '\vreply' skipwhite contained

" arp_hdr_field_keywords (via arp_hdr_field)
hi link   nft_arp_hdr_expr_arp_hdr_field_keyword_operation nftHL_Action
syn match nft_arp_hdr_expr_arp_hdr_field_keyword_operation '\voperation' skipwhite contained
\ nextgroup=
\    nft_arp_hdr_expr_close_scope_arp_constant_expr_operation_code_keyword_request,
\    nft_arp_hdr_expr_close_scope_arp_constant_expr_operation_code_keyword_reply,
\    nft_arp_hdr_expr_close_scope_arp_constant_expr_int_hex_16b

hi link   nft_arp_hdr_expr_arp_hdr_field_keyword_htype nftHL_Action
syn match nft_arp_hdr_expr_arp_hdr_field_keyword_htype '\vhtype' skipwhite contained
\ nextgroup=
\    nft_arp_hdr_expr_close_scope_arp_constant_expr_int_hex_16b

hi link   nft_arp_hdr_expr_close_scope_arp_ptype_defines nftHL_Define
sy match nft_arp_hdr_expr_close_scope_arp_ptype_defines '\v(ipv6|arp|ip)' skipwhite contained

hi link   nft_arp_hdr_expr_arp_hdr_field_keyword_ptype nftHL_Action
syn match nft_arp_hdr_expr_arp_hdr_field_keyword_ptype '\vptype' skipwhite contained
\ nextgroup=
\    nft_arp_hdr_expr_close_scope_arp_ptype_defines,
\    nft_arp_hdr_expr_close_scope_arp_constant_expr_int_hex_16b

hi link   nft_arp_hdr_expr_arp_hdr_field_keyword_hlen nftHL_Action
syn match nft_arp_hdr_expr_arp_hdr_field_keyword_hlen '\vhlen' skipwhite contained
\ nextgroup=
\    nft_arp_hdr_expr_close_scope_arp_constant_expr_int_hex_8b

hi link   nft_arp_hdr_expr_arp_hdr_field_keyword_plen nftHL_Action
syn match nft_arp_hdr_expr_arp_hdr_field_keyword_plen '\vplen' skipwhite contained
\ nextgroup=
\    nft_arp_hdr_expr_close_scope_arp_constant_expr_int_hex_8b


" arp_hdr_field (via arp_hdr_expr)
syn cluster nft_c_arp_hdr_field
\ contains=
\    nft_arp_hdr_expr_arp_hdr_field_keyword_operation,
\    nft_arp_hdr_expr_arp_hdr_field_keyword_htype,
\    nft_arp_hdr_expr_arp_hdr_field_addrs,
\    nft_arp_hdr_expr_arp_hdr_field_keyword_ptype,
\    nft_arp_hdr_expr_arp_hdr_field_keyword_hlen,
\    nft_arp_hdr_expr_arp_hdr_field_keyword_plen

