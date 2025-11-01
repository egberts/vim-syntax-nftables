" File: tcp_hdr_expr.vim
" Directory: custom/nftables/table/chain/stmt/expr/
"
" Field     Datatype   Value Range,Notes
" sport     uint16     0-65535       Source port (e.g., tcp sport 80).
" dport     uint16     0-65535       Destination port (e.g., tcp dport 443).
" sequence  uint32     0-4294967295  Sequence number.
" ackseq    uint32     0-4294967295  Acknowledgment sequence number.
" doff      uint4      5-15          Data offset (header length in 32-bit words; minimum 5 for 20-byte header).
"                          0.5–1.875 * 32 bits
" reserved  uint4      0-15          Reserved bits (must be 0).
" flags     uint8      0-255         bitmask flags
"                                    CWR=128, ECE=64, URG=32, ACK=16, PSH=8, RST=4, SYN=2, FIN=1
" window    uint16     0-65535       Window size (bytes).
" checksum  uint16     0-65535       Checksum (calculated by kernel).
" urgptr    uint16     0-65535       Urgent pointer.
" kind      uint8      0-255
" length    uint8      0-255
"
" nftables 'tcp' gotchas:
"  - No chaining of tcp_hdr_field; you cannot omit 'tcp'
"    when chaining multiple TCP header fields or options
"    in nftables v1.1.4
"  - Convention: a separate line for each tcp field/option
"
" Option     Value    Field    Value    Notes
" kind                         Range
"
" echo       8        LENGTH   0–255    Option length.
" eol        0                          End of options (no fields).
" fastopen  34        LENGTH   0–255    Option length.
" md5sig    19        LENGTH   0–255    Option length (fixed 18).
" mptcp     30        SUBTYPE  0–255    MPTCP subtype (e.g., 0=MP_CAPABLE, 1=MP_JOIN).
" mss        2        SIZE     0–65535  Maximum segment size (e.g., tcp option mss size 1460).
" nop        1                          No operation (no fields).
" sack_perm  4        LENGTH   0–255    Option length (fixed 2).
" timestamp  8        TSVAL    0–4294967295  Timestamp value.
"                     TSECR,   0–4294967295  Timestamp echo reply.
" window     3        COUNT    0–255    Scale count (0–14).
" sack       5        LEFT     0–4294967295  Left edge of SACK.
" sack1      5        RIGHT    0–4294967295  Right edge of SACK.
" sack2      5                               Additional SACK edges (similar to LEFT/RIGHT).
" sack3      5                               Additional SACK edges (similar to LEFT/RIGHT).
" Custom     0–255    LENGTH   0–255    Generic option length.

let s:tcp_hdr_expr_list_filepaths_semantic_early = [
\        'table/chain/stmt/expr/tcp_hdr_option_type.vim'
\    ]
let s:tcp_hdr_expr_list_filepaths_semantic_later = []

if exists('b:did_nftables_tcp_hdr_expr')
  call nftables#syntax#log('INFO', 'Skipped tcp_hdr_expr (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:tcp_hdr_expr_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading tcp_hdr_expr syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "




" 'tcp' '.*' [ 'accept' / 'drop' ]
hi link   nft_tcp_hdr_field_keyword_action nftHL_Action
syn match nft_tcp_hdr_field_keyword_action '\v(accept|drop)' skipwhite contained
\ nextgroup=
\    nft_EOS

" 'tcp' 'sport' 'vmap' '{'
" tcp_hdr_field (via tcp_hdr_expr) (outside of Bison/Yacc)
" tcp_hdr_field->tcp_hdr_expr->'tcp'->[payload_expr|inner_inet_expr]
hi link   nft_tcp_hdr_field_keywords_ports_keyword_vmap_num_or_numrange_5digit nftHL_Number
syn match nft_tcp_hdr_field_keywords_ports_keyword_vmap_num_or_numrange_5digit '\v[0-9]{1,5}(\-[0-9]{1,5})?' skipwhite contained
\ nextgroup=
\    nft_tcp_hdr_field_keywords_ports_keyword_vmap_block_expression_comma,
\    nft_EOS

" 'tcp' 'sport' <NUM> [ '-' <NUM> ]
" tcp_hdr_field  (outside of Bison/Yacc)
hi link   nft_tcp_hdr_field_keywords_ports_num_or_numrange_5digit nftHL_Number
syn match nft_tcp_hdr_field_keywords_ports_num_or_numrange_5digit '\v[0-9]{1,5}(\-[0-9]{1,5})?' skipwhite contained
\ nextgroup=
\    nft_tcp_hdr_field_keywords_ports_block_expression_comma

" 'tcp' 'sport' 'vmap' '{' '!='
" tcp_hdr_field  (outside of Bison/Yacc)
hi link   nft_tcp_hdr_field_keywords_ports_keyword_vmap_operator_negative nftHL_Operator
syn match nft_tcp_hdr_field_keywords_ports_keyword_vmap_operator_negative '\v\!\=' skipwhite contained
\ nextgroup=
\    nft_tcp_hdr_field_keywords_ports_keyword_vmap_num_or_numrange_5digit,
\    nft_tcp_hdr_field_keywords_ports_keyword_vmap_service_name,
\    nft_Error

" 'tcp' 'sport' <NUM> [ '-' <NUM> ]
" tcp_hdr_field  (outside of Bison/Yacc)
hi link   nft_tcp_hdr_field_keywords_ports_operator_negative nftHL_Operator
syn match nft_tcp_hdr_field_keywords_ports_operator_negative '\v\!\=' skipwhite contained
\ nextgroup=
\    nft_tcp_hdr_field_keywords_ports_num_or_numrange_5digit,
\    nft_tcp_hdr_field_keywords_ports_service_name,
\    nft_Error

