" File: table_block_set_block.vim
" Directory: custom/nftables/table/table_block/
"
let s:table_block_set_block_list_filepaths_semantic_early = []
let s:table_block_set_block_list_filepaths_semantic_later = []

if exists('b:did_nftables_table_block_set_block')
  call nftables#syntax#log('INFO', 'Skipped table_block_set_block (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:table_block_set_block_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading table_block_set_block syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
" ******************** BEGIN stateful_stmt
" 'table' table_block '{' 'set' set_block '{' stateful_stmt_list stateful_stmt counter_stmt 'counter' 'bytes' <NUM>
hi link   nft_stateful_stmt_counter_stmt_counter_arg_bytes_num nftHL_Integer
syn match nft_stateful_stmt_counter_stmt_counter_arg_bytes_num '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\     nft_add_cmd_table_block_set_block_separator

" 'table' table_block '{' 'set' set_block '{' stateful_stmt_list stateful_stmt counter_stmt 'counter' 'bytes'
hi link   nft_stateful_stmt_counter_stmt_counter_arg_keyword_bytes nftHL_Keyword
syn match nft_stateful_stmt_counter_stmt_counter_arg_keyword_bytes '\vbytes\ze[ \t]' skipwhite contained
\ nextgroup=nft_stateful_stmt_counter_stmt_counter_arg_bytes_num

" 'table' table_block '{' 'set' set_block '{' stateful_stmt_list stateful_stmt counter_stmt 'counter' 'packets' <NUM>
hi link   nft_stateful_stmt_counter_stmt_counter_arg_packets_num nftHL_Integer
syn match nft_stateful_stmt_counter_stmt_counter_arg_packets_num '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\     nft_stateful_stmt_counter_stmt_counter_arg_keyword_bytes

" 'table' table_block '{' 'set' set_block '{' stateful_stmt_list stateful_stmt counter_stmt 'counter' 'packets'
hi link   nft_stateful_stmt_counter_stmt_counter_arg_keyword_packets nftHL_Keyword
syn match nft_stateful_stmt_counter_stmt_counter_arg_keyword_packets '\vpackets\ze[ \t]' skipwhite contained
\ nextgroup=nft_stateful_stmt_counter_stmt_counter_arg_packets_num


" 'table' table_block '{' 'set' set_block '{' stateful_stmt_list stateful_stmt counter_stmt 'counter'
hi link   nft_add_cmd_table_block_set_block_stateful_stmt_list_stmt_stateful_stmt_counter_stmt_keyword_counter nftHL_Statement
syn match nft_add_cmd_table_block_set_block_stateful_stmt_list_stmt_stateful_stmt_counter_stmt_keyword_counter '\vcounter\ze[ \t\n\};]' skipwhite contained
\ nextgroup=
\    nft_stateful_stmt_counter_stmt_counter_arg_keyword_packets,

" limit_burst_bytes
" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst' <NUM> ('bytes'|'string')
" 'bytes'->limit_burst_bytes->limit_config
hi link   nft_table_block_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_keyword_packets nftHL_Keyword
syn match nft_table_block_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_keyword_packets "\vpackets" skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error

" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst' <NUM>
" num->limit_burst_pkts->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_table_block_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_num nftHL_Number
syn match nft_table_block_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_num "\v[0-9]{1,20}\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_table_block_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_keyword_packets,
\    nft_UnexpectedEOS,
\    nft_Error

" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst'
" 'burst'->limit_burst_pkts->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_table_block_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_keyword_burst nftHL_Command
syn match nft_table_block_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_keyword_burst "\vburst\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_table_block_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_num,
\    nft_Error


hi link   nft_table_block_set_block_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit nftHL_Keyword
syn match nft_table_block_set_block_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit "\v(second|minute|hour|day|week)[s]?" skipwhite contained
\ nextgroup=
\    nft_table_block_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_keyword_burst,
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Errror

" limit_rate_bytes
" 'rate' [ 'over'|'until' ] <NUM> 'bytes' '/'
" '/'->limit_rate_bytes->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_table_block_set_block_stateful_stmt_limit_stmt_limit_rate_pkts_expression_slash nftHL_Expression
syn match nft_table_block_set_block_stateful_stmt_limit_stmt_limit_rate_pkts_expression_slash "/" skipwhite contained
\ nextgroup=
\    nft_table_block_set_block_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit,
\    nft_UnexpectedEOS,
\    nft_Error

