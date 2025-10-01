" File: add_map_cmd.vim
" Directory: custom/nftables/add/
"
let s:add_map_cmd_list_filepaths_semantic_early = []
let s:add_map_cmd_list_filepaths_semantic_later = []

if exists('b:did_nftables_add_map_cmd')
  call nftables#syntax#log('INFO', 'Skipped add_map_cmd (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:add_map_cmd_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading add_map_cmd syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
" ******************** BEGIN map-related **************************
" ******************** BEGIN map_block ****************************

hi link   nft_add_cmd_map_map_spec_map_block_separator nftHL_Separator
syn match nft_add_cmd_map_map_spec_map_block_separator /;/ skipwhite contained
\ nextgroup=
\    nft_Semicolon,
\    nft_comment_inline

" base_cmd_add_cmd 'map' map_spec '{' map_block typeof_key_expr 'type' typeof_expr primary_expr
hi link   nft_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof_expr_primary_expr nftHL_Identifier
syn match nft_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof_expr_primary_expr contained
\  "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}"
" do not use 'skipwhite' here

" base_cmd_add_cmd 'map' map_spec '{' map_block typeof_key_expr 'type'  <family>
hi link   nft_add_cmd_map_map_spec_map_block_typeof_key_expr_type_data_type_expr nftHL_Keyword
syn match nft_add_cmd_map_map_spec_map_block_typeof_key_expr_type_data_type_expr "\v[a-zA-Z][a-zA-Z0-9_\-]\{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_typeof_key_expr_type_data_type_expr

" base_cmd_add_cmd 'map' map_spec '{' map_block typeof_key_expr 'type'
hi link   nft_add_cmd_map_map_spec_map_block_typeof_key_expr_type nftHL_Command
syn match nft_add_cmd_map_map_spec_map_block_typeof_key_expr_type "type\s" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_typeof_key_expr_type_data_type_expr

" base_cmd_add_cmd 'map' map_spec '{' map_block typeof_key_expr 'typeof' typeof_expr primary_expr
hi link   nft_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof_expr_primary_expr nftHL_Identifier
syn match nft_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof_expr_primary_expr contained
\  "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}(\.[a-zA-Z][a-zA-Z0-9_\-]{0,63}){0,5}" contained  " do not use 'skipwhite' here
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof_expr_primary_expr_with_dot

" base_cmd_add_cmd 'map' map_spec '{' map_block typeof_key_expr 'typeof' typeof_expr
syn cluster nft_c_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof_expr
\ contains=
\    nft_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof_expr_primary_expr

" base_cmd_add_cmd 'map' map_spec '{' map_block typeof_key_expr 'typeof'
hi link   nft_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof nftHL_Command
syn match nft_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof "typeof" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof_expr

" base_cmd_add_cmd 'map' map_spec '{' map_block typeof_key_expr
syn cluster nft_c_add_cmd_map_mamappec_map_block_typeof_key_expr
\ contains=
\    nft_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof,
\    nft_add_cmd_map_map_spec_map_block_typeof_key_expr_type


" base_cmd add_cmd 'map' map_spec '{' map_block 'flags' map_flag_list map_flag ','
hi link   nft_add_cmd_map_map_spec_map_block_flags_map_flag_list_comma nftHL_Operator
syn match nft_add_cmd_map_map_spec_map_block_flags_map_flag_list_comma "," skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_map_map_spec_map_block_map_flag_list

" base_cmd add_cmd 'map' map_spec '{' map_block 'flags' map_flag_list map_flag
hi link   nft_add_cmd_map_map_spec_map_block_flags_map_flag_list_map_flag nftHL_Keyword
syn match nft_add_cmd_map_map_spec_map_block_flags_map_flag_list_map_flag skipwhite contained
\ "\v(constant|interval|timeout|dynamic)"
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_flags_map_flag_list_comma

" base_cmd add_cmd 'map' map_spec '{' map_block 'flags' map_flag_list
syn cluster nft_c_add_cmd_map_map_spec_map_block_map_flag_list
\ contains=
\    nft_add_cmd_map_map_spec_map_block_flags_map_flag_list_map_flag

" base_cmd add_cmd 'map' map_spec '{' map_block 'flags'
hi link   nft_add_cmd_map_map_spec_map_block_flags nftHL_Command
syn match nft_add_cmd_map_map_spec_map_block_flags "flags" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_map_map_spec_map_block_map_flag_list


