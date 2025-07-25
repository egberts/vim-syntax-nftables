
hi link   nft_flowtable_expr_comma nftHL_Expression
syn match nft_flowtable_expr_comma "," skipwhite contained

syn match nft_flowtable_expr_string "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained

hi link    nft_flowtable_expr_quoted_string_single nftHL_Expression
syn region nft_flowtable_expr_quoted_string_single start="\'" end="\'" skip="\\\'" skipwhite contained
\ contains=
\    nft_flowtable_expr_string
\ nextgroup=
\    nft_flowtable_expr_comma

hi link    nft_flowtable_expr_quoted_string_double nftHL_Expression
syn region nft_flowtable_expr_quoted_string_double start="\"" end="\"" skip="\\\"" skipwhite contained
\ contains=
\    nft_flowtable_expr_string
\ nextgroup=
\    nft_flowtable_expr_comma

hi link   nft_flowtable_expr_variable_expr nftHL_Element
syn match nft_flowtable_expr_variable_expr "\v\$[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_flowtable_expr_comma

syn cluster nft_c_flowtable_expr_member
\ contains=
\    nft_flowtable_expr_variable_expr,
\    nft_flowtable_expr_quoted_string_single,
\    nft_flowtable_expr_quoted_string_double,
\    nft_flowtable_expr_string

hi link    nft_flowtable_expr_block nftHL_BlockDelimitersFlowtable
syn region nft_flowtable_expr_block start="{" end="}" skipwhite contained
\ contains =
\    @nft_c_flowtable_expr_member

hi link   nft_flowtable_expr_variable nftHL_Variable
syn match nft_flowtable_expr_variable "\v\$[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained


