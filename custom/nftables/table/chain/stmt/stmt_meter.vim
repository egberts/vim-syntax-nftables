" File: stmt_meter.vim
" Directory: custom/nftables/
" TODO: Replace 'stmt_meter' with filename of this script
"
let s:stmt_meter_list_filepaths_semantic_early = []
let s:stmt_meter_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_meter')
  call nftables#syntax#log('INFO', 'Skipped stmt_meter (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_meter_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_meter syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "



" ******************** BEGIN meter_expr ********************
hi link    nft_add_cmd_rule_rule_alloc_stmt_meter_stmt_meter_stmt_alloc_block nftHL_BlockDelimitersSet
syn region nft_add_cmd_rule_rule_alloc_stmt_meter_stmt_meter_stmt_alloc_block start=+{+ end=+}+ skipwhite contained

hi link   nft_add_cmd_rule_rule_alloc_stmt_meter_stmt_meter_stmt_alloc_size nftHL_Integer
syn match nft_add_cmd_rule_rule_alloc_stmt_meter_stmt_meter_stmt_alloc_size '\v[0-9]{1,10}\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meter_stmt_meter_stmt_alloc_block
hi link   nft_add_cmd_rule_rule_alloc_stmt_meter_stmt_meter_stmt_alloc_keyword_size nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_meter_stmt_meter_stmt_alloc_keyword_size '\vsize\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meter_stmt_meter_stmt_alloc_size
hi link   nft_add_cmd_rule_rule_alloc_stmt_meter_stmt_meter_stmt_alloc_identifier nftHL_Identifier
syn match nft_add_cmd_rule_rule_alloc_stmt_meter_stmt_meter_stmt_alloc_identifier '\v[a-zA-Z0-9_\-]{1,64}\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meter_stmt_meter_stmt_alloc_keyword_size,
\    nft_add_cmd_rule_rule_alloc_stmt_meter_stmt_meter_stmt_alloc_block,
\    nft_rule_cluster_Error
hi link   nft_add_cmd_rule_rule_alloc_stmt_meter_stmt_meter_stmt_alloc_keyword_meter nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_meter_stmt_meter_stmt_alloc_keyword_meter '\vmeter\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meter_stmt_meter_stmt_alloc_identifier
" ******************** BEGIN meter_expr ********************


  for s:this_semantic_file in s:stmt_meter_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_meter for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_meter.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_meter = v:true
