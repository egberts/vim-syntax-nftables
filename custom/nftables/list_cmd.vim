" File: list_cmd.vim
" Directory: custom/nftables/
"
let s:list_cmd_list_filepaths_semantic_early = []
let s:list_cmd_list_filepaths_semantic_later = []

if exists('b:did_nftables_list_cmd')
  call nftables#syntax#log('INFO', 'Skipped list_cmd (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:list_cmd_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading list_cmd syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

"***************** BEGIN list_cmd *************************
" base_cmd list_cmd 'table' table_spec family_spec 'last'
hi link   nft_list_table_spec_identifier_keyword_last nftHL_Keyword
syn match nft_list_table_spec_identifier_keyword_last "\vlast\ze[ \t]" skipwhite contained

" base_cmd list_cmd 'table' table_spec family_spec identifier
hi link   nft_list_table_spec_identifier_string nftHL_Identifier
syn match nft_list_table_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ contains=nft_identifier_last
\ nextgroup=
\    nft_stmt_separator,
\    nft_Error

" base_cmd list_cmd 'table' table_spec family_spec family_spec_explicit
hi link   nft_list_table_spec_family_spec_valid nftHL_Family  " _add_ to make 'table_spec' pathway unique
syn match nft_list_table_spec_family_spec_valid "\v(bridge|netdev|inet|arp|ip6|ip)" skipwhite contained
\ nextgroup=
\    nft_list_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd [ 'list' ] [ 'table' ] table_spec
syn cluster nft_c_list_table_spec_end
\ contains=
\    nft_list_table_spec_family_spec_valid,
\    nft_list_table_spec_identifier_string

" base_cmd list_cmd 'table'
hi link   nft_base_cmd_list_keyword_table_end nftHL_Command
syn match nft_base_cmd_list_keyword_table_end "\vtable\ze[ \t]" skipwhite contained
\ nextgroup=
\    @nft_c_list_table_spec_end,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

hi link   nft_list_cmd_tables_chains_ruleset_meters_flowtables_maps_ruleset_spec nftHL_Family
syn match nft_list_cmd_tables_chains_ruleset_meters_flowtables_maps_ruleset_spec "\v(bridge|netdev|inet|arp|ip6|ip)" skipwhite contained
\ nextgroup=nft_Error

" base_cmd list_cmd 'table'
hi link   nft_base_cmd_list_keywords_tables_chains_ruleset_meters_flowtables_maps_end nftHL_Command
syn match nft_base_cmd_list_keywords_tables_chains_ruleset_meters_flowtables_maps_end "\v(tables|chains|ruleset|meters|flowtables|maps)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_tables_chains_ruleset_meters_flowtables_maps_ruleset_spec,
\    nft_Semicolon,
\    nft_EOS,
\    nft_Error

" base_cmd list_cmd 'chain' [ family_spec ] table_spec chain_spec
hi link   nft_list_chain_spec_identifier_string nftHL_Identifier
syn match nft_list_chain_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_Semicolon,
\    nft_EOS,
\    nft_Error

hi link   nft_list_chain_spec_identifier_keyword_last nftHL_Keyword
syn match nft_list_chain_spec_identifier_keyword_last "\vlast\ze[ \t]" skipwhite contained

" base_cmd list_cmd 'chain' [ family_spec ] table_spec
hi link   nft_list_chain_table_spec_identifier_string nftHL_Identifier
syn match nft_list_chain_table_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_list_chain_spec_identifier_keyword_last,
\    nft_list_chain_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_list_chain_table_spec_identifier_keyword_last nftHL_Keyword
syn match nft_list_chain_table_spec_identifier_keyword_last "\vlast\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_list_chain_spec_identifier_keyword_last,
\    nft_list_chain_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" list_cmd 'chain' chain_spec family_spec family_spec_explicit
hi link   nft_list_chain_spec_family_spec_explicit nftHL_Family
syn match nft_list_chain_spec_family_spec_explicit "\v(ip(6)?|inet|arp|bridge|netdev)" skipwhite contained
\ nextgroup=
\    nft_list_chain_table_spec_identifier_keyword_last,
\    nft_list_chain_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd list_cmd 'chain' chain_spec
syn cluster nft_c_list_cmd_chain_spec_end
\ contains=
\    nft_list_chain_table_spec_identifier_keyword_last,
\    nft_list_chain_spec_family_spec_explicit,
\    nft_list_chain_table_spec_identifier_string

