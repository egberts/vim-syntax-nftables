" File: add_ct_cmd.vim
" Directory: custom/nftables/
"
let s:add_ct_cmd_list_filepaths_semantic_early = []
let s:add_ct_cmd_list_filepaths_semantic_later = []

if exists('b:did_nftables_add_ct_cmd')
  call nftables#syntax#log('INFO', 'Skipped add_ct_cmd (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:add_ct_cmd_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading add_ct_cmd syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

" **************** BEGIN add_ct_cmd **************************************
hi link   nft_add_cmd_keyword_ct_keyword_expectation_obj_spec_identifier nftHL_Table
syn match nft_add_cmd_keyword_ct_keyword_expectation_obj_spec_identifier "\v[A-Za-z][A-Za-z0-9_\-]{0,63}" skipwhite contained

hi link   nft_add_cmd_keyword_ct_keyword_expectation_obj_spec_table_spec_identifier_table nftHL_Table
syn match nft_add_cmd_keyword_ct_keyword_expectation_obj_spec_table_spec_identifier_table "\v[A-Za-z][A-Za-z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_ct_keyword_expectation_obj_spec_identifier

" base_cmd 'ct' 'expectation' obj_spec table_spec
hi link   nft_base_cmd_add_ct_expectation_obj_spec_table_spec nftHL_Command
syn match nft_base_cmd_add_ct_expectation_obj_spec_table_spec "\v(ip[6]|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_ct_keyword_expectation_obj_spec_table_spec_identifier_table

" base_cmd 'ct' 'expectation' obj_spec
syn cluster nft_c_base_cmd_add_ct_expectation_obj_spec
\ contains=
\    nft_base_cmd_add_ct_expectation_obj_spec_table_spec,
\    nft_add_cmd_keyword_ct_keyword_expectation_obj_spec_table_spec_identifier_table

" base_cmd [ 'ct' ] ('helper'|'timeout'|'expectation')
hi link   nft_base_cmd_add_ct_keyword_expectation nftHL_Command
syn match nft_base_cmd_add_ct_keyword_expectation "expectation" skipwhite contained
\ nextgroup=
\    @nft_c_base_cmd_add_ct_expectation_obj_spec

hi link    nft_add_cmd_keyword_ct_keyword_timeout_ct_timeout_block nftHL_BlockDelimitersCT
syn region nft_add_cmd_keyword_ct_keyword_timeout_ct_timeout_block start="{" end="}" skip="\\[\{\}]"  skipwhite contained
\ contains=
\    @nft_c_ct_timeout_config

hi link   nft_add_cmd_keyword_ct_keyword_timeout_obj_spec_identifier nftHL_Chain
syn match nft_add_cmd_keyword_ct_keyword_timeout_obj_spec_identifier "\v[A-Za-z][A-Za-z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_ct_keyword_timeout_ct_timeout_block

hi link   nft_add_cmd_keyword_ct_keyword_timeout_obj_spec_table_spec_identifier_table nftHL_Table
syn match nft_add_cmd_keyword_ct_keyword_timeout_obj_spec_table_spec_identifier_table "\v[A-Za-z][A-Za-z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_ct_keyword_timeout_obj_spec_identifier

" base_cmd 'ct' 'timeout' obj_spec table_spec
hi link   nft_base_cmd_add_ct_timeout_obj_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_base_cmd_add_ct_timeout_obj_spec_table_spec_family_spec_explicit "\v(bridge|netdev|inet|arp|ip6|ip)" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_ct_keyword_timeout_obj_spec_table_spec_identifier_table

" base_cmd 'ct' 'timeout' obj_spec
syn cluster nft_c_base_cmd_add_ct_timeout_obj_spec
\ contains=
\    nft_base_cmd_add_ct_timeout_obj_spec_table_spec_family_spec_explicit,
\    nft_add_cmd_keyword_ct_keyword_timeout_obj_spec_table_spec_identifier_table
" TODO: missing table_spec

" base_cmd [ 'ct' ] ('helper'|'timeout'|'expectation')
" base_cmd 'ct' 'timeout' obj_spec table_spec
hi link   nft_base_cmd_add_ct_keyword_timeout nftHL_Command
syn match nft_base_cmd_add_ct_keyword_timeout "timeout" skipwhite contained
\ nextgroup=
\    @nft_c_base_cmd_add_ct_timeout_obj_spec

