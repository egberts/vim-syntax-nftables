" File: table_block_ct.vim
" Directory: custom/nftables/
"
let s:table_block_ct_list_filepaths_semantic_early = []
let s:table_block_ct_list_filepaths_semantic_later = []

if exists('b:did_nftables_table_block_ct')
  call nftables#syntax#log('INFO', 'Skipped table_block_ct (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:table_block_ct_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading table_block_ct syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "


" **************** BEGIN table_block ct timeout **************************************
" ********* BEGIN table_block 'ct' 'timeout' '{' **************************************
hi link   nft_ct_timeout_block_separator nftHL_Separator
syn match nft_ct_timeout_block_separator '\v(\n|\;)' skipnl skipwhite contained
\ nextgroup=
\    nft_table_block_keyword_ct_timeout_obj_id_ct_timeout_block_keyword_protocol,
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_table_block_keyword_ct_timeout_obj_id_ct_timeout_block_keyword_l3proto,
\    nft_common_block_keyword_define,
\    nft_table_block_keyword_ct_timeout_obj_id_ct_timeout_block_keyword_protocol,
\    nft_common_block_keyword_error,
\    nft_comment_inline,
\    nft_Error
" ********* BEGIN table_block 'ct' 'timeout' '{' 'policy' **************************************
" ********* BEGIN table_block 'ct' 'timeout' '{' 'policy' '=' **************************************
" ********* BEGIN table_block 'ct' 'timeout' '{' 'policy' '=' '{' **************************************

" ********* BEGIN table_block 'ct' 'timeout' '{' 'policy' '=' '{' key ':' value **************************************
hi link   nft_table_block_ct_timeout_obj_id_ct_timeout_block_policy_value nftHL_Number
syn match nft_table_block_ct_timeout_obj_id_ct_timeout_block_policy_value "\v[a-zA-Z0-9]{1,11}" skipwhite contained
" ********* END table_block 'ct' 'timeout' '{' 'policy' '=' '{' key ':' value **************************************

" ********* BEGIN table_block 'ct' 'timeout' '{' 'policy' '=' '{' key ':' **************************************
hi link   nft_table_block_ct_timeout_obj_id_ct_timeout_block_policy_colon_separator nftHL_Expression
syn match nft_table_block_ct_timeout_obj_id_ct_timeout_block_policy_colon_separator ":" skipwhite contained
\ nextgroup=
\    nft_table_block_ct_timeout_obj_id_ct_timeout_block_policy_value
" ********* END table_block 'ct' 'timeout' '{' 'policy' '=' '{' key ':' **************************************

" ********* BEGIN table_block 'ct' 'timeout' '{' 'policy' '=' '{' key **************************************
hi link   nft_table_block_ct_timeout_obj_id_ct_timeout_block_policy_key_state nftHL_Statement
syn match nft_table_block_ct_timeout_obj_id_ct_timeout_block_policy_key_state
\ '\v(established|close_wait|syn_sent2|time_wait|unreplied|last_ack|fin_wait|syn_recv|syn_sent|replied|retrans|close|unack)'
\ skipwhite contained
\ nextgroup=
\    nft_table_block_ct_timeout_obj_id_ct_timeout_block_policy_colon_separator
" ********* END table_block 'ct' 'timeout' '{' 'policy' '=' '{' key ':' value **************************************
" ********* END table_block 'ct' 'timeout' '{' 'policy' '=' '{' key **************************************

hi link    nft_table_block_ct_timeout_obj_id_ct_timeout_block_policy_block nftHL_BlockDelimitersChain
syn region nft_table_block_ct_timeout_obj_id_ct_timeout_block_policy_block start='{' end='}' skip='\\}' skipnl skipwhite contained
\ contains=
\    nft_table_block_ct_timeout_obj_id_ct_timeout_block_policy_key_state,
\    nft_Error
" ********* END table_block 'ct' 'timeout' '{' 'policy' '=' '{' **************************************

hi link   nft_table_block_ct_timeout_obj_id_ct_timeout_block_policy_equal nftHL_Expression
syn match nft_table_block_ct_timeout_obj_id_ct_timeout_block_policy_equal "\v\=" skipwhite skipnl contained
\ nextgroup=
\   nft_table_block_ct_timeout_obj_id_ct_timeout_block_policy_block
" ********* END table_block 'ct' 'timeout' '{' 'policy' '=' **************************************

