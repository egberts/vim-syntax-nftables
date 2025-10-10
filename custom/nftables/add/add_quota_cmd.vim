" File: quota_cmd.vim
" Directory: custom/nftables/

let s:quota_cmd_list_filepaths_semantic_early = ['quota_config.vim']
let s:quota_cmd_list_filepaths_semantic_later = []

if exists('b:did_nftables_quota_cmd')
  call nftables#syntax#log('INFO', 'Skipped quota_cmd (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:quota_cmd_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading quota_cmd syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "



" *********************  BEGIN 'quota' ***********************
hi link    nft_add_cmd_quota_block nftHL_BlockDelimitersQuota
syn region nft_add_cmd_quota_block start="{" end="}" skip="\\}" skipwhite contained
\ contains=
\    @nft_c_quota_config,
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_quota_config_quota_mode_keyword_until,
\    nft_quota_config_quota_mode_keyword_over,
\    nft_quota_config_num,
\    nft_comment_spec,
\    nft_stmt_separator,

hi link   nft_add_cmd_quota_cmd_obj_spec_identifier_string nft_Identifier
syn match nft_add_cmd_quota_cmd_obj_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_quota_config_quota_mode_keyword_until,
\    nft_quota_config_quota_mode_keyword_over,
\    nft_add_cmd_quota_block,
\    nft_quota_config_num,
\    nft_Error

hi link   nft_add_cmd_quota_cmd_obj_spec_table_spec_identifier_string nftHL_Identifier
syn match nft_add_cmd_quota_cmd_obj_spec_table_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_quota_cmd_obj_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_add_cmd_quota_cmd_obj_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_add_cmd_quota_cmd_obj_spec_table_spec_family_spec_explicit "\v(bridge|netdev|inet|arp|ip6|ip)" skipwhite contained
\ nextgroup=
\    nft_add_cmd_quota_cmd_obj_spec_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" 'quota'->add_cmd->'add'->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_quota nftHL_Substatement
syn match nft_base_cmd_add_cmd_keyword_quota "\vquota\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_quota_cmd_obj_spec_table_spec_family_spec_explicit,
\    nft_add_cmd_quota_cmd_obj_spec_table_spec_identifier_string_unknown,
\    nft_add_cmd_quota_cmd_obj_spec_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_quota_cmd_obj_spec_identifier_string nft_Identifier
syn match nft_quota_cmd_obj_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_quota_block,
\    nft_quota_config_quota_mode,
\    nft_quota_config_num

hi link   nft_quota_cmd_obj_spec_identifier_keyword_last nftHL_Keyword
syn match nft_quota_cmd_obj_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_add_cmd_quota_block,
\    nft_quota_config_quota_mode,
\    nft_quota_config_num

hi link   nft_quota_cmd_obj_spec_table_spec_identifier_string nftHL_Identifier
syn match nft_quota_cmd_obj_spec_table_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_quota_cmd_obj_spec_identifier_keyword_last,
\    nft_quota_cmd_obj_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_quota_cmd_obj_spec_table_spec_identifier_keyword_last nftHL_Keyword
syn match nft_quota_cmd_obj_spec_table_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_quota_cmd_obj_spec_identifier_keyword_last,
\    nft_quota_cmd_obj_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_quota_cmd_obj_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_quota_cmd_obj_spec_table_spec_family_spec_explicit "\v(bridge|netdev|inet|arp|ip6|ip)" skipwhite contained
\ nextgroup=
\    nft_quota_cmd_obj_spec_table_spec_identifier_keyword_last,
\    nft_quota_cmd_obj_spec_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" 'quota'->add_cmd->base_cmd->line
hi link   nft_base_cmd_keyword_quota nftHL_Command
syn match nft_base_cmd_keyword_quota "\vquota\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_quota_cmd_obj_spec_table_spec_identifier_keyword_last,
\    nft_quota_cmd_obj_spec_table_spec_identifier_string,
\    nft_quota_cmd_obj_spec_table_spec_family_spec_explicit,
\    nft_quota_cmd_obj_spec_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
" ********************* END 'quota' ************************


  for s:this_semantic_file in s:quota_cmd_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded quota_cmd for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define quota_cmd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_quota_cmd = v:true