" base_cmd list_cmd 'chain'
" base_cmd [ 'list' ] [ 'chain' ] chain_spec
hi link   nft_base_cmd_list_keyword_chain_end nftHL_Command
syn match nft_base_cmd_list_keyword_chain_end "\vchain\ze[ \t]" skipwhite contained
\ nextgroup=
\    @nft_c_list_cmd_chain_spec_end,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_list_cmd_keywords_sets_et_al_ruleset_spec nftHL_Family
syn match nft_list_cmd_keywords_sets_et_al_ruleset_spec  "\v(bridge|netdev|inet|arp|ip6|ip)" skipwhite contained
\ nextgroup=nft_Error

" 'list' ('sets'|'counters'|'quotas'|'limits'|'secmarks'|'synproxys')
hi link   nft_list_cmd_keywords_sets_et_al_table_spec_identifier_string_table nftHL_Table
syn match nft_list_cmd_keywords_sets_et_al_table_spec_identifier_string_table  "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_Semicolon,
\    nft_EOS,
\    nft_Error

hi link   nft_list_cmd_keywords_sets_et_al_table_spec_identifier_keyword_last nftHL_Keyword
syn match nft_list_cmd_keywords_sets_et_al_table_spec_identifier_keyword_last  "last" skipwhite contained
\ nextgroup=
\    nft_Semicolon,
\    nft_EOS,
\    nft_Error

hi link   nft_list_cmd_keywords_sets_et_al_table_spec_family_spec_explicit nftHL_Family
syn match nft_list_cmd_keywords_sets_et_al_table_spec_family_spec_explicit  "\v(bridge|netdev|inet|arp|ip6|ip)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keywords_sets_et_al_table_spec_identifier_keyword_last,
\    nft_list_cmd_keywords_sets_et_al_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_list_cmd_keywords_sets_et_al_keyword_table nftHL_Statement
syn match nft_list_cmd_keywords_sets_et_al_keyword_table "table" skipwhite contained
\ nextgroup=
\     nft_list_cmd_keywords_sets_et_al_table_spec_family_spec_explicit,
\     nft_list_cmd_keywords_sets_et_al_table_spec_identifier_keyword_last,
\     nft_list_cmd_keywords_sets_et_al_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" 'list' ('sets'|'counters'|'quotas'|'limits'|'secmarks'|'synproxys')
hi link   nft_base_cmd_list_keywords_sets_et_al_end nftHL_Statement
syn match nft_base_cmd_list_keywords_sets_et_al_end "\v(sets|counters|quotas|limits|synproxys)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keywords_sets_et_al_ruleset_spec,
\    nft_list_cmd_keywords_sets_et_al_keyword_table
" removed 'secmarks' from token list; not supported

" base_cmd list_cmd 'chain' [ family_spec ] table_spec chain_spec
hi link   nft_list_set_chain_spec_identifier_string nftHL_Identifier
syn match nft_list_set_chain_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error

hi link   nft_list_set_chain_spec_identifier_keyword_last nftHL_Keyword
syn match nft_list_set_chain_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error

" list_cmd 'set' set_spec family_spec family_spec_explicit
hi link   nft_list_set_table_spec_identifier_string nftHL_Identifier
syn match nft_list_set_table_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_list_set_chain_spec_identifier_keyword_last,
\    nft_list_set_chain_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_list_set_table_spec_identifier_keyword_last nftHL_Keyword
syn match nft_list_set_table_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_list_set_chain_spec_identifier_keyword_last,
\    nft_list_set_chain_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_list_set_spec_family_spec_explicit nftHL_Family
syn match nft_list_set_spec_family_spec_explicit "\v(bridge|netdev|inet|arp|ip6|ip)" skipwhite contained
\ nextgroup=
\    nft_list_set_table_spec_identifier_keyword_last,
\    nft_list_set_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd list_cmd 'set' set_spec
syn cluster nft_c_list_cmd_set_spec_end
\ contains=
\    nft_list_set_table_spec_identifier_keyword_last,
\    nft_list_set_table_spec_identifier_string,
\    nft_list_set_spec_family_spec_explicit