hi link   nft_table_block_ct_timeout_obj_id_ct_timeout_block_keyword_policy nftHL_Command
syn match nft_table_block_ct_timeout_obj_id_ct_timeout_block_keyword_policy "\vpolicy" skipwhite skipnl contained
\ nextgroup=
\    nft_table_block_ct_timeout_obj_id_ct_timeout_block_policy_equal
" ********* END table_block 'ct' 'timeout' '{' 'policy' **************************************

" ********* BEGIN table_block 'ct' 'timeout' '{' 'l3proto' **************************************
" ********* BEGIN table_block 'ct' 'timeout' '{' 'l3proto' [family_spec] **************************************

hi link   nft_table_block_ct_timeout_obj_id_ct_timeout_block_l3proto_family_spec_explicit nftHL_Family
syn match nft_table_block_ct_timeout_obj_id_ct_timeout_block_l3proto_family_spec_explicit '\v(bridge|netdev|inet|arp|ip6|ip)' skipwhite contained
\ nextgroup=
\    nft_ct_timeout_block_separator

hi link   nft_table_block_ct_timeout_obj_id_ct_timeout_block_keyword_l3proto nftHL_Command
syn match nft_table_block_ct_timeout_obj_id_ct_timeout_block_keyword_l3proto "l3proto" skipwhite contained
\ nextgroup=
\    nft_table_block_ct_timeout_obj_id_ct_timeout_block_l3proto_family_spec_explicit,
\    nft_Error
" ********* END table_block 'ct' 'timeout' '{' 'l3proto' **************************************

" ********* BEGIN table_block 'ct' 'timeout' '{' 'protocol' **************************************
" ********* BEGIN table_block 'ct' 'timeout' '{' 'protocol' ct_l4proto **************************************
hi link   nft_table_block_ct_timeout_obj_id_ct_timeout_block_keyword_protocol_l4proto nftHL_Family
syn match nft_table_block_ct_timeout_obj_id_ct_timeout_block_keyword_protocol_l4proto "\v(tcp|udp)\ze[ \t\n]" skipwhite contained
\ nextgroup=
\    nft_ct_timeout_block_separator
" ********* END table_block 'ct' 'timeout' '{' 'protocol' ct_l4proto **************************************

hi link   nft_table_block_ct_timeout_obj_id_ct_timeout_block_keyword_protocol nftHL_Command
syn match nft_table_block_ct_timeout_obj_id_ct_timeout_block_keyword_protocol "\vprotocol\ze[ \t\n]" skipwhite contained
\ nextgroup=
\    nft_table_block_ct_timeout_obj_id_ct_timeout_block_keyword_protocol_l4proto
" ********* END table_block 'ct' 'timeout' '{' 'protocol' **************************************


hi link    nft_table_block_ct_timeout_obj_id_ct_timeout_block nftHL_BlockDelimitersCT
syn region nft_table_block_ct_timeout_obj_id_ct_timeout_block start="{" end="}" skip="\\}" skipnl skipwhite contained
\ contains=
\    nft_table_block_ct_timeout_obj_id_ct_timeout_block_keyword_protocol,
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_table_block_ct_timeout_obj_id_ct_timeout_block_keyword_l3proto,
\    nft_common_block_keyword_define,
\    nft_table_block_ct_timeout_obj_id_ct_timeout_block_keyword_policy,
\    nft_common_block_keyword_error,
\    nft_comment_inline,
\    nft_comment_spec,
\    nft_Error
" ********* END table_block 'ct' 'timeout' '{' **************************************

" **************** BEGIN table_block ct timeout <obj_id> **************************************
hi link   nft_table_block_ct_timeout_obj_spec_identifier nftHL_Chain
syn match nft_table_block_ct_timeout_obj_spec_identifier "\v[A-Za-z][A-Za-z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_table_block_ct_timeout_obj_id_ct_timeout_block,
\    nft_common_block_keyword_error
" **************** END table_block ct timeout <obj_id> **************************************

