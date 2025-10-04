" File: table_block_chain.vim
" Directory: custom/nftables/table/table_block/
"
let s:table_block_chain_list_filepaths_semantic_early = []
let s:table_block_chain_list_filepaths_semantic_later = []

if exists('b:did_nftables_table_block_chain')
  call nftables#syntax#log('INFO', 'Skipped table_block_chain (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:table_block_chain_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading table_block_chain syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
  " common_block is contains=lastly due to 'comment' in chain_block & chain_block/rule
" 'table' identifier '{' 'chain' identifier '{' chain_block
" chain_block->'chain'->table_block->'table'->add_cmd->base_cmd->line
" chain_block->'chain'->table_block->'table'->add_cmd->'add'->base_cmd->line
hi link    nft_add_cmd_keyword_table_table_block_chain_chain_block_delimiters nftHL_BlockDelimitersChain
"syn region nft_add_cmd_keyword_table_table_block_chain_chain_block_delimiters start='\v\{' end=+}+ keepend skipwhite contained
"syn region nft_add_cmd_keyword_table_table_block_chain_chain_block_delimiters start='\v\s*\zs\{' end='\v\}' skipwhite skipempty
syn region nft_add_cmd_keyword_table_table_block_chain_chain_block_delimiters start='\v\s*\zs\{' end='\v\}' skipwhite skipempty contained
\ nextgroup=
\    nft_table_block_stmt_separator,
\    nft_comment_inline
\ contains=
\    nft_add_cmd_rule_rule_alloc_stmt_masq_keyword_masquerade,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_rtclassid,
\    nft_verdict_expr_keyword_continue,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ibriport,
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iifgroup,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_obriport,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oifgroup,
\    nft_common_block_keyword_include,
\    nft_add_cmd_rule_rule_alloc_stmt_redir_stmt_redir_stmt_alloc_keyword_redirect,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec,
\    nft_stmt_keyword_counter,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_keyword_devices,
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
\    nft_common_block_keyword_define,
\    nft_payload_expr_icmpv6_hdr_expr_keyword_icmpv6,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_policy_spec_keyword_policy,
\    nft_stmt_reject_stmt_reject_stmt_alloc_keyword_reject,
\    nft_verdict_expr_keyword_return,
\    nft_stmt_set_stmt_set_stmt_op_keyword_update,
\    nft_common_block_keyword_error,
\    nft_keyword_expr_keyword_ether,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_flags_spec_keyword_flags,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_ipsec,
\    nft_stmt_keyword_limit,
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
\    nft_payload_expr_icmp_hdr_expr_keyword_icmp,
\    nft_chain_stmt_verdict_expr_keyword_jump,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_mark,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_meta,
\    nft_payload_expr_sctp_hdr_expr_keyword_sctp,
\    nft_stmt_nat_stmt_nat_stmt_alloc_keyword_snat,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_time,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_keyword_type,
\    nft_keyword_expr_keyword_vlan,
\    nft_payload_raw_expr_payload_base_spec_keyword_at_ih,
\    nft_payload_raw_expr_payload_base_spec_keyword_at_ll,
\    nft_payload_raw_expr_payload_base_spec_keyword_at_nh,
\    nft_payload_raw_expr_payload_base_spec_keyword_at_th,
\    nft_keyword_expr_keyword_ether,
\    nft_stmt_set_stmt_set_stmt_op_keyword_add,
\    nft_keyword_expr_keyword_arp,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_cpu,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_day,
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iif,
\    nft_stmt_log_stmt_log_stmt_alloc_keyword_log,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oif,
\    nft_payload_expr_esp_hdr_expr_keyword_esp,
\    nft_stmt_keyword_ip6,
\    nft_payload_expr_tcp_hdr_expr_keyword_tcp,
\    nft_payload_stmt_payload_expr_udp_hdr_expr_keyword_udp,
\    nft_payload_expr_ah_hdr_expr_keyword_ah,
\    nft_payload_expr_th_hdr_expr_keyword_th,
\    nft_stmt_keyword_ct,
\    nft_stmt_keyword_ip,
\    nft_payload_raw_expr_payload_base_spec_keyword_th,
\    nft_payload_raw_expr_payload_base_spec_keyword_at_string,
\    nft_stmt_concat_primary_expr_base_spec_keyword_at_string,
\    nft_comment_inline,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_stmt_separator,
"\    nextgroup=nft_hash_comment

"\ contains=
"\ nextgroup=
"\    nft_add_cmd_keyword_table_table_block_chain_flags_spec,
"\    nft_add_cmd_keyword_table_table_block_chain_rule_spec,
"\    nft_add_cmd_keyword_table_table_block_chain_device_keyword
" \ contains=ALLBUT,
" \    nft_add_table_options_flag_keyword,
" \    nft_add_table_options_comment_spec,
" \    nft_add_cmd_table_block_keyword_chain

"**** BEGIN 'table T { chain' ******************
" 'table' 'T' '{' 'chain' 'C' '{' ';'
" ';'->stmt_separator->chain_block->'chain'->table_block->'table'->add_cmd->base_cmd
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_stmt_separator nftHL_Separator
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_stmt_separator contained /\v\s{0,8}[\n;]{1,15}/  skipwhite contained

" add_cmd 'table' table_block 'chain' chain_spec table_id chain_id
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_unquoted nftHL_Chain
syn match nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_unquoted "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_delimiters

" add_cmd 'table' table_block 'chain' chain_spec table_id chain_id
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_sans_double_quote nftHL_Chain
syn match nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_sans_double_quote "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" keepend skipwhite contained

" add_cmd 'table' table_block 'chain' chain_spec table_id chain_id
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_sans_single_quote nftHL_Chain
syn match nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_sans_single_quote "\v[a-zA_Z][a-zA-Z0-9_\-]{0,63}" keepend skipwhite contained

" add_cmd 'table' table_block 'chain' chain_spec table_id chain_id
hi link    nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_single nftHL_Chain
syn region nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_single start="'" skip="\\\'" end="'" keepend skipwhite oneline contained
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_sans_single_quote
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_delimiters

" add_cmd 'table' table_block 'chain' <DOUBLE_STRING>
hi link    nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_double nftHL_Chain
syn region nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_double start="\"" skip="\\\"" end="\"" keepend skipwhite oneline contained
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_sans_double_quote
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_delimiters

" add_cmd 'table' table_block 'chain' 'last'
hi link  nft_add_cmd_keyword_table_table_block_chain_chain_identifier_last nftHL_Keyword
syn match nft_add_cmd_keyword_table_table_block_chain_chain_identifier_last "last" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_delimiters

" add_cmd 'table' table_block 'chain'
hi link   nft_add_cmd_table_block_keyword_chain nftHL_Command
syn match nft_add_cmd_table_block_keyword_chain "chain" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_single,
\    nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_double,
\    nft_add_cmd_keyword_table_table_block_chain_chain_identifier_last,
\    nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_unquoted
"**** END OF table <identifier> { chain
"**** END 'table T { chain' ******************



  for s:this_semantic_file in s:table_block_chain_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded table_block_chain for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define table_block_chain.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_table_block_chain = v:true

