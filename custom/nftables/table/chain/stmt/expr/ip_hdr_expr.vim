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
syn region nft_ip_hdr_expr_close_scope_ip_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    @nft_c_primary_stmt_expr


hi link   nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_2b_ecn nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_2b_ecn '\v(0x)?[0-3]' skipwhite contained
\ nextgroup=
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

hi link   nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_4b_hdrlength nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_4b_hdrlength '\v(0x[5-9a-fA-F]|1[0-5]|[5-9])\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_4b_hdrversion nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_4b_hdrversion '\v(0x[fF]|0x[0-9a-eA-E]|[1][0-5]|[0-9])\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_stmt_separator,
\    @nft_c_primary_stmt_expr

hi link   nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_4b_field_length_second_num nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_4b_field_length_second_num '\v(0x2[0-8]|0x1[0-9a-fA-F]|0x[4-9a-fA-F]|40|[3][0-9]|[2][0-9]|[1][0-9]|[4-9])\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_ip_hdr_expr_close_scope_ip_symbol_dash nftHL_Operator
syn match nft_ip_hdr_expr_close_scope_ip_symbol_dash /\-/ skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_4b_field_length_second_num,
\    nft_Error

" Valid range: 4
hi link   nft_ip_hdr_expr_option_ra_close_scope_ip_constant_expr_int_hex_4b_field_length nftHL_Integer
syn match nft_ip_hdr_expr_option_ra_close_scope_ip_constant_expr_int_hex_4b_field_length '\v4\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

" Valid range: 4-40
hi link   nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_4b_field_length nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_4b_field_length '\v(0x2[0-8]|0x1[0-9a-fA-F]|0x[4-9a-fA-F]|40|[3][0-9]|[2][0-9]|[1][0-9]|[4-9])\ze[ \t\n\-]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_symbol_dash,
\    @nft_c_primary_stmt_expr

hi link   nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_6b nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_6b '\v((0x[0-9a-fA-F]{1,1})|([0-9]{1,2}))' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_8b nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_8b '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_8b_protocol nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_8b_protocol '\v(0x[fF]{2}|0x[0-9a-eA-E][0-9a-fA-F]|0x[0-9a-fA-F]|25[0-5]|2[0-4][0-9]|[1-9][0-9]|[0-9])\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_8b_ttl nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_8b_ttl '\v(0x[fF]{2}|0x[0-9a-eA-E][0-9a-fA-F]|0x[0-9a-fA-F]|25[0-5]|2[0-4][0-9]|[1-9][0-9]|[0-9])\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_13b_frag_off nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_13b_frag_off '\v(0x1[fF]{3}|0x1[fF][0-9a-eA-E][0-9a-fA-F]|0x1[0-9a-eA-E][0-9a-fA-F]{2}|0x[0-9a-fA-F]{1,3}|819[0-1]|81[0-8][0-9]|80[0-9]{2}|[1-7][0-9]{3}|[1-9][0-9]{0,2}|0)\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_16b_length nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_16b_length '\v(0x[fF]{4}|0x[0-9a-eA-E][0-9a-fA-F]{3}|0x[0-9a-fA-F]{3}|0x[0-9a-fA-F]{2}|0x[2-9a-fA-F]|6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|6[0-4][0-9]{3}|[1-5][0-9]{4}|[1-9][0-9]{3}|[1-9][0-9]{2}|[2-9][0-9])' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_16b_checksum nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_16b_checksum '\v(0x[fF]{4}|0x[0-9a-eA-E][0-9a-fA-F]{3}|0x[0-9a-fA-F]{3}|0x[0-9a-fA-F]{2}|0x[0-9a-fA-F]|6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|6[0-4][0-9]{3}|[1-5][0-9]{4}|[1-9][0-9]{3}|[1-9][0-9]{2}|[1-9][0-9]|[0-9])\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_16b_id nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_16b_id '\v(0x[fF]{4}|0x[0-9a-eA-E][0-9a-fA-F]{3}|0x[0-9a-fA-F]{3}|0x[0-9a-fA-F]{2}|0x[0-9a-fA-F]|6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|6[0-4][0-9]{3}|[1-5][0-9]{4}|[1-9][0-9]{3}|[1-9][0-9]{2}|[1-9][0-9]|[0-9])\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_ip_hdr_expr_close_scope_ip_constant_expr_string_ip_opt_cidr nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_constant_expr_string_ip_opt_cidr
\ '\v(0x[0-9a-fA-F]{1,8})|(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}(\/(3[0-2]|[12]\d|[0-9]))?'
\ skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_constant_expr_string_ip_cidr nftHL_Integer
syn match nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_constant_expr_string_ip_cidr
\ '\v(0x[0-9a-fA-F]{1,8})|(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}(\/(3[0-2]|[12]\d|[0-9]))'
\ skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_constant_expr_string_ip_second nftHL_Integer
syn match nft_ip_hdr_expr_ip_hdr_field_addr_close_scope_ip_constant_expr_string_ip_second
\ '\v(0x[0-9a-fA-F]{1,8})|(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}'
\ skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

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

" 'ip hdrlength'
" 'hdrlength'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" Valid range: 5-15
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_hdrlength nftHL_Keyword
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_hdrlength '\vhdrlength\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_4b_hdrlength,
\    nft_UnexpectedNonNumber,
\    nft_Error