hi link   nft_table_block_ct_keyword_timeout nftHL_Substatement
syn match nft_table_block_ct_keyword_timeout '\vtimeout\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_table_block_ct_timeout_obj_spec_identifier,
\    nft_common_block_keyword_error
" **************** END table_block ct timeout *************************************
" **************** END table_block ct timeout **************************************


" ********* BEGIN table_block 'ct' 'helper' '{' **************************************
hi link   nft_ct_helper_block_separator nftHL_Separator
syn match nft_ct_helper_block_separator '\v(\n|\;)' skipnl skipwhite contained
\ nextgroup=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_table_block_keyword_ct_helper_obj_id_ct_helper_block_keyword_l3proto,
\    nft_common_block_keyword_define,
\    nft_table_block_keyword_ct_helper_obj_id_ct_helper_block_keyword_type,
\    nft_common_block_keyword_error,
\    nft_comment_inline,
\    nft_Error
" ********* BEGIN table_block 'ct' 'helper' '{' 'l3proto' **************************************
" ********* BEGIN table_block 'ct' 'helper' '{' 'l3proto' [family_spec] **************************************

hi link   nft_table_block_ct_helper_obj_id_ct_helper_block_l3proto_family_spec_explicit nftHL_Family
syn match nft_table_block_ct_helper_obj_id_ct_helper_block_l3proto_family_spec_explicit '\v(bridge|netdev|inet|arp|ip6|ip)' skipwhite contained
\ nextgroup=
\    nft_ct_helper_block_separator

hi link   nft_table_block_ct_helper_obj_id_ct_helper_block_keyword_type nftHL_Command
syn match nft_table_block_ct_helper_obj_id_ct_helper_block_keyword_type "l3proto" skipwhite contained
\ nextgroup=
\    nft_table_block_ct_helper_obj_id_ct_helper_block_l3proto_family_spec_explicit,
\    nft_Error
" ********* END table_block 'ct' 'helper' '{' 'l3proto' **************************************

" ********* BEGIN table_block 'ct' 'helper' '{' 'type' **************************************
" ********* BEGIN table_block 'ct' 'helper' '{' 'type' quoted_string **************************************
" ********* BEGIN table_block 'ct' 'helper' '{' 'type' quoted_string 'protocol' **************************************
" ********* BEGIN table_block 'ct' 'helper' '{' 'type' quoted_string 'protocol' ct_l4proto **************************************
hi link   nft_table_block_ct_helper_obj_id_ct_helper_block_keyword_protocol_l4proto nftHL_Family
syn match nft_table_block_ct_helper_obj_id_ct_helper_block_keyword_protocol_l4proto "\v(tcp|udp)\ze[ \t\n]" skipwhite contained
\ nextgroup=
\    nft_ct_helper_block_separator
" ********* END table_block 'ct' 'helper' '{' 'type' quoted_string 'protocol' ct_l4proto **************************************

hi link   nft_table_block_ct_helper_obj_id_ct_helper_block_keyword_protocol nftHL_Keyword
syn match nft_table_block_ct_helper_obj_id_ct_helper_block_keyword_protocol "\vprotocol\ze[ \t\n]" skipwhite contained
\ nextgroup=
\    nft_table_block_ct_helper_obj_id_ct_helper_block_keyword_protocol_l4proto
" ********* END table_block 'ct' 'helper' '{' 'type' quoted_string 'protocol' **************************************

hi link   nft_table_block_ct_helper_obj_id_ct_helper_block_keyword_type_double_quoted_string nftHL_String
syn match nft_table_block_ct_helper_obj_id_ct_helper_block_keyword_type_double_quoted_string "\v\"[A-Za-z][A-Za-z0-9_\-]{0,63}\"" skipwhite contained
\ nextgroup=
\    nft_table_block_ct_helper_obj_id_ct_helper_block_keyword_protocol
" ********* END table_block 'ct' 'helper' '{' 'type' quoted_string **************************************

" table_block table_spec '{' 'ct' 'helper' obj_spec '{'
hi link   nft_table_block_ct_helper_obj_id_ct_helper_block_keyword_type nftHL_Command
syn match nft_table_block_ct_helper_obj_id_ct_helper_block_keyword_type "\vtype\ze[ \t\n]" skipwhite contained
\ nextgroup=
\    nft_table_block_ct_helper_obj_id_ct_helper_block_keyword_type_double_quoted_string
" ********* END table_block 'ct' 'helper' '{' 'type' **************************************