" 'tcp' 'sport' 'vmap' '{' service_name ','
" tcp_hdr_field  (outside of Bison/Yacc)
hi link   nft_tcp_hdr_field_keywords_ports_keyword_vmap_block_expression_comma nftHL_Element
syn match nft_tcp_hdr_field_keywords_ports_keyword_vmap_block_expression_comma ',' skipwhite contained
\ nextgroup=
\    nft_tcp_hdr_field_ports_keywords_ports_keyword_vmap_num_or_numrange_5digit,
\    nft_tcp_hdr_field_ports_keywords_ports_keyword_vmap_operator_negative,
\    nft_tcp_hdr_field_ports_keywords_ports_keyword_vmap_service_name

" 'tcp' 'sport' '{' service_name ','
" tcp_hdr_field  (outside of Bison/Yacc)
hi link   nft_tcp_hdr_field_keywords_ports_block_expression_comma nftHL_Element
syn match nft_tcp_hdr_field_keywords_ports_block_expression_comma ',' skipwhite contained
\ nextgroup=
\    nft_tcp_hdr_field_ports_keywords_ports_num_or_numrange_5digit,
\    nft_tcp_hdr_field_ports_keywords_ports_operator_negative,
\    nft_tcp_hdr_field_ports_keywords_ports_service_name

" 'tcp' 'sport' vmap '{' <NUM>
" tcp_hdr_field  (outside of Bison/Yacc)
hi link   nft_tcp_hdr_field_keywords_ports_keyword_vmap_block_service_name nftHL_Identifier
syn match nft_tcp_hdr_field_keywords_ports_keyword_vmap_block_service_name '\v[a-z]{1,17}' skipwhite contained
\ nextgroup=
\    nft_tcp_hdr_field_keywords_ports_keyword_vmap_block_block_expression_comma

" 'tcp' 'sport' <NUM> [ '-' <NUM> ]
" tcp_hdr_field  (outside of Bison/Yacc)
hi link   nft_tcp_hdr_field_keywords_ports_service_name nftHL_Identifier
syn match nft_tcp_hdr_field_keywords_ports_service_name '\v[a-z]{1,17}' skipwhite contained
\ nextgroup=
\    nft_tcp_hdr_field_keywords_ports_block_expression_comma

" 'tcp' 'sport' '{' <NUM> ',' <NUM> '}'
hi link    nft_tcp_hdr_field_keywords_ports_block_delimiter nftHL_BlockDelimitersSet
syn region nft_tcp_hdr_field_keywords_ports_block_delimiter start='{' end='}' skipwhite contained
\ contains=
\    nft_tcp_hdr_field_keywords_ports_num_or_numrange_5digit,
\    nft_tcp_hdr_field_keywords_ports_operator_negative,
\    nft_tcp_hdr_field_keywords_ports_service_name

" 'tcp' 'sport' 'vmap' '{'
hi link    nft_tcp_hdr_field_keywords_ports_keyword_vmap_block_delimiter nftHL_BlockDelimitersLimit
syn region nft_tcp_hdr_field_keywords_ports_keyword_vmap_block_delimiter start='{' end='}' skipwhite contained
\ contains=
\    nft_tcp_hdr_field_keywords_ports_keyword_vmap_num_or_numrange_5digit,
\    nft_tcp_hdr_field_keywords_ports_keyword_vmap_operator_negative,
\    nft_tcp_hdr_field_keywords_ports_keyword_vmap_service_name

" 'tcp' 'sport' <NUM> [ '-' <NUM> ]
" tcp_hdr_field  (outside of Bison/Yacc)
hi link   nft_tcp_hdr_field_keywords_ports_keyword_vmap nftHL_Action
syn match nft_tcp_hdr_field_keywords_ports_keyword_vmap 'vmap' skipwhite contained
\ nextgroup=
\    nft_tcp_hdr_field_keywords_ports_keyword_vmap_block_delimiter

syn cluster nft_c_stmt_hdr_expr_tcp_hdr_field_keywords_ports_block
\ contains=
\    nft_tcp_hdr_field_keywords_ports_num_or_numrange_5digit,
\    nft_tcp_hdr_field_keywords_ports_operator_negative,
\    nft_tcp_hdr_field_keywords_ports_block_delimiter,
\    nft_tcp_hdr_field_keywords_ports_keyword_vmap,
\    nft_tcp_hdr_field_keywords_ports_service_name

" 'tcp' 'dport'
" tcp_hdr_field  (outside of Bison/Yacc)
hi link   nft_tcp_hdr_field_keywords nftHL_Action
syn match nft_tcp_hdr_field_keywords '\vdport\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt_hdr_expr_tcp_hdr_field_keywords_ports_block,
\    nft_EOS,
\    nft_Error

" 'tcp' 'sport'
" tcp_hdr_field  (outside of Bison/Yacc)
hi link   nft_tcp_hdr_field_keywords nftHL_Action
syn match nft_tcp_hdr_field_keywords '\vsport\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt_hdr_expr_tcp_hdr_field_keywords_ports_block,
\    nft_EOS,
\    nft_Error
hi link   nft_tcp_hdr_field_keywords nftHL_Action

syn match nft_tcp_hdr_field_keywords '\v(sequence|ackseq|doff|reserved|flags|window|checksum|urgptr)' skipwhite contained
\ nextgroup=
\    @nft_c_stmt_hdr_expr_tcp_hdr_field_keywords_ports_block,
\    nft_EOS,
\    nft_Error


" tcp_hdr_expr->inner_inet_expr->inner_expr->(vxlan_hdr_expr|gretap_hdr_expr|geneve_hdr_expr)
" tcp_hdr_expr 'option' 'tcp' 'at' tcp_hdr_option_type ',' NUM ',' (via tcp_hdr_expr)
hi link   nft_tcp_hdr_option_at_payload_raw_len nftHL_Number
syn match nft_tcp_hdr_option_at_payload_raw_len '\v[0-9]{1,11}' skipwhite contained

