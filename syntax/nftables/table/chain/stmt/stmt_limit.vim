" File: stmt_limit.vim
" Directory: custom/nftables/
" The actual start of 'stmt' statements for starting 'limit' token/keyword
"
"  The 'limit' keyword is the focus here within this file
"  (and not the 'payload_expr' semantic action that it appears to emulate).
"
" Some overlays for 'limit' keywords as the token opener of statements are:
"
"    - keyword_expr (simplest 'limit')
"    - payload_stmt is a write and has a 'set' keyword
"    - primary_expr (includes payload_expr) is a read-only  ('limit protocol icmp')
"    - primary_stmt_expr is this run-on, add-ons of additional 'expr' for each 'stmt'
"    - concat_stmt_expr is this 'glueless' run-on of 'primary_stmt_expr' together.
"    - payload_stmt_expr is may be surrounded by parenthesis during 'glueless'
"          concat_stmt_expr chaining, e.g., 'limit protocol icmp (icmp type echo-request)'
"
" For expression, see 'limit_expr.vim'
"
"  By staying true to LL(1) (or keyword-centric, we avoid clashes by semantic actions)

let s:stmt_limit_list_filepaths_semantic_early = []
let s:stmt_limit_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_limit')
  call nftables#syntax#log('INFO', 'Skipped stmt_limit (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_limit_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_limit syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

" 'limit' 'rate' [ 'over'|'until' ]
" limit_mode->limit_stmt->stateful_stmt
hi link   nft_limit_stmt_limit_config_limit_mode nftHL_Keyword
syn match nft_limit_stmt_limit_config_limit_mode "\v(over|until)" skipwhite contained
\ nextgroup=
\    nft_limit_stmt_limit_rate_pktsbytes_num

" limit_burst_bytes
" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst' <NUM> ('bytes'|'string')
" 'bytes'->limit_burst_bytes->limit_config
hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_keyword_packets nftHL_Unit
syn match nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_keyword_packets "\vpackets" skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator

" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst' <NUM>
" num->limit_burst_pkts->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_num nftHL_Integer
syn match nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_num "\v[0-9]{1,20}\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_keyword_packets,
\    nft_UnexpectedEOS,
\    nft_Error

" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst'
" 'burst'->limit_burst_pkts->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_keyword_burst nftHL_Substatement
syn match nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_keyword_burst "\vburst\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_num,
\    nft_Error


hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit nftHL_Unit
syn match nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit "\v(second|minute|hour|day|week)[s]?" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_keyword_burst,
\    nft_line_stmt_separator,
\    @nft_c_stmt

" limit_rate_bytes
" 'rate' [ 'over'|'until' ] <NUM> 'bytes' '/'
" '/'->limit_rate_bytes->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_pkts_expression_slash nftHL_Expression
syn match nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_pkts_expression_slash "/" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit,
\    nft_UnexpectedEOS,
\    nft_Error

" limit_burst_bytes
" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst' <NUM> ('bytes'|'string')
" 'bytes'->limit_burst_bytes->limit_config
hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_human nftHL_Unit
syn match nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_human "\v(pbyte|gbyte|mbyte|kbyte|byte)s" skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,

" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst' <NUM>
" num->limit_burst_bytes->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_num nftHL_Integer
syn match nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_num "\v[0-9]{1,10}\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_human,
\    nft_Error

" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst'
" 'burst'->limit_burst_bytes->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_keyword_burst nftHL_Substatement
syn match nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_keyword_burst "\vburst\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_num,
\    nft_Error

hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_bytes_time_unit nftHL_Unit
syn match nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_bytes_time_unit "\v(second|minute|hour|day|week)[s]?" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_keyword_burst,
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error

hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_bytes_expression_slash nftHL_Expression
syn match nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_bytes_expression_slash "/" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_bytes_time_unit

" 'limit' 'rate' [ 'over'|'until' ] <NUM> 'string'
" 'string'->limit_rate_bytes->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_bytes_string nftHL_Unit
syn match nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_bytes_string "\v(kbyte|mbyte|gbyte|pbyte|byte)s" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_bytes_expression_slash,
\    nft_EOS

" 'limit' 'rate' [ 'over'|'until' ] <NUM>
" <num>->*->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_pktsbytes_num nftHL_Integer
syn match nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_pktsbytes_num "\v[0-9]{1,10}\ze[ \t\/\}]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_pkts_expression_slash,
\    nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_bytes_string,
\    nft_UnexpectedEOS

" 'rate' [ 'over'|'until' ]
" limit_mode->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_mode nftHL_Keyword
syn match nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_mode "\v(over|until)\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_pktsbytes_num,
\    nft_Error

hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_keyword_rate nftHL_Substatement
syn match nft_add_cmd_set_block_stateful_stmt_limit_stmt_keyword_rate "\vrate\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_mode,
\    nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_pktsbytes_num,
\    nft_Error

hi link   nft_objref_stmt_objref_stmt_limit_identifier nftHL_Identifier
syn match nft_objref_stmt_objref_stmt_limit_identifier '\v[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained
" \ nextgroup=
" \    @nft_c_stmt_expr

