" File: template_name.vim
" Directory: custom/nftables/table/add/
"
let s:template_name_list_filepaths_semantic_early = []
let s:template_name_list_filepaths_semantic_later = []

if exists('b:did_nftables_template_name')
  call nftables#syntax#log('INFO', 'Skipped template_name (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:template_name_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading template_name syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "


" base_cmd add_cmd 'limit' <table_id> <limit_id>
hi link   nft_add_cmd_keyword_limit_obj_spec_identifier nftHL_Identifier
syn match nft_add_cmd_keyword_limit_obj_spec_identifier "\v[A-Za-z][A-Za-z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_keyword_rate,
\    nft_add_cmd_limit_limit_block,
\    nft_Error

" base_cmd add_cmd 'limit' table_spec
hi link   nft_add_cmd_keyword_limit_obj_spec_table_spec_identifier nftHL_Identifier
syn match nft_add_cmd_keyword_limit_obj_spec_table_spec_identifier "\v[A-Za-z][A-Za-z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_obj_spec_identifier

" base_cmd add_cmd 'limit' ('ip'|'ip6'|'inet'|'arp'|'bridge'|'netdev')
" base_cmd add_cmd 'limit' family_spec
hi link   nft_add_cmd_keyword_limit_obj_spec_family_spec nftHL_Family
syn match nft_add_cmd_keyword_limit_obj_spec_family_spec "\v(bridge|netdev|inet|arp|ip6|ip)" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_obj_spec_table_spec_identifier

hi link   nft_add_cmd_table_block_limit_block_separator nftHL_Separator
syn match nft_add_cmd_table_block_limit_block_separator /;/ skipwhite contained

  for s:this_semantic_file in s:template_name_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded template_name for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define template_name.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_template_name = v:true
