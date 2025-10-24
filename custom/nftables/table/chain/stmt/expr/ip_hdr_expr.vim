" File: ip_hdr_expr.vim
" Directory: custom/nftables/
"
" Semantic   Range              enums  example
" HDRVERSION 0–15 (typically 4) None  ip version 4
" HDRLENGTH  5–15               None  ip hdrlength 5
" CHECKSUM   0–65535            None  ip checksum 1234
" FRAG_OFF   0–8191             None  ip frag-off 0
" PROTOCOL   0–255              icmp, tcp, udp, etc.  ip protocol icmp
" LENGTH     20–65535           None  ip length 1500
" DADDR      IPv4 address/CIDR  None  ip daddr 8.8.8.8
" SADDR      IPv4 address/CIDR  None  ip saddr 192.168.1.1
" DSCP       0–63               None  ip dscp 46
" ECN        0–3                None  ip ecn 3
" TTL        0–255              None  ip ttl 64
" ID         0–65535            None  ip id 1234
"
let s:ip_hdr_expr_list_filepaths_semantic_early = []
let s:ip_hdr_expr_list_filepaths_semantic_later = []

if exists('b:did_nftables_ip_hdr_expr')
  call nftables#syntax#log('INFO', 'Skipped ip_hdr_expr (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:ip_hdr_expr_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading ip_hdr_expr syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

hi link    nft_ip_hdr_expr_close_scope_ip_inline_set nftHL_BlockDelimitersSet
syn region nft_ip_hdr_expr_close_scope_ip_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    @nft_c_primary_stmt_expr


" Valid Range: 4-40, in modulo 4 of
hi link   nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_4b_ptr_second_num nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_4b_ptr_second_num '\v(40|36|32|2[048]|1[26]|[48])' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_ip_hdr_expr_close_scope_ip_ptr_symbol_dash nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_ptr_symbol_dash /\-/ skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_4b_ptr_second_num,
\    nft_Error

hi link   nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_4b_ptr nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_4b_ptr '\v(40|36|32|2[048]|1[26]|[48])\ze[ \t\n-]' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_ptr_symbol_dash,
\    @nft_c_primary_stmt_expr

hi link   nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_8b nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_8b '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_ip_hdr_expr_close_scope_ip_set_expr_constant_expr_string_ip_cidr nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_set_expr_constant_expr_string_ip_cidr
\ '\v(0x[0-9a-fA-F]{1,8})|(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])){3}(\/(3[0-2]|[12][0-9]|[0-9])){0,1}\ze[ \t\n,\-]'
\ skipwhite contained

hi link   nft_ip_hdr_expr_close_scope_ip_addr_constant_expr_string_ip_cidr nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_addr_constant_expr_string_ip_cidr
\ '\v(0x[0-9a-fA-F]{1,8})|(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])){3}(\/(3[0-2]|[12][0-9]|[0-9])){0,1}\ze[ \t\n\;]'
\ skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr,
\    @nft_c_stmt

hi link   nft_ip_hdr_expr_close_scope_ip_constant_expr_string_ip_opt_cidr nftHL_Define
syn match nft_ip_hdr_expr_close_scope_ip_constant_expr_string_ip_opt_cidr
\ '\v(0x[0-9a-fA-F]{1,8})|(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])){3}(\/(3[0-2]|[12][0-9]|[0-9])){0,1}\ze[ \t\n\;]'
\ skipwhite contained
\ nextgroup=
\    nft_payload_expr_nft_rt_expr_keyword_rt,
\    @nft_c_primary_stmt_expr,
\    @nft_c_stmt

hi link   nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_constant_expr_string_ip_cidr nftHL_Integer
syn match nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_constant_expr_string_ip_cidr
\ '\v(0x[0-9a-fA-F]{1,8})|(25[0-5]|2[0-4]\d|1\d\d|[0-9]\d|\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[0-9]\d|\d)){3}(\/(3[0-2]|[12]\d|[0-9]))'
\ skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr,
\    @nft_c_stmt

hi link   nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_constant_expr_string_ip_second nftHL_Integer
syn match nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_constant_expr_string_ip_second
\ '\v(0x[0-9a-fA-F]{1,8})|(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}'
\ skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr,
\    @nft_c_stmt

hi link   nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_constant_expr_string_dash nftHL_Operator
syn match nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_constant_expr_string_dash '\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_constant_expr_string_ip_second

hi link   nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_constant_expr_string_ip nftHL_Integer
syn match nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_constant_expr_string_ip
\ '\v(0x[0-9a-fA-F]{1,8})|(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}'
\ skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_constant_expr_string_dash,
\    @nft_c_primary_stmt_expr

" **************** BEGIN 'ip hdrlength' ********************************
" 'hdrlength'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_close_scope_ip_hdrlength_symbol_expr_variable_expr nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_hdrlength_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" BEGIN Operators - Set membership
hi link   nft_ip_hdr_expr_close_scope_ip_hdrlength_set_ref_expr_set_ref_symbol_expr_at_setname nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_hdrlength_set_ref_expr_set_ref_symbol_expr_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_ip_hdr_expr_close_scope_ip_hdrlength_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint4_hex nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_hdrlength_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint4_hex '\v(0x[56789aAbBcCdDeEfF])|[5-9]|1[0-5]\ze[ \t\n,]' skipwhite contained

hi link   nft_ip_hdr_expr_close_scope_ip_hdrlength_set_ref_expr_set_ref_symbol_expr_range_stmt_expr_symbol_dash nftHL_Element
syn match nft_ip_hdr_expr_close_scope_ip_hdrlength_set_ref_expr_set_ref_symbol_expr_range_stmt_expr_symbol_dash '\v\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint4_hex

hi link   nft_ip_hdr_expr_close_scope_ip_hdrlength_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint4_hex_range nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_hdrlength_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint4_hex_range '\v(0x[fF]|0x[0-9a-eA-E]|[1][0-5]|[0-9])\ze[-]' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_set_ref_expr_set_ref_symbol_expr_range_stmt_expr_symbol_dash

hi link    nft_ip_hdr_expr_hdrlength_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_ip_hdr_expr_hdrlength_set_expr_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint4_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint4_hex
" END Operators - Set membership

" BEGIN Operators - Scalar
hi link   nft_ip_hdr_expr_close_scope_ip_hdrlength_integer_expr_num_uint4_hex nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_hdrlength_integer_expr_num_uint4_hex '\v(0x[56789aAbBcCdDeEfF])|[5-9]|1[0-5]\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_stmt_separator,
\    @nft_c_primary_stmt_expr

hi link   nft_ip_hdr_expr_close_scope_ip_hdrlength_range_stmt_expr_keyword_dash nftHL_Element
syn match nft_ip_hdr_expr_close_scope_ip_hdrlength_range_stmt_expr_keyword_dash '\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_integer_expr_num_uint4_hex,
\    nft_Error

hi link   nft_ip_hdr_expr_close_scope_ip_hdrlength_integer_expr_num_uint4_hex_range nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_hdrlength_integer_expr_num_uint4_hex_range '\v(0x[56789aAbBcCdDeEfF])|[5-9]|1[0-5]\ze\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_range_stmt_expr_keyword_dash,
\    nft_Error
" END Operators - Scalar

hi link   nft_ip_hdr_expr_close_scope_ip_hdrlength_relational_op_discrete_1char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_hdrlength_relational_op_discrete_1char '\v\<|\>|lt|gt' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_hdrlength_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_integer_expr_num_uint4_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_ip_hdr_expr_close_scope_ip_hdrlength_relational_op_discrete_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_hdrlength_relational_op_discrete_2char '\v((\<|\>)\=)|((ge|le)\ze[ \t\n;])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_hdrlength_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_integer_expr_num_uint4_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string


hi link   nft_ip_hdr_expr_close_scope_ip_hdrlength_relational_expr_relational_op_symbol_exclamation nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_hdrlength_relational_expr_relational_op_symbol_exclamation '\v\!\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_hdrlength_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_integer_expr_num_uint4_hex
" 'not' operator is most flexible with scalar but never directly to a set membership ('not in' ok)

hi link   nft_ip_hdr_expr_close_scope_ip_hdrlength_relational_op_non_equality_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_hdrlength_relational_op_non_equality_2char '\v(\!\=)|(ne\ze[ \t\n;])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_hdrlength_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_integer_expr_num_uint4_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_integer_expr_num_uint4_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

hi link   nft_ip_hdr_expr_close_scope_ip_hdrlength_relational_op_equality_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_hdrlength_relational_op_equality_2char '\v(\=\=)|(eq\ze[ \t\n;\n])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_hdrlength_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_integer_expr_num_uint4_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_integer_expr_num_uint4_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" Valid range: 0-15
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_hdrlength nftHL_Substatement
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_hdrlength '\vhdrlength\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_relational_op_equality_2char,
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_relational_op_non_equality_2char,
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_relational_op_discrete_2char,
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_relational_op_discrete_1char,
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_hdrlength_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_integer_expr_num_uint4_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_hdrlength_integer_expr_num_uint4_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" **************** END 'ip hdrlength' ********************************