" 'list' ('counter'|'quota'|'limit'|'secmark'|'synproxy') obj_spec
hi link   nft_list_cmd_keywords_counter_et_al_obj_spec nftHL_Statement
syn match nft_list_cmd_keywords_counter_et_al_obj_spec "\v(counter|quota|limit|secmark|synproxy)\ze " skipwhite contained
\ nextgroup=
\    @nft_c_list_cmd_set_spec_end,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error


" base_cmd [ 'list' ] [ 'set' ] set_spec
" base_cmd [ 'list' ] [ 'map' ] set_spec
" base_cmd [ 'list' ] [ 'meter' ] set_spec
hi link   nft_base_cmd_list_set_map_meter_end nftHL_Command
syn match nft_base_cmd_list_set_map_meter_end "\v(set|map|meter)\ze " skipwhite contained
\ nextgroup=
\    @nft_c_list_cmd_set_spec_end,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd [ 'list' ] [ 'flowtable' ] set_spec

" base_cmd list_cmd 'flowtables' [ family_spec ] table_spec chain_spec
" base_cmd list_cmd 'flow' 'tables' [ family_spec ] table_spec chain_spec
hi link   nft_list_flowtables_ruleset_chain_spec_identifier nftHL_Identifier
syn match nft_list_flowtables_ruleset_chain_spec_identifier "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained

" list_cmd 'flowtables' ruleset_spefc family_spec family_spec_explicit
hi link   nft_list_flowtable_ruleset_table_spec_identifier nftHL_Identifier
syn match nft_list_flowtable_ruleset_table_spec_identifier "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_list_flowtable_ruleset_chain_spec_identifier,
\    nft_list_flowtable_spec_family_spec_explicit,
\    nft_list_flowtable_spec_family_spec_explicit_unsupported,
\    nft_list_flowtable_ruleset_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_list_flowtable_ruleset_table_spec_identifier_keyword_last nftHL_Identifier
syn match nft_list_flowtable_ruleset_table_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_list_flowtable_ruleset_chain_spec_identifier_keyword_last,
\    nft_list_flowtable_ruleset_chain_spec_identifier_string,
\    nft_list_flowtable_spec_family_spec_explicit,
\    nft_list_flowtable_spec_family_spec_explicit_unsupported,
\    nft_list_flowtable_ruleset_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_list_flowtable_spec_family_spec_explicit nftHL_Family
syn match nft_list_flowtable_spec_family_spec_explicit "\v(inet|ip6|ip)" skipwhite contained
\ nextgroup=
\    nft_list_flowtable_ruleset_table_spec_identifier_keyword_last,
\    nft_list_flowtable_ruleset_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_list_flowtable_spec_family_spec_explicit_unsupported nftHL_Error
syn match nft_list_flowtable_spec_family_spec_explicit_unsupported "\v(netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit nftHL_Family
syn match nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit "\v(inet|ip6|ip)" skipwhite contained
\ nextgroup=
\    nft_list_flowtables_ruleset_table_spec_identifier_keyword_last,
\    nft_list_flowtables_ruleset_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit_unsupported nftHL_Error
syn match nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit_unsupported "\v(netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd [ 'list' ] [ 'flow' ] [ 'tables' ] ruleset_spec
" ruleset_spec->'tables'->list_cmd->'list'->line
hi link   nft_list_cmd_keyword_flow_keyword_table_set_spec_family_spec_identifier_string nftHL_Identifier
syn match nft_list_cmd_keyword_flow_keyword_table_set_spec_family_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained

" base_cmd [ 'list' ] [ 'flow' ] [ 'tables' ] ruleset_spec
" ruleset_spec->'table'->list_cmd->'list'->line
hi link   nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit nftHL_Family
syn match nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit "\v(inet|ip6|ip)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_identifier_string

" *************** BEGIN 'list flow[s]/flowtable[s]' **************
" *************** BEGIN 'list flow table' **************
" base_cmd [ 'list' ] [ 'flow' ] [ 'table' ] set_spec identifier
hi link   nft_list_cmd_keyword_flow_keyword_table_set_spec_identifier_string nftHL_Identifier
syn match nft_list_cmd_keyword_flow_keyword_table_set_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_Semicolon,
\    nft_EOS,
\    nft_Error

