"
" jhash { ip saddr | ip6 daddr | tcp dport | udp sport | ether saddr } […] mod NUM [ seed NUM ] [ offset NUM ]
" symhash mod NUM [ offset NUM ]




" hash_expr (via hash_hdr_expr)
hi link   nft_hash_expr_offset_opt_num nftHL_Integer
syn match nft_hash_expr_offset_opt_num '\v[0-9]{1,10}\ze[ \t\n;]' skipwhite contained

hi link   nft_hash_expr_offset_opt_keyword_offset nftHL_Keyword
syn match nft_hash_expr_offset_opt_keyword_offset '\voffset\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_hash_expr_offset_opt_num,
\    nft_Error

hi link   nft_hash_expr_keyword_seed nftHL_Keyword
syn match nft_hash_expr_keyword_seed '\vseed\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_hash_expr_offset_opt_num,
\    nft_Error

hi link   nft_hash_expr_num_second nftHL_Integer
syn match nft_hash_expr_num_second '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_hash_expr_offset_opt_keyword_offset,
\    nft_hash_expr_keyword_seed_num,
\    nft_Error


" hash_expr 'symhash' 'mod' (via primary_expr)
hi link   nft_hash_expr_keyword_mod nftHL_Substatement
syn match nft_hash_expr_keyword_mod '\vmod\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_hash_expr_num_second,
\    nft_Error

" hash_expr 'jhash' (via primary_expr)
hi link   nft_payload_expr_hash_expr_keyword_jhash nftHL_Substatement
syn match nft_payload_expr_hash_expr_keyword_jhash '\vjhash\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_expr,

" hash_expr 'symhash' (via primary_expr)
hi link   nft_payload_expr_hash_expr_keyword_symhash nftHL_Substatement
syn match nft_payload_expr_hash_expr_keyword_symhash '\vsymhash\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_hash_expr_keyword_mod,
\    nft_Error
