" File: template_name.vim
" Directory: custom/nftables/
" TODO: Replace 'template_name' with filename of this script
"
let s:template_name_list_filepaths_semantic_early = []
let s:template_name_list_filepaths_semantic_later = []

if exists('b:did_nftables_template_name')
  call nftables#syntax#log('INFO', 'Skipped template_name (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:template_name_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading template_name syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
" base_cmd add_cmd 'table' 'set' set_block typeof_key_expr 'type' typeof_expr primary_expr
hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr nftHL_Identifier
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr skipwhite contained
\  '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}'
" do not use 'skipwhite' here

" ******************* BEGIN 'type <type>' ****************************
hi link   nft_set_block_typeof_key_expr_typeof_expr_symbol_dot nftHL_Operator
syn match nft_set_block_typeof_key_expr_typeof_expr_symbol_dot '\v\.' skipwhite contained
\ nextgroup=
\    nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp6_hdr_expr_keyword_icmpv6,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp_hdr_expr_keyword_icmp,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_oifname,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_iifname,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_ipsec,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vxlan_hdr_expr_keyword_vxlan,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_keyword_frag,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_qualified_keyword_mark,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_keyword_meta,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_keyword_sctp,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vlan_expr_keyword_vlan,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_payload_raw_expr_payload_base_spec_string_keyword_at_ih,
\    nft_set_block_family_netdev_typeof_key_expr_typeof_expr_primary_expr_payload_expr_eth_hdr_expr_keyword_eth,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_iif,
\    nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip6_hdr_expr_keyword_ip6,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_oif,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_osf_expr_keyword_osf,
\    nft_set_block_family_inet_typeof_key_expr_typeof_expr_primary_expr_payload_expr_tcp_hdr_expr_keyword_tcp,
\    nft_set_block_family_inet_typeof_key_expr_typeof_expr_primary_expr_payload_expr_udp_hdr_expr_keyword_udp,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_keyword_ct,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_keyword_ip,

hi link   nft_set_block_typeof_key_expr_typeof_expr_symbol_colon nftHL_Operator
syn match nft_set_block_typeof_key_expr_typeof_expr_symbol_colon '\v:' skipwhite contained
\ nextgroup=
\    nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp6_hdr_expr_keyword_icmpv6,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp_hdr_expr_keyword_icmp,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_oifname,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_iifname,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_ipsec,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vxlan_hdr_expr_keyword_vxlan,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_keyword_frag,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_qualified_keyword_mark,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_keyword_meta,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_keyword_sctp,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vlan_expr_keyword_vlan,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_payload_raw_expr_payload_base_spec_string_keyword_at_ih,
\    nft_set_block_family_netdev_typeof_key_expr_typeof_expr_primary_expr_payload_expr_eth_hdr_expr_keyword_eth,
\    nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip6_hdr_expr_keyword_ip6,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_iif,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_oif,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_osf_expr_keyword_osf,
\    nft_set_block_family_inet_typeof_key_expr_typeof_expr_primary_expr_payload_expr_tcp_hdr_expr_keyword_tcp,
\    nft_set_block_family_inet_typeof_key_expr_typeof_expr_primary_expr_payload_expr_udp_hdr_expr_keyword_udp,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_keyword_ct,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_keyword_ip,


" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr 'type'  <family>
hi link   nft_set_block_typeof_key_expr_type_data_type_expr nftHL_Define
syn match nft_set_block_typeof_key_expr_type_data_type_expr
\ '\vinet_service|fib_addrtype|dccp_pkttype|iface_index|icmpv6_type|icmpv6_code|inet_proto|iface_type|icmpx_code|ether_type|ether_addr|ipv6_addr|ipv4_addr|igmp_type|icmp_type|icmp_code|ct_status|cgroupsv2|tcp_flag|pkt_type|nf_proto|devgroup|ct_state|ct_label|ct_event|mh_type|bitmask|classid|boolean|integer|ll_addr|verdict|string|ifname|ct_dir|arp_op|realm|time|mark|dscp|gid|uid|ecn'
\ skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr 'type'
hi link   nft_set_block_typeof_key_expr_keyword_type nftHL_Command
syn match nft_set_block_typeof_key_expr_keyword_type '\v\s\zstype\ze[ \t]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
" ********************* END 'type <type>' ****************************

" ******************** BEGIN set_block 'typeof' **********************
" ******************** BEGIN set_block 'typeof ipsec' *******************
" reqid is not a packet field — it's a policy attribute
hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_ipsec nftHL_Substatement
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_ipsec  '\vipsec\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
" ******************** END set_block 'typeof ipsec' *******************

" ******************** BEGIN set_block 'typeof iifname' *******************
hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_iif nftHL_Substatement
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_iif  '\viif\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_iifname nftHL_Substatement
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_iifname  '\viifname\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
" ******************** END set_block 'typeof iifname' *******************

