

" base_cmd_add_cmd 'limit' <table_id> <limit_id> limit_block
hi link    nft_add_cmd_limit_limit_block nftHL_BlockDelimitersLimit
syn region nft_add_cmd_limit_limit_block start=+{+ end=+}+ keepend skipwhite contained
\ contains=
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_comment_spec_keyword_comment,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_add_cmd_keyword_limit_limit_config_keyword_rate,
\    nft_Error
\ nextgroup=nft_line_separator