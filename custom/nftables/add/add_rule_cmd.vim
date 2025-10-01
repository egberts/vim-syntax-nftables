" File: add_rule_cmd.vim
" Directory: custom/nftables/add/
"
let s:add_rule_cmd_list_filepaths_semantic_early = []
let s:add_rule_cmd_list_filepaths_semantic_later = []

if exists('b:did_nftables_add_rule_cmd')
  call nftables#syntax#log('INFO', 'Skipped add_rule_cmd (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:add_rule_cmd_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading add_rule_cmd syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
" ***************** BEGIN 'add' 'rule' ***************
syn cluster nft_c_base_cmd_add_cmd_rule_alloc_stmt_cluster
\ contains=
\    nft_add_cmd_rule_rule_alloc_stmt_masq_keyword_masquerade,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_rtclassid,
\    nft_verdict_expr_keyword_continue,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ibriport,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iifgroup,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_obriport,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oifgroup,
\    nft_add_cmd_rule_rule_alloc_stmt_redir_stmt_redir_stmt_alloc_keyword_redirect,
\    nft_add_cmd_rule_rule_alloc_stmt_synproxy_stmt_keyword_synproxy,
\    nft_stmt_keyword_counter,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ibrname,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iifname,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iiftype,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_notrack,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_obrname,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oifname,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oiftype,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_pkttype,
\    nft_verdict_expr_keyword_accept,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_cgroup,
\    nft_chain_block_primary_expr_numgen_expr_keyword_numgen,
\    nft_verdict_expr_keyword_return,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_ipsec,
\    nft_add_cmd_rule_rule_alloc_stmt_meter_stmt_meter_stmt_alloc_keyword_meter,
\    nft_stmt_keyword_quota,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_skgid,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_skuid,
\    nft_payload_expr_dccp_hdr_expr_keyword_dccp,
\    nft_stmt_nat_stmt_nat_stmt_alloc_keyword_dnat,
\    nft_verdict_expr_keyword_drop,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_flow,
\    nft_verdict_expr_keyword_goto,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_hour,
\    nft_chain_stmt_verdict_expr_keyword_jump,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_mark,
\    nft_stmt_nat_stmt_nat_stmt_alloc_keyword_snat,
\    nft_payload_expr_sctp_hdr_expr_keyword_sctp,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_time,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_cpu,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_day,
\    nft_payload_expr_esp_hdr_expr_keyword_esp,
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iif,
\    nft_stmt_log_stmt_log_stmt_alloc_keyword_log,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oif,
\    nft_payload_expr_tcp_hdr_expr_keyword_tcp,
\    nft_payload_expr_udp_hdr_expr_keyword_udp,
\    nft_payload_expr_ah_hdr_expr_keyword_ah,
\    nft_objref_stmt_objref_stmt_ct_keyword_ct,
\    nft_payload_expr_th_hdr_expr_keyword_th,
\    nft_rule_cluster_Error
"\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_meta,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_hash_expr_keyword_symhash,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_udplite,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_exthdr_exists_expr_keyword_exthdr,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_geneve,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_gretap,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_socket_expr_keyword_socket,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_ether,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_hash_expr_keyword_jhash,
"\    nft_add_cmd_rule_rule_alloc_stmt_meter_stmt_meter_stmt_alloc_keyword_meter,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_vxlan,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_auth,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_comp,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_dccp,
"\    nft_add_cmd_rule_rule_alloc_stmt_nat_stmt_keyword_dnat,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_exthdr_expr_frag_hdr_expr_keyword_frag,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_icmp,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_igmp,
"\    nft_add_cmd_rule_rule_alloc_stmt_nat_stmt_keyword_snat,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_sctp,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_vlan,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_arp,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_exthdr_expr_dst_hdr_expr_keyword_dst,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_esp,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_gre,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_exthdr_expr_hbh_hdr_expr_keyword_hbh,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_ip6,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_osf_expr_keyword_osf,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_exthdr_expr_rt0_hdr_expr_keyword_rt0,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_exthdr_expr_rt2_hdr_expr_keyword_rt2,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_exthdr_expr_rt4_hdr_expr_keyword_rt4,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_tcp,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_udp,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_payload_raw_expr_keyword_at,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_ip,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_exthdr_expr_mh_hdr_expr_keyword_mh,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_exthdr_expr_rt_hdr_expr_keyword_rt,
"\    nft_payload_expr_th_hdr_expr_keyword_th,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_block,  \" '{'  basic_expr '}'
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_integer_expr,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_symbol_expr_variable_expr,  \" $var_name
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_symbol_expr_string,         \" usually quoted, some pre-defined identifier/keywords



  " Define rule-start keywords by length
