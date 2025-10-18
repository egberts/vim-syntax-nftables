" File: add_flowtable_cmd.vim
" Directory: custom/nftables/
"
let s:add_flowtable_cmd_list_filepaths_semantic_early = []
let s:add_flowtable_cmd_list_filepaths_semantic_later = []

if exists('b:did_nftables_add_flowtable_cmd')
  call nftables#syntax#log('INFO', 'Skipped add_flowtable_cmd (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:add_flowtable_cmd_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading add_flowtable_cmd syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "



" ***************** BEGIN 'add' 'flowtable' ***************
hi link   nft_add_cmd_flowtable_block_hook_keyword_priority_extended_int nftHL_Constant
syn match nft_add_cmd_flowtable_block_hook_keyword_priority_extended_int '\v\-?[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_flowtable_block_stmt_separator,
\    nft_Error

hi link   nft_add_cmd_flowtable_block_hook_keyword_priority_extended_var nftHL_Variable
syn match nft_add_cmd_flowtable_block_hook_keyword_priority_extended_var '\v\$[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_flowtable_block_hook_keyword_priority_extended_sign nftHL_Expression
syn match nft_flowtable_block_hook_keyword_priority_extended_sign '\v[-+]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_flowtable_block_hook_keyword_priority_extended_int

hi link   nft_add_cmd_flowtable_block_hook_keyword_priority_extended_name nftHL_Keyword
syn match nft_add_cmd_flowtable_block_hook_keyword_priority_extended_name '\v[a-zA-Z][a-zA-Z0-9]{1,16}' skipwhite contained
\ nextgroup=
\     @nft_flowtable_block_hook_keyword_priority_extended_sign

hi link   nft_add_cmd_flowtable_block_hook_keyword_priority nftHL_Keyword
syn match nft_add_cmd_flowtable_block_hook_keyword_priority '\vpriority\ze\s' skipwhite contained
\ nextgroup=
\    nft_add_cmd_flowtable_block_hook_keyword_priority_extended_int,
\    nft_add_cmd_flowtable_block_hook_keyword_priority_extended_var,
\    nft_add_cmd_flowtable_block_hook_keyword_priority_extended_name,
\    nft_Error

hi link    nft_add_cmd_flowtable_block_hook_identifier_quoted_double nftHL_Identifier
syn region nft_add_cmd_flowtable_block_hook_identifier_quoted_double start='\"' end='\"' skip='\\\"' oneline skipwhite contained
\ nextgroup=
\    nft_add_cmd_flowtable_block_hook_keyword_priority,
\    nft_Error

hi link    nft_add_cmd_flowtable_block_hook_identifier_quoted_single nftHL_Identifier
syn region nft_add_cmd_flowtable_block_hook_identifier_quoted_single start='\'' end='\'' skip='\\\'' oneline skipwhite contained
\ nextgroup=
\    nft_add_cmd_flowtable_block_hook_keyword_priority,
\    nft_Error

hi link   nft_add_cmd_flowtable_block_hook_keywords nftHL_Define
syn match nft_add_cmd_flowtable_block_hook_keywords '\v(ingress)' skipwhite contained
\ nextgroup=
\    nft_add_cmd_flowtable_block_hook_keyword_priority,
\    nft_Error

hi link   nft_add_cmd_flowtable_block_stmt_separator nftHL_Operator
syn match nft_add_cmd_flowtable_block_stmt_separator /;/ skipwhite contained

" base_cmd_add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'hook'
" base_cmd_create_cmd 'flowtable' flowtable_spec '{' flowtable_block 'hook'
" base_cmd_delete_cmd 'flowtable' flowtable_spec '{' flowtable_block 'hook'
" base_cmd_destroy_cmd 'flowtable' flowtable_spec '{' flowtable_block 'hook'
" table_block 'flowtable' flowtable_spec '{' flowtable_block 'hook'
hi link   nft_add_cmd_flowtable_block_keyword_hook nftHL_Statement
syn match nft_add_cmd_flowtable_block_keyword_hook '\vhook' skipwhite contained
\ nextgroup=
\    nft_add_cmd_flowtable_block_hook_keywords,
\    nft_Error

