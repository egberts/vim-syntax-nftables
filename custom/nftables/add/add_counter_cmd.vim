" File: add_counter_cmd.vim
" Directory: custom/nftables/
"
let s:add_counter_cmd_list_filepaths_semantic_early = []
let s:add_counter_cmd_list_filepaths_semantic_later = []

if exists('b:did_nftables_add_counter_cmd')
  call nftables#syntax#log('INFO', 'Skipped add_counter_cmd (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:add_counter_cmd_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading add_counter_cmd syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

" ************************* BEGIN counter_cmd' *************************
"**** BEGIN OF add_cmd_/'counter'/obj_spec *****
hi link   nft_add_cmd_keyword_counter_block_stmt_separator nftHL_Separator
syn match nft_add_cmd_keyword_counter_block_stmt_separator '\v(\n|;)' skipwhite contained

" add_cmd 'counter' obj_spec counter_config 'packet' <packet_num> 'bytes' <integer>
hi link   nft_add_cmd_keyword_counter_counter_config_bytes_num nftHL_Number
syn match nft_add_cmd_keyword_counter_counter_config_bytes_num '\v[0-9]{1,10}\ze(([ \t;])|($))' skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_Error

" add_cmd 'counter' obj_spec counter_config 'packet' <packet_num> 'bytes'
hi link   nft_add_cmd_keyword_counter_counter_config_bytes nftHL_Unit
syn match nft_add_cmd_keyword_counter_counter_config_bytes '\vbytes\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_config_bytes_num,
\    nft_Error

" add_cmd 'counter' obj_spec counter_config 'packet' <packet_num>
hi link   nft_add_cmd_keyword_counter_counter_config_packet_num nftHL_Number
syn match nft_add_cmd_keyword_counter_counter_config_packet_num '\v[0-9]{1,10}\ze(([ \t])|($))' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_config_bytes,
\    nft_Error

" add_cmd 'counter' obj_spec counter_config obj_id 'packet'
hi link   nft_add_cmd_keyword_counter_counter_config_keyword_packets nftHL_Keyword
syn match nft_add_cmd_keyword_counter_counter_config_keyword_packets '\vpackets\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_config_packet_num,
\    nft_Error

" add_cmd 'counter' obj_spec counter_config 'packet' <packet_num> 'bytes' <integer>
hi link   nft_add_cmd_keyword_counter_block_counter_block_counter_config_bytes_num nftHL_Number
syn match nft_add_cmd_keyword_counter_block_counter_block_counter_config_bytes_num '\v[0-9]{1,10}\ze[ \t;\}\n]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_block_stmt_separator,
\    nft_Error

" add_cmd 'counter' obj_spec counter_config 'packet' <packet_num> 'bytes'
hi link   nft_add_cmd_keyword_counter_counter_block_counter_config_bytes nftHL_Keyword
syn match nft_add_cmd_keyword_counter_counter_block_counter_config_bytes '\vbytes\ze[ \t]' skipwhite contained
\ nextgroup=
\   nft_add_cmd_keyword_counter_block_counter_block_counter_config_bytes_num,
\   nft_Error

" add_cmd 'counter' obj_spec counter_config 'packet' <packet_num>
hi link   nft_add_cmd_keyword_counter_counter_block_counter_config_packet_num nftHL_Number
syn match nft_add_cmd_keyword_counter_counter_block_counter_config_packet_num '\v[0-9]{1,10}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_block_counter_config_bytes,
\    nft_Error

hi link   nft_add_cmd_counter_block_Error_Always nftHL_Error
syn match nft_add_cmd_counter_block_Error_Always '\v\i{1,15}' skipwhite contained

" add_cmd 'counter' obj_spec counter_config obj_id 'packet'
hi link   nft_add_cmd_keyword_counter_counter_block_counter_counter_config_keyword_packets nftHL_Keyword
syn match nft_add_cmd_keyword_counter_counter_block_counter_counter_config_keyword_packets '\vpackets\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_block_counter_config_packet_num,
\    nft_Error


" base_cmd add_cmd 'set' set_spec '{' set_block 'comment' comment_spec QUOTED_STRING
hi link    nft_add_cmd_keyword_counter_counter_block_comment_string_quoted_double nftHL_Comment
syn region nft_add_cmd_keyword_counter_counter_block_comment_string_quoted_double start='"' end='"' skip='\\\"' keepend oneline skipwhite contained
\ nextgroup=
\    nft_String,
\    nft_Error

" base_cmd add_cmd 'set' set_spec '{' set_block 'comment'
hi link   nft_add_cmd_keyword_counter_counter_block_comment_spec nftHL_Comment
syn match nft_add_cmd_keyword_counter_counter_block_comment_spec '\vcomment\ze[ \t]' skipwhite contained
\ nextgroup=
\   nft_add_cmd_keyword_counter_counter_block_comment_string_quoted_double

