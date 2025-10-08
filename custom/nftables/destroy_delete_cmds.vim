" File: destroy_delete_cmds.vim
" Directory: custom/nftables/
"
let s:destroy_delete_cmds_list_filepaths_semantic_early = []
let s:destroy_delete_cmds_list_filepaths_semantic_later = []

if exists('b:did_nftables_destroy_delete_cmds')
  call nftables#syntax#log('INFO', 'Skipped destroy_delete_cmds (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:destroy_delete_cmds_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading destroy_delete_cmds syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

" **************** BEGIN destroy_cmd *********************************
hi link   nft_destroy_cmd_keyword_chain_chainid_spec_num nftHL_Handle
syn match nft_destroy_cmd_keyword_chain_chainid_spec_num '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_EOS

hi link   nft_destroy_cmd_keyword_chain_chain_spec_identifier_string_chain nftHL_Table
syn match nft_destroy_cmd_keyword_chain_chain_spec_identifier_string_chain '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_destroy_cmd_keyword_chain_chainid_spec_keyword_handle nftHL_Keyword
syn match nft_destroy_cmd_keyword_chain_chainid_spec_keyword_handle 'handle' skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_chain_chainid_spec_num

hi link   nft_destroy_cmd_keyword_chain_chain_spec_keyword_last nftHL_Keyword
syn match nft_destroy_cmd_keyword_chain_chain_spec_keyword_last 'last' skipwhite contained

hi link   nft_destroy_cmd_keyword_chain_table_spec_identifier_string_table nftHL_Table
syn match nft_destroy_cmd_keyword_chain_table_spec_identifier_string_table '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_chain_chainid_spec_keyword_handle,
\    nft_destroy_cmd_keyword_chain_chain_spec_keyword_last,
\    nft_destroy_cmd_keyword_chain_chain_spec_identifier_string_chain

hi link   nft_destroy_cmd_keyword_chain_table_spec_keyword_last nftHL_Keyword
syn match nft_destroy_cmd_keyword_chain_table_spec_keyword_last 'last' skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_chain_chainid_spec_keyword_handle,
\    nft_destroy_cmd_keyword_chain_chain_spec_keyword_last,
\    nft_destroy_cmd_keyword_chain_chain_spec_identifier_string_chain

hi link   nft_destroy_cmd_keyword_chain_table_spec_family_spec nftHL_Family
syn match nft_destroy_cmd_keyword_chain_table_spec_family_spec '\v(bridge|netdev|inet|arp|ip6|ip)' skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_chain_table_spec_keyword_last,
\    nft_destroy_cmd_keyword_chain_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_destroy_cmd_keyword_chain nftHL_Statement
syn match nft_destroy_cmd_keyword_chain 'chain' skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_chain_table_spec_family_spec,
\    nft_destroy_cmd_keyword_chain_table_spec_keyword_last,
\    nft_destroy_cmd_keyword_chain_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error



" ****************** BEGIN destroy_cmd/delete_cmd ***********************
" 'delete' 'table' [ ip|ip6|inet|netdev|bridge|arp ] identifier
" 'last'->identifier->table_spec->table_or_id_spec->'table'->delete_cmd->'delete'->base_cmd->line
hi link   nft_delete_cmd_keyword_table_table_or_id_spec_table_spec_identifier nftHL_Identifier
syn match nft_delete_cmd_keyword_table_table_or_id_spec_table_spec_identifier '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedIdentifierChar,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_table_table_or_id_spec_family_spec nftHL_Family
syn match nft_delete_cmd_keyword_table_table_or_id_spec_family_spec '\v(bridge|netdev|inet|arp|ip6|ip)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_table_table_or_id_spec_table_spec_identifier,  " last match entry
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" 'delete' 'table'
" 'table'->delete_cmd->'delete'->base_cmd->line
hi link   nft_base_cmd_destroy_delete_cmds_keyword_table nftHL_Statement
syn match nft_base_cmd_destroy_delete_cmds_keyword_table '\vtable\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_table_table_or_id_spec_family_spec,
\    nft_delete_cmd_keyword_table_table_or_id_spec_table_spec_identifier,  " last match entry
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" 'destroy' 'table' [ ip|ip6|inet|netdev|bridge|arp ] identifier
" 'last'->identifier->table_spec->table_or_id_spec->'table'->destroy_cmd->'destroy'->base_cmd->line
hi link   nft_destroy_cmd_keyword_table_table_or_id_spec_table_spec_identifier nftHL_Identifier
syn match nft_destroy_cmd_keyword_table_table_or_id_spec_table_spec_identifier '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedIdentifierChar,
\    nft_Error

