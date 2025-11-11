" File: table_block_counter.vim
" Directory: custom/nftables/table/table_block/
"
let s:table_block_counter_list_filepaths_semantic_early = []
let s:table_block_counter_list_filepaths_semantic_later = []

if exists('b:did_nftables_table_block_counter')
  call nftables#syntax#log('INFO', 'Skipped table_block_counter (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:table_block_counter_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading table_block_counter syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "





" ************* BEGIN table_block 'counter counter_block ***************
hi link   nft_add_cmd_table_block_counter_block_stmt_separator nftHL_Separator
syn match nft_add_cmd_table_block_counter_block_stmt_separator ';' skipwhite contained

" add_cmd 'table' table_block '{' 'counter' counter_block '{' 'packet' <NUM> 'bytes' <NUM>
hi link   nft_add_cmd_keyword_table_table_block_counter_block_counter_config_bytes_num nftHL_Unit
syn match nft_add_cmd_keyword_table_table_block_counter_block_counter_config_bytes_num "\v[0-9]{1,10}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_counter_block_stmt_separator,

" add_cmd 'table' table_block '{' 'counter' counter_block '{' 'packet' <NUM> 'bytes'
hi link   nft_add_cmd_keyword_table_table_block_counter_block_counter_config_keyword_bytes nftHL_Keyword
syn match nft_add_cmd_keyword_table_table_block_counter_block_counter_config_keyword_bytes "\vbytes\ze[ \t]" skipwhite contained
\ nextgroup=
\   nft_add_cmd_keyword_table_table_block_counter_block_counter_config_bytes_num,
\   nft_Error

" add_cmd 'table' table_block '{' 'counter' counter_block '{' 'packet' <NUM>
hi link   nft_add_cmd_keyword_table_table_block_counter_block_counter_config_num_packets nftHL_Number
syn match nft_add_cmd_keyword_table_table_block_counter_block_counter_config_num_packets "\v[0-9]{1,10}" skipnl skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_counter_block_counter_config_keyword_bytes,

" add_cmd 'table' table_block '{' 'counter' counter_block '{' 'packet'
hi link   nft_add_cmd_keyword_table_table_block_counter_block_counter_config_keyword_packets nftHL_Statement
syn match nft_add_cmd_keyword_table_table_block_counter_block_counter_config_keyword_packets "\vpackets\ze[ \t]" skipempty skipnl skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_counter_block_counter_config_num_packets,
\    nft_Error

" add_cmd 'table' table_block '{' 'counter' counter_block '{'
hi link    nft_add_cmd_keyword_table_table_block_counter_block_delimiters nftHL_BlockDelimitersCounter
syn region nft_add_cmd_keyword_table_table_block_counter_block_delimiters start=+{+ end=+}+ skipwhite contained
\ nextgroup=
\    nft_table_block_stmt_separator,
\    nft_Error
\ contains=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_add_cmd_keyword_table_table_block_counter_block_counter_config_keyword_packets,
\    nft_comment_inline,
\    nft_Error

hi link   nft_add_cmd_keyword_table_table_block_keyword_counter_obj_identifier nftHL_Identifier
syn match nft_add_cmd_keyword_table_table_block_keyword_counter_obj_identifier '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_counter_block_delimiters

hi link   nft_add_cmd_keyword_table_table_block_keyword_counter nftHL_Statement
syn match nft_add_cmd_keyword_table_table_block_keyword_counter '\vcounter\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_stateful_stmt_counter_stmt_counter_arg_keyword_packets,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_add_table_options_comment_spec,
\    nft_add_cmd_keyword_table_table_block_keyword_counter_obj_identifier
" ************* END table_block 'counter' counter_block ***************

  for s:this_semantic_file in s:table_block_counter_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded table_block_counter for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define table_block_counter.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_table_block_counter = v:true