" add_cmd 'counter' obj_spec '{' counter_block '}'
hi link    nft_add_cmd_keyword_counter_counter_block nftHL_BlockDelimitersCounter
syn region nft_add_cmd_keyword_counter_counter_block start=/{/ end=/}/ skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error
\ contains=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_add_cmd_keyword_counter_counter_block_comment_spec,
\    nft_add_cmd_keyword_counter_counter_block_counter_counter_config_keyword_packets,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_comment_inline,
\    nft_add_cmd_keyword_counter_block_stmt_separator,
\    nft_Error

" add_cmd 'counter' table_identifier [ obj_id | 'last' ]
hi link   nft_add_cmd_counter_obj_spec_obj_id nftHL_Identifier
syn match nft_add_cmd_counter_obj_spec_obj_id '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze(([ \t])|($))' skipnl skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_config_keyword_packets,
\    nft_add_cmd_keyword_counter_counter_block,
\    nft_line_stmt_separator,
\    nft_Error

hi link   nft_add_cmd_counter_Semicolon nftHL_Normal
syn match nft_add_cmd_counter_Semicolon contained '\v\s{0,8};' skipwhite contained
\ nextgroup=
\    nft_EOL,
\    nft_comment_inline

hi link   nft_add_cmd_counter_last_Error_Always nftHL_Error
syn match nft_add_cmd_counter_last_Error_Always '\v\i{1,15}' skipwhite contained

hi link   nft_add_cmd_keyword_counter_obj_spec_identifier_last nftHL_Keyword
syn match nft_add_cmd_keyword_counter_obj_spec_identifier_last '\vlast\ze(([ \t])|($))' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_block,
\    nft_add_cmd_keyword_counter_counter_config_keyword_packets,
\    nft_line_stmt_separator

" add_cmd 'counter' obj_spec obj_id table_spec table_id
hi link   nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id nftHL_Identifier
syn match nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_obj_spec_identifier_last,
\    nft_add_cmd_counter_obj_spec_obj_id,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" _add_ to make 'chain_spec' pathway unique
hi link   nft_add_cmd_keyword_counter_obj_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_add_cmd_keyword_counter_obj_spec_table_spec_family_spec_explicit '\v(bridge|netdev|inet|arp|ip6|ip)' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" base_cmd add_cmd 'counter' obj_spec
syn cluster nft_c_add_cmd_keyword_counter_obj_spec
\ contains=
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_family_spec_explicit,
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id,

" 'counter'->objref_stmt_counter->stmt->rule_alloc->rule->add_cmd->base_cmd->line
syn match nft_add_cmd_rule_rule_alloc_stmt_counter_objref_identifier '\v[a-zA-Z_][a-zA-Z0-9_]*' contained

" 'counter'->add_cmd->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_counter nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_counter '\vcounter\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_counter_obj_spec,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS
" ***************** END base_cmd 'counter' *****************


hi link   nft_base_cmd_keyword_counter_keyword_table_obj_spec_obj_id nftHL_Identifier
syn match nft_base_cmd_keyword_counter_keyword_table_obj_spec_obj_id '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze(([ \t;])|($))' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_config_keyword_packets,
\    nft_add_cmd_keyword_counter_counter_block,
\    nft_line_stmt_separator,
\    nft_Error

hi link   nft_base_cmd_keyword_counter_keyword_table_Semicolon nftHL_Normal
syn match nft_base_cmd_keyword_counter_keyword_table_Semicolon contained '\v\s{0,8};' skipwhite contained
\ nextgroup=
\    nft_EOL,
\    nft_comment_inline

hi link   nft_base_cmd_keyword_counter_keyword_table_last_Error_Always nftHL_Error
syn match nft_base_cmd_keyword_counter_keyword_table_last_Error_Always '\v\i{1,15}' skipwhite contained

syn cluster nft_c_add_cmd_keyword_counter_obj_spec_obj_last
\ contains=
\    nft_add_cmd_keyword_counter_counter_block,
\    nft_add_cmd_keyword_counter_counter_config_keyword_packets,
\    nft_line_stmt_separator

hi link   nft_add_cmd_keyword_counter_obj_spec_identifier_last nftHL_Keyword
syn match nft_add_cmd_keyword_counter_obj_spec_identifier_last 'last' skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_counter_obj_spec_obj_last

" add_cmd 'counter' obj_spec obj_id table_spec table_id
hi link   nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id nftHL_Identifier
syn match nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_obj_spec_identifier_last,
\    nft_base_cmd_keyword_counter_keyword_table_obj_spec_obj_id,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" _add_ to make 'chain_spec' pathway unique
hi link   nft_add_cmd_keyword_counter_obj_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_add_cmd_keyword_counter_obj_spec_table_spec_family_spec_explicit '\v(bridge|netdev|inet|arp|ip6|ip)' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" base_cmd add_cmd 'counter' obj_spec
syn cluster nft_c_add_cmd_keyword_counter_obj_spec
\ contains=
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_family_spec_explicit,
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id,

" 'counter'->add_cmd->base_cmd->line
hi link   nft_add_cmd_counter_keyword_table nftHL_Command
syn match nft_add_cmd_counter_keyword_table '\vtable\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_counter_obj_spec,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOSA

  for s:this_semantic_file in s:add_counter_cmd_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded add_counter_cmd for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define add_counter_cmd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_add_counter_cmd = v:true