" limit_burst_bytes
" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst' <NUM> ('bytes'|'string')
" 'bytes'->limit_burst_bytes->limit_config
hi link   nft_table_block_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_human nftHL_Keyword
syn match nft_table_block_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_human "\v(pbyte|gbyte|mbyte|kbyte|byte)s" skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error

" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst' <NUM>
" num->limit_burst_bytes->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_table_block_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_num nftHL_Number
syn match nft_table_block_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_num "\v[0-9]{1,10}\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_table_block_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_human,
\    nft_Error

" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst'
" 'burst'->limit_burst_bytes->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_table_block_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_keyword_burst nftHL_Command
syn match nft_table_block_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_keyword_burst "\vburst\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_table_block_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_num,
\    nft_Error

hi link   nft_table_block_set_block_stateful_stmt_limit_stmt_limit_rate_bytes_time_unit nftHL_Keyword
syn match nft_table_block_set_block_stateful_stmt_limit_stmt_limit_rate_bytes_time_unit "\v(second|minute|hour|day|week)[s]?" skipwhite contained
\ nextgroup=
\    nft_table_block_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_keyword_burst,
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error

hi link   nft_table_block_set_block_stateful_stmt_limit_stmt_limit_rate_bytes_expression_slash nftHL_Expression
syn match nft_table_block_set_block_stateful_stmt_limit_stmt_limit_rate_bytes_expression_slash "/" skipwhite contained
\ nextgroup=
\    nft_table_block_set_block_stateful_stmt_limit_stmt_limit_rate_bytes_time_unit

" 'limit' 'rate' [ 'over'|'until' ] <NUM> 'string'
" 'string'->limit_rate_bytes->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_table_block_set_block_stateful_stmt_limit_stmt_limit_rate_bytes_string nftHL_Keyword
syn match nft_table_block_set_block_stateful_stmt_limit_stmt_limit_rate_bytes_string "\v(kbyte|mbyte|gbyte|pbyte|byte)s" skipwhite contained
\ nextgroup=
\    nft_table_block_set_block_stateful_stmt_limit_stmt_limit_rate_bytes_expression_slash,
\    nft_EOS

" 'limit' 'rate' [ 'over'|'until' ] <NUM>
" <num>->*->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_table_block_set_block_stateful_stmt_limit_stmt_limit_rate_pktsbytes_num nftHL_Number
syn match nft_table_block_set_block_stateful_stmt_limit_stmt_limit_rate_pktsbytes_num "\v[0-9]{1,10}\ze[ \t\/\}]" skipwhite contained
\ nextgroup=
\    nft_table_block_set_block_stateful_stmt_limit_stmt_limit_rate_pkts_expression_slash,
\    nft_table_block_set_block_stateful_stmt_limit_stmt_limit_rate_bytes_string,
\    nft_UnexpectedEOS

" 'rate' [ 'over'|'until' ]
" limit_mode->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_table_block_set_block_stateful_stmt_limit_stmt_limit_mode nftHL_Keyword
syn match nft_table_block_set_block_stateful_stmt_limit_stmt_limit_mode "\v(over|until)\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_table_block_set_block_stateful_stmt_limit_stmt_limit_rate_pktsbytes_num,
\    nft_Error

hi link   nft_table_block_set_block_stateful_stmt_limit_stmt_keyword_rate nftHL_Statement
syn match nft_table_block_set_block_stateful_stmt_limit_stmt_keyword_rate "\vrate\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_table_block_set_block_stateful_stmt_limit_stmt_limit_mode,
\    nft_table_block_set_block_stateful_stmt_limit_stmt_limit_rate_pktsbytes_num,
\    nft_Error

hi link   nft_add_cmd_table_block_set_block_stateful_stmt_list_stmt_stateful_stmt_limit_stmt_keyword_limit nftHL_Statement
syn match nft_add_cmd_table_block_set_block_stateful_stmt_list_stmt_stateful_stmt_limit_stmt_keyword_limit '\vlimit\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_table_block_set_block_stateful_stmt_limit_stmt_keyword_rate,
\    nft_Error