" tcp_hdr_expr 'option' 'tcp' 'at' tcp_hdr_option_type ',' NUM ',' (via tcp_hdr_expr)
hi link   nft_tcp_hdr_option_at_comma2 nftHL_Expression
syn match nft_tcp_hdr_option_at_comma2 ',' skipwhite contained
\ nextgroup=
\    nft_tcp_hdr_option_at_payload_raw_len,
\    nft_Error_Always

" tcp_hdr_expr 'option' 'tcp' 'at' tcp_hdr_option_type ',' NUM (via tcp_hdr_expr)
hi link   nft_tcp_hdr_option_at_num nftHL_Number
syn match nft_tcp_hdr_option_at_num '\v[0-9]{1,11}' skipwhite contained
\ nextgroup=
\    nft_tcp_hdr_option_at_comma2,
\    nft_Error_Always

" tcp_hdr_expr 'option' 'tcp' 'at' tcp_hdr_option_type ',' (via tcp_hdr_expr)
hi link   nft_tcp_hdr_option_at_comma nftHL_Expression
syn match nft_tcp_hdr_option_at_comma ',' skipwhite contained
\ nextgroup=
\    nft_tcp_hdr_option_at_num,
\    nft_Error_Always

" tcp_hdr_expr 'option' 'tcp' 'at' tcp_hdr_option_type (via tcp_hdr_expr)
hi link   nft_tcp_hdr_option_at_tcp_hdr_option_type nftHL_Action
syn match nft_tcp_hdr_option_at_tcp_hdr_option_type '\v(echo|eol|fastopen|md5sig|mptcp|mss|nop|timestamp|window|num)' skipwhite contained
\ nextgroup=
\    nft_tcp_hdr_option_at_comma,
\    nft_Error_Always
" relocated 'sack-permitted' to nft_tcp_hdr_option_sack

" tcp_hdr_expr 'option' 'tcp' 'at' (via tcp_hdr_expr)
hi link   nft_tcp_hdr_option_at nftHL_Action
syn match nft_tcp_hdr_option_at 'at' skipwhite contained
\ nextgroup=
\    nft_tcp_hdr_option_at_tcp_hdr_option_type,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error


" tcp_hdr_expr 'option' (via inner_inet_expr, payload_expr)
hi link   nft_payload_expr_tcp_hdr_expr_keyword_option nftHL_Statement
syn match nft_payload_expr_tcp_hdr_expr_keyword_option '\voption\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_tcp_hdr_option_at,
\    nft_tcp_hdr_option_sack,
\    @nft_c_stmt_hdr_option_type,
\    @nft_c_stmt_hdr_option_kind_and_field,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error


" tcp_hdr_field
syn cluster nft_c_stmt_hdr_expr_tcp_hdr_field_keywords
\ contains=
\    nft_tcp_hdr_field_keywords,
\    nft_Error

"payload_exprpayload_exprpayload_exprX ^^^ OLD ^^^ OLD ^^^
" ************************* BEGIN  tcp' *************************

hi link   nft_payload_expr_close_scope_tcp_named_set nftHL_AtSetname
syn match nft_payload_expr_close_scope_tcp_named_set '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_symbol_expr nftHL_Variable
syn match nft_payload_expr_close_scope_tcp_symbol_expr '\v[\$\@][a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" ************************* BEGIN tcp checksum' *************************
"  tcp checksum in { 1,127,255 }
hi link   nft_payload_expr_tcp_inline_set_checksum nftHL_Integer
syn match nft_payload_expr_tcp_inline_set_checksum '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t,\}n]' skipwhite contained

"  tcp checksum in {  }
hi link    nft_payload_expr_tcp_checksum_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_checksum_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_inline_set_checksum
\ nextgroup=
\    @nft_c_stmt

"  tcp checksum in
hi link   nft_payload_expr_tcp_checksum_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_checksum_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_checksum_inline_set

"  tcp checksum
hi link   nft_payload_expr_tcp_checksum_num2 nftHL_Integer
syn match nft_payload_expr_tcp_checksum_num2 '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_tcp_checksum_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_checksum_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_checksum_num2,
\    nft_chainError

hi link   nft_payload_expr_tcp_checksum_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_checksum_num_or_range '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt,
\    nft_payload_expr_tcp_checksum_dash_symbol

"  tcp checksum >
hi link   nft_payload_expr_tcp_checksum_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_checksum_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_checksum_num_or_range,
\    nft_chainError

"  tcp checksum >=
hi link   nft_payload_expr_tcp_checksum_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_checksum_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_checksum_num_or_range,
\    nft_chainError

"  tcp checksum
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_checksum nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_checksum '\vchecksum\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_checksum_operator_2char,
\    nft_payload_expr_tcp_checksum_keyword_in,
\    nft_payload_expr_tcp_checksum_operator_1char,
\    nft_payload_expr_close_scope_tcp_named_set,
\    nft_payload_expr_tcp_checksum_inline_set,
\    nft_payload_expr_tcp_checksum_num_or_range,
\    nft_chainError
" ************************* END  tcp checksum' *************************

" ************************* BEGIN  tcp sequence' *************************
"  tcp sequence in { 1,127,255 }
hi link   nft_payload_expr_tcp_inline_set_sequence nftHL_Integer
syn match nft_payload_expr_tcp_inline_set_sequence '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t,\}\n]' skipwhite contained

"  tcp sequence in {  }
hi link    nft_payload_expr_tcp_sequence_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_sequence_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_inline_set_sequence
\ nextgroup=
\    @nft_c_stmt