hi link   nft_destroy_cmd_keyword_table_table_or_id_spec_family_spec nftHL_Family
syn match nft_destroy_cmd_keyword_table_table_or_id_spec_family_spec '\v(bridge|netdev|inet|arp|ip6|ip)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_table_table_or_id_spec_table_spec_identifier,  " last match entry
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" 'destroy' 'table'
" 'table'->destroy_cmd->'destroy'->base_cmd->line
hi link   nft_base_cmd_destroy_cmd_keyword_table nftHL_Statement
syn match nft_base_cmd_destroy_cmd_keyword_table '\vtable\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_table_table_or_id_spec_family_spec,
\    nft_destroy_cmd_keyword_table_table_or_id_spec_table_spec_identifier,  " last match entry
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_chain_chain_spec_identifier_string_chain nftHL_Table
syn match nft_delete_cmd_keyword_chain_chain_spec_identifier_string_chain '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_delimiters,
\    nft_Error

hi link   nft_delete_cmd_keyword_chain_table_spec_identifier_string_table nftHL_Table
syn match nft_delete_cmd_keyword_chain_table_spec_identifier_string_table '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_chain_chain_spec_identifier_string_chain,
\    nft_Error

hi link   nft_delete_cmd_keyword_chain_table_spec_family_spec nftHL_Family
syn match nft_delete_cmd_keyword_chain_table_spec_family_spec '\v(bridge|netdev|inet|arp|ip6|ip)' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_chain_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_delete_cmd_keyword_chain nftHL_Statement
syn match nft_base_cmd_delete_cmd_keyword_chain '\vchain\ze\s' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_chain_table_spec_family_spec,
\    nft_delete_cmd_keyword_chain_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_destroy_cmd_keyword_chain_chainid_spec_num nftHL_Handle
syn match nft_destroy_cmd_keyword_chain_chainid_spec_num '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_EOS,
\    nft_Error

hi link   nft_destroy_cmd_keyword_chain_chain_spec_identifier_string_chain nftHL_Table
syn match nft_destroy_cmd_keyword_chain_chain_spec_identifier_string_chain '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_UnexpectedVariableName,
\    nft_UnexpectedNonIdentifier,
\    nft_UnexpectedSymbol,
\    nft_UnexpectedQuote,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedNumber

hi link   nft_destroy_cmd_keyword_chain_chainid_spec_keyword_handle nftHL_Keyword
syn match nft_destroy_cmd_keyword_chain_chainid_spec_keyword_handle 'handle' skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_chain_chainid_spec_num,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_destroy_cmd_keyword_chain_chain_spec_keyword_last nftHL_Keyword
syn match nft_destroy_cmd_keyword_chain_chain_spec_keyword_last 'last' skipwhite contained

hi link   nft_destroy_cmd_keyword_chain_table_spec_identifier_string_table nftHL_Table
syn match nft_destroy_cmd_keyword_chain_table_spec_identifier_string_table '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_chain_chainid_spec_keyword_handle,
\    nft_destroy_cmd_keyword_chain_chain_spec_keyword_last,
\    nft_destroy_cmd_keyword_chain_chain_spec_identifier_string_chain,
\    nft_Error