" base_cmd add_cmd 'map' map_spec '{' map_block 'timeout'/'gc-interval' time_spec
hi link   nft_add_cmd_map_map_spec_map_block_time_spec nftHL_Number
syn match nft_add_cmd_map_map_spec_map_block_time_spec "\v[A-Za-z0-9\-\_\:]{1,32}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_separator
" TODO clarify <time_spec>

" base_cmd add_cmd 'map' map_spec '{' map_block 'timeout'
hi link   nft_add_cmd_map_map_spec_map_block_timeout nftHL_Command
syn match nft_add_cmd_map_map_spec_map_block_timeout "\vtimeout\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_time_spec

" base_cmd add_cmd 'map' map_spec '{' map_block 'elements'
hi link   nft_add_cmd_map_map_spec_map_block_elements nftHL_Command
syn match nft_add_cmd_map_map_spec_map_block_elements "\velements\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_time_spec

" base_cmd add_cmd 'map' map_spec '{' map_block 'gc-interval'
hi link   nft_add_cmd_map_map_spec_map_block_gc_interval nftHL_Command
syn match nft_add_cmd_map_map_spec_map_block_gc_interval "\vgc\-interval" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_time_spec

hi link   nft_add_cmd_map_map_spec_map_block_elements_block_item_colon nftHL_Element
syn match nft_add_cmd_map_map_spec_map_block_elements_block_item_colon '\v:' skipwhite contained

" base_cmd add_cmd 'map' map_spec '{' map_block 'elements' '=' '{' map_block_item
hi link    nft_add_cmd_map_map_spec_map_block_elements_block_items nftHL_Element
syn match nft_add_cmd_map_map_spec_map_block_elements_block_items "\v\$[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_elements_block_item_colon

" base_cmd add_cmd 'map' map_spec '{' map_block 'elements' '=' '{' map_block_expr
hi link    nft_add_cmd_map_map_spec_map_block_elements_map_block_expr nftHL_BlockDelimitersMap
syn region nft_add_cmd_map_map_spec_map_block_elements_map_block_expr start="{" end="}" skipwhite contained
\ contains=
\    nft_add_cmd_map_map_spec_map_block_elements_block_items
\ nextgroup=
\    nft_Semicolon,
\    nft_Error

" base_cmd add_cmd 'map' map_spec '{' map_block 'elements' '='
hi link   nft_add_cmd_map_map_spec_map_block_elements_equal nftHL_Operator
syn match nft_add_cmd_map_map_spec_map_block_elements_equal "=" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_elements_map_block_expr

" base_cmd add_cmd 'map' map_spec '{' map_block 'elements'
hi link   nft_add_cmd_map_map_spec_map_block_elements nftHL_Command
syn match nft_add_cmd_map_map_spec_map_block_elements "\velements\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_elements_equal

" base_cmd add_cmd 'map' map_spec '{' map_block set_mechanism 'size' <interval>
hi link   nft_add_cmd_map_map_spec_map_block_set_mechanism_size_value nftHL_Number
syn match nft_add_cmd_map_map_spec_map_block_set_mechanism_size_value "\v[0-9]{1,32}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_separator,
\    nft_comment_inline

" base_cmd add_cmd 'map' map_spec '{' map_block set_mechanism 'size'
hi link   nft_add_cmd_map_map_spec_map_block_set_mechanism_size nftHL_Command
syn match nft_add_cmd_map_map_spec_map_block_set_mechanism_size "size" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_set_mechanism_size_value


" base_cmd add_cmd 'map' map_spec '{' map_block set_mechanism 'policy' 'memory'
hi link   nft_add_cmd_map_map_spec_map_block_set_mechanism_policy_memory nftHL_Keyword
syn match nft_add_cmd_map_map_spec_map_block_set_mechanism_policy_memory "memory" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_separator,
\    nft_comment_inline

" base_cmd add_cmd 'map' map_spec '{' map_block set_mechanism 'policy' 'performance'
hi link   nft_add_cmd_map_map_spec_map_block_set_mechanism_policy_performance nftHL_Keyword
syn match nft_add_cmd_map_map_spec_map_block_set_mechanism_policy_performance "performance" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_separator

" base_cmd add_cmd 'map' map_spec '{' map_block set_mechanism 'policy'
hi link   nft_add_cmd_map_map_spec_map_block_set_mechanism_policy nftHL_Command
syn match nft_add_cmd_map_map_spec_map_block_set_mechanism_policy "policy" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_set_mechanism_policy_memory,
\    nft_add_cmd_map_map_spec_map_block_set_mechanism_policy_performance

