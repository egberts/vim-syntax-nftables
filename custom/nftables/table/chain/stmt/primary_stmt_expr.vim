" File: primary_stmt_expr.vim
" Directory: custom/nftables/table/chain/stmt/expr/
"
let s:primary_stmt_expr_list_filepaths_semantic_early = []
let s:primary_stmt_expr_list_filepaths_semantic_later = []

if exists('b:did_nftables_primary_stmt_expr')
  call nftables#syntax#log('INFO', 'Skipped payload_stmt_expr (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:primary_stmt_expr_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading payload_expr syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
"*************** BEGIN primary_stmt_expr *******************************
" primary_stmt_expr includes symbol_expr (done)
" primary_stmt_expr includes integer_expr
" primary_stmt_expr includes boolean_expr
" primary_stmt_expr includes meta_expr
" primary_stmt_expr includes rt_expr
" primary_stmt_expr includes ct_expr
" primary_stmt_expr includes numgen_expr
" primary_stmt_expr includes hash_expr
" primary_stmt_expr includes payload_expr
" primary_stmt_expr includes keyword_expr
" primary_stmt_expr includes socket_expr
" primary_stmt_expr includes osf_expr
" primary_stmt_expr includes ( basic_stmt_expr )
"
" All first-order, first-encountered keywords from all the semantic actions
" above are then placed inside 'contains=' in decreasing order of length of
" its lexical token then in least-to-most permissive regex order.
"

syn cluster nft_c_primary_stmt_expr
\ contains=
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_rtclassid,
\    nft_verdict_expr_keyword_continue,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_ibriport,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_iifgroup,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_obriport,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_oifgroup,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_ibrname,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_iifname,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_iiftype,
\    nft_stmt_primary_stmt_expr_boolean_expr_boolean_keys_keyword_missing,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_nftrace,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_obrname,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_oifname,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_oiftype,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_pkttype,
\    nft_payload_expr_hash_expr_keyword_symhash,
\    nft_payload_expr_udplite_hdr_expr_keyword_udplite,
\    nft_verdict_expr_keyword_accept,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_cgroup,
\    nft_stmt_primary_stmt_expr_boolean_expr_boolean_keys_keyword_exists,
\    nft_payload_expr_geneve_hdr_expr_keyword_geneve,
\    nft_payload_expr_gretap_hdr_expr_keyword_gretap,
\    nft_payload_expr_icmpv6_hdr_expr_keyword_icmpv6,
\    nft_chain_block_primary_expr_numgen_expr_keyword_numgen,
\    nft_stmt_reject_stmt_reject_stmt_alloc_keyword_reject,
\    nft_verdict_expr_keyword_return,
\    nft_socket_expr_keyword_socket,
\    nft_payload_expr_keyword_expr_keyword_ether,
\    nft_payload_expr_hash_expr_keyword_jhash,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_ipsec,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_skuid,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_skgid,
\    nft_payload_expr_vxlan_hdr_expr_keyword_vxlan,
\    nft_payload_expr_comp_hdr_expr_keyword_comp,
\    nft_payload_expr_dccp_hdr_expr_keyword_dccp,
\    nft_verdict_expr_keyword_drop,
\    nft_verdict_expr_keyword_goto,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_hour,
\    nft_payload_expr_icmp_hdr_expr_keyword_icmp,
\    nft_payload_expr_igmp_hdr_expr_keyword_igmp,
\    nft_verdict_expr_keyword_jump,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_mark,
\    nft_payload_expr_meta_expr_keyword_meta,
\    nft_payload_expr_sctp_hdr_expr_keyword_sctp,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_time,
\    nft_keyword_expr_keyword_vlan,
\    nft_keyword_expr_keyword_arp,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_cpu,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_day,
\    nft_payload_expr_esp_hdr_expr_keyword_esp,
\    nft_payload_expr_gre_hdr_expr_keyword_gre,
\    nft_meta_expr_meta_key_unqualified_keyword_iif,
\    nft_payload_expr_ip6_hdr_expr_keyword_ip6,
\    nft_payload_expr_meta_expr_keyword_meta_key_unqualified_keyword_oif,
\    nft_payload_expr_tcp_hdr_expr_keyword_tcp,
\    nft_payload_expr_udp_hdr_expr_keyword_udp,
\    nft_payload_expr_auth_hdr_expr_keyword_ah,
\    nft_payload_expr_ct_expr_keyword_ct,
\    nft_stmt_declarative_keyword_ip,
\    payload_expr_nft_rt_expr_keyword_rt,
\    nft_payload_expr_th_hdr_expr_keyword_th,
\    nft_payload_expr_payload_raw_expr_keyword_at,
\    nft_stmt_primary_stmt_expr_symbol_expr_variable_expr,
\    nft_stmt_verdict_expr_chain_expr_variable_expr,
\    nft_stmt_primary_stmt_expr_integer_expr_num,
\    nft_stmt_primary_stmt_expr_symbol_expr_string
"*************** END primary_stmt_expr *******************************


  for s:this_semantic_file in s:primary_stmt_expr_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded payload_expr for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define primary_stmt_expr.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_primary_stmt_expr = v:true