hi link nft_table_block_set_block_stateful_stmt_quota_stmt_quota_used_quota_unit_keywords_bytes nftHL_Keyword
syn match nft_table_block_set_block_stateful_stmt_quota_stmt_quota_used_quota_unit_keywords_bytes '\v(kbyte|mbyte|gbyte|pbyte|byte)s' skipwhite contained

hi link   nft_table_block_set_block_stateful_stmt_quota_stmt_quota_used_num nftHL_Integer
syn match nft_table_block_set_block_stateful_stmt_quota_stmt_quota_used_num '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_table_block_set_block_stateful_stmt_quota_stmt_quota_used_quota_unit_keywords_bytes,
\    nft_Error

hi link   nft_table_block_set_block_stateful_stmt_quota_stmt_quota_used_keyword_used nftHL_Keyword
syn match nft_table_block_set_block_stateful_stmt_quota_stmt_quota_used_keyword_used '\vused' skipwhite contained
\ nextgroup=
\    nft_table_block_set_block_stateful_stmt_quota_stmt_quota_used_num,
\    nft_Error

hi link   nft_table_block_set_block_stateful_stmt_quota_stmt_quota_unit_keywords_bytes nftHL_Keyword
syn match nft_table_block_set_block_stateful_stmt_quota_stmt_quota_unit_keywords_bytes '\v(kbyte|mbyte|gbyte|pbyte|byte)s' skipwhite contained
\ nextgroup=
\    nft_table_block_set_block_stateful_stmt_quota_stmt_quota_used_keyword_used

hi link   nft_table_block_set_block_stateful_stmt_quota_stmt_quota_mode_num nftHL_Integer
syn match nft_table_block_set_block_stateful_stmt_quota_stmt_quota_mode_num '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_table_block_set_block_stateful_stmt_quota_stmt_quota_unit_keywords_bytes,
\    nft_Error

hi link   nft_table_block_set_block_stateful_stmt_quota_stmt_quota_mode_keyword_until nftHL_Keyword
syn match nft_table_block_set_block_stateful_stmt_quota_stmt_quota_mode_keyword_until '\vuntil' skipwhite contained
\ nextgroup=
\    nft_table_block_set_block_stateful_stmt_quota_stmt_quota_mode_num,
\    nft_Error

hi link   nft_table_block_set_block_stateful_stmt_quota_stmt_quota_mode_keyword_over nftHL_Keyword
syn match nft_table_block_set_block_stateful_stmt_quota_stmt_quota_mode_keyword_over '\vover' skipwhite contained
\ nextgroup=
\    nft_table_block_set_block_stateful_stmt_quota_stmt_quota_mode_num,
\    nft_Error

hi link   nft_add_cmd_table_block_set_block_stateful_stmt_list_stmt_stateful_stmt_quota_stmt_keyword_quota nftHL_Statement
syn match nft_add_cmd_table_block_set_block_stateful_stmt_list_stmt_stateful_stmt_quota_stmt_keyword_quota '\vquota\ze[ \t\n\};]' skipwhite contained
\ nextgroup=
\    nft_table_block_set_block_stateful_stmt_quota_stmt_quota_mode_keyword_until,
\    nft_table_block_set_block_stateful_stmt_quota_stmt_quota_mode_keyword_over,
\    nft_table_block_set_block_stateful_stmt_quota_stmt_quota_mode_num,
\    nft_Error

hi link   nft_add_cmd_table_block_set_block_stateful_stmt_list_stmt_stateful_stmt_last_stmt_keyword_last nftHL_Statement
syn match nft_add_cmd_table_block_set_block_stateful_stmt_list_stmt_stateful_stmt_last_stmt_keyword_last '\vlast' skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_last_stmt_keyword_used

hi link   nft_add_cmd_table_block_set_block_stateful_stmt_list_stmt_stateful_stmt_connlimit_stmt_keyword_ct nftHL_Statement
syn match nft_add_cmd_table_block_set_block_stateful_stmt_list_stmt_stateful_stmt_connlimit_stmt_keyword_ct 'ct\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_connlimit_stmt_keyword_count
" ******************** END stateful_stmt ****************************


  for s:this_semantic_file in s:table_block_set_block_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded table_block_set_block for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define table_block_set_block.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_table_block_set_block = v:true