hi link   nft_destroy_cmd_keyword_chain_table_spec_keyword_last nftHL_Keyword
syn match nft_destroy_cmd_keyword_chain_table_spec_keyword_last 'last' skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_chain_chainid_spec_keyword_handle,
\    nft_destroy_cmd_keyword_chain_chain_spec_keyword_last,
\    nft_destroy_cmd_keyword_chain_chain_spec_identifier_string_chain,
\    nft_Error

hi link   nft_destroy_cmd_keyword_chain_table_spec_family_spec nftHL_Family
syn match nft_destroy_cmd_keyword_chain_table_spec_family_spec '\v(bridge|netdev|inet|arp|ip6|ip)' skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_chain_table_spec_keyword_last,
\    nft_destroy_cmd_keyword_chain_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_destroy_cmd_keyword_chain nftHL_Statement
syn match nft_base_cmd_destroy_cmd_keyword_chain 'chain' skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_chain_table_spec_family_spec,
\    nft_destroy_cmd_keyword_chain_table_spec_keyword_last,
\    nft_destroy_cmd_keyword_chain_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error



hi link   nft_delete_cmd_keyword_rule_ruleid_spec_handle_spec_num nftHL_Number
syn match nft_delete_cmd_keyword_rule_ruleid_spec_handle_spec_num '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_EOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_rule_ruleid_spec_handle_spec_keyword_handle nftHL_Keyword
syn match nft_delete_cmd_keyword_rule_ruleid_spec_handle_spec_keyword_handle 'handle' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_rule_ruleid_spec_handle_spec_num,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_identifier_string_chain nftHL_Chain
syn match nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_identifier_string_chain '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_rule_ruleid_spec_handle_spec_keyword_handle,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_keyword_last nftHL_Keyword
syn match nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_keyword_last 'last' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_rule_ruleid_spec_handle_spec_keyword_handle,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_identifier_string_table nftHL_Table
syn match nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_identifier_string_table '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_keyword_last,
\    nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_identifier_string_chain,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_family_spec nftHL_Family
syn match nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_family_spec '\v(bridge|netdev|inet|arp|ip6|ip)' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_keyword_last,
\    nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_identifier_keyword_last nftHL_Keyword
syn match nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_identifier_keyword_last '\vlast\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_keyword_last,
\    nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_identifier_string_chain,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_destroy_delete_cmds_keyword_rule nftHL_Statement
syn match nft_base_cmd_destroy_delete_cmds_keyword_rule '\vrule\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_family_spec,
\    nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_identifier_keyword_last,
\    nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_set_set_spec_identifier_string_set nftHL_Table
syn match nft_delete_cmd_keyword_set_set_spec_identifier_string_set '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_delete_cmd_keyword_set_table_spec_identifier_string_table nftHL_Table
syn match nft_delete_cmd_keyword_set_table_spec_identifier_string_table '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_set_set_spec_identifier_string_set

hi link   nft_delete_cmd_keyword_set_table_spec_family_spec nftHL_Family
syn match nft_delete_cmd_keyword_set_table_spec_family_spec '\v(bridge|netdev|inet|arp|ip6|ip)' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_set_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_destroy_delete_cmds_keyword_set nftHL_Keyword
syn match nft_base_cmd_destroy_delete_cmds_keyword_set '\vset\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_set_table_spec_family_spec,
\    nft_delete_cmd_keyword_set_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_map_map_spec_identifier_string_map nftHL_Table
syn match nft_delete_cmd_keyword_map_map_spec_identifier_string_map '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator

hi link   nft_delete_cmd_keyword_map_map_spec_keyword_last nftHL_Keyword
syn match nft_delete_cmd_keyword_map_map_spec_keyword_last '\vlast\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_EOS

