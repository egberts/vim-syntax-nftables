

hi link   nft_keyword_expr_keyword_original nftHL_Substatement
syn match nft_keyword_expr_keyword_original '\voriginal' skipwhite contained

hi link   nft_keyword_expr_keyword_destroy nftHL_Substatement
syn match nft_keyword_expr_keyword_destroy '\vdestroy' skipwhite contained

" eth_hdr_expr (via inner_eth_expr, payload_expr)
hi link   nft_keyword_expr_keyword_ether nftHL_Substatement
syn match nft_keyword_expr_keyword_ether '\vether' skipwhite contained
\  nextgroup=
\    nft_eth_hdr_expr_eth_hdr_field_keyword_daddr,
\    nft_eth_hdr_expr_eth_hdr_field_keyword_saddr,
\    nft_eth_hdr_expr_eth_hdr_field_keyword_type,
\    nft_UnexpectedNumber,
\    nft_chainError

hi link   nft_keyword_expr_keyword_label nftHL_Substatement
syn match nft_keyword_expr_keyword_label '\vlabel' skipwhite contained

hi link   nft_keyword_expr_keyword_reply nftHL_Substatement
syn match nft_keyword_expr_keyword_reply '\vreply' skipwhite contained

hi link   nft_keyword_expr_keyword_reset nftHL_Substatement
syn match nft_keyword_expr_keyword_reset '\vreset' skipwhite contained

hi link   nft_keyword_expr_keyword_dnat nftHL_Substatement
syn match nft_keyword_expr_keyword_dnat '\vdnat' skipwhite contained

hi link   nft_keyword_expr_keyword_last nftHL_Substatement
syn match nft_keyword_expr_keyword_last '\vlast' skipwhite contained

hi link   nft_keyword_expr_keyword_snat nftHL_Substatement
syn match nft_keyword_expr_keyword_snat '\vsnat' skipwhite contained

hi link   nft_keyword_expr_keyword_vlan nftHL_Substatement
syn match nft_keyword_expr_keyword_vlan '\vvlan' skipwhite contained
\  nextgroup=
\    nft_vlan_hdr_expr_vlan_hdr_field_keyword_type,
\    nft_vlan_hdr_expr_vlan_hdr_field_keyword_cfi,
\    nft_vlan_hdr_expr_vlan_hdr_field_keyword_dei,
\    nft_vlan_hdr_expr_vlan_hdr_field_keyword_pcp,
\    nft_vlan_hdr_expr_vlan_hdr_field_keyword_id,
\    nft_chainError

" arp_hdr_expr 'arp' (via inner_eth_expr, payload_expr)
hi link   nft_keyword_expr_keyword_arp nftHL_Statement
syn match nft_keyword_expr_keyword_arp '\varp' skipwhite contained
\ nextgroup=
\    nft_arp_hdr_expr_arp_hdr_field_keyword_operation,
\    nft_arp_hdr_expr_arp_hdr_field_keyword_htype,
\    nft_arp_hdr_expr_arp_hdr_field_addrs,
\    nft_arp_hdr_expr_arp_hdr_field_keyword_ptype,
\    nft_arp_hdr_expr_arp_hdr_field_keyword_hlen,
\    nft_arp_hdr_expr_arp_hdr_field_keyword_plen

hi link   nft_keyword_expr_keyword_ecn nftHL_Substatement
syn match nft_keyword_expr_keyword_ecn '\vecn' skipwhite contained

hi link   nft_keyword_expr_keyword_ip6 nftHL_Substatement
syn match nft_keyword_expr_keyword_ip6 '\vip6' skipwhite contained

hi link   nft_keyword_expr_keyword_ip nftHL_Substatement
syn match nft_keyword_expr_keyword_ip '\vip\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_ip_hdr_field_keyword_hdrversion,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_hdrlength,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_checksum,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_frag_off,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_protocol,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_length,
\    nft_ip_hdr_expr_keyword_option,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_daddr,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_saddr,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_dscp,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_ecn,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_ttl,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_id,
\    nft_Error