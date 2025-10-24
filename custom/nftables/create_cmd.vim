" File:  create_cmd.vim
" Directory: custom/nftables/
"
let s:create_cmd_list_filepaths_semantic_early = []
let s:create_cmd_list_filepaths_semantic_later = []

if exists('b:did_nftables_create_cmd')
  call nftables#syntax#log('INFO', 'Skipped create_cmd (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:create_cmd_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading create_cmd syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "


" **************** BEGIN 'create synproxy' ***************************
hi link   nft_create_cmd_keyword_synproxy nftHL_Command
syn match nft_create_cmd_keyword_synproxy "synproxy" skipwhite contained
\ nextgroup=
\    nft_create_cmd_keyword_secmark_obj_spec_table_spec_family_spec_explicit,
\    nft_create_cmd_keyword_secmark_obj_spec_table_spec_identifier_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" **************** END 'create synproxy' ***************************

" **************** BEGIN 'create secmark' **************************
hi link   nft_create_cmd_keyword_secmark_secmark_config_string_unquoted nftHL_String
syn match nft_create_cmd_keyword_secmark_secmark_config_string_unquoted "\v[a-zA-Z0-9\\\/_\-\.\[\]\(\) ]{2,45}" skipwhite contained

hi link    nft_create_cmd_keyword_secmark_secmark_config_string_quoted_single nftHL_String
syn region nft_create_cmd_keyword_secmark_secmark_config_string_quoted_single start="\'" end="\'" skip="\\\'" skipwhite contained

hi link    nft_create_cmd_keyword_secmark_secmark_config_string_quoted_double nftHL_String
syn region nft_create_cmd_keyword_secmark_secmark_config_string_quoted_double start="\"" end="\"" skip="\\\"" oneline skipwhite contained


hi link   nft_create_cmd_keyword_secmark_obj_spec_identifier_secmark nftHL_Identifier
syn match nft_create_cmd_keyword_secmark_obj_spec_identifier_secmark "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_create_cmd_keyword_secmark_secmark_config_string_quoted_single,
\    nft_create_cmd_keyword_secmark_secmark_config_string_quoted_double,
\    nft_create_cmd_keyword_secmark_secmark_config_string_unquoted,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

hi link   nft_create_cmd_keyword_secmark_obj_spec_table_spec_identifier_table nftHL_Table
syn match nft_create_cmd_keyword_secmark_obj_spec_table_spec_identifier_table "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_create_cmd_keyword_secmark_obj_spec_identifier_secmark,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

hi link   nft_create_cmd_keyword_secmark_obj_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_create_cmd_keyword_secmark_obj_spec_table_spec_family_spec_explicit "\v(bridge|netdev|inet|arp|ip6|ip)" skipwhite contained
\ nextgroup=
\    nft_create_cmd_keyword_secmark_obj_spec_table_spec_identifier_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

hi link   nft_create_cmd_keyword_secmark nftHL_Command
syn match nft_create_cmd_keyword_secmark "secmark" skipwhite contained
\ nextgroup=
\    nft_create_cmd_keyword_secmark_obj_spec_table_spec_family_spec_explicit,
\    nft_create_cmd_keyword_secmark_obj_spec_table_spec_identifier_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" **************** END 'create secmark' ****************************

" *************** BEGIN 'create table' ***************************
hi link   nft_create_cmd_keyword_table_identifier_chain nftHL_Table
syn match nft_create_cmd_keyword_table_identifier_chain "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    @nft_c_add_table_spec,
\    nft_EOS

hi link   nft_create_cmd_keyword_table_identifier_table nftHL_Table
syn match nft_create_cmd_keyword_table_identifier_table "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_create_cmd_keyword_table_identifier_chain,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

hi link   nft_create_cmd_keyword_table_absolute_family_spec nftHL_Family
syn match nft_create_cmd_keyword_table_absolute_family_spec "\v(bridge|netdev|inet|arp|ip6|ip)" skipwhite contained
\ nextgroup=
\    nft_create_cmd_keyword_table_identifier_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

hi link   nft_create_cmd_keyword_table nftHL_Statement
syn match nft_create_cmd_keyword_table "\vtable\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_create_cmd_keyword_table_absolute_family_spec,
\    nft_create_cmd_keyword_table_identifier_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS
" **************** END 'create' 'table' *********************

" **************** BEGIN 'create' ***************************
" 'create'->base_cmd->line
hi link   nft_base_cmd_keyword_create nftHL_Command
syn match nft_base_cmd_keyword_create 'create' skipwhite contained
\ nextgroup=
\    nft_base_cmd_add_cmd_keyword_flowtable,
\    nft_create_cmd_keyword_synproxy,
\    nft_base_cmd_add_cmd_keyword_counter,
\    nft_get_et_al_cmd_keyword_elements,
\    nft_base_cmd_add_cmd_keyword_table_imperative,
\    nft_base_cmd_add_cmd_keyword_chain_imperative,
\    nft_base_cmd_add_cmd_keyword_quota,
\    nft_base_cmd_add_cmd_keyword_limit,
\    nft_base_cmd_add_cmd_keyword_set,
\    nft_base_cmd_add_cmd_keyword_map,
\    nft_base_cmd_add_cmd_keyword_ct,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" no 'secmark' in create: nft_create_cmd_keyword_secmark
" **************** END 'create' *****************************


  for s:this_semantic_file in s:create_cmd_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded create_cmd for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define create_cmd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_create_cmd = v:true