"  tcp sequence in
hi link   nft_payload_expr_tcp_sequence_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_sequence_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_sequence_inline_set

hi link   nft_payload_expr_tcp_sequence_num2 nftHL_Integer
syn match nft_payload_expr_tcp_sequence_num2 '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_tcp_sequence_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_sequence_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_sequence_num2,
\    nft_chainError

hi link   nft_payload_expr_tcp_sequence_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_sequence_num_or_range '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\-]' contained
\ nextgroup=
\    @nft_c_stmt,
\    nft_payload_expr_tcp_sequence_dash_symbol

"  tcp sequence >
hi link   nft_payload_expr_tcp_sequence_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_sequence_operator_1char '\v([\>\<\!])'  skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_sequence_num_or_range,
\    nft_chainError

"  tcp sequence >=
hi link   nft_payload_expr_tcp_sequence_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_sequence_operator_2char '\v([\>\<\!])\='  skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_sequence_num_or_range,
\    nft_chainError

"  tcp sequence
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_sequence nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_sequence '\vsequence\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_sequence_operator_2char,
\    nft_payload_expr_tcp_sequence_keyword_in,
\    nft_payload_expr_tcp_sequence_operator_1char,
\    nft_payload_expr_close_scope_tcp_named_set,
\    nft_payload_expr_tcp_sequence_inline_set,
\    nft_payload_expr_tcp_sequence_num_or_range,
\    nft_chainError
" ************************* END  tcp sequence' *************************

" ************************* BEGIN  tcp ackseq' *************************
"  tcp ackseq in { 1,127,255 }
hi link   nft_payload_expr_tcp_inline_set_ackseq nftHL_Integer
syn match nft_payload_expr_tcp_inline_set_ackseq '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t,\}\n]' skipwhite contained

"  tcp ackseq in {  }
hi link    nft_payload_expr_tcp_ackseq_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_ackseq_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_inline_set_ackseq
\ nextgroup=
\    @nft_c_stmt

"  tcp ackseq in
hi link   nft_payload_expr_tcp_ackseq_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_ackseq_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_ackseq_inline_set

hi link   nft_payload_expr_tcp_ackseq_num2 nftHL_Integer
syn match nft_payload_expr_tcp_ackseq_num2 '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_tcp_ackseq_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_ackseq_dash_symbol '\v\-\ze[0-9]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_ackseq_num2,
\    nft_chainError

hi link   nft_payload_expr_tcp_ackseq_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_ackseq_num_or_range '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt,
\    nft_payload_expr_tcp_ackseq_dash_symbol

"  tcp ackseq >
hi link   nft_payload_expr_tcp_ackseq_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_ackseq_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_ackseq_num_or_range,
\    nft_chainError

"  tcp ackseq >=
hi link   nft_payload_expr_tcp_ackseq_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_ackseq_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_ackseq_num_or_range,
\    nft_chainError

"  tcp ackseq
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_ackseq nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_ackseq '\vackseq\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_ackseq_operator_2char,
\    nft_payload_expr_tcp_ackseq_keyword_in,
\    nft_payload_expr_tcp_ackseq_operator_1char,
\    nft_payload_expr_close_scope_tcp_named_set,
\    nft_payload_expr_tcp_ackseq_inline_set,
\    nft_payload_expr_tcp_ackseq_num_or_range,
\    nft_chainError
" ************************* END  tcp ackseq' *************************

" ************************* BEGIN  tcp urgptr' *************************
"  tcp urgptr in { 1,127,255 }
hi link   nft_payload_expr_tcp_inline_set_urgptr nftHL_Integer
syn match nft_payload_expr_tcp_inline_set_urgptr '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  tcp urgptr in {  }
hi link    nft_payload_expr_tcp_urgptr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_urgptr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_inline_set_urgptr
\ nextgroup=
\    @nft_c_stmt

"  tcp urgptr in
hi link   nft_payload_expr_tcp_urgptr_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_urgptr_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_urgptr_inline_set

hi link   nft_payload_expr_tcp_urgptr_num2 nftHL_Integer
syn match nft_payload_expr_tcp_urgptr_num2 '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_tcp_urgptr_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_urgptr_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_urgptr_num2,
\    nft_chainError

"  tcp urgptr
hi link   nft_payload_expr_tcp_urgptr_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_urgptr_num_or_range '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\-]' contained
\ nextgroup=
\    @nft_c_stmt,
\    nft_payload_expr_tcp_urgptr_dash_symbol

"  tcp urgptr >
hi link   nft_payload_expr_tcp_urgptr_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_urgptr_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_urgptr_num_or_range,
\    nft_chainError

"  tcp urgptr >=
hi link   nft_payload_expr_tcp_urgptr_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_urgptr_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_urgptr_num_or_range,
\    nft_chainError

"  tcp urgptr
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_urgptr nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_urgptr '\vurgptr\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_urgptr_operator_2char,
\    nft_payload_expr_tcp_urgptr_keyword_in,
\    nft_payload_expr_tcp_urgptr_operator_1char,
\    nft_payload_expr_close_scope_tcp_named_set,
\    nft_payload_expr_tcp_urgptr_inline_set,
\    nft_payload_expr_tcp_urgptr_num_or_range,
\    nft_chainError
" ************************* END  tcp urgptr' *************************

" ************************* BEGIN  tcp window' *************************
"  tcp window in { 1,127,255 }
hi link   nft_payload_expr_tcp_window_inline_set_num nftHL_Integer
syn match nft_payload_expr_tcp_window_inline_set_num '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  tcp window in {  }
hi link    nft_payload_expr_tcp_window_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_window_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_window_inline_set_num
\ nextgroup=
\    @nft_c_stmt

