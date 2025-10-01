" File: insert_cmd.vim
" Directory: custom/nftables/
"
let s:insert_cmd_list_filepaths_semantic_early = []
let s:insert_cmd_list_filepaths_semantic_later = []

if exists('b:did_nftables_insert_cmd')
  call nftables#syntax#log('INFO', 'Skipped insert_cmd (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:insert_cmd_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading insert_cmd syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "



" *************** BEGIN insert_cmd *******************
hi link   nft_insert_cmd_keyword_rule_rule_position_keywords_position_spec_num nftHL_Number
syn match nft_insert_cmd_keyword_rule_rule_position_keywords_position_spec_num "\v[0-9]{1,10}" skipwhite contained
\ nextgroup=
\    @nft_c_rule,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

hi link   nft_insert_cmd_keyword_rule_rule_position_keywords_position_et_al_spec nftHL_Keyword
syn match nft_insert_cmd_keyword_rule_rule_position_keywords_position_et_al_spec "\v(position|handle|index)" skipwhite contained
\ nextgroup=
\    nft_insert_cmd_keyword_rule_rule_position_keywords_position_spec_num,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_insert_cmd_keyword_rule_rule_position_table_spec_identifier_string_chain nftHL_Chain
syn match nft_insert_cmd_keyword_rule_rule_position_table_spec_identifier_string_chain "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_insert_cmd_keyword_rule_rule_position_keywords_position_et_al_spec,
\    @nft_c_rule,  " this got taken by chain_block; ain't gonna work, gotta duplicate @nft_c_rule
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_insert_cmd_keyword_rule_rule_position_table_spec_identifier_keyword_last nftHL_Keyword
syn match nft_insert_cmd_keyword_rule_rule_position_table_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_insert_cmd_keyword_rule_rule_position_keywords_position_et_al_spec,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_identifier_string_table nftHL_Identifier
syn match nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_identifier_string_table "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_insert_cmd_keyword_rule_rule_position_table_spec_identifier_keyword_last,
\    nft_insert_cmd_keyword_rule_rule_position_table_spec_identifier_string_chain,
\    nft_Error,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,

hi link   nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_identifier_keyword_last nftHL_Keyword
syn match nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_insert_cmd_keyword_rule_rule_position_table_spec_identifier_keyword_last,
\    nft_insert_cmd_keyword_rule_rule_position_table_spec_identifier_string_chain,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_family_spec_explicit "\v(bridge|netdev|inet|arp|ip6|ip)" skipwhite contained
\ nextgroup=
\    nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_identifier_keyword_last,
\    nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" 'rule'->insert_cmd->'insert'->base_cmd->line
hi link   nft_base_cmd_keyword_insert_keyword_rule nftHL_Command
syn match nft_base_cmd_keyword_insert_keyword_rule "rule" skipwhite contained
\ nextgroup=
\    nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_family_spec_explicit,
\    nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_identifier_keyword_last,
\    nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" 'insert'->base_cmd->line
hi link   nft_base_cmd_keyword_insert nftHL_Command
syn match nft_base_cmd_keyword_insert "insert" skipwhite contained
\ nextgroup=
\    nft_base_cmd_keyword_insert_keyword_rule,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" *************** END insert_cmd *******************


  for s:this_semantic_file in s:insert_cmd_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded insert_cmd for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define insert_cmd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_insert_cmd = v:true