" 'ip version'
" 'version'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" Valid range: 0-15
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_hdrversion nftHL_Keyword
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_hdrversion '\vversion\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_4b_hdrversion,
\    nft_UnexpectedNonNumber,
\    nft_Error

" 'ip checksum'
" 'checksum'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_checksum nftHL_Keyword
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_checksum '\vchecksum\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_16b_checksum,
\    nft_UnexpectedNonNumber,
\    nft_Error

" 'ip frag_off'
" 'frag-off'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" Valid range: 0-8191
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_frag_off nftHL_Keyword
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_frag_off '\vfrag\-off\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_13b_frag_off,
\    nft_UnexpectedNonNumber,
\    nft_Error

" 'ip protocol'
" 'protocol'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" 'ip protocol' begin
hi link   nft_ip_hdr_expr_close_scope_ip_datatype_ip_protocol nftHL_Define
syn match nft_ip_hdr_expr_close_scope_ip_datatype_ip_protocol '\v(udplite|gretap|icmpv6|comp|dccp|icmp|igmp|sctp|esp|gre|tcp|udp|ah)\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr,

" Valid range: 0-255
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_protocol nftHL_Keyword
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_protocol '\vprotocol\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_expr_keyword_continue,
\    nft_verdict_expr_keyword_accept,
\    nft_verdict_expr_keyword_return,
\    nft_verdict_expr_keyword_drop,
\    nft_verdict_expr_keyword_goto,
\    nft_verdict_expr_keyword_jump,
\    nft_ip_hdr_expr_close_scope_ip_datatype_ip_protocol,
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_8b_protocol,
\    nft_UnexpectedNonNumber,
\    nft_Error

" 'ip length'
" 'length'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_length nftHL_Keyword
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_length '\vlength\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_16b_length,
\    nft_Error

" **************************** 'ip option' ***************************
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

" 'ip daddr'
" 'daddr'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_daddr nftHL_Keyword
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_daddr '\vdaddr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_map_stmt_keyword_vmap,
\    nft_map_stmt_expr_keyword_map,
\    nft_ip_hdr_expr_close_scope_ip_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_string_ip_opt_cidr,
\    nft_Error

" 'ip saddr'
" 'saddr'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_saddr nftHL_Keyword
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_saddr '\vsaddr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_map_stmt_keyword_vmap,
\    nft_map_stmt_expr_keyword_map,
\    nft_ip_hdr_expr_close_scope_ip_inline_set,
\    nft_ip_hdr_expr_close_scope_ip_primary_stmt_expr,
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_string_ip_opt_cidr,
\    nft_Error

" 'ip' 'dscp' <NUM>
" ip_hdr_field (via ip_hdr_expr) (internal Bison/Lex)
hi link   nft_ip_hdr_field_keyword_dscp_id_number nftHL_Integer
syn match nft_ip_hdr_field_keyword_dscp_id_number '\v(0x[0-3][0-9a-fA-F]|0x[0-9a-fA-F]|[1-5][0-9]|[6][0-3]|[0-9])' skipwhite contained
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
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_6b,
\    nft_ip_hdr_field_keyword_dscp_set_label

hi link   nft_ip_hdr_expr_close_scope_ip_constant_expr_int_dscp_num nftHL_Integer
syn match nft_ip_hdr_expr_close_scope_ip_constant_expr_int_dscp_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,2}))' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_field_keyword_dscp_set_comma

hi link   nft_ip_hdr_field_keyword_dscp_set_label nftHL_Label
syn match nft_ip_hdr_field_keyword_dscp_set_label '\v(df|be|lephb|va|ef|cs[0-7]|af[1-4][1-3])' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_field_keyword_dscp_set_comma

syn region nft_ip_hdr_field_keyword_dscp_block_delimiter start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_int_dscp_num,
\    nft_ip_hdr_field_keyword_dscp_set_label

" 'ip dscp'
" 'dscp'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" Valid range: 0-63
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_dscp nftHL_Keyword
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_dscp '\vdscp\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_field_keyword_dscp_block_delimiter,
\    nft_ip_hdr_field_keyword_dscp_operator_negation,
\    nft_ip_hdr_field_keyword_dscp_id_label,
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_int_dscp_num,
\    nft_Error

" 'ip ecn'
" 'ecn'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" Valid range: 0-3
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_ecn nftHL_Keyword
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_ecn '\vecn\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_2b_ecn,
\    nft_UnexpectedNonNumber,
\    nft_Error

" 'ip ttl'
" 'ttl'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" Valid range: 0-255
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_ttl nftHL_Keyword
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_ttl 'ttl\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_8b_ttl,
\    nft_UnexpectedNonNumber,
\    nft_Error

" 'ip id'
" 'id'->ip_hdr_field->'ip'->ip_hdr_expr (internal Bison/Lex)
" Valid range: 0-65535
hi link   nft_ip_hdr_expr_ip_hdr_field_keyword_id nftHL_Keyword
syn match nft_ip_hdr_expr_ip_hdr_field_keyword_id '\vid\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_close_scope_ip_constant_expr_int_hex_16b_id,
\    nft_UnexpectedNonNumber,
\    nft_Error


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
