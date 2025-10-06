" File: eth_hdr_expr.vim
"
" Called by: payload_expr
" Called by: inner_inet_expr

" ************************* BEGIN ether_hdr_expr' *************************
hi link   nft_ether_hdr_expr_eth_hdr_field_close_scope_type_types nftHL_Number
syn match nft_ether_hdr_expr_eth_hdr_field_close_scope_type_types '\v((0[xX][0-9a-fA-F]{1,4})|([0-9]{1,5}))' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_ether_hdr_expr_close_scope_eth_macaddr nftHL_Number
syn match nft_ether_hdr_expr_close_scope_eth_macaddr '\v[0-9a-fA-F]{1,2}(:[0-9a-fA-F]{1,2}){5}' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

" this 'set' is not a Command/Statement, it is an 'Action'/expression/write-only
hi link   nft_payload_expr_ether_hdr_expr_keyword_set nftHL_Write
syn match nft_payload_expr_ether_hdr_expr_keyword_set '\vset' skipwhite contained
\ nextgroup=
\    @nft_c_stmt_expr,
\    nft_chain_block_primary_expr_numgen_expr_keyword_numgen,
\    nft_ether_hdr_expr_close_scope_eth_macaddr,
\    nft_chainError

" eth_hdr_expr->inner_eth_expr->inner_expr->(vxlan_hdr_expr|gretap_hdr_expr|geneve_hdr_expr)
" eth_hdr_field 'saddr'/'daddr' (via eth_hdr_field)
hi link   nft_eth_hdr_expr_eth_hdr_field_keyword_daddr nftHL_Keyword
syn match nft_eth_hdr_expr_eth_hdr_field_keyword_daddr '\vdaddr' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ether_hdr_expr_keyword_set,
\    nft_ether_hdr_expr_close_scope_eth_macaddr,
\    nft_chainError

hi link   nft_eth_hdr_expr_eth_hdr_field_keyword_saddr nftHL_Keyword
syn match nft_eth_hdr_expr_eth_hdr_field_keyword_saddr '\vsaddr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ether_hdr_expr_keyword_set,
\    nft_numgen_expr,
\    nft_ether_hdr_expr_close_scope_eth_macaddr,
\    nft_chainError

" eth_hdr_field 'type' (via eth_hdr_field)
hi link   nft_eth_hdr_expr_eth_hdr_field_keyword_type nftHL_Keyword
syn match nft_eth_hdr_expr_eth_hdr_field_keyword_type '\vtype' skipwhite contained
\ nextgroup=
\    nft_ether_hdr_expr_eth_hdr_field_close_scope_type_types,
\    nft_chainError

" ************************* END ether_hdr_expr' *****************

" eth_hdr_expr (via inner_eth_expr, payload_expr)
hi link   nft_eth_hdr_expr_keyword_ether nftHL_Statement
syn match nft_eth_hdr_expr_keyword_ether '\vether' skipwhite contained
\  nextgroup=
\    nft_eth_hdr_expr_eth_hdr_field_keyword_daddr,
\    nft_eth_hdr_expr_eth_hdr_field_keyword_saddr,
\    nft_eth_hdr_expr_eth_hdr_field_keyword_type,
\    nft_UnexpectedNumber,
\    nft_chainError

syn cluster nft_c_eth_hdr_expr
\ contains=
\    nft_eth_hdr_expr_eth_hdr_field_keyword_daddr,
\    nft_eth_hdr_expr_eth_hdr_field_keyword_saddr,
\    nft_eth_hdr_expr_eth_hdr_field_keyword_type