" base_cmd add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'flags' flowtable_flag_list flowtable_flag
hi link   nft_add_cmd_flowtable_block_flags_flowtable_flag_list_flowtable_flag nftHL_Keyword
syn match nft_add_cmd_flowtable_block_flags_flowtable_flag_list_flowtable_flag skipwhite contained
\ '\v(offload)'
\ nextgroup=
\    nft_add_cmd_flowtable_block_stmt_separator,
\    nft_CurlyBraceAheadSilent,
\    nft_Error

" base_cmd add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'flags' flowtable_flag_list
syn cluster nft_c_flowtable_block_flowtable_flag_list
\ contains=
\    nft_add_cmd_flowtable_block_flags_flowtable_flag_list_flowtable_flag

" base_cmd add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'flags'
hi link   nft_add_cmd_flowtable_block_keyword_flags nftHL_Statement
syn match nft_add_cmd_flowtable_block_keyword_flags 'flags' skipwhite contained
\ nextgroup=
\    @nft_c_flowtable_block_flowtable_flag_list,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" flowtable_block_expr->'='->'devices'->flowtable_block->'{'->'flowtable'->add_cmd->base_cmd->line

" base_cmd add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'counter'
hi link   nft_add_cmd_flowtable_block_keyword_counter nftHL_Statement
syn match nft_add_cmd_flowtable_block_keyword_counter 'counter' skipwhite contained
\ nextgroup=
\    nft_add_cmd_flowtable_block_stmt_separator,
\    nft_CurlyBraceAheadSilent,
\    nft_Error


hi link   nft_flowtable_expr_comma nftHL_Expression
syn match nft_flowtable_expr_comma /,/ skipwhite contained

hi link   nft_flowtable_expr_unquoted_string nftHL_String
syn match nft_flowtable_expr_unquoted_string '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_flowtable_expr_unquoted_identifier nftHL_Identifier
syn match nft_flowtable_expr_unquoted_identifier '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link    nft_flowtable_expr_quoted_string_single nftHL_String
syn region nft_flowtable_expr_quoted_string_single start='\'' end='\'' skip='\\\'' oneline skipwhite contained
\ contains=
\    nft_flowtable_expr_unquoted_string
\ nextgroup=
\    nft_flowtable_expr_comma

hi link    nft_flowtable_expr_quoted_string_double nftHL_String
syn region nft_flowtable_expr_quoted_string_double start='\"' end='\"' skip='\\\"' oneline skipwhite contained
\ contains=
\    nft_flowtable_expr_unquoted_string
\ nextgroup=
\    nft_flowtable_expr_comma

hi link   nft_flowtable_expr_variable_expr nftHL_Variable
syn match nft_flowtable_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_flowtable_expr_comma

syn cluster nft_c_flowtable_expr_member
\ contains=
\    nft_flowtable_expr_variable_expr,
\    nft_flowtable_expr_quoted_string_single,
\    nft_flowtable_expr_quoted_string_double,
\    nft_flowtable_expr_unquoted_identifier

hi link    nft_flowtable_expr_block nftHL_BlockDelimitersFlowtable
syn region nft_flowtable_expr_block start=/{/ end=/}/ keepend skipwhite contained
\ contains =
\    @nft_c_flowtable_expr_member

hi link   nft_flowtable_expr_variable nftHL_Variable
syn match nft_flowtable_expr_variable '\v\$[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

" [ 'add' ] 'flowtable' table_id flow_id '{' 'devices' '='
" '='->'devices'->flowtable_block->'{'->'flowtable'->add_cmd->base_cmd->line
hi link   nft_add_cmd_flowtable_block_devices_equal nftHL_Expression
syn match nft_add_cmd_flowtable_block_devices_equal /=/ skipwhite contained
\ nextgroup=
\    nft_flowtable_expr_variable,
\    nft_flowtable_expr_block,