" ******************** BEGIN set_block 'typeof oifname' *******************
hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_oif nftHL_Substatement
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_oif  '\voif\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_oifname nftHL_Substatement
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_oifname  '\voifname\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
" ******************** END set_block 'typeof oifname' *******************
hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_id nftHL_Keyword
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_id '\vid\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_ttl nftHL_Keyword
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_ttl '\vttl\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_ecn nftHL_Keyword
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_ecn '\vecn\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_dscp nftHL_Keyword
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_dscp '\vdscp\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_daddr nftHL_Keyword
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_daddr '\vdaddr\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_saddr nftHL_Keyword
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_saddr '\vsaddr\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

" ************** BEGIN 'typeof ip option *****************************
hi link   nft_set_block_ip_hdr_expr_ip_option_field_keyword_value nftHL_Keyword
syn match nft_set_block_ip_hdr_expr_ip_option_field_keyword_value '\vvalue\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_ip_hdr_expr_close_scope_ip_keyword_kind nftHL_Keyword
syn match nft_set_block_ip_hdr_expr_close_scope_ip_keyword_kind '\vkind\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link nft_set_block_typeof_key_expr_typeof_expr_ip_hdr_expr_options_keyword_lsrr nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_ip_hdr_expr_options_keyword_lsrr '\vlsrr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_ip_hdr_expr_ip_option_field_keyword_value,
\    nft_set_block_ip_hdr_expr_close_scope_ip_keyword_kind,
\    nft_Error

hi link nft_set_block_typeof_key_expr_typeof_expr_ip_hdr_expr_options_keyword_ssrr nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_ip_hdr_expr_options_keyword_ssrr '\vssrr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_ip_hdr_expr_ip_option_field_keyword_value,
\    nft_set_block_ip_hdr_expr_close_scope_ip_keyword_kind,
\    nft_Error

hi link nft_set_block_typeof_key_expr_typeof_expr_ip_hdr_expr_options_keyword_rr nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_ip_hdr_expr_options_keyword_rr '\vrr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_ip_hdr_expr_ip_option_field_keyword_value,
\    nft_set_block_ip_hdr_expr_close_scope_ip_keyword_kind,
\    nft_Error

hi link nft_set_block_typeof_key_expr_typeof_expr_ip_hdr_expr_options_keyword_ra nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_ip_hdr_expr_options_keyword_ra '\vra\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_ip_hdr_expr_ip_option_field_keyword_value,
\    nft_set_block_ip_hdr_expr_close_scope_ip_keyword_kind,
\    nft_Error

hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_option nftHL_Keyword
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_option '\voption\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_ip_hdr_expr_options_keyword_lsrr,
\    nft_set_block_typeof_key_expr_typeof_expr_ip_hdr_expr_options_keyword_ssrr,
\    nft_set_block_typeof_key_expr_typeof_expr_ip_hdr_expr_options_keyword_rr,
\    nft_set_block_typeof_key_expr_typeof_expr_ip_hdr_expr_options_keyword_ra,
\    nft_Error
" ************** END 'typeof ip option *******************************

hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_length nftHL_Keyword
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_length '\vlength\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_version nftHL_Keyword
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_version '\vversion\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_frag_off nftHL_Keyword
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_frag_off '\vfrag\-off\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_checksum nftHL_Keyword
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_checksum '\vchecksum\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_protocol nftHL_Keyword
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_protocol '\vprotocol\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_hdrlength nftHL_Keyword
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_hdrlength '\vhdrlength\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_keyword_ip nftHL_Substatement
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_keyword_ip 'ip\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_hdrlength,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_protocol,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_checksum,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_frag_off,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_version,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_length,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_option,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_saddr,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_daddr,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_dscp,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_ecn,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_ttl,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_id,
\    nft_Error
" ******************** END set_block 'typeof ip' *********************

" *************** BEGIN set_block 'typeof icmp' **********************
hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp_hdr_expr_icmp_hdr_field_keyword_type nftHL_Keyword
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp_hdr_expr_icmp_hdr_field_keyword_type '\vtype\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp_hdr_expr_icmp_hdr_field_keyword_code nftHL_Keyword
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp_hdr_expr_icmp_hdr_field_keyword_code '\vcode\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp_hdr_expr_keyword_icmp nftHL_Substatement
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp_hdr_expr_keyword_icmp 'icmp\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp_hdr_expr_icmp_hdr_field_keyword_type,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp_hdr_expr_icmp_hdr_field_keyword_code,
\    nft_Error
" ******************** END set_block 'typeof icmp' *****************************

" ******************** BEGIN set_block 'typeof ip6' ****************************
hi link   nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_saddr nftHL_Keyword
syn match nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_saddr '\vsaddr\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_daddr nftHL_Keyword
syn match nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_daddr '\vdaddr\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_nexthdr nftHL_Keyword
syn match nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_nexthdr '\vnexthdr\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip6_hdr_expr_keyword_ip6 nftHL_Substatement
syn match nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip6_hdr_expr_keyword_ip6 'ip6\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_nexthdr,
\    nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_saddr,
\    nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_daddr,
\    nft_Error
" ******************** END set_block 'typeof ip6' ******************************

