" File: stmt_counter.vim
" Directory: custom/nftables/table/chain/stmt/
"
let s:stmt_counter_list_filepaths_semantic_early = []
let s:stmt_counter_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_counter')
  call nftables#syntax#log('INFO', 'Skipped stmt_counter (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_counter_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_counter syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

" ********************* BEGIN 'objref_stmt_counter' ******************
hi link   nft_stmt_objref_stmt_objref_stmt_counter_stmt_expr_symbol_expr_variable nftHL_Variable
syn match nft_stmt_objref_stmt_objref_stmt_counter_stmt_expr_symbol_expr_variable '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained

hi link   nft_stmt_objref_stmt_objref_stmt_counter_stmt_expr_symbol_expr_string_quoted nftHL_String
syn match nft_stmt_objref_stmt_objref_stmt_counter_stmt_expr_symbol_expr_string_quoted '\v\"[a-zA-Z][a-zA-Z0-9\-_]{0,63}\"\ze[ \t\n;]' skipwhite contained
syn match nft_stmt_objref_stmt_objref_stmt_counter_stmt_expr_symbol_expr_string_quoted '\v\'[a-zA-Z][a-zA-Z0-9\-_]{0,63}\'\ze[ \t\n;]' skipwhite contained
hi link   nft_stmt_objref_stmt_objref_stmt_counter_stmt_expr_symbol_expr_string_raw nftHL_Identifier
syn match nft_stmt_objref_stmt_objref_stmt_counter_stmt_expr_symbol_expr_string_raw '\v[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained

" 'name'->'counter'->objref_stmt_counter->objref_stmt->stmt->rule_alloc->rule->add_cmd->base_cmd->line
hi link   nft_stmt_objref_stmt_objref_stmt_counter_keyword_name nftHL_Keyword
syn match nft_stmt_objref_stmt_objref_stmt_counter_keyword_name '\vname\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stmt_objref_stmt_objref_stmt_counter_stmt_expr_symbol_expr_variable,
\    nft_stmt_objref_stmt_objref_stmt_counter_stmt_expr_symbol_expr_string_quoted,
\    nft_stmt_objref_stmt_objref_stmt_counter_stmt_expr_symbol_expr_string_raw,

" 'objref_stmt'->add_cmd->base_cmd->line
hi link   nft_stateful_stmt_counter_stmt_counter_arg_bytes_num nftHL_Integer
syn match nft_stateful_stmt_counter_stmt_counter_arg_bytes_num '\v[0-9]{1,10}\ze[ \t\n;]' skipwhite contained

hi link   nft_stateful_stmt_counter_stmt_counter_arg_keyword_bytes nftHL_Keyword
syn match nft_stateful_stmt_counter_stmt_counter_arg_keyword_bytes '\vbytes' skipwhite contained
\ nextgroup=
\    nft_stateful_stmt_counter_stmt_counter_arg_bytes_num

hi link   nft_stateful_stmt_counter_stmt_counter_arg_packets_num nftHL_Integer
syn match nft_stateful_stmt_counter_stmt_counter_arg_packets_num '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_stateful_stmt_counter_stmt_counter_arg_keyword_bytes,
\    nft_Error

hi link   nft_stateful_stmt_counter_stmt_counter_arg_keyword_packets nftHL_Keyword
syn match nft_stateful_stmt_counter_stmt_counter_arg_keyword_packets '\vpackets\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stateful_stmt_counter_stmt_counter_arg_keyword_bytes,
\    nft_Error
" *********************  END 'objref_stmt' ***************************


" ********************* BEGIN 'counter_stmt' *************************
" Match the 'counter' keyword
hi link   nft_stmt_counter_stmt_keyword_counter nftHL_Statement
syn match nft_stmt_counter_stmt_keyword_counter '\vcounter\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_stateful_stmt_counter_stmt_counter_arg_keyword_packets,
\    nft_stmt_keyword_quota,
\    nft_stmt_objref_stmt_objref_stmt_counter_keyword_name,
\    nft_add_cmd_rule_rule_alloc_stmt_counter_objref_identifier
" *********************  END 'counter_stmt' **************************


  for s:this_semantic_file in s:stmt_counter_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_counter for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_counter.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_counter = v:true
