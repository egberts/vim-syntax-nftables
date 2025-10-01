" File: stmt_ct.vim
" Directory: custom/nftables/
"
let s:stmt_ct_list_filepaths_semantic_early = []
let s:stmt_ct_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_ct')
  call nftables#syntax#log('INFO', 'Skipped stmt_ct (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_ct_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_ct syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "


" ********************* BEGIN 'objref_stmt' **************************
" ********************* BEGIN 'objref_stmt_ct' ********************
hi link   nft_conntrack_timeout_types nftHL_Define
syn match nft_conntrack_timeout_types '\v(expectation|generic|icmp|tcp|udp)' skipwhite contained

hi link    nft_stmt_ct_stmt_set_quoted_string nftHL_String
syn region nft_stmt_ct_stmt_set_quoted_string start='\"' end='\"' skipwhite oneline contained

hi link   nft_stmt_stmt_expr_map_stmt_expr_symbol_expr_string_quoted_string_conntrack_types nftHL_Define
syn match nft_stmt_stmt_expr_map_stmt_expr_symbol_expr_string_quoted_string_conntrack_types '\v(h323|pptp|tftp|ftp|irc|sip)' skipwhite contained
\ nextgroup=
\    nft_Error

hi link    nft_stmt_expr_map_stmt_expr_map_stmt_expr_set_set_expr_delimiters nftHL_BlockDelimitersSet
syn region nft_stmt_expr_map_stmt_expr_map_stmt_expr_set_set_expr_delimiters start=+{+ end=+}+ skipwhite contained

hi link   nft_stmt_expr_map_stmt_expr_map_stmt_expr_set_set_expr_set_ref_symbol_expr_at_setname nftHL_Variable
syn match nft_stmt_expr_map_stmt_expr_map_stmt_expr_set_set_expr_set_ref_symbol_expr_at_setname '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_keyword_map nftHL_Write
syn match nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_keyword_map '\vmap' skipwhite contained
\ nextgroup=
\    nft_stmt_expr_map_stmt_expr_map_stmt_expr_set_set_expr_set_ref_symbol_expr_at_setname,
\    nft_stmt_expr_map_stmt_expr_map_stmt_expr_set_set_expr_delimiters

hi link   nft_stmt_stmt_expr_concat_stmt_expr_keyword_dot nftHL_Operator
syn match nft_stmt_stmt_expr_concat_stmt_expr_keyword_dot '\.' skipwhite contained
\ nextgroup=
\    nft_stmt_stmt_expr_map_stmt_expr_symbol_expr_string_quoted_string_conntrack_types,
\    nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_tcp_hdr_expr_keyword_tcp,
\    nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_ip6_hdr_expr_keyword_ip6,
\    nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_ip_hdr_expr_keyword_ip,
\    nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_th_hdr_expr_keyword_th,
\    nft_stmt_objref_stmt_objref_stmt_ct_stmt_expr_symbol_stmt_expr_symbol_expr_string_quoted_string,
\    nft_ct_stmt_verdict_stmt_verdict_map_stmt_set_ref_expr_set_ref_symbol_expr_keyword_at_identifier,
\    nft_Error

hi link   nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_ip6_hdr_expr_ip6_hdr_field_keyword_daddr nftHL_Keyword
syn match nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_ip6_hdr_expr_ip6_hdr_field_keyword_daddr '\v(saddr|daddr)' skipwhite contained
\ nextgroup=
\    nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_keyword_map,
\    nft_stmt_stmt_expr_concat_stmt_expr_keyword_dot

hi link   nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_ip6_hdr_expr_ip6_hdr_field_keyword_protocol nftHL_Keyword
syn match nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_ip6_hdr_expr_ip6_hdr_field_keyword_protocol '\vprotocol' skipwhite contained
\ nextgroup=
\    nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_keyword_map,
\    nft_stmt_stmt_expr_concat_stmt_expr_keyword_dot

hi link   nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_th_hdr_expr_keyword_th nftHL_Statement
syn match nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_th_hdr_expr_keyword_th '\vth' skipwhite contained
\ nextgroup=
\    nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_tcp_hdr_expr_tcp_hdr_field_keyword_dport,
\    nftHL_Normal