hi link    nft_add_cmd_ct_helper_block nftHL_BlockDelimitersCT
syn region nft_add_cmd_ct_helper_block start="{" end="}" skip="\\}" skipwhite contained
\ contains=
\    @nft_c_ct_helper_config,
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_comment_spec,
\    nft_stmt_separator,

hi link   nft_add_cmd_keyword_ct_keyword_helper_obj_spec_identifier nftHL_Chain
syn match nft_add_cmd_keyword_ct_keyword_helper_obj_spec_identifier "\v[A-Za-z][A-Za-z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_ct_helper_block

hi link   nft_add_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_table nftHL_Table
syn match nft_add_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_table "\v[A-Za-z][A-Za-z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_ct_keyword_helper_obj_spec_identifier

" base_cmd 'ct' 'helper' obj_spec table_spec
" family_spec->table_spec->obj_spec->'helper'->add_cmd->base_cmd->line
hi link   nft_base_cmd_add_ct_helper_obj_spec_table_spec_family_spec nftHL_Family
syn match nft_base_cmd_add_ct_helper_obj_spec_table_spec_family_spec "\v(ip6|ip|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_table

" base_cmd [ 'ct' ] ('helper'|'timeout'|'expectation')
hi link   nft_base_cmd_add_ct_keyword_helper nftHL_Command
syn match nft_base_cmd_add_ct_keyword_helper "helper" skipwhite contained
\ nextgroup=
\    nft_base_cmd_add_ct_helper_obj_spec_table_spec_family_spec,
\    nft_setname,
\    nft_add_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_table
" TODO nft_setname

" nft_stmt_ct_common_ct_key_keyword_helper
" **************** END of ct_expr *******************
syn cluster nft_c_cmd_add_ct_keywords
\ contains=
\    nft_base_cmd_add_ct_keyword_expectation,
\    nft_base_cmd_add_ct_keyword_timeout,
\    nft_base_cmd_add_ct_keyword_helper,
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_connlimit_stmt_keyword_count,

" **************** BEGIN ct_expr *************************************
hi link   nft_direction_types nftHL_Define
syn match nft_direction_types '\v(original|reply)' skipwhite contained

hi link   nft_conntrack_types nftHL_Define
syn match nft_conntrack_types '\v(h323|pptp|tftp|ftp|irc|sip)' skipwhite contained
\ nextgroup=
\    nft_ct_common_conntrack_types,
\    nft_Error

hi link   nft_stmt_objref_stmt_objref_stmt_ct_keyword_expiration nftHL_Substatement
syn match nft_stmt_objref_stmt_objref_stmt_ct_keyword_expiration '\vexpiration' skipwhite contained
\ nextgroup=
\    nft_ct_common_conntrack_types,
\    nft_Error

hi link   nft_stmt_ct_common_ct_key_keyword_direction nftHL_Substatement
syn match nft_stmt_ct_common_ct_key_keyword_direction '\vdirection' skipwhite contained
\ nextgroup=
\    nft_direction_types,
\    nft_Error

hi link   nft_close_scope_ct_primary_expr_constant_expr_int_hex_16b nftHL_Integer
syn match nft_close_scope_ct_primary_expr_constant_expr_int_hex_16b '\v((0[xX][0-9a-fA-F]{1,2})|([0-9]{1,5}))' skipwhite contained

hi link   nft_stmt_ct_common_ct_key_keyword_proto_src nftHL_Substatement
syn match nft_stmt_ct_common_ct_key_keyword_proto_src '\vproto\-src' skipwhite contained
\ nextgroup=
\    nft_stmt_ct_stmt_keyword_set,
\    nft_close_scope_ct_primary_expr_constant_expr_int_hex_16b

hi link   nft_stmt_ct_common_ct_key_keyword_proto_dst nftHL_Substatement
syn match nft_stmt_ct_common_ct_key_keyword_proto_dst '\vproto\-dst' skipwhite contained
\ nextgroup=
\    nft_stmt_ct_stmt_keyword_set,
\    nft_close_scope_ct_primary_expr_constant_expr_int_hex_16b

"\    ct 'protocol' - anything in /etc/services
" ct protocol set

