" File: table_block_quota.vim
" Directory: custom/nftables/table/table_block/
"
let s:table_block_quota_list_filepaths_semantic_early = []
let s:table_block_quota_list_filepaths_semantic_later = []

if exists('b:did_nftables_table_block_quota')
  call nftables#syntax#log('INFO', 'Skipped table_block_quota (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:table_block_quota_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading table_block_quota syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "




" ************* BEGIN table_block 'quota' quota_block ***************
hi link   nft_add_cmd_table_block_quota_block_quota_config_quota_used_quota_unit nftHL_Unit
syn match nft_add_cmd_table_block_quota_block_quota_config_quota_used_quota_unit '\v(pbytes|gbytes|mbytes|kbytes|bytes|pbyte|gbyte|mbyte|kbyte|byte)s' skipwhite contained

hi link   nft_add_cmd_table_block_quota_block_quota_config_quota_used_num nftHL_Integer
syn match nft_add_cmd_table_block_quota_block_quota_config_quota_used_num '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_quota_block_quota_config_quota_used_quota_unit

hi link   nft_add_cmd_table_block_quota_block_quota_config_quota_used_keyword_used nftHL_Keyword
syn match nft_add_cmd_table_block_quota_block_quota_config_quota_used_keyword_used '\vused' skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_quota_block_quota_config_quota_used_num,
\    nft_Error

hi link   nft_add_cmd_table_block_quota_block_quota_config_quota_unit nftHL_Unit
syn match nft_add_cmd_table_block_quota_block_quota_config_quota_unit '\v(pbytes|gbytes|mbytes|kbytes|bytes|pbyte|gbyte|mbyte|kbyte|byte)s' skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_quota_block_quota_config_quota_used_keyword_used

hi link   nft_add_cmd_table_block_quota_block_quota_config_num nftHL_Integer
syn match nft_add_cmd_table_block_quota_block_quota_config_num '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_quota_block_quota_config_quota_unit,

hi link   nft_add_cmd_table_block_quota_block_quota_config_quota_mode_keyword_over nftHL_Keyword
syn match nft_add_cmd_table_block_quota_block_quota_config_quota_mode_keyword_over '\vover\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_quota_block_quota_config_num,

hi link   nft_add_cmd_table_block_quota_block_quota_config_quota_mode_keyword_until nftHL_Keyword
syn match nft_add_cmd_table_block_quota_block_quota_config_quota_mode_keyword_until '\vuntil\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_quota_block_quota_config_num,

hi link   nft_add_cmd_table_block_quota_block_options_comment_spec_string nftHL_Comment
syn match nft_add_cmd_table_block_quota_block_options_comment_spec_string '\v\"[ \ta-zA-Z0-9]{1,64}\"' skipwhite contained

hi link nft_add_cmd_table_block_quota_block_options_comment_spec_keyword_comment nftHL_Statement
syn match nft_add_cmd_table_block_quota_block_options_comment_spec_keyword_comment '\vcomment' skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_quota_block_options_comment_spec_string,
\    nft_Error

hi link   nft_add_cmd_table_block_quota_block_delimiters nftHL_BlockDelimitersCounter
syn region nft_add_cmd_table_block_quota_block_delimiters start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_common_block_keyword_redefine,
\    nft_add_cmd_table_block_quota_block_options_comment_spec_keyword_comment,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_add_cmd_table_block_quota_block_quota_config_quota_mode_keyword_over,
\    nft_add_cmd_table_block_quota_block_quota_config_quota_mode_keyword_until,
\    nft_comment_inline,
\    nft_add_cmd_table_block_quota_block_quota_config_num
\ nextgroup=
\    nft_table_block_stmt_separator,
\    nft_Error

hi link   nft_add_cmd_table_block_keyword_quota_obj_identifier_identifier_string nftHL_Identifier
syn match nft_add_cmd_table_block_keyword_quota_obj_identifier_identifier_string '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_quota_block_delimiters

hi link   nft_add_cmd_keyword_table_table_block_keyword_quota nftHL_Statement
syn match nft_add_cmd_keyword_table_table_block_keyword_quota '\vquota' skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_keyword_quota_obj_identifier_identifier_string,
\    nft_Error
" ************* END table_block 'quota' quota_block ***************


  for s:this_semantic_file in s:table_block_quota_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded table_block_quota for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define table_block_quota.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_table_block_quota = v:true