"  tcp window in
hi link   nft_payload_expr_tcp_window_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_window_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_window_inline_set

hi link   nft_payload_expr_tcp_window_num2 nftHL_Integer
syn match nft_payload_expr_tcp_window_num2 '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_tcp_window_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_window_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_window_num2,
\    nft_chainError

hi link   nft_payload_expr_tcp_window_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_window_num_or_range '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\-]' contained
\ nextgroup=
\    @nft_c_stmt,
\    nft_payload_expr_tcp_sequence_dash_symbol

"  tcp window >
hi link   nft_payload_expr_tcp_window_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_window_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_window_num_or_range,
\    nft_chainError

"  tcp window >=
hi link   nft_payload_expr_tcp_window_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_window_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_window_num_or_range,
\    nft_chainError

"  tcp window
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_window nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_window '\vwindow\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_window_operator_2char,
\    nft_payload_expr_tcp_window_keyword_in,
\    nft_payload_expr_tcp_window_operator_1char,
\    nft_payload_expr_close_scope_tcp_named_set,
\    nft_payload_expr_tcp_window_inline_set,
\    nft_payload_expr_tcp_window_num_or_range,
\    nft_chainError
" ************************* END  tcp window' *************************

" ************************* BEGIN  tcp dport' *************************
"  tcp dport in { 1,127,255 }
hi link   nft_payload_expr_tcp_inline_set_dport nftHL_Integer
syn match nft_payload_expr_tcp_inline_set_dport '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  tcp dport in {  }
hi link    nft_payload_expr_tcp_dport_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_dport_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_inline_set_dport
\ nextgroup=
\    @nft_c_stmt

"  tcp dport in
hi link   nft_payload_expr_tcp_dport_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_dport_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_dport_inline_set

hi link   nft_payload_expr_tcp_dport_num2 nftHL_Integer
syn match nft_payload_expr_tcp_dport_num2 '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt


hi link   nft_payload_expr_close_scope_tcp_dport_set_ref_expr_range_stmt_expr_symbol_dash nftHL_elements
syn match nft_payload_expr_close_scope_tcp_dport_set_ref_expr_range_stmt_expr_symbol_dash '\-' contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_addr_set_ref_expr_payload_expr_string_ip4,
\    nft_Error

hi link   nft_payload_expr_tcp_dport_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_dport_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_dport_num2,
\    nft_chainError

hi link   nft_payload_expr_tcp_dport_enums nftHL_Define
syn match nft_payload_expr_tcp_dport_enums '\v(clc\-build\-daemon|kerberos\-master|afs3\-fileserver|zabbix\-trapper|passwd\-server|ms\-wbt\-server|gsigatekeeper|f5\-globalsite|dhcpv6\-server|dhcpv6\-client|afs3\-vlserver|afs3\-prserver|afs3\-kaserver|afs3\-callback|zabbix\-agent|moira\-update|microsoft\-ds|kerberos\-adm|iscsi\-target|gnutella\-svc|gnutella\-rtr|font\-service|xmpp\-server|xmpp\-client|submissions|sge\-qmaster|sa\-msg\-port|rpc2portmap|rmiregistry|radmin\-port|radius\-acct|ptp\-general|netbios\-ssn|netbios\-dgm|mysql\-proxy|ipsec\-nat\-t|datametrics|afs3\-volser|afs3\-update|afs3\-rmtsys|zephyr\-srv|zephyr\-clt|syslog\-tls|supfilesrv|supfiledbg|submission|rtcm\-sc104|postgresql|netbios\-ns|moira\-ureg|ingreslock|cvspserver|codasrv\-se|cmip\-agent|cisco\-sccp|bacula\-dir|afpovertcp|zephyr\-hm|snmp\-trap|sge\-execd|sane\-port|ptp\-event|lotusnote|kerberos4|groupwise|ftps\-data|f5\-iquery|dircproxy|codaauth2|clearcase|bacula\-sd|bacula\-fd|amidxtape|amandaidx|zope\-ftp|zebrasrv|venus\-se|sgi\-crsd|sgi\-cmsd|poppassd|ms\-sql\-s|ms\-sql\-m|moira\-db|krb\-prop|kerberos|iso\-tsap|http\-alt|ftp\-data|domain\-s|cmip\-man|cfengine|asf\-rmcp|afs3\-bos|acr\-nema|telnets|skkserv|sip\-tls|sgi\-gcd|sgi\-cad|printer|predict|pawserv|ospfapi|openvpn|omniorb|netstat|kpasswd|kamanda|hylafax|gsidcap|freeciv|discard|daytime|codasrv|chargen|xinetd|webmin|tproxy|telnet|tcpmux|tacacs|systat|sysrqd|syslog|svrloc|sunrpc|rmtcfg|ripngd|remctl|radius|puppet|proofd|ospf6d|kshell|klogin|kermit|isakmp|ircs\-u|gsiftp|gopher|gnunet|gds\-db|gdomap|finger|domain|distcc|db\-lsp|csync2|bootps|bootpc|amanda|zserv|zebra|z3950|xtelw|xmms2|xdmcp|x11\-7|x11\-6|x11\-5|x11\-4|x11\-3|x11\-2|x11\-1|whois|venus|tfido|suucp|spamd|socks|sieve|shell|rsync|rplay|route|rootd|redis|pop3s|ospfd|ntske|ntalk|nntps|mysql|munin|mailq|login|ldaps|isisd|iprop|imaps|imap2|icpv2|https|epmap|dicom|coaps|canna|binkp|babel|amqps|zope|xtel|wnn6|uucp|tinc|time|tftp|talk|snpp|snmp|smux|smtp|silc|saft|rtsp|rtmp|ripd|qotd|qmtp|qmqp|pop3|nsca|nrpe|nntp|mdns|ldap|isns|ircd|http|gris|gpsd|ftps|fido|exec|epmd|echo|dict|dcap|daap|coap|biff|bgpd|auth|amqp|zip|x11|who|svn|ssh|sip|nut|ntp|nqs|nfs|nbp|nbd|mtn|mon|ldp|l2f|ipx|ipp|iax|hkp|git|ftp|fsp|fax|bgp|bbs|asp)' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_dport_set_ref_expr_range_stmt_expr_symbol_dash,
\    @nft_c_stmt,