" ******************** BEGIN set_block 'typeof icmpv6' *************************
hi link   nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp6_hdr_expr_icmp6_hdr_field_keyword_type nftHL_Keyword
syn match nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp6_hdr_expr_icmp6_hdr_field_keyword_type '\vtype\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp6_hdr_expr_icmp6_hdr_field_keyword_code nftHL_Keyword
syn match nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp6_hdr_expr_icmp6_hdr_field_keyword_code '\vcode\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp6_hdr_expr_keyword_icmpv6 nftHL_Substatement
syn match nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp6_hdr_expr_keyword_icmpv6 'icmpv6\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp6_hdr_expr_icmp6_hdr_field_keyword_type,
\    nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp6_hdr_expr_icmp6_hdr_field_keyword_code,
\    nft_Error
" ******************** END set_block 'typeof icmpv6' ***************************

" ******************** BEGIN set_block 'typeof ether' **************************
hi link   nft_set_block_family_netdev_typeof_key_expr_typeof_expr_primary_expr_payload_expr_eth_hdr_expr_eth_hdr_field_keyword_saddr nftHL_Keyword
syn match nft_set_block_family_netdev_typeof_key_expr_typeof_expr_primary_expr_payload_expr_eth_hdr_expr_eth_hdr_field_keyword_saddr '\vsaddr\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_netdev_typeof_key_expr_typeof_expr_primary_expr_payload_expr_eth_hdr_expr_eth_hdr_field_keyword_daddr nftHL_Keyword
syn match nft_set_block_family_netdev_typeof_key_expr_typeof_expr_primary_expr_payload_expr_eth_hdr_expr_eth_hdr_field_keyword_daddr '\vdaddr\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_netdev_typeof_key_expr_typeof_expr_primary_expr_payload_expr_eth_hdr_expr_keyword_eth nftHL_Substatement
syn match nft_set_block_family_netdev_typeof_key_expr_typeof_expr_primary_expr_payload_expr_eth_hdr_expr_keyword_eth 'ether\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_family_netdev_typeof_key_expr_typeof_expr_primary_expr_payload_expr_eth_hdr_expr_eth_hdr_field_keyword_saddr,
\    nft_set_block_family_netdev_typeof_key_expr_typeof_expr_primary_expr_payload_expr_eth_hdr_expr_eth_hdr_field_keyword_daddr,
\    nft_Error
" ******************** END set_block 'typeof ether' ****************************

" ******************** BEGIN set_block 'typeof udp' ****************************
hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_udp_hdr_expr_udp_hdr_field_keyword_sport nftHL_Keyword
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_udp_hdr_expr_udp_hdr_field_keyword_sport '\vsport\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_udp_hdr_expr_udp_hdr_field_keyword_dport nftHL_Keyword
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_udp_hdr_expr_udp_hdr_field_keyword_dport '\vdport\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_udp_hdr_expr_keyword_udp nftHL_Substatement
syn match nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_udp_hdr_expr_keyword_udp 'udp\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_udp_hdr_expr_udp_hdr_field_keyword_sport,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_udp_hdr_expr_udp_hdr_field_keyword_dport,
\    nft_Error
" ******************** END set_block 'typeof udp' ******************************

" ******************** BEGIN set_block 'typeof mark' ***************************
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_qualified_keyword_mark nftHL_Substatement
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_qualified_keyword_mark 'mark\ze[ \t\n;]' skipwhite contained
" ******************** END set_block 'typeof mark' *****************************

" ******************** BEGIN set_block 'typeof meta' ***************************
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_qualified_keyword_protocol nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_qualified_keyword_protocol '\vprotocol\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_qualified_keyword_priority nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_qualified_keyword_priority '\vpriority\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_unqualified_keyword_iifname nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_unqualified_keyword_iifname '\viifname\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_unqualified_keyword_oifname nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_unqualified_keyword_oifname '\voifname\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_unqualified_keyword_skuid nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_unqualified_keyword_skuid '\vskuid\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_unqualified_keyword_skgid nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_unqualified_keyword_skgid '\vskgid\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_unqualified_keyword_mark nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_unqualified_keyword_mark '\vmark\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_unqualified_keyword_iif nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_unqualified_keyword_iif '\viif\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_unqualified_keyword_oif nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_unqualified_keyword_oif '\voif\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon


hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_keyword_meta nftHL_Substatement
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_keyword_meta 'meta\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_qualified_keyword_protocol,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_unqualified_keyword_mark,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_ipsec,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_qualified_keyword_priority,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_unqualified_keyword_skuid,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_unqualified_keyword_skgid,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_unqualified_keyword_iif,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_unqualified_keyword_oif,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_unqualified_keyword_iifname,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_meta_key_unqualified_keyword_oifname,
\    nft_Error
" ******************** END set_block 'typeof meta' *****************************

