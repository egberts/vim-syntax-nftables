" File: add_set_cmd.vim
" Directory: custom/nftables/add/
"
let s:add_set_cmd_list_filepaths_semantic_early = []
let s:add_set_cmd_list_filepaths_semantic_later = []

if exists('b:did_nftables_add_set_cmd')
  call nftables#syntax#log('INFO', 'Skipped add_set_cmd (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:add_set_cmd_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading add_set_cmd syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

" ******************** BEGIN set_cmd ************************
hi link   nft_add_cmd_set_block_separator nftHL_Normal
syn match nft_add_cmd_set_block_separator /;/ skipwhite contained
\ nextgroup=
\    nft_Semicolon,
\    nft_comment_inline

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr 'type' typeof_expr primary_expr
hi link   nft_add_cmd_set_block_typeof_key_expr_typeof_expr_primary_expr nftHL_Identifier
syn match nft_add_cmd_set_block_typeof_key_expr_typeof_expr_primary_expr skipwhite contained
\  "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}"
" do not use 'skipwhite' here

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr 'type'  <family>
hi link   nft_add_cmd_set_block_typeof_key_expr_type_data_type_expr nftHL_Keyword
syn match nft_add_cmd_set_block_typeof_key_expr_type_data_type_expr "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_typeof_key_expr_type_data_type_expr

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr 'type'
hi link   nft_add_cmd_set_block_typeof_key_expr_keyword_type nftHL_Command
syn match nft_add_cmd_set_block_typeof_key_expr_keyword_type "type\s" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_typeof_key_expr_type_data_type_expr

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr 'typeof' typeof_expr primary_expr
hi link   nft_add_cmd_set_block_typeof_key_expr_typeof_expr_primary_expr nftHL_Identifier
syn match nft_add_cmd_set_block_typeof_key_expr_typeof_expr_primary_expr contained
\  "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}(\.[a-zA-Z][a-zA-Z0-9]{0,63}){0,23}" contained  " do not use 'skipwhite' here
\ nextgroup=
\    nft_add_cmd_set_block_typeof_key_expr_typeof_expr_primary_expr_with_dot
" TODO undefined nft_add_cmd_set_block_typeof_key_expr_typeof_expr_primary_with_dot

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr 'typeof' typeof_expr
syn cluster nft_c_add_cmd_set_block_typeof_key_expr_typeof_expr
\ contains=
\    nft_add_cmd_set_block_typeof_key_expr_typeof_expr_primary_expr

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr 'typeof'
hi link   nft_add_cmd_set_block_typeof_key_expr_keyword_typeof nftHL_Command
syn match nft_add_cmd_set_block_typeof_key_expr_keyword_typeof "typeof" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_set_block_typeof_key_expr_typeof_expr

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr
syn cluster nft_c_add_cmd_set_block_typeof_key_expr
\ contains=
\    nft_add_cmd_set_block_typeof_key_expr_keyword_typeof,
\    nft_add_cmd_set_block_typeof_key_expr_keyword_type

" base_cmd add_cmd 'set' set_spec '{' set_block 'flags' set_flag_list set_flag ','
hi link   nft_add_cmd_set_block_flags_set_flag_list_comma nftHL_Operator
syn match nft_add_cmd_set_block_flags_set_flag_list_comma "," skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_set_block_set_flag_list

" base_cmd add_cmd 'set' set_spec '{' set_block 'flags' set_flag_list set_flag
hi link   nft_add_cmd_set_block_flags_set_flag_list_set_flag nftHL_Keyword
syn match nft_add_cmd_set_block_flags_set_flag_list_set_flag skipwhite contained
\ "\v(constant|interval|timeout|dynamic)"
\ nextgroup=
\    nft_add_cmd_set_block_flags_set_flag_list_comma

" base_cmd add_cmd 'set' set_spec '{' set_block 'flags' set_flag_list
syn cluster nft_c_add_cmd_set_block_set_flag_list
\ contains=
\    nft_add_cmd_set_block_flags_set_flag_list_set_flag

