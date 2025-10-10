" File: add_synproxy_cmd.vim
" Directory: custom/nftables/add/
"
let s:add_synproxy_cmd_list_filepaths_semantic_early = []
let s:add_synproxy_cmd_list_filepaths_semantic_later = []

if exists('b:did_nftables_add_synproxy_cmd')
  call nftables#syntax#log('INFO', 'Skipped add_synproxy_cmd (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:add_synproxy_cmd_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading add_synproxy_cmd syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "


" ************************* BEGIN synproxy_cmd' *************************
" 'mss' <NUM> 'wscale' [ 'timestamp' ] [ 'sack-perm' ]
" synproxy_sack->synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_block_synproxy_sack nftHL_Keyword
syn match nft_synproxy_block_synproxy_sack '\vsack\-perm\ze(([ \t\;])|$)' skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,

" 'mss' <NUM> 'wscale' [ 'timestamp' ]
" synproxy_ts->synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_block_synproxy_ts nftHL_Keyword
syn match nft_synproxy_block_synproxy_ts '\vtimestamp\ze(([ \t\;])|$)' skipnl skipwhite contained
\ nextgroup=
\    nft_synproxy_block_synproxy_sack,
\    nft_line_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale' <NUM>
" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_block_keyword_wscale_num nftHL_Integer
syn match nft_synproxy_block_keyword_wscale_num '\v[0-9]{1,5}\ze(([ \t\;])|$)' skipnl skipempty skipwhite contained
\ nextgroup=
\    nft_synproxy_block_synproxy_ts,
\    nft_synproxy_block_synproxy_sack,
\    nft_line_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale'
" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_block_keyword_wscale nftHL_Statement
syn match nft_synproxy_block_keyword_wscale '\vwscale\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_synproxy_block_keyword_wscale_num,
\    nft_Error


hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale_stmt_separator nftHL_Separator
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale_stmt_separator /;/ skipnl skipwhite contained
\ nextgroup=
\    nft_synproxy_block_synproxy_ts,
\    nft_synproxy_block_synproxy_sack,
\    nft_EOS,
\    nft_Error

" 'mss' <NUM> 'wscale' <NUM>
" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale_num nftHL_Integer
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale_num '\v[0-9]{1,5}\ze(([ \t\;])|$)' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale'
" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale nftHL_Statement
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale '\vwscale\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale_num




" 'mss' <NUM> 'wscale' <NUM>
" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_keyword_wscale_num nftHL_Integer
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_keyword_wscale_num '\v[0-9]{1,5}\ze(([ \t\;])|$)' skipnl skipwhite contained
\ nextgroup=
\    nft_synproxy_block_synproxy_ts,
\    nft_synproxy_block_synproxy_sack,
\    nft_line_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale'
" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_keyword_wscale nftHL_Statement
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_keyword_wscale '\vwscale\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_keyword_wscale_num,
\    nft_Error

hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_stmt_separator nftHL_Separator
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_stmt_separator /;/ skipnl skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale,
\    nft_Error

" 'mss' <NUM>
" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_num nftHL_Integer
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_num '\v[0-9]{1,5}\ze(([ \t\;])|$)' skipnl skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_keyword_wscale,
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_stmt_separator,
\    nft_Error

" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss nftHL_Command
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss '\vmss\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_num,
\    nft_Error

" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss nftHL_Command
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss '\vmss\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_num,
\    nft_Error

hi link    nft_add_cmd_keyword_synproxy_synproxy_block nftHL_Delimiters
syn region nft_add_cmd_keyword_synproxy_synproxy_block start=+{+ end=+}+ skip='\\\}' contained
\ contains=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss,
\    nft_line_stmt_separator,
\    nft_InlineComment

" 'mss' <NUM> 'wscale' [ 'timestamp' ] [ 'sack-perm' ]
" synproxy_sack->synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_config_synproxy_sack nftHL_Keyword
syn match nft_synproxy_config_synproxy_sack '\vsack\-perm\ze(([ \t\;])|$)' skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,

" 'mss' <NUM> 'wscale' [ 'timestamp' ]
" synproxy_ts->synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_config_synproxy_ts nftHL_Keyword
syn match nft_synproxy_config_synproxy_ts '\vtimestamp\ze(([ \t\;])|$)' skipwhite contained
\ nextgroup=
\    nft_synproxy_config_synproxy_sack,
\    nft_line_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale' <NUM>
" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_config_keyword_wscale_num nftHL_Integer
syn match nft_synproxy_config_keyword_wscale_num '\v[0-9]{1,5}\ze(([ \t\;])|$)' skipwhite contained
\ nextgroup=
\    nft_synproxy_config_synproxy_ts,
\    nft_synproxy_config_synproxy_sack,
\    nft_line_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale'
" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_config_keyword_wscale nftHL_Statement
syn match nft_synproxy_config_keyword_wscale '\vwscale[ \t]' skipwhite contained
\ nextgroup=
\    nft_synproxy_config_keyword_wscale_num,
\    nft_Error


hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale_stmt_separator nftHL_Separator
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale_stmt_separator /;/ skipwhite contained
\ nextgroup=
\    nft_synproxy_config_synproxy_ts,
\    nft_synproxy_config_synproxy_sack,
\    nft_EOS,
\    nft_Error

" 'mss' <NUM> 'wscale' <NUM>
" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale_num nftHL_Integer
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale_num '\v[0-9]{1,5}\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale'
" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale nftHL_Statement
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale '\vwscale\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale_num

" 'mss' <NUM> 'wscale' <NUM>
" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_keyword_wscale_num nftHL_Integer
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_keyword_wscale_num '\v[0-9]{1,5}\ze(([ \t\;])|$)' skipwhite contained
\ nextgroup=
\    nft_synproxy_config_synproxy_ts,
\    nft_synproxy_config_synproxy_sack,
\    nft_line_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale'
" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_keyword_wscale nftHL_Statement
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_keyword_wscale '\vwscale\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_keyword_wscale_num,
\    nft_Error

hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_stmt_separator nftHL_Separator
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_stmt_separator /;/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale,
\    nft_Error

" 'mss' <NUM>
" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_num nftHL_Integer
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_num '\v[0-9]{1,5}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_keyword_wscale,
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_stmt_separator,
\    nft_Error

" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss nftHL_Command
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss '\vmss\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_num,
\    nft_Error

hi link   nft_add_cmd_keyword_synproxy_obj_spec_identifier nftHL_Identifier
syn match nft_add_cmd_keyword_synproxy_obj_spec_identifier '\v[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss,
\    nft_add_cmd_keyword_synproxy_synproxy_block,
\    nft_Error

hi link   nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier nftHL_Identifier
syn match nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier '\v[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_obj_spec_identifier,
\    nft_Error

hi link   nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_ip nftHL_Family
syn match nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_ip /ip/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier
hi link   nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_arp nftHL_Family
syn match nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_arp /arp/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier
hi link   nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_ip6 nftHL_Family
syn match nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_ip6 /ip6/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier
hi link   nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_inet nftHL_Family
syn match nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_inet /inet/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier
hi link   nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_netdev nftHL_Family
syn match nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_netdev /netdev/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier

hi link   nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_bridge nftHL_Family
syn match nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_bridge /bridge/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier


" 'synproxy'->add_cmd->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_synproxy nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_synproxy '\vsynproxy\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_bridge,
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_netdev,
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_inet,
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_arp,
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_ip6,
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_ip,
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS
" ************************* END synproxy_cmd' *************************A
  for s:this_semantic_file in s:add_synproxy_cmd_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded add_synproxy_cmd for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define add_synproxy_cmd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_add_synproxy_cmd = v:true