hi link   nft_delete_cmd_keyword_map_table_spec_identifier_string_table nftHL_Table
syn match nft_delete_cmd_keyword_map_table_spec_identifier_string_table '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_map_map_spec_keyword_last,
\    nft_delete_cmd_keyword_map_map_spec_identifier_string_map,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_map_table_spec_keyword_last nftHL_Keyword
syn match nft_delete_cmd_keyword_map_table_spec_keyword_last '\vlast\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_map_map_spec_keyword_last,
\    nft_delete_cmd_keyword_map_map_spec_identifier_string_map,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_map_table_spec_family_spec nftHL_Family
syn match nft_delete_cmd_keyword_map_table_spec_family_spec '\v(bridge|netdev|inet|arp|ip6|ip)' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_map_table_spec_keyword_last,
\    nft_delete_cmd_keyword_map_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_destroy_delete_cmds_keyword_map nftHL_Statement
syn match nft_base_cmd_destroy_delete_cmds_keyword_map '\vmap\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_map_table_spec_family_spec,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_element_set_spec_identifier_string_element nftHL_Table
syn match nft_delete_cmd_keyword_element_set_spec_identifier_string_element '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_set_expr

hi link   nft_delete_cmd_keyword_element_set_spec_keyword_last nftHL_Keyword
syn match nft_delete_cmd_keyword_element_set_spec_keyword_last '\vlast\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_set_expr

hi link   nft_delete_cmd_keyword_element_table_spec_identifier_string_table nftHL_Table
syn match nft_delete_cmd_keyword_element_table_spec_identifier_string_table '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_element_set_spec_keyword_last,
\    nft_delete_cmd_keyword_element_set_spec_identifier_string_element,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_element_table_spec_keyword_last nftHL_Keyword
syn match nft_delete_cmd_keyword_element_table_spec_keyword_last '\vlast\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_element_set_spec_keyword_last,
\    nft_delete_cmd_keyword_element_set_spec_identifier_string_element,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_element_table_spec_family_spec nftHL_Family
syn match nft_delete_cmd_keyword_element_table_spec_family_spec '\v(bridge|netdev|inet|arp|ip6|ip)' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_element_table_spec_keyword_last,
\    nft_delete_cmd_keyword_element_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_destroy_delete_cmds_keyword_element nftHL_Statement
syn match nft_base_cmd_destroy_delete_cmds_keyword_element '\velement\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_element_table_spec_family_spec,
\    nft_delete_cmd_keyword_element_table_spec_keyword_last,
\    nft_delete_cmd_keyword_element_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_flowtable_flowtable_spec_identifier_string_flowtable nftHL_Table
syn match nft_delete_cmd_keyword_flowtable_flowtable_spec_identifier_string_flowtable '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_UnexpectedCurlyBrace,
\    nft_Error

hi link   nft_delete_cmd_keyword_flowtable_table_spec_identifier_string_table nftHL_Table
syn match nft_delete_cmd_keyword_flowtable_table_spec_identifier_string_table '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_flowtable_flowtable_spec_identifier_string_flowtable,

hi link   nft_delete_cmd_keyword_flowtable_table_spec_keyword_last nftHL_Keyword
syn match nft_delete_cmd_keyword_flowtable_table_spec_keyword_last '\vlast\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_flowtable_flowtable_spec_identifier_string_flowtable

hi link   nft_delete_cmd_keyword_flowtable_table_spec_family_spec nftHL_Family
syn match nft_delete_cmd_keyword_flowtable_table_spec_family_spec '\v(bridge|netdev|inet|arp|ip6|ip)' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_flowtable_table_spec_keyword_last,
\    nft_delete_cmd_keyword_flowtable_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_destroy_delete_cmds_keyword_flowtable nftHL_Statement
syn match nft_base_cmd_destroy_delete_cmds_keyword_flowtable '\vflowtable\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_flowtable_table_spec_family_spec,
\    nft_delete_cmd_keyword_flowtable_table_spec_keyword_last,
\    nft_delete_cmd_keyword_flowtable_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" flowtableflowtableflowtable