" ******************** BEGIN set_block 'typeof ct' *****************************
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_expiration nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_expiration '\vexpiration\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_proto_dst nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_proto_dst '\vproto\-dst\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_proto_src nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_proto_src '\vproto\-src\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_l3proto nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_l3proto '\vl3proto\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_ct_key_dir_optional_keyword_packets nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_ct_key_dir_optional_keyword_packets '\vpackets\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_secmark nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_secmark '\vsecmark\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_ct_key_dir_optional_keyword_avgpkt nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_ct_key_dir_optional_keyword_avgpkt '\vavgpkt\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_helper nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_helper '\vhelper\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_status nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_status '\vstatus\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_ct_key_dir_optional_keyword_bytes nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_ct_key_dir_optional_keyword_bytes '\vbytes\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_daddr nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_daddr '\vdaddr\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_event nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_event '\vevent\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_label nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_label '\vlabel\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_saddr nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_saddr '\vsaddr\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_state nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_state '\vstate\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_mark nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_mark '\vmark\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_ct_key_dir_optional_keyword_zone nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_ct_key_dir_optional_keyword_zone '\vzone\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_dir_keyword_dir nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_dir_keyword_dir '\v(original|reply)\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_id nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_id '\vid\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon


hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_keyword_ct nftHL_Substatement
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_keyword_ct '\v \zsct\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_expiration,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_proto_dst,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_proto_src,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_protocol,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_proto_id,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_l3proto,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_ct_key_dir_optional_keyword_packets,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_secmark,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_ct_key_dir_optional_keyword_avgpkt,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_helper,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_status,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_ct_key_dir_optional_keyword_bytes,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_daddr,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_saddr,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_event,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_label,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_state,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_keyword_mark,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_key_ct_key_dir_optional_keyword_zone,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_dir_keyword_dir,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_ct_dir_keyword_id,
\    nft_Error
" ******************** END set_block 'typeof ct' *******************************

" ******************** BEGIN set_block 'typeof tcp' *******************************
hi link   nft_set_block_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_value nftHL_Keyword
syn match nft_set_block_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_value '\vvalue\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_mss nftHL_Keyword
syn match nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_mss '\v(mss|maxseg)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_value,
\    nft_Error

hi link   nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_eol nftHL_Keyword
syn match nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_eol '\veol\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_nop nftHL_Keyword
syn match nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_nop '\vnop\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_num nftHL_Keyword
syn match nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_num '\vnum\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_echo nftHL_Keyword
syn match nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_echo '\vecho\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_tcp_hdr_option_sack_keyword_sack nftHL_Keyword
syn match nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_tcp_hdr_option_sack_keyword_sack '\vsack\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_tcp_hdr_option_sack_keyword_sack0 nftHL_Keyword
syn match nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_tcp_hdr_option_sack_keyword_sack0 '\vsack0\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_tcp_hdr_option_sack_keyword_sack1 nftHL_Keyword
syn match nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_tcp_hdr_option_sack_keyword_sack1 '\vsack1\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_tcp_hdr_option_sack_keyword_sack2 nftHL_Keyword
syn match nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_tcp_hdr_option_sack_keyword_sack2 '\vsack2\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_tcp_hdr_option_sack_keyword_sack3 nftHL_Keyword
syn match nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_tcp_hdr_option_sack_keyword_sack3 '\vsack3\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

" Supported Sub-Keywords for tcp option mptcp:
"    subtype: Matches the MPTCP subtype (8-bit value, e.g., 0 for MP_CAPABLE, 1 for MP_JOIN).
"    token_key: Matches the MPTCP token or key (32-bit or 64-bit value, depending on subtype).
"    token_rcv: Matches the receiver’s token (32-bit value).
"    token_snd: Matches the sender’s token (32-bit value).
"    addr_id: Matches the address ID (8-bit value, used in ADD_ADDR or REM_ADDR).
"    flags: Matches MPTCP flags (bitmask, specific to certain subtypes)
"
hi link   nft_tcp_hdr_option_kind_and_field_keyword_tcpopt_field_pctcp_keyword_token_key nftHL_Keyword
syn match nft_tcp_hdr_option_kind_and_field_keyword_tcpopt_field_pctcp_keyword_token_key '\vtoken\-key\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_tcp_hdr_option_kind_and_field_keyword_tcpopt_field_pctcp_keyword_token_rcv nftHL_Keyword
syn match nft_tcp_hdr_option_kind_and_field_keyword_tcpopt_field_pctcp_keyword_token_rcv '\vtoken\-rcv\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_tcp_hdr_option_kind_and_field_keyword_tcpopt_field_pctcp_keyword_token_snd nftHL_Keyword
syn match nft_tcp_hdr_option_kind_and_field_keyword_tcpopt_field_pctcp_keyword_token_snd '\vtoken\-snd\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_tcp_hdr_option_kind_and_field_keyword_tcpopt_field_pctcp_keyword_addr_id nftHL_Keyword
syn match nft_tcp_hdr_option_kind_and_field_keyword_tcpopt_field_pctcp_keyword_addr_id '\vaddr_id\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_tcp_hdr_option_kind_and_field_keyword_tcpopt_field_pctcp_keyword_subtype nftHL_Keyword
syn match nft_tcp_hdr_option_kind_and_field_keyword_tcpopt_field_pctcp_keyword_subtype '\vsubtype\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_tcp_hdr_option_kind_and_field_keyword_tcpopt_field_pctcp_keyword_flags nftHL_Keyword
syn match nft_tcp_hdr_option_kind_and_field_keyword_tcpopt_field_pctcp_keyword_flags '\vflags\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_mptcp nftHL_Keyword
syn match nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_mptcp '\vmptcp\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_tcp_hdr_option_kind_and_field_keyword_tcpopt_field_pctcp_keyword_token_key,
\    nft_tcp_hdr_option_kind_and_field_keyword_tcpopt_field_pctcp_keyword_token_rcv,
\    nft_tcp_hdr_option_kind_and_field_keyword_tcpopt_field_pctcp_keyword_token_snd,
\    nft_tcp_hdr_option_kind_and_field_keyword_tcpopt_field_pctcp_keyword_addr_id,
\    nft_tcp_hdr_option_kind_and_field_keyword_tcpopt_field_pctcp_keyword_subtype,
\    nft_tcp_hdr_option_kind_and_field_keyword_tcpopt_field_pctcp_keyword_flags,
\    nft_Error