" **************** BEGIN 'ip checksum' **********************************
" 'checksum'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_close_scope_ip_checksum_symbol_expr_variable_expr nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_checksum_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" BEGIN Operators - Set membership
hi link   nft_ip_hdr_expr_close_scope_ip_checksum_set_ref_expr_set_ref_symbol_expr_at_setname nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_checksum_set_ref_expr_set_ref_symbol_expr_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt


hi link   nft_ip_hdr_expr_close_scope_ip_checksum_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint16_hex nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_checksum_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint16_hex '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{4}|[0-9]{1,4})\ze[ \t\n,]' contained

hi link   nft_ip_hdr_expr_close_scope_ip_checksum_set_ref_expr_set_ref_symbol_expr_range_stmt_expr_symbol_dash nftHL_Element
syn match nft_ip_hdr_expr_close_scope_ip_checksum_set_ref_expr_set_ref_symbol_expr_range_stmt_expr_symbol_dash '\v\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_checksum_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint16_hex

hi link   nft_ip_hdr_expr_close_scope_ip_checksum_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint16_hex_range nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_checksum_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint16_hex_range '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{4}|[0-9]{1,4})\ze\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_checksum_set_ref_expr_set_ref_symbol_expr_range_stmt_expr_symbol_dash

hi link    nft_ip_hdr_expr_checksum_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_ip_hdr_expr_checksum_set_expr_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_ip_hdr_expr_close_scope_ip_checksum_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint16_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_checksum_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint16_hex
" END Operators - Set membership

" BEGIN Operators - Scalar
hi link   nft_ip_hdr_expr_close_scope_ip_checksum_integer_expr_num_uint16_hex nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_checksum_integer_expr_num_uint16_hex '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{4})|[0-9]{1,4}\ze[ \t\n;]' contained
\ nextgroup=
\    @nft_c_primary_stmt_expr,
\    @nft_c_stmt

hi link   nft_ip_hdr_expr_close_scope_ip_checksum_range_stmt_expr_keyword_dash nftHL_Element
syn match nft_ip_hdr_expr_close_scope_ip_checksum_range_stmt_expr_keyword_dash '\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_checksum_integer_expr_num_uint16_hex,
\    nft_Error

hi link   nft_ip_hdr_expr_close_scope_ip_checksum_integer_expr_num_uint16_hex_range nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_checksum_integer_expr_num_uint16_hex_range '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{4})|[0-9]{1,4}\ze\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_checksum_range_stmt_expr_keyword_dash,
\    nft_Error
" END Operators - Scalar

hi link   nft_ip_hdr_expr_close_scope_ip_checksum_relational_op_discrete_1char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_checksum_relational_op_discrete_1char '\v\<|\>|lt|gt' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_checksum_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_checksum_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_checksum_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_checksum_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_ip_hdr_expr_close_scope_ip_checksum_relational_op_discrete_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_checksum_relational_op_discrete_2char '\v((\<|\>)\=)|((ge|le)\ze[ \t\n;])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_checksum_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_checksum_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_checksum_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_checksum_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string


hi link   nft_ip_hdr_expr_close_scope_ip_checksum_relational_expr_relational_op_symbol_exclamation nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_checksum_relational_expr_relational_op_symbol_exclamation '\v\!\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_checksum_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_close_scope_ip_checksum_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_checksum_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_checksum_integer_expr_num_uint16_hex
" 'not' operator is most flexible with scalar but never directly to a set membership ('not in' ok)

hi link   nft_ip_hdr_expr_close_scope_ip_checksum_relational_op_non_equality_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_checksum_relational_op_non_equality_2char '\v(\!\=)|(ne\ze[ \t\n;])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_checksum_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_checksum_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_checksum_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_checksum_integer_expr_num_uint16_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_checksum_integer_expr_num_uint16_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

hi link   nft_ip_hdr_expr_close_scope_ip_checksum_relational_op_equality_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_checksum_relational_op_equality_2char '\v(\=\=)|(eq\ze[ \t\n;\n])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_checksum_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_checksum_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_checksum_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_checksum_integer_expr_num_uint16_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_checksum_integer_expr_num_uint16_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_checksum nftHL_Substatement
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_checksum '\vchecksum\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_ip_hdr_expr_close_scope_ip_checksum_relational_op_equality_2char,
\    nft_ip_hdr_expr_close_scope_ip_checksum_relational_op_non_equality_2char,
\    nft_ip_hdr_expr_close_scope_ip_checksum_relational_op_discrete_2char,
\    nft_ip_hdr_expr_close_scope_ip_checksum_relational_op_discrete_1char,
\    nft_ip_hdr_expr_close_scope_ip_checksum_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_checksum_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_checksum_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_checksum_integer_expr_num_uint16_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_checksum_integer_expr_num_uint16_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" **************** END 'ip checksum' **********************************

" **************** BEGIN 'ip frag-off' ********************************
" 'ip frag_off'
" 'frag-off'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" Valid range: 0-8191
" 'frag_off'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_close_scope_ip_frag_off_symbol_expr_variable_expr nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_frag_off_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" BEGIN Operators - Set membership
hi link   nft_ip_hdr_expr_close_scope_ip_frag_off_set_ref_expr_set_ref_symbol_expr_at_setname nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_frag_off_set_ref_expr_set_ref_symbol_expr_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_ip_hdr_expr_close_scope_ip_frag_off_set_expr_integer_expr_uint13_hex nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_frag_off_set_expr_integer_expr_uint13_hex '\v(0x1[fF]{3}|0x1[fF][0-9a-eA-E][0-9a-fA-F]|0x1[0-9a-eA-E][0-9a-fA-F]{2}|0x[0-9a-fA-F]{1,3}|819[0-1]|81[0-8][0-9]|80[0-9]{2}|[1-7][0-9]{3}|[1-9][0-9]{0,2}|0)\ze[ \t\n,]' contained

hi link   nft_ip_hdr_expr_close_scope_ip_frag_off_set_expr_range_stmt_expr_symbol_dash nftHL_Element
syn match nft_ip_hdr_expr_close_scope_ip_frag_off_set_expr_range_stmt_expr_symbol_dash '\-' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_frag_off_set_expr_integer_expr_uint13_hex,
\    nft_Error

hi link   nft_ip_hdr_expr_close_scope_ip_frag_off_set_expr_integer_expr_uint13_hex_range nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_frag_off_set_expr_integer_expr_uint13_hex_range '\v(0x1[fF]{3}|0x1[fF][0-9a-eA-E][0-9a-fA-F]|0x1[0-9a-eA-E][0-9a-fA-F]{2}|0x[0-9a-fA-F]{1,3}|819[0-1]|81[0-8][0-9]|80[0-9]{2}|[1-7][0-9]{3}|[1-9][0-9]{0,2}|0)\ze\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_frag_off_set_expr_range_stmt_expr_symbol_dash,
\    nft_Error

hi link    nft_ip_hdr_expr_frag_off_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_ip_hdr_expr_frag_off_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_ip_hdr_field_frag_off_set_expr_symbol_expr_string_keyword_defines,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_set_expr_integer_expr_uint13_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_set_expr_integer_expr_uint13_hex,
" END Operators - Set membership

" BEGIN Operators - Scalar
hi link   nft_ip_hdr_expr_close_scope_ip_frag_off_integer_expr_num_uint13_hex nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_frag_off_integer_expr_num_uint13_hex  '\v(0x1[fF]{3}|0x1[fF][0-9a-eA-E][0-9a-fA-F]|0x1[0-9a-eA-E][0-9a-fA-F]{2}|0x[0-9a-fA-F]{1,3}|819[0-1]|81[0-8][0-9]|80[0-9]{2}|[1-7][0-9]{3}|[1-9][0-9]{0,2}|0)\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    nft_stmt_separator,
\    @nft_c_primary_stmt_expr

hi link   nft_ip_hdr_expr_close_scope_ip_frag_off_range_stmt_expr_keyword_dash nftHL_Element
syn match nft_ip_hdr_expr_close_scope_ip_frag_off_range_stmt_expr_keyword_dash '\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_frag_off_integer_expr_num_uint13_hex,
\    nft_Error

hi link   nft_ip_hdr_expr_close_scope_ip_frag_off_integer_expr_num_uint13_hex_range nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_frag_off_integer_expr_num_uint13_hex_range '\v(0x1[fF]{3}|0x1[fF][0-9a-eA-E][0-9a-fA-F]|0x1[0-9a-eA-E][0-9a-fA-F]{2}|0x[0-9a-fA-F]{1,3}|819[0-1]|81[0-8][0-9]|80[0-9]{2}|[1-7][0-9]{3}|[1-9][0-9]{0,2}|0)\ze\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_frag_off_range_stmt_expr_keyword_dash,
\    nft_Error
" END Operators - Scalar

hi link   nft_ip_hdr_expr_close_scope_ip_frag_off_relational_op_discrete_1char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_frag_off_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_frag_off_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_integer_expr_num_uint13_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_ip_hdr_expr_close_scope_ip_frag_off_relational_op_discrete_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_frag_off_relational_op_discrete_2char '\v((\<|\>)\=)|((gt|lt|ge|le)\ze[ \t\n;])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_frag_off_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_integer_expr_num_uint13_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string


