" File: integer_expr.vim
"
" Called by: primary_expr
" Called by: primary_rhs_expr
" Called by: primary_stmt_expr
" Called by: queue_expr
" Called by: queue_stmt_expr_simple
" Called by: reject_with_expr

hi link   nft_primary_expr_integer_expr_num_u32 nftHL_Integer
syn match nft_primary_expr_integer_expr_num_u32 '\v((0[xX][0-9a-fA-F]{1,8})|(429496729[0-5])|4294967[0-1][0-9][0-9]|429496[0-6][0-9][0-9][0-9]|42949[0-5][0-9]{4}|429[0-3][0-9]{6}|4[0-1][0-9]{8}|[0-3][0-9]{9}|[0-9]{1,8})\ze[ \t\n;]' skipwhite contained
