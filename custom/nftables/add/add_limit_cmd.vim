" File: template_name.vim
" Directory: custom/nftables/table/add/
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

" 'rate' [ 'over'|'until' ]
" limit_mode->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_keyword_limit_limit_config_limit_mode nftHL_Keyword
syn match nft_add_cmd_keyword_limit_limit_config_limit_mode "\v(over|until)\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_limit_rate_pktsbytes_num,
\    nft_Error

hi link   nft_add_cmd_keyword_limit_limit_config_keyword_rate nftHL_Statement
syn match nft_add_cmd_keyword_limit_limit_config_keyword_rate "\vrate\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_limit_mode,
\    nft_add_cmd_keyword_limit_limit_config_limit_rate_pktsbytes_num,
\    nft_Error

" base_cmd_add_cmd 'limit' <table_id> <limit_id> limit_block
hi link    nft_add_cmd_limit_limit_block nftHL_BlockDelimitersLimit
syn region nft_add_cmd_limit_limit_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_comment_spec_keyword_comment,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_add_cmd_keyword_limit_limit_config_keyword_rate,
\    nft_Error
\ nextgroup=nft_line_separator

" base_cmd add_cmd 'limit' <table_id> <limit_id>
hi link   nft_add_cmd_keyword_limit_obj_spec_identifier nftHL_Identifier
syn match nft_add_cmd_keyword_limit_obj_spec_identifier "\v[A-Za-z][A-Za-z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_keyword_rate,
\    nft_add_cmd_limit_limit_block,
\    nft_Error
" TODO: limit_block
" TODO: undefined nft_add_cmd_limit_limit_block

" base_cmd add_cmd 'limit' table_spec
hi link   nft_add_cmd_keyword_limit_obj_spec_table_spec_identifier nftHL_Identifier
syn match nft_add_cmd_keyword_limit_obj_spec_table_spec_identifier "\v[A-Za-z][A-Za-z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_obj_spec_identifier

" base_cmd add_cmd 'limit' ('ip'|'ip6'|'inet'|'arp'|'bridge'|'netdev')
" base_cmd add_cmd 'limit' family_spec
hi link   nft_add_cmd_keyword_limit_obj_spec_family_spec nftHL_Family
syn match nft_add_cmd_keyword_limit_obj_spec_family_spec "\v(bridge|netdev|inet|arp|ip6|ip)" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_obj_spec_table_spec_identifier

" base_cmd 'add' add_cmd 'limit'
hi link   nft_base_cmd_add_cmd_keyword_limit nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_limit "\vlimit\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_obj_spec_family_spec,
\    nft_add_cmd_keyword_limit_obj_spec_table_spec_identifier

hi link   nft_add_cmd_table_block_limit_block_separator nftHL_Separator
syn match nft_add_cmd_table_block_limit_block_separator /;/ skipwhite contained

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