" base_cmd add_cmd 'map' map_spec '{' map_block set_mechanism
syn cluster nft_c_add_cmd_map_map_spec_map_block_set_mechanism
\ contains=
\    nft_add_cmd_map_map_spec_map_block_set_mechanism_size,
\    nft_add_cmd_map_map_spec_map_block_set_mechanism_policy

" base_cmd add_cmd 'map' map_spec '{' map_block 'comment' comment_spec STRING
hi link   nft_add_cmd_map_map_spec_map_block_comment_string_string nftHL_Comment
syn match nft_add_cmd_map_map_spec_map_block_comment_string_string "\v[\"\'\_\-A-Za-z0-9]{1,64}" contained

" base_cmd add_cmd 'map' map_spec '{' map_block 'comment' comment_spec QUOTED_STRING
hi link   nft_add_cmd_map_map_spec_map_block_comment_string_quoted_single nftHL_Comment
syn match nft_add_cmd_map_map_spec_map_block_comment_string_quoted_single "\v\'[\"\_\- A-Za-z0-9]{1,64}\'" contained

" base_cmd add_cmd 'map' map_spec '{' map_block 'comment' comment_spec QUOTED_STRING
hi link   nft_add_cmd_map_map_spec_map_block_comment_string_quoted_double nftHL_Comment
syn match nft_add_cmd_map_map_spec_map_block_comment_string_quoted_double "\v\"[\'\_\- A-Za-z0-9]{1,64}\"" contained

" base_cmd add_cmd 'map' map_spec '{' map_block 'comment' comment_spec ASTERISK_STRING
hi link   nft_add_cmd_map_map_spec_map_block_comment_string_asterisk nftHL_Comment
syn match nft_add_cmd_map_map_spec_map_block_comment_string_asterisk "\v\*[\"\'\_\-A-Za-z0-9 ]{1,64}\*" contained

" base_cmd add_cmd 'map' map_spec '{' map_block 'comment' comment_spec
syn cluster nft_c_add_cmd_map_map_spec_map_block_comment_string
\ contains=
\   nft_add_cmd_map_map_spec_map_block_comment_string_asterisk,
\   nft_add_cmd_map_map_spec_map_block_comment_string_quoted_single,
\   nft_add_cmd_map_map_spec_map_block_comment_string_quoted_double,
\   nft_add_cmd_map_map_spec_map_block_comment_string_string

" base_cmd add_cmd 'map' map_spec '{' map_block 'comment'
hi link   nft_add_cmd_map_map_spec_map_block_comment_spec nftHL_Comment
syn match nft_add_cmd_map_map_spec_map_block_comment_spec "comment" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_map_map_spec_map_block_comment_string



" base_cmd add_cmd 'map' map_spec '{' map_block '}'
hi link    nft_add_cmd_map_map_spec_map_block nftHL_BlockDelimitersMap
syn region nft_add_cmd_map_map_spec_map_block start="{" end="}" skipnl skipempty skipwhite contained
\ contains=
\    nft_add_cmd_map_map_spec_map_block_timeout,
\    nft_add_cmd_map_map_spec_map_block_gc_interval,
\    nft_add_cmd_map_map_spec_map_block_flags,
\    @nft_c_stateful_stmt,
\    nft_add_cmd_map_map_spec_map_block_comment_spec,
\    @nft_c_add_cmd_map_map_spec_map_block_set_mechanism,
\    @nft_c_add_cmd_map_map_spec_map_block_typeof_key_expr,
\    undefined_map_map_spec_map_block_type_datatype,
\    nft_add_cmd_map_map_spec_map_block_elements,
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_comment_spec,
\    nft_add_cmd_map_map_spec_map_block_separator
\ nextgroup=
\    nft_comment_inline,
\    nft_line_stmt_separator

" base_cmd add_cmd 'map' map_spec set_identifier (chain)
hi link   nft_add_cmd_map_map_spec_identifier_set nftHL_Chain
syn match nft_add_cmd_map_map_spec_identifier_set "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block,
\    nft_UnexpectedEOS,

" base_cmd add_cmd 'map' map_spec table_spec family_spec identifier (table)
hi link   nft_add_cmd_map_map_spec_table_spec_family_spec_identifier_table nftHL_Table
syn match nft_add_cmd_map_map_spec_table_spec_family_spec_identifier_table "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_identifier_set,
\    nft_UnexpectedEOS

