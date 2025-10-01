" File: ~/.vim/custom/nftables/table_block_secmark.vim
"
let s:table_block_secmark_list_filepaths_semantic_early = []
let s:table_block_secmark_list_filepaths_semantic_later = []

if exists('b:did_nftables_table_block_secmark')
  call nftables#syntax#log('INFO', 'Skipped table_block_secmark (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:table_block_secmark_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading table_block_secmark syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

" ------------- BEGIN table_block 'secmark' -------------
hi link   nft_table_block_secmark_block_stmt_separator nftHL_Separator
syn match nft_table_block_secmark_block_stmt_separator /;/ skipwhite contained

hi link   nft_table_block_ct_secmark_block_ct_secmark_config_quoted_string_content nftHL_String
syn match nft_table_block_ct_secmark_block_ct_secmark_config_quoted_string_content '\v\"[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze[ \t]' skipwhite contained

hi link    nft_table_block_ct_secmark_block_ct_secmark_config_quoted_string nftHL_String
syn region nft_table_block_ct_secmark_block_ct_secmark_config_quoted_string start='\"' end='\"' skip='\\\"' skipwhite contained
\ contains=
\    nft_table_block_ct_secmark_block_ct_secmark_config_quoted_string_content

hi link    nft_add_cmd_table_block_secmark_block_delimiters nftHL_BlockDelimitersSecMark
syn region nft_add_cmd_table_block_secmark_block_delimiters start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_table_block_ct_secmark_block_ct_secmark_config_quoted_string,
\    nft_comment_inline,
\    nft_table_block_secmark_block_stmt_separator
\ nextgroup=
\    nft_table_block_stmt_separator,
\    nft_CurlyBraceAheadSilent,
\    nft_EOS,
\    nft_Error

hi link   nft_add_cmd_table_block_keyword_secmark_obj_identifier_keyword_last nftHL_Define
syn match nft_add_cmd_table_block_keyword_secmark_obj_identifier_keyword_last '\vlast' skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_secmark_block_delimiters,
\    nft_Error

hi link   nft_add_cmd_table_block_keyword_secmark_obj_identifier nftHL_Identifier
syn match nft_add_cmd_table_block_keyword_secmark_obj_identifier '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_secmark_block_delimiters,
\    nft_Error

hi link   nft_add_cmd_table_block_keyword_secmark nftHL_Statement
syn match nft_add_cmd_table_block_keyword_secmark '\vsecmark' skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_keyword_secmark_obj_identifier_keyword_last,
\    nft_add_cmd_table_block_keyword_secmark_obj_identifier,
\    nft_Error
" ------------- END table_block 'secmark' -------------

  for s:this_semantic_file in s:table_block_secmark_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded table_block_secmark for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define table_block_secmark.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_table_block_secmark = v:true