hi link   nft_ip_hdr_expr_close_scope_ip_frag_off_relational_expr_relational_op_symbol_exclamation nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_frag_off_relational_expr_relational_op_symbol_exclamation '\v\!\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_frag_off_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_frag_off_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_integer_expr_num_uint13_hex
" 'not' operator is most flexible with scalar but never directly to a set membership ('not in' ok)

hi link   nft_ip_hdr_expr_close_scope_ip_frag_off_relational_op_non_equality_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_frag_off_relational_op_non_equality_2char '\v(\!\=)|(ne\ze[ \t\n;])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_frag_off_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_frag_off_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_integer_expr_num_uint13_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_integer_expr_num_uint13_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

hi link   nft_ip_hdr_expr_close_scope_ip_frag_off_relational_op_equality_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_frag_off_relational_op_equality_2char '\v(\=\=)|(eq\ze[ \t\n;\n])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_frag_off_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_frag_off_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_integer_expr_num_uint13_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_integer_expr_num_uint13_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" Valid range: 0-15
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_frag_off nftHL_Substatement
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_frag_off '\vfrag\-off\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_relational_op_equality_2char,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_relational_op_non_equality_2char,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_relational_op_discrete_2char,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_relational_op_discrete_1char,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_frag_off_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_integer_expr_num_uint13_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_frag_off_integer_expr_num_uint13_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" **************** END 'ip frag-off' ********************************

" **************** BEGIN 'ip protocol' ********************************
" 'ip protocol'
" 'protocol'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" Valid range: 0-255
hi link   nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_protocol_at_setname nftHL_AtSetname
syn match nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_protocol_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t]' skipwhite contained

hi link   nft_ip_hdr_expr_close_scope_ip_protocol_symbol_expr_variable_expr nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_protocol_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" BEGIN Operators - Set membership
hi link   nft_ip_hdr_expr_close_scope_ip_protocol_set_ref_symbol_expr_symbol_expr_types nftHL_Define
syn match nft_ip_hdr_expr_close_scope_ip_protocol_set_ref_symbol_expr_symbol_expr_types '\v(udplite|gretap|icmpv6|comp|dccp|icmp|igmp|sctp|esp|gre|tcp|udp|ah)\ze[ \t\n,]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr,

hi link   nft_ip_hdr_expr_close_scope_ip_protocol_set_ref_expr_set_ref_symbol_expr_at_setname nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_protocol_set_ref_expr_set_ref_symbol_expr_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n,]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_ip_hdr_expr_close_scope_ip_protocol_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint8_hex nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_protocol_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint8_hex '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9]{1,2})\ze[ \t\n,]' skipwhite contained

hi link   nft_ip_hdr_expr_close_scope_ip_protocol_set_ref_expr_set_ref_symbol_expr_range_stmt_expr_symbol_dash nftHL_Element
syn match nft_ip_hdr_expr_close_scope_ip_protocol_set_ref_expr_set_ref_symbol_expr_range_stmt_expr_symbol_dash '\v\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_protocol_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint8_hex

hi link   nft_ip_hdr_expr_close_scope_ip_protocol_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint8_hex_range nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_protocol_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint8_hex_range '\v(0x[0-9a-eA-E]{1,2}|2][0-5][0-9]|1[0-9][0-9]|[0-9]{1,2})\ze\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_protocol_set_ref_expr_set_ref_symbol_expr_range_stmt_expr_symbol_dash


hi link    nft_ip_hdr_expr_protocol_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_ip_hdr_expr_protocol_set_expr_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_ip_hdr_expr_close_scope_ip_protocol_set_ref_symbol_expr_symbol_expr_types,
\    nft_ip_hdr_expr_close_scope_ip_protocol_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint8_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_protocol_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint8_hex
"

" END Operators - Set membership

" BEGIN Operators - Scalar
hi link   nft_ip_hdr_expr_close_scope_ip_protocol_symbol_expr_types nftHL_Define
syn match nft_ip_hdr_expr_close_scope_ip_protocol_symbol_expr_types '\v(udplite|gretap|icmpv6|comp|dccp|icmp|igmp|sctp|esp|gre|tcp|udp|ah)\ze[ \t\n,]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr,

hi link   nft_ip_hdr_expr_close_scope_ip_protocol_integer_expr_num_uint8_hex nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_protocol_integer_expr_num_uint8_hex '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9]{1,2})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr,
\    @nft_c_stmt

hi link   nft_ip_hdr_expr_close_scope_ip_protocol_range_stmt_expr_keyword_dash nftHL_Element
syn match nft_ip_hdr_expr_close_scope_ip_protocol_range_stmt_expr_keyword_dash '\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_protocol_integer_expr_num_uint8_hex,
\    nft_Error

hi link   nft_ip_hdr_expr_close_scope_ip_protocol_integer_expr_num_uint8_hex_range nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_protocol_integer_expr_num_uint8_hex_range '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9]{1,2})\ze\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_protocol_range_stmt_expr_keyword_dash,
\    nft_Error
" END Operators - Scalar

hi link   nft_ip_hdr_expr_close_scope_ip_protocol_relational_op_discrete_1char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_protocol_relational_op_discrete_1char '\v\<|\>|lt|gt' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_protocol_symbol_expr_types,
\    nft_ip_hdr_expr_close_scope_ip_protocol_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_protocol_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_protocol_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_protocol_integer_expr_num_uint8_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_ip_hdr_expr_close_scope_ip_protocol_relational_op_discrete_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_protocol_relational_op_discrete_2char '\v((\<|\>)\=)|((ge|le)\ze[ \t\n;])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_protocol_symbol_expr_types,
\    nft_ip_hdr_expr_close_scope_ip_protocol_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_protocol_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_protocol_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_protocol_integer_expr_num_uint8_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_ip_hdr_expr_close_scope_ip_protocol_relational_expr_relational_op_symbol_exclamation nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_protocol_relational_expr_relational_op_symbol_exclamation '\v\!\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_protocol_symbol_expr_types,
\    nft_ip_hdr_expr_close_scope_ip_protocol_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_close_scope_ip_protocol_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_protocol_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_protocol_integer_expr_num_uint8_hex
" 'not' operator is most flexible with scalar but never directly to a set membership ('not in' ok)

hi link   nft_ip_hdr_expr_close_scope_ip_protocol_relational_op_non_equality_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_protocol_relational_op_non_equality_2char '\v(\!\=)|(ne\ze[ \t\n;])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_protocol_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_protocol_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_protocol_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_protocol_integer_expr_num_uint8_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_protocol_integer_expr_num_uint8_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

hi link   nft_ip_hdr_expr_close_scope_ip_protocol_relational_op_equality_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_protocol_relational_op_equality_2char '\v(\=\=)|(eq\ze[ \t\n;\n])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_protocol_symbol_expr_types,
\    nft_ip_hdr_expr_close_scope_ip_protocol_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_protocol_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_protocol_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_protocol_integer_expr_num_uint8_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_protocol_integer_expr_num_uint8_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" Valid range: 0-15
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_protocol nftHL_Substatement
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_protocol '\vprotocol\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_protocol_symbol_expr_types,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_ip_hdr_expr_close_scope_ip_protocol_relational_op_equality_2char,
\    nft_ip_hdr_expr_close_scope_ip_protocol_relational_op_non_equality_2char,
\    nft_ip_hdr_expr_close_scope_ip_protocol_relational_op_discrete_2char,
\    nft_ip_hdr_expr_close_scope_ip_protocol_relational_op_discrete_1char,
\    nft_ip_hdr_expr_close_scope_ip_protocol_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_protocol_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_protocol_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_protocol_integer_expr_num_uint8_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_protocol_integer_expr_num_uint8_hex,
\    nft_UnexpectedQuote,
\    nft_Error


" Valid range: 0-255
"hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_protocol nftHL_Substatement
"syn match nft_ip_hdr_expr_ip_hdr_field_keyword_protocol '\vprotocol\ze[ \t]' skipwhite contained
"\ nextgroup=
"\    nft_verdict_expr_keyword_continue,
"\    nft_verdict_expr_keyword_accept,
"\    nft_verdict_expr_keyword_return,
"\    nft_verdict_expr_keyword_drop,
"\    nft_verdict_expr_keyword_goto,
"\    nft_verdict_expr_keyword_jump,
"\    nft_verdict_map_stmt_keyword_vmap,
"\    nft_map_expr_keyword_map,
"\    nft_ip_hdr_expr_close_scope_ip_datatype_ip_protocol,
"\    nft_ip_hdr_expr_close_scope_ip_inline_set_protocols,
"\    nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_protocol_at_setname,
"\    nft_UnexpectedNonNumber,
"\    nft_Error
" **************** END 'ip protocol' ********************************

" **************** BEGIN 'ip version' ********************************
" 'version'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_expr_set_ref_symbol_expr_at_setname nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_expr_set_ref_symbol_expr_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_ip_hdr_expr_close_scope_ip_hdrversion_symbol_expr_variable_expr nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_hdrversion_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_expr_set_ref_symbol_expr_at_setname nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_expr_set_ref_symbol_expr_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" BEGIN Operators - Set membership
hi link   nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_symbol_expr_keyword_at_identifier nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_symbol_expr_keyword_at_identifier '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint4_hex nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint4_hex '\v(0x[fF]|0x[0-9a-eA-E]|[1][0-5]|[0-9])\ze[ \t\n,]' skipwhite contained