hi link   nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_md5sig nftHL_Keyword
syn match nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_md5sig '\vmd5sig\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_window nftHL_Keyword
syn match nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_window '\vwindow\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_fastopen nftHL_Keyword
syn match nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_fastopen '\vfastopen\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_sack_perm nftHL_Keyword
syn match nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_sack_perm '\vsack\-perm\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_timestamp nftHL_Keyword
syn match nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_timestamp '\vtimestamp\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_keyword_option nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_keyword_option '\voption\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_sack_perm,
\    nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_timestamp,
\    nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_fastopen,
\    nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_window,
\    nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_md5sig,
\    nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_tcp_hdr_option_sack_keyword_sack0,
\    nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_tcp_hdr_option_sack_keyword_sack1,
\    nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_tcp_hdr_option_sack_keyword_sack2,
\    nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_tcp_hdr_option_sack_keyword_sack3,
\    nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_tcp_hdr_option_sack_keyword_sack,
\    nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_echo,
\    nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_eol,
\    nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_nop,
\    nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_num

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_keyword_option_lone nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_keyword_option_lone '\voption\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_mptcp,
\    nft_set_block_tcp_hdr_expr_tcp_hdr_option_type_keyword_mss,

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_doff nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_doff '\vdoff\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_flags nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_flags '\vflags\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_sport nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_sport '\vsport\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_dport nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_dport '\vdport\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_window nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_window '\vwindow\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_ackseq nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_ackseq '\vackseq\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_urgptr nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_urgptr '\vurgptr\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_reserved nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_reserved '\vreserved\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_reserved2 nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_reserved2 '\vreserved2\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_sequence nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_sequence '\vsequence\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_checksum nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_checksum '\vchecksum\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_family_inet_typeof_key_expr_typeof_expr_primary_expr_payload_expr_tcp_hdr_expr_keyword_tcp nftHL_Substatement
syn match nft_set_block_family_inet_typeof_key_expr_typeof_expr_primary_expr_payload_expr_tcp_hdr_expr_keyword_tcp  '\vtcp\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_sequence,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_checksum,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_reserved,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_window,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_ackseq,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_urgptr,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_keyword_option,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_sport,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_dport,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_flags,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_tcp_hdr_expr_tcp_hdr_field_keyword_doff,
\    nft_Error
" ******************** END set_block 'typeof tcp' *******************************

" ******************** BEGIN set_block 'typeof vlan' *****************************
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vlan_hdr_expr_vlan_hdr_field_keyword_type nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vlan_hdr_expr_vlan_hdr_field_keyword_type '\vtype\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vlan_hdr_expr_vlan_hdr_field_keyword_pcp nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vlan_hdr_expr_vlan_hdr_field_keyword_pcp '\vpcp\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vlan_hdr_expr_vlan_hdr_field_keyword_dei nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vlan_hdr_expr_vlan_hdr_field_keyword_dei '\vdei\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vlan_hdr_expr_vlan_hdr_field_keyword_cfi nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vlan_hdr_expr_vlan_hdr_field_keyword_cfi '\vcfi\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vlan_hdr_expr_vlan_hdr_field_keyword_id nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vlan_hdr_expr_vlan_hdr_field_keyword_id '\vid\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vlan_expr_keyword_vlan nftHL_Substatement
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vlan_expr_keyword_vlan '\v \zsvlan\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vlan_hdr_expr_vlan_hdr_field_keyword_type,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vlan_hdr_expr_vlan_hdr_field_keyword_pcp,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vlan_hdr_expr_vlan_hdr_field_keyword_dei,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vlan_hdr_expr_vlan_hdr_field_keyword_cfi,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vlan_hdr_expr_vlan_hdr_field_keyword_id,
\    nft_Error
" ******************** END set_block 'typeof vlan' *******************************

