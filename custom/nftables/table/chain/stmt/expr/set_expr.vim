" File: set_expr.vim
"
" referenced by:
"    expr
"    map_stmt_expr_set
"    rhs_expr
"    set_block_expr
"    set_list_member_expr"


syn cluster nft_c_set_list_member_expr
\ contains=
\    @nft_c_set_expr,
\    nft_primary_rhs_expr,
\    nft_set_elem_expr

hi link    nft_set_expr_block_delimiters nftHL_BlockDelimiterMap
syn region nft_set_expr_block_delimiters start=+{+ end=+}+ skipwhite contained
\ contains=
\    @nft_c_set_list_member_expr

syn cluster nft_c_set_expr
\ contains=
\    nft_set_expr_block_delimiters