hi link   nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_expr_set_ref_symbol_expr_range_stmt_expr_symbol_dash nftHL_Element
syn match nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_expr_set_ref_symbol_expr_range_stmt_expr_symbol_dash '\v\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint4_hex

hi link   nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint4_hex_range nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint4_hex_range '\v(0x[fF]|0x[0-9a-eA-E]|[1][0-5]|[0-9])\ze\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_expr_set_ref_symbol_expr_range_stmt_expr_symbol_dash

hi link    nft_ip_hdr_expr_hdrversion_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_ip_hdr_expr_hdrversion_set_expr_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint4_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint4_hex
" END Operators - Set membership

" BEGIN Operators - Scalar
hi link   nft_ip_hdr_expr_close_scope_ip_hdrversion_integer_expr_num_uint4_hex nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_hdrversion_integer_expr_num_uint4_hex '\v(0x[fF]|0x[0-9a-eA-E]|[1][0-5]|[0-9])\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_stmt_separator,
\    @nft_c_primary_stmt_expr

hi link   nft_ip_hdr_expr_close_scope_ip_hdrversion_range_stmt_expr_keyword_dash nftHL_Element
syn match nft_ip_hdr_expr_close_scope_ip_hdrversion_range_stmt_expr_keyword_dash '\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_integer_expr_num_uint4_hex,
\    nft_Error

hi link   nft_ip_hdr_expr_close_scope_ip_hdrversion_integer_expr_num_uint4_hex_range nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_hdrversion_integer_expr_num_uint4_hex_range '\v(0x[fF]|0x[0-9a-eA-E]|[1][0-5]|[0-9])\ze[-]' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_range_stmt_expr_keyword_dash,
\    nft_Error
" END Operators - Scalar

hi link   nft_ip_hdr_expr_close_scope_ip_hdrversion_relational_op_discrete_1char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_hdrversion_relational_op_discrete_1char '\v\<|\>|lt|gt' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_integer_expr_num_uint4_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_ip_hdr_expr_close_scope_ip_hdrversion_relational_op_discrete_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_hdrversion_relational_op_discrete_2char '\v((\<|\>)\=)|((ge|le)\ze[ \t\n;])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_integer_expr_num_uint4_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string


hi link   nft_ip_hdr_expr_close_scope_ip_hdrversion_relational_expr_relational_op_symbol_exclamation nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_hdrversion_relational_expr_relational_op_symbol_exclamation '\v\!\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_hdrversion_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_integer_expr_num_uint4_hex
" 'not' operator is most flexible with scalar but never directly to a set membership ('not in' ok)

hi link   nft_ip_hdr_expr_close_scope_ip_hdrversion_relational_op_non_equality_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_hdrversion_relational_op_non_equality_2char '\v(\!\=)|(ne\ze[ \t\n;])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_hdrversion_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_integer_expr_num_uint4_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_integer_expr_num_uint4_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

hi link   nft_ip_hdr_expr_close_scope_ip_hdrversion_relational_op_equality_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_hdrversion_relational_op_equality_2char '\v(\=\=)|(eq\ze[ \t\n;\n])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_hdrversion_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_integer_expr_num_uint4_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_integer_expr_num_uint4_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" Valid range: 0-15
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_hdrversion nftHL_Substatement
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_hdrversion '\vversion\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_relational_op_equality_2char,
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_relational_op_non_equality_2char,
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_relational_op_discrete_2char,
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_relational_op_discrete_1char,
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_hdrversion_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_integer_expr_num_uint4_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_hdrversion_integer_expr_num_uint4_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" **************** END 'ip version' **********************************

" ********************** BEGIN 'ip length' ***************************
" 'length'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_close_scope_ip_length_symbol_expr_variable_expr nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_length_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" BEGIN Operators - Set membership
hi link   nft_ip_hdr_expr_close_scope_ip_length_set_ref_expr_set_ref_symbol_expr_at_setname nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_length_set_ref_expr_set_ref_symbol_expr_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_ip_hdr_expr_close_scope_ip_length_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint16_hex nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_length_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint16_hex '\v(0x([0-9a-fA-F]{3,4}|[2-9a-fA-F][0-9a-fA-F]|(1[4-9a-fA-F])))|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{4}|([0-9]{3})|[2-9][0-9])\ze[ \t\n,]' skipwhite contained

hi link   nft_ip_hdr_expr_close_scope_ip_length_set_ref_expr_set_ref_symbol_expr_range_stmt_expr_symbol_dash nftHL_Element
syn match nft_ip_hdr_expr_close_scope_ip_length_set_ref_expr_set_ref_symbol_expr_range_stmt_expr_symbol_dash '\v\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_length_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint16_hex

hi link   nft_ip_hdr_expr_close_scope_ip_length_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint16_hex_range nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_length_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint16_hex_range '\v(0x([0-9a-fA-F]{3,4}|[2-9a-fA-F][0-9a-fA-F]|(1[4-9a-fA-F])))|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{4}|([0-9]{3})|[2-9][0-9])\ze\-'  contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_length_set_ref_expr_set_ref_symbol_expr_range_stmt_expr_symbol_dash

hi link    nft_ip_hdr_expr_length_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_ip_hdr_expr_length_set_expr_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_ip_hdr_expr_close_scope_ip_length_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint16_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_length_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint16_hex
" END Operators - Set membership

" BEGIN Operators - Scalar
hi link   nft_ip_hdr_expr_close_scope_ip_length_integer_expr_num_uint16_hex nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_length_integer_expr_num_uint16_hex '\v(0x([0-9a-fA-F]{3,4}|[2-9a-fA-F][0-9a-fA-F]|(1[4-9a-fA-F])))|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{4}|([0-9]{3})|[2-9][0-9])\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr,
\    @nft_c_stmt

hi link   nft_ip_hdr_expr_close_scope_ip_length_range_stmt_expr_keyword_dash nftHL_Element
syn match nft_ip_hdr_expr_close_scope_ip_length_range_stmt_expr_keyword_dash '\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_length_integer_expr_num_uint16_hex,
\    nft_Error

hi link   nft_ip_hdr_expr_close_scope_ip_length_integer_expr_num_uint16_hex_range nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_length_integer_expr_num_uint16_hex_range '\v(0x([0-9a-fA-F]{3,4}|[2-9a-fA-F][0-9a-fA-F]|(1[4-9a-fA-F])))|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{4}|([0-9]{3})|[2-9][0-9])\ze\-' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_length_range_stmt_expr_keyword_dash,
\    nft_Error
" END Operators - Scalar

hi link   nft_ip_hdr_expr_close_scope_ip_length_relational_op_discrete_1char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_length_relational_op_discrete_1char '\v\<|\>|lt|gt' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_length_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_length_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_length_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_length_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_ip_hdr_expr_close_scope_ip_length_relational_op_discrete_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_length_relational_op_discrete_2char '\v((\<|\>)\=)|((ge|le)\ze[ \t\n;])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_length_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_length_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_length_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_length_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string


hi link   nft_ip_hdr_expr_close_scope_ip_length_relational_expr_relational_op_symbol_exclamation nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_length_relational_expr_relational_op_symbol_exclamation '\v\!\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_length_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_close_scope_ip_length_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_length_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_length_integer_expr_num_uint16_hex
" 'not' operator is most flexible with scalar but never directly to a set membership ('not in' ok)

hi link   nft_ip_hdr_expr_close_scope_ip_length_relational_op_non_equality_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_length_relational_op_non_equality_2char '\v(\!\=)|(ne\ze[ \t\n;])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_length_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_length_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_length_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_length_integer_expr_num_uint16_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_length_integer_expr_num_uint16_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

hi link   nft_ip_hdr_expr_close_scope_ip_length_relational_op_equality_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_length_relational_op_equality_2char '\v(\=\=)|(eq\ze[ \t\n;\n])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_length_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_length_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_length_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_length_integer_expr_num_uint16_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_length_integer_expr_num_uint16_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" Valid range: 0-15
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_length nftHL_Substatement
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_length '\vlength\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_ip_hdr_expr_close_scope_ip_length_relational_op_equality_2char,
\    nft_ip_hdr_expr_close_scope_ip_length_relational_op_non_equality_2char,
\    nft_ip_hdr_expr_close_scope_ip_length_relational_op_discrete_2char,
\    nft_ip_hdr_expr_close_scope_ip_length_relational_op_discrete_1char,
\    nft_ip_hdr_expr_close_scope_ip_length_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_length_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_length_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_length_integer_expr_num_uint16_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_length_integer_expr_num_uint16_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" 'ip length'
" 'length'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" ********************** END 'ip length' ***************************

" ******************* BEGIN 'ip option' *******************************
" 'ip option ra length'
" Valid range 4
hi link   nft_ip_hdr_expr_ra_ip_option_field_keyword_length nftHL_Keyword
syn match nft_ip_hdr_expr_ra_ip_option_field_keyword_length '\vlength' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_option_ra_close_scope_ip_constant_expr_int_hex_4b_field_length,
\    nft_Error

