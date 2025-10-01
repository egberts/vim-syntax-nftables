" File: table_block.vim
" Directory: custom/nftables/table
"
let s:list_filepaths_semantic_early = [
\    'table/table_block/table_block_flowtable.vim',
\    'table/table_block/table_block_synproxy.vim',
\    'table/table_block/table_block_counter.vim',
\    'table/table_block/table_block_secmark.vim',
\    'table/table_block/table_block_chain.vim',
\    'table/table_block/table_block_limit.vim',
\    'table/table_block/table_block_quota.vim',
\    'table/table_block/table_block_map.vim',
\    'table/table_block/table_block_set_block.vim',
\    'table/table_block/table_block_set.vim'
\    ]
let s:list_filepaths_semantic_later = []

if exists('b:did_nftables_table_block')
  call nftables#syntax#log('INFO', 'Skipped table_block (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading table_block syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
"******** BEGIN OF INSIDE THE TABLE BLOCK **********************
" table_flag (via table_options 'flags')
hi link   nft_add_table_options_flags_element_separator nftHL_Separator
syn match nft_add_table_options_flags_element_separator '\v,\ze[ \t\n;\}(dormant|persist|owner)]{1,5}' skipnl skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_table_table_block_table_options_keyword_flags_elements,
\    nft_Error

hi link   nft_add_table_options_flags_list_item nftHL_Define
syn match nft_add_table_options_flags_list_item "\v(dormant|persist|owner)\ze\s{0,5}[\t\n,;\}]{1,5}" skipwhite contained
\ nextgroup=
\    nft_add_table_options_flags_element_separator,
\    nft_add_cmd_keyword_table_table_block_table_options_semicolon,
\    nft_Error

" add_cmd 'table' table_block table_options 'flags' table_flag
syn cluster nft_c_add_cmd_keyword_table_table_block_table_options_keyword_flags_elements
\ contains=
\    nft_add_table_options_flags_list_item

" add_cmd 'table' table_block table_options 'flags'
hi link   nft_add_cmd_keyword_table_table_options_keyword_flags nftHL_Statement
syn match nft_add_cmd_keyword_table_table_options_keyword_flags "flags" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_table_table_block_table_options_keyword_flags_elements,
\    nft_Error



" add table <table_id> {
" [ [ 'add' ] 'table' ] table_id '{'
" table_block->add_cmd->base_cmd->line
" table_block->'table'->add_cmd->'add'->base_cmd->line
hi link    nft_add_cmd_keyword_table_table_block_delimiters nftHL_BlockDelimitersTable
" really cannot use 'keepend' for table_block because
"    multiple chain_blocks' curly braces must exist.
syn region nft_add_cmd_keyword_table_table_block_delimiters start='\v\s+\zs\{' end='\v\}' skipwhite skipempty skipnl contained
\ nextgroup=
\    nft_line_separator
\ contains=
\    nft_add_cmd_table_block_keyword_flowtable,
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_add_cmd_keyword_table_table_block_keyword_counter,
\    nft_add_cmd_keyword_table_table_options_comment_spec_keyword_comment,
\    nft_common_block_keyword_include,
\    nft_add_cmd_table_block_keyword_synproxy,
\    nft_add_cmd_table_block_keyword_secmark,
\    nft_common_block_keyword_define,
\    nft_add_cmd_table_block_keyword_chain,
\    nft_common_block_keyword_error,
\    nft_add_cmd_keyword_table_table_block_keyword_quota,
\    nft_add_cmd_keyword_table_table_options_keyword_flags,
\    nft_comment_inline,
\    nft_add_cmd_table_block_keyword_limit,
\    nft_add_cmd_table_block_keyword_map,
\    nft_add_cmd_table_block_keyword_set,
\    nft_comment_inline,
\    nft_table_block_stmt_separator,
\    nft_Error
"\    nextgroup=nft_hash_comment,
"\    nft_add_cmd_table_block_keyword_flowtable,
" ******** END OF INSIDE THE TABLE BLOCK *********************


  for s:this_semantic_file in s:list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded table_block for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define table_block.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_terminal = v:true

