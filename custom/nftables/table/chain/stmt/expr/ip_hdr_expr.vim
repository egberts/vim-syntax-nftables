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


" 'ip hdrlength'
" 'hdrlength'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" Valid range: 5-15
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_hdrlength nftHL_Action
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_hdrlength '\vhdrlength\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_4b

" 'ip version'
" 'version'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" Valid range: 0-15
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_hdrversion nftHL_Action
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_hdrversion '\vversion\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_4b

" 'ip checksum'
" 'checksum'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_ip_hdr_field_keywords nftHL_Action
syn match nft_ip_hdr_expr_ip_hdr_field_keywords '\vchecksum\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_ip_hdr_expr_keyword_checksum_value

" 'ip frag_off'
" 'frag-off'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" Valid range: 0-8191
hi link   nft_ip_hdr_expr_ip_hdr_field_keywords nftHL_Action
syn match nft_ip_hdr_expr_ip_hdr_field_keywords '\vfrag\-off\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_13b

" 'ip protocol'
" 'protocol'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" Valid range: 0-255
hi link   nft_ip_hdr_expr_ip_hdr_field_keywords nftHL_Action
syn match nft_ip_hdr_expr_ip_hdr_field_keywords '\vprotocol\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_13b

" 'ip length'
" 'length'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_ip_hdr_field_keywords nftHL_Action
syn match nft_ip_hdr_expr_ip_hdr_field_keywords '\vlength\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_ip_hdr_expr_keyword_length_num

" 'ip option lsrr length'
" 'length'->ip_option_field->'lsrr'->ip_option_type->'option'->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_ip_option_field_keyword_length nftHL_Statement
syn match nft_ip_hdr_expr_ip_option_field_keyword_length '\vlength\ze[ \t]' skipwhite contained

" 'ip option lsrr value'
" 'value'->ip_option_field->'lsrr'->ip_option_type->'option'->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_ip_option_field_keyword_value nftHL_Statement
syn match nft_ip_hdr_expr_ip_option_field_keyword_value '\vvalue\ze[ \t]' skipwhite contained

" 'ip option lsrr addr'
" 'addr'->ip_option_field->'lsrr'->ip_option_type->'option'->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_ip_option_field_keyword_addr nftHL_Statement
syn match nft_ip_hdr_expr_ip_option_field_keyword_addr '\vaddr\ze[ \t]' skipwhite contained

" 'ip option lsrr type'
" 'type'->ip_option_field->'lsrr'->ip_option_type->'option'->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_ip_option_field_keywords nftHL_Statement
syn match nft_ip_hdr_expr_ip_option_field_keywords '\vtype\ze[ \t]' skipwhite contained

" 'ip option lsrr ptr'
" 'ptr'->ip_option_field->'lsrr'->ip_option_type->'option'->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_ip_option_field_keywords nftHL_Statement
syn match nft_ip_hdr_expr_ip_option_field_keywords '\vptr\ze[ \t]' skipwhite contained

" 'ip option lsrr'
" 'lsrr'->ip_option_type->'option'->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_ip_option_keywords nftHL_Action
syn match nft_ip_hdr_expr_ip_option_keywords '\v(lsrr|rr|ssrr|ra)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_ip_option_field_keyword_length,
\    nft_ip_hdr_expr_ip_option_field_keyword_value,
\    nft_ip_hdr_expr_ip_option_field_keyword_addr,
\    nft_ip_hdr_expr_ip_option_field_keyword_type,
\    nft_ip_hdr_expr_ip_option_field_keyword_ptr,
\    nft_Semicolon

" 'ip option'
" 'option'->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_keyword_option nftHL_Statement
syn match nft_ip_hdr_expr_keyword_option '\voption\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_ip_option_keywords

" 'ip daddr'
" 'daddr'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_daddr nftHL_Action
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_daddr '\vdaddr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_ip6_fields

" 'ip saddr'
" 'saddr'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_ip_hdr_field_keywords nftHL_Action
syn match nft_ip_hdr_expr_ip_hdr_field_keywords '\vsaddr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_ip6_fields

