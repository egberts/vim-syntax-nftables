" File: replace_cmd.vim
" Directory: custom/nftables/
"
let s:replace_cmd_list_filepaths_semantic_early = []
let s:replace_cmd_list_filepaths_semantic_later = []

if exists('b:did_nftables_replace_cmd')
  call nftables#syntax#log('INFO', 'Skipped replace_cmd (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:replace_cmd_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading replace_cmd syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

" **************** START replace_cmd ***************
" base_cmd 'replace' [ family_spec ] table_identifier chain_identifier handle_identifier rule
syn cluster nft_c_base_cmd_replace_rule_alloc_stmt
\ contains=
\    @nft_c_payload_stmt,
\    @nft_c_stmt,
\    @nft_c_base_cmd_replace_rule_alloc_stmt

syn cluster nft_c_base_cmd_replace_rule_alloc
\ contains=
\    @nft_c_base_cmd_replace_rule_alloc_stmt,
\    nft_comment_spec

syn cluster nft_c_base_cmd_replace_rule
\ contains=
\    @nft_c_base_cmd_replace_rule_alloc

" base_cmd 'replace' [ family_spec ] table_identifier chain_identifier handle_identifier
hi link   nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_handle_id nftHL_Handle
syn match nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_handle_id '\v[0-9]{1,9}' skipwhite contained
\ nextgroup=
\    @nft_c_base_cmd_replace_rule,
\    nft_line_stmt_separator,
\    nft_Error

" base_cmd 'replace' [ family_spec ] table_identifier chain_identifier handle_identifier
hi link   nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_keywords_handle_position_index nftHL_Keyword
syn match nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_keywords_handle_position_index '\v(position|index|handle)\s' skipwhite contained
\ nextgroup=
\    nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_handle_id

" base_cmd 'replace' [ family_spec ] table_identifier chain_identifier
hi link   nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_chain_id nftHL_Chain
syn match nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_chain_id '\v[a-zA-Z0-9_\-]{1,64}\s{1,5}' skipwhite contained
\ nextgroup=
\    nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_keywords_handle_position_index,
\    @nft_c_payload_stmt
"\    nft_ip_hdr_expr_keyword_ip via @nft_c_payload_stmt
"\    @nft_c_rule

" base_cmd 'replace' [ family_spec ] table_identifier
hi link   nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_table_id nftHL_Table
syn match nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_table_id "\v[a-zA-Z0-9_\-]{1,64}\s+" contained
\ nextgroup=
\    nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_chain_id,

" base_cmd 'replace' family_spec
hi link   nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_family_spec_family nftHL_Family
syn match nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_family_spec_family "\v(ip6|ip|inet|bridge|netdev|arp)\s+" skipwhite contained
\ nextgroup=
\    nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_table_id,
\    nft_UnexpectedIdentifierChar,

" base_cmd 'replace' [ family_spec ]
syn cluster nft_c_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec
\ contains=
\    nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_family_spec_family,
\    nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_table_id

" base_cmd 'replace' 'rule'
hi link   nft_replace_cmd_keyword_rule nftHL_Statement
syn match nft_replace_cmd_keyword_rule "rule" skipwhite contained
\ nextgroup=
\    @nft_c_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd 'replace'
hi link   nft_base_cmd_keyword_replace nftHL_Statement
syn match nft_base_cmd_keyword_replace "\vreplace" skipwhite contained
\ nextgroup=
\    nft_replace_cmd_keyword_rule,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
"***************** replace_cmd END *****************


  for s:this_semantic_file in s:replace_cmd_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded replace_cmd for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define replace_cmd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_replace_cmd = v:true
