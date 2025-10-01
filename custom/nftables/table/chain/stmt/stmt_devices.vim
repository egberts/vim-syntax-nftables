" File: stmt_devices.vim
" Directory: custom/nftables/table/chain/stmt/
"
let s:stmt_devices_list_filepaths_semantic_early = []
let s:stmt_devices_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_devices')
  call nftables#syntax#log('INFO', 'Skipped stmt_devices (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_devices_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_devices syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

" 'table' identifier '{' 'chain' identifier '{' 'devices' '=' '$'identifier
" '$'identifier->'='->'devices'->chain_block->'chain'->table_block->'table'->add_cmd
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_variable_expr nftHL_Variable
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_variable_expr "\v\$[a-zA-Z][a-zA-Z0-9\/\\_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_stmt_separator

" 'table' identifier '{' 'chain' identifier '{' 'devices' '=' '{' flowtable_expr_member ','
" ','->flowtable_expr_member->'{'->'='->'devices'->chain_block->'chain'->table_block->'table'->add_cmd
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_comma nftHL_Operator
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_comma "," skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member

" 'table' identifier '{' 'chain' identifier '{' 'devices' '=' '{' <STRING>
" <STRING>->'{'->'='->'devices'->chain_block->'chain'->table_block->'table'->add_cmd
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_string nftHL_String
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_string "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_comma,
\    nft_CurlyBraceAheadSilent,
\    nftHL_Error

" 'table' identifier '{' 'chain' identifier '{' 'devices' '=' '{' '$'identifier
" '$'identifier->'{'->'='->'devices'->chain_block->'chain'->table_block->'table'->add_cmd
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_variable_expr nftHL_Variable
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_variable_expr "\v\$[a-zA-Z][a-zA-Z0-9\/\\_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_comma,
\    nft_CurlyBraceAheadSilent,
\    nftHL_EOS,
\    nftHL_Error

syn match nft_CurlyBraceAheadSilent "\v\ze\}" skipwhite contained

" 'table' identifier '{' 'chain' identifier '{' 'devices' '=' '{' <QUOTED_STRING>
" <QUOTED_STRING>->'{'->'='->'devices'->chain_block->'chain'->table_block->'table'->add_cmd
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_quoted_string nftHL_String
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_quoted_string "\v\"[a-zA-Z][a-zA-Z0-9\/\\_\.\-]{0,63}\"" keepend skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_comma,
\    nft_CurlyBraceAheadSilent,
\    nftHL_EOS,
\    nftHL_Error

" 'table' identifier '{' 'chain' identifier '{' 'devices' '=' '{' flowtable_expr_member
" flowtable_expr_member->'{'->'='->'devices'->chain_block->'chain'->table_block->'table'->add_cmd
syn cluster nft_c_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_variable_expr,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_quoted_string,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_string

hi link   nft_MissingDeviceVariable2 nftHL_Error
syn match nft_MissingDeviceVariable2 "\v[^\$\{\}]{1,5}" skipwhite contained " do not use 'keepend' here

syn cluster nft_c_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block
\ contains=@nft_c_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member

" 'table' identifier '{' 'chain' identifier '{' 'devices' '=' '{' flowtable_expr_block
" flowtable_expr_block->'{'->'='->'devices'->chain_block->'chain'->table_block->'table'->add_cmd
hi link    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block nftHL_BlockDelimitersFlowTable
syn region nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block start=/{/ end=/}/ skipwhite contained
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_variable_expr,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_quoted_string,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_string
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_stmt_separator

" 'table' identifier '{' 'chain' identifier '{' 'devices' '='
" '='->'devices'->chain_block->'chain'->table_block->'table'->add_cmd
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_equal nftHL_Operator
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_equal "=" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_variable_expr,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block,
\    nft_UnexpectedSemicolon,
\    nft_Error

" 'table' identifier '{' 'chain' identifier '{' 'devices'
" 'devices'->chain_block->'chain'->table_block->'table'->add_cmd->base_cmd->line
" 'devices'->chain_block->'chain'->table_block->'table'->add_cmd->'add'->base_cmd->line
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_keyword_devices nftHL_Statement
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_keyword_devices "devices" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_equal


  for s:this_semantic_file in s:stmt_devices_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_devices for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_devices.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_devices = v:true