" [ 'add' ] 'flowtable' table_id flow_id '{' 'devices'
" 'devices'->flowtable_block->'{'->'flowtable'->add_cmd->base_cmd->line
hi link   nft_add_cmd_flowtable_block_keyword_devices nftHL_Statement
syn match nft_add_cmd_flowtable_block_keyword_devices 'devices' skipwhite contained
\ nextgroup=
\    nft_add_cmd_flowtable_block_devices_equal

" ';'->flowtable_block->'{'->'flowtable'
hi link   nft_add_cmd_flowtable_block_separator nftHL_Separator
syn match nft_add_cmd_flowtable_block_separator ';' skipwhite contained
\ nextgroup=
\    @nft_c_flowtable_block

syn cluster nft_c_flowtable_block
\ contains=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_add_cmd_flowtable_block_counter,
\    nft_add_cmd_flowtable_block_devices,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_add_cmd_flowtable_block_keyword_flags,
\    nft_add_cmd_flowtable_block_keyword_hook,
\    nft_add_cmd_flowtable_block_stmt_separator,
\    nft_comment_inline


" [ 'add' ] 'flowtable' table_id flow_id '{' flowtable_block
" flowtable_block->'{'->'flowtable'->add_cmd->base_cmd->line
hi link    nft_add_cmd_keyword_flowtable_flowtable_block nftHL_BlockDelimitersFlowTable
" Can use 'keepend' if and only if there are no further nesting of blocks (what about 'elements'?)
syn region nft_add_cmd_keyword_flowtable_flowtable_block start=/{/ end=/}/ skipwhite contained
\ contains=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_add_cmd_flowtable_block_keyword_counter,
\    nft_add_cmd_flowtable_block_keyword_devices,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_add_cmd_flowtable_block_keyword_flags,
\    nft_add_cmd_flowtable_block_keyword_hook,
\    nft_add_cmd_flowtable_block_stmt_separator,
\    nft_comment_inline,
\    nft_Error
\ nextgroup=
\    nft_comment_inline,
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error

" base_cmd add_cmd 'flowtable' flowtable_spec identifier (chain)
hi link   nft_add_cmd_keyword_flowtable_flowtable_spec_identifier_flowtable nftHL_Chain
syn match nft_add_cmd_keyword_flowtable_flowtable_spec_identifier_flowtable '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze\s' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_flowtable_flowtable_block,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd add_cmd 'flowtable' flowtable_spec table_spec family_spec identifier (table)
hi link   nft_add_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_identifier_table nftHL_Table
syn match nft_add_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_identifier_table '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze\s' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_flowtable_flowtable_spec_identifier_flowtable,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd add_cmd 'flowtable' flowtable_spec table_spec family_spec family_spec_explicit (table)
hi link   nft_add_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_family_spec_explicit nftHL_Family
syn match nft_add_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_family_spec_explicit skipwhite contained
\ '\v(bridge|netdev|inet|arp|ip6|ip)\ze\s'
\ nextgroup=
\    nft_add_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_identifier_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_UnexpectedEOL,
\    nft_Error

" base_cmd [ 'add' ] 'flowtable' flowtable_spec
syn cluster nft_c_add_cmd_keyword_flowtable_flowtable_spec
\ contains=@nft_c_add_cmd_keyword_flowtable_flowtable_spec_table_spec
" ***************** END 'add' 'flowtable' ***************

" ***************** BEGIN base_cmd 'flowtable' *****************
" 'flowtable'->add_cmd->'add'->base_cmd->line
" 'flowtable'->add_cmd->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_flowtable nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_flowtable '\vflowtable\ze\s' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_family_spec_explicit,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_add_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_identifier_table,
\    nft_Error
" ***************** END base_cmd 'flowtable' *****************

  for s:this_semantic_file in s:add_flowtable_cmd_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded add_flowtable_cmd for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define add_flowtable_cmd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_add_flowtable_cmd = v:true