" ******************** BEGIN set_block 'typeof frag' *******************************
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_id nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_id '\vid\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_nexthdr nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_nexthdr '\vnexthdr\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_reserved nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_reserved '\vreserved\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_reserved2 nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_reserved2 '\vreserved2\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_more_fragments nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_more_fragments '\vmore\-fragments\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_frag_off nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_frag_off '\vfrag\-off\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_keyword_frag nftHL_Substatement
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_keyword_frag '\vfrag\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_more_fragments,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_reserved2,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_frag_off,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_reserved,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_nexthdr,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_id,
\    nft_Error
" ******************** END set_block 'typeof frag' *******************************

" ******************** BEGIN set_block 'typeof osf' *******************************
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_osf_expr_keyword_version nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_osf_expr_keyword_version '\vversion\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_osf_expr_keyword_name nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_osf_expr_keyword_name '\vname\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_osf_expr_osf_ttl_keyword_ttl nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_osf_expr_osf_ttl_keyword_ttl '\vname\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_osf_expr_keyword_osf nftHL_Substatement
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_osf_expr_keyword_osf '\vosf\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_osf_expr_keyword_version,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_osf_expr_keyword_name,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_osf_expr_osf_ttl_keyword_ttl,
\    nft_Error
" ******************** END set_block 'typeof osf' *******************************

" ******************** BEGIN set_block 'typeof vxlan' *******************************
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vxlan_hdr_expr_vxlan_hdr_field_keyword_flags nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vxlan_hdr_expr_vxlan_hdr_field_keyword_flags '\vflags\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vxlan_hdr_expr_vxlan_hdr_field_keyword_vni nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vxlan_hdr_expr_vxlan_hdr_field_keyword_vni '\vvni\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vxlan_hdr_expr_keyword_vxlan nftHL_Substatement
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vxlan_hdr_expr_keyword_vxlan '\vvxlan\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_more_fragments,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_reserved2,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_frag_off,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_reserved,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_nexthdr,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_frag_hdr_field_keyword_id,
\    nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp6_hdr_expr_keyword_icmpv6,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp_hdr_expr_keyword_icmp,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_oifname,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_iifname,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_ipsec,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_keyword_frag,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_qualified_keyword_mark,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_keyword_meta,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vlan_expr_keyword_vlan,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_payload_raw_expr_payload_base_spec_string_keyword_at_ih,
\    nft_set_block_family_netdev_typeof_key_expr_typeof_expr_primary_expr_payload_expr_eth_hdr_expr_keyword_eth,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_iif,
\    nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip6_hdr_expr_keyword_ip6,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_oif,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_osf_expr_keyword_osf,
\    nft_set_block_family_inet_typeof_key_expr_typeof_expr_primary_expr_payload_expr_tcp_hdr_expr_keyword_tcp,
\    nft_set_block_family_inet_typeof_key_expr_typeof_expr_primary_expr_payload_expr_udp_hdr_expr_keyword_udp,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_keyword_ct,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_keyword_ip,
\    nft_Error
" ******************** END set_block 'typeof vxlan' *******************************

" ******************** BEGIN set_block 'typeof ih' *******************************
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_payload_raw_expr_integer_expr_num2 nftHL_Integer
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_payload_raw_expr_integer_expr_num2 '\v[0-9]{1,5}' skipwhite contained

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_payload_raw_expr_symbol_comma2 nftHL_Operator
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_payload_raw_expr_symbol_comma2 '\v,' skipwhite contained
\ nextgroup=
\         nft_set_block_typeof_key_expr_typeof_expr_primary_expr_payload_raw_expr_integer_expr_num2,
\    nft_Error

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_payload_raw_expr_integer_expr_num1 nftHL_Integer
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_payload_raw_expr_integer_expr_num1 '\v[0-9]{1,5}' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_payload_raw_expr_symbol_comma2,
\    nft_Error

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_payload_raw_expr_symbol_comma1 nftHL_Operator
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_payload_raw_expr_symbol_comma1 '\v,' skipwhite contained
\ nextgroup=
\         nft_set_block_typeof_key_expr_typeof_expr_primary_expr_payload_raw_expr_integer_expr_num1,
\    nft_Error

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_payload_raw_expr_payload_base_spec_string_keyword_at_ih nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_payload_raw_expr_payload_base_spec_string_keyword_at_ih '\v\@(lh|nh|th|ih)\ze[ \t,]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_payload_raw_expr_symbol_comma1,
\    nft_Error
" ******************** END set_block 'typeof ih' *******************************

" ******************** BEGIN set_block 'typeof sctp' *******************************
" 'sctp' 'chunk' 'type'
" 'type'->sctp_chunk_common_field->sctp_chunk_allow->'chunk'->'sctp'->sctp_hdr_expr
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_type nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_type "type" skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

" 'sctp' 'chunk' 'flags'
" 'flags'->ntf_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field->sctp_chunk_allow->'chunk'->'sctp'->sctp_hdr_expr
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_flags nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_flags "flags" skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