" 'ip option lsrr length'
" Valid range 4-40
hi link   nft_ip_hdr_expr_ip_option_field_keyword_length nftHL_Keyword
syn match nft_ip_hdr_expr_ip_option_field_keyword_length '\vlength' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_4b_field_length,
\    nft_Error

" 'ip option lsrr addr'
hi link   nft_ip_hdr_expr_ip_option_field_keyword_addr nftHL_Keyword
syn match nft_ip_hdr_expr_ip_option_field_keyword_addr '\vaddr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_constant_expr_string_ip_cidr,
\    nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_constant_expr_string_ip,
\    nft_Error

hi link   nft_ip_hdr_expr_ip_option_field_keyword_type nftHL_Keyword
syn match nft_ip_hdr_expr_ip_option_field_keyword_type '\vtype\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_8b,
\    nft_Error

hi link   nft_ip_hdr_expr_ip_option_field_keyword_ptr nftHL_Keyword
syn match nft_ip_hdr_expr_ip_option_field_keyword_ptr '\vptr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_4b_ptr,

" 'ip option lsrr'
hi link   nft_ip_hdr_expr_ip_option_type_keyword_lsrr nftHL_Keyword
syn match nft_ip_hdr_expr_ip_option_type_keyword_lsrr '\vlsrr' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_ip_option_field_keyword_length,
\    nft_ip_hdr_expr_ip_option_field_keyword_addr,
\    nft_ip_hdr_expr_ip_option_field_keyword_type,
\    nft_ip_hdr_expr_ip_option_field_keyword_ptr,
\    @nft_c_primary_stmt_expr

" 'ip option ssrr'
hi link   nft_ip_hdr_expr_ip_option_type_keyword_ssrr nftHL_Keyword
syn match nft_ip_hdr_expr_ip_option_type_keyword_ssrr '\vssrr' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_ip_option_field_keyword_length,
\    nft_ip_hdr_expr_ip_option_field_keyword_addr,
\    nft_ip_hdr_expr_ip_option_field_keyword_type,
\    nft_ip_hdr_expr_ip_option_field_keyword_ptr,
\    @nft_c_primary_stmt_expr

" 'ip option ra ptr 0'
hi link   nft_ip_hdr_expr_ip_option_field_keyword_type_ptr_zero nftHL_Integer
syn match nft_ip_hdr_expr_ip_option_field_keyword_type_ptr_zero '\vptr[ \t]{1,5}0\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

" 'ip option ra'
hi link   nft_ip_hdr_expr_ip_option_type_keyword_ra nftHL_Keyword
syn match nft_ip_hdr_expr_ip_option_type_keyword_ra '\vra' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_ra_ip_option_field_keyword_length,
\    nft_ip_hdr_expr_ip_option_field_keyword_value,
\    nft_ip_hdr_expr_ip_option_field_keyword_type,
\    nft_ip_hdr_expr_ip_option_field_keyword_type_ptr_zero,
\    @nft_c_primary_stmt_expr

" 'ip option rr'
hi link   nft_ip_hdr_expr_ip_option_type_keyword_rr nftHL_Keyword
syn match nft_ip_hdr_expr_ip_option_type_keyword_rr '\vrr' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_ip_option_field_keyword_length,
\    nft_ip_hdr_expr_ip_option_field_keyword_addr,
\    nft_ip_hdr_expr_ip_option_field_keyword_type,
\    nft_ip_hdr_expr_ip_option_field_keyword_ptr,
\    @nft_c_primary_stmt_expr

" 'ip option'
" 'option'->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_keyword_option nftHL_Keyword
syn match nft_ip_hdr_expr_keyword_option '\voption\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_ip_option_type_keyword_lsrr,
\    nft_ip_hdr_expr_ip_option_type_keyword_ssrr,
\    nft_ip_hdr_expr_ip_option_type_keyword_ra,
\    nft_ip_hdr_expr_ip_option_type_keyword_rr,
\    nft_Error
" ******************* END 'ip option' *******************************

" ******************* BEGIN 'ip saddr' *******************************
hi link   nft_ip_hdr_expr_close_scope_ip_saddr_symbol_expr_variable_expr nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_saddr_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" BEGIN Operators - Set membership
hi link    nft_ip_hdr_expr_saddr_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_ip_hdr_expr_saddr_set_expr_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_ip_hdr_expr_close_scope_ip_saddr_set_list_member_expr_symbol_expr_string_keyword_defines,
\    nft_ip_hdr_expr_close_scope_ip_saddr_set_list_member_expr_symbol_expr_string_ip4_opt_cidr_prefix,
\    nft_ip_hdr_expr_close_scope_ip_saddr_set_list_member_expr_symbol_expr_string_ip4,
\    nft_ip_hdr_expr_close_scope_ip_saddr_set_list_member_expr_symbol_expr_string_quoted,
\    nft_ip_hdr_expr_close_scope_ip_saddr_set_list_member_expr_symbol_expr_string_asterisk,
\    nft_ip_hdr_expr_close_scope_ip_saddr_set_list_member_expr_integer_expr_num_uint64_hex,
\    nft_ip_hdr_expr_close_scope_ip_saddr_set_list_member_expr_integer_expr_num_uint8_hex

hi link   nft_ip_hdr_expr_close_scope_ip_saddr_internal_set_expr_keyword_in nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_saddr_internal_set_expr_keyword_in '\vin\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_saddr_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_saddr_set_expr_inline_set,
\    nft_Error
" no scalar (integer) after 'in' keyword
" END Operators - Set membership

" BEGIN Operators - Scalar
hi link   nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4 nftHL_Integer
"syn match nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4 '\v(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9]{1,2})(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9]{1,2})){3}' skipwhite contained
syn match nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4 '\v(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9]{1,2})(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9]{1,2})){3}' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_ip_hdr_expr_close_scope_ip_addr_range_stmt_expr_symbol_dash nftHL_Element
syn match nft_ip_hdr_expr_close_scope_ip_addr_range_stmt_expr_symbol_dash '\v\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4,
\    nft_Error

hi link   nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4_range nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4_range '\v(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]{1,2})(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9]{1,2})){3}\ze\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_addr_range_stmt_expr_symbol_dash,
\    nft_Error

hi link   nft_ip_hdr_expr_close_scope_ip_addr_string_expr_string_ip4_cidr nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_addr_string_expr_string_ip4_cidr '\v(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]{1,2})(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9]{1,2})){3}/(3[0-2]|[12][0-9]|[0-9])\ze[ \t\n;]' skipwhite contained

hi link   nft_ip_hdr_expr_close_scope_ip_saddr_symbol_expr_string_keyword_defines nfthL_Defines
syn match nft_ip_hdr_expr_close_scope_ip_saddr_symbol_expr_string_keyword_defines '\v(abc|def)\ze[ \t\n;,]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_ip_hdr_expr_close_scope_ip_saddr_integer_expr_num_uint32_hex nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_saddr_integer_expr_num_uint32_hex '\v0x[0-9a-fA-F]{1,8}|429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_ip

hi link   nft_ip_hdr_expr_close_scope_ip_addr_hex_range_stmt_expr_symbol_dash nftHL_Element
syn match nft_ip_hdr_expr_close_scope_ip_addr_hex_range_stmt_expr_symbol_dash '\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_saddr_integer_expr_num_uint32_hex,
\    nft_Error

hi link   nft_ip_hdr_expr_close_scope_ip_saddr_integer_expr_num_uint32_hex_range nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_saddr_integer_expr_num_uint32_hex_range '\v0x[0-9a-fA-F]{1,8}|429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}\ze\-' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_addr_hex_range_stmt_expr_symbol_dash,
\    nft_Error
" END Operators - Scalar

hi link   nft_ip_hdr_expr_close_scope_ip_saddr_relational_op_discrete_1char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_saddr_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_saddr_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4,
\    nft_ip_hdr_expr_close_scope_ip_saddr_symbol_expr_string_quoted,
\    nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4,
\    nft_ip_hdr_expr_close_scope_ip_saddr_integer_expr_num_uint32_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" \    nft_ip_hdr_expr_saddr_set_expr_inline_set_not_integer,
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_ip_hdr_expr_close_scope_ip_saddr_relational_op_discrete_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_saddr_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_saddr_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4,
\    nft_ip_hdr_expr_close_scope_ip_saddr_symbol_expr_string_quoted,
\    nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4,
\    nft_ip_hdr_expr_close_scope_ip_saddr_integer_expr_num_uint32_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
"\    nft_ip_hdr_expr_saddr_set_expr_inline_set_not_integer,
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string


hi link   nft_ip_hdr_expr_close_scope_ip_saddr_relational_expr_relational_op_symbol_exclamation nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_saddr_relational_expr_relational_op_symbol_exclamation '\v\!\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_saddr_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_saddr_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_addr_string_expr_string_ip4_cidr,
\    nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4_range,
\    nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4,
\    nft_ip_hdr_expr_close_scope_ip_saddr_integer_expr_num_uint32_hex
" 'not' operator is most flexible with scalar but never directly to a set membership ('not in' ok)