" base_cmd add_cmd 'set' set_spec '{' set_block 'flags'
hi link   nft_add_cmd_set_block_flags nftHL_Command
syn match nft_add_cmd_set_block_flags "flags" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_set_block_set_flag_list

" base_cmd add_cmd 'set' set_spec '{' set_block 'timeout'/'gc-interval' time_spec
hi link   nft_add_cmd_set_block_time_spec nftHL_Number
syn match nft_add_cmd_set_block_time_spec "\v[a-zA-Z0-9_\:]{1,31}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_separator

" base_cmd add_cmd 'set' set_spec '{' set_block 'timeout'
hi link   nft_add_cmd_set_block_timeout nftHL_Command
syn match nft_add_cmd_set_block_timeout "\vtimeout\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_time_spec

" base_cmd add_cmd 'set' set_spec '{' set_block 'elements'
hi link   nft_add_cmd_set_block_elements nftHL_Command
syn match nft_add_cmd_set_block_elements "\velements\ze[ \t]" skipwhite contained

" base_cmd add_cmd 'set' set_spec '{' set_block 'gc-interval'
hi link   nft_add_cmd_set_block_gc_interval nftHL_Command
syn match nft_add_cmd_set_block_gc_interval "\vgc\-interval" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_time_spec

" base_cmd add_cmd 'set' set_spec '{' set_block siabcdefghijklmnoptdfteful_stmt counter_st'counter'
hi link   nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_counter_stmt_keyword_counter nftHL_Statement
syn match nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_counter_stmt_keyword_counter '\vcounter' skipwhite contained
\ nextgroup=
\    nft_stateful_stmt_counter_stmt_counter_arg_keyword_packets,
\    nft_stateful_stmt_counter_stmt_counter_arg_keyword_bytes,
\    nft_add_cmd_set_block_separator

" limit_burst_bytes
" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst' <NUM> ('bytes'|'string')
" 'bytes'->limit_burst_bytes->limit_config
hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_keyword_packets nftHL_Keyword
syn match nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_keyword_packets "\vpackets" skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator

" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst' <NUM>
" num->limit_burst_pkts->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_num nftHL_Number
syn match nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_num "\v[0-9]{1,20}\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_keyword_packets,
\    nft_UnexpectedEOS,
\    nft_Error

" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst'
" 'burst'->limit_burst_pkts->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_keyword_burst nftHL_Keyword
syn match nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_keyword_burst "\vburst\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_num,
\    nft_Error


hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit nftHL_Unit
syn match nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_pkts_time_unit "\v(second|minute|hour|day|week)[s]?" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_pkts_keyword_burst,
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Errror

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
\    nft_Error

" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst' <NUM>
" num->limit_burst_bytes->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_num nftHL_Number
syn match nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_num "\v[0-9]{1,10}\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_human,
\    nft_Error

" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst'
" 'burst'->limit_burst_bytes->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_burst_bytes_keyword_burst nftHL_Command
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
hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_limit_rate_pktsbytes_num nftHL_Number
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

hi link   nft_add_cmd_set_block_stateful_stmt_limit_stmt_keyword_rate nftHL_Keyword
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

hi link   nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_num_quota_used_string nftHL_Unit
syn match nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_num_quota_used_string '\v(pbyte|kbyte|mbyte|gbyte|tbyte|byte)s?' skipwhite contained

hi link   nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_used_num nftHL_Integer
syn match nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_used_num '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_num_quota_used_string,
\    nft_Error

hi link   nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_num_quota_used_keyword_used nftHL_Statement
syn match nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_num_quota_used_keyword_used '\vused' skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_used_num,
\    nft_Error

hi link   nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_num_quota_unit_string nftHL_Unit
syn match nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_num_quota_unit_string '\v(pbyte|kbyte|mbyte|gbyte|tbyte|byte)s?' skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_num_quota_used_keyword_used