" 'sctp' 'chunk' 'length'
" 'length'->sctp_chunk_common_field->sctp_chunk_allow->'chunk'->'sctp'->sctp_hdr_expr
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_length nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_length "length" skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

" 'sctp' 'chunk'
" sctp_chunk_common_field->sctp_chunk_allow->'chunk'->'sctp'->sctp_hdr_expr
syn cluster nft_c_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field
\ contains=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_length,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_flags,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_type,
\    nft_EOS

" ******************** BEGIN set_block 'typeof sctp chunk cwr' *******************************
" 'sctp' 'chunk' ( 'ecne'|'cwr') 'lowest-tsn'
" 'lowest-tsn'->sctp_chunk_alloc->sctp_hdr_expr
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_chunk_alloc_keyword_lowest_tsn nftHL_Define
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_chunk_alloc_keyword_lowest_tsn 'lowest\-tsn' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_symbol_dot,
\    nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_cwr nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_cwr '\vcwr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_chunk_alloc_keyword_lowest_tsn,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_length,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_flags,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_type,
" ******************** END set_block 'typeof chunk ecne' *******************************

" ******************** BEGIN set_block 'typeof sctp data' *******************************
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_data_field_keyword_stream nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_data_field_keyword_stream '\vstream\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_symbol_dot,
\    nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_data_field_keyword_ppid nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_data_field_keyword_ppid '\vppid\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_data_field_keyword_tsn nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_data_field_keyword_tsn '\vtsn\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_data_field_keyword_ssn nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_data_field_keyword_ssn '\vssn\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

" 'sctp' 'chunk' 'data' [ 'tsn' | 'stream' | 'ssn' | 'ppid' ]
" sctp_chunk_data_field->'data'->sctp_chuck_alloc->'chunk'->'sctp'->sctp_hdr_expr
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_data nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_data '\vdata\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_data_field_keyword_stream,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_length,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_flags,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_data_field_keyword_ppid,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_type,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_data_field_keyword_tsn,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_data_field_keyword_ssn,
\    nft_Error
" ******************** BEGIN set_block 'typeof sctp data' *******************************

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_ecne nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_ecne '\vecne\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_length,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_flags,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_type,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_chunk_alloc_keyword_lowest_tsn,
\    nft_Error

" 'sctp' 'chunk' 'init' ('init-tag'|'a-rwnd'|'num-outbound-streams'|'num-inbound-streams'|'initial-tsn')
" ('cum-tsn-ack'|'a-rwnd'|'num-gap-ack-block'|'num-dup-tsns')->sctp_chunk_alloc->sctp_hdr_expr
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_init_field nftHL_Define
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_init_field
\ '\v(num\-outbound\-streams|num\-inbound\-streams|initial\-tsn|init\-tag|a\-rwnd)\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_init nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_init '\vinit\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_length,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_init_field,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_flags,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_type,
\    nft_Error

" ******************** BEGIN set_block 'typeof sctp sack' *******************************
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_chunk_alloc_sctp_chunk_sack_field nftHL_Define
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_chunk_alloc_sctp_chunk_sack_field "\v(cum\-tsn\-ack|a\-rwnd|num\-gap\-ack\-blocks|num\-dup\-tsns)" skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_sack nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_sack '\vsack\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_chunk_alloc_sctp_chunk_sack_field,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_length,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_flags,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_type,
\    nft_Error
" ******************** BEGIN set_block 'typeof sctp sack' *******************************

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_hdr_field_keyword_vtag nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_hdr_field_keyword_vtag '\vvtag\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_hdr_field_keyword_dport nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_hdr_field_keyword_dport '\vdport\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_hdr_field_keyword_sport nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_hdr_field_keyword_sport '\vsport\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_asconf nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_asconf '\vasconf\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_length,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_flags,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_seqno,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_type

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_init_ack nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_init_ack '\vinit\-ack\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_length,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_init_field,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_flags,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_type,
\    nft_Error

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_hdr_field_keyword_checksum nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_hdr_field_keyword_checksum '\vchecksum\ze[ \t\n;]' skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

" ************* BEGIN 'sctp chunk shutdown cum-tsk-ack' ****************
" 'sctp' 'chunk' 'shutdown ('cum-tsn-ack'|'type'|'flags'|'length')
" 'cum-tsn-ack'->sctp_chunk_alloc->sctp_hdr_expr
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_chunk_alloc_keyword_cum_tsn_ack nftHL_Define
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_chunk_alloc_keyword_cum_tsn_ack "\vcum\-tsn\-ack" skipwhite contained
\ nextgroup=  nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_shutdown nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_shutdown '\vshutdown\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_chunk_alloc_keyword_cum_tsn_ack,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_length,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_flags,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_type,
\    nft_Error
" ************* END 'sctp chunk shutdown cum-tsk-ack' ****************

