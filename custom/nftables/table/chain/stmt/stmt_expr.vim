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


syn cluster nft_c_stmt_expr
\ contains=
\    nft_payload_expr_hash_expr_keyword_symhash,
\    nft_stmt_payload_expr_udplite_hdr_expr_keyword_udplite,
\    nft_stmt_payload_expr_geneve_hdr_expr_keyword_geneve,
\    nft_stmt_payload_expr_gretap_hdr_expr_keyword_gretap,
\    nft_stmt_payload_expr_icmpv6_hdr_expr_keyword_icmpv6,
\    nft_payload_expr_keyword_expr_keyword_ether,
\    nft_stmt_payload_expr_vxlan_hdr_expr_keyword_vxlan,
\    nft_stmt_payload_expr_comp_hdr_expr_keyword_comp,
\    nft_stmt_payload_expr_dccp_hdr_expr_keyword_dccp,
\    nft_stmt_payload_expr_icmp_hdr_expr_keyword_icmp,
\    nft_stmt_keyword_icmp,
\    nft_stmt_payload_expr_igmp_hdr_expr_keyword_igmp,
\    nft_payload_expr_hash_expr_keyword_jhash,
\    nft_stmt_payload_expr_sctp_hdr_expr_keyword_sctp,
\    nft_stmt_payload_expr_vlan_hdr_expr_keyword_vlan,
\    nft_stmt_payload_expr_arp_hdr_expr_keyword_arp,
\    nft_stmt_payload_expr_esp_hdr_expr_keyword_esp,
\    nft_stmt_payload_expr_gre_hdr_expr_keyword_gre,
\    nft_stmt_payload_expr_ip6_hdr_expr_keyword_ip6,
\    nft_stmt_keyword_ip6,
\    nft_map_expr_keyword_map,
\    nft_stmt_payload_expr_tcp_hdr_expr_keyword_tcp,
\    nft_stmt_payload_expr_udp_hdr_expr_keyword_udp,
\    nft_stmt_payload_expr_auth_hdr_expr_keyword_ah,
\    nft_stmt_payload_expr_th_hdr_expr_keyword_th,
\    nft_stmt_payload_expr_payload_raw_expr_keyword_at,

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