hi link   nft_ip_hdr_expr_keyword_protocol_num nftHL_Number
syn match nft_ip_hdr_expr_keyword_protocol_num '\v[a-zA-Z0-9]{1,32}' skipwhite contained

" 'ip' 'dscp' <NUM>
" ip_hdr_field (via ip_hdr_expr) (internal Bison/Lex)
hi link   nft_ip_hdr_field_keyword_dscp_id_number nftHL_Number
syn match nft_ip_hdr_field_keyword_dscp_id_number '\v[0-9]{1,3}' skipwhite contained
\ nextgroup=
\    nft_EOS
syn match nft_ip_hdr_field_keyword_dscp_id_number '\v0x[0-9]{1,2}' skipwhite contained
\ nextgroup=
\    nft_EOS
hi link   nft_ip_hdr_field_keyword_dscp_id_label nftHL_Label
syn match nft_ip_hdr_field_keyword_dscp_id_label '\v(ef|cs[0-7]|af[1-4][1-3])' skipwhite contained
\ nextgroup=
\    nft_EOS
hi link   nft_ip_hdr_field_keyword_dscp_operator_negation nftHL_Operator
syn match nft_ip_hdr_field_keyword_dscp_operator_negation '\v\!\=' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_field_keyword_dscp_id_number,
\    nft_ip_hdr_field_keyword_dscp_id_label

hi link   nft_ip_hdr_field_keyword_dscp_set_comma nftHL_Element
syn match nft_ip_hdr_field_keyword_dscp_set_comma ',' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_field_keyword_dscp_set_number,
\    nft_ip_hdr_field_keyword_dscp_set_label

hi link   nft_ip_hdr_field_keyword_dscp_set_number nftHL_Number
syn match nft_ip_hdr_field_keyword_dscp_set_number '\v[0-9]{1,3}' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_field_keyword_dscp_set_comma
syn match nft_ip_hdr_field_keyword_dscp_set_number '\v0x[0-9]{1,2}' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_field_keyword_dscp_set_comma
hi link   nft_ip_hdr_field_keyword_dscp_set_label nftHL_Label
syn match nft_ip_hdr_field_keyword_dscp_set_label '\v(df|be|lephb|va|ef|cs[0-7]|af[1-4][1-3])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_field_keyword_dscp_set_comma

syn region nft_ip_hdr_field_keyword_dscp_block_delimiter start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_ip_hdr_field_keyword_dscp_set_number,
\    nft_ip_hdr_field_keyword_dscp_set_label

" 'ip dscp'
" 'dscp'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_field_keywords nftHL_Action
syn match nft_ip_hdr_field_keywords '\vdscp\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr
"\    nft_ip_hdr_field_keyword_dscp_block_delimiter,
"\    nft_ip_hdr_field_keyword_dscp_operator_negation,
"\    nft_ip_hdr_field_keyword_dscp_id_label,
"\    nft_ip_hdr_field_keyword_dscp_id_number

" 'ip ecn'
" 'ecn'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_field_keywords nftHL_Action
syn match nft_ip_hdr_field_keywords '\vecn\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_keyword_ecn_id

" 'ip ttl'
" 'ttl'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_field_keywords nftHL_Action
syn match nft_ip_hdr_field_keywords 'ttl\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_keyword_ttl_count

" 'ip id'
" 'id'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_field_keywords nftHL_Action
syn match nft_ip_hdr_field_keywords '\vid\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_keyword_id_num


" 'ip'
" ip_hdr_expr
" 'ip'->ip_hdr_expr
hi link   nft_ip_hdr_expr_keyword_ip nftHL_Statement
syn match nft_ip_hdr_expr_keyword_ip '\vip\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_ip_hdr_field_keyword_hdrversion,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_hdrlength,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_checksum,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_frag_off,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_protocol,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_length,
\    nft_ip_hdr_expr_keyword_option,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_daddr,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_saddr,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_dscp,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_ecn,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_ttl,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_id,
\    nft_Error