" base_cmd [ 'list' ] [ 'flow' ] [ 'table' ] set_spec identifier
hi link   nft_list_cmd_keyword_flow_keyword_table_set_spec_identifier_keyword_last nftHL_Keyword
syn match nft_list_cmd_keyword_flow_keyword_table_set_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_Semicolon,
\    nft_EOS,
\    nft_Error

" base_cmd [ 'list' ] [ 'flow' ] [ 'table' ] set_spec
" string->identifier->table_spec->set_spec->'table'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_identifier_string nftHL_Identifier
syn match nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flow_keyword_table_set_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_flow_keyword_table_set_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd [ 'list' ] [ 'flow' ] [ 'table' ] set_spec
" 'last'->identifier->table_spec->set_spec->'table'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_identifier_keyword_last nftHL_Keyword
syn match nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flow_keyword_table_set_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_flow_keyword_table_set_spec_identifier_string

" base_cmd [ 'list' ] [ 'flow' ] [ 'table' ] set_spec
" family_spec_explicit->family_spec->table_spec->set_spec->'table'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_family_spec_explicit "\v(inet|ip6|ip)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_identifier_string,

" family_spec_explicit->family_spec->table_spec->set_spec->'table'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_family_spec_explicit_unsupported nftHL_Error
syn match nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_family_spec_explicit_unsupported "\v(netdev|bridge|arp)" skipwhite contained

" base_cmd [ 'list' ] [ 'flow' ] [ 'table' ]
" set_spec->'table'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_flow_keyword_table nftHL_Statement
syn match nft_list_cmd_keyword_flow_keyword_table "\vtable\ze " skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_family_spec_explicit,
\    nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_family_spec_explicit_unsupported,
\    nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS
" *************** END 'list flow table' **************

" *************** BEGIN 'list flow tables' **************
" base_cmd [ 'list' ] [ 'flow' ] [ 'tables' ] ruleset_spec
" family_spec_explicit->ruleset_spec->'tables'->'flow'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit nftHL_Family
syn match nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit "\v(inet|ip6|ip)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_identifier_string,

" family_spec_explicit->ruleset_spec->'tables'->'flow'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit_unsupported nftHL_Error
syn match nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit_unsupported "\v(netdev|bridge|arp)" skipwhite contained

" base_cmd [ 'list' ] [ 'flow' ] [ 'tables' ]
" 'tables'->'flow'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_flow_keyword_tables nftHL_Statement
syn match nft_list_cmd_keyword_flow_keyword_tables "tables" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit_unsupported,
\    nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit

" *************** END 'list flow tables' **************

" base_cmd [ 'list' ] [ 'flow' ]
" 'flow'->list_cmd->'list'->base_cmd->line
hi link   nft_base_cmd_list_keyword_flow nftHL_Command
syn match nft_base_cmd_list_keyword_flow "\vflow\ze " skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flow_keyword_tables,
\    nft_list_cmd_keyword_flow_keyword_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" *************** END 'list flow' **************


" *************** BEGIN 'list flowtables' **************
" base_cmd [ 'list' ] [ 'flowtables' ] ruleset_spec
" ruleset_spec->'flowtables'->list_cmd->'list'->base_cmd->line
hi link   nft_base_cmd_list_keyword_flowtables nftHL_Command
syn match nft_base_cmd_list_keyword_flowtables "flowtables" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit,
\    nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit_unsupported,
\    nft_Semicolon,
\    nft_EOS,
\    nft_Error
" *************** END 'list flowtables' **************

" *************** BEGIN 'list flowtable' **************
hi link   nft_list_cmd_keyword_flowtable_flowtable_spec_identifier_string nftHL_Table
syn match nft_list_cmd_keyword_flowtable_flowtable_spec_identifier_string "\v[A-Za-z][A-Za-z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_Semicolon,
\    nft_EOS,
\    nft_Error

hi link   nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_identifier_string nftHL_Table
syn match nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_identifier_string "\v[A-Za-z][A-Za-z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flowtable_flowtable_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd [ 'list' ] [ 'flowtable' ] flowtable_spec
" family_spec_explicit->family_spec->table_spec->flowtable_spec->'flowtable'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_explicit "\v(inet|ip6|ip)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_identifier_string,