hi link   nft_ip_hdr_expr_close_scope_ip_saddr_relational_op_non_equality_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_saddr_relational_op_non_equality_2char '\v(\!\=)|(ne\ze[ \t\n;])' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_saddr_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_saddr_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_addr_string_expr_string_ip4_cidr,
\    nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4_range,
\    nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4,
\    nft_ip_hdr_expr_close_scope_ip_saddr_integer_expr_num_uint32_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_saddr_integer_expr_num_uint32_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)



hi link   nft_ip_hdr_expr_close_scope_ip_saddr_relational_op_equality_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_saddr_relational_op_equality_2char '\v\=\=' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_saddr_boolean_expr_boolean_keys_keywords,
\    nft_ip_hdr_expr_close_scope_ip_saddr_symbol_expr_string_keyword_defines,
\    nft_ip_hdr_expr_close_scope_ip_saddr_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_saddr_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_addr_string_expr_string_ip4_cidr,
\    nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4_range,
\    nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4,
\    nft_ip_hdr_expr_close_scope_ip_saddr_integer_expr_num_uint32_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_saddr_integer_expr_num_uint32_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

hi link   nft_ip_hdr_expr_close_scope_ip_saddr_relational_expr_relational_op_keyword_not nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_saddr_relational_expr_relational_op_keyword_not '\v(not|\!\=)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_saddr_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_close_scope_ip_saddr_string_expr_string_ip4_cidr,
\    nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4_range,
\    nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4,
\    nft_ip_hdr_expr_saddr_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_saddr_integer_expr_num_uint32_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_saddr_integer_expr_num_uint32_hex,
" 'not' operator is most flexible with scalar but never directly to a set membership ('not in' ok)

hi link   nft_ip_hdr_expr_close_scope_ip_saddr_symbol_expr_string_keyword_any nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_saddr_symbol_expr_string_keyword_any '\vany\ze[ \t;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" 'ip saddr'
" 'saddr'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_saddr nftHL_Substatement
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_saddr '\vsaddr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_ip_hdr_expr_close_scope_ip_saddr_relational_expr_relational_op_keyword_not,
\    nft_ip_hdr_expr_close_scope_ip_saddr_relational_op_equality_2char,
\    nft_ip_hdr_expr_close_scope_ip_saddr_relational_op_discrete_2char,
\    nft_ip_hdr_expr_close_scope_ip_saddr_internal_set_expr_keyword_in,
\    nft_ip_hdr_expr_close_scope_ip_saddr_relational_op_discrete_1char,
\    nft_ip_hdr_expr_close_scope_ip_saddr_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_saddr_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_addr_string_expr_string_ip4_cidr,
\    nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4_range,
\    nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4,
\    nft_ip_hdr_expr_close_scope_ip_saddr_integer_expr_num_uint32_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_saddr_integer_expr_num_uint32_hex,
\    nft_Error

"\    nft_verdict_map_stmt_keyword_vmap,
"\    nft_map_stmt_expr_keyword_map,
"\    nft_payload_stmt_keyword_set,
"\    nft_ip_hdr_expr_close_scope_ip_addr_relational_expr_relational_op_keyword_not,
"\    nft_ip_hdr_expr_close_scope_ip_addr_internal_keyword_in,
"\    nft_ip_hdr_expr_close_scope_ip_addr_relational_expr_relational_op_2char,
"\    nft_ip_hdr_expr_close_scope_ip_addr_relational_expr_relational_op_1char,
"\    nft_ip_hdr_expr_close_scope_ip_addr_set_expr_inline_set,
"\    nft_ip_hdr_expr_close_scope_ip_addr_set_ref_symbol_expr_at_setname,
"\    nft_primary_stmt_expr_payload_expr_symbol_expr_variable_expr_identifier,
"\    nft_ip_hdr_expr_close_scope_ip_addr_constant_expr_string_ip_cidr,
"\    nft_Error
" ********************* END 'ip saddr' *******************************

" ******************* BEGIN 'ip daddr' *******************************
" 'ip daddr'
" 'daddr'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_daddr nftHL_Substatement
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_daddr '\vdaddr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_ip_hdr_expr_close_scope_ip_saddr_relational_expr_relational_op_keyword_not,
\    nft_ip_hdr_expr_close_scope_ip_saddr_relational_op_equality_2char,
\    nft_ip_hdr_expr_close_scope_ip_saddr_relational_op_discrete_2char,
\    nft_ip_hdr_expr_close_scope_ip_saddr_internal_set_expr_keyword_in,
\    nft_ip_hdr_expr_close_scope_ip_saddr_relational_op_discrete_1char,
\    nft_ip_hdr_expr_close_scope_ip_saddr_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_saddr_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_addr_string_expr_string_ip4_cidr,
\    nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4_range,
\    nft_ip_hdr_expr_close_scope_ip_addr_payload_expr_string_ip4,
\    nft_ip_hdr_expr_close_scope_ip_saddr_integer_expr_num_uint32_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_saddr_integer_expr_num_uint32_hex,
\    nft_Error
" ********************* END 'ip daddr' *******************************

" 'ip' 'dscp' <NUM>
hi link   nft_ip_hdr_field_keyword_dscp_id_label nftHL_Label
syn match nft_ip_hdr_field_keyword_dscp_id_label '\v(ef|cs[0-7]|af[1-4][1-3])' skipwhite contained
\ nextgroup=
\    nft_EOS
" **************** BEGIN 'ip dscp' ***********************************
" 'ip dscp'
" 'dscp'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" Valid range: 0-63, 6-bit
hi link   nft_ip_hdr_expr_close_scope_ip_dscp_symbol_expr_variable_expr nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_dscp_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_ip_hdr_field_dscp_set_expr_symbol_expr_string_keyword_defines nftHL_Label
syn match nft_ip_hdr_field_dscp_set_expr_symbol_expr_string_keyword_defines '\v(df|be|lephb|va|ef|cs[0-7]|af[1-4][1-3])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_field_keyword_dscp_set_comma

" BEGIN Operators - Set membership
hi link   nft_ip_hdr_expr_close_scope_ip_dscp_set_expr_integer_expr_uint6b_hex nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_dscp_set_expr_integer_expr_uint6b_hex '\v(0x[0-3][0-9a-fA-F])|0x[0-9a-fA-F]|6[0-3]|([0-5]|[5-9])\ze[ \t\n,]' contained

hi link   nft_ip_hdr_expr_close_scope_ip_dscp_set_expr_range_stmt_expr_symbol_dash nftHL_Element
syn match nft_ip_hdr_expr_close_scope_ip_dscp_set_expr_range_stmt_expr_symbol_dash '\-' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_dscp_set_expr_integer_expr_uint6b_hex,
\    nft_Error

hi link   nft_ip_hdr_expr_close_scope_ip_dscp_set_expr_integer_expr_uint6b_hex_range nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_dscp_set_expr_integer_expr_uint6b_hex_range '\v(0x[0-3][0-9a-fA-F])|0x[0-9a-fA-F]|6[0-3]|([0-5]|[5-9])\ze[ \t\n\-]' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_dscp_set_expr_range_stmt_expr_symbol_dash,
\    nft_Error

hi link    nft_ip_hdr_expr_dscp_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_ip_hdr_expr_dscp_set_expr_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_ip_hdr_field_dscp_set_expr_symbol_expr_string_keyword_defines,
\    nft_ip_hdr_expr_close_scope_ip_dscp_set_expr_integer_expr_uint6b_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_dscp_set_expr_integer_expr_uint6b_hex,
" END Operators - Set membership

" BEGIN Operators - Scalar
hi link   nft_ip_hdr_field_dscp_symbol_expr_string_keyword_defines nftHL_Label
syn match nft_ip_hdr_field_dscp_symbol_expr_string_keyword_defines '\v(df|be|lephb|va|ef|cs[0-7]|af[1-4][1-3])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_field_keyword_dscp_set_comma

hi link   nft_ip_hdr_field_dscp_set_expr_symbol_expr_string_keyword_defines nftHL_Label
syn match nft_ip_hdr_field_dscp_set_expr_symbol_expr_string_keyword_defines '\v(df|be|lephb|va|ef|cs[0-7]|af[1-4][1-3])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_field_keyword_dscp_set_comma

hi link   nft_ip_hdr_expr_close_scope_ip_dscp_integer_expr_uint6b_hex nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_dscp_integer_expr_uint6b_hex '\v(0x[0-3][0-9a-fA-F])|0x[0-9a-fA-F]|6[0-3]|([0-5]|[5-9])\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_Error

hi link   nft_ip_hdr_expr_close_scope_ip_dscp_range_stmt_expr_symbol_dash nftHL_Element
syn match nft_ip_hdr_expr_close_scope_ip_dscp_range_stmt_expr_symbol_dash '\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_dscp_integer_expr_uint6b_hex,
\    nft_Error

hi link   nft_ip_hdr_expr_close_scope_ip_dscp_integer_expr_uint6b_hex_range nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_dscp_integer_expr_uint6b_hex_range '\v(0x[0-3][0-9a-fA-F])|0x[0-9a-fA-F]|6[0-3]|([0-5]|[5-9])\ze\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_dscp_range_stmt_expr_symbol_dash,
\    nft_Error
" END Operators - Scalar