" GENERIC obj_or_id_spec for 'delete', 'destroy' command
" provides for 'counter', 'quota', 'ct', 'limit', 'synproxy'
" but not 'secmark' where family_spec is a required argument
hi link   nft_delete_cmd_obj_or_id_spec_obj_spec_identifier nftHL_Identifier
syn match nft_delete_cmd_obj_or_id_spec_obj_spec_identifier '\v[A-Za-z][A-Za-z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_Error

hi link   nft_delete_cmd_obj_or_id_spec_obj_spec_table_spec_identifier nftHL_Identifier
syn match nft_delete_cmd_obj_or_id_spec_obj_spec_table_spec_identifier '\v[A-Za-z][A-Za-z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_obj_or_id_spec_obj_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_obj_or_id_spec_obj_spec_table_spec_family_spec_family_spec_explicit nftHL_Family
syn match nft_delete_cmd_obj_or_id_spec_obj_spec_table_spec_family_spec_family_spec_explicit '\v(bridge|netdev|inet|arp|ip6|ip)' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_obj_or_id_spec_obj_spec_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error


hi link   nft_base_cmd_destroy_delete_cmds_keyword_quota nftHL_Statement
syn match nft_base_cmd_destroy_delete_cmds_keyword_quota '\vquota\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_obj_or_id_spec_obj_spec_table_spec_family_spec_family_spec_explicit,
\    nft_delete_cmd_obj_or_id_spec_obj_spec_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_destroy_delete_cmds_keyword_secmark nftHL_Statement
syn match nft_base_cmd_destroy_delete_cmds_keyword_secmark '\vsecmark\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_obj_or_id_spec_obj_spec_table_spec_family_spec_family_spec_explicit,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_destroy_delete_cmds_keyword_synproxy nftHL_Statement
syn match nft_base_cmd_destroy_delete_cmds_keyword_synproxy '\vsynproxy\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_delete_cmd_obj_or_id_spec_obj_spec_table_spec_family_spec_family_spec_explicit,
\    nft_delete_cmd_obj_or_id_spec_obj_spec_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error


" 'delete'->base_cmd->line
hi link   nft_base_cmd_keyword_delete nftHL_Command
syn match nft_base_cmd_keyword_delete '\vdelete\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_base_cmd_destroy_delete_cmds_keyword_flowtable,
\    nft_base_cmd_destroy_delete_cmds_keyword_synproxy,
\    nft_base_cmd_destroy_delete_cmds_keyword_element,
\    nft_base_cmd_delete_cmd_keyword_chain,
\    nft_base_cmd_destroy_delete_cmds_keyword_table,
\    nft_base_cmd_destroy_delete_cmds_keyword_quota,
\    nft_base_cmd_destroy_delete_cmds_keyword_rule,
\    nft_base_cmd_destroy_delete_cmds_keyword_set,
\    nft_base_cmd_destroy_delete_cmds_keyword_map,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" removed nft_base_cmd_destroy_delete_cmds_keyword_secmark; not supported



" 'destroy'->base_cmd->line
hi link   nft_base_cmd_keyword_destroy nftHL_Command
syn match nft_base_cmd_keyword_destroy '\vdestroy\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_base_cmd_destroy_delete_cmds_keyword_flowtable,
\    nft_base_cmd_destroy_delete_cmds_keyword_synproxy,
\    nft_base_cmd_destroy_delete_cmds_keyword_element,
\    nft_base_cmd_destroy_cmd_keyword_chain,
\    nft_base_cmd_destroy_cmd_keyword_table,
\    nft_base_cmd_destroy_delete_cmds_keyword_quota,
\    nft_base_cmd_destroy_delete_cmds_keyword_rule,
\    nft_base_cmd_destroy_delete_cmds_keyword_set,
\    nft_base_cmd_destroy_delete_cmds_keyword_map,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" removed nft_base_cmd_destroy_delete_cmds_keyword_secmark; not supported
" **************** END delete_cmd/destroy_cmd ***************

  for s:this_semantic_file in s:destroy_delete_cmds_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded destroy_delete_cmds for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define destroy_delete_cmds.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_destroy_delete_cmds = v:true