"   tcp dport
hi link   nft_payload_expr_tcp_dport_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_dport_num_or_range '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\-\n]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_dport_set_ref_expr_range_stmt_expr_symbol_dash,
\    @nft_c_stmt

"  tcp dport >
hi link   nft_payload_expr_tcp_dport_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_dport_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_dport_num_or_range,
\    nft_chainError

"  tcp dport >=
hi link   nft_payload_expr_tcp_dport_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_dport_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_dport_num_or_range,
\    nft_chainError

" tcp dport map ...
hi link   nft_stmt_expr_map_stmt_expr_keyword_map nftHL_Write
syn match nft_stmt_expr_map_stmt_expr_keyword_map '\vmap' skipwhite contained
\ nextgroup=
\    @nft_c_map_expr_rhs_expr

"  tcp dport
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_dport nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_dport '\vdport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_dport_enums,
\    nft_stmt_expr_map_stmt_expr_keyword_map,
\    nft_payload_expr_tcp_dport_operator_2char,
\    nft_payload_expr_tcp_dport_keyword_in,
\    nft_payload_expr_tcp_dport_operator_1char,
\    nft_payload_expr_close_scope_tcp_named_set,
\    nft_payload_expr_close_scope_tcp_symbol_expr,
\    nft_payload_expr_tcp_dport_inline_set,
\    nft_payload_expr_tcp_dport_num_or_range,
\    nft_chainError
" ************************* END  tcp dport' *************************

" ************************* BEGIN  tcp flags' *************************
" flags: syn, ack, fin, rst, psh, urg, ecn, cwr or 0 to 0xFF.
"  tcp flags in { 1,127,255 }
hi link   nft_payload_expr_tcp_flags_inline_set_defines nftHL_Define
syn match nft_payload_expr_tcp_flags_inline_set_defines '\v(syn|ack|fin|rst|psh|urg|ecn|cwr)\ze[ \t,\}\n]'  skipwhite contained

hi link   nft_payload_expr_tcp_flags_inline_set_num nftHL_Integer
syn match nft_payload_expr_tcp_flags_inline_set_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t,\}\n]' skipwhite contained

"  tcp flags in {  }
hi link    nft_payload_expr_tcp_flags_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_flags_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_flags_inline_set_defines,
\    nft_payload_expr_tcp_flags_inline_set_num
\ nextgroup=
\    @nft_c_stmt

"  tcp flags in
hi link   nft_payload_expr_tcp_flags_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_flags_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_flags_inline_set

hi link   nft_payload_expr_tcp_flags_num2 nftHL_Integer
syn match nft_payload_expr_tcp_flags_num2 '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_tcp_flags_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_flags_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_flags_num2,
\    nft_chainError

hi link   nft_payload_expr_tcp_flags_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_flags_num_or_range '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t\-]'  skipwhite contained
\ nextgroup=
\    @nft_c_stmt,
\    nft_payload_expr_tcp_sequence_dash_symbol

hi link   nft_payload_expr_tcp_flags_defines nftHL_Define
syn match nft_payload_expr_tcp_flags_defines '\v(syn|ack|fin|rst|psh|urg|ecn|cwr)\ze[ \t]'  contained
\ nextgroup=
\    @nft_c_stmt

"  tcp flags >
hi link   nft_payload_expr_tcp_flags_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_flags_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_flags_defines,
\    nft_payload_expr_tcp_flags_num_or_range,
\    nft_chainError

"  tcp flags >=
hi link   nft_payload_expr_tcp_flags_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_flags_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_flags_defines,
\    nft_payload_expr_tcp_flags_num_or_range,
\    nft_chainError

hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_flags nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_flags '\vflags\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_flags_defines,
\    nft_payload_expr_tcp_flags_operator_2char,
\    nft_payload_expr_tcp_flags_keyword_in,
\    nft_payload_expr_tcp_flags_operator_1char,
\    nft_payload_expr_close_scope_tcp_named_set,
\    nft_payload_expr_tcp_flags_inline_set,
\    nft_payload_expr_tcp_flags_num_or_range,
\    nft_chainError
" ************************* END tcp flags' *************************

