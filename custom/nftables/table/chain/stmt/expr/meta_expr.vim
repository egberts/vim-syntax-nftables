" File: meta_expr.vim
" Directory: custom/nftables/table/chain/stmt/expr/
"
let s:meta_expr_list_filepaths_semantic_early = []
let s:meta_expr_list_filepaths_semantic_later = []

if exists('b:did_nftables_meta_expr')
  call nftables#syntax#log('INFO', 'Skipped meta_expr (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:meta_expr_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading meta_expr syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
" **************** BEGIN meta_expr ***********************************
" meta_expr - trying for a generic Vim syntax group (to reside ONLY within chain_block)
"   used by primary_expr and primary_stmt_expr
syn cluster nft_c_meta_key_qualified
\ contains=
\    nft_meta_key_qualified_keyword_protocol,
\    nft_meta_key_qualified_keyword_priority,
\    nft_meta_key_qualified_keyword_secmark,
\    nft_meta_key_qualified_keyword_length,
\    nft_meta_key_qualified_keyword_random

syn cluster nft_c_meta_key_unqualified
\ contains=
\    nft_meta_key_unqualified_keyword_rtclassid,
\    nft_meta_key_unqualified_keyword_iifgroup,
\    nft_meta_key_unqualified_keyword_oifgroup,
\    nft_meta_key_unqualified_keyword_ibrname,
\    nft_meta_key_unqualified_keyword_ibrport,
\    nft_meta_key_unqualified_keyword_iifname,
\    nft_meta_key_unqualified_keyword_iiftype,
\    nft_meta_key_unqualified_keyword_nftrace,
\    nft_meta_key_unqualified_keyword_obrname,
\    nft_meta_key_unqualified_keyword_obrport,
\    nft_meta_key_unqualified_keyword_oifname,
\    nft_meta_key_unqualified_keyword_oiftype,
\    nft_meta_key_unqualified_keyword_pkttype,
\    nft_meta_key_unqualified_keyword_cgroup,
\    nft_meta_key_unqualified_keyword_ipsec,
\    nft_meta_key_unqualified_keyword_skgid,
\    nft_meta_key_unqualified_keyword_skuid,
\    nft_meta_key_unqualified_keyword_hour,
\    nft_meta_key_unqualified_keyword_mark,
\    nft_meta_key_unqualified_keyword_time,
\    nft_meta_key_unqualified_keyword_cpu,
\    nft_meta_key_unqualified_keyword_day,
\    nft_meta_key_unqualified_keyword_iif,
\    nft_meta_key_unqualified_keyword_oif

" meta_key, used by meta_expr & meta_stmt
syn cluster nft_c_meta_key
\ contains=
\    nft_meta_key_unqualified_keyword_rtclassid,
\    nft_meta_key_unqualified_keyword_iifgroup,
\    nft_meta_key_unqualified_keyword_oifgroup,
\    nft_meta_key_qualified_keyword_protocol,
\    nft_meta_key_qualified_keyword_priority,
\    nft_meta_key_unqualified_keyword_ibrname,
\    nft_meta_key_unqualified_keyword_ibrport,
\    nft_meta_key_unqualified_keyword_iifname,
\    nft_meta_key_unqualified_keyword_iiftype,
\    nft_meta_key_unqualified_keyword_nftrace,
\    nft_meta_key_unqualified_keyword_obrname,
\    nft_meta_key_unqualified_keyword_obrport,
\    nft_meta_key_unqualified_keyword_oifname,
\    nft_meta_key_unqualified_keyword_oiftype,
\    nft_meta_key_unqualified_keyword_pkttype,
\    nft_meta_key_qualified_keyword_secmark,
\    nft_meta_key_unqualified_keyword_cgroup,
\    nft_meta_key_qualified_keyword_length,
\    nft_meta_key_qualified_keyword_random,
\    nft_meta_key_unqualified_keyword_ipsec,
\    nft_meta_key_unqualified_keyword_skgid,
\    nft_meta_key_unqualified_keyword_skuid,
\    nft_meta_key_unqualified_keyword_hour,
\    nft_meta_key_unqualified_keyword_mark,
\    nft_meta_key_unqualified_keyword_time,
\    nft_meta_key_unqualified_keyword_cpu,
\    nft_meta_key_unqualified_keyword_day,
\    nft_meta_key_unqualified_keyword_iif,
\    nft_meta_key_unqualified_keyword_oif,

hi link   nft_meta_key_unqualified_keywords nftHL_Command
syn match nft_meta_key_unqualified_keywords '\v(rtclassid|iifgroup|oifgroup|ibrname|ibrport|iifname|iiftype|nftrace|obrname|obrport|oifname|oiftype|pkttype|cgroup|ipsec|skgid|skuid|hour|mark|time|cpu|day|iif|oif)' skipwhite contained

hi link   nft_meta_expr_keyword_meta_string nftHL_String
syn match nft_meta_expr_keyword_meta_string '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_meta_expr_keyword_meta nftHL_Command
syn match nft_meta_expr_keyword_meta '\vmeta\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_meta_key,
\    nft_meta_expr_keyword_meta_string

syn cluster nft_c_meta_expr_template
\ contains=
\    nft_meta_key_unqualified_keyword_rtclassid,
\    nft_meta_key_unqualified_keyword_iifgroup,
\    nft_meta_key_unqualified_keyword_oifgroup,
\    nft_meta_key_unqualified_keyword_ibrname,
\    nft_meta_key_unqualified_keyword_ibrport,
\    nft_meta_key_unqualified_keyword_iifname,
\    nft_meta_key_unqualified_keyword_iiftype,
\    nft_meta_key_unqualified_keyword_nftrace,
\    nft_meta_key_unqualified_keyword_obrname,
\    nft_meta_key_unqualified_keyword_obrport,
\    nft_meta_key_unqualified_keyword_oifname,
\    nft_meta_key_unqualified_keyword_oiftype,
\    nft_meta_key_unqualified_keyword_pkttype,
\    nft_meta_key_unqualified_keyword_cgroup,
\    nft_meta_key_unqualified_keyword_ipsec,
\    nft_meta_key_unqualified_keyword_skgid,
\    nft_meta_key_unqualified_keyword_skuid,
\    nft_meta_key_unqualified_keyword_hour,
\    nft_meta_key_unqualified_keyword_mark,
\    nft_meta_expr_keyword_meta,
\    nft_meta_key_unqualified_keyword_time,
\    nft_meta_key_unqualified_keyword_cpu,
\    nft_meta_key_unqualified_keyword_day,
\    nft_meta_key_unqualified_keyword_iif,
\    nft_meta_key_unqualified_keyword_oif

syn cluster nft_c_meta_expr
\ contains=
\    nft_meta_key_unqualified_keywords,
\    nft_meta_expr_keyword_meta
" **************** END meta_expr *************************************




" ***************** BEGIN meta_expr ***************
" If it's followed by a set, it's likely meta_stmt. If it's
" followed by a field name and then a comparison (==, <, etc.),
" it's meta_expr.
hi link   nft_add_cmd_rule_rule_alloc_stmt_primary_expr_meta_expr_meta_key_unqualified_keyword_rtclassid nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_primary_expr_meta_expr_meta_key_unqualified_keyword_rtclassid "\vrtclassid\ze[ \t\n]" skipwhite contained

" ***************** END meta_expr ***************

  for s:this_semantic_file in s:meta_expr_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded meta_expr for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define meta_expr.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_meta_expr = v:true
