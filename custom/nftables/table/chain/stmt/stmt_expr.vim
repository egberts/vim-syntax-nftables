" File: stmt_expr.vim
" Directory: custom/nftables/table/chain/stmt/

"
let s:stmt_expr_list_filepaths_semantic_early = []
let s:stmt_expr_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_expr')
  call nftables#syntax#log('INFO', 'Skipped stmt_expr (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_expr_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_expr syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

"**************** BEGIN stmt_expr **********************************************
" stmt_expr - trying for a generic Vim syntax group (to reside ONLY within chain_block)
"   used by ct_stmt dup_stmt fwd_stmt masq_stmt_args meta_stmt nat_stmt
"           objref_stmt_counter objref_stmt_ct objref_stmt_limit
"           objref_stmt_quota objref_stmt_synproxy payload_stmt
"           redir_stmt_arg tproxy_stmt
"   points to map_stmt_expr, multion_stmt_expr, and symbol_stmt_expr
hi link   nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_symbol_expr_variable_expr nftHL_Variable
syn match nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_symbol_expr_string nftHL_String
syn match nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_symbol_expr_string '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_integer_expr_num nftHL_Integer
syn match nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_integer_expr_num '\v[0-9]{1,10}' skipwhite contained

hi link   nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_boolean_expr_keywords nftHL_Define
syn match nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_boolean_expr_keywords '\v(missing|exists)' skipwhite contained

hi link   nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_boolean_expr_keyword_exists nftHL_Define
syn match nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_boolean_expr_keyword_exists '\vexists' skipwhite contained

hi link   nft_symbol_stmt_expr_symbol_expr_variable_expr_variable nftHL_Variable
syn match nft_symbol_stmt_expr_symbol_expr_variable_expr_variable '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_symbol_stmt_expr_symbol_expr_quoted_string nftHL_String
syn region nft_symbol_stmt_expr_symbol_expr_quoted_string start='\"' end='\"' oneline skipwhite contained

syn cluster nft_c_symbol_stmt_expr
\ contains=
\    nft_symbol_stmt_expr_symbol_expr_variable_expr_variable,
\    nft_symbol_stmt_expr_symbol_expr_quoted_string

" stmt_expr; referenced by referenced by: ct_stmt dup_stmt fwd_stmt masq_stmt_args
"     meta_stmt nat_stmt objref_stmt_counter objref_stmt_ct objref_stmt_limit
"     objref_stmt_quota objref_stmt_synproxy payload_stmt redir_stmt_arg tproxy_stmt

syn cluster nft_c_stmt_expr
\ contains=
\    nft_boolean_expr_boolean_key_keyword_missing,
\    nft_payload_expr_hash_expr_keyword_symhash,
\    nft_stmt_payload_expr_udplite_hdr_expr_keyword_udplite,
\    nft_boolean_expr_boolean_key_keyword_exists,
\    nft_stmt_payload_expr_geneve_hdr_expr_keyword_geneve,
\    nft_stmt_payload_expr_gretap_hdr_expr_keyword_gretap,
\    nft_payload_expr_icmp6_hdr_expr_icmp6_hdr_field_keyword_icmp6,
\    nft_payload_expr_keyword_expr_keyword_ether,
\    nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_boolean_expr_keyword_exists,
\    nft_stmt_payload_expr_vxlan_hdr_expr_keyword_vxlan,
\    nft_stmt_payload_expr_comp_hdr_expr_keyword_comp,
\    nft_stmt_payload_expr_dccp_hdr_expr_keyword_dccp,
\    nft_meta_expr_invalid_keyword_flow,
\    nft_payload_expr_icmp_hdr_expr_keyword_icmp,
\    nft_stmt_keyword_icmp,
\    nft_stmt_payload_expr_igmp_hdr_expr_keyword_igmp,
\    nft_payload_expr_hash_expr_keyword_jhash,
\    nft_stmt_payload_expr_sctp_hdr_expr_keyword_sctp,
\    nft_stmt_payload_expr_vlan_hdr_expr_keyword_vlan,
\    nft_stmt_payload_expr_arp_hdr_expr_keyword_arp,
\    nft_stmt_payload_expr_esp_hdr_expr_keyword_esp,
\    nft_stmt_payload_expr_gre_hdr_expr_keyword_gre,
\    nft_meta_expr_meta_key_unqualified_keyword_iif,
\    nft_stmt_payload_expr_ip6_hdr_expr_keyword_ip6,
\    nft_stmt_keyword_ip6,
\    nft_stmt_keyword_ip6,
\    nft_map_expr_keyword_map,
\    nft_meta_expr_meta_key_unqualified_keyword_oif,
\    nft_stmt_payload_expr_tcp_hdr_expr_keyword_tcp,
\    nft_stmt_payload_expr_udp_hdr_expr_keyword_udp,
\    nft_payload_expr_ip_protocol_keyword_udp,
\    nft_stmt_payload_expr_auth_hdr_expr_keyword_ah,
\    nft_primary_stmt_expr_ct_expr_keyword_ct,
\    nft_stmt_declarative_keyword_ip,
\    nft_stmt_payload_expr_th_hdr_expr_keyword_th,
\    nft_stmt_payload_expr_payload_raw_expr_keyword_at,
\    nft_stmt_expr_map_stmt_expr_set_expr_set_ref_expr_set_symbol_ref_expr_keyword_at_identifier,
\    nft_stmt_expr_map_stmt_expr_set_expr,
\    @nft_c_multion_stmt_expr,
\    @nft_c_symbol_stmt_expr,
\    nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_symbol_expr_variable_expr,
\    nft_stmt_expr_map_stmt_expr_set_expr_set_ref_expr_set_symbol_ref_expr_variable

  for s:this_semantic_file in s:stmt_expr_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_expr for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_expr.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_expr = v:true
