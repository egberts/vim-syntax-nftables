" File: table_block_flowtable.vim
" File: custom/nftables/table/table_block/
"
let s:table_block_flowtable_list_filepaths_semantic_early = []
let s:table_block_flowtable_list_filepaths_semantic_later = []

if exists('b:did_nftables_table_block_flowtable')
  call nftables#syntax#log('INFO', 'Skipped table_block_flowtable (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:table_block_flowtable_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading table_block_flowtable syntax ...' )

  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

" ************* BEGIN table_block 'flowtable' flowtable_block ***************
hi link   nft_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_int nftHL_Integer
syn match nft_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_int "\v\-?[0-9]{1,10}" skipwhite contained
\ nextgroup=
\    nft_EOS

hi link   nft_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_var nftHL_Variable
syn match nft_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_var "\v\$[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained

hi link   nft_c_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_sign nftHL_Expression
syn match nft_c_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_sign "\v[-+]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_int

hi link   nft_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_name nftHL_Keyword
syn match nft_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_name "\v[a-zA-Z][a-zA-Z]{1,16}" skipwhite contained
\ nextgroup=
\     nft_c_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_sign

syn cluster nft_c_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended
\ contains=
\    nft_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_int,
\    nft_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_var,
\    nft_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_name

hi link   nft_add_cmd_block_table_flowtable_block_hook_keyword_priority nftHL_Keyword
syn match nft_add_cmd_block_table_flowtable_block_hook_keyword_priority "\vpriority\ze\s" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended

hi link    nft_add_cmd_block_table_flowtable_block_hook_string_quoted_double nftHL_String
syn region nft_add_cmd_block_table_flowtable_block_hook_string_quoted_double start='"' end='"' skip="\\\"" skipwhite skipnl skipempty contained
\ nextgroup=
\    nft_add_cmd_block_table_flowtable_block_hook_keyword_priority

hi link    nft_add_cmd_block_table_flowtable_block_hook_string_quoted_single nftHL_String
syn region nft_add_cmd_block_table_flowtable_block_hook_string_quoted_single start="'" end="'" skip="\\\'" skipwhite skipnl skipempty contained
\ nextgroup=
\    nft_add_cmd_block_table_flowtable_block_hook_keyword_priority

hi link    nft_add_cmd_block_table_flowtable_block_hook_string_unquoted nftHL_String
syn match nft_add_cmd_block_table_flowtable_block_hook_string_unquoted "\v[a-zA-Z0-9]{1,64}" skipwhite skipnl skipempty contained
\ nextgroup=
\    nft_add_cmd_block_table_flowtable_block_hook_keyword_priority

syn cluster nft_c_add_cmd_block_table_flowtable_spec_flowtable_block_hook_string
\ contains=
\    nft_add_cmd_block_table_flowtable_block_hook_string_quoted_double,
\    nft_add_cmd_block_table_flowtable_block_hook_string_quoted_single,
\    nft_add_cmd_block_table_flowtable_block_hook_string_unquoted

hi link   nft_add_cmd_block_table_flowtable_block_stmt_separator nftHL_Operator
syn match nft_add_cmd_block_table_flowtable_block_stmt_separator ";" skipwhite contained

" base_cmd_add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'hook'
hi link   nft_add_cmd_block_table_flowtable_spec_flowtable_block_hook nftHL_Statement
syn match nft_add_cmd_block_table_flowtable_spec_flowtable_block_hook "\v[{ ;]\zshook\ze[;} ]" skipwhite skipnl skipempty contained
\ nextgroup=
\    @nft_c_add_cmd_block_table_flowtable_spec_flowtable_block_hook_string

" base_cmd add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'flags' flowtable_flag_list flowtable_flag
hi link   nft_add_cmd_block_table_flowtable_spec_flowtable_block_flags_flowtable_flag_list_flowtable_flag nftHL_Keyword
syn match nft_add_cmd_block_table_flowtable_spec_flowtable_block_flags_flowtable_flag_list_flowtable_flag skipwhite contained
\ "\v(offload)"
\ nextgroup=
\    nft_add_cmd_block_table_flowtable_block_stmt_separator,
\    nft_CurlyBraceAheadSilent,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'flags' flowtable_flag_list
syn cluster nft_c_add_cmd_block_table_flowtable_spec_flowtable_block_flowtable_flag_list
\ contains=
\    nft_add_cmd_block_table_flowtable_spec_flowtable_block_flags_flowtable_flag_list_flowtable_flag

