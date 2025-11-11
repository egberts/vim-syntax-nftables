


hi link   nft_xfrm_expr_xfrm_dir_keyword_out nftHL_Operator
syn match nft_xfrm_expr_xfrm_dir_keyword_out '\vout\ze[ \t\{]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_named_set_identifier,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_spnum,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_reqid,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_spi,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_block,
\    nft_Error

hi link   nft_xfrm_expr_xfrm_dir_keyword_in nftHL_Operator
syn match nft_xfrm_expr_xfrm_dir_keyword_in '\vin\ze[ \t\{]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_named_set_identifier,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_spnum,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_reqid,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_spi,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_block,
\    nft_Error

hi link   nft_xfrm_expr_keyword_ipsec nftHL_Error
syn match nft_xfrm_expr_keyword_ipsec '\vipsec\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_xfrm_expr_xfrm_dir_keyword_out,
\    nft_xfrm_expr_xfrm_dir_keyword_in,
\    nft_Error