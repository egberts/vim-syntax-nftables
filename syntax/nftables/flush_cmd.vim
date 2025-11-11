" File: flush_cmd.vim
" Directory: custom/nftables/
"
let s:flush_cmd_list_filepaths_semantic_early = []
let s:flush_cmd_list_filepaths_semantic_later = []

if exists('b:did_nftables_flush_cmd')
  call nftables#syntax#log('INFO', 'Skipped flush_cmd (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:flush_cmd_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading flush_cmd syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

"***************** flush_cmd BEGIN *****************
" base_cmd 'flush' 'ruleset' ruleset_spec
hi link   nft_flush_cmd_keyword_ruleset_ruleset_spec_family_spec_explicit nftHL_Family
syn match nft_flush_cmd_keyword_ruleset_ruleset_spec_family_spec_explicit '\v(inet|ip6|ip)\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_stmt_separator,
\    nft_EOS,
\    nft_EOL,
\    nft_Error

" base_cmd 'flush' 'ruleset' set_spec
" family_spec_explicit->ruleset_spec->'ruleset'->flush_cmd-'flush'->base_cmd->line
hi link   nft_flush_cmd_keyword_ruleset_end nftHL_Command
syn match nft_flush_cmd_keyword_ruleset_end '\vruleset\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_flush_cmd_keyword_ruleset_ruleset_spec_family_spec_explicit,
\    nft_UnexpectedSemicolon,
\    nft_EOS,
\    nft_Error

" base_cmd flush_cmd 'chain' [ family_spec ] table_spec chain_spec
" identifier->chain_spec->'chain'->flush_cmd->'flush'->base_cmd->line
hi link   nft_flush_cmd_keyword_set_et_al_chain_spec_identifier nftHL_Identifier
syn match nft_flush_cmd_keyword_set_et_al_chain_spec_identifier '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_stmt_separator,
\    nft_UnexpectedVariable,
\    nft_UnexpectedNonIdentifier,
\    nft_EOL,
\    nft_Error

" flush_cmd 'set' set_spec family_spec family_spec_explicit
" identifier->table_spec->chain_spec->'chain'->flush_cmd->'flush'->base_cmd->line
hi link   nft_flush_cmd_keyword_set_et_al_table_spec_identifier nftHL_Identifier
syn match nft_flush_cmd_keyword_set_et_al_table_spec_identifier '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_flush_cmd_keyword_set_et_al_chain_spec_identifier,
\    nft_UnexpectedSymbol,
\    nft_Error

" family_spec_explicit->table_spec->chain_spec->'chain'->flush_cmd->'flush'->base_cmd->line
hi link   nft_flush_cmd_keyword_set_et_al_set_spec_family_spec_explicit nftHL_Family
syn match nft_flush_cmd_keyword_set_et_al_set_spec_family_spec_explicit '\v(bridge|netdev|inet|arp|ip6|ip)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_flush_cmd_keyword_set_et_al_table_spec_identifier,
\    nft_UnexpectedSymbol,
\    nft_Error

" base_cmd flush_cmd 'set' set_spec
syn cluster nft_c_flush_cmd_keyword_set_et_al_set_spec_end
\ contains=
\    nft_flush_cmd_keyword_set_et_al_set_spec_family_spec_explicit,
\    nft_flush_cmd_keyword_set_et_al_table_spec_identifier

" base_cmd [ 'flush' ] [ 'set' ] set_spec
" base_cmd [ 'flush' ] [ 'meter' ] set_spec
hi link   nft_flush_cmd_keyword_set_map_meter_end nftHL_Command
syn match nft_flush_cmd_keyword_set_map_meter_end '\v(set|map)\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_flush_cmd_keyword_set_et_al_set_spec_end,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd flush_cmd 'chain' [ family_spec ] table_spec chain_spec
hi link   nft_flush_cmd_keyword_chain_chain_spec_identifier nftHL_Identifier
syn match nft_flush_cmd_keyword_chain_chain_spec_identifier '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_stmt_separator,
\    nft_EOL,
\    nft_Error

