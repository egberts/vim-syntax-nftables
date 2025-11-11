

hi link   nft_vlan_hdr_expr_close_scope_vlan_constant_expr_int_hex_1b nftHL_Integer
syn match nft_vlan_hdr_expr_close_scope_vlan_constant_expr_int_hex_1b '\v((0x[0-1]{1})|([0-1]{1}))\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_vlan_hdr_expr_close_scope_vlan_constant_expr_int_hex_3b nftHL_Integer
syn match nft_vlan_hdr_expr_close_scope_vlan_constant_expr_int_hex_3b '\v((0x[0-7]{1})|([0-7]{1}))\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_vlan_hdr_expr_close_scope_vlan_constant_expr_int_hex_7b nftHL_Integer
syn match nft_vlan_hdr_expr_close_scope_vlan_constant_expr_int_hex_7b '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3})\ze[ \t\n])' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_vlan_hdr_expr_close_scope_vlan_constant_expr_int_hex_12b nftHL_Integer
syn match nft_vlan_hdr_expr_close_scope_vlan_constant_expr_int_hex_12b '\v((0x[0-9a-fA-F]{1,3})|([0-9]{1,4}))' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_vlan_hdr_expr_vlan_hdr_field_keyword_type nftHL_Substatement
syn match nft_vlan_hdr_expr_vlan_hdr_field_keyword_type '\vtype' skipwhite contained
\ nextgroup=
\    nft_vlan_hdr_expr_close_scope_vlan_constant_expr_int_hex_7b,
\    nft_Error

hi link   nft_vlan_hdr_expr_vlan_hdr_field_keyword_cfi nftHL_Substatement
syn match nft_vlan_hdr_expr_vlan_hdr_field_keyword_cfi '\vcfi' skipwhite contained
\ nextgroup=
\    nft_vlan_hdr_expr_close_scope_vlan_constant_expr_int_hex_1b,
\    nft_Error

hi link   nft_vlan_hdr_expr_vlan_hdr_field_keyword_dei nftHL_Substatement
syn match nft_vlan_hdr_expr_vlan_hdr_field_keyword_dei '\vdei' skipwhite contained
\ nextgroup=
\    nft_vlan_hdr_expr_close_scope_vlan_constant_expr_int_hex_1b,
\    nft_Error

hi link   nft_vlan_hdr_expr_vlan_hdr_field_keyword_pcp nftHL_Substatement
syn match nft_vlan_hdr_expr_vlan_hdr_field_keyword_pcp '\pcp' skipwhite contained
\ nextgroup=
\    nft_vlan_hdr_expr_close_scope_vlan_constant_expr_int_hex_3b,
\    nft_Error

hi link   nft_vlan_hdr_expr_vlan_hdr_field_keyword_id nftHL_Substatement
syn match nft_vlan_hdr_expr_vlan_hdr_field_keyword_id '\vid' skipwhite contained
\ nextgroup=
\    nft_vlan_hdr_expr_close_scope_vlan_constant_expr_int_hex_12b,
\    nft_Error

hi link   nft_vlan_hdr_expr_keyword_vlan nftHL_Statement
syn match nft_vlan_hdr_expr_keyword_vlan '\vvlan' skipwhite contained
\  nextgroup=
\    nft_vlan_hdr_expr_vlan_hdr_field_keyword_type,
\    nft_vlan_hdr_expr_vlan_hdr_field_keyword_cfi,
\    nft_vlan_hdr_expr_vlan_hdr_field_keyword_dei,
\    nft_vlan_hdr_expr_vlan_hdr_field_keyword_pcp,
\    nft_vlan_hdr_expr_vlan_hdr_field_keyword_id,
\    nft_chainError