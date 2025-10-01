" File: ~/.vim/custom/nftables/add_cmd.vim
"
let s:add_cmd_list_filepaths_semantic_early = [
\    'add/add_secmark_cmd.vim',
\    'add/add_chain_cmd.vim',
\    'add/add_table_cmd.vim',
\    'add/add_map_cmd.vim',
\    'add/add_set_cmd.vim',
\  ]
let s:add_cmd_list_filepaths_semantic_later = []

if exists('b:did_nftables_add_cmd')
  call nftables#syntax#log('INFO', 'Skipped add_cmd (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:add_cmd_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading add_cmd syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "


call nftables#syntax#define_match(
\    'nft_base_cmd_keyword_add',
\    [],
\    ['nft_base_cmd_add_cmd_keyword_flowtable',
\     'nft_base_cmd_add_cmd_keyword_synproxy',
\     'nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_bridge',
\     'nft_base_cmd_add_cmd_keyword_counter',
\     'nft_base_cmd_add_cmd_keyword_element',
\     'nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_netdev',
\     'nft_base_cmd_add_cmd_keyword_secmark',
\     'nft_base_cmd_add_cmd_keyword_chain_imperative',
\     'nft_base_cmd_add_cmd_keyword_quota',
\     'nft_base_cmd_add_cmd_keyword_table_imperative',
\     'nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_inet',
\     'nft_base_cmd_add_cmd_keyword_rule',
\     'nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_arp',
\     'nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip6',
\     'nft_base_cmd_add_cmd_keyword_map',
\     'nft_base_cmd_add_cmd_keyword_set',
\     'nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip',
\     'nft_Error'],
\    '\vadd\ze ',
 \    'nftHL_Command' )
" \    { 'skipwhite' : 1, 'contained' : 1 })

syn cluster nft_c_base_cmd_add_cmd_unused_placeholder
\ contains=
\    nft_base_cmd_add_cmd_synproxy_keyword,
\    nft_base_cmd_add_cmd_counter_keyword,
\    nft_base_cmd_add_cmd_keyword_element,
\    nft_base_cmd_add_cmd_keyword_secmark,
\    nft_base_cmd_add_cmd_keyword_chain,
\    nft_base_cmd_add_cmd_keyword_limit,
\    nft_base_cmd_add_cmd_keyword_table_declarative,
\    nft_base_cmd_add_cmd_keyword_table_imperative,
\    nft_base_cmd_add_cmd_keyword_rule,
\    nft_base_cmd_keyword_add,
\    nft_base_cmd_add_cmd_keyword_map,
\    nft_base_cmd_add_cmd_keyword_set

"********** base_cmd END *************************************************
  for s:this_semantic_file in s:add_cmd_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded add_cmd for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define add_cmd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_add_cmd = v:true


