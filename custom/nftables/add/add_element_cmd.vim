" File: add_element_cmd.vim
" Directory: custom/nftables/table/add/
"
let s:add_element_cmd_list_filepaths_semantic_early = []
let s:add_element_cmd_list_filepaths_semantic_later = []

if exists('b:did_nftables_add_element_cmd')
  call nftables#syntax#log('INFO', 'Skipped add_element_cmd (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:add_element_cmd_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading add_element_cmd syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "



" **************** START add_element_cmd ***************
" base_cmd add_cmd 'element' set_block_expr '{' comment_spec 'comment' QUOTED_STRING
hi link    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_comment_spec nftHL_Comment
syn region nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_comment_spec start='"' end='"' skip='\\\"' oneline skipwhite contained
\ nextgroup=
\    nft_String,
\    nft_Error

" base_cmd add_cmd 'element' set_block_expr '{' A : B comment_spec '}'
hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_comment_spec nftHL_Comment
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_comment_spec '\vcomment\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_comment_spec

hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_verdict_expr_chain_expr_identifier nftHL_Identifier
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_verdict_expr_chain_expr_identifier '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze[ \t,\}\n]' skipwhite contained

hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_verdict_expr_chain_expr_variable_expr nftHL_Variable
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_verdict_expr_chain_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze[ \t,\}\n]' skipwhite contained

hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_continue nftHL_Keyword
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_continue '\vcontinue\ze[ \t,\}]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_comment_spec

hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_return nftHL_Keyword
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_return '\vreturn\ze[ \t,\}]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_comment_spec

hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_accept nftHL_Keyword
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_accept '\vaccept\ze[ \t,;\}]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_comment_spec

hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_drop nftHL_Keyword
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_drop '\vdrop\ze[ \t,;\}]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_comment_spec

hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_jump nftHL_Keyword
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_jump '\vjump\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_verdict_expr_chain_expr_variable_expr,
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_verdict_expr_chain_expr_identifier

hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_goto nftHL_Keyword
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_goto '\vgoto\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_verdict_expr_chain_expr_variable_expr,
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_verdict_expr_chain_expr_identifier


hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_colon_separator nftHL_Element
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_colon_separator /:/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_continue,
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_return,
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_accept,
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_drop,
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_goto,
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_jump,


hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_time_spec nftHL_String
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_time_spec '\v[0-9]{1,5}(d|h|m|s|ms|us|ns){1,7}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_colon_separator

hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option nftHL_Keyword
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option '\v(timeout|expires)' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_time_spec,

hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_unquoted_identifier_IP nftHL_String
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_unquoted_identifier_IP '\v[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option,
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_colon_separator

hi link    nft_add_cmd_keyword_element_set_block_expr_set_spec_block nftHL_BlockDelimitersSet
syn region nft_add_cmd_keyword_element_set_block_expr_set_spec_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_unquoted_identifier_IP,
\    nft_Error
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error

hi link   nft_add_cmd_keyword_element_set_block_expr_variable_expr_variable nftHL_Variable
syn match nft_add_cmd_keyword_element_set_block_expr_variable_expr_variable '\v\$[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze[ \t;]' skipwhite contained
\ contains=
\    nft_line_stmt_separator

hi link   nft_add_cmd_keyword_element_set_spec_set_spec_identifier nftHL_Table
syn match nft_add_cmd_keyword_element_set_spec_set_spec_identifier '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_variable_expr_variable,
\    nft_add_cmd_keyword_element_set_block_expr_set_spec_block,
\    nft_Error

hi link   nft_add_cmd_keyword_element_set_spec_set_spec_keyword_last nftHL_Keyword
syn match nft_add_cmd_keyword_element_set_spec_set_spec_keyword_last '\vlast\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_variable_expr_variable,
\    nft_add_cmd_keyword_element_set_block_expr_set_spec_block,
\    nft_add_cmd_keyword_element_set_spec_block,
\    nft_variable_identifier,
\    nft_Error

hi link   nft_add_cmd_keyword_element_set_spec_table_spec_identifier_string_table nftHL_Table
syn match nft_add_cmd_keyword_element_set_spec_table_spec_identifier_string_table '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_spec_set_spec_keyword_last,
\    nft_add_cmd_keyword_element_set_spec_set_spec_identifier,
\    nft_UnexpectedCurlyBrace,
\    nft_Error

hi link   nft_add_cmd_keyword_element_set_spec_table_spec_keyword_last nftHL_Keyword
syn match nft_add_cmd_keyword_element_set_spec_table_spec_keyword_last '\vlast\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_spec_set_spec_keyword_last,
\    nft_add_cmd_keyword_element_set_spec_set_spec_identifier,
\    nft_UnexpectedCurlyBrace,
\    nft_Error

hi link   nft_add_cmd_keyword_element_set_spec_table_spec_family_spec nftHL_Family
syn match nft_add_cmd_keyword_element_set_spec_table_spec_family_spec '\v(bridge|netdev|inet|arp|ip6|ip)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_spec_table_spec_keyword_last,
\    nft_add_cmd_keyword_element_set_spec_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link nft_base_cmd_add_cmd_keyword_element nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_element '\velement\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_spec_table_spec_keyword_last,
\    nft_add_cmd_keyword_element_set_spec_table_spec_family_spec,
\    nft_add_cmd_keyword_element_set_spec_table_spec_identifier_string_table,
\    nft_Error
" **************** END add_element_cmd ***************

  for s:this_semantic_file in s:add_element_cmd_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded add_element_cmd for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define add_element_cmd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_add_element_cmd = v:true