hi link   nft_l4_protocol Define
syn match nft_l4_protocol '\v(([0-9]{1,3})|(mobility\-header|mpls\-in\-ip|ipv6\-route|idpr\-cmtp|ipv6\-frag|ipv6\-icmp|ipv6\-nonxt|ipv6\-opts|ethernet|ipencap|iso\-tp4|udplite|xns\-idp|hopopt|ipcomp|ax\.25|eigrp|encap|manet|mptcp|shim6|dccp|icmp|idrp|igmp|ipv6|isis|l2tp|ospf|rohc|rspf|rsvp|sctp|skip|vrrp|vmtp|wesp|ddp|egp|esp|gre|hip|hmp|igp|ggp|pim|pup|rdp|tcp|udp|xtp|ah|fc|ip))\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_stmt_separator

hi link   nft_primary_expr_ct_expr_keyword_set nftHL_Write
syn match nft_primary_expr_ct_expr_keyword_set '\vset' skipwhite contained
\ nextgroup=
\    nft_l4_protocol

hi link   nft_stmt_ct_common_ct_key_keyword_protocol nftHL_Substatement
syn match nft_stmt_ct_common_ct_key_keyword_protocol '\vprotocol' skipwhite contained
\ nextgroup=
\    nft_primary_expr_ct_expr_keyword_set,
\    @nft_c_stmt_expr

hi link   nft_stmt_ct_common_ct_key_keyword_packets nftHL_Substatement
syn match nft_stmt_ct_common_ct_key_keyword_packets '\vpackets' skipwhite contained

"\    ct 'l3proto' - `family_spec`
hi link   nft_stmt_ct_common_ct_key_keyword_l3proto nftHL_Substatement
syn match nft_stmt_ct_common_ct_key_keyword_l3proto '\vl3proto' skipwhite contained
\ nextgroup=
\    nft_conntrack_types

hi link   nft_stmt_ct_common_ct_key_keyword_secmark nftHL_Substatement
syn match nft_stmt_ct_common_ct_key_keyword_secmark '\vsecmark' skipwhite contained

hi link   nft_stmt_ct_common_ct_key_keyword_avgpkt nftHL_Substatement
syn match nft_stmt_ct_common_ct_key_keyword_avgpkt '\vavgpkt' skipwhite contained

"\    ct 'helper' - ftp sip h323 irc pptp tftp
hi link   nft_ct_stmt_verdict_stmt_verdict_map_stmt_set_ref_expr_set_ref_symbol_expr_keyword_at_identifier nftHL_AtSetname
syn match nft_ct_stmt_verdict_stmt_verdict_map_stmt_set_ref_expr_set_ref_symbol_expr_keyword_at_identifier '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_stmt_ct_common_ct_key_keyword_helper nftHL_Substatement
syn match nft_stmt_ct_common_ct_key_keyword_helper '\vhelper\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ct_common_conntrack_types,
\    nft_stmt_objref_stmt_objref_stmt_ct_keyword_set,
\    nft_ct_stmt_verdict_stmt_verdict_map_stmt_set_ref_expr_set_ref_symbol_expr_keyword_at_identifier

hi link   nft_stmt_ct_common_ct_key_keyword_status nftHL_Substatement
syn match nft_stmt_ct_common_ct_key_keyword_status '\vstatus' skipwhite contained
hi link   nft_stmt_ct_common_ct_key_keyword_bytes nftHL_Substatement
syn match nft_stmt_ct_common_ct_key_keyword_bytes '\vbytes' skipwhite contained
hi link   nft_stmt_ct_common_ct_key_keyword_event nftHL_Substatement
syn match nft_stmt_ct_common_ct_key_keyword_event '\vevent' skipwhite contained
hi link   nft_stmt_ct_common_ct_key_keyword_label nftHL_Substatement
syn match nft_stmt_ct_common_ct_key_keyword_label '\vlabel' skipwhite contained
hi link   nft_stmt_ct_common_ct_key_keyword_daddr nftHL_Substatement
syn match nft_stmt_ct_common_ct_key_keyword_daddr '\vdaddr' skipwhite contained
hi link   nft_stmt_ct_common_ct_key_keyword_saddr nftHL_Substatement
syn match nft_stmt_ct_common_ct_key_keyword_saddr '\vsaddr' skipwhite contained

" **************** BEGIN ct_expr ct_key 'state' *******************
hi link   nft_primary_expr_ct_expr_ct_state_inline_set_comma nftHL_Element
syn match nft_primary_expr_ct_expr_ct_state_inline_set_comma '\v,' skipwhite contained
\ nextgroup=
\   nft_primary_expr_ct_expr_ct_state_inline_set_choices