" family_spec_explicit->family_spec->table_spec->flowtable_spec->'flowtable'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_explicit_unsupported nftHL_Error
syn match nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_explicit_unsupported "\v(netdev|bridge|arp)" skipwhite contained

" base_cmd list_cmd 'flowtable' flowtable_spec
syn cluster nft_c_list_cmd_keyword_flowtable_flowtable_spec_end
\ contains=
\    nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_explicit,
\    nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_explicit_unsupported,
\    nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_identifier_string,

" base_cmd [ 'list' ] [ 'flowtable' ] flowtable_spec
" flowtable_spec->'flowtable'->list_cmd->'list'->base_cmd->line
hi link   nft_base_cmd_list_keyword_flowtable nftHL_Command
syn match nft_base_cmd_list_keyword_flowtable "\vflowtable\ze " skipwhite contained
\ nextgroup=
\    @nft_c_list_cmd_keyword_flowtable_flowtable_spec_end,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" *************** END 'list flowtable' **************

" *************** END 'list flow[s]/flowtable[s]' **************
" base_cmd 'list' 'ruleset' ruleset_spec
hi link   nft_list_ruleset_spec_family_spec_explicit nftHL_Family
syn match nft_list_ruleset_spec_family_spec_explicit "\v(ip(6)?|inet)" skipwhite contained
\ nextgroup=
\    nft_list_set_table_spec_identifier

" base_cmd 'list' 'ruleset' set_spec
hi link   nft_base_cmd_list_ruleset_end nftHL_Command
syn match nft_base_cmd_list_ruleset_end "ruleset" skipwhite contained
\ nextgroup=
\    nft_list_ruleset_spec_family_spec_explicit,
\    nft_Error
" TODO: Unused nft_base_cmd_list_ruleset_end

" 'list' 'ct' ('helpers'|'timeout'|'expectation') ('ip'|'ip6'|'inet'|'netdev'|'bridge'|'arp') identifier
" identifier->family_spec->table_spec->list_cmd->base_cmd->line
hi link   nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_identifier_string nftHL_Table
syn match nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_EOS

" 'list' 'ct' ('helpers'|'timeout'|'expectation') ('ip'|'ip6'|'inet'|'netdev'|'bridge'|'arp') 'last'
" identifier->family_spec->table_spec->list_cmd->base_cmd->line
hi link   nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_keyword_last nftHL_Keyword
syn match nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_EOS

" 'list' 'ct' ('helpers'|'timeout'|'expectation') ('ip'|'ip6'|'inet'|'netdev'|'bridge'|'arp')
" family_spec_explicit->family_spec->table_spec->list_cmd->base_cmd->line
hi link   nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_family_spec_explicit nftHL_Family
syn match nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_family_spec_explicit "\v(bridge|netdev|inet|arp|ip6|ip)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_keyword_last,
\    nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_identifier_string,
\    nft_UnexpectedEOS

hi link   nft_list_cmd_keyword_ct_keyword_helper_obj_spec_identifier_string nftHL_Identifier
syn match nft_list_cmd_keyword_ct_keyword_helper_obj_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_Semicolon,
\    nft_EOS,
\    nft_Error

hi link   nft_list_cmd_keyword_ct_keyword_helper_obj_spec_identifier_keyword_last nftHL_Keyword
syn match nft_list_cmd_keyword_ct_keyword_helper_obj_spec_identifier_keyword_last "last" skipwhite contained

hi link   nft_list_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_string nftHL_Identifier
syn match nft_list_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

