" File: add_secmark_cmd.vim
" Directory: custom/nftables/
"
let s:add_secmark_cmd_list_filepaths_semantic_early = []
let s:add_secmark_cmd_list_filepaths_semantic_later = []

if exists('b:did_nftables_add_secmark_cmd')
  call nftables#syntax#log('INFO', 'Skipped add_secmark_cmd (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:add_secmark_cmd_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading add_secmark_cmd syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

" ******************* BEGIN base_cmd 'secmark' *************
hi link  nft_add_cmd_keyword_secmark_secmark_block_separator nftHL_Separator
syn match nft_add_cmd_keyword_secmark_secmark_block_separator /;/ skipwhite contained

hi link  nft_add_cmd_keyword_secmark_secmark_block nftHL_BlockDelimitersFlowtable
syn region nft_add_cmd_keyword_secmark_secmark_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_add_cmd_keyword_secmark_secmark_block_separator,
\    nft_Error
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error

hi link   nft_add_cmd_keyword_secmark_secmark_config_string nftHL_String
syn match nft_add_cmd_keyword_secmark_secmark_config_string "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze[ \t]" skipwhite contained

hi link   nft_add_cmd_keyword_secmark_obj_spec_identifier nftHL_Table
syn match nft_add_cmd_keyword_secmark_obj_spec_identifier "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_secmark_secmark_block,
\    nft_add_cmd_keyword_secmark_secmark_config,
\    nft_Error

hi link   nft_add_cmd_keyword_secmark_obj_spec_table_spec_identifier nftHL_Table
syn match nft_add_cmd_keyword_secmark_obj_spec_table_spec_identifier "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_secmark_obj_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOL,
\    nft_Error

hi link   nft_add_cmd_keyword_secmark_obj_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_add_cmd_keyword_secmark_obj_spec_table_spec_family_spec_explicit "\v(ip6|ip|inet|netdev|arp|bridge)\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_secmark_obj_spec_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOL,
\    nft_Error

" 'add' 'secmark'
" 'secmark'->add_cmd->'add'->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_secmark nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_secmark "\vsecmark\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_secmark_obj_spec_table_spec_family_spec_explicit,
\    nft_add_cmd_keyword_secmark_obj_spec_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" ******************* END base_cmd 'secmark' *************

  for s:this_semantic_file in s:add_secmark_cmd_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded add_secmark_cmd for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define add_secmark_cmd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_add_secmark_cmd = v:true