hi link   nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_num nftHL_Integer
syn match nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_num '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_num_quota_unit_string,
\    nft_Error

hi link   nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_keyword_until nftHL_Keyword
syn match nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_keyword_until '\vuntil' skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_num,
\    nft_Error

hi link   nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_keyword_over nftHL_Keyword
syn match nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_keyword_over '\vover' skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_num

" base_cmd add_cmd 'set' set_spec '{' set_block stateful_stmt quota_stmt 'quota'
hi link   nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_keyword_quota nftHL_Statement
syn match nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_keyword_quota '\vquota' skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_keyword_until,
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_keyword_over,
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_num

hi link   nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_last_stmt_keyword_never nftHL_Keyword
syn match nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_last_stmt_keyword_never '\vnever' skipwhite contained

hi link   nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_last_stmt_time_spec_string nftHL_String
syn match nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_last_stmt_time_spec_string '\v\"([0-9]{1,5}[wdhms]{1}){1,5}\"' skipwhite contained
hi link   nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_last_stmt_time_spec_string nftHL_String
syn match nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_last_stmt_time_spec_string '\v([0-9]{1,5}[wdhms]{1}){1,5}' skipwhite contained

hi link   nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_last_stmt_keyword_used nftHL_Keyword
syn match nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_last_stmt_keyword_used '\vused' skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_last_stmt_keyword_never,
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_last_stmt_time_spec_string

" base_cmd add_cmd 'set' set_spec '{' set_block stateful_stmt last_stmt 'last'
hi link   nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_last_stmt_keyword_last nftHL_Statement
syn match nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_last_stmt_keyword_last '\vlast' skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_last_stmt_keyword_used

hi link   nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_connlimit_stmt_num nftHL_Integer
syn match nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_connlimit_stmt_num '\v[0-9]{1,10}' skipwhite contained

hi link   nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_connlimit_stmt_keyword_over nftHL_Keyword
syn match nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_connlimit_stmt_keyword_over '\vover' skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_connlimit_stmt_num

hi link   nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_connlimit_stmt_keyword_count nftHL_Keyword
syn match nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_connlimit_stmt_keyword_count '\vcount' skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_connlimit_stmt_keyword_over,
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_connlimit_stmt_num

" base_cmd add_cmd 'set' set_spec '{' set_block stateful_stmt counter_stmt 'ct'
hi link   nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_connlimit_stmt_keyword_ct nftHL_Statement
syn match nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_connlimit_stmt_keyword_ct '\vct' skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_connlimit_stmt_keyword_count

" base_cmd add_cmd 'set' set_spec '{' set_block 'elements' '=' set_block_expr
hi link    nft_add_cmd_set_block_elements_set_block_expr_set_expr nftHL_BlockDelimitersSet
syn region nft_add_cmd_set_block_elements_set_block_expr_set_expr start="{" end="}" skipwhite contained
\ contains=
\    nft_add_cmd_set_block_element_set_block_elements_block_items
\ nextgroup=
\    nft_add_cmd_set_block_separator

hi link   nft_add_cmd_set_block_element_set_block_semicolon nftHL_Operator
syn match nft_add_cmd_set_block_element_set_block_semicolon /;/ skipwhite contained

hi link    nft_add_cmd_set_block_elements_set_block_expr_set_expr_delimiters nftHL_BlockDelimitersSet
syn region nft_add_cmd_set_block_elements_set_block_expr_set_expr_delimiters start="{" end="}" skipnl skipempty skipwhite contained
\ contains=
\    nft_add_cmd_set_block_element_set_block_elements_block_items
\ nextgroup=
\    nft_add_cmd_set_block_separator

hi link   nft_add_cmd_set_block_elements_variable_expr nftHL_Variable
syn match nft_add_cmd_set_block_elements_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_separator

" base_cmd add_cmd 'set' set_spec '{' set_block 'elements' '='
hi link   nft_add_cmd_set_block_elements_equal nftHL_Operator
syn match nft_add_cmd_set_block_elements_equal '\v\=' skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_elements_set_block_expr_set_expr_delimiters,
\    nft_add_cmd_set_block_elements_variable_expr,
\    nft_Error

