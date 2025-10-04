" File: stmt_ip6.vim
" Directory: custom/nftables/
" The actual start of 'stmt' statements for 'ip6', not run-on expression
"
"  The 'ip6' keyword is the focus here within this file
"  (and not the 'payload_expr' semantic action that it appears to emulate).
"
"    - payload_stmt is a write and has a 'set' keyword
"    - primary_expr (includes payload_expr) is a read-only
"    - payload_stmt_expr is may be surrounded by parenthesis
""
" For expression, see 'ip6_expr.vim'
"
"  By staying true to LL(1) (or keyword-centric, we avoid clashes by semantic actions)

let s:stmt_ip6_list_filepaths_semantic_early = []
let s:stmt_ip6_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_ip6')
  call nftables#syntax#log('INFO', 'Skipped stmt_ip6 (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_ip6_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_ip6 syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "



hi link   nft_stmt_keyword_ip6 nftHL_Command
syn match nft_stmt_keyword_ip6 '\vip6\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_flowlabel,
\    nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_hoplimit,
\    nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_nexthdr,
\    nft_payload_expr_ip6_keyword_version,
\    nft_payload_expr_ip6_keyword_length,
\    nft_payload_expr_ip6_keyword_daddr,
\    nft_payload_expr_ip6_keyword_saddr,
\    nft_payload_expr_ip6_keyword_dscp,
\    nft_payload_expr_ip6_keyword_ecn,
\    nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_ttl,
\    nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_id,
\    nft_chainError

  for s:this_semantic_file in s:stmt_ip6_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_ip6 for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_ip6.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_ip6 = v:true