hi link   nft_primary_expr_ct_expr_ct_state_inline_set_choices nftHL_Define
syn match nft_primary_expr_ct_expr_ct_state_inline_set_choices '\v((invalid|established|related|new|untracked)|([0-9]{1,10}))' skipwhite contained
\ nextgroup=
\   nft_primary_expr_ct_expr_ct_state_inline_set_comma

hi link    nft_primary_expr_ct_expr_ct_state_inline_set nftHL_blockDelimitersSet
syn region nft_primary_expr_ct_expr_ct_state_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_primary_expr_ct_expr_ct_state_inline_set_choices

hi link   nft_primary_expr_ct_expr_ct_state_comma nftHL_Element
syn match nft_primary_expr_ct_expr_ct_state_comma '\v,' skipwhite contained
\ nextgroup=
\   nft_primary_expr_ct_expr_ct_state_choices

hi link   nft_primary_expr_ct_expr_ct_state_at_setname nftHL_AtSetname
syn match nft_primary_expr_ct_expr_ct_state_at_setname '\v\@[a-zA-Z0-9][a-zA-Z0-9\-_]{0,63}' skipwhite contained
\ nextgroup=
\   @nft_c_stmt,
\   nft_primary_expr_ct_expr_ct_state_comma

hi link   nft_primary_expr_ct_expr_ct_state_choices nftHL_Define
syn match nft_primary_expr_ct_expr_ct_state_choices '\v((invalid|established|related|new|untracked)|([0-9]{1,10}))' skipwhite contained
\ nextgroup=
\   @nft_c_stmt,
\   nft_primary_expr_ct_expr_ct_state_comma,

hi link   nft_stmt_ct_common_ct_key_keyword_state nftHL_Substatement
syn match nft_stmt_ct_common_ct_key_keyword_state '\vstate' skipwhite contained
\ nextgroup=
\    nft_primary_expr_ct_expr_ct_state_at_setname,
\    nft_primary_expr_ct_expr_ct_state_choices,
\    nft_primary_expr_ct_expr_ct_state_inline_set,

" **************** END ct_expr ct_key 'state' *******************
hi link   nft_stmt_ct_stmt_keyword_set nftHL_Write
syn match nft_stmt_ct_stmt_keyword_set '\vset\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt_expr

hi link   nft_stmt_ct_common_ct_key_keyword_mark nftHL_Substatement
syn match nft_stmt_ct_common_ct_key_keyword_mark '\vmark\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stmt_ct_stmt_keyword_set

hi link   nft_stmt_ct_common_ct_key_keyword_zone nftHL_Substatement
syn match nft_stmt_ct_common_ct_key_keyword_zone '\vzone' skipwhite contained
\ nextgroup=
\    nft_stmt_ct_stmt_keyword_set

hi link   nft_stmt_ct_common_ct_key_keyword_id nftHL_Substatement
syn match nft_stmt_ct_common_ct_key_keyword_id '\vid' skipwhite contained
hi link   nft_stmt_ct_common_ct_key_proto_field_keyword_ip nftHL_Substatement
syn match nft_stmt_ct_common_ct_key_proto_field_keyword_ip '\vip' skipwhite contained
\ nextgroup=
\   nft_stmt_ct_common_ct_key_keyword_daddr,
\   nft_stmt_ct_common_ct_key_keyword_saddr
hi link   nft_stmt_ct_common_ct_key_proto_field_keyword_ip6 nftHL_Substatement
syn match nft_stmt_ct_common_ct_key_proto_field_keyword_ip6 '\vip6' skipwhite contained
\ nextgroup=
\   nft_stmt_ct_common_ct_key_keyword_daddr,
\   nft_stmt_ct_common_ct_key_keyword_saddr

" **************** BEGIN ct_expr_keyword_original *******************
syn cluster nft_c_primary_expr_ct_expr_ct_dir_key_keywords
\ contains=
\    nft_primary_expr_ct_expr_ct_dir_ct_key_dir_keyword_proto_dst,
\    nft_primary_expr_ct_expr_ct_dir_ct_key_dir_keyword_proto_src,
\    nft_primary_expr_ct_expr_ct_dir_ct_key_dir_keyword_protocol,
\    nft_primary_expr_ct_expr_ct_dir_ct_key_dir_keyword_l3proto,
\    nft_primary_expr_ct_expr_ct_dir_ct_key_dir_keyword_packets,
\    nft_primary_expr_ct_expr_ct_dir_ct_key_dir_keyword_avgpkt,
\    nft_primary_expr_ct_expr_ct_dir_ct_key_dir_keyword_bytes,
\    nft_primary_expr_ct_expr_ct_dir_ct_key_dir_keyword_daddr,
\    nft_primary_expr_ct_expr_ct_dir_ct_key_dir_keyword_saddr,
\    nft_primary_expr_ct_expr_ct_dir_ct_key_dir_keyword_zone,
\    nft_primary_expr_ct_expr_ct_dir_ct_key_proto_field_keyword_ip6,
\    nft_primary_expr_ct_expr_ct_dir_ct_key_proto_field_keyword_ip