" base_cmd add_cmd 'set' set_spec '{' set_block 'elements'
hi link   nft_add_cmd_set_block_elements nftHL_Command
syn match nft_add_cmd_set_block_elements "\velements\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_elements_equal,
\    nft_Error

" base_cmd add_cmd 'set' set_spec '{' set_block 'automerge'
hi link   nft_add_cmd_set_block_automerge nftHL_Command
syn match nft_add_cmd_set_block_automerge "\vauto\-merge" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_separator

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism 'size' <interval>
hi link   nft_add_cmd_set_block_set_mechanism_size_value nftHL_Number
syn match nft_add_cmd_set_block_set_mechanism_size_value "\v[0-9]{1,32}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_separator,
\    nft_comment_inline

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism 'size'
hi link   nft_add_cmd_set_block_set_mechanism_size nftHL_Command
syn match nft_add_cmd_set_block_set_mechanism_size "size" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_set_mechanism_size_value

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism 'policy' 'memory'
hi link   nft_add_cmd_set_block_set_mechanism_policy_memory nftHL_Keyword
syn match nft_add_cmd_set_block_set_mechanism_policy_memory "memory" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_separator,
\    nft_comment_inline

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism 'policy' 'performance'
hi link   nft_add_cmd_set_block_set_mechanism_policy_performance nftHL_Keyword
syn match nft_add_cmd_set_block_set_mechanism_policy_performance "performance" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_separator

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism 'policy'
hi link   nft_add_cmd_set_block_set_mechanism_policy nftHL_Command
syn match nft_add_cmd_set_block_set_mechanism_policy "policy" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block_set_mechanism_policy_memory,
\    nft_add_cmd_set_block_set_mechanism_policy_performance

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism
syn cluster nft_c_add_cmd_set_block_set_mechanism
\ contains=
\    nft_add_cmd_set_block_set_mechanism_size,
\    nft_add_cmd_set_block_set_mechanism_policy


hi link   nft_add_cmd_set_block_comment_spec_string_content nftHL_Comment
syn match nft_add_cmd_set_block_comment_spec_string_content '\v[a-zA-Z0-9 ]{1,64}' skipwhite contained

" 'comment' comment_spec QUOTED_STRING
" used only at top-level, never inside 'blocks'
hi link    nft_add_cmd_set_block_comment_spec_string_quoted_double nftHL_Comment
syn region nft_add_cmd_set_block_comment_spec_string_quoted_double start='\"' end='\"' skip="\\\"" skipwhite contained
\ contains=
\    nft_add_cmd_set_block_comment_spec_string_content

" base_cmd add_cmd 'set' set_spec '{' set_block 'comment'
" used only at top-level, never inside 'blocks'
hi link   nft_add_cmd_set_block_comment_spec_keyword_comment nftHL_Statement
syn match nft_add_cmd_set_block_comment_spec_keyword_comment '\vcomment' skipwhite contained
\ nextgroup=
\   nft_add_cmd_set_block_comment_spec_string_quoted_double,
\   nft_Error

" base_cmd add_cmd 'set' set_spec '{' set_block '}'
hi link    nft_add_cmd_set_block nftHL_BlockDelimitersSet
syn region nft_add_cmd_set_block start="{" end="}" skipwhite contained
\ contains=
\    nft_add_cmd_set_block_gc_interval,
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_counter_stmt_keyword_counter,
\    nft_add_cmd_set_block_automerge,
\    nft_add_cmd_set_block_elements,
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_add_cmd_set_block_comment_spec_keyword_comment,
\    nft_common_block_keyword_include,
\    nft_add_cmd_set_block_timeout,
\    nft_common_block_keyword_define,
\    nft_add_cmd_set_block_set_mechanism_policy,
\    nft_add_cmd_set_block_typeof_key_expr_keyword_typeof,
\    nft_common_block_keyword_error,
\    nft_add_cmd_set_block_flags,
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_limit_stmt_keyword_limit,
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_quota_stmt_keyword_quota,
\    undefined_set_mechanism,
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_last_stmt_keyword_last,
\    nft_add_cmd_set_block_set_mechanism_size,
\    nft_add_cmd_set_block_typeof_key_expr_keyword_type,
\    nft_comment_inline,
\    nft_add_cmd_set_block_separator
\ nextgroup=
\    nft_comment_inline,
\    nft_line_stmt_separator