" base_cmd add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'flags'
hi link   nft_add_cmd_block_table_flowtable_spec_flowtable_block_flags nftHL_Statement
syn match nft_add_cmd_block_table_flowtable_spec_flowtable_block_flags "flags" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_block_table_flowtable_spec_flowtable_block_flowtable_flag_list,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" flowtable_block_expr->'='->'devices'->flowtable_block->'{'->'flowtable'->add_cmd->base_cmd->line
" base_cmd add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'counter'
hi link   nft_add_cmd_block_table_flowtable_spec_flowtable_block_counter nftHL_Statement
syn match nft_add_cmd_block_table_flowtable_spec_flowtable_block_counter "counter" skipwhite contained
\ nextgroup=
\    nft_add_cmd_block_table_flowtable_block_stmt_separator,
\    nft_CurlyBraceAheadSilent,
\    nft_Error

hi link    nft_add_cmd_block_table_flowtable_spec_flowtable_block_devices_flowtable_block_expr nftHL_BlockDelimitersFlowtable
syn region nft_add_cmd_block_table_flowtable_spec_flowtable_block_devices_flowtable_block_expr start="{" end="}" skipwhite contained

hi link   nft_add_cmd_block_table_flowtable_spec_flowtable_expr_variable nftHL_Variable
syn match nft_add_cmd_block_table_flowtable_spec_flowtable_expr_variable "\v\$[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
" [ 'add' ] 'flowtable' table_id flow_id '{' 'devices' '='
" '='->'devices'->flowtable_block->'{'->'flowtable'->add_cmd->base_cmd->line
hi link   nft_add_cmd_block_table_flowtable_spec_flowtable_block_devices_equal nftHL_Expression
syn match nft_add_cmd_block_table_flowtable_spec_flowtable_block_devices_equal "=" skipwhite contained
\ nextgroup=
\    nft_add_cmd_block_table_flowtable_spec_flowtable_block_devices_flowtable_block_expr,
\    nft_add_cmd_block_table_flowtable_spec_flowtable_expr_variable

" [ 'add' ] 'flowtable' table_id flow_id '{' 'devices'
" 'devices'->flowtable_block->'{'->'flowtable'->add_cmd->base_cmd->line
hi link   nft_add_cmd_block_table_flowtable_spec_flowtable_block_devices nftHL_Statement
syn match nft_add_cmd_block_table_flowtable_spec_flowtable_block_devices "devices" skipwhite contained
\ nextgroup=
\    nft_add_cmd_block_table_flowtable_spec_flowtable_block_devices_equal

" [ 'add' ] 'flowtable' table_id flow_id '{' flowtable_block
" flowtable_block->'{'->'flowtable'->add_cmd->base_cmd->line
hi link    nft_add_cmd_block_table_flowtable_spec_flowtable_block nftHL_BlockDelimitersFlowTable
syn region nft_add_cmd_block_table_flowtable_spec_flowtable_block start="{" end="}" skipwhite contained
\ nextgroup=
\    nft_comment_inline,
\    nft_Semicolon,
\    nft_EOS,
\    nft_Error
\ contains=
\    nft_add_cmd_block_table_flowtable_spec_flowtable_block_counter,
\    nft_add_cmd_block_table_flowtable_spec_flowtable_block_devices,
\    nft_add_cmd_block_table_flowtable_spec_flowtable_block_flags,
\    nft_add_cmd_block_table_flowtable_spec_flowtable_block_hook,
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_comment_inline,
\    nft_comment_spec,
\    nft_add_cmd_block_table_flowtable_block_stmt_separator,
\    nft_Error

" base_cmd add_cmd 'table' table_block 'flowtable' identifier '{' flowtable_block '}'
hi link    nft_add_cmd_table_block_flowtable_block_delimiters nftHL_BlockDelimitersSet
syn region nft_add_cmd_table_block_flowtable_block_delimiters start="{" end="}" skip="\\{" skipwhite contained
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
\    nft_add_cmd_table_block_flowtable_stmt_separator
\ nextgroup=
\    nft_comment_inline,
\    nft_table_block_stmt_separator

" base_cmd add_cmd 'table' table_block 'flowtable' identifier
hi link   nft_add_cmd_table_block_keyword_flowtable_identifier nftHL_Identifier
syn match nft_add_cmd_table_block_keyword_flowtable_identifier "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_flowtable_block_delimiters

" base_cmd add_cmd 'table' table_block 'flowtable' 'last'
hi link   nft_add_cmd_table_block_keyword_flowtable_identifier_keyword_last nftHL_Keyword
syn match nft_add_cmd_table_block_keyword_flowtable_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_flowtable_block_delimiters

" base_cmd add_cmd 'table' table_block 'flowtable'
hi link   nft_add_cmd_table_block_keyword_flowtable nftHL_Command
syn match nft_add_cmd_table_block_keyword_flowtable "flowtable" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_keyword_flowtable_identifier_keyword_last,
\    nft_add_cmd_table_block_keyword_flowtable_identifier,
" ************* END table_block 'flowtable' flowtable_block ***************


  for s:this_semantic_file in s:table_block_flowtable_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded table_block_flowtable for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define table.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_table_block_flowtable = v:true