let s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_9char = join([
\   'masquerade', 'rtclassid',
\ ], '\|')

let s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_8char = join([
\   'continue', 'ibriport', 'iffgroup', 'obriport', 'redirect', 'synproxy',
\ ], '\|')

let s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_7char = join([
\   'counter', 'ibrname', 'iifname', 'iiftype', 'nftrace',
\   'notrack', 'obranme', 'oifname', 'oiftype', 'pkttype', 'udplite',
\ ], '\|')

let s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_6char = join([
\   'accept', 'cgroup', 'delete', 'geneve', 'gretap',
\   'reject', 'return', 'tproxy', 'update',
\ ], '\|')

let s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_5char = join([
\   'ether', 'icmpv6', 'limit', 'meter', 'queue',
\   'quota', 'reset', 'skgid', 'skuid', 'vxlan',
\ ], '\|')

let s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_4char = join([
\   'auth', 'comp', 'dccp', 'dnat', 'drop',
\   'flow', 'goto', 'icmp', 'igmp', 'jump', 'last',
\   'meta', 'mark', 'snat',
\ ], '\|')

let s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_3char = join([
\   'add', 'arp', 'cpu', 'day', 'dup',
\   'esp', 'fwd', 'gre', 'iif', 'ip6', 'log',
\   'oif', 'set', 'tcp', 'udp',
\ ], '\|')

let s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_2char = join([
\   'at', 'ct', 'ip', 'th', 'xt',
\ ], '\|')

" ⚠️ DOUBLE ESCAPE for literal * and (
let s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_1char = join([
\   '\\*', '\\(',
\ ], '\|')

let s:rule_alloc_start_regex =
\ '^\s*\%('
\ . s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_9char . '\|'
\ . s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_8char . '\|'
\ . s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_7char . '\|'
\ . s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_6char . '\|'
\ . s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_5char . '\|'
\ . s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_4char . '\|'
\ . s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_3char . '\|'
\ . s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_2char . '\|'
\ . s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_1char . '\|'
\ . '\h\w*' . '\\\)'

" ************* BEGIN rule_alloc stmt *******************************
"echom s:rule_alloc_start_regex
" ^\s*\%(masquerade\|rtclassid\|continue\|ibriport\|iifgroup\|obriport\|redirect\|synproxy\|counter\|ibrname\|iifname\|iiftype\|nftrace\|notrack\|obrname\|oifname\|oiftype\|pkttype\|udplite\|accept\|cgroup\|delete\|geneve\|gretap\|reject\|return\|tproxy\|update\|icmpv6\|ether\|limit\|meter\|queue\|quota\|reset\|skgid\|skuid\|vxlan\|auth\|comp\|dccp\|dnat\|drop\|flow\|goto\|icmp\|igmp\|jump\|last\|meta\|mark\|snat\|add\|arp\|cpu\|day\|dup\|esp\|fwd\|gre\|iif\|ip6\|log\|oif\|set\|tcp\|udp\|at\|ct\|ip\|th\|xt\|\\*\|\\(\|\h\w*\\\)

execute 'syntax region nft_add_cmd_rule_rule_alloc_stmt start=' . "'" . s:rule_alloc_start_regex . "'"
      \ . " end=';' contains=@nft_c_base_cmd_add_cmd_rule_alloc_stmt_cluster keepend contained"

" redefine nft_add_cmd_rule_rule_alloc_stmt"
hi link    nft_add_cmd_rule_rule_alloc_stmt nftHL_Statement
syn region nft_add_cmd_rule_rule_alloc_stmt end=/\ze;/ keepend contained
\ start='\v(masquerade|rtclassid|continue|ibriport|iifgroup|obriport|oifgroup|redirect|synproxy|counter|ibrname|iifname|iiftype|nftrace|notrack|obrname|oifname|oiftype|pkttype|udplite|accept|cgroup|delete|geneve|gretap|reject|return|tproxy|update|icmpv6|ether|ipsec|limit|meter|queue|quota|reset|skgid|skuid|vxlan|auth|comp|dccp|dnat|drop|flow|goto|hour|icmp|igmp|jump|last|mark|meta|snat|time|add|arp|cpu|day|dup|esp|fwd|gre|iif|ip6|log|not|oif|set|tcp|udp|at|ct|ip|th|xt)\ze(([ \t;])|($))'
\ contains=
\    @nft_c_base_cmd_add_cmd_rule_alloc_stmt_cluster
\ nextgroup=
\    nft_stmt_separator,
\    nft_Error
" ************* END rule_alloc stmt *********************

