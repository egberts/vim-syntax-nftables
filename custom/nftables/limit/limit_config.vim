

" limit_burst_bytes
" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst' <NUM> ('bytes'|'string')
" 'bytes'->limit_burst_bytes->limit_config
hi link   nft_add_cmd_keyword_limit_limit_config_limit_burst_pkts_limit_pkts_keyword_pkts nftHL_Keyword
syn match nft_add_cmd_keyword_limit_limit_config_limit_burst_pkts_limit_pkts_keyword_pkts "\vpackets" skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error

" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst' <NUM>
" num->limit_burst_pkts->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_keyword_limit_limit_config_limit_burst_pkts_limit_pkts_num nftHL_Number
syn match nft_add_cmd_keyword_limit_limit_config_limit_burst_pkts_limit_pkts_num "\v[0-9]{1,20}\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_limit_burst_pkts_limit_pkts_keyword_pkts,
\    nft_UnexpectedEOS,
\    nft_Error

" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst'
" 'burst'->limit_burst_pkts->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_keyword_limit_limit_config_limit_burst_pkts_keyword_burst nftHL_Command
syn match nft_add_cmd_keyword_limit_limit_config_limit_burst_pkts_keyword_burst "\vburst\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_limit_burst_pkts_limit_pkts_num,
\    nft_Error


hi link   nft_add_cmd_keyword_limit_limit_config_limit_rate_pkts_time_unit nftHL_Unit
syn match nft_add_cmd_keyword_limit_limit_config_limit_rate_pkts_time_unit "\v(second|minute|hour|day|week)[s]?" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_limit_burst_pkts_keyword_burst,
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Errror

" limit_rate_bytes
" 'rate' [ 'over'|'until' ] <NUM> 'bytes' '/'
" '/'->limit_rate_bytes->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_keyword_limit_limit_config_limit_rate_pkts_expression_slash nftHL_Expression
syn match nft_add_cmd_keyword_limit_limit_config_limit_rate_pkts_expression_slash "/" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_limit_rate_pkts_time_unit,
\    nft_UnexpectedEOS,
\    nft_Error

" limit_burst_bytes
" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst' <NUM> ('bytes'|'string')
" 'bytes'->limit_burst_bytes->limit_config
hi link   nft_limit_config_limit_burst_bytes_limit_bytes_keyword_bytes nftHL_Unit
syn match nft_limit_config_limit_burst_bytes_limit_bytes_keyword_bytes "\v(pbyte|gbyte|mbyte|kbyte|byte)s" skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error

" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst' <NUM>
" num->limit_burst_bytes->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_limit_config_limit_burst_bytes_limit_bytes_num nftHL_Number
syn match nft_limit_config_limit_burst_bytes_limit_bytes_num "\v[0-9]{1,10}\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_limit_config_limit_burst_bytes_limit_bytes_keyword_bytes,
\    nft_Error

" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst'
" 'burst'->limit_burst_bytes->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_limit_config_limit_burst_bytes_keyword_burst nftHL_Command
syn match nft_limit_config_limit_burst_bytes_keyword_burst "\vburst\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_limit_config_limit_burst_bytes_limit_bytes_num,
\    nft_Error

hi link   nft_add_cmd_keyword_limit_limit_config_limit_rate_bytes_time_unit nftHL_Unit
syn match nft_add_cmd_keyword_limit_limit_config_limit_rate_bytes_time_unit "\v(second|minute|hour|day|week)[s]?" skipwhite contained
\ nextgroup=
\    nft_limit_config_limit_burst_bytes_keyword_burst,
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error

hi link   nft_add_cmd_keyword_limit_limit_config_limit_rate_bytes_expression_slash nftHL_Expression
syn match nft_add_cmd_keyword_limit_limit_config_limit_rate_bytes_expression_slash "/" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_limit_rate_bytes_time_unit

" 'limit' 'rate' [ 'over'|'until' ] <NUM> 'string'
" 'string'->limit_rate_bytes->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_keyword_limit_limit_config_limit_rate_bytes_keyword_string nftHL_Unit
syn match nft_add_cmd_keyword_limit_limit_config_limit_rate_bytes_keyword_string "\v(kbyte|mbyte|gbyte|pbyte|byte)s" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_limit_rate_bytes_expression_slash,
\    nft_EOS

" 'limit' 'rate' [ 'over'|'until' ] <NUM>
" <num>->*->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_keyword_limit_limit_config_limit_rate_pktsbytes_num nftHL_Number
syn match nft_add_cmd_keyword_limit_limit_config_limit_rate_pktsbytes_num "\v[0-9]{1,10}\ze[ \t\/]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_limit_rate_bytes_keyword_string,
\    nft_add_cmd_keyword_limit_limit_config_limit_rate_pkts_expression_slash,
\    nft_UnexpectedEOS,
\    nft_Error

" '[add] limit rate [ over|until ]
" limit_mode->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_keyword_limit_limit_config_limit_mode nftHL_Keyword
syn match nft_add_cmd_keyword_limit_limit_config_limit_mode "\v(over|until)\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_limit_rate_pktsbytes_num,
\    nft_Error

" '[add] limit rate'
hi link   nft_add_cmd_keyword_limit_limit_config_keyword_rate nftHL_Statement
syn match nft_add_cmd_keyword_limit_limit_config_keyword_rate "\vrate\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_limit_mode,
\    nft_add_cmd_keyword_limit_limit_config_limit_rate_pktsbytes_num,
\    nft_Error