" ************* END 'sctp chunk asconf seqno' ****************
 hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_seqno  nftHL_Define
 syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_seqno  '\vseqno\ze[ \t\n;]' skipwhite contained
\ nextgroup= nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_asconf_ack nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_asconf_ack '\vasconf\-ack\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_length,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_flags,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_seqno,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_type

" ************* BEGIN 'sctp chunk asconf seqno' ****************

" ************* BEGIN 'sctp chunk forward-tsn' ****************
 hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_new_cum_tsn  nftHL_Define
 syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_new_cum_tsn  '\vnew\-cum\-tsn\ze[ \t\n;]' skipwhite contained
\ nextgroup= nft_set_block_typeof_key_expr_typeof_expr_symbol_dot, nft_set_block_typeof_key_expr_typeof_expr_symbol_colon

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_forward_tsn nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_forward_tsn '\vforward\-tsn\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_new_cum_tsn,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_length,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_flags,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_type
" ************* END 'sctp chunk forward-tsn' ****************

" ************* BEGIN 'sctp chunk heartbeat' ****************
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_type_keyword_heartbeat nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_type_keyword_heartbeat '\vheartbeat\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_length,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_flags,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_type
" ************* END 'sctp chunk heartbeat' ****************

" ************* BEGIN 'sctp chunk abort' ****************
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_type_keyword_abort nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_type_keyword_abort '\vabort\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_length,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_flags,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_type
" ************* END 'sctp chunk abort' ****************

" ************* BEGIN 'sctp chunk shutdown-ack' ****************
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_type_keyword_shutdown_ack nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_type_keyword_shutdown_ack '\vshutdown\-ack\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_length,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_flags,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_type
" ************* END 'sctp chunk shutdown-ack' ****************

" ************* BEGIN 'sctp chunk shutdown-complete' ****************
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_type_keyword_shutdown_complete nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_type_keyword_shutdown_complete '\vshutdown\-complete\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_length,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_flags,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_type
" ************* END 'sctp chunk shutdown-complete' ****************

" ************* BEGIN 'sctp chunk error' ****************
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_type_keyword_error nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_type_keyword_error '\verror\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_length,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_flags,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_common_field_keyword_type
" ************* END 'sctp chunk error' ****************


" ************* BEGIN 'sctp chunk' ****************
hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_keyword_chunk nftHL_Keyword
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_keyword_chunk '\vchunk\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_type_keyword_shutdown_complete,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_type_keyword_shutdown_ack,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_forward_tsn,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_type_keyword_heartbeat,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_init_ack,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_shutdown,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_asconf_ack,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_asconf,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_type_keyword_abort,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_sctp_chunk_type_keyword_error,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_ecne,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_init,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_data,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_sack,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_chunk_alloc_keyword_cwr,
" ************* END 'sctp chunk' ****************

hi link   nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_keyword_sctp nftHL_Substatement
syn match nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_keyword_sctp '\vsctp\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_hdr_field_keyword_checksum,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_keyword_chunk,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_hdr_field_keyword_dport,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_hdr_field_keyword_sport,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_sctp_hdr_field_keyword_vtag,
\    nft_Error
" ******************** END set_block 'typeof sctp' *******************************

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr 'typeof'
hi link   nft_set_block_typeof_key_expr_keyword_typeof nftHL_Command
syn match nft_set_block_typeof_key_expr_keyword_typeof '\vtypeof\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp6_hdr_expr_keyword_icmpv6,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_icmp_hdr_expr_keyword_icmp,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_oifname,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_iifname,
\    nft_meta_expr_meta_key_meta_key_unqualified_keyword_ipsec,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vxlan_hdr_expr_keyword_vxlan,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_exthdr_expr_frag_hdr_expr_keyword_frag,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_qualified_keyword_mark,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_meta_expr_keyword_meta,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_sctp_hdr_expr_keyword_sctp,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_vlan_expr_keyword_vlan,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_payload_raw_expr_payload_base_spec_string_keyword_at_ih,
\    nft_set_block_family_netdev_typeof_key_expr_typeof_expr_primary_expr_payload_expr_eth_hdr_expr_keyword_eth,
\    nft_set_block_family_ip6_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip6_hdr_expr_keyword_ip6,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_iif,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_meta_expr_meta_key_unqualified_keyword_oif,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_osf_expr_keyword_osf,
\    nft_set_block_family_inet_typeof_key_expr_typeof_expr_primary_expr_payload_expr_tcp_hdr_expr_keyword_tcp,
\    nft_set_block_family_inet_typeof_key_expr_typeof_expr_primary_expr_payload_expr_udp_hdr_expr_keyword_udp,
\    nft_set_block_typeof_key_expr_typeof_expr_primary_expr_ct_expr_keyword_ct,
\    nft_set_block_family_ip_typeof_key_expr_typeof_expr_primary_expr_payload_expr_ip_hdr_expr_keyword_ip,
\    nft_Error
" ******************** BEGIN 'typeof' ********************************

  for s:this_semantic_file in s:template_name_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded template_name for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define template_name.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_template_name = v:true
