" File: set_block.vim
" Directory: custom/nftables/
" TODO: Replace 'set_block' with filename of this script
"
let s:set_block_list_filepaths_semantic_early = []
let s:set_block_list_filepaths_semantic_later = []

if exists('b:did_nftables_set_block')
  call nftables#syntax#log('INFO', 'Skipped set_block (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:set_block_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading set_block syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here


" ************* BEGIN table_block 'set' set_block ***************

hi link   nft_set_block_separator nftHL_Separator
syn match nft_set_block_separator /;/ skipwhite contained
\ nextgroup=
\    nft_comment_inline



" base_cmd add_cmd 'set' set_spec '{' set_block 'flags' set_flag_list set_flag ','
hi link   nft_set_block_set_flag_list_comma nftHL_Operator
syn match nft_set_block_set_flag_list_comma ',' skipwhite contained
\ nextgroup=
\    @nft_c_set_block_set_flag_list

" base_cmd add_cmd 'set' set_spec '{' set_block 'flags' set_flag_list set_flag
hi link   nft_set_block_set_flag_list_item nftHL_Keyword
syn match nft_set_block_set_flag_list_item skipwhite contained
\ '\v(auto\-merge|constant|interval|timeout|dynamic)'
\ nextgroup=
\    nft_set_block_set_flag_list_comma,
\    nft_set_block_separator

" base_cmd add_cmd 'set' set_spec '{' set_block 'flags' set_flag_list
syn cluster nft_c_set_block_set_flag_list
\ contains=
\    nft_set_block_set_flag_list_item

" base_cmd add_cmd 'set' set_spec '{' set_block 'flags'
hi link   nft_set_block_keyword_flags nftHL_Command
syn match nft_set_block_keyword_flags 'flags' skipwhite contained
\ nextgroup=
\    @nft_c_set_block_set_flag_list


" base_cmd add_cmd 'set' set_spec '{' set_block 'timeout'/'gc-interval' time_spec
hi link   nft_set_block_time_spec nftHL_Number
syn match nft_set_block_time_spec '\v[a-zA-Z0-9_\:]{1,31}' skipwhite contained
\ nextgroup=
\    nft_set_block_separator

" base_cmd add_cmd 'set' set_spec '{' set_block 'timeout'
hi link   nft_set_block_keyword_timeout nftHL_Command
syn match nft_set_block_keyword_timeout 'timeout' skipwhite contained
\ nextgroup=
\    nft_set_block_time_spec

" base_cmd add_cmd 'set' set_spec '{' set_block 'gc-interval'
hi link   nft_set_block_keyword_gc_interval nftHL_Command
syn match nft_set_block_keyword_gc_interval '\vgc\-interval' skipwhite contained
\ nextgroup=
\    nft_set_block_time_spec

" unused nft_add_cmd_set_block_elements_set_block_semicolon
hi link   nft_set_block_set_block_expr_set_expr_comma nftHL_Operator
syn match nft_set_block_set_block_expr_set_expr_comma /,/ skipwhite contained

hi link    nft_set_block_set_block_expr_set_expr nftHL_BlockDelimitersMap
syn region nft_set_block_set_block_expr_set_expr start=+{+ end=+}+ skipnl skipwhite contained
\ contains=
\    nft_set_block_set_block_expr_set_expr_comma,
\    nft_set_expr

hi link   nft_set_block_set_block_expr_variable_expr nftHL_Variable
syn match nft_set_block_set_block_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_set_block_separator,
\    nft_EOS

" base_cmd add_cmd 'set' set_spec '{' set_block 'elements' '='
hi link   nft_set_block_keyword_elements_set_block_expr_equal nftHL_Operator
syn match nft_set_block_keyword_elements_set_block_expr_equal '\v\=' skipwhite contained
\ nextgroup=
\    nft_set_block_set_block_expr_set_expr,
\    nft_set_block_set_block_expr_variable_expr,
\    nft_Error

" base_cmd add_cmd 'set' set_spec '{' set_block 'elements'
hi link   nft_set_block_keyword_elements nftHL_Command
syn match nft_set_block_keyword_elements '\velements\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_keyword_elements_set_block_expr_equal

" base_cmd add_cmd 'set' set_spec '{' set_block 'automerge'
hi link   nft_set_block_keyword_automerge nftHL_Command
syn match nft_set_block_keyword_automerge 'auto\-merge' skipwhite contained
\ nextgroup=
\    nft_set_block_separator

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism 'size' <NUM>
hi link   nft_set_block_set_mechanism_size_num nftHL_Integer
syn match nft_set_block_set_mechanism_size_num '\v[0-9]{1,32}' skipwhite contained
\ nextgroup=
\    nft_set_block_separator,
\    nft_comment_inline

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism 'size'
hi link   nft_set_block_set_mechanism_keyword_size nftHL_Command
syn match nft_set_block_set_mechanism_keyword_size '\v^\s{0,36}size' skipwhite contained
\ nextgroup=
\    nft_set_block_set_mechanism_size_num


" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism 'policy' 'memory'
hi link   nft_set_block_set_mechanism_set_policy_spec_keyword_memory nftHL_Keyword
syn match nft_set_block_set_mechanism_set_policy_spec_keyword_memory 'memory' skipwhite contained
\ nextgroup=
\    nft_set_block_separator

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism 'policy' 'performance'
hi link   nft_set_block_set_mechanism_set_policy_spec_keyword_performance nftHL_Keyword
syn match nft_set_block_set_mechanism_set_policy_spec_keyword_performance 'performance' skipwhite contained
\ nextgroup=
\    nft_set_block_separator

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism 'policy'
hi link   nft_set_block_set_mechanism_keyword_policy nftHL_Command
syn match nft_set_block_set_mechanism_keyword_policy 'policy' skipwhite contained
\ nextgroup=
\    nft_set_block_set_mechanism_set_policy_spec_keyword_memory,
\    nft_set_block_set_mechanism_set_policy_spec_keyword_performance,
\    nft_Error

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism
syn cluster nft_c_add_cmd_table_block_set_block_set_mechanism
\ contains=
\    nft_set_block_set_mechanism_keyword_size,
\    nft_set_block_set_mechanism_keyword_policy

hi link   nft_set_block_comment_spec_string_content nftHL_Comment
syn match nft_set_block_comment_spec_string_content '\v[a-zA-Z0-9 ]{1,64}' skipwhite contained

hi link    nft_set_block_comment_spec_comment_content nftHL_Comment
syn region nft_set_block_comment_spec_comment_content start='\"' end='\"' skip='\\\"' skipwhite contained
\ contains=
\    nft_set_block_comment_spec_string_content

hi link   nft_set_block_comment_spec_keyword_comment nftHL_Statement
syn match nft_set_block_comment_spec_keyword_comment '\vcomment' skipwhite contained
\ nextgroup=
\    nft_set_block_comment_spec_comment_content,
\    nft_Error

hi link    nft_set_block_set_block_expr_set_expr_block nftHL_BlockDelimitersSet
syn region nft_set_block_set_block_expr_set_expr_block start=+{+ end=+}+ skip='\\{' skipwhite contained
\ contains=
\    nft_set_expr

hi link   nft_set_block_set_block_expr_variable_expr nftHL_Variable
syn match nft_set_block_set_block_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_set_block_keyword_elements_operator_equal nftHL_Operator
syn match nft_set_block_keyword_elements_operator_equal '\v\=' skipwhite contained
\ nextgroup=
\    nft_set_block_set_block_expr_set_expr_block,
\    nft_set_block_set_block_expr_variable_expr,
\    nft_Error

hi link   nft_set_block_keyword_elements nftHL_Command
syn match nft_set_block_keyword_elements '\velements\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_block_keyword_elements_operator_equal,
\    nft_Error


" base_cmd add_cmd 'table' table_block 'set' identifier '{' set_block '}'
hi link    nft_set_block_delimiters nftHL_BlockDelimitersSet
syn region nft_set_block_delimiters start=+{+ end=+}+ skip='\\{' skipnl skipempty skipwhite contained
\ contains=
\    nft_set_block_keyword_gc_interval,
\    nft_set_block_keyword_automerge,
\    nft_set_block_keyword_elements,
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_set_block_comment_spec_keyword_comment,
\    nft_set_block_stateful_stmt_list_stmt_stateful_stmt_counter_stmt_keyword_counter,
\    nft_common_block_keyword_include,
\    nft_set_block_keyword_timeout,
\    nft_common_block_keyword_define,
\    nft_set_block_set_mechanism_keyword_policy,
\    nft_set_block_typeof_key_expr_keyword_typeof,
\    nft_set_block_stateful_stmt_list_stmt_stateful_stmt_limit_stmt_keyword_limit,
\    nft_set_block_stateful_stmt_list_stmt_stateful_stmt_quota_stmt_keyword_quota,
\    nft_set_block_keyword_flags,
\    nft_set_block_set_mechanism_keyword_size,
\    nft_set_block_typeof_key_expr_keyword_type,
\    nft_set_block_stateful_stmt_list_stmt_stateful_stmt_connlimit_stmt_keyword_ct,
\    nft_comment_inline
\ nextgroup=
\    nft_table_block_stmt_separator

" base_cmd add_cmd 'table' table_block 'set' identifier
hi link   nft_add_cmd_table_block_keyword_set_identifier nftHL_Identifier
syn match nft_add_cmd_table_block_keyword_set_identifier '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_set_block_delimiters

" base_cmd add_cmd 'table' table_block 'set'
hi link   nft_add_cmd_table_block_keyword_set nftHL_Command
syn match nft_add_cmd_table_block_keyword_set 'set' skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_keyword_set_identifier,

" ************* END table_block 'set' set_block ***************


  for s:this_semantic_file in s:set_block_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded set_block for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define set_block.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_set_block = v:true
