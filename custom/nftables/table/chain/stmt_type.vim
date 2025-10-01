" File: stmt_policy.vim
" Directory: custom/nftables/table/chain/
"
let s:stmt_policy_list_filepaths_semantic_early = []
let s:stmt_policy_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_policy')
  call nftables#syntax#log('INFO', 'Skipped stmt_policy (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_policy_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_policy syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "


"**** BEGIN of table <identifier> { chain <identifier> {"
" add 'table' table_block chain_block hook_spec
" add_cmd 'table' table_block 'chain' chain_block ';'
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_separator nftHL_Separator
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_separator /;/ skipwhite contained
\ nextgroup=
\    nft_comment_inline

" cmd_add 'table' table_block chain_block hook_spec 'type' prio_spec number
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_number_valid nftHL_Integer
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_number_valid "\v[\-]{0,1}[0-9]{1,5}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_separator,
\    nft_EOS,
\    nft_Error

hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_string nftHL_Error
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_string "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_number_valid

hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_variable nftHL_Variable
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_variable "\v\$[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained

hi link   nft_add_cmd_keyword_table_table_block_chain_chain_hook_spec_prio_spec_signs nftHL_Operator
syn match nft_add_cmd_keyword_table_table_block_chain_chain_hook_spec_prio_spec_signs "\v[\-\+]" skipwhite contained
\ nextgroup =
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_number_valid

hi link   nft_add_cmd_keyword_table_bridge_table_block_chain_block_hook_spec_prio_spec_valid_defines nftHL_Define
syn match nft_add_cmd_keyword_table_bridge_table_block_chain_block_hook_spec_prio_spec_valid_defines '\v(dstnat|filter|srcnat|out)' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_hook_spec_prio_spec_signs,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_separator

hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_valid_defines nftHL_Define
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_valid_defines '\v(security|dstnat|filter|mangle|srcnat|raw|out)' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_hook_spec_prio_spec_signs,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_separator

" cmd_add 'table' table_block chain_block hook_spec 'type' prio_spec 'priority'
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec nftHL_Command
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec '\vpriority\ze\s' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_valid_defines,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_variable,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_number_valid,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedSymbol,
\    nft_Error

" add_cmd 'table' table_block 'chain' chain_block hook_spec 'type' dev_spec 'device' string
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_device_string nftHL_Device
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_device_string  "\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec

" add_cmd 'table' table_block 'chain' chain_block hook_spec 'type' dev_spec 'device' variable_expr
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_device_variable_expr nftHL_Variable
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_device_variable_expr "\v\$[a-zA-Z0-9\_\-]{1,64}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec

" add_cmd 'table' table_block 'chain' chain_block hook_spec 'type' dev_spec 'device'
syn cluster nft_c_add_table_block_chain_block_hook_spec_dev_spec_device_variable_expr_or_string
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_device_variable_expr,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_device_string

" add_cmd 'table' table_block 'chain' chain_block hook_spec 'type' dev_spec 'device'
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_device nftHL_Statement
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_device "device" skipwhite contained
\ nextgroup=
\    @nft_c_add_table_block_chain_block_hook_spec_dev_spec_device_variable_expr_or_string

" add_cmd 'table' table_block 'chain' chain_block hook_spec 'type' dev_spec 'devices' flowtable_expr variable_expr
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_devices_flowtable_expr_variable_expr nftHL_Variable
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_devices_flowtable_expr_variable_expr "\v\$[a-zA-Z0-9\_\-]{1,64}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec


" add_cmd 'table' table_block 'chain' chain_block hook_spec 'type' dev_spec 'devices. flowtable_expr flowtable_block flowtable_member_expr <string> ','
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_comma nftHL_Element
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_comma "," skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_variable,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string_quote_doubles,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string_quote_singles,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string


" add_cmd 'table' table_block 'chain' chain_block hook_spec 'type' dev_spec 'devices. flowtable_expr flowtable_block flowtable_member_expr <string>
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string nftHL_String
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string "\v[a-zA-Z0-9 \t]{1,64}" skipwhite oneline contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_comma

" add_cmd 'table' table_block 'chain' chain_block hook_spec 'type' dev_spec 'devices. flowtable_expr flowtable_block flowtable_member_expr "'" <string> "'"
hi link    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string_quote_singles nftHL_String
syn region nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string_quote_singles start="\'" end="\'" skip="\\\'" skipwhite oneline contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_comma

" add_cmd 'table' table_block 'chain' chain_block hook_spec 'type' dev_spec 'devices. flowtable_expr flowtable_block flowtable_member_expr '"' <string> '"'
hi link    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string_quote_doubles nftHL_String
syn region nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string_quote_doubles start="\"" end="\"" skip="\\\"" skipwhite oneline contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_comma

" add_cmd 'table' table_block 'chain' chain_block hook_spec 'type' dev_spec 'devices. flowtable_expr flowtable_block flowtable_member_expr
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_variable nftHL_Variable
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_variable "\v\$[a-zA-Z][a-zA-Z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_comma

" add 'table' table_block chain_block hook_spec dev_spec devices flowtable_expr flowtable_block
hi link    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_devices_flowtable_expr_block nftHL_BlockDelimitersFlowTable
syn region nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_devices_flowtable_expr_block skipnl skipempty skipwhite contained
\ start='\v\{' end='\v\}'
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_variable,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string_quote_doubles,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string_quote_singles,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec

" add 'table' table_block chain_block hook_spec dev_spec devices flowtable_expr
syn cluster nft_c_add_table_block_chain_block_hook_spec_dev_spec_flowtable_expr
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_devices_flowtable_expr_variable_expr,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_devices_flowtable_expr_block,
\    nft_MissingDeviceVariable,
\    nft_UnexpectedEOS

" add 'table' table_block chain_block hook_spec dev_spec devices '='
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_devices_equal nftHL_Operator
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_devices_equal "=" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_devices_flowtable_expr_variable_expr,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_devices_flowtable_expr_block,
\    nft_MissingDeviceVariable,
\    nft_UnexpectedEOS

" dev_spec 'devices ='
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_devices nftHL_Statement
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_devices "devices" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_devices_equal,
\    nft_UnexpectedEOS

" dev_spec (via hook_spec)
hi link     nft_c_add_table_block_chain_block_hook_spec_dev_spec nftHL_Identifier
syn cluster nft_c_add_table_block_chain_block_hook_spec_dev_spec
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_devices,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_device,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec

hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_hooks nftHL_Hook
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_hooks "\v(postrouting|prerouting|forward|ingress|egress|output|input)" skipnl skipwhite contained
\ nextgroup=
\    @nft_c_add_table_block_chain_block_hook_spec_dev_spec,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec,
\    nft_UnexpectedSemicolon

hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_keyword_hook nftHL_Statement
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_keyword_hook "\vhook\ze\s" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_hooks,
\    nft_UnexpectedSemicolon,
\    nft_Error

hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_types nftHL_Type
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_types "\v(filter|route|nat)" skipnl skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_keyword_hook,
\    nft_UnexpectedSemicolon,
\    nft_Error

hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_keyword_type nftHL_Command
" A more restrictive type look-behind is required due to reuse of 'type' keyword elsewhere:
" A left curly brace or a new line (start of line)
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_keyword_type "\v(^|\{)\s{0,40}[ \t]{0,40}\zstype" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_types,
\    nft_UnexpectedSymbol,
\    nft_UnexpectedSemicolon,
\    nft_Error


  for s:this_semantic_file in s:stmt_policy_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_policy for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_policy.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_policy = v:true