" ************* BEGIN rule_position *********************
hi link   nft_add_cmd_rule_position_num nftHL_Number
syn match nft_add_cmd_rule_position_num /\v[0-9]{1,10}/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt,
\    nft_Error

hi link   nft_add_cmd_rule_position_position_spec_keyword_position nftHL_Keyword
syn match nft_add_cmd_rule_position_position_spec_keyword_position /\vposition\ze[ \t]/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_position_num,
\    nft_Error

hi link   nft_add_cmd_rule_position_handle_spec_keyword_handle nftHL_Keyword
syn match nft_add_cmd_rule_position_handle_spec_keyword_handle /handle\ze[ \t]/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_position_num,
\    nft_Error

hi link   nft_add_cmd_rule_position_index_spec_keyword_index nftHL_Keyword
syn match nft_add_cmd_rule_position_index_spec_keyword_index /\vindex\ze[ \t]/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_position_num,
\    nft_Error
" ************* END rule_position *********************


" THE vector point to over 73 lexical tokens/keywords, this nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier_declarative
hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_identifier nftHL_Table
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_identifier '\v\s\zs[a-zA-Z][a-zA-Z0-9_\.-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt,
\    nft_add_cmd_rule_position_position_spec_keyword_position,
\    nft_add_cmd_rule_position_handle_spec_keyword_handle,
\    nft_add_cmd_rule_position_index_spec_keyword_index,
\    nft_line_nonidentifier_error
" TODO: We need a split-out of super-cluster nft_add_cmd_rule_rule_alloc_stmt to interperse position_spec's keywords

hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip nftHL_Family
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip "\vip\ze " skipwhite contained
\ nextgroup=
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier_declarative

hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_arp nftHL_Family
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_arp "arp" skipwhite contained
\ nextgroup=
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier_declarative

hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip6 nftHL_Family
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip6 "ip6" skipwhite contained
\ nextgroup=
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier_declarative

hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_inet nftHL_Family
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_inet "inet" skipwhite contained
\ nextgroup=
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier_declarative

hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_netdev nftHL_Family
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_netdev "netdev" skipwhite contained
\ nextgroup=
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier_declarative

hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_bridge nftHL_Family
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_bridge "bridge" skipwhite contained
\ nextgroup=
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier_declarative

syn cluster nft_c_add_cmd_rule_rule_alloc_again
\ contains=@nft_c_add_cmd_rule_rule_alloc_alloc

" base_cmd [ 'add' ] 'rule' rule_alloc comment_spec
hi link   nft_add_cmd_rule_comment_spec_string nftHL_Comment
syn match nft_add_cmd_rule_comment_spec_string "\v[A-Za-z0-9 ]{1,64}" skipwhite contained
" TODO A BUG? What is a 'space' doing in comment?"

hi link   nft_add_cmd_rule_comment_spec_keyword_comment nftHL_Comment
syn match nft_add_cmd_rule_comment_spec_keyword_comment "\vcomment\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_comment_spec_string

" base_cmd [ 'add' ] 'rule' rule
syn cluster nft_c_add_cmd_rule_rule_alloc
\ contains=
\    nft_add_cmd_rule_comment_spec_keyword_comment,
\    @nft_c_stmt

" base_cmd [ 'add' ] 'rule' rule
syn cluster nft_c_add_cmd_rule_rule
\ contains=
\    @nft_c_add_cmd_rule_rule_alloc



" IMPERATIVE 'nft> add rule ...'
" 'rule'->add_cmd->'add'->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_rule nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_rule "\vrule\ze[ \t]" skipnl skipwhite contained
\ nextgroup=
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_bridge,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_netdev,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_inet,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip6,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_arp,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier_declarative,
\    nft_Error

syn cluster nft_c_rule_alloc
\ contains=
\    @nft_c_stmt

syn cluster nft_c_rule
\ contains=
\    @nft_c_rule_alloc
"***************** END rule/'add_cmd'/'base_cmd' *****************


  for s:this_semantic_file in s:add_rule_cmd_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded add_rule_cmd for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define add_rule_cmd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_add_rule_cmd = v:true
