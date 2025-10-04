" File: stmt_ip.vim
" Directory: custom/nftables/
" The actual start of 'stmt' statements for starting 'ip' token/keyword
"
"  The 'ip' keyword is the focus here within this file
"  (and not the 'payload_expr' semantic action that it appears to emulate).
"
" Some overlays for 'ip' keywords as the token opener of statements are:
"
"    - keyword_expr (simplest 'ip')
"    - payload_stmt is a write and has a 'set' keyword
"    - primary_expr (includes payload_expr) is a read-only  ('ip protocol icmp')
"    - primary_stmt_expr is this run-on, add-ons of additional 'expr' for each 'stmt'
"    - concat_stmt_expr is this 'glueless' run-on of 'primary_stmt_expr' together.
"    - payload_stmt_expr is may be surrounded by parenthesis during 'glueless'
"          concat_stmt_expr chaining, e.g., 'ip protocol icmp (icmp type echo-request)'
"
" For expression, see 'ip_expr.vim'
"
"  By staying true to LL(1) (or keyword-centric, we avoid clashes by semantic actions)

let s:stmt_ip_list_filepaths_semantic_early = []
let s:stmt_ip_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_ip')
  call nftables#syntax#log('INFO', 'Skipped stmt_ip (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_ip_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_ip syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
" ************************* BEGIN payload_stmt ***********************
hi link   nft_stmt_ip_payload_stmt_keyword_set nftHL_Write
syn match nft_stmt_ip_payload_stmt_keyword_set '\vset\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt_expr

" ************************* END payload_stmt ***********************

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_2b nftHL_Integer
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_2b '\v((0x[0-9a-fA-F]{1,})|([0-9]{1,1}))' skipwhite contained
\ nextgroup=
\    nft_stmt_ip_payload_stmt_keyword_set,
\    @nft_c_primary_stmt_expr

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_4b nftHL_Integer
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_4b '\v((0x[0-9a-fA-F]{1})|([0-9]{1,2}))' skipwhite contained
\ nextgroup=
\    nft_stmt_ip_payload_stmt_keyword_set,
\    @nft_c_primary_stmt_expr

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_6b nftHL_Integer
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_6b '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,2}))' skipwhite contained
\ nextgroup=
\    nft_stmt_ip_payload_stmt_keyword_set,
\    @nft_c_primary_stmt_expr

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_8b nftHL_Integer
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_8b '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))' skipwhite contained
\ nextgroup=
\    nft_stmt_ip_payload_stmt_keyword_set,
\    @nft_c_primary_stmt_expr

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_16b nftHL_Integer
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_16b '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))' skipwhite contained
\ nextgroup=
\    nft_stmt_ip_payload_stmt_keyword_set,
\    @nft_c_primary_stmt_expr


hi link   nft_close_scope_ip_primary_expr_constant_expr_int_hex_32b nftHL_Integer
syn match nft_close_scope_ip_primary_expr_constant_expr_int_hex_32b '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))' skipwhite contained
\ nextgroup=
\    nft_stmt_ip_payload_stmt_keyword_set,
\    @nft_c_primary_stmt_expr


" ************************* BEGIN payload_expr *********************
hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_length nftHL_Keyword
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_length '\vlength' skipwhite contained
\ nextgroup=
\    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_8b,
\    nft_Error

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_value nftHL_Keyword
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_value '\vvalue' skipwhite contained
\ nextgroup=
\    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_16b,
\    nft_Error

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_addr nftHL_Keyword
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_addr '\vaddr' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_constant_expr_int_hex_32b,
\    nft_Error

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_type nftHL_Keyword
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_type '\vtype' skipwhite contained
\ nextgroup=
\    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_8b,
\    nft_Error

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_ptr nftHL_Keyword
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_ptr '\vptr' skipwhite contained
\ nextgroup=
\    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_8b,
\    nft_Error

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_type_keyword_lsrr nftHL_Define
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_type_keyword_lsrr '\vlsrr' skipwhite contained
\ nextgroup=
\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_length,
\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_addr,
\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_type,
\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_ptr,
\    @nft_c_primary_stmt_expr

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_type_keyword_ssrr nftHL_Define
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_type_keyword_ssrr '\vssrr' skipwhite contained
\ nextgroup=
\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_length,
\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_addr,
\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_type,
\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_ptr,
\    @nft_c_primary_stmt_expr

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_type_keyword_ra nftHL_Define
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_type_keyword_ra '\vra' skipwhite contained
\ nextgroup=
\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_length,
\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_value,
\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_type,
\    @nft_c_primary_stmt_expr

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_type_keyword_rr nftHL_Define
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_type_keyword_rr '\vrr' skipwhite contained
\ nextgroup=
\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_length,
\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_addr,
\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_type,
\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_field_keyword_ptr,
\    @nft_c_primary_stmt_expr

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_option nftHL_Action
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_option '\voption' skipwhite contained
\ nextgroup=
\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_type_keyword_lsrr,
\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_type_keyword_ssrr,
\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_type_keyword_ra,
\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_option_type_keyword_rr,
\    nft_chainError

hi link   nft_close_scope_ip_primary_expr_constant_expr_setname nftHL_Element
syn match nft_close_scope_ip_primary_expr_constant_expr_setname '\v\@[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_close_scope_ip_primary_expr_constant_expr_ip nftHL_Integer
syn match nft_close_scope_ip_primary_expr_constant_expr_ip '\v[0-9]{1,3}(\.([0-9]{1,3})){3}' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_hdrlength nftHL_Action
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_hdrlength '\vhdrlength' skipwhite contained
\ nextgroup=
\    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_4b

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_checksum nftHL_Action
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_checksum '\vchecksum' skipwhite contained
\ nextgroup=
\    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_16b

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_frag_off nftHL_Action
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_frag_off '\vfrag\-off' skipwhite contained
\ nextgroup=
\    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_16b

