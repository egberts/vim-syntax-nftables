" File: stmt_log.vim
" Directory: custom/nftables/table/chain/stmt/
"
let s:stmt_log_list_filepaths_semantic_early = []
let s:stmt_log_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_log')
  call nftables#syntax#log('INFO', 'Skipped stmt_log (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_log_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_log syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "


" ************************* BEGIN log_stmt' *************************
hi link   nft_stmt_log_stmt_log_arg_num nftHL_Integer
syn match nft_stmt_log_stmt_log_arg_num '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_keyword_prefix,
\    nft_stmt_log_stmt_log_arg_keyword_group,
\    nft_stmt_log_stmt_log_arg_keyword_snaplen,
\    nft_stmt_log_stmt_log_arg_keyword_queue_threshold,
\    nft_stmt_log_stmt_log_arg_keyword_level,
\    nft_stmt_log_stmt_log_arg_keyword_flags,

hi link   nft_stmt_log_stmt_log_arg_keyword_queue_threshold nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_keyword_queue_threshold '\vqueue\-threshold\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_num,
\    nft_Error

hi link   nft_stmt_log_stmt_log_arg_keyword_snaplen nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_keyword_snaplen '\vsnaplen\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_num,
\    nft_Error

hi link   nft_stmt_log_stmt_log_arg_keyword_prefix_string_valid nftHL_String
syn match nft_stmt_log_stmt_log_arg_keyword_prefix_string_valid '\v[ a-zA-Z0-9_\-:;~!@#\$%^&\*\(\)\+\|\}\{\?><`=\\\]\[\'\/\.,]{1,64}' skipwhite contained

syn region nft_stmt_log_stmt_log_arg_keyword_prefix_string start='\"' end='\"' skipwhite contained
\ contains=
\    nft_stmt_log_stmt_log_arg_keyword_prefix_string_valid
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_keyword_prefix,
\    nft_stmt_log_stmt_log_arg_keyword_group,
\    nft_stmt_log_stmt_log_arg_keyword_snaplen,
\    nft_stmt_log_stmt_log_arg_keyword_queue_threshold,
\    nft_stmt_log_stmt_log_arg_keyword_level,
\    nft_stmt_log_stmt_log_arg_keyword_flags,
\    @nft_c_stmt,

hi link   nft_stmt_log_stmt_log_arg_keyword_prefix_string_unquoted nftHL_String
syn match nft_stmt_log_stmt_log_arg_keyword_prefix_string_unquoted
\ '\v[a-zA-Z0-9_\-:;~!@#\$%^&\*\(\)\+\|\}\{\?><`=\\\]\[\'\/\.,]{1,64}' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr,
\    @nft_c_stmt

hi link   nft_stmt_log_stmt_log_arg_keyword_prefix nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_keyword_prefix '\vprefix\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_keyword_prefix_string,
\    nft_stmt_log_stmt_log_arg_keyword_prefix_string_unquoted,
\    nft_Error

hi link   nft_stmt_log_stmt_log_arg_keyword_level_defines nftHL_Define
syn match nft_stmt_log_stmt_log_arg_keyword_level_defines '\v(notice|alert|debug|emerg|crit|info|warn|err)' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_keyword_prefix,
\    nft_stmt_log_stmt_log_arg_keyword_group,
\    nft_stmt_log_stmt_log_arg_keyword_snaplen,
\    nft_stmt_log_stmt_log_arg_keyword_queue_threshold,
\    nft_stmt_log_stmt_log_arg_keyword_level,
\    nft_stmt_log_stmt_log_arg_keyword_flags,

hi link   nft_stmt_log_stmt_log_arg_log_flags_keyword_ether nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_log_flags_keyword_ether '\vether' skipwhite contained

hi link   nft_stmt_log_stmt_log_arg_log_flags_keyword_skuid nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_log_flags_keyword_skuid '\vskuid' skipwhite contained

hi link   nft_stmt_log_stmt_log_arg_log_flags_keyword_all nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_log_flags_keyword_all '\vall' skipwhite contained

hi link   nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_symbol_comma nftHL_Element
syn match nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_symbol_comma /,/ skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_keyword_sequence,
\    nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_keyword_options

hi link   nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_keyword_options nftHL_Define
syn match nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_keyword_options '\voptions' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_symbol_comma

hi link   nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_keyword_sequence nftHL_Define
syn match nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_keyword_sequence '\vsequence' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_symbol_comma,
\    nft_Error

hi link   nft_stmt_log_stmt_log_arg_log_flags_keyword_tcp nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_log_flags_keyword_tcp '\vtcp' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_keyword_sequence,
\    nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_keyword_options,
\    nft_Error

hi link   nft_stmt_log_stmt_log_arg_log_flags_log_flag_ip_keyword_options nftHL_Define
syn match nft_stmt_log_stmt_log_arg_log_flags_log_flag_ip_keyword_options '\voptions' skipwhite contained

hi link   nft_stmt_log_stmt_log_arg_log_flags_keyword_ip nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_log_flags_keyword_ip '\vip' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_log_flags_log_flag_ip_keyword_options,
\    nft_Error

hi link   nft_stmt_log_stmt_log_arg_keyword_flags nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_keyword_flags '\vflags\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_log_flags_keyword_ether,
\    nft_stmt_log_stmt_log_arg_log_flags_keyword_skuid,
\    nft_stmt_log_stmt_log_arg_log_flags_keyword_all,
\    nft_stmt_log_stmt_log_arg_log_flags_keyword_tcp,
\    nft_stmt_log_stmt_log_arg_log_flags_keyword_ip,
\    nft_Error

hi link   nft_stmt_log_stmt_log_arg_keyword_group nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_keyword_group '\vgroup\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_num,
\    nft_Error

hi link   nft_stmt_log_stmt_log_arg_keyword_level nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_keyword_level '\vlevel\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_keyword_level_defines,
\    nft_Error

hi link   nft_stmt_log_stmt_log_stmt_alloc_keyword_log nftHL_Command
syn match nft_stmt_log_stmt_log_stmt_alloc_keyword_log '\vlog\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_keyword_queue_threshold,
\    nft_stmt_log_stmt_log_arg_keyword_snaplen,
\    nft_stmt_log_stmt_log_arg_keyword_prefix,
\    nft_stmt_log_stmt_log_arg_keyword_flags,
\    nft_stmt_log_stmt_log_arg_keyword_group,
\    nft_stmt_log_stmt_log_arg_keyword_level,
\    nft_expected_semicolon_or_new_line
" no error handling
" ************************* END log_stmt *****************************

  for s:this_semantic_file in s:stmt_log_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_log for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_log.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_log = v:true