hi link    nft_table_block_ct_helper_obj_id_ct_helper_block nftHL_BlockDelimitersCT
syn region nft_table_block_ct_helper_obj_id_ct_helper_block start="{" end="}" skip="\\}" skipnl skipwhite contained
\ contains=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_table_block_ct_helper_obj_id_ct_helper_block_keyword_l3proto,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_table_block_ct_helper_obj_id_ct_helper_block_keyword_type,
\    nft_comment_inline,
\    nft_comment_spec,
\    nft_ct_helper_block_separator,
\    nft_Error
" ********* END table_block 'ct' 'helper' '{' **************************************

" **************** BEGIN table_block ct helper <obj_id> **************************************
hi link   nft_table_block_ct_helper_obj_spec_identifier nftHL_Chain
syn match nft_table_block_ct_helper_obj_spec_identifier "\v[A-Za-z][A-Za-z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_table_block_ct_helper_obj_id_ct_helper_block,
\    nft_common_block_keyword_error
" **************** END table_block ct helper <obj_id> **************************************

hi link   nft_table_block_ct_keyword_helper nftHL_Substatement
syn match nft_table_block_ct_keyword_helper '\vhelper\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_table_block_ct_helper_obj_spec_identifier,
\    nft_common_block_keyword_error
" **************** END table_block ct helper **************************************


" **************** BEGIN table_block ct expectation **************************************
" ********* BEGIN table_block 'ct' 'expectation' '{' **************************************
hi link   nft_ct_expectation_block_separator nftHL_Separator
syn match nft_ct_expectation_block_separator '\v(\n|\;)' skipnl skipwhite contained
\ nextgroup=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_table_block_keyword_ct_expectation_obj_id_ct_expectation_block_keyword_l3proto,
\    nft_common_block_keyword_define,
\    nft_table_block_keyword_ct_expectation_obj_id_ct_expectation_block_keyword_protocol,
\    nft_common_block_keyword_error,
\    nft_comment_inline,


" ********* BEGIN table_block 'ct' 'expectation' '{' 'timeout' **************************************
" ********* BEGIN table_block 'ct' 'expectation' '{' 'timeout' ct_l4proto **************************************
hi link   nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_timeout_NUM nftHL_Number
syn match nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_timeout_NUM "\v[0-9]{1,11}\ze[ \t\n;]" skipwhite contained
\ nextgroup=
\    nft_ct_expectation_block_separator
" ********* END table_block 'ct' 'expectation' '{' 'timeout' ct_l4proto **************************************

hi link   nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_timeout nftHL_Command
syn match nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_timeout "\vtimeout\ze[ \t\n]" skipwhite contained
\ nextgroup=
\    nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_timeout_NUM,
\    nft_UnexpectedEOS
" ********* END table_block 'ct' 'expectation' '{' 'timeout' **************************************



" ********* BEGIN table_block 'ct' 'expectation' '{' 'l3proto' **************************************
" ********* BEGIN table_block 'ct' 'expectation' '{' 'l3proto' [family_spec] **************************************
hi link   nft_table_block_ct_expectation_obj_id_ct_expectation_block_l3proto_family_spec_explicit nftHL_Family
syn match nft_table_block_ct_expectation_obj_id_ct_expectation_block_l3proto_family_spec_explicit '\v(bridge|netdev|inet|arp|ip6|ip)\ze[ \t\n;]' skipnl skipwhite contained
\ nextgroup=
\    nft_ct_expectation_block_separator

hi link   nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_l3proto nftHL_Command
syn match nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_l3proto "\vl3proto\ze[ \t\n]" skipwhite contained
\ nextgroup=
\    nft_table_block_ct_expectation_obj_id_ct_expectation_block_l3proto_family_spec_explicit
" ********* END table_block 'ct' 'expectation' '{' 'l3proto' **************************************

" ********* BEGIN table_block 'ct' 'expectation' '{' 'protocol' **************************************
" ********* BEGIN table_block 'ct' 'expectation' '{' 'protocol' ct_l4proto **************************************
hi link   nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_protocol_l4proto nftHL_Family
syn match nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_protocol_l4proto "\v(tcp|udp)\ze[ \t\n;]" skipwhite contained
\ nextgroup=
\    nft_ct_expectation_block_separator
" ********* END table_block 'ct' 'expectation' '{' 'protocol' ct_l4proto **************************************

