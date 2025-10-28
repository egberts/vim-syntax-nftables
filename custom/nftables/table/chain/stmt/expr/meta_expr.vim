" File: meta_expr.vim
" Directory: custom/nftables/table/chain/stmt/expr/
"
let s:meta_expr_list_filepaths_semantic_early = []
let s:meta_expr_list_filepaths_semantic_later = []

if exists('b:did_nftables_meta_expr')
  call nftables#syntax#log('INFO', 'Skipped meta_expr (already loaded for buffer: ' . bufname('%') . ')')
  finish
endif

" save the filespec of this script into a stack for logging purpose
let s:filepath_this_script = resolve(expand('<sfile>:p'))
call nftables#syntax#push(s:filepath_this_script)
" now we can use nftables#syntax#log()

call nftables#syntax#log('OK', 'Begin.')

" BEGIN OF 'syntax' statements
"
try
  " non-terminal semantic action processing
  for s:this_semantic_file in s:meta_expr_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading meta_expr syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
" ************************ BEGIN meta_expr ***************************
hi link   nft_interface_type_identifier_at_setname nftHL_AtSetname
syn match nft_interface_type_identifier_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}[\ze[ \t;]' skipwhite contained

hi link   nft_interface_type_set_symbol_comma nftHL_elements
syn match nft_interface_type_set_symbol_comma '\v,' contained
\ nextgroup=
\    nft_interface_type_listed_number

hi link   nft_interface_type_listed_number nftHL_Integer
syn match nft_interface_type_listed_number '\v[0-9]{1,3}' contained
\ nextgroup=
\    nft_interface_type_set_symbol_comma

hi link   nft_interface_set_type_number nftHL_Integer
syn match nft_interface_set_type_number '\v(0x[0-9A-Fa-f]{1,8}|(429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}))\ze[ \t\n,]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_interface_type_number nftHL_Integer
syn match nft_interface_type_number '\v(0x([A-Fa-f0-9]{1,4}|[A-Fa-f]{2}[0-9]{2}|[A-Fa-f0-9]{1,4})|6553[0-5]|655[0-2][0-9]|65[0-4][0-9][0-9]|6[0-4][0-9][0-9][0-9]|[1-5][0-9]{4}|[0-9]{1,4})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_interface_type_operators nftHL_Operator
syn match nft_interface_type_operators '\v(\!|\=)\=' skipwhite contained
\ nextgroup=
\    nft_interface_type_identifier_at_setname,
\    nft_interface_type_set_block,
\    nft_interface_type_number,
\    nft_Error

hi link   nft_interface_type_operators_discrete nftHL_Operator
syn match nft_interface_type_operators_discrete '\v(\<|\>)\=' skipwhite contained
\ nextgroup=
\    nft_interface_type_number,
\    nft_Error

hi link    nft_interface_type_inline_set nftHL_BlockDelimitersSet
syn region nft_interface_type_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_interface_set_type_number
\ nextgroup=
\    @nft_c_stmt

hi link   nft_interface_type_operators_keyword_in nftHL_Operator
syn match nft_interface_type_operators_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_interface_type_identifier_at_setname,
\    nft_interface_type_inline_set,
\    nft_Error

hi link   nft_interface_type_operators_prefix_keyword_not nftHL_Operator
syn match nft_interface_type_operators_prefix_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_datatype_iface_type,
\    nft_interface_type_operators_keyword_in,
\    nft_interface_type_identifier_at_setname,
\    nft_interface_type_number,
\    nft_Error

syn cluster nft_c_interface_type
\ contains=
\    nft_interface_type_operators_prefix_keyword_not,
\    nft_interface_type_operators_discrete,
\    nft_interface_type_operators_keyword_in,
\    nft_interface_type_operators,
\    nft_interface_type_identifier_at_setname,
\    nft_interface_type_inline_set,
\    nft_interface_type_number,

" ***************** BEGIN meta_expr ***************
" If it's followed by a set, it's likely meta_stmt. If it's
" followed by a field name and then a comparison (==, <, etc.),
" it's meta_expr.
" meta_stmt is followed by a set.
" meta_expr is followed by a comparison.
" meta_expr is followed by a field name.

syn match nft_meta_expr_mark_missing '\v\ze[ \t]*[;\n]'  contained
hi link   nft_meta_expr_mark_missing nftHL_Error

hi link   nft_socket_t_quoted_string nftHL_String
syn match nft_socket_t_quoted_string '\v\'[^\']{0,63}\'' skipwhite contained
syn match nft_socket_t_quoted_string '\v\"[^\"]{0,63}\"' skipwhite contained

hi link   nft_socket_t_integer nftHL_Integer
syn match nft_socket_t_integer '\v[0-9]{1,10}' skipwhite contained
syn match nft_socket_t_integer '\v0x[0-9a-f]{1,8}' skipwhite contained

hi link   nft_meta_expr_close_scope_meta_socketid_integer_expr_uint32_hex nftHL_Integer
syn match nft_meta_expr_close_scope_meta_socketid_integer_expr_uint32_hex '\v0x[0-9a-fA-F]{1,8}|429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}\ze[ \t\n;]' skipwhite contained

hi link   nft_socket_t_operators_relational_1char nftHL_Operator
syn match nft_socket_t_operators_relational_1char '\v(\<|\>)' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_socketid_integer_expr_uint32_hex, nft_Error

hi link   nft_socket_t_operators_equality nftHL_Operator
syn match nft_socket_t_operators_equality '\v(\!|\=)\=' skipwhite contained
\ nextgroup=
\    nft_socket_t_named_set,
\    nft_socket_t_set_block,
\    nft_socket_t_quoted_string,
\    nft_meta_expr_close_scope_meta_socketid_integer_expr_uint32_hex,
\    nft_Error

hi link   nft_socket_t_operators_relational_2char nftHL_Operator
syn match nft_socket_t_operators_relational_2char '\v(\<|\>)\=' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_socketid_integer_expr_uint32_hex, nft_Error

hi link   nft_meta_expr_close_scope_meta_socket_integer_expr_uint32_hex nftHL_Integer
syn match nft_meta_expr_close_scope_meta_socket_integer_expr_uint32_hex '\v0x[0-9a-fA-F]{1,8}|429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_socket_t_operators_relational_2char,
\    nft_socket_t_operators_equality,
\    nft_socket_t_operators_relational_1char

hi link   nft_socket_t_operator_mask nftHL_Operator
syn match nft_socket_t_operator_mask '\v\&' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_socket_integer_expr_uint32_hex,
\    nft_Error
hi link   nft_socket_t_set_block_elements_integer nftHL_Integer
syn match nft_socket_t_set_block_elements_integer '\v[0-9]{1,10}' skipwhite contained
syn match nft_socket_t_set_block_elements_integer '\v0x[0-9a-f]{1,8}' skipwhite contained
\ nextgroup=
\    nft_socket_t_set_block_elements_separator,
\    nft_Error

hi link   nft_socket_t_set_block_elements_separator nftHL_Separator
syn match nft_socket_t_set_block_elements_separator /,/ skipwhite contained
\ nextgroup=
\    nft_socket_t_set_block_elements_integer

hi link    nft_socket_t_set_block nftHL_BlockDelimitersSet
syn region nft_socket_t_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_socket_t_set_block_elements_integer,
\    nft_Error

hi link   nft_socket_t_named_set nftHL_AtSetname
syn match nft_socket_t_named_set '\v\@[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_socket_t_set_membership_keyword_in nftHL_Operator
syn match nft_socket_t_set_membership_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_socket_t_named_set,
\    nft_socket_t_set_block,
\    nft_meta_expr_close_scope_meta_socketid_integer_expr_uint32_hex,
\    nft_Error

hi link   nft_socket_t_set_membership_prefix_keyword_not nftHL_Operator
syn match nft_socket_t_set_membership_prefix_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_socket_t_set_membership_keyword_in,
\    nft_socket_t_named_set,
\    nft_socket_t_quoted_string,
\    nft_meta_expr_close_scope_meta_socketid_integer_expr_uint32_hex,
\    nft_Error

syn cluster nft_c_socket_t
\ contains=
\    nft_socket_t_set_membership_prefix_keyword_not,
\    nft_socket_t_set_membership_keyword_in,
\    nft_socket_t_operators_equality,
\    nft_socket_t_operators_relational_2char,
\    nft_socket_t_operator_mask,
\    nft_socket_t_operators_discrete_only_1char,
\    nft_socket_t_operators_relational_1char,
\    nft_socket_t_named_set,
\    nft_socket_t_quoted_string,
\    nft_meta_expr_close_scope_meta_socketid_integer_expr_uint32_hex,

hi link   nft_hour_type_integer nftHL_Integer
syn match nft_hour_type_integer '\v[0-9]{1,10}\ze[ \t;]' skipwhite contained
syn match nft_hour_type_integer '\v0x[0-9a-fA-F]{1,8}\ze[ \t;]' skipwhite contained

hi link   nft_hour_type_set_block_member_separator nftHL_Integer
syn match nft_hour_type_set_block_member_separator /,/ skipwhite contained
\ nextgroup=
\    nft_hour_type_set_block_member_integer,
\    nft_Error

hi link   nft_hour_type_set_block_member_integer nftHL_Integer
syn match nft_hour_type_set_block_member_integer '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_hour_type_set_block_member_separator
syn match nft_hour_type_set_block_member_integer '\v0x[0-9a-fA-F]{1,8}' skipwhite contained
\ nextgroup=
\    nft_hour_type_set_block_member_separator

hi link    nft_hour_type_set_block nftHL_BlockDelimitersSet
syn region nft_hour_type_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_hour_type_set_block_member_integer

hi link   nft_hour_type_named_set_identifier nftHL_AtSetname
syn match nft_hour_type_named_set_identifier '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_hour_type_operator_set_keyword_in nftHL_Operator
syn match nft_hour_type_operator_set_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_hour_type_set_block,
\    nft_hour_type_named_set_identifier,
\    nft_Error

hi link   nft_hour_type_operator_set_prefix_keyword_not nftHL_Operator
syn match nft_hour_type_operator_set_prefix_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_hour_type_operator_set_keyword_in

hi link   nft_hour_type_operators_relational_1char nftHL_Operator
syn match nft_hour_type_operators_relational_1char '\v(\<|\>)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_hour_type_named_set_identifier,
\    nft_hour_type_set_block,
\    nft_hour_type_integer,
\    nft_Error

hi link   nft_hour_type_operators_equality nftHL_Operator
syn match nft_hour_type_operators_equality '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_hour_type_integer,
\    nft_Error

hi link   nft_hour_type_operators_relational_2char nftHL_Operator
syn match nft_hour_type_operators_relational_2char '\v(\<|\>)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_hour_type_named_set_identifier,
\    nft_hour_type_set_block,
\    nft_hour_type_integer,
\    nft_Error

syn cluster nft_c_hour_type
\ contains=
\    nft_hour_type_operator_set_prefix_keyword_not,
\    nft_hour_type_operator_set_keyword_in,
\    nft_hour_type_operators_relational_2char,
\    nft_hour_type_operators_equality,
\    nft_hour_type_operators_relational_1char,
\    nft_hour_type_integer,


" ************** BEGIN meta_expr 'meta iif' **************************
" nft_c_string must be the LAST contains= (via nft_unquoted_string)
hi link   nft_meta_expr_close_scope_meta_device_index_set_elements_separator nftHL_Separator
syn match nft_meta_expr_close_scope_meta_device_index_set_elements_separator /,/ skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_device_index_set_quoted_identifier,
\    nft_meta_expr_close_scope_meta_device_index_set_number,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_device_index_set_quoted_identifier nftHL_String
syn match nft_meta_expr_close_scope_meta_device_index_set_quoted_identifier '\v\"[a-zA-Z][a-zA-Z0-9\-_]{0,63}\"' skipwhite contained
\ nextgroup= nft_meta_expr_close_scope_meta_device_index_set_elements_separator, nft_Error
\ nextgroup=
\    nft_meta_expr_close_scope_meta_device_index_set_elements_separator,
\    nft_Error

syn match nft_meta_expr_close_scope_meta_device_index_set_quoted_identifier '\v\'[a-zA-Z][a-zA-Z0-9\-_]{0,63}\'' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_device_index_set_elements_separator,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_device_index_set_number nftHL_Integer
syn match nft_meta_expr_close_scope_meta_device_index_set_number '\v(0x[0-9A-Fa-f]{1,8})|(429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9})\ze[ \t\n,]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_device_index_set_elements_separator,
\    nft_Error

hi link    nft_meta_expr_close_scope_meta_device_index_set_block nftHL_BlockDelimitersSet
syn region nft_meta_expr_close_scope_meta_device_index_set_block start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\     nft_meta_expr_close_scope_meta_device_index_set_quoted_identifier,
\     nft_meta_expr_close_scope_meta_device_index_set_number,
\     nft_Error

hi link   nft_meta_expr_close_scope_meta_device_index_at_setname nftHL_AtSetname
syn match nft_meta_expr_close_scope_meta_device_index_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}[\ze[ \t;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_meta_expr_close_scope_meta_device_index_number nftHL_Integer
syn match nft_meta_expr_close_scope_meta_device_index_number '\v(0x[0-9A-Fa-f]{1,8})|(429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_meta_expr_close_scope_meta_device_index_quoted_identifier nftHL_String
syn match nft_meta_expr_close_scope_meta_device_index_quoted_identifier '\v\"[a-zA-Z][a-zA-Z0-9\-_\*]{0,63}\"[\ze[ \t\n;]' skipwhite contained
syn match nft_meta_expr_close_scope_meta_device_index_quoted_identifier '\v\'[a-zA-Z][a-zA-Z0-9\-_\*]{0,63}\'[\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_meta_expr_close_scope_meta_device_index_identifier nftHL_Identifier
syn match nft_meta_expr_close_scope_meta_device_index_identifier '\v[a-zA-Z][a-zA-Z0-9\-_]{0,63}[\ze[ \t;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_interface_name_set_block_elements_string_quoted nftHL_String
syn match nft_interface_name_set_block_elements_string_quoted '\v\"[a-zA-Z][a-zA-Z0-9\-_\*]{0,63}\"' skipwhite contained
\ nextgroup=
\    nft_interface_name_set_elements_separator,
\    @nft_c_stmt,
\    nft_Error

syn match nft_interface_name_set_block_elements_string_quoted '\v\'[a-zA-Z][a-zA-Z0-9\-_\*]{0,63}\'' skipwhite contained
\ nextgroup=
\    nft_interface_name_set_elements_separator,
\    @nft_c_stmt,
\    nft_Error

hi link    nft_interface_name_set_block  nftHL_BlockDelimitersSet
syn region nft_interface_name_set_block start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_interface_name_set_block_elements_string_quoted,
\    nft_Error
" 'any' keyword is not supported inside a set

" equality operators support scalar, inline set
hi link   nft_meta_expr_close_scope_meta_device_index_operators_equality nftHL_Operator
syn match nft_meta_expr_close_scope_meta_device_index_operators_equality '\v(\!|\=)\=' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_device_index_at_setname,
\    nft_meta_expr_close_scope_meta_device_index_quoted_identifier,
\    nft_meta_expr_close_scope_meta_device_index_set_block,
\    nft_meta_expr_close_scope_meta_device_index_identifier,
\    nft_meta_expr_close_scope_meta_device_index_number,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_device_index_set_operator_in nftHL_Operator
syn match nft_meta_expr_close_scope_meta_device_index_set_operator_in '\vin\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_device_index_at_setname,
\    nft_meta_expr_close_scope_meta_device_index_set_block,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_device_index_operator_prefix_keyword_not nftHL_Operator
syn match nft_meta_expr_close_scope_meta_device_index_operator_prefix_keyword_not '\vnot\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_device_index_set_operator_in,
\    nft_meta_expr_close_scope_meta_device_index_set_block,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_device_index_keyword_any nftHL_Operator
syn match nft_meta_expr_close_scope_meta_device_index_keyword_any '\vany\ze[ \t;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_blind_interface nftHL_Define
syn match nft_blind_interface '\vlo|[a-z]{1,3}[0-9]{1,2}([a-z]{1,2}[0-9]{1,2}){0,1}' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_meta_expr_meta_key_unqualified_keyword_iif nftHL_Statement
syn match nft_meta_expr_meta_key_unqualified_keyword_iif '\viif\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_device_index_keyword_any,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_meta_expr_close_scope_meta_device_index_operator_prefix_keyword_not,
\    nft_meta_expr_close_scope_meta_device_index_operators_equality,
\    nft_meta_expr_close_scope_meta_device_index_set_operator_in,
\    nft_meta_expr_close_scope_meta_device_index_quoted_identifier,
\    nft_interface_name_set_block,
\    nft_meta_expr_close_scope_meta_device_index_number,
\    nft_blind_interface
" No error handler here, 'iif' is also a standalone statement keyword

hi link   nft_primary_rhs_expr_symbol_expr_variable_expr_identifier nftHL_Variable
syn match nft_primary_rhs_expr_symbol_expr_variable_expr_identifier '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_iif nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_iif '\viif\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_meta_expr_close_scope_meta_device_index_keyword_any,
\    nft_map_expr_keyword_map,
\    nft_meta_expr_close_scope_meta_device_index_operator_prefix_keyword_not,
\    nft_meta_expr_close_scope_meta_device_index_operators_equality,
\    nft_meta_expr_close_scope_meta_device_index_set_operator_in,
\    nft_meta_expr_close_scope_meta_device_index_quoted_identifier,
\    nft_interface_name_set_block,
\    nft_primary_rhs_expr_symbol_expr_variable_expr_identifier,
\    nft_meta_expr_close_scope_meta_device_index_identifier,
\    nft_meta_expr_close_scope_meta_device_index_number,
" No error handler here, 'iif' is also a standalone statement keyword
" **************** END meta_expr 'meta iif' **************************

" ************** BEGIN meta_expr 'meta oif' **************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_oif nftHL_Statement
syn match nft_meta_expr_meta_key_unqualified_keyword_oif '\voif\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_device_index_keyword_any,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_meta_expr_close_scope_meta_device_index_operator_prefix_keyword_not,
\    nft_meta_expr_close_scope_meta_device_index_operators_equality,
\    nft_meta_expr_close_scope_meta_device_index_set_operator_in,
\    nft_meta_expr_close_scope_meta_device_index_quoted_identifier,
\    nft_interface_name_set_block,
\    nft_primary_rhs_expr_symbol_expr_variable_expr_identifier,
\    nft_meta_expr_close_scope_meta_device_index_identifier,
\    nft_meta_expr_close_scope_meta_device_index_number,
\    nft_blind_interface
" No error handler here, 'oif' is also a standalone statement keyword

hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_oif nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_oif '\voif\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_device_index_keyword_any,
\    nft_meta_expr_close_scope_meta_device_index_operator_prefix_keyword_not,
\    nft_meta_expr_close_scope_meta_device_index_operators_equality,
\    nft_meta_expr_close_scope_meta_device_index_set_operator_in,
\    nft_meta_expr_close_scope_meta_device_index_quoted_identifier,
\    nft_meta_expr_close_scope_meta_device_index_identifier,
\    nft_meta_expr_close_scope_meta_device_index_number
" No error handler here, 'oif' is also a standalone statement keyword

syn cluster nft_c_device_index
\ contains=
\    nft_meta_expr_close_scope_meta_device_index_keyword_any,
\    nft_meta_expr_close_scope_meta_device_index_operator_prefix_keyword_not,
\    nft_meta_expr_close_scope_meta_device_index_operators_equality,
\    nft_meta_expr_close_scope_meta_device_index_set_operator_in,
\    nft_meta_expr_close_scope_meta_device_index_quoted_identifier,
\    nft_meta_expr_close_scope_meta_device_index_identifier,
\    nft_meta_expr_close_scope_meta_device_index_number,
" **************** END meta_expr 'meta oif' **************************


" **************** BEGIN meta_expr 'meta rtclassid' ******************
" 'meta' keyword is almost always followed by a value (except for 'random', 'nftrace', 'ipsec')
hi link   nft_meta_expr_close_scope_meta_rtclassid_integer_id nftHL_Integer
syn match nft_meta_expr_close_scope_meta_rtclassid_integer_id '\v(0x[0-9A-Fa-f]{1,8})|(429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9})\ze[ \t\n;]' skipwhite contained

hi link   nft_meta_expr_close_scope_meta_rtclassid_at_setname nftHL_AtSetname
syn match nft_meta_expr_close_scope_meta_rtclassid_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t;]' skipwhite contained

hi link   nft_meta_expr_close_scope_meta_rtclassid_enum_any nftHL_Define
syn match nft_meta_expr_close_scope_meta_rtclassid_enum_any '\vany\ze[ \t\n;]' skipwhite contained

" ****************** BEGIN meta_expr 'rtclassid' ******************
hi link   nft_meta_expr_meta_key_unqualified_keyword_rtclassid nftHL_Error
syn match nft_meta_expr_meta_key_unqualified_keyword_rtclassid '\vrtclassid' skipwhite contained
\ nextgroup=
\    nft_Error
" ****************** END meta_expr 'rtclassid' ******************
hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_rtclassid nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_rtclassid '\vrtclassid\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_rtclassid_enum_any,
\    nft_meta_expr_close_scope_meta_rtclassid_integer_id,
\    nft_meta_expr_close_scope_meta_rtclassid_at_setname,
\    nft_Error
" ****************** END meta_expr 'meta rtclassid' ******************

" **************** BEGIN meta_expr 'meta ibriport' *******************
hi link   nft_briport_index_integer nftHL_Integer
syn match nft_briport_index_integer '\v(([0-9]{1,20})|(0x[0-9a-fA-F]{1,8}))\ze[ \t\n;]' skipwhite contained

hi link   nft_briport_index_set_block_member_separator nftHL_Separator
syn match nft_briport_index_set_block_member_separator /,/ skipwhite contained
\ nextgroup=
\    nft_briport_index_set_block_member_integer,
\    nft_Error

hi link   nft_briport_index_set_block_member_integer nftHL_Integer
syn match nft_briport_index_set_block_member_integer '\v(([0-9]{1,20})|(0x[0-9a-fA-F]{1,8}))\ze[ \t\n,]' skipwhite contained
\ nextgroup=
\    nft_briport_index_set_block_member_separator

hi link    nft_briport_index_set_block nftHL_BlockDelimitersSet
syn region nft_briport_index_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_briport_index_set_block_member_integer

hi link   nft_briport_index_named_set_identifier nftHL_AtSetname
syn match nft_briport_index_named_set_identifier '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained

hi link   nft_briport_index_operator_set_keyword_in nftHL_Operator
syn match nft_briport_index_operator_set_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_briport_index_set_block,
\    nft_briport_index_named_set_identifier,
\    nft_Error

hi link   nft_briport_index_operator_set_prefix_keyword_not nftHL_Operator
syn match nft_briport_index_operator_set_prefix_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_briport_index_operator_set_keyword_in

hi link   nft_briport_index_operators_relational_1char nftHL_Operator
syn match nft_briport_index_operators_relational_1char '\v(\<|\>)' skipwhite contained
\ nextgroup=
\    nft_briport_index_integer,
\    nft_Error

hi link   nft_briport_index_operators_equality nftHL_Operator
syn match nft_briport_index_operators_equality '\v(\!|\=)\=' skipwhite contained
\ nextgroup=
\    nft_briport_index_named_set_identifier,
\    nft_briport_index_set_block,
\    nft_briport_index_integer,
\    nft_Error

hi link   nft_briport_index_operators_relational_2char nftHL_Operator
syn match nft_briport_index_operators_relational_2char '\v(\<|\>)\=' skipwhite contained
\ nextgroup=
\    nft_briport_index_integer,
\    nft_Error

syn cluster nft_c_meta_expr_close_scope_meta_briport
\ contains=
\    nft_briport_index_operator_set_prefix_keyword_not,
\    nft_briport_index_operator_set_keyword_in,
\    nft_briport_index_operators_relational_2char,
\    nft_briport_index_operator_set_keyword_equality,
\    nft_briport_index_operators_relational_1char,
\    nft_briport_index_operators_equality,
\    nft_briport_index_integer,
\    nft_Error
" **************** BEGIN meta_expr 'ibriport' *******************
hi link   nft_meta_expr_meta_key_unqualified_keyword_ibriport nftHL_Error
syn match nft_meta_expr_meta_key_unqualified_keyword_ibriport '\vibriport' skipwhite contained
\ nextgroup=
\    nft_Error
" ****************** END meta_expr 'ibriport' ******************
hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_ibriport nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_ibriport '\vibriport\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_meta_expr_close_scope_meta_briport,
\    nft_Error
" ****************** END meta_expr 'meta ibriport' *******************

" **************** BEGIN meta_expr 'meta iifgroup' *******************
hi link   nft_interface_group_index nftHL_Integer
syn match nft_interface_group_index '\v(0x[0-9A-Fa-f]{1,8})|(429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9})\ze[ \t\n;]' skipwhite contained
" 'meta iifgroup 42' value is set by 'ip link set dev eth0 group 42' CLI command
hi link   nft_ifgroup_index_integer nftHL_Integer
syn match nft_ifgroup_index_integer '\v(0x[0-9A-Fa-f]{1,8})|(429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9})\ze[ \t\n;]' skipwhite contained

syn cluster nft_c_ifgroup_index
\ contains=
\    nft_ifgroup_index_operator_set_prefix_keyword_not,
\    nft_ifgroup_index_operator_set_keyword_in,
\    nft_ifgroup_index_operators_relational_2char,
\    nft_ifgroup_index_operator_set_keyword_equality,
\    nft_ifgroup_index_operators_relational_1char,
\    nft_ifgroup_index_operators_equality,
\    nft_ifgroup_index_integer
" **************** BEGIN meta_expr 'iifgroup' *******************
hi link   nft_meta_expr_meta_key_unqualified_keyword_iifgroup nftHL_Error
syn match nft_meta_expr_meta_key_unqualified_keyword_iifgroup '\viifgroup' skipwhite contained
\ nextgroup=
\    nft_Error
" ****************** END meta_expr 'iifgroup' *******************
hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_iifgroup nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_iifgroup '\viifgroup\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ifgroup_index_operator_set_prefix_keyword_not,
\    nft_ifgroup_index_operator_set_keyword_in,
\    nft_ifgroup_index_operators_relational_2char,
\    nft_ifgroup_index_operator_set_keyword_equality,
\    nft_ifgroup_index_operators_relational_1char,
\    nft_ifgroup_index_operators_equality,
\    nft_ifgroup_index_integer,
\    nft_Error
" ****************** END meta_expr 'meta iifgroup' *******************

" **************** BEGIN meta_expr 'meta obriport' *******************
" **************** BEGIN meta_expr 'obriport' *******************
hi link   nft_meta_expr_meta_key_unqualified_keyword_obriport nftHL_Error
syn match nft_meta_expr_meta_key_unqualified_keyword_obriport '\vobriport' skipwhite contained
\ nextgroup=
\    nft_Error
" ****************** END meta_expr 'obriport' *******************
hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_obriport nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_obriport '\vobriport\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_meta_expr_close_scope_meta_briport,
\    nft_Error
" ****************** END meta_expr 'meta obriport' *******************

" ********************** BEGIN 'meta oifgroup' ***********************
" ********************** BEGIN 'oifgroup' ***********************
hi link   nft_meta_expr_meta_key_unqualified_keyword_oifgroup nftHL_Error
syn match nft_meta_expr_meta_key_unqualified_keyword_oifgroup '\voifgroup' skipwhite contained
\ nextgroup=
\    nft_Error
" ************************ END 'oifgroup' ***********************
hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_oifgroup nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_oifgroup '\voifgroup\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_ifgroup_index,
\    nft_Error
" ************************ END 'meta oifgroup' ***********************

" ********************** BEGIN 'meta priority' ***********************
hi link   nft_meta_expr_meta_key_meta_key_qualified_priority_keyword_none nftHL_Define
syn match nft_meta_expr_meta_key_meta_key_qualified_priority_keyword_none '\vnone\ze[ \t;]' skipwhite contained

hi link   nft_meta_expr_meta_key_meta_key_qualified_priority_number nftHL_Integer
syn match nft_meta_expr_meta_key_meta_key_qualified_priority_number '\v((0[xX][0-9a-fA-F]{1,8})|(429496729[0-5])|4294967[0-1][0-9][0-9]|429496[0-6][0-9][0-9][0-9]|42949[0-5][0-9]{4}|429[0-3][0-9]{6}|4[0-1][0-9]{8}|[0-3][0-9]{9}|[0-9]{1,8})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_stmt_separator,
\    nft_Error

hi link   nft_meta_expr_priority_set_block_elements_separator nftHL_Separator
syn match nft_meta_expr_priority_set_block_elements_separator /,/ skipwhite contained
\ nextgroup=
\    nft_meta_expr_priority_set_block_elements_protocol_types,
\    nft_meta_expr_priority_set_block_elements_protocol_number,
\    nft_Error

hi link   nft_meta_expr_priority_set_block_elements_protocol_number nftHL_Integer
syn match nft_meta_expr_priority_set_block_elements_protocol_number '\v[0-9]{1,5}' skipwhite contained
syn match nft_meta_expr_priority_set_block_elements_protocol_number '\v\c0x[0-9a-f]{1,4}' skipwhite contained
\ nextgroup= nft_meta_expr_priority_set_block_elements_separator, nft_Error

hi link   nft_meta_expr_priority_set_block_elements_protocol_types nftHL_Identifier
syn match nft_meta_expr_priority_set_block_elements_protocol_types '\v(loopback|mpls_mc|mpls_uc|(802_1q)|pppoe|lldp|qinq|arp|ip6|ip)' skipwhite contained

hi link    nft_meta_expr_priority_set_block nftHL_BlockDelimitersSet
syn region nft_meta_expr_priority_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\     nft_meta_expr_priority_set_block_elements_protocol_identifier,
\     nft_meta_expr_priority_set_block_elements_protocol_types,
\     nft_meta_expr_priority_set_block_elements_protocol_number,
\     nft_Error

hi link   nft_meta_expr_priority_any nftHL_Operator
syn match nft_meta_expr_priority_any '\vany\ze[ \t;]' skipwhite contained

hi link   nft_meta_expr_priority_identifier nftHL_Identifier
syn match nft_meta_expr_priority_identifier '\v(loopback|mpls_mc|mpls_uc|(802_1q)|pppoe|lldp|qinq|any|arp|ip6|ip)' skipwhite contained
\ contains=nft_meta_expr_priority_any

hi link   nft_meta_expr_priority_operators_1char nftHL_Operator
syn match nft_meta_expr_priority_operators_1char '\v(\<|\>)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_priority_identifier,
\    nft_meta_expr_priority_set_block,
\    nft_meta_expr_priority_set_identifier,
\    nft_meta_expr_meta_key_meta_key_qualified_priority_number,
\    nft_Error

hi link   nft_meta_key_qualified_priority_operators_discrete nftHL_Operator
syn match nft_meta_key_qualified_priority_operators_discrete '\v(\<|\>)\=' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_meta_key_qualified_priority_number,
\    nft_Error

hi link   nft_meta_expr_priority_operators_2char nftHL_Operator
syn match nft_meta_expr_priority_operators_2char '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_priority_identifier,
\    nft_meta_expr_priority_set_block,
\    nft_meta_expr_meta_key_meta_key_qualified_priority_number,
\    nft_Error

hi link   nft_meta_expr_priority_set_operator_in nftHL_Operator
syn match nft_meta_expr_priority_set_operator_in '\vin\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_priority_set_identifier,
\    nft_meta_expr_priority_set_block,
\    nft_Error

syn cluster nft_c_priority
\ contains=
\    nft_meta_key_qualified_priority_operators_discrete,
\    nft_meta_expr_meta_key_meta_key_qualified_priority_keyword_none,
\    nft_meta_expr_priority_operators_2char,
\    nft_meta_expr_priority_set_operator_in,
\    nft_meta_expr_priority_operators_1char,
\    nft_meta_expr_priority_identifier,
\    nft_meta_expr_meta_key_meta_key_qualified_priority_number,

" **************** BEGIN meta_expr 'priority' *********************
hi link   nft_meta_expr_meta_key_qualified_keyword_priority nftHL_Error
syn match nft_meta_expr_meta_key_qualified_keyword_priority '\vpriority' skipwhite contained
\ nextgroup=
\    nft_Error
" **************** END meta_expr 'priority' *********************
hi link   nft_meta_expr_meta_key_meta_key_qualified_keyword_priority nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_qualified_keyword_priority '\vpriority\ze[ \t]' skipwhite contained
\ nextgroup= @nft_c_priority,
\    nft_Error
" **************** END meta_expr 'meta priority' *********************


" ******************** BEGIN 'meta protocol' *************************
" Ummm, that is NOT Layer-2 protocol here; as in not 'l2proto'
" This used to be 'l4proto'
hi link   nft_meta_expr_close_scope_meta_protocol_set_expr_delimiters_elements_separator nftHL_Separator
syn match nft_meta_expr_close_scope_meta_protocol_set_expr_delimiters_elements_separator /,/ skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_protocol_set_expr_delimiters_elements_protocol_types,
\    nft_meta_expr_close_scope_meta_protocol_set_expr_delimiters_elements_protocol_number,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_protocol_set_expr_delimiters_elements_protocol_number nftHL_Integer
syn match nft_meta_expr_close_scope_meta_protocol_set_expr_delimiters_elements_protocol_number '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_protocol_set_expr_delimiters_elements_separator

" 'vlan' == '802.1q'
hi link   nft_meta_expr_close_scope_meta_protocol_set_expr_delimiters_elements_protocol_types nftHL_Define
syn match nft_meta_expr_close_scope_meta_protocol_set_expr_delimiters_elements_protocol_types '\v(ipv6\-icmp|udplite|gretap|icmpv6|comp|dccp|icmp|igmp|sctp|any|esp|gre|tcp|udp|ah)\ze[ \t\n,]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_protocol_set_expr_delimiters_elements_separator

hi link    nft_meta_expr_close_scope_meta_protocol_set_expr_delimiters nftHL_BlockDelimitersSet
syn region nft_meta_expr_close_scope_meta_protocol_set_expr_delimiters start=+{+ end=+}+ skipwhite contained
\ contains=
\     nft_meta_expr_close_scope_meta_protocol_set_expr_delimiters_elements_protocol_identifier,
\     nft_meta_expr_close_scope_meta_protocol_set_expr_delimiters_elements_protocol_types,
\     nft_meta_expr_close_scope_meta_protocol_set_expr_delimiters_elements_protocol_number,
\     nft_Error
\ nextgroup=
\    @nft_c_primary_stmt_expr,
\    @nft_c_stmt

hi link   nft_meta_expr_close_scope_meta_protocol_set_ref_symbol_expr_setname nftHL_AtSetname
syn match nft_meta_expr_close_scope_meta_protocol_set_ref_symbol_expr_setname '\v\@[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_meta_expr_close_scope_meta_protocol_symbol_expr_keywords nftHL_Define
syn match nft_meta_expr_close_scope_meta_protocol_symbol_expr_keywords '\v(ipv6\-icmp|udplite|gretap|icmpv6|comp|dccp|icmp|igmp|sctp|any|esp|gre|tcp|udp|ah)\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_meta_expr_close_scope_meta_protocol_integer_expr_num nftHL_Integer
syn match nft_meta_expr_close_scope_meta_protocol_integer_expr_num '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9]{1,2})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" ip6 nexthdr icmpv6 sequence
hi link   nft_meta_expr_close_scope_meta_protocol_relational_operators_discrete_1char nftHL_Operator
syn match nft_meta_expr_close_scope_meta_protocol_relational_operators_discrete_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_protocol_integer_expr_num,
\    nft_chainError

hi link   nft_meta_expr_close_scope_meta_protocol_relational_operators_discrete_2char nftHL_Operator
syn match nft_meta_expr_close_scope_meta_protocol_relational_operators_discrete_2char '\v(\<|\>)\=' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_protocol_integer_expr_num,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_protocol_relational_operators_equality_2char nftHL_Operator
syn match nft_meta_expr_close_scope_meta_protocol_relational_operators_equality_2char '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_protocol_symbol_expr_keywords,
\    nft_meta_expr_close_scope_meta_protocol_set_expr_delimiters,
\    nft_meta_expr_close_scope_meta_protocol_set_ref_symbol_expr_setname,
\    nft_meta_expr_close_scope_meta_protocol_integer_expr_num,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_protocol_internal_keyword_in nftHL_Operator
syn match nft_meta_expr_close_scope_meta_protocol_internal_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_protocol_set_ref_symbol_expr_setname,
\    nft_meta_expr_close_scope_meta_protocol_set_expr_delimiters,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_protocol_relational_expr_keyword_not nftHL_Operator
syn match nft_meta_expr_close_scope_meta_protocol_relational_expr_keyword_not '\vnot\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_protocol_internal_keyword_in,
\    nft_meta_expr_close_scope_meta_protocol_set_expr_delimiters,
\    nft_meta_expr_close_scope_meta_protocol_integer_expr_num,
\    nft_meta_expr_expr_close_scope_meta_protocol_sequence_set_ref_symbol_expr_setname,
\    nft_chainError

hi link   nft_meta_expr_close_scope_meta_protocol_internal_keyword_any nftHL_Operator
syn match nft_meta_expr_close_scope_meta_protocol_internal_keyword_any '\vany\ze[ \t\n;]' skipwhite contained

syn cluster nft_c_protocol_type
\ contains=
\    nft_meta_expr_close_scope_meta_protocol_internal_keyword_any,
\    nft_meta_expr_close_scope_meta_protocol_relational_expr_keyword_not,
\    nft_meta_expr_close_scope_meta_protocol_relational_operators_discrete_2char,
\    nft_meta_expr_close_scope_meta_protocol_relational_operators_equality_2char,
\    nft_meta_expr_close_scope_meta_protocol_internal_keyword_in,
\    nft_meta_expr_close_scope_meta_protocol_set_expr_delimiters,
\    nft_meta_expr_close_scope_meta_protocol_relational_operators_discrete_1char,
\    nft_meta_expr_close_scope_meta_protocol_symbol_expr_keywords,
\    nft_meta_expr_close_scope_meta_protocol_integer_expr_num,

" ******************** BEGIN 'protocol' *************************
" 'l4proto' got obsoleted by 'protocol' keyword
hi link   nft_meta_expr_meta_key_qualified_keyword_protocol nftHL_Statement
syn match nft_meta_expr_meta_key_qualified_keyword_protocol '\vl4proto\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_protocol_type,
\    nft_Error

hi link   nft_meta_expr_meta_key_qualified_keyword_protocol nftHL_Statement
syn match nft_meta_expr_meta_key_qualified_keyword_protocol '\vprotocol\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_protocol_type,
\    nft_Error
" ************************ END 'protocol' ***********************
" 'l4proto' got obsoleted by 'protocol' keyword
hi link   nft_meta_expr_meta_key_meta_key_qualified_keyword_protocol nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_qualified_keyword_protocol '\vl4proto\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_protocol_type,
\    nft_Error

hi link   nft_meta_expr_meta_key_meta_key_qualified_keyword_protocol nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_qualified_keyword_protocol '\vprotocol\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_protocol_type,
\    nft_Error
" ************************ END 'meta protocol' ***********************

" ************** BEGIN meta_expr 'meta ibrname' **********************
syn cluster nft_c_meta_expr_close_scope_meta_interface_name
\ contains=
\    nft_interface_name_operator_special_any,
\    nft_interface_name_operators_equality,
\    nft_interface_name_operator_regex_not_match,
\    nft_interface_name_operator_regex_match,
\    nft_interface_name_quote_string_asterisk

hi link   nft_interface_name_regex_string_quoted nftHL_String
syn match nft_interface_name_regex_string_quoted '\v\"\S{1,64}\"' skipwhite contained
syn match nft_interface_name_regex_string_quoted '\v\'\S{1,64}\'' skipwhite contained

hi link   nft_interface_name_operator_regex_match nftHL_Operator
syn match nft_interface_name_operator_regex_match '\v\~' skipwhite contained
\ nextgroup= nft_interface_name_regex_string_quoted, nft_Error

hi link   nft_interface_name_operator_regex_not_match nftHL_Operator
syn match nft_interface_name_operator_regex_not_match '\v\!\~' skipwhite contained
\ nextgroup= nft_interface_name_regex_string_quoted, nft_Error

hi link   nft_interface_name_operator_special_any nftHL_Operator
syn match nft_interface_name_operator_special_any '\vany' skipwhite contained

hi link   nft_interface_name_set_elements_separator nftHL_Separator
syn match nft_interface_name_set_elements_separator /,/ skipwhite contained
\ nextgroup= nft_interface_name_set_block_elements_string_quoted, nft_Error

hi link   nft_interface_name_namedset  nftHL_Identifier
syn match nft_interface_name_namedset '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_interface_name_quote_string_asterisk  nftHL_String
syn match nft_interface_name_quote_string_asterisk '\v\"[a-zA-Z][a-zA-Z0-9\-_\*]{0,15}\"\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_expr,
\    @nft_c_primary_stmt_expr,
\    @nft_c_stmt

syn match nft_interface_name_quote_string_asterisk '\v\'[a-zA-Z][a-zA-Z0-9\-_\*]{0,15}\'\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_interface_name_quote_mandatory  nftHL_String
syn match nft_interface_name_quote_mandatory '\v\"[a-zA-Z][a-zA-Z0-9\-_]{0,15}\"\ze[ \t\n;]' skipwhite contained
syn match nft_interface_name_quote_mandatory '\v\'[a-zA-Z][a-zA-Z0-9\-_]{0,15}\'\ze[ \t\n;]' skipwhite contained

hi link   nft_interface_name_operators_equality nftHL_Operator
syn match nft_interface_name_operators_equality '\v(\!|\=)\=' skipwhite contained
\ nextgroup=
\    nft_interface_name_quote_mandatory,
\    nft_interface_name_namedset,
\    nft_interface_name_set_block,
\    nft_Error

syn cluster nft_c_meta_expr_close_scope_meta_interface_name_quoted_device_name
\ contains=
\    nft_interface_name_operator_special_any,
\    nft_interface_name_operators_equality,
\    nft_interface_name_operator_regex_not_match,
\    nft_interface_name_operator_regex_match,
\    nft_interface_name_set_block,
\    nft_interface_name_quote_string_asterisk,

hi link   nft_meta_expr_close_scope_meta_ifname_at_setname nftHL_AtSetname
syn match nft_meta_expr_close_scope_meta_ifname_at_setname '\v\@[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_in nftHL_Operator
syn match nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_ifname_at_setname,
\    nft_interface_name_set_block,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_ifname_set_membership_operator_prefix_keyword_not nftHL_Operator
syn match nft_meta_expr_close_scope_meta_ifname_set_membership_operator_prefix_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_in,
\    nft_Error

hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_ibrname nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_ibrname '\vibrname\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_meta_expr_close_scope_meta_ifname_set_membership_operator_prefix_keyword_not,
\    nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_in,
\    @nft_c_meta_expr_close_scope_meta_interface_name_quoted_device_name,
\    nft_Error
" **************** BEGIN meta_expr 'ibrname' *************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_ibrname nftHL_Error
syn match nft_meta_expr_meta_key_unqualified_keyword_ibrname '\vibrname' skipwhite contained
\ nextgroup=
\    nft_Error
" **************** END meta_expr 'ibrname' ***************************
" **************** END meta_expr 'meta ibrname' **********************

" **************** END meta_expr 'meta iifname' **********************
hi link   nft_meta_expr_close_scope_meta_ifname_integer nftHL_Integer
syn match nft_meta_expr_close_scope_meta_ifname_integer '\v[0-9]{1,10}' skipwhite contained
syn match nft_meta_expr_close_scope_meta_ifname_integer '\v0x[0-9a-f]{1,8}' skipwhite contained

hi link   nft_meta_expr_close_scope_meta_ifname_operators_relational_1char nftHL_Operator
syn match nft_meta_expr_close_scope_meta_ifname_operators_relational_1char '\v(\<|\>)' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_ifname_integer, nft_Error

hi link   nft_meta_expr_close_scope_meta_ifname_operators_relational_2char nftHL_Operator
syn match nft_meta_expr_close_scope_meta_ifname_operators_relational_2char '\v(\<|\>)\=' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_ifname_integer, nft_Error

hi link   nft_meta_expr_close_scope_meta_ifname_operators_equality nftHL_Operator
syn match nft_meta_expr_close_scope_meta_ifname_operators_equality '\v(\!|\=)\=' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_ifname_integer,
\    nft_meta_expr_close_scope_meta_ifname_at_setname,
\    nft_meta_expr_close_scope_meta_ifname_set_block,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_ifname_integer_operand nftHL_Integer
syn match nft_meta_expr_close_scope_meta_ifname_integer_operand '\v(0x)?[0-9a-f]{1,10}' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_ifname_operators_relational_2char,
\    nft_meta_expr_close_scope_meta_ifname_operators_equality,
\    nft_meta_expr_close_scope_meta_ifname_operators_relational_1char

hi link   nft_meta_expr_close_scope_meta_ifname_operator_mask nftHL_Operator
syn match nft_meta_expr_close_scope_meta_ifname_operator_mask '\v\&' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_ifname_integer_operand,
\    nft_Error

hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_iifname nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_iifname '\viifname\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_meta_expr_close_scope_meta_ifname_set_membership_operator_prefix_keyword_not,
\    nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_in,
\    @nft_c_meta_expr_close_scope_meta_interface_name_quoted_device_name,
\    nft_Error
" **************** BEGIN meta_expr 'iifname' *************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_iifname nftHL_Statement
syn match nft_meta_expr_meta_key_unqualified_keyword_iifname '\viifname\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_meta_expr_close_scope_meta_ifname_set_membership_operator_prefix_keyword_not,
\    nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_in,
\    @nft_c_meta_expr_close_scope_meta_interface_name_quoted_device_name,
\    nft_Error
" **************** END meta_expr 'iifname' ***************************
" **************** END meta_expr 'meta iifname' **********************

" ************** BEGIN meta_expr 'meta iiftype' **********************
" ************** BEGIN meta_expr 'iiftype' **********************
hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_iiftype nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_iiftype '\viiftype\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_interface_type,
\    nft_Error
" ************** END meta_expr 'iiftype' **********************
hi link   nft_meta_expr_meta_key_unqualified_keyword_iiftype nftHL_Statement
syn match nft_meta_expr_meta_key_unqualified_keyword_iiftype '\viiftype\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_interface_type,
\    nft_Error
" **************** END meta_expr 'meta iiftype' **********************

" ************** START meta_expr 'meta nftrace' **********************
" 'meta nftrace' has '0'/'1'
hi link   nft_meta_expr_meta_key_unqualified_keyword_nftrace_value nftHL_Integer
syn match nft_meta_expr_meta_key_unqualified_keyword_nftrace_value '\v(0x[0-1]{1})|([0-1]{1})\ze[ \t\n;]' skipwhite contained
hi link   nft_meta_expr_meta_key_unqualified_keyword_nftrace_comparison nftHL_Operator
syn match nft_meta_expr_meta_key_unqualified_keyword_nftrace_comparison '\v(\<|\>|\!|\=)\=\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_unqualified_keyword_nftrace_value

hi link   nft_meta_expr_meta_key_unqualified_keyword_nftrace_set_elements nftHL_BlockDelimitersSet
syn region nft_meta_expr_meta_key_unqualified_keyword_nftrace_set_elements start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_meta_expr_meta_key_unqualified_keyword_nftrace_value

hi link   nft_meta_expr_meta_key_unqualified_keyword_nftrace_set nftHL_Write
syn match nft_meta_expr_meta_key_unqualified_keyword_nftrace_set '\vset\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_unqualified_keyword_nftrace_set_elements,
\    nft_meta_expr_meta_key_unqualified_keyword_nftrace_value,
\    nft_Error

hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_nftrace nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_nftrace '\vnftrace\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_unqualified_keyword_nftrace_set,
\    nft_meta_expr_meta_key_unqualified_keyword_nftrace_value,
\    nft_meta_expr_meta_key_unqualified_keyword_nftrace_comparison,
\    nft_Error
" **************** BEGIN meta_expr 'nftrace' *************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_nftrace nftHL_Error
syn match nft_meta_expr_meta_key_unqualified_keyword_nftrace '\vnftrace' skipwhite contained
\ nextgroup=
\    nft_Error
" **************** END meta_expr 'nftrace' ***************************
" **************** END meta_expr 'meta nftrace' **********************

" ************** BEGIN meta_expr 'meta nfproto' **********************
hi link   nft_meta_expr_close_scope_meta_nf_protocols nftHL_Define
syn match nft_meta_expr_close_scope_meta_nf_protocols '\v([0-9]{1,3})|(bridge|netdev|unspec|inet|arp|ip6|ip)\ze[ \t;]' skipwhite contained

hi link   nft_meta_expr_internal_string_keyword_nfproto_set nftHL_Write
syn match nft_meta_expr_internal_string_keyword_nfproto_set '\vset\ze[ \t]' skipwhite contained
\ nextgroup= nft_meta_expr_close_scope_meta_nf_protocols, nft_Error

hi link   nft_meta_expr_close_scope_meta_nfproto_id nftHL_Integer
syn match nft_meta_expr_close_scope_meta_nfproto_id '\v0x([A-Fa-f0-9]{1,2}|[0-9A-Fa-f])|25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9]\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_expr_meta_expr_internal_string_keyword_nfproto_set,
\    nft_stmt_separator

hi link   nft_meta_expr_close_scope_meta_nfproto_enum nftHL_Define
syn match nft_meta_expr_close_scope_meta_nfproto_enum '\v(bridge|netdev|inet|arp|ip6|ip)\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_expr_meta_expr_internal_string_keyword_nfproto_set,
\    nft_stmt_separator

" **************** BEGIN meta_expr 'nfproto' *************************
hi link   nft_meta_expr_internal_string_keyword_nfproto nftHL_Error
syn match nft_meta_expr_internal_string_keyword_nfproto '\vnfproto' skipwhite contained
\ nextgroup=
\    nft_Error
" **************** END meta_expr 'nfproto' ***************************
hi link   nft_meta_expr_meta_key_internal_string_keyword_nfproto nftHL_Substatement
syn match nft_meta_expr_meta_key_internal_string_keyword_nfproto '\vnfproto\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_meta_expr_close_scope_meta_nfproto_enum,
\    nft_meta_expr_close_scope_meta_nfproto_id,
\    nft_Error
" **************** END meta_expr 'meta nfproto' **********************

" ************** BEGIN meta_expr 'meta obrname' **********************
" ************** BEGIN meta_expr 'obrname' ***************************
hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_obrname nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_obrname '\vobrname\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_meta_expr_close_scope_meta_ifname_set_membership_operator_prefix_keyword_not,
\    nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_in,
\    @nft_c_meta_expr_close_scope_meta_interface_name_quoted_device_name,
\    nft_Error
" ************** END meta_expr 'obrname' *****************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_obrname nftHL_Error
syn match nft_meta_expr_meta_key_unqualified_keyword_obrname '\vobrname' skipwhite contained
\ nextgroup=
\    nft_Error
" **************** END meta_expr 'meta obrname' **********************

" ************** BEGIN meta_expr 'meta oifname' **********************
" ************** BEGIN meta_expr 'oifname' **********************
hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_oifname nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_oifname '\voifname\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_meta_expr_close_scope_meta_ifname_set_membership_operator_prefix_keyword_not,
\    nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_in,
\    nft_primary_rhs_expr_symbol_expr_variable_expr_identifier,
\    @nft_c_meta_expr_close_scope_meta_interface_name_quoted_device_name,
\    nft_Error
" **************** END meta_expr 'oifname' **********************
hi link   nft_meta_expr_meta_key_unqualified_keyword_oifname nftHL_Statement
syn match nft_meta_expr_meta_key_unqualified_keyword_oifname '\voifname\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_meta_expr_close_scope_meta_ifname_set_membership_operator_prefix_keyword_not,
\    nft_meta_expr_close_scope_meta_ifname_set_membership_keyword_in,
\    nft_primary_rhs_expr_symbol_expr_variable_expr_identifier,
\    @nft_c_meta_expr_close_scope_meta_interface_name_quoted_device_name,
\    nft_blind_interface,
\    nft_Error
" **************** END meta_expr 'meta oifname' **********************

" ************** BEGIN meta_expr 'meta oiftype' **********************
" ************** BEGIN meta_expr 'oiftype' **********************
hi link   nft_meta_expr_meta_key_unqualified_keyword_oiftype nftHL_Statement
syn match nft_meta_expr_meta_key_unqualified_keyword_oiftype '\voiftype\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_interface_type, nft_Error
" **************** END meta_expr 'oiftype' **********************
hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_oiftype nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_oiftype '\voiftype\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_interface_type, nft_Error
" **************** END meta_expr 'meta oiftype' **********************

" ************** BEGIN meta_expr 'meta pkttype' **********************
hi link   nft_pkttype_at_setname nftHL_AtSetname
syn match nft_pkttype_at_setname '\v\@[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_meta_pkttype_set_symbol_comma nftHL_elements
syn match nft_meta_pkttype_set_symbol_comma '\v,' skipnl contained
\ nextgroup=
\    nft_meta_pkttype_set_symbol_elements_packet_type,
\    nft_meta_expr_close_scope_meta_pkttype_set_expr_integer_expr_num

hi link   nft_meta_pkttype_set_elements_packet_type nftHL_Define
syn match nft_meta_pkttype_set_elements_packet_type '\v(broadcast|fastroute|multicast|otherhost|loopback|outgoing|unicast|host)' skipnl contained
\ nextgroup=
\    nft_meta_pkttype_set_symbol_comma

hi link   nft_meta_expr_close_scope_meta_pkttype_set_expr_integer_expr_num nftHL_Integer
syn match nft_meta_expr_close_scope_meta_pkttype_set_expr_integer_expr_num '\v(0x[A-Fa-f0-9]{1,4}|6553[0-5]|655[0-2][0-9]|65[0-4][0-9][0-9]|6[0-4][0-9][0-9][0-9]|[1-5][0-9]{4}|[0-9]{1,4})\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_pkttype_set_symbol_comma

hi link    nft_meta_expr_close_scope_meta_pkttype_set_expr nftHL_BlockDelimitersSet
syn region nft_meta_expr_close_scope_meta_pkttype_set_expr start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_meta_pkttype_set_elements_packet_type,
\    nft_meta_expr_close_scope_meta_pkttype_set_expr_integer_expr_num

hi link   nft_symbol_expr_string_packet_type nftHL_Define
syn match nft_symbol_expr_string_packet_type '\v(broadcast|fastroute|multicast|otherhost|loopback|outgoing|unicast|host)\ze[ \t\n;]' skipnl contained
\ nextgroup=
\    @nft_c_primary_stmt_expr,
\    nft_stmt_separator

hi link   nft_meta_expr_close_scope_meta_pkttype_integer_expr_num nftHL_Integer
syn match nft_meta_expr_close_scope_meta_pkttype_integer_expr_num '\v0x[A-Fa-f0-9]{1,4}|6553[0-5]|655[0-2][0-9]|65[0-4][0-9][0-9]|6[0-4][0-9][0-9][0-9]|[1-5][0-9]{4}|[0-9]{1,4}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr,
\    nft_stmt_separator

hi link   nft_pkttype_set_membership_keyword_in nftHL_Operator
syn match nft_pkttype_set_membership_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_symbol_expr_string_packet_type_operators_equality,
\    nft_meta_expr_close_scope_meta_pkttype_set_expr,
\    nft_pkttype_at_setname,
\    nft_Error

hi link   nft_pkttype_set_membership_operator_prefix_keyword_not nftHL_Operator
syn match nft_pkttype_set_membership_operator_prefix_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_symbol_expr_string_packet_type,
\    nft_meta_expr_close_scope_meta_pkttype_set_expr,
\    nft_pkttype_set_membership_keyword_in,
\    nft_meta_expr_close_scope_meta_pkttype_integer_expr_num,
\    nft_Error

hi link   nft_symbol_expr_string_packet_type_operators_equality nftHL_Operator
syn match nft_symbol_expr_string_packet_type_operators_equality '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_symbol_expr_string_packet_type,
\    nft_meta_expr_close_scope_meta_pkttype_set_expr,
\    nft_meta_expr_close_scope_meta_pkttype_integer_expr_num,
\    nft_Error

" **************** BEGIN meta_expr 'pkttype' **********************
hi link   nft_meta_expr_meta_key_unqualified_keyword_pkttype nftHL_Statement
syn match nft_meta_expr_meta_key_unqualified_keyword_pkttype '\vpkttype\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    nft_symbol_expr_string_packet_type,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_pkttype_set_membership_operator_prefix_keyword_not,
\    nft_pkttype_set_membership_keyword_in,
\    nft_symbol_expr_string_packet_type_operators_equality,
\    nft_meta_expr_close_scope_meta_pkttype_integer_expr_num,
\    nft_Error
" **************** END meta_expr 'pkttype' **********************
hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_pkttype nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_pkttype '\vpkttype\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    nft_symbol_expr_string_packet_type,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_pkttype_set_membership_operator_prefix_keyword_not,
\    nft_pkttype_set_membership_keyword_in,
\    nft_symbol_expr_string_packet_type_operators_equality,
\    nft_meta_expr_close_scope_meta_pkttype_integer_expr_num,
\    nft_Error
" **************** END meta_expr 'meta pkttype' **********************

" ************** BEGIN meta_expr 'meta secmark' **********************
syn cluster nft_c_secmark
\ contains=
\    nft_meta_expr_meta_key_unqualified_mark_operators_equality,
\    nft_meta_expr_meta_key_unqualified_mark_operators_relational_2char,
\    nft_meta_expr_meta_key_unqualified_mark_operator_mask,
\    nft_meta_expr_meta_key_unqualified_mark_operators_discrete_only_1char,
\    nft_meta_expr_meta_key_unqualified_mark_operators_relational_1char,
\    nft_meta_expr_meta_key_unqualified_mark_integer,

" **************** BEGIN meta_expr 'secmark' **********************
hi link   nft_meta_expr_meta_key_qualified_keyword_secmark nftHL_Error
syn match nft_meta_expr_meta_key_qualified_keyword_secmark '\vsecmark\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_Error
" **************** END meta_expr 'meta secmark' **********************
hi link   nft_meta_expr_meta_key_meta_key_qualified_keyword_secmark nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_qualified_keyword_secmark '\vsecmark\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_secmark,
\    nft_Error
" **************** END meta_expr 'meta secmark' **********************

" ************** BEGIN meta_expr 'meta cgroup' ***********************
hi link   nft_meta_expr_close_scope_meta_cgroup_set_expr_integer_expr_uint64_hex nftHL_Integer
syn match nft_meta_expr_close_scope_meta_cgroup_set_expr_integer_expr_uint64_hex '\v0x[0-9a-fA-F]{1,16}|[0-9]{1,20}\ze[ \t\n,]' skipwhite contained
\ nextgroup=
\    nft_cgroup_index_set_block_member_separator

hi link   nft_cgroup_index_set_block_member_separator nftHL_Separator
syn match nft_cgroup_index_set_block_member_separator /,/ skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_cgroup_set_expr_integer_expr_uint64_hex,
\    nft_Error

hi link    nft_cgroup_index_set_block nftHL_BlockDelimitersSet
syn region nft_cgroup_index_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_meta_expr_close_scope_meta_cgroup_set_expr_integer_expr_uint64_hex

hi link   nft_cgroup_index_named_set_identifier nftHL_AtSetname
syn match nft_cgroup_index_named_set_identifier '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_meta_expr_close_scope_meta_cgroup_integer_expr_uint64_hex nftHL_Integer
syn match nft_meta_expr_close_scope_meta_cgroup_integer_expr_uint64_hex '\v(0x[0-9a-fA-F]{1,16})|([0-9]{1,20})\ze[ \t\n;]' skipwhite contained

hi link   nft_cgroup_index_operators_relational_1char nftHL_Operator
syn match nft_cgroup_index_operators_relational_1char '\v(\<|\>)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_cgroup_integer_expr_uint64_hex,
\    nft_Error

hi link   nft_cgroup_index_operators_relational_2char nftHL_Operator
syn match nft_cgroup_index_operators_relational_2char '\v(\<|\>)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_cgroup_integer_expr_uint64_hex,
\    nft_Error

hi link   nft_cgroup_index_operators_equality nftHL_Operator
syn match nft_cgroup_index_operators_equality '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_cgroup_index_named_set_identifier,
\    nft_cgroup_index_set_block,
\    nft_meta_expr_close_scope_meta_cgroup_integer_expr_uint64_hex,
\    nft_Error

hi link   nft_cgroup_index_operator_set_keyword_in nftHL_Operator
syn match nft_cgroup_index_operator_set_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_cgroup_index_set_block,
\    nft_cgroup_index_named_set_identifier,
\    nft_Error

hi link   nft_cgroup_index_operator_set_prefix_keyword_not nftHL_Operator
syn match nft_cgroup_index_operator_set_prefix_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_cgroup_index_operator_set_keyword_in,
\    nft_cgroup_index_named_set_identifier,
\    nft_meta_expr_close_scope_meta_cgroup_integer_expr_uint64_hex

" **************** BEGIN meta_expr 'cgroup' **************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_cgroup nftHL_Error
syn match nft_meta_expr_meta_key_unqualified_keyword_cgroup '\vcgroup' skipwhite contained
\ nextgroup=nft_Error

" **************** END meta_expr 'cgroup' ****************************
hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_cgroup nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_cgroup '\vcgroup\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_cgroup_index_operator_set_prefix_keyword_not,
\    nft_cgroup_index_operator_set_keyword_in,
\    nft_cgroup_index_operators_relational_2char,
\    nft_cgroup_index_operators_equality,
\    nft_cgroup_index_operators_relational_1char,
\    nft_cgroup_index_set_block,
\    nft_meta_expr_close_scope_meta_cgroup_integer_expr_uint64_hex,
\    nft_Error
" **************** END meta_expr 'meta cgroup' ***********************

" ************** BEGIN meta_expr 'meta length' ***********************
hi link   nft_meta_expr_close_scope_meta_length_set_expr_delimiters_member_separator nftHL_Integer
syn match nft_meta_expr_close_scope_meta_length_set_expr_delimiters_member_separator /,/ skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_length_set_expr_delimiters_member_integer,
\    nft_Error

syn match nft_meta_expr_close_scope_meta_length_set_expr_delimiters_member_integer  '\v(0x[A-Fa-f0-9]{1,4}|6553[0-5]|655[0-2][0-9]|65[0-4][0-9][0-9]|6[0-4][0-9][0-9][0-9]|[1-5][0-9]{4}|[0-9]{1,4})\ze[ \t\n,]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_length_set_expr_delimiters_member_separator

hi link    nft_meta_expr_close_scope_meta_length_set_expr_delimiters nftHL_BlockDelimitersSet
syn region nft_meta_expr_close_scope_meta_length_set_expr_delimiters start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_meta_expr_close_scope_meta_length_set_expr_delimiters_member_integer

hi link   nft_packet_length_named_set_identifier nftHL_AtSetname
syn match nft_packet_length_named_set_identifier '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained
hi link   nft_meta_expr_close_scope_meta_length_relational_expr_operators_1char nftHL_Operator
syn match nft_meta_expr_close_scope_meta_length_relational_expr_operators_1char '\v(\<|\>)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_length_integer_expr_num,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_length_integer_expr_num nftHL_Integer
syn match nft_meta_expr_close_scope_meta_length_integer_expr_num  '\v(0x[A-Fa-f0-9]{1,4}|6553[0-5]|655[0-2][0-9]|65[0-4][0-9][0-9]|6[0-4][0-9][0-9][0-9]|[1-5][0-9]{4}|[0-9]{1,4})\ze[ \t\n;]' skipwhite contained
\ nextgroup=@nft_c_stmt

hi link   nft_meta_expr_close_scope_meta_length_relational_expr_operators_equality nftHL_Operator
syn match nft_meta_expr_close_scope_meta_length_relational_expr_operators_equality '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_length_relational_expr_set_ref_symbol_expr_keyword_at_setname,
\    nft_meta_expr_close_scope_meta_length_set_expr_delimiters,
\    nft_meta_expr_close_scope_meta_length_integer_expr_num,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_length_relational_expr_operators_2char nftHL_Operator
syn match nft_meta_expr_close_scope_meta_length_relational_expr_operators_2char '\v(\<|\>)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_length_integer_expr_num,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_length_set_expr_operator_keyword_in nftHL_Operator
syn match nft_meta_expr_close_scope_meta_length_set_expr_operator_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_length_set_expr_delimiters,
\    nft_meta_expr_close_scope_meta_length_relational_expr_set_ref_symbol_expr_keyword_at_setname,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_length_relational_expr_keyword_not nftHL_Operator
syn match nft_meta_expr_close_scope_meta_length_relational_expr_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_length_set_expr_operator_keyword_in,
\    nft_meta_expr_close_scope_meta_length_set_expr_delimiters,
\    nft_meta_expr_close_scope_meta_length_integer_expr_num,
\    nft_meta_expr_close_scope_meta_length_relational_expr_set_ref_symbol_expr_keyword_at_setname,
\    nft_chainError

syn cluster nft_c_packet_length
\ contains=
\    nft_meta_expr_close_scope_meta_length_relational_expr_keyword_not,
\    nft_meta_expr_close_scope_meta_length_relational_expr_operators_2char,
\    nft_meta_expr_close_scope_meta_length_set_expr_operator_keyword_in,
\    nft_meta_expr_close_scope_meta_length_relational_expr_operators_equality,
\    nft_meta_expr_close_scope_meta_length_relational_expr_operators_1char,
\    nft_meta_expr_close_scope_meta_length_relational_expr_set_ref_symbol_expr_keyword_at_setname,
\    nft_meta_expr_close_scope_meta_length_integer_expr_num

" **************** BEGIN meta_expr 'length' **************************
hi link   nft_meta_expr_meta_key_qualified_keyword_length nftHL_Statement
syn match nft_meta_expr_meta_key_qualified_keyword_length '\vlength\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_packet_length, nft_Error
" **************** END meta_expr 'length' ****************************
hi link   nft_meta_expr_meta_key_meta_key_qualified_keyword_length nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_qualified_keyword_length '\vlength\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_packet_length, nft_Error
" **************** END meta_expr 'meta length' ***********************

" ************** BEGIN meta_expr 'meta random' ***********************


syn match nft_meta_expr_close_scope_meta_random_match '\v[0-9]{1,10}\ze[ \t;]' skipwhite contained

hi link   nft_meta_expr_close_scope_meta_random_expr nftHL_Operator
syn match nft_meta_expr_close_scope_meta_random_expr '\v((\<)|(\>)|(\=)|(\!))\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_random_match

hi link   nft_meta_expr_close_scope_meta_random_mod_divisor nftHL_Integer
syn match nft_meta_expr_close_scope_meta_random_mod_divisor '\v[0-9]{1,10}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_random_expr

hi link   nft_meta_expr_close_scope_meta_random_mod nftHL_Keyword
syn match nft_meta_expr_close_scope_meta_random_mod '\vmod\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_random_mod_divisor

hi link   nft_meta_expr_close_scope_meta_random_integer_expr_uint32 nftHL_Integer
syn match nft_meta_expr_close_scope_meta_random_integer_expr_uint32 '\v0x[0-9a-fA-F]{1,8}|429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}\ze[ \t\n;]' skipwhite contained

hi link   nft_meta_expr_meta_key_qualified_keyword_random_expr nftHL_Operator
syn match nft_meta_expr_meta_key_qualified_keyword_random_expr '\v((\<)|(\>)|(\=)|(\!))\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_random_integer_expr_uint32

hi link   nft_meta_expr_meta_key_qualified_keyword_random_mod_divisor nftHL_Integer
syn match nft_meta_expr_meta_key_qualified_keyword_random_mod_divisor '\v(0x[0-9A-Fa-f]{1,8}|(429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}))\ze[ \t\n,\}]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_qualified_keyword_random_expr

hi link   nft_meta_expr_meta_key_qualified_keyword_random_mod nftHL_Keyword
syn match nft_meta_expr_meta_key_qualified_keyword_random_mod '\vmod\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_qualified_keyword_random_mod_divisor

syn match nft_meta_stmt_keyword_set '\vset\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_qualified_keyword_random_mod,
\    @nft_c_stmt_expr

" **************** BEGIN meta_expr 'random' **************************
hi link   nft_meta_expr_meta_key_qualified_keyword_random nftHL_Error
syn match nft_meta_expr_meta_key_qualified_keyword_random '\vrandom' skipwhite contained
\ nextgroup=
\    nftHL_Error
" **************** END meta_expr 'random' ****************************
hi link   nft_meta_expr_meta_key_meta_key_qualified_keyword_random nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_qualified_keyword_random '\vrandom\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_keyword_set,
\    nft_meta_expr_meta_key_qualified_keyword_random_expr,
\    nft_meta_expr_close_scope_meta_random_integer_expr_uint32,
\    nft_Error
" **************** END meta_expr 'meta random' ***********************

" ************** BEGIN meta_expr 'meta ipsec' ************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_ipsec_integer nftHL_Integer
syn match nft_meta_expr_meta_key_unqualified_keyword_ipsec_integer '\v[0-1]{1,1}\ze[ \t;]' skipwhite contained

hi link   nft_meta_expr_meta_key_unqualified_keyword_ipsec_operators_relational nftHL_Operator
syn match nft_meta_expr_meta_key_unqualified_keyword_ipsec_operators_relational '\v((\<)|(\>)|(\=)|(\!))\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_unqualified_keyword_ipsec_integer

hi link   nft_meta_expr_meta_key_unqualified_keyword_ipsec_special_keywords nftHL_Define
syn match nft_meta_expr_meta_key_unqualified_keyword_ipsec_special_keywords '\v(missing|exists)\ze[ \t;]' skipwhite contained

hi link   nft_meta_expr_meta_key_unqualified_keyword_ipsec_named_set_identifier Identifier
syn match nft_meta_expr_meta_key_unqualified_keyword_ipsec_named_set_identifier '\v\@[a-zA-Z][a-zA-Z0-9\-\_]{0,63}\ze[ \t;]' skipwhite contained

hi link   nft_meta_expr_meta_key_unqualified_keyword_ipsec_set_block_member_separator  nftHL_Separator
syn match nft_meta_expr_meta_key_unqualified_keyword_ipsec_set_block_member_separator  /,/ skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_unqualified_keyword_ipsec_set_block_member_integer,
\    nft_meta_expr_meta_key_unqualified_keyword_ipsec_set_block_member_special_keywords

hi link   nft_meta_expr_meta_key_unqualified_keyword_ipsec_set_block_member_integer nftHL_Integer
syn match nft_meta_expr_meta_key_unqualified_keyword_ipsec_set_block_member_integer '\v[0-1]{1,1}' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_block_member_separator

hi link    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_block nftHL_BlockDelimitersSet
syn region nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_block start='{' end='}' skipwhite contained
\ contains=
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_block_member_special_keywords,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_block_member_integer,

hi link   nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_block_member_special_keywords nftHL_Define
syn match nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_block_member_special_keywords '\v(missing|exists)\ze[ \t;]' skipwhite contained

hi link   nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_operators_equality nftHL_Operator
syn match nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_operators_equality '\v((\=)|(\!))\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_unqualified_keyword_ipsec_special_keywords,
\    nft_meta_expr_meta_key_unqualified_keyword_ipsec_named_set_identifier,
\    nft_meta_expr_meta_key_unqualified_keyword_ipsec_set_block,
\    nft_meta_expr_meta_key_unqualified_keyword_ipsec_integer

hi link   nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_reqid_num nftHL_Integer
syn match nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_reqid_num '\v[0-9]{1,10}\ze[ \t]' skipwhite contained

hi link   nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_reqid nftHL_Keyword
syn match nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_reqid '\vreqid\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_reqid_num

" ***************** Begin 'ipsec spi num' ***************
hi link   nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_spi_num nftHL_Integer
syn match nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_spi_num '\v(([0-9]{1,10})|(0[xX][0-9a-fA-F]{1,8}))\ze[ \t]' skipwhite contained

" ipsec [in|out] spi"
hi link   nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_spi nftHL_Keyword
syn match nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_spi '\vspi\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_spi_num
" ***************** End 'ipsec spi num' ***************

" ***************** End 'ipsec spnum num' ***************
" ipsec [in|out] spnum"
hi link   nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_spnum nftHL_Keyword
syn match nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_spnum '\vspnum\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_spnum_num_or_range

hi link   nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_named_set_identifier nftHL_AtSetname
syn match nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_named_set_identifier '\v\@[a-zA-Z]a-zA-Z0-9]{0,63}' skipwhite contained
" ***************** End 'ipsec spnum num' ***************

hi link   nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_value_integer nftHL_Integer
syn match nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_value_integer '\v[0-1]\ze[ \t\n;]' skipwhite contained

hi link   nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_directional_keyword_in nftHL_Keyword
syn match nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_directional_keyword_in '\vin\ze[ \t\{]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_named_set_identifier,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_reqid,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_spnum,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_spi,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_block,
\    nft_Error

hi link   nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_directional_keyword_out nftHL_Keyword
syn match nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_directional_keyword_out '\vout\ze[ \t\{]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_named_set_identifier,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_spnum,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_reqid,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_spi,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_block,
\    nft_Error

hi link   nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_keyword_in nftHL_Keyword
syn match nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_keyword_in '\vin\ze[ \t\{]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_named_set_identifier,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_spnum,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_reqid,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_spi,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_block,
\    nft_Error

hi link   nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_operator_prefix_keyword_not nftHL_Operator
syn match nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_operator_prefix_keyword_not '\vnot\ze[ \t\{]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_keyword_out,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_keyword_spi,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_keyword_in,
\    nft_Error

hi link   nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_keyword_exclamation nftHL_Operator
syn match nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_keyword_exclamation '\v\!\ze[ \t\{]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_keyword_out,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_keyword_spi,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_keyword_in,
\    nft_Error

hi link   nft_meta_expr_meta_key_unqualified_ipsec_keyword_missing nftHL_Define
syn match nft_meta_expr_meta_key_unqualified_ipsec_keyword_missing '\vmissing' skipwhite contained

hi link   nft_meta_expr_meta_key_unqualified_ipsec_keyword_exists nftHL_Define
syn match nft_meta_expr_meta_key_unqualified_ipsec_keyword_exists '\vexists' skipwhite contained

hi link   nft_meta_expr_meta_key_unqualified_ipsec_operator_prefix_keyword_not nftHL_Expression
syn match nft_meta_expr_meta_key_unqualified_ipsec_operator_prefix_keyword_not '\vnot' skipwhite contained
\ nextgroup=nft_meta_expr_meta_key_unqualified_ipsec_keyword_exists

hi link   nft_meta_expr_meta_key_unqualified_ipsec_keyword_exclamation nftHL_Expression
syn match nft_meta_expr_meta_key_unqualified_ipsec_keyword_exclamation '\v\!' skipwhite contained
\ nextgroup=nft_meta_expr_meta_key_unqualified_ipsec_keyword_exists

" LL(1) maintains distinction between 'meta ipsec' and 'ipsec'
" This here is 'ipsec' (no 'exists' keyword)
" There is no writable ipsec so meta_stmt is not supported here (strictly meta_expr)
" We use condensed 'primary_stmt/primary_stmt_expr' as an anchor for ipsec group name
"    (thereby skipping primary_stmt/concat_primary_expr/meta_expr/stmt_expr/concat_stmt_expr/basic_stmt_expr/exclusive_or_stmt_expr/and_stmt_expr/shift_stmt_expr/primary_stmt_expr/meta_expr)
" keyword_ipsec is split between:
"    - stmt/meta_stmt/stmt_expr and
"    - stmt/primary_stmt/concat_primary_expr/meta_expr/stmt_expr/concat_stmt_expr/basic_stmt_expr/exclusive_or_stmt_expr/and_stmt_expr/shift_stmt_expr/primary_stmt_expr/meta_expr
" The 'ipsec' part (without 'meta' keyword)

hi link   nft_meta_expr_meta_key_unqualified_keyword_ipsec nftHL_Error
syn match nft_meta_expr_meta_key_unqualified_keyword_ipsec '\vipsec\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_Error

" The 'meta ipsec' part
hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_ipsec nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_ipsec '\vipsec\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_unqualified_ipsec_keyword_missing,
\    nft_meta_expr_meta_key_unqualified_ipsec_keyword_exists,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_operator_prefix_keyword_not,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_keyword_spi,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_keyword_out,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_keyword_in,
\    nft_meta_expr_meta_key_unqualified_ipsec_operator_prefix_keyword_not,
\    nft_meta_expr_meta_key_unqualified_ipsec_keyword_exclamation,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_operators_relational,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_operators_equality,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_set_keyword_exclamation,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_ipsec_value_integer
" no nft_Error here, 'meta ipsec' is a standalone statement
" **************** END meta_expr 'meta ipsec' ************************

" ************** BEGIN meta_expr 'meta skgid' ************************
" ************** BEGIN meta_expr 'skgid' ************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_skgid nftHL_Error
syn match nft_meta_expr_meta_key_unqualified_keyword_skgid '\vskgid' skipwhite contained
\ nextgroup=nft_Error
" **************** END meta_expr 'skgid' ************************

hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_skgid nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_skgid '\vskgid\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_socket_t, nft_Error
" **************** END meta_expr 'meta skgid' ************************

" ************** BEGIN meta_expr 'meta skuid' ************************
" ************** BEGIN meta_expr 'skuid' ************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_skuid nftHL_Error
syn match nft_meta_expr_meta_key_unqualified_keyword_skuid '\vskuid' skipwhite contained
\ nextgroup=nft_Error
" **************** END meta_expr 'skuid' ************************
hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_skuid nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_skuid '\vskuid\ze[ \t]' skipwhite contained
\ nextgroup= @nft_c_socket_t, nft_Error
" **************** END meta_expr 'meta skuid' ************************

" ************** BEGIN meta_expr 'meta hour' *************************
hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_hour nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_hour '\vhour\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_hour_type, nft_Error
hi link   nft_meta_expr_meta_key_unqualified_keyword_hour nftHL_Statement
syn match nft_meta_expr_meta_key_unqualified_keyword_hour '\vhour\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_hour_type, nft_Error
" **************** END meta_expr 'meta hour' *************************

" ************** BEGIN meta_expr 'meta mark' *************************
syn match nft_meta_expr_mark_missing '\v\ze[ \t]*[;\n]'  contained
hi link   nft_meta_expr_mark_missing nftHL_Error

hi link   nft_meta_expr_meta_key_unqualified_mark_integer nftHL_Integer
syn match nft_meta_expr_meta_key_unqualified_mark_integer '\v((0x[0-9a-f]{1,8})|([0-9]{1,10}))\ze[ \t\n;]' skipwhite contained

hi link   nft_meta_expr_meta_key_unqualified_mark_named_set nftHL_AtSetname
syn match nft_meta_expr_meta_key_unqualified_mark_named_set '\v\@[a-zA-Z][a-zA-Z0-9]{0,63}' skipwhite contained

hi link   nft_meta_expr_meta_key_unqualified_mark_operators_relational_1char nftHL_Operator
syn match nft_meta_expr_meta_key_unqualified_mark_operators_relational_1char '\v(\<|\>)' skipwhite contained
\ nextgroup=
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedAtSymbol,
\    nft_meta_expr_meta_key_unqualified_mark_integer, nft_Error

hi link   nft_meta_expr_meta_key_unqualified_mark_operators_equality nftHL_Operator
syn match nft_meta_expr_meta_key_unqualified_mark_operators_equality '\v(\!|\=)\=' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_unqualified_mark_integer,
\    nft_meta_expr_meta_key_unqualified_mark_named_set,
\    nft_meta_expr_meta_key_unqualified_mark_set_block,
\    nft_Error

hi link   nft_meta_expr_meta_key_unqualified_mark_operators_relational_2char nftHL_Operator
syn match nft_meta_expr_meta_key_unqualified_mark_operators_relational_2char '\v((\<|\>)(\=|\<|\>))' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_unqualified_mark_integer, nft_Error

hi link   nft_meta_expr_meta_key_unqualified_mark_integer_operand nftHL_Integer
syn match nft_meta_expr_meta_key_unqualified_mark_integer_operand '\v(0x)?[0-9a-f]{1,10}' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_unqualified_mark_operators_relational_2char,
\    nft_meta_expr_meta_key_unqualified_mark_operators_equality,
\    nft_meta_expr_meta_key_unqualified_mark_operators_relational_1char

hi link   nft_meta_expr_meta_key_unqualified_mark_operator_mask nftHL_Operator
syn match nft_meta_expr_meta_key_unqualified_mark_operator_mask '\v\&' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_unqualified_mark_integer_operand,
\    nft_Error
hi link   nft_meta_expr_meta_key_unqualified_mark_set_block_elements_integer nftHL_Integer
syn match nft_meta_expr_meta_key_unqualified_mark_set_block_elements_integer '\v[0-9]{1,10}' skipwhite contained
syn match nft_meta_expr_meta_key_unqualified_mark_set_block_elements_integer '\v0x[0-9a-f]{1,8}' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_unqualified_mark_set_block_elements_separator,
\    nft_Error

hi link   nft_meta_expr_meta_key_unqualified_mark_set_block_elements_separator nftHL_Separator
syn match nft_meta_expr_meta_key_unqualified_mark_set_block_elements_separator /,/ skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_unqualified_mark_set_block_elements_integer

hi link    nft_meta_expr_meta_key_unqualified_mark_set_block nftHL_BlockDelimitersSet
syn region nft_meta_expr_meta_key_unqualified_mark_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_meta_expr_meta_key_unqualified_mark_set_block_elements_integer,
\    nft_Error

hi link   nft_meta_expr_meta_key_unqualified_mark_named_set nftHL_AtSetname
syn match nft_meta_expr_meta_key_unqualified_mark_named_set '\v\@[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_meta_expr_meta_key_unqualified_mark_keyword_in nftHL_Operator
syn match nft_meta_expr_meta_key_unqualified_mark_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_unqualified_mark_set_block,
\    nft_meta_expr_meta_key_unqualified_mark_integer,
\    nft_Error

syn cluster nft_c_mark
\ contains=
\    nft_meta_expr_meta_key_unqualified_mark_keyword_in,
\    nft_meta_expr_meta_key_unqualified_mark_operators_equality,
\    nft_meta_expr_meta_key_unqualified_mark_operators_relational_2char,
\    nft_meta_expr_meta_key_unqualified_mark_operator_mask,
\    nft_meta_expr_meta_key_unqualified_mark_operators_discrete_only_1char,
\    nft_meta_expr_meta_key_unqualified_mark_operators_relational_1char,
\    nft_meta_expr_meta_key_unqualified_mark_named_set,
\    nft_meta_expr_meta_key_unqualified_mark_integer,

hi link   nft_meta_expr_meta_key_unqualified_mark_operator_prefix_keyword_not nftHL_Operator
syn match nft_meta_expr_meta_key_unqualified_mark_operator_prefix_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_mark,
\    nft_Error

" **************** BEGIN meta_expr 'mark' *************************
hi link   nft_meta_expr_meta_key_unqualified_keyword_mark nftHL_Error
syn match nft_meta_expr_meta_key_unqualified_keyword_mark '\vmark' skipwhite contained
\ nextgroup=
\    nft_Error
" **************** END meta_expr 'mark' *************************

hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_mark nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_mark '\vmark\ze[ \t]' skipnl skipwhite contained
\ nextgroup=
\    nft_meta_stmt_keyword_mark_keyword_set,
\    nft_map_expr_keyword_map,
\    nft_meta_expr_meta_key_unqualified_mark_operator_prefix_keyword_not,
\    @nft_c_mark,
\    nft_Error
" **************** END meta_expr 'meta mark' *************************

" ************** BEGIN meta_expr 'meta time' *************************
hi link   nft_time_type_integer nftHL_Integer
syn match nft_time_type_integer '\v[0-9]{1,10}\ze[ \t;]' skipwhite contained
syn match nft_time_type_integer '\v0x[0-9a-fA-F]{1,32}\ze[ \t;]' skipwhite contained

hi link   nft_time_type_set_block_member_separator nftHL_Separator
syn match nft_time_type_set_block_member_separator /,/ skipwhite contained
\ nextgroup=
\    nft_time_type_set_block_member_integer,
\    nft_Error

hi link   nft_time_type_set_block_member_integer nftHL_Integer
syn match nft_time_type_set_block_member_integer '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_time_type_set_block_member_separator
syn match nft_time_type_set_block_member_integer '\v0x[0-9a-fA-F]{1,8}' skipwhite contained
\ nextgroup=
\    nft_time_type_set_block_member_separator

hi link    nft_time_type_set_block nftHL_BlockDelimitersSet
syn region nft_time_type_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_time_type_set_block_member_integer

hi link   nft_time_type_named_set_identifier nftHL_AtSetname
syn match nft_time_type_named_set_identifier '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_time_type_operator_set_keyword_in nftHL_Operator
syn match nft_time_type_operator_set_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_time_type_set_block,
\    nft_time_type_named_set_identifier,
\    nft_Error

hi link   nft_time_type_operator_set_prefix_keyword_not nftHL_Operator
syn match nft_time_type_operator_set_prefix_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_time_type_operator_set_keyword_in

hi link   nft_time_type_operators_relational_2char nftHL_Operator
syn match nft_time_type_operators_relational_2char '\v(\<|\>)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_time_type_integer,
\    nft_Error

hi link   nft_time_type_operators_relational_1char nftHL_Operator
syn match nft_time_type_operators_relational_1char '\v(\<|\>)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_time_type_integer,
\    nft_Error

hi link   nft_time_type_operators_equality nftHL_Operator
syn match nft_time_type_operators_equality '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_time_type_named_set_identifier,
\    nft_time_type_set_block,
\    nft_time_type_integer,
\    nft_Error

syn cluster nft_c_time_type
\ contains=
\    nft_time_type_operator_set_prefix_keyword_not,
\    nft_time_type_operator_set_keyword_in,
\    nft_time_type_operators_relational_2char,
\    nft_time_type_operators_equality,
\    nft_time_type_operators_relational_1char,
\    nft_time_type_integer,

hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_time nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_time '\vtime\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_time_type, nft_Error

hi link   nft_meta_expr_meta_key_unqualified_keyword_time nftHL_Statement
syn match nft_meta_expr_meta_key_unqualified_keyword_time '\vtime\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_time_type, nft_Error
" **************** END meta_expr 'meta time' *************************

" ************** BEGIN meta_expr 'meta cpu' **************************
hi link   nft_meta_expr_close_scope_meta_cpu_set_expr_integer_expr_uint32 nftHL_Integer
syn match nft_meta_expr_close_scope_meta_cpu_set_expr_integer_expr_uint32 '\v((0x[0-9A-Fa-f]{1,8})|(429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}))\ze[ \t\n,]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_cpu_set_expr_symbol_comma

hi link   nft_meta_expr_close_scope_meta_cpu_set_expr_symbol_comma nftHL_Separator
syn match nft_meta_expr_close_scope_meta_cpu_set_expr_symbol_comma '\v,' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_cpu_set_expr_integer_expr_uint32

hi link    nft_meta_expr_close_scope_meta_cpu_set_expr_delimiters nftHL_BlockDelimitersSet
syn region nft_meta_expr_close_scope_meta_cpu_set_expr_delimiters start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_meta_expr_close_scope_meta_cpu_set_expr_integer_expr_uint32

hi link   nft_meta_expr_close_scope_meta_cpu_set_ref_symbol_expr_keyword_at_identifier nftHL_AtSetname
syn match nft_meta_expr_close_scope_meta_cpu_set_ref_symbol_expr_keyword_at_identifier '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_meta_expr_close_scope_meta_cpu_constant_expr_string_keyword_in nftHL_Operator
syn match nft_meta_expr_close_scope_meta_cpu_constant_expr_string_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_cpu_set_expr_delimiters,
\    nft_meta_expr_close_scope_meta_cpu_set_ref_symbol_expr_keyword_at_identifier,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_cpu_integer_expr_uint32 nftHL_Integer
syn match nft_meta_expr_close_scope_meta_cpu_integer_expr_uint32 '\v(0x[0-9A-Fa-f]{1,8})|(429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt_expr,
\    @nft_chain_separator,
\    nft_Error

hi link   nft_cpu_index_operators_relational_2char nftHL_Operator
syn match nft_cpu_index_operators_relational_2char '\v(\<|\>)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_cpu_integer_expr_uint32,
\    nft_Error

hi link   nft_cpu_index_operators_relational_1char nftHL_Operator
syn match nft_cpu_index_operators_relational_1char '\v(\<|\>)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_cpu_integer_expr_uint32,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_cpu_set_expr_symbol_comma nftHL_Integer
syn match nft_meta_expr_close_scope_meta_cpu_set_expr_symbol_comma /,/ skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_cpu_set_expr_delimiters_member_integer,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_cpu_relational_expr_operators_equality nftHL_Operator
syn match nft_meta_expr_close_scope_meta_cpu_relational_expr_operators_equality '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_cpu_set_ref_symbol_expr_keyword_at_identifier,
\    nft_meta_expr_close_scope_meta_cpu_set_expr_delimiters,
\    nft_meta_expr_close_scope_meta_cpu_integer_expr_uint32,
\    nft_Error

hi link   nft_meta_expr_close_scope_meta_cpu_constant_expr_string_keyword_in nftHL_Operator
syn match nft_meta_expr_close_scope_meta_cpu_constant_expr_string_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_cpu_set_ref_symbol_expr_keyword_at_identifier,
\    nft_meta_expr_close_scope_meta_cpu_set_expr_delimiters,
\    nft_Error

hi link   nft_cpu_index_operator_set_prefix_keyword_not nftHL_Operator
syn match nft_cpu_index_operator_set_prefix_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_close_scope_meta_cpu_constant_expr_string_keyword_in,
\    nft_meta_expr_close_scope_meta_cpu_integer_expr_uint32

hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_cpu nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_cpu '\vcpu\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_cpu_index_operator_set_prefix_keyword_not,
\    nft_meta_expr_close_scope_meta_cpu_constant_expr_string_keyword_in,
\    nft_meta_expr_close_scope_meta_cpu_relational_expr_operators_equality,
\    nft_meta_expr_close_scope_meta_cpu_set_ref_symbol_expr_keyword_at_identifier,
\    nft_meta_expr_close_scope_meta_cpu_set_expr_delimiters,
\    nft_meta_expr_close_scope_meta_cpu_integer_expr_uint32,
\    nft_Error

hi link   nft_meta_expr_meta_key_unqualified_keyword_cpu nftHL_Error
syn match nft_meta_expr_meta_key_unqualified_keyword_cpu '\vcpu' skipwhite contained
\ nextgroup=nft_Error
" **************** END meta_expr 'meta cpu' **************************

" ************** BEGIN meta_expr 'meta day' **************************
hi link   nft_day_of_week_integer nftHL_Integer
syn match nft_day_of_week_integer '\v0x[0-6]{1}|[0-6]{1}\ze[ \t\n;]' skipwhite contained

hi link   nft_day_of_week_symbolic_constants nftHL_Define
syn match nft_day_of_week_symbolic_constants '\v(Saturday|Wednesday|Thursday|Tuesday|Friday|Monday|Sunday)\ze[ \t\n;]' skipwhite contained

hi link   nft_day_of_week_set_block_elements_separator nftHL_Separator
syn match nft_day_of_week_set_block_elements_separator /,/ skipwhite contained
\ nextgroup=
\    nft_day_of_week_set_block_elements_integer,
\    nft_day_of_week_set_block_elements_symbolic_constants,
\    nft_Error

hi link   nft_day_of_week_set_block_elements_integer nftHL_Integer
syn match nft_day_of_week_set_block_elements_integer '\v[0-6]{1}\ze[ \t\n,]' skipwhite contained
\ nextgroup=
\    nft_day_of_week_set_block_elements_separator,

hi link   nft_day_of_week_set_block_elements_symbolic_constants nftHL_Define
syn match nft_day_of_week_set_block_elements_symbolic_constants '\v(Saturday|Wednesday|Thursday|Tuesday|Friday|Monday|Sunday)\ze[ \t,]' skipwhite contained
\ nextgroup=
\    nft_day_of_week_set_block_elements_separator,

hi link    nft_day_of_week_set_block nftHL_BlockDelimitersSet
syn region nft_day_of_week_set_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_day_of_week_set_block_elements_symbolic_constants,
\    nft_day_of_week_set_block_elements_integer,

hi link   nft_day_of_week_operator_set_keyword_in nftHL_Operator
syn match nft_day_of_week_operator_set_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_day_of_week_set_block,
\    nft_Error

hi link   nft_day_of_week_operator_set_prefix_keyword_not nftHL_Operator
syn match nft_day_of_week_operator_set_prefix_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_day_of_week_operator_set_keyword_in,
\    nft_Error

hi link   nft_day_of_week_operators_equality nftHL_Operator
syn match nft_day_of_week_operators_equality '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_day_of_week_symbolic_constants,
\    nft_day_of_week_integer,
\    nft_Error

hi link   nft_day_of_week_operators_equality nftHL_Operator
syn match nft_day_of_week_operators_equality '\v(\!|\=)\=\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_day_of_week_symbolic_constants,
\    nft_day_of_week_integer,
\    nft_Error

syn cluster nft_c_day_of_week
\ contains=
\    nft_day_of_week_symbolic_constants,
\    nft_day_of_week_operator_set_prefix_keyword_not,
\    nft_day_of_week_operator_set_keyword_in,
\    nft_day_of_week_operators_equality,
\    nft_day_of_week_integer,

hi link   nft_meta_expr_meta_key_unqualified_keyword_day nftHL_Statement
syn match nft_meta_expr_meta_key_unqualified_keyword_day '\vday\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_day_of_week, nft_Error
hi link   nft_meta_expr_meta_key_meta_key_unqualified_keyword_day nftHL_Substatement
syn match nft_meta_expr_meta_key_meta_key_unqualified_keyword_day '\vday\ze[ \t]' skipwhite contained
\ nextgroup=@nft_c_day_of_week, nft_Error
" **************** END meta_expr 'meta day' **************************

hi link   nft_meta_expr_invalid_keyword_notrack nftHL_Error
syn match nft_meta_expr_invalid_keyword_notrack '\vnotrack\ze[ \t\n;]' skipwhite contained

hi link   nft_meta_expr_invalid_keyword_flow nftHL_Error
syn match nft_meta_expr_invalid_keyword_flow '\vflow\ze[ \t\n;]' skipwhite contained

"  meta_expr '<meta_key_qualified>'
syn cluster nft_c_meta_expr_meta_key_qualified
\ contains=
\    nft_meta_expr_meta_key_qualified_keyword_protocol,
\    nft_meta_expr_meta_key_qualified_keyword_priority,
\    nft_meta_expr_meta_key_qualified_keyword_secmark,
\    nft_meta_expr_meta_key_qualified_keyword_length,
\    nft_meta_expr_meta_key_qualified_keyword_random

"  meta_expr 'meta <meta_key_qualified>'
syn cluster nft_c_meta_expr_meta_key_meta_key_qualified
\ contains=
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_protocol,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_priority,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_secmark,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_length,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_random

"  meta_expr '<meta_key_unqualified>'
syn cluster nft_c_meta_expr_meta_key_unqualified
\ contains=
\    nft_meta_expr_meta_key_unqualified_keyword_rtclassid,
\    nft_meta_expr_meta_key_unqualified_keyword_ibriport,
\    nft_meta_expr_meta_key_unqualified_keyword_iifgroup,
\    nft_meta_expr_meta_key_unqualified_keyword_obriport,
\    nft_meta_expr_meta_key_unqualified_keyword_oifgroup,
\    nft_meta_expr_meta_key_unqualified_keyword_ibrname,
\    nft_meta_expr_meta_key_unqualified_keyword_iifname,
\    nft_meta_expr_meta_key_unqualified_keyword_iiftype,
\    nft_meta_expr_meta_key_unqualified_keyword_nftrace,
\    nft_meta_expr_meta_key_unqualified_keyword_obrname,
\    nft_meta_expr_meta_key_unqualified_keyword_oifname,
\    nft_meta_expr_meta_key_unqualified_keyword_oiftype,
\    nft_meta_expr_meta_key_unqualified_keyword_pkttype,
\    nft_meta_expr_meta_key_unqualified_keyword_cgroup,
\    nft_meta_expr_meta_key_unqualified_keyword_ipsec,
\    nft_meta_expr_meta_key_unqualified_keyword_skgid,
\    nft_meta_expr_meta_key_unqualified_keyword_skuid,
\    nft_meta_expr_meta_key_unqualified_keyword_hour,
\    nft_meta_expr_meta_key_unqualified_keyword_mark,
\    nft_meta_expr_meta_key_unqualified_keyword_time,
\    nft_meta_expr_meta_key_unqualified_keyword_cpu,
\    nft_meta_expr_meta_key_unqualified_keyword_day,
\    nft_meta_expr_meta_key_unqualified_keyword_iif,
\    nft_meta_expr_meta_key_unqualified_keyword_oif

"  meta_expr 'meta <meta_key_unqualified>'
syn cluster nft_c_meta_expr_meta_key_meta_key_unqualified
\ contains=
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_rtclassid,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_ibriport,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_obriport,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_iifgroup,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_oifgroup,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_ibrname,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_iifname,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_iiftype,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_nftrace,
\    nft_meta_expr_meta_key_internal_string_keyword_nfproto,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_obrname,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_oifname,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_oiftype,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_pkttype,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_cgroup,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_ipsec,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_skgid,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_skuid,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_hour,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_mark,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_time,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_cpu,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_day,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_iif,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_oif

hi link   nft_meta_expr_keyword_meta nftHL_Command
syn match nft_meta_expr_keyword_meta '\vmeta\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_rtclassid,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_ibriport,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_iifgroup,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_obriport,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_oifgroup,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_priority,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_protocol,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_ibrname,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_iifname,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_iiftype,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_nftrace,
\    nft_meta_expr_meta_key_internal_string_keyword_nfproto,
\    nft_meta_expr_invalid_keyword_notrack,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_obrname,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_oifname,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_oiftype,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_pkttype,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_secmark,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_cgroup,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_length,
\    nft_meta_expr_meta_key_meta_key_qualified_keyword_random,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_ipsec,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_skgid,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_skuid,
\    nft_meta_expr_invalid_keyword_flow,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_hour,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_mark,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_time,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_cpu,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_day,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_iif,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_oif,
\    nft_meta_expr_string,
\    nft_Error
" ***************** END meta_expr ************************************

  for s:this_semantic_file in s:meta_expr_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded meta_expr for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define meta_expr.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_meta_expr = v:true
