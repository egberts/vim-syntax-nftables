
if exists('g:nft_did_create_cmd')
  finish
endif

if exists('b:current_syntax') && b:current_syntax ==# 'nftables'
  finish
endif
let s:script_dir = expand('<sfile>:p:h')
call nftables#syntax#debug('create_cmd.vim: Loading create_cmd.vim ...' )

" 'create'->base_cmd->line
hi link   nft_base_cmd_keyword_create nftHL_Command
syn match nft_base_cmd_keyword_create 'create' skipwhite contained
\ nextgroup=
\    nft_base_cmd_add_cmd_keyword_flowtable,
\    nft_create_cmd_keyword_synproxy,
\    nft_base_cmd_add_cmd_keyword_counter,
\    nft_get_et_al_cmd_keyword_element,
\    nft_create_cmd_keyword_secmark,
\    nft_base_cmd_add_cmd_keyword_table_declarative,
\    nft_base_cmd_add_cmd_keyword_chain,
\    nft_base_cmd_add_cmd_keyword_quota,
\    nft_base_cmd_add_cmd_keyword_limit,
\    nft_base_cmd_add_cmd_keyword_set,
\    nft_base_cmd_add_cmd_keyword_map,
\    nft_base_cmd_add_cmd_keyword_ct,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" *************** END create_cmd *******************

let g:nft_did_create_cmd = v:true