" base_cmd add_cmd 'map' map_spec table_spec family_spec family_spec_explicit (table)
hi link   nft_add_cmd_map_map_spec_table_spec_family_spec_family_spec_explicit nftHL_Family
syn match nft_add_cmd_map_map_spec_table_spec_family_spec_family_spec_explicit skipwhite contained
\ "\v(ip(6)?|inet|arp|bridge|netdev)"
\ nextgroup=
\    nft_add_cmd_map_map_spec_table_spec_family_spec_identifier_table,
\    nft_UnexpectedEOS

" base_cmd [ 'add' ] 'map' map_spec table_spec
syn cluster nft_c_add_cmd_map_map_spec_table_spec
\ contains=
\    nft_add_cmd_map_map_spec_table_spec_family_spec_family_spec_explicit,
\    nft_UnexpectedEOS

" base_cmd [ 'add' ] 'map' map_spec
syn cluster nft_c_add_cmd_map_map_spec
\ contains=@nft_c_add_cmd_map_map_spec_table_spec

" 'map'->add_cmd->'add'->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_map nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_map "\vmap\ze[ \t]" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_map_map_spec,
\    nft_Error

hi link   nft_base_cmd_keyword_map nftHL_Command
syn match nft_base_cmd_keyword_map "\vmap\ze " skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_map_map_spec
" do not add ^ regex to nft_base_cmd_map, already done by nft_line
" ******************** END map_block ******************************


" ***** REDUX PART TWO?
"

" **************** BEGIN set stmt_expr *******************
" unused nft_add_cmd_keyword_map_map_spec_map_block_element_map_block_semicolon
hi link   nft_chain_block_map_block_map_block_expr_elements_comma nftHL_Operator
syn match nft_chain_block_map_block_map_block_expr_elements_comma /,/ skipwhite contained

hi link    nft_chain_block_map_block_expr_map_expr nftHL_BlockDelimitersSet
syn region nft_chain_block_map_block_expr_map_expr start="{" end="}" keepend skipwhite contained
\ contains=
\    nft_chain_block_map_block_map_block_expr_elements_comma

hi link   nft_stmt_ct_stmt_set_map_stmt_expr_keyword_map nftHL_Keyword
syn match nft_stmt_ct_stmt_set_map_stmt_expr_keyword_map '\vmap' skipwhite contained
\ nextgroup=
\    nft_chain_block_map_block_expr_map_expr

hi link   nft_meta_stmt_unqualified_meta_keys nftHL_Keyword
syn match nft_meta_stmt_unqualified_meta_keys '\vmark' skipwhite contained
\ nextgroup=
\    nft_stmt_ct_stmt_set_map_stmt_expr_keyword_map

hi link   nft_stmt_meta_stmt_set_keyword_meta nftHL_Keyword
syn match nft_stmt_meta_stmt_set_keyword_meta '\vmeta' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_unqualified_meta_keys

hi link   nft_payload_stmt_ip_keywords nftHL_Keyword
syn match nft_payload_stmt_ip_keywords '\v(daddr|saddr|protocol)' skipwhite contained
\ nextgroup=
\    nft_stmt_ct_stmt_set_map_stmt_expr_keyword_map

hi link   nft_stmt_payload_stmt_set_ip_keyword_ip nftHL_Keyword
syn match nft_stmt_payload_stmt_set_ip_keyword_ip '\vip' skipwhite contained
\ nextgroup=
\    nft_payload_stmt_ip_keywords

hi link   nft_stmt_ct_stmt_set_map_stmt_expr_keys nftHL_Keyword
syn match nft_stmt_ct_stmt_set_map_stmt_expr_keys '\v(iifname|oifname|daddr|saddr|mark|iif|oif)' skipwhite contained
\ nextgroup=
\    nft_stmt_ct_stmt_set_map_stmt_expr_keyword_map,

" non-functional placeholder  nft_c_set_stmt_expr_keys
syn cluster nft_c_set_stmt_expr_keys
\ contains=
\    nft_stmt_ct_stmt_set_map_stmt_expr_keys,
\    nft_stmt_meta_stmt_set_keyword_meta,
\    nft_stmt_payload_stmt_set_ip6_keyword_ip6,
\    nft_stmt_payload_stmt_set_ip_keyword_ip,


"***************** END set stmt_expr *********************************




  for s:this_semantic_file in s:add_map_cmd_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded add_map_cmd for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define add_map_cmd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_add_map_cmd = v:true