hi link   nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_ip_hdr_expr_keyword_ip nftHL_Statement
syn match nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_ip_hdr_expr_keyword_ip '\vip' skipwhite contained
\ nextgroup=
\    nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_ip6_hdr_expr_ip6_hdr_field_keyword_protocol,
\    nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_ip6_hdr_expr_ip6_hdr_field_keyword_daddr

hi link   nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_tcp_hdr_expr_tcp_hdr_field_keyword_dport nftHL_Keyword
syn match nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_tcp_hdr_expr_tcp_hdr_field_keyword_dport '\v(sport|dport)' skipwhite contained
\ nextgroup=
\    nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_keyword_map,
\    nft_stmt_stmt_expr_concat_stmt_expr_keyword_dot

hi link   nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_tcp_hdr_expr_keyword_tcp nftHL_Statement
syn match nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_tcp_hdr_expr_keyword_tcp '\vtcp' skipwhite contained
\ nextgroup=
\    nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_tcp_hdr_expr_tcp_hdr_field_keyword_dport,

hi link   nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_ip6_hdr_expr_keyword_ip6 nftHL_Statement
syn match nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_ip6_hdr_expr_keyword_ip6 '\vip6' skipwhite contained
\ nextgroup=
\    nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_ip6_hdr_expr_ip6_hdr_field_keyword_protocol,
\    nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_ip6_hdr_expr_ip6_hdr_field_keyword_daddr

hi link    nft_stmt_objref_stmt_objref_stmt_ct_stmt_expr_symbol_stmt_expr_symbol_expr_string_quoted_string nftHL_String
syn region nft_stmt_objref_stmt_objref_stmt_ct_stmt_expr_symbol_stmt_expr_symbol_expr_string_quoted_string start='\"' end='\"' oneline skipwhite contained

hi link   nft_ct_stmt_verdict_stmt_verdict_map_stmt_set_ref_expr_set_ref_symbol_expr_keyword_at_identifier nftHL_Variable
syn match nft_ct_stmt_verdict_stmt_verdict_map_stmt_set_ref_expr_set_ref_symbol_expr_keyword_at_identifier '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_stmt_objref_stmt_objref_stmt_ct_keyword_set nftHL_Write
syn match nft_stmt_objref_stmt_objref_stmt_ct_keyword_set '\vset[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_ct_expectation_stmt_expr

syn cluster nft_c_ct_expectation_stmt_expr
\ contains=
\    nft_stmt_stmt_expr_map_stmt_expr_symbol_expr_string_quoted_string_conntrack_types,
\    nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_tcp_hdr_expr_keyword_tcp,
\    nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_ip6_hdr_expr_keyword_ip6,
\    nft_stmt_ct_stmt_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_payload_ip_hdr_expr_keyword_ip,
\    nft_stmt_objref_stmt_objref_stmt_ct_stmt_expr_symbol_stmt_expr_symbol_expr_string_quoted_string,
\    nft_ct_stmt_verdict_stmt_verdict_map_stmt_set_ref_expr_set_ref_symbol_expr_keyword_at_identifier


hi link   nft_stmt_objref_stmt_objref_stmt_ct_keyword_expectation nftHL_Keyword
syn match nft_stmt_objref_stmt_objref_stmt_ct_keyword_expectation '\vexpectation[ \t]' skipwhite contained
\ nextgroup=
\    nft_stmt_objref_stmt_objref_stmt_ct_keyword_set

hi link   nft_stmt_objref_stmt_objref_stmt_ct_keyword_timeout nftHL_Keyword
syn match nft_stmt_objref_stmt_objref_stmt_ct_keyword_timeout '\vtimeout[ \t]' skipwhite contained
\ nextgroup=
\    nft_stmt_objref_stmt_objref_stmt_ct_keyword_set
"    nft_conntrack_types is only done OUTSIDE chain_block
" ********************* END 'objref_stmt_ct' **********************


  for s:this_semantic_file in s:stmt_ct_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_ct for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_ct.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_ct = v:true