hi link   nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_protocol nftHL_Command
syn match nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_protocol "\vprotocol\ze[ \t\n]" skipwhite contained
\ nextgroup=
\    nft_UnexpectedEOS,
\    nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_protocol_l4proto
" ********* END table_block 'ct' 'expectation' '{' 'protocol' **************************************

" ********* BEGIN table_block 'ct' 'expectation' '{' 'dport' **************************************
" ********* BEGIN table_block 'ct' 'expectation' '{' 'dport' ct_l4proto **************************************
hi link   nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_dport_NUM nftHL_Number
syn match nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_dport_NUM "\v[0-9]{1,11}\ze[ \t\n;]" skipwhite contained
\ nextgroup=
\    nft_ct_expectation_block_separator
" ********* END table_block 'ct' 'expectation' '{' 'dport' ct_l4proto **************************************

hi link   nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_dport nftHL_Command
syn match nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_dport "\vdport\ze[ \t\n]" skipwhite contained
\ nextgroup=
\    nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_dport_NUM,
\    nft_UnexpectedEOS
" ********* END table_block 'ct' 'expectation' '{' 'dport' **************************************

" ********* BEGIN table_block 'ct' 'expectation' '{' 'size' **************************************
" ********* BEGIN table_block 'ct' 'expectation' '{' 'size' ct_l4proto **************************************
hi link   nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_size_NUM nftHL_Number
syn match nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_size_NUM "\v[0-9]{1,11}\ze[ \t\n;]" skipwhite contained
\ nextgroup=
\    nft_ct_expectation_block_separator
" ********* END table_block 'ct' 'expectation' '{' 'size' ct_l4proto **************************************

hi link   nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_size nftHL_Command
syn match nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_size "\vsize\ze[ \t\n]" skipwhite contained
\ nextgroup=
\    nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_size_NUM,
\    nft_UnexpectedEOS
" ********* END table_block 'ct' 'expectation' '{' 'size' **************************************



hi link    nft_table_block_ct_expectation_obj_id_ct_expectation_block nftHL_BlockDelimitersCT
syn region nft_table_block_ct_expectation_obj_id_ct_expectation_block start="{" end="}" skip="\\}" skipnl skipwhite contained
\ contains=
\    nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_protocol,
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_l3proto,
\    nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_timeout,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_dport,
\    nft_table_block_ct_expectation_obj_id_ct_expectation_block_keyword_size,
\    nft_comment_inline,
\    nft_comment_spec,
\    nft_Error
" ********* END table_block 'ct' 'expectation' '{' **************************************

" **************** BEGIN table_block ct expectation <obj_id> **************************************
hi link   nft_table_block_ct_expectation_obj_spec_identifier nftHL_Chain
syn match nft_table_block_ct_expectation_obj_spec_identifier "\v[A-Za-z][A-Za-z0-9_\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_table_block_ct_expectation_obj_id_ct_expectation_block,
\    nft_UnexpectedEOS,
\    nft_common_block_keyword_error
" **************** END table_block ct expectation <obj_id> **************************************

hi link   nft_table_block_ct_keyword_expectation nftHL_Substatement
syn match nft_table_block_ct_keyword_expectation '\vexpectation\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_table_block_ct_expectation_obj_spec_identifier,
\    nft_UnexpectedEOS,
\    nft_common_block_keyword_error
" **************** END table_block ct expectation *************************************
" **************** END table_block ct expectation **************************************


" **************** BEGIN table_block ct ***************************************
" [ family_spec ] table_id { 'ct'
hi link   nft_table_block_keyword_ct nftHL_Command
syn match nft_table_block_keyword_ct "\vct\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_table_block_ct_keyword_expectation,
\    nft_table_block_ct_keyword_timeout,
\    nft_table_block_ct_keyword_helper,
\    nft_Error
" **************** END table_block ct ***************************************


  for s:this_semantic_file in s:table_block_ct_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded table_block_ct for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define table_block_ct.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_table_block_ct = v:true

