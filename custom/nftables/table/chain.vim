" File: chain.vim
" Directory: custom/nftables/table/
" Description:
"   Declarative 'chain' (not imperative 'add chain')
let s:list_filepaths_semantic_early = [
\    'table/chain/stmt.vim',
\    ]
let s:list_filepaths_semantic_later = []

if exists('b:did_nftables_chain')
  call nftables#syntax#log('INFO', 'Skipped chain (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading chain syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "


" add_cmd 'table' table_block 'chain' chain_block flags_spec ';'
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_flags_spec_separator nftHL_BlockDelimitersChain
syn match nft_add_cmd_keyword_table_table_block_chain_chain_flags_spec_separator /;/ skipwhite contained

" TODO: 'offload' is only valid with chain hook 'ingress' and 'netdev' family
" add_cmd 'table' table_block 'chain' chain_block flags_spec 'offload'
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_flags_spec_keyword_offload nftHL_Define
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_flags_spec_keyword_offload '\voffload\ze[ \t\n;\}]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_flags_spec_separator,
\    nft_Error

" add_cmd 'table' table_block 'chain' chain_block flags_spec 'flags'
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_flags_spec_keyword_flags nftHL_Statement
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_flags_spec_keyword_flags "\vflags\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_flags_spec_keyword_offload,
\    nft_Error
" TODO: Add negatation of 'tcp' in 'tcp flags' or add to nextgroup=BUT in chain_block



" **** BEGIN 'add chain' command **** BEGIN 'chain' command ****
hi link    nft_add_cmd_keyword_chain_chain_block_delimiters nftHL_BlockDelimitersChain
syn region nft_add_cmd_keyword_chain_chain_block_delimiters start='\v\s*\zs\{' end='\v\}' skip="#.{0,45}$" keepend skipwhite skipempty contained
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
\    nft_stmt_counter_stmt_keyword_counter,
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
\    nft_stmt_set_stmt_set_stmt_op_keyword_delete,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_policy_spec_keyword_policy,
\    nft_verdict_expr_keyword_return,
\    nft_stmt_set_stmt_set_stmt_op_keyword_update,
\    nft_common_block_keyword_error,
\    nft_stmt_keyword_ether,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_flags_spec_keyword_flags,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_ipsec,
\    nft_add_cmd_table_block_set_block_stateful_stmt_list_stmt_stateful_stmt_limit_stmt_keyword_limit,
\    nft_add_cmd_rule_rule_alloc_stmt_meter_stmt_meter_stmt_alloc_keyword_meter,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_skgid,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_skuid,
\    nft_stmt_nat_stmt_nat_stmt_alloc_keyword_dnat,
\    nft_verdict_expr_keyword_drop,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_flow,
\    nft_verdict_expr_keyword_goto,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_hour,
\    nft_keyword_expr_keyword_icmp,
\    nft_chain_stmt_verdict_expr_keyword_jump,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_mark,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_meta,
\    nft_stmt_nat_stmt_nat_stmt_alloc_keyword_snat,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_time,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_keyword_type,
\    nft_keyword_expr_keyword_vlan,
\    nft_keyword_expr_keyword_arp,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_cpu,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_day,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iif,
\    nft_stmt_log_stmt_log_stmt_alloc_keyword_log,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oif,
\    nft_keyword_expr_keyword_ip,
\    nft_comment_inline,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_stmt_separator,
\    nft_rule_cluster_Error

hi link   nft_add_cmd_chain_spec_identifier nftHL_Identifier
syn match nft_add_cmd_chain_spec_identifier '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_chain_chain_block_delimiters,
\    nft_EOS,
\    nft_UnexpectedSemicolon,
\    nfft_Error

hi link   nft_add_cmd_chain_spec_table_spec_identifier nftHL_Identifier
syn match nft_add_cmd_chain_spec_table_spec_identifier '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_chain_spec_identifier,
\    nft_UnexpectedVariableName,
\    nft_UnexpectedNonIdentifier,
\    nft_UnexpectedAtSymbol,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedNewLine,
\    nft_UnexpectedSymbol,
\    nft_UnexpectedSemicolon,
\    nft_Error

hi link   nft_add_cmd_chain_spec_table_spec_family_spec_family_spec_explicit nftHL_Family
syn match nft_add_cmd_chain_spec_table_spec_family_spec_family_spec_explicit '\v(bridge|netdev|inet|arp|ip6|ip)' skipwhite contained
\ nextgroup=
\    nft_add_cmd_chain_spec_table_spec_identifier,
\    nft_UnexpectedVariableName,
\    nft_UnexpectedNonIdentifier,
\    nft_UnexpectedAtSymbol,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedNewLine,
\    nft_UnexpectedSymbol,
\    nft_UnexpectedSemicolon,
\    nft_Error

" 'chain'->add_cmd->'add'->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_chain_declarative nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_chain_declarative "\vchain\ze\s" skipwhite contained
\ nextgroup=
\    nft_add_cmd_chain_spec_table_spec_family_spec_family_spec_explicit,
\    nft_add_cmd_chain_spec_table_spec_identifier,
\    nft_UnexpectedVariableName,
\    nft_UnexpectedNonIdentifier,
\    nft_UnexpectedAtSymbol,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedNewLine,
\    nft_UnexpectedSymbol,
\    nft_UnexpectedSemicolon,
\    nft_Error
" **** END 'add chain' command **** END 'chain' command ****

  for s:this_semantic_file in s:list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded chain for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define chain.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry

" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_chain = v:true
