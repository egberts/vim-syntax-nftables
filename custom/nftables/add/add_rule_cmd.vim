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