" base_cmd flush_cmd 'chain' [ family_spec ] table_spec
hi link   nft_flush_cmd_keyword_chain_table_spec_identifier nftHL_Identifier
syn match nft_flush_cmd_keyword_chain_table_spec_identifier '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_flush_cmd_keyword_chain_chain_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" flush_cmd 'chain' chain_spec family_spec family_spec_explicit
hi link   nft_flush_cmd_keyword_chain_chain_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_flush_cmd_keyword_chain_chain_spec_table_spec_family_spec_explicit '\v(bridge|netdev|inet|arp|ip6|ip)\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_flush_cmd_keyword_chain_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd flush_cmd 'chain' chain_spec
syn cluster nft_c_flush_cmd_keyword_chain_end
\ contains=
\    nft_flush_cmd_keyword_chain_chain_spec_table_spec_family_spec_explicit,
\    nft_flush_cmd_keyword_chain_table_spec_identifier,
\    nft_Error

" base_cmd flush_cmd 'chain'
" base_cmd [ 'flush' ] [ 'chain' ] chain_spec
hi link   nft_flush_cmd_keyword_chain nftHL_Command
syn match nft_flush_cmd_keyword_chain "chain" skipwhite contained
\ nextgroup=
\    @nft_c_flush_cmd_keyword_chain_end,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd flush_cmd 'table' table_spec family_spec identifier
hi link   nft_flush_cmd_keyword_flush_table_spec_identifier nftHL_Identifier
syn match nft_flush_cmd_keyword_flush_table_spec_identifier '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_stmt_separator,
\    nft_UnexpectedVariable,
\    nft_EOL,
\    nft_Error

" base_cmd flush_cmd 'table' table_spec family_spec family_spec_explicit
hi link   nft_flush_cmd_keyword_flush_table_spec_family_spec_explicit nftHL_Family  " _add_ to make 'table_spec' pathway unique
syn match nft_flush_cmd_keyword_flush_table_spec_family_spec_explicit '\v(bridge|netdev|inet|arp|ip6|ip)\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    nft_flush_cmd_keyword_flush_table_spec_identifier,
\    nft_Error

" base_cmd [ 'flush' ] [ 'table' ] table_spec
" table_spec->'table'->flush_cmd->'flush'->base_cmd->line
syn cluster nft_c_flush_cmd_keyword_flush_table_spec_end
\ contains=
\    nft_flush_cmd_keyword_flush_table_spec_family_spec_explicit,
\    nft_flush_cmd_keyword_flush_table_spec_identifier,
\    nft_Error


" base_cmd flush_cmd 'table'
" 'table'->flush_cmd->'flush'->base_cmd->line
hi link   nft_flush_cmd_keyword_table nftHL_Command
syn match nft_flush_cmd_keyword_table '\vtable\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_flush_cmd_keyword_flush_table_spec_family_spec_explicit,
\    nft_flush_cmd_keyword_flush_table_spec_identifier,
\    nft_Error

" base_cmd flush_cmd 'flowtable'
" 'flowtable'->flush_cmd->'flush'->base_cmd->line
hi link   nft_flush_cmd_keyword_flowtable nftHL_Command
syn match nft_flush_cmd_keyword_flowtable '\vflowtable\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_flush_cmd_keyword_chain_end

" 'flush'->base_cmd->line
hi link   nft_base_cmd_keyword_flush nftHL_Command
syn match nft_base_cmd_keyword_flush '\vflush\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_flush_cmd_keyword_flowtable,
\    nft_flush_cmd_keyword_table,
\    nft_flush_cmd_keyword_chain,
\    nft_flush_cmd_keyword_set_map_meter_end,
\    nft_flush_cmd_keyword_ruleset_end,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
"***************** flush_cmd END *****************

  for s:this_semantic_file in s:flush_cmd_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded flush_cmd for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define flush_cmd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_flush_cmd = v:true