hi link   nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_dscp_at_setname nftHL_AtSetname
syn match nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_dscp_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t]' skipwhite contained

hi link   nft_ip_hdr_expr_close_scope_ip_dscp_relational_op_discrete_1char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_dscp_relational_op_discrete_1char '\v\<|\>\ze[ \t0-9]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_field_dscp_symbol_expr_string_keyword_defines,
\    nft_ip_hdr_field_keyword_dscp_id_label,
\    nft_ip_hdr_expr_close_scope_ip_dscp_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_close_scope_ip_dscp_integer_expr_uint6b_hex,
\    nft_Error

hi link   nft_ip_hdr_expr_close_scope_ip_dscp_relational_op_discrete_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_dscp_relational_op_discrete_2char '\v\>\=|\<\=' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_field_dscp_symbol_expr_string_keyword_defines,
\    nft_ip_hdr_field_keyword_dscp_id_label,
\    nft_ip_hdr_expr_close_scope_ip_dscp_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_close_scope_ip_dscp_integer_expr_uint6b_hex,
\    nft_Error


hi link   nft_ip_hdr_expr_close_scope_ip_dscp_relational_op_equality_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_dscp_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_field_dscp_symbol_expr_string_keyword_defines,
\    nft_ip_hdr_field_keyword_dscp_id_label,
\    nft_ip_hdr_expr_dscp_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_dscp_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_close_scope_ip_dscp_integer_expr_uint6b_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_dscp_integer_expr_uint6b_hex,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" 'ip dscp'
" 'dscp'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" Valid range: 5-15
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_dscp nftHL_Substatement
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_dscp '\vdscp\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_field_dscp_symbol_expr_string_keyword_defines,
\    nft_ip_hdr_field_keyword_dscp_id_label,
\    nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_dscp_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_dscp_relational_op_discrete_2char,
\    nft_ip_hdr_expr_close_scope_ip_dscp_relational_op_equality_2char,
\    nft_ip_hdr_expr_close_scope_ip_dscp_relational_op_discrete_1char,
\    nft_ip_hdr_expr_close_scope_ip_dscp_integer_expr_uint6b_hex,
\    nft_UnexpectedNonNumber,
\    nft_Error
" **************** END 'ip dscp' ***********************************

" **************** BEGIN 'ip ecn' ***********************************
" 'ecn'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_close_scope_ip_ecn_symbol_expr_variable_expr nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_ecn_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" BEGIN Operators - Set membership
hi link   nft_ip_hdr_expr_close_scope_ip_ecn_set_ref_expr_set_ref_symbol_expr_at_setname nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_ecn_set_ref_expr_set_ref_symbol_expr_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_ip_hdr_expr_close_scope_ip_ecn_set_expr_integer_expr_uint6b_hex nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_ecn_set_expr_integer_expr_uint6b_hex '\v(0x[0-3][0-9a-fA-F])|0x[0-9a-fA-F]|6[0-3]|([0-5]|[5-9])\ze[ \t\n,]' contained

hi link    nft_ip_hdr_expr_ecn_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_ip_hdr_expr_ecn_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_ip_hdr_field_ecn_set_expr_symbol_expr_string_keyword_defines,
\    nft_ip_hdr_expr_close_scope_ip_ecn_set_expr_integer_expr_uint6b_hex,
" END Operators - Set membership

" BEGIN Operators - Scalar
hi link   nft_ip_hdr_expr_close_scope_ip_ecn_integer_expr_num_uint2_hex nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_ecn_integer_expr_num_uint2_hex '\v(0x[0-3])|[0-3]\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_stmt_separator,
\    @nft_c_primary_stmt_expr

hi link   nft_ip_hdr_expr_close_scope_ip_ecn_range_stmt_expr_keyword_dash nftHL_Element
syn match nft_ip_hdr_expr_close_scope_ip_ecn_range_stmt_expr_keyword_dash '\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_ecn_integer_expr_num_uint2_hex,
\    nft_Error

hi link   nft_ip_hdr_expr_close_scope_ip_ecn_integer_expr_num_uint2_hex_range nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_ecn_integer_expr_num_uint2_hex_range '\v(0x[0-3])|[0-3]\ze[-]' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_ecn_range_stmt_expr_keyword_dash,
\    nft_Error
" END Operators - Scalar

hi link   nft_ip_hdr_expr_close_scope_ip_ecn_relational_op_discrete_1char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_ecn_relational_op_discrete_1char '\v\<|\>|lt|gt' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_ecn_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_ecn_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_close_scope_ip_ecn_integer_expr_num_uint2_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_ip_hdr_expr_close_scope_ip_ecn_relational_op_discrete_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_ecn_relational_op_discrete_2char '\v((\<|\>)\=)|((ge|le)\ze[ \t\n;])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_ecn_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_ecn_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_close_scope_ip_ecn_integer_expr_num_uint2_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string


hi link   nft_ip_hdr_expr_close_scope_ip_ecn_relational_expr_relational_op_symbol_exclamation nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_ecn_relational_expr_relational_op_symbol_exclamation '\v\!\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_ecn_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_close_scope_ip_ecn_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_ecn_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_ecn_integer_expr_num_uint2_hex
" 'not' operator is most flexible with scalar but never directly to a set membership ('not in' ok)

hi link   nft_ip_hdr_expr_close_scope_ip_ecn_relational_op_non_equality_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_ecn_relational_op_non_equality_2char '\v(\!\=)|(ne\ze[ \t\n;])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_ecn_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_ecn_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_ecn_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_ecn_integer_expr_num_uint2_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_ecn_integer_expr_num_uint2_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

hi link   nft_ip_hdr_expr_close_scope_ip_ecn_relational_op_equality_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_ecn_relational_op_equality_2char '\v(\=\=)|(eq\ze[ \t\n;\n])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_ecn_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_ecn_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_ecn_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_ecn_integer_expr_num_uint2_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_ecn_integer_expr_num_uint2_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" Valid range: 0-15
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_ecn nftHL_Substatement
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_ecn '\vecn\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_ip_hdr_expr_close_scope_ip_ecn_relational_op_equality_2char,
\    nft_ip_hdr_expr_close_scope_ip_ecn_relational_op_non_equality_2char,
\    nft_ip_hdr_expr_close_scope_ip_ecn_relational_op_discrete_2char,
\    nft_ip_hdr_expr_close_scope_ip_ecn_relational_op_discrete_1char,
\    nft_ip_hdr_expr_close_scope_ip_ecn_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_ecn_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_ecn_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_ecn_integer_expr_num_uint2_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_ecn_integer_expr_num_uint2_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" 'ip ecn'
" 'ecn'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" Valid range: 0-3
" **************** END 'ip ecn' ***********************************

" **************** BEGIN 'ip ttl' ***********************************
" 'ip ttl'
" 'ttl'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" Valid range: 0-255
hi link   nft_ip_hdr_expr_close_scope_ip_ttl_symbol_expr_variable_expr nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_ttl_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" BEGIN Operators - Set membership
hi link   nft_ip_hdr_expr_close_scope_ip_ttl_set_ref_expr_set_ref_symbol_expr_at_setname nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_ttl_set_ref_expr_set_ref_symbol_expr_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_ip_hdr_expr_close_scope_ip_ttl_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint16_hex nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_ttl_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint16_hex '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9]{1,2})\ze[ \t\n,]' skipwhite contained

hi link   nft_ip_hdr_expr_close_scope_ip_ttl_set_ref_expr_set_ref_symbol_expr_range_stmt_expr_symbol_dash nftHL_Element
syn match nft_ip_hdr_expr_close_scope_ip_ttl_set_ref_expr_set_ref_symbol_expr_range_stmt_expr_symbol_dash '\v\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_ttl_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint16_hex

hi link   nft_ip_hdr_expr_close_scope_ip_ttl_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint16_hex_range nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_ttl_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint16_hex_range '\v(0x[0-9a-eA-E]{1,2}|2][0-5][0-9]|1[0-9][0-9]|[0-9]{1,2})\ze\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_ttl_set_ref_expr_set_ref_symbol_expr_range_stmt_expr_symbol_dash

hi link    nft_ip_hdr_expr_ttl_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_ip_hdr_expr_ttl_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_ip_hdr_expr_close_scope_ip_ttl_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint16_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_ttl_set_ref_expr_set_ref_symbol_expr_integer_expr_num_uint16_hex
"

" END Operators - Set membership

" BEGIN Operators - Scalar
hi link   nft_ip_hdr_expr_close_scope_ip_ttl_integer_expr_num_uint8_hex nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_ttl_integer_expr_num_uint8_hex '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9]{1,2})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr,
\    @nft_c_stmt

hi link   nft_ip_hdr_expr_close_scope_ip_ttl_range_stmt_expr_keyword_dash nftHL_Element
syn match nft_ip_hdr_expr_close_scope_ip_ttl_range_stmt_expr_keyword_dash '\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_ttl_integer_expr_num_uint8_hex,
\    nft_Error

