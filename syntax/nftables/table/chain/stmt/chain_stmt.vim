


syn region nft_chain_stmt_block_delimiters start=+{+ end=+}+ skipwhite contained
\ contains=
\    @nft_c_stmt
\ nextgroup=
\    nft_stmt_separator

hi link   nft_chain_stmt_chain_stmt_type_keyword_goto nftHL_Statement
syn match nft_chain_stmt_chain_stmt_type_keyword_goto '\vgoto\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_chain_stmt_block_delimiters
" this overlaps with nft_verdict_stmt_verdict_expr_keyword_goto

hi link   nft_chain_stmt_chain_stmt_type_keyword_jump nftHL_Statement
syn match nft_chain_stmt_chain_stmt_type_keyword_jump '\vjump\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_chain_stmt_block_delimiters
" this overlaps with nft_verdict_stmt_verdict_expr_keyword_jump