" ************************* BEGIN tcp sport' *************************
hi link   nft_payload_expr_close_scope_tcp_sport_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" === nftables service names - safe, single-quoted, no parentheses ===
hi link   nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines nftHL_Define
hi link   nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines nftHL_Define
" nftables service names - ORIGINAL ORDER (longest to shortest), <132 chars
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v\ze[ \t](clc-build-daemon|kerberos-master|zabbix-trapper|passwd-server|ms-wbt-server|gsigatekeeper|f5-globalsite|dhcpv6-server|dhcpv6-client|afs3-vlserver|afs3-prserver|afs3-kaserver|afs3-callback|zabbix-agent|moira-update|microsoft-ds|kerberos-adm|iscsi-target|gnutella-svc|gnutella-rtr|font-service|xmpp-server|xmpp-client|submissions|sge-qmaster)\ze[ \t,]'
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v\ze[ \t](sa-msg-port|rpc2portmap|rmiregistry|radmin-port|radius-acct|ptp-general|netbios-ssn|netbios-dgm|mysql-proxy|ipsec-nat-t|datametrics|afs3-volser|afs3-update|afs3-rmtsys|zephyr-srv|zephyr-clt|syslog-tls|supfilesrv|supfiledbg|submission|rtcm-sc104|postgresql|netbios-ns|moira-ureg|ingreslock)\ze[ \t,]'
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v\ze[ \t](cvspserver|codasrv-se|cmip-agent|cisco-sccp|bacula-dir|afpovertcp|zephyr-hm|snmp-trap|sge-execd|sane-port|ptp-event|lotusnote|kerberos4|groupwise|ftps-data|f5-iquery|dircproxy|codaauth2|clearcase|bacula-sd|bacula-fd|amidxtape|amandaidx|zope-ftp|zebrasrv)\ze[ \t,]'
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v\ze[ \t](venus-se|sgi-crsd|sgi-cmsd|poppassd|ms-sql-s|ms-sql-m|moira-db|krb-prop|kerberos|iso-tsap|http-alt|ftp-data|domain-s|cmip-man|cfengine|asf-rmcp|afs3-bos|acr-nema|telnets|skkserv|sip-tls|sgi-gcd|sgi-cad|printer|predict)\ze[ \t,]'
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v\ze[ \t](pawserv|ospfapi|openvpn|omniorb|netstat|kpasswd|kamanda|hylafax|gsidcap|freeciv|discard|daytime|codasrv|chargen|xinetd|webmin|tproxy|telnet|tcpmux|tacacs|systat|sysrqd|svrloc|sunrpc|rmtcfg)\ze[ \t,]'
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v\ze[ \t](ripngd|remctl|radius|puppet|proofd|ospf6d|kshell|klogin|kermit|isakmp|ircs-u|gsiftp|gopher|gnunet|gds-db|gdomap|finger|domain|distcc|db-lsp|csync2|bootps|bootpc|amanda|zserv)\ze[ \t,]'
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v\ze[ \t](zebra|z3950|xtelw|xmms2|xdmcp|x11-7|x11-6|x11-5|x11-4|x11-3|x11-2|x11-1|whois|venus|tfido|suucp|spamd|socks|sieve|shell|rsync|rplay|route|rootd|redis|pop3s)\ze[ \t,]'
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v\ze[ \t](ospfd|ntske|ntalk|nntps|mysql|munin|mailq|login|ldaps|isisd|iprop|imaps|imap2|icpv2|https|epmap|dicom|coaps|canna|binkp|babel|amqps|zope|xtel)\ze[ \t,]'
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v\ze[ \t](wnn6|uucp|tinc|time|tftp|talk|snpp|snmp|smux|smtp|silc|saft|rtsp|ripd|qotd|qmtp|qmqp|pop3|nsca|nrpe|nntp|mdns|ldap|isns)\ze[ \t,]'
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v\ze[ \t](ircd|http|gris|gpsd|ftps|fido|exec|epmd|echo|dict|dcap|daap|coap|bgpd|auth|amqp|zip|x11|svn|ssh|sip|nut|ntp|nqs|nfs|nbp|nbd|mtn|mon|ldp|l2f)\ze[ \t,]'
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v\ze[ \t](ipx|ipp|iax|hkp|git|ftp|fax|bgp|bbs|asp)\ze[ \t,]'
\ nextgroup=
\    @nft_c_stmt


"  tcp sport in { 1,127,255 }
hi link   nft_payload_expr_close_scope_tcp_inline_set_sport nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_inline_set_sport '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{0,4})\ze[ \t\n,]' skipwhite contained

"  tcp sport in {  }
hi link    nft_payload_expr_tcp_hdr_field_sport_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_hdr_field_sport_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines,
\    nft_payload_expr_close_scope_tcp_inline_set_sport
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{0,4})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines nftHL_Define
" nftables service names - ORIGINAL ORDER (longest to shortest), <132 chars
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](clc-build-daemon|kerberos-master|zabbix-trapper|passwd-server|ms-wbt-server|gsigatekeeper|f5-globalsite|dhcpv6-server|dhcpv6-client|afs3-vlserver|afs3-prserver|afs3-kaserver|afs3-callback|zabbix-agent|moira-update|microsoft-ds|kerberos-adm|iscsi-target|gnutella-svc|gnutella-rtr|font-service|xmpp-server|xmpp-client|submissions|sge-qmaster)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](sa-msg-port|rpc2portmap|rmiregistry|radmin-port|radius-acct|ptp-general|netbios-ssn|netbios-dgm|mysql-proxy|ipsec-nat-t|datametrics|afs3-volser|afs3-update|afs3-rmtsys|zephyr-srv|zephyr-clt|syslog-tls|supfilesrv|supfiledbg|submission|rtcm-sc104|postgresql|netbios-ns|moira-ureg|ingreslock)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](cvspserver|codasrv-se|cmip-agent|cisco-sccp|bacula-dir|afpovertcp|zephyr-hm|snmp-trap|sge-execd|sane-port|ptp-event|lotusnote|kerberos4|groupwise|ftps-data|f5-iquery|dircproxy|codaauth2|clearcase|bacula-sd|bacula-fd|amidxtape|amandaidx|zope-ftp|zebrasrv)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](venus-se|sgi-crsd|sgi-cmsd|poppassd|ms-sql-s|ms-sql-m|moira-db|krb-prop|kerberos|iso-tsap|http-alt|ftp-data|domain-s|cmip-man|cfengine|asf-rmcp|afs3-bos|acr-nema|telnets|skkserv|sip-tls|sgi-gcd|sgi-cad|printer|predict)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](pawserv|ospfapi|openvpn|omniorb|netstat|kpasswd|kamanda|hylafax|gsidcap|freeciv|discard|daytime|codasrv|chargen|xinetd|webmin|tproxy|telnet|tcpmux|tacacs|systat|sysrqd|svrloc|sunrpc|rmtcfg)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](ripngd|remctl|radius|puppet|proofd|ospf6d|kshell|klogin|kermit|isakmp|ircs-u|gsiftp|gopher|gnunet|gds-db|gdomap|finger|domain|distcc|db-lsp|csync2|bootps|bootpc|amanda|zserv)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](zebra|z3950|xtelw|xmms2|xdmcp|x11-7|x11-6|x11-5|x11-4|x11-3|x11-2|x11-1|whois|venus|tfido|suucp|spamd|socks|sieve|shell|rsync|rplay|route|rootd|redis|pop3s)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](ospfd|ntske|ntalk|nntps|mysql|munin|mailq|login|ldaps|isisd|iprop|imaps|imap2|icpv2|https|epmap|dicom|coaps|canna|binkp|babel|amqps|zope|xtel)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](wnn6|uucp|tinc|time|tftp|talk|snpp|snmp|smux|smtp|silc|saft|rtsp|ripd|qotd|qmtp|qmqp|pop3|nsca|nrpe|nntp|mdns|ldap|isns)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](ircd|http|gris|gpsd|ftps|fido|exec|epmd|echo|dict|dcap|daap|coap|bgpd|auth|amqp|zip|x11|svn|ssh|sip|nut|ntp|nqs|nfs|nbp|nbd|mtn|mon|ldp|l2f)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](ipx|ipp|iax|hkp|git|ftp|fax|bgp|bbs|asp)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_sport_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_tcp_sport_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex,
\    nft_chainError