syn cluster nft_c_primary_expr_ct_expr_ct_dir_ct_dir_key_keywords
\ contains=
\    nft_stmt_ct_common_ct_key_keyword_proto_src,
\    nft_stmt_ct_common_ct_key_keyword_proto_dst,
\    nft_stmt_ct_common_ct_key_keyword_protocol,
\    nft_stmt_ct_common_ct_key_keyword_l3proto,
\    nft_stmt_ct_common_ct_key_keyword_packets,
\    nft_stmt_ct_common_ct_key_keyword_secmark,
\    nft_stmt_ct_common_ct_key_keyword_avgpkt,
\    nft_stmt_ct_common_ct_key_keyword_bytes,
\    nft_stmt_ct_common_ct_key_keyword_daddr,
\    nft_stmt_ct_common_ct_key_keyword_saddr,
\    nft_stmt_ct_common_ct_key_keyword_zone,
\    nft_stmt_ct_common_ct_key_proto_field_keyword_ip6,
\    nft_stmt_ct_common_ct_key_proto_field_keyword_ip,

hi link   nft_primary_expr_ct_expr_ct_dir_keyword_original nftHL_Keyword
syn match nft_primary_expr_ct_expr_ct_dir_keyword_original '\voriginal' skipwhite contained
\ nextgroup=
\    @nft_c_primary_expr_ct_expr_ct_dir_ct_dir_key_keywords

hi link   nft_primary_expr_ct_expr_ct_dir_keyword_reply nftHL_Keyword
syn match nft_primary_expr_ct_expr_ct_dir_keyword_reply '\vreply' skipwhite contained
\ nextgroup=
\    @nft_c_primary_expr_ct_expr_ct_dir_ct_dir_key_keywords
" **************** END ct_expr ***************************************

" **************** BEGIN ct_stmt *************************************
" **************** END ct_stmt ***************************************

" base_cmd [ 'ct' ]
hi link   nft_base_cmd_add_cmd_keyword_ct nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_ct "\vct\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_stmt_objref_stmt_objref_stmt_ct_keyword_expiration,
\    nft_stmt_ct_common_ct_key_keyword_direction,
\    nft_stmt_ct_common_ct_key_keyword_proto_dst,
\    nft_stmt_ct_common_ct_key_keyword_proto_src,
\    nft_primary_expr_ct_expr_ct_dir_keyword_original,
\    nft_stmt_ct_common_ct_key_keyword_protocol,
\    nft_stmt_ct_common_ct_key_keyword_packets,
\    nft_stmt_ct_common_ct_key_keyword_secmark,
\    nft_stmt_objref_stmt_objref_stmt_ct_keyword_timeout,
\    nft_base_cmd_add_ct_keyword_helper,
\    nft_stmt_ct_common_ct_key_keyword_l3proto,
\    nft_stmt_ct_common_ct_key_keyword_avgpkt,
\    nft_stmt_ct_common_ct_key_keyword_helper,
\    nft_stmt_ct_common_ct_key_keyword_status,
\    nft_stmt_ct_common_ct_key_keyword_bytes,
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_connlimit_stmt_keyword_count,
\    nft_stmt_ct_common_ct_key_keyword_event,
\    nft_stmt_ct_common_ct_key_keyword_daddr,
\    nft_stmt_ct_common_ct_key_keyword_label,
\    nft_primary_expr_ct_expr_ct_dir_keyword_reply,
\    nft_stmt_ct_common_ct_key_keyword_saddr,
\    nft_stmt_ct_common_ct_key_keyword_state,
\    nft_stmt_ct_common_ct_key_keyword_mark,
\    nft_stmt_ct_common_ct_key_keyword_zone,
\    nft_stmt_ct_common_ct_key_keyword_id,
\    nft_Error
" **************** BEGIN add_ct_cmd *******************

  for s:this_semantic_file in s:add_ct_cmd_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded add_ct_cmd for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define add_ct_cmd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_add_ct_cmd = v:true