" 'ip protocol' begin
hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_datatype_ip_protocol nftHL_Define
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_datatype_ip_protocol '\v((udplite|icmpv6|comp|dccp|icmp|sctp|esp|tcp|udp|ah)|(0x[0-9a-zA-F]{1,2})|([0-9]{1,3}))' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr,
"\    nft_chain_stmt_separator,
"\    nft_Error

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_protocol nftHL_Action
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_protocol '\vprotocol\ze[ \t]{1,5}' keepend skipwhite contained
\ nextgroup=
\    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_datatype_ip_protocol,
\    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_8b,
\    nft_Error
" 'ip protocol' end

" 'ip version' end
hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_version nftHL_Action
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_version '\vversion' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_constant_expr_int_hex_8b,
\    nft_Error

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_length nftHL_Action
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_length '\vlength' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_map_expr_keyword_map,
\    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_16b,
\    nft_Error

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_daddr nftHL_Action
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_daddr '\vdaddr' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_constant_expr_setname,
\    nft_close_scope_ip_primary_expr_constant_expr_ip,
\    nft_chainError

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_saddr nftHL_Action
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_saddr '\vsaddr' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_constant_expr_setname,
\    nft_close_scope_ip_primary_expr_constant_expr_ip,
\    nft_chainError

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_dscp nftHL_Action
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_dscp '\vdscp' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_constant_expr_setname,
\    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_6b,
\    nft_chainError

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_ecn nftHL_Action
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_ecn '\vecn' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_constant_expr_setname,
\    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_2b,
\    nft_chainError

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_ttl nftHL_Action
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_ttl '\vttl' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_constant_expr_setname,
\    nft_close_scope_ip_primary_expr_constant_expr_int_hex_8b,
\    nft_chainError

hi link   nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_id nftHL_Action
syn match nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_id '\vid' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_constant_expr_setname,
\    nft_close_scope_ip_primary_expr_constant_expr_int_hex_16b,
\    nft_chainError
" ************************* END payload_expr ***********************

" ************************* Keyword 'ip' ***************************
" this is not an expression but THE opening statement 'ip' keyword
"
" No expression allowed here
""
" WRONG to use: rule → stmt_list → stmt → stmt_expr → multiton_stmt_expr → primary_stmt_expr → keyword_expr -> 'ip'
"     multiton_stmt_expr is for range/prefix only

" TODO, rename this multion_stmt_expr to:
"   stmt->payload_stmt->payload_expr->ip_hdr_expr->'ip' (only if using 'set')
"   stmt->match_stmt->relational_expr->expr->concat_expr->basic_expr->primary_expr->payload_expr->ip_hdr_expr
"   stmt->match_stmt->relational_expr->expr->concat_expr->basic_expr->primary_expr->payload_expr->ip_hdr_expr
"   (14 others)->stmt_expr->symbol_stmt_expr->keyword_expr->'ip'; typically with modifier keyword ('set', 'to', 'devices')
"   primary_stmt_expr->payload_expr->ip_hdr_expr->'ip' (used in sub-stmt, not applicable in this 'stmt' context here)
""
"   payload_expr->ip_hdr_expr->'ip'
"   family_spec->family_spec_explicit->'ip'  (not applicable in this 'stmt' context here)
"
" Most simplistic LL(1) semantic action is 'keyword_expr' (one keyword: 'ip'),
" not used because out-of-scope (not at 'stmt' context) and only used as an
" expression after its initial statement.
"
" Next most simplistic semantic is 'concat_stmt_expr': 'ip protocol icmp', the 'ip' part.
"
"hi link   nft_keyword_expr_keyword_ip  nftHL_Command
"syn match nft_keyword_expr_keyword_ip  '\vip\ze[ \t]' skipwhite contained
"\ nextgroup=
"\    nft_ip_hdr_expr_ip_hdr_field_keyword_hdrversion,
"\    nft_ip_hdr_expr_ip_hdr_field_keyword_hdrlength,
"\    nft_ip_hdr_expr_ip_hdr_field_keyword_checksum,
"\    nft_ip_hdr_expr_ip_hdr_field_keyword_frag_off,
"\    nft_ip_hdr_expr_ip_hdr_field_keyword_protocol,
"\    nft_ip_hdr_expr_ip_hdr_field_keyword_length,
"\    nft_ip_hdr_expr_keyword_option,
"\    nft_ip_hdr_expr_ip_hdr_field_keyword_daddr,
"\    nft_ip_hdr_expr_ip_hdr_field_keyword_saddr,
"\    nft_ip_hdr_expr_ip_hdr_field_keyword_dscp,
"\    nft_ip_hdr_expr_ip_hdr_field_keyword_ecn,
"\    nft_ip_hdr_expr_ip_hdr_field_keyword_ttl,
"\    nft_ip_hdr_expr_ip_hdr_field_keyword_id,
"\    nft_Error

"\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_hdrlength,
"\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_checksum,
"\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_frag_off,
"\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_protocol,
"\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_version,
"\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_length,
"\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_option,
"\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_daddr,
"\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_saddr,
"\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_dscp,
"\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_ecn,
"\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_ttl,
"\    nft_stmt_ip_payload_expr_ip_hdr_expr_ip_hdr_field_keyword_id,
"\    nft_chainError


  for s:this_semantic_file in s:stmt_ip_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_ip for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_ip.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_ip = v:true
