" File: ~/.vim/custom/nftables/create_cmd.vim

let s:sub_files = []

if exists('b:did_nftables_create_cmd')
  call nftables#syntax#log('INFO', 'Skipped create_cmd.vim (already loaded for buffer: ' . bufname('%') . ')')
  finish
endif

" save the filespec of this script into a stack for logging purpose
" echom '<sfile>:p: ' . expand('<sfile>:p')
let s:filepath_this_script = resolve(expand('<sfile>:p'))
" echom 's:filepath_this_script: ' . s:filepath_this_script
call nftables#syntax#push(s:filepath_this_script)

call nftables#syntax#log('OK', 'Begin.')

let s:sub_dir = fnamemodify(s:filepath_this_script, ':p:h') . '/sub_dir/'
for sub in s:sub_files
  call nftables#syntax#load(sub)
endfor

call nftables#syntax#debug('Loading create_cmd ...')
call nftables#syntax#log('INFO', 'Loaded create_cmd for buffer: ' . bufname('%'))

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
\    nft_c_add_table_spec,
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
\    nft_get_et_al_cmd_keyword_element,
\    nft_create_cmd_keyword_secmark,
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
" **************** END 'create' *****************************

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Common ending
let b:did_nftables_create_cmd = 1