hi link   nft_ip_hdr_expr_close_scope_ip_ttl_integer_expr_num_uint8_hex_range nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_ttl_integer_expr_num_uint8_hex_range '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9]{1,2})\ze\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_ttl_range_stmt_expr_keyword_dash,
\    nft_Error
" END Operators - Scalar

hi link   nft_ip_hdr_expr_close_scope_ip_ttl_relational_op_discrete_1char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_ttl_relational_op_discrete_1char '\v\<|\>|lt|gt' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_ttl_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_ttl_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_ttl_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_ttl_integer_expr_num_uint8_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_ip_hdr_expr_close_scope_ip_ttl_relational_op_discrete_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_ttl_relational_op_discrete_2char '\v((\<|\>)\=)|((ge|le)\ze[ \t\n;])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_ttl_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_ttl_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_ttl_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_ttl_integer_expr_num_uint8_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_ip_hdr_expr_close_scope_ip_ttl_relational_expr_relational_op_symbol_exclamation nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_ttl_relational_expr_relational_op_symbol_exclamation '\v\!\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_ttl_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_close_scope_ip_ttl_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_ttl_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_ttl_integer_expr_num_uint8_hex
" 'not' operator is most flexible with scalar but never directly to a set membership ('not in' ok)

hi link   nft_ip_hdr_expr_close_scope_ip_ttl_relational_op_non_equality_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_ttl_relational_op_non_equality_2char '\v(\!\=)|(ne\ze[ \t\n;])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_ttl_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_ttl_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_ttl_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_ttl_integer_expr_num_uint8_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_ttl_integer_expr_num_uint8_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

hi link   nft_ip_hdr_expr_close_scope_ip_ttl_relational_op_equality_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_ttl_relational_op_equality_2char '\v(\=\=)|(eq\ze[ \t\n;\n])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_ttl_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_ttl_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_ttl_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_ttl_integer_expr_num_uint8_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_ttl_integer_expr_num_uint8_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" Valid range: 0-15
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_ttl nftHL_Substatement
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_ttl '\vttl\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_ip_hdr_expr_close_scope_ip_ttl_relational_op_equality_2char,
\    nft_ip_hdr_expr_close_scope_ip_ttl_relational_op_non_equality_2char,
\    nft_ip_hdr_expr_close_scope_ip_ttl_relational_op_discrete_2char,
\    nft_ip_hdr_expr_close_scope_ip_ttl_relational_op_discrete_1char,
\    nft_ip_hdr_expr_close_scope_ip_ttl_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_ttl_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_ttl_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_ttl_integer_expr_num_uint8_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_ttl_integer_expr_num_uint8_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" **************** END 'ip ttl' ***********************************

" **************** BEGIN 'ip id' ***********************************
" 'ip id'
" 'id'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" Valid range: 0-65535
" 'id'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_close_scope_ip_id_symbol_expr_variable_expr nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_id_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" BEGIN Operators - Set membership
hi link   nft_ip_hdr_expr_close_scope_ip_id_set_ref_expr_set_ref_symbol_expr_at_setname nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_id_set_ref_expr_set_ref_symbol_expr_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt
" 'ip dscp'
" 'dscp'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" Valid range: 0-63, 6-bit
hi link   nft_ip_hdr_expr_close_scope_ip_dscp_symbol_expr_variable_expr nftHL_Variable
syn match nft_ip_hdr_expr_close_scope_ip_dscp_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_ip_hdr_field_dscp_set_expr_symbol_expr_string_keyword_defines nftHL_Label
syn match nft_ip_hdr_field_dscp_set_expr_symbol_expr_string_keyword_defines '\v(df|be|lephb|va|ef|cs[0-7]|af[1-4][1-3])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_field_keyword_dscp_set_comma

" BEGIN Operators - Set membership
hi link   nft_ip_hdr_expr_close_scope_ip_dscp_set_expr_integer_expr_uint6b_hex nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_dscp_set_expr_integer_expr_uint6b_hex '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{4}|[0-9]{1,4})\ze[ \t\n,]' contained

hi link   nft_ip_hdr_expr_close_scope_ip_dscp_set_expr_range_stmt_expr_symbol_dash nftHL_Element
syn match nft_ip_hdr_expr_close_scope_ip_dscp_set_expr_range_stmt_expr_symbol_dash '\-' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_dscp_set_expr_integer_expr_uint6b_hex,
\    nft_Error

hi link   nft_ip_hdr_expr_close_scope_ip_dscp_set_expr_integer_expr_uint6b_hex_range nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_dscp_set_expr_integer_expr_uint6b_hex_range '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{4}|[0-9]{1,4})\ze\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_dscp_set_expr_range_stmt_expr_symbol_dash,
\    nft_Error

hi link    nft_ip_hdr_expr_id_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_ip_hdr_expr_id_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_ip_hdr_field_dscp_set_expr_symbol_expr_string_keyword_defines,
\    nft_ip_hdr_expr_close_scope_ip_dscp_set_expr_integer_expr_uint6b_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_dscp_set_expr_integer_expr_uint6b_hex,
" END Operators - Set membership

" BEGIN Operators - Scalar
hi link   nft_ip_hdr_expr_close_scope_ip_id_integer_expr_num_uint16_hex nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_id_integer_expr_num_uint16_hex '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{4}|[0-9]{1,4})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr,
\    @nft_c_stmt

hi link   nft_ip_hdr_expr_close_scope_ip_id_range_stmt_expr_keyword_dash nftHL_Element
syn match nft_ip_hdr_expr_close_scope_ip_id_range_stmt_expr_keyword_dash '\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_id_integer_expr_num_uint16_hex,
\    nft_Error

hi link   nft_ip_hdr_expr_close_scope_ip_id_integer_expr_num_uint16_hex_range nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_id_integer_expr_num_uint16_hex_range '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{4}|[0-9]{1,4})\ze\-' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_id_range_stmt_expr_keyword_dash,
\    nft_Error
" END Operators - Scalar

hi link   nft_ip_hdr_expr_close_scope_ip_id_relational_op_discrete_1char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_id_relational_op_discrete_1char '\v\<|\>|lt|gt' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_id_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_id_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_id_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_id_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_ip_hdr_expr_close_scope_ip_id_relational_op_discrete_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_id_relational_op_discrete_2char '\v((\<|\>)\=)|((ge|le)\ze[ \t\n;])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_id_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_id_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_id_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_id_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string


hi link   nft_ip_hdr_expr_close_scope_ip_id_relational_expr_relational_op_symbol_exclamation nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_id_relational_expr_relational_op_symbol_exclamation '\v\!\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_id_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_close_scope_ip_id_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_id_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_id_integer_expr_num_uint16_hex
" 'not' operator is most flexible with scalar but never directly to a set membership ('not in' ok)

hi link   nft_ip_hdr_expr_close_scope_ip_id_relational_op_non_equality_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_id_relational_op_non_equality_2char '\v(\!\=)|(ne\ze[ \t\n;])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_id_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_id_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_id_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_id_integer_expr_num_uint16_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_id_integer_expr_num_uint16_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

hi link   nft_ip_hdr_expr_close_scope_ip_id_relational_op_equality_2char nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_id_relational_op_equality_2char '\v(\=\=)|(eq\ze[ \t\n;\n])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_id_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_id_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_id_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_id_integer_expr_num_uint16_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_id_integer_expr_num_uint16_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" Valid range: 0-15
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_id nftHL_Substatement
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_id '\vid\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_ip_hdr_expr_close_scope_ip_id_relational_op_equality_2char,
\    nft_ip_hdr_expr_close_scope_ip_id_relational_op_non_equality_2char,
\    nft_ip_hdr_expr_close_scope_ip_id_relational_op_discrete_2char,
\    nft_ip_hdr_expr_close_scope_ip_id_relational_op_discrete_1char,
\    nft_ip_hdr_expr_close_scope_ip_id_set_ref_expr_set_ref_symbol_expr_at_setname,
\    nft_ip_hdr_expr_close_scope_ip_id_symbol_expr_variable_expr,
\    nft_ip_hdr_expr_id_set_expr_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_id_integer_expr_num_uint16_hex_range,
\    nft_ip_hdr_expr_close_scope_ip_id_integer_expr_num_uint16_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" 'ip id'
" 'id'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" **************** END 'ip id' ***********************************


" **************** BEGIN 'ip' ***********************************
" 'ip'
" ip_hdr_expr
" 'ip'->ip_hdr_expr
hi link   nft_ip_hdr_expr_keyword_ip nftHL_Substatement
syn match nft_ip_hdr_expr_keyword_ip '\vip\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_ip_hdr_field_keyword_hdrversion,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_hdrlength,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_checksum,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_frag_off,
\    nft_ip_hdr_expr_keyword_option,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_daddr,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_saddr,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_dscp,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_ecn,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_ttl,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_id,
\    nft_Error
"\    nft_ip_hdr_expr_ip_hdr_field_keyword_protocol,
" **************** END 'ip' ***********************************


  for s:this_semantic_file in s:ip_hdr_expr_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded ip_hdr_expr for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define ip_hdr_expr.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_ip_hdr_expr = v:true