" base_cmd add_cmd 'table' table_block 'chain' chain_block '{' 'limit'
hi link   nft_stmt_keyword_limit nftHL_Statement
syn match nft_stmt_keyword_limit '\vlimit' skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_limit_stmt_keyword_rate,
\    nft_Error

" base_cmd add_cmd 'set' set_spec '{' set_block stateful_stmt limit_stmt 'limit'
hi link   nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_limit_stmt_keyword_limit nftHL_Statement
syn match nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_limit_stmt_keyword_limit '\vlimit' skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_limit_stmt_keyword_rate,
\    nft_Error


" ********************** BEGIN 'limit rate' **************************
" ***************** BEGIN 'limit rate [ 'over'|'until' ] *************
hi link   nft_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit_keyword_second nftHL_Unit
syn match nft_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit_keyword_second '\vsecond\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit_keyword_minute nftHL_Unit
syn match nft_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit_keyword_minute '\vminute\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit_keyword_hour nftHL_Unit
syn match nft_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit_keyword_hour '\vhour\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit_keyword_week nftHL_Unit
syn match nft_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit_keyword_week '\vweek\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit_keyword_day nftHL_Unit
syn match nft_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit_keyword_day '\vday\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_stateful_stmt_limit_stmt_limit_rate_pkts_keyword_SLASH nftHL_Operator
syn match nft_stateful_stmt_limit_stmt_limit_rate_pkts_keyword_SLASH '\v\/' contained
\ nextgroup=
\    nft_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit_keyword_second,
\    nft_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit_keyword_minute,
\    nft_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit_keyword_hour,
\    nft_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit_keyword_week,
\    nft_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit_keyword_day,
\    nft_Error

hi link   nft_stateful_stmt_limit_stmt_limit_rate_pkts_num_32b nftHL_Integer
syn match nft_stateful_stmt_limit_stmt_limit_rate_pkts_num_32b '\v[0-9]{1,11}\ze[ \t\/]' contained
\ nextgroup=
\    nft_stateful_stmt_limit_stmt_limit_rate_pkts_keyword_SLASH,
\    nft_Error

" 'limit' 'rate' [ 'over'|'until' ]
" limit_mode->'limit'->set_elem_stmt->set_elem_expr_alloc
hi link   nft_stateful_stmt_limit_stmt_limit_mode_keyword_until nftHL_Keyword
syn match nft_stateful_stmt_limit_stmt_limit_mode_keyword_until "\vuntil\ze[ \t\n]" skipwhite contained
\ nextgroup=
\    nft_stateful_stmt_limit_stmt_limit_rate_pkts_num_32b,
\    nft_Error

hi link   nft_stateful_stmt_limit_stmt_limit_mode_keyword_over nftHL_Keyword
syn match nft_stateful_stmt_limit_stmt_limit_mode_keyword_over "\vover\ze[ \t\n]" skipwhite contained
\ nextgroup=
\    nft_stateful_stmt_limit_stmt_limit_rate_pkts_num_32b,
\    nft_Error
" ******************* END 'limit rate [ 'over'|'until' ] *************

" 'rate'->limit_stmt->stateful_stmt
hi link   nft_stateful_stmt_limit_stmt_keyword_rate nftHL_Substatement
syn match nft_stateful_stmt_limit_stmt_keyword_rate "rate" skipwhite contained
\ nextgroup=
\    nft_stateful_stmt_limit_stmt_limit_mode_keyword_until,
\    nft_stateful_stmt_limit_stmt_limit_mode_keyword_over,
\    nft_stateful_stmt_limit_stmt_limit_rate_pkts_num_32b,
\    nft_Error
" ************************ END 'limit rate' **************************

" ********************** BEGIN 'limit' *******************************
" this is not an expression but THE opening statement 'limit' keyword
hi link   nft_stateful_stmt_limit_stmt_declarative_keyword_limit  nftHL_Command
syn match nft_stateful_stmt_limit_stmt_declarative_keyword_limit  '\vlimit\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stateful_stmt_limit_stmt_keyword_rate,
\    nft_stateful_stmt_limit_stmt_limit_rate_pkts_num_32b,
\    nft_Error

" this is an expression
hi link   nft_add_rule_imperative_keyword_limit  nftHL_Command
syn match nft_add_rule_imperative_keyword_limit  '\vlimit\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stateful_stmt_limit_stmt_keyword_rate,
\    nft_stateful_stmt_limit_stmt_limit_rate_pkts_num_32b,
\    nft_Error


" 'limit'
" 'limit'->limit_stmt->stateful_stmt
hi link   nft_limit_stmt nftHL_Statement
syn match nft_limit_stmt "limit" skipwhite contained
\ nextgroup=
\    nft_stateful_stmt_limit_stmt_keyword_rate

" ********************** BEGIN 'limit' *******************************


  for s:this_semantic_file in s:stmt_limit_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_limit for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_limit.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_limit = v:true