hi link   nft_list_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_keyword_last nftHL_Keyword
syn match nft_list_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" 'list' 'ct' ('helpers'|'timeout'|'expectation') ct_cmd_type
" ct_obj_type->list_cmd->base_cmd->line
hi link   nft_list_cmd_keyword_ct_keywords_timeout_expectation_keyword_table nftHL_Keyword
syn match nft_list_cmd_keyword_ct_keywords_timeout_expectation_keyword_table "\vtable\ze " skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_family_spec_explicit,
\    nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_keyword_last,
\    nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" 'list' 'ct' 'helper'
" 'helper'->ct_obj_type->'ct'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_ct_keyword_helper_obj_spec_family_spec_explicit nftHL_Family
syn match nft_list_cmd_keyword_ct_keyword_helper_obj_spec_family_spec_explicit "\v(bridge|netdev|inet|arp|ip6|ip)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" 'list' 'ct' ('timeout'|'expectation')
" 'timeout'->'ct'->list_cmd->'list'->base_cmd->line
" 'expectation'->ct_obj_type->'ct'->list_cmd->'list'->base_cmd->line
" 'expectation'->ct_cmd_type->'ct'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_ct_keywords_timeout_expectation nftHL_Statement
syn match nft_list_cmd_keyword_ct_keywords_timeout_expectation "\v(timeout|expectation)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_ct_keywords_timeout_expectation_keyword_table,
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_family_spec_explicit,
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" 'list' 'ct' 'helper'
" 'helper'->ct_obj_type->'ct'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_ct_keyword_helper nftHL_Statement
syn match nft_list_cmd_keyword_ct_keyword_helper "helper" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_family_spec_explicit,
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" 'list' 'ct' 'helpers' ct_obj_type
" 'helper'->ct_cmd_type->'ct'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_ct_keyword_helpers nftHL_Statement
syn match nft_list_cmd_keyword_ct_keyword_helpers "helpers" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_ct_keywords_timeout_expectation_keyword_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" 'list' 'ct'
" list_cmd->base_cmd->line
" 'ct'->list_cmd->'list'->base_cmd->line
hi link   nft_base_cmd_list_keyword_ct nftHL_Statement
syn match nft_base_cmd_list_keyword_ct "\vct\ze " skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_ct_keyword_helper,
\    nft_list_cmd_keyword_ct_keyword_helpers,
\    nft_list_cmd_keyword_ct_keywords_timeout_expectation,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" 'list' 'hooks'
" basehook_device_name->basehook_spec->'hooks'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_hooks_basehook_spec_basehook_device_name_string nftHL_Device
syn match nft_list_cmd_keyword_hooks_basehook_spec_basehook_device_name_string "\v[a-zA-Z0-9\-_\.]{1,32}" skipwhite contained

" 'list' 'hooks'
" basehook_device_name->basehook_spec->'hooks'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_hooks_basehook_spec_basehook_device_name_keyword_device nftHL_Keyword
syn match nft_list_cmd_keyword_hooks_basehook_spec_basehook_device_name_keyword_device "device" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_hooks_basehook_spec_basehook_device_name_string

" 'list' 'hooks'
" family_spec_explicit->family_spec->ruleset_spec->basehook_spec->'hooks'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_hooks_basehook_spec_ruleset_spec_family_spec_explicit nftHL_Family
syn match nft_list_cmd_keyword_hooks_basehook_spec_ruleset_spec_family_spec_explicit "\v(bridge|netdev|inet|arp|ip6|ip)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_hooks_basehook_spec_ruleset_spec_family_spec_explicit,
\    nft_list_cmd_keyword_hooks_basehook_spec_basehook_device_name_keyword_device

" 'list' 'hooks'
" 'hooks'->list_cmd->'list'->base_cmd->line
hi link   nft_base_cmd_list_keyword_hooks nftHL_Statement
syn match nft_base_cmd_list_keyword_hooks "hooks" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_hooks_basehook_spec_ruleset_spec_family_spec_explicit,
\    nft_list_cmd_keyword_hooks_basehook_spec_basehook_device_name


" 'list'->base_cmd->line
hi link   nft_base_cmd_keyword_list nftHL_Command
syn match nft_base_cmd_keyword_list "list" skipwhite contained
\ nextgroup=
\    nft_base_cmd_list_keyword_table_end,
\    nft_base_cmd_list_keywords_tables_chains_ruleset_meters_flowtables_maps_end,
\    nft_base_cmd_list_keyword_chain_end,
\    nft_base_cmd_list_keywords_sets_et_al_end,
\    nft_base_cmd_list_set_map_meter_end,
\    nft_base_cmd_list_keyword_flowtables,
\    nft_base_cmd_list_keyword_flowtable,
\    nft_base_cmd_list_keyword_flow,
\    nft_base_cmd_list_keyword_ct,
\    nft_base_cmd_list_keyword_hooks,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" removed nft_list_cmd_keywords_counter_et_al_obj_spec; not supported
"***************** END list_cmd *************************

  for s:this_semantic_file in s:list_cmd_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded list_cmd for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define list_cmd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_list_cmd = v:true
