


" quota_unit->quota_config->(add_cmd|create_cmd|quota_block)
hi link   nft_quota_config_quota_unit nftHL_Unit
syn match nft_quota_config_quota_unit "\v(([MmKkGg])?bytes|string)" skipwhite contained
\ nextgroup=
\    nft_quota_config_quota_used

" num->->quota_config->(add_cmd|create_cmd|quota_block)
hi link   nft_quota_config_num nftHL_Number
syn match nft_quota_config_num "\v[0-9]{1,11}\ze[ \t\n;]" skipwhite contained
\ nextgroup=
\    nft_quota_config_quota_unit

" 'over'->quota_config->(add_cmd|create_cmd|quota_block)
hi link   nft_quota_config_quota_mode_keyword_over nftHL_Keyword
syn match nft_quota_config_quota_mode_keyword_over "\vover\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_quota_config_num

hi link   nft_quota_config_quota_mode_keyword_until nftHL_Keyword
syn match nft_quota_config_quota_mode_keyword_until "\vuntil\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_quota_config_num

" 'until'->quota_config->(add_cmd|create_cmd|quota_block)
" quota_config->(add_cmd|create_cmd|quota_block)
syn cluster nft_c_quota_config
\ contains=
\    nft_quota_config_quota_mode_keyword_until,
\    nft_quota_config_quota_mode_keyword_over,
\    nft_quota_config_num