" ************* BEGIN set_spec 'set' ('add'|'clean') ***************
" base_cmd 'reset' [ 'set' | 'map' ] table_id spec_id '$'identifier
hi link   nft_add_cmd_set_block_expr_variable_expr nftHL_Position
syn match nft_add_cmd_set_block_expr_variable_expr "\v\$[a-zA-Z][a-zA-Z0-9_\-]{0,31}" contained
\ nextgroup=
\    nft_Semicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd add_cmd 'set' set_spec set_identifier
" set_identifier->'set'->add_cmd->base_cmd->line
hi link   nft_add_cmd_keyword_set_set_spec_set_id nftHL_Identifier
syn match nft_add_cmd_keyword_set_set_spec_set_id "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze[ \t\n;]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_set_block,
\    nft_line_separator,
\    nft_add_cmd_set_block_expr_variable_expr,


" base_cmd add_cmd 'set' set_spec table_spec family_spec identifier (table)
hi link   nft_add_cmd_keyword_set_cmd_set_spec_table_spec_family_spec_table_id nftHL_Table
syn match nft_add_cmd_keyword_set_cmd_set_spec_table_spec_family_spec_table_id "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_set_id,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedEOS,

" base_cmd add_cmd 'set' set_spec table_spec family_spec family_spec_explicit (table)
hi link   nft_add_cmd_keyword_set_set_spec_table_spec_family_spec_family_spec_explicit nftHL_Family
syn match nft_add_cmd_keyword_set_set_spec_table_spec_family_spec_family_spec_explicit skipwhite contained
\ "\v(ip(6)?|inet|arp|bridge|netdev)"
\ nextgroup=
\    nft_add_cmd_keyword_set_cmd_set_spec_table_spec_family_spec_table_id,
\    nft_UnexpectedEOS,

" base_cmd [ 'add' ] 'set' set_spec table_spec
syn cluster nft_c_add_cmd_keyword_set_set_spec_table_spec
\ contains=
\    nft_add_cmd_keyword_set_set_spec_table_spec_family_spec_family_spec_explicit,
\    nft_add_cmd_keyword_set_cmd_set_spec_table_spec_family_spec_table_id

" base_cmd [ 'add' ] 'set' set_spec
syn cluster nft_c_add_cmd_keyword_set_set_spec
\ contains=@nft_c_add_cmd_keyword_set_set_spec_table_spec
" ************* END set_spec 'set' ('add'|'clean') ***************

" 'set'->add_cmd->base_cmd->line
hi link   nft_base_cmd_keyword_set nftHL_Command
syn match nft_base_cmd_keyword_set "set\>" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_table_spec_family_spec_family_spec_explicit,
\    nft_add_cmd_keyword_set_cmd_set_spec_table_spec_family_spec_table_id,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedSemicolon

" do not add ^ regex to nft_base_cmd_add_cmd_keyword_set, already done by nft_line
" 'set'->add_cmd->'add'->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_set nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_set "set" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_table_spec_family_spec_family_spec_explicit,
\    nft_add_cmd_keyword_set_cmd_set_spec_table_spec_family_spec_table_id,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS
" do not add ^ regex to nft_base_cmd_add_cmd_keyword_set, already done by nft_line
" ******************** END set_cmd ************************

  for s:this_semantic_file in s:add_set_cmd_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded add_set_cmd for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define add_set_cmd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_add_set_cmd = v:true