"   tcp sport NUM
hi link   nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex_range '\v(0x[0-9a-fA-F]{1,4})|([0-9]{1,5})\ze[ \t\-\n;]' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sport_dash_symbol,
\    @nft_c_stmt
" END Operators - Scalar

hi link   nft_payload_expr_close_scope_tcp_sport_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_sport_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines,
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" \    nft_payload_expr_tcp_hdr_field_sport_set_expr_inline_set_not_integer,
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_sport_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_sport_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines,
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
"\    nft_payload_expr_tcp_hdr_field_sport_set_expr_inline_set_not_integer,
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_sport_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_sport_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines,
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_sport_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" 'payload_expr tcp_hdr_field_sport' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_sport nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_sport '\vsport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_sport_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_sport_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sport_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_sport_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex,
\    nft_Error
" \    nft_payload_expr_close_scope_tcp_sport_set_ref_expr_set_ref_symbol_expr_at_setname,
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ************************* END tcp sport' *************************

"  tcp sport
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_dport nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_dport '\vdport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_sport_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_sport_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sport_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_sport_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex,
\    nft_Error
" ************************* END tcp dport' *************************

" ************************* BEGIN  tcp doff' *************************
hi link   nft_payload_expr_close_scope_tcp_doff_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_tcp_doff_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

"  tcp doff in { 1,127,255 }
hi link   nft_payload_expr_close_scope_tcp_inline_set_doff nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_inline_set_doff '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  tcp doff in {  }
hi link    nft_payload_expr_tcp_hdr_field_doff_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_hdr_field_doff_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_tcp_inline_set_doff
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_doff_num2 nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_doff_num2 '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_doff_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_tcp_doff_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_doff_num2,
\    nft_chainError

"   tcp doff
hi link   nft_payload_expr_close_scope_tcp_doff_num_or_range nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_doff_num_or_range '\v(0x[0-9a-fA-F]{1,4})|([0-9]{1,5})\ze[ \t\-\n;]' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_doff_dash_symbol,
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex '\v0x[5-9a-fA-F]|20|0x1[0-4]|[5-9]|1[0-9]\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt
" END Operators - Scalar

hi link   nft_payload_expr_close_scope_tcp_doff_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_doff_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_doff_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex_range,
\    nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" \    nft_payload_expr_tcp_hdr_field_doff_set_expr_inline_set_not_integer,
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_doff_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_doff_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_doff_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex_range,
\    nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
"\    nft_payload_expr_tcp_hdr_field_doff_set_expr_inline_set_not_integer,
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_doff_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_doff_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_doff_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_doff_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex_range,
\    nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" 'payload_expr tcp_hdr_field_doff' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_doff nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_doff '\vdoff\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_doff_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_doff_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_doff_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_doff_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_doff_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_doff_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex_range,
\    nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex,
\    nft_Error
" \    nft_payload_expr_close_scope_tcp_doff_set_ref_expr_set_ref_symbol_expr_at_setname,
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" *************** End of payload_expr tcp_hdr_expr 'tcp doff' *************************

" tcp_hdr_expr is valid in chain_block and stmt_list
" tcp_hdr_expr 'tcp'
" 'tcp'->tcp_hdr_expr->inner_inet_expr->inner_expr->(vxlan_hdr_expr|gretap_hdr_expr|geneve_hdr_expr)
" 'tcp'->tcp_hdr_expr->gre_hdr_expr->payload_expr->(payload_stmt|primary_expr|primary_stmt_expr)
hi link   nft_payload_expr_tcp_hdr_expr_keyword_tcp nftHL_Statement
syn match nft_payload_expr_tcp_hdr_expr_keyword_tcp '\vtcp\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_checksum,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_sequence,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_ackseq,
\    nft_payload_expr_tcp_hdr_expr_keyword_option,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_urgptr,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_window,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_dport,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_flags,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_sport,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_doff,
\    nft_UnexpectedSemicolon,
\    nft_Error
" *************** End of payload_expr tcp_hdr_expr 'tcp' *************************

  for s:this_semantic_file in s:tcp_hdr_expr_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded tcp_hdr_expr for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define tcp_hdr_expr.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_tcp_hdr_expr = v:true
