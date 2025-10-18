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

hi link   nft_close_scope_ip_primary_expr_constant_expr_at_setname nftHL_AtSetname
syn match nft_close_scope_ip_primary_expr_constant_expr_at_setname '\v\@[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_2b_ecn nftHL_Integer
syn match  nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_2b_ecn '\v(0x)?[0-3]' skipwhite contained

hi link    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_4b_hdrlength nftHL_Integer
syn match  nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_4b_hdrlength '\v(0x[5-9a-fA-F]|1[0-5]|[5-9])\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_4b_hdrversion nftHL_Integer
syn match  nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_4b_hdrversion '\v(0x[fF]|0x[0-9a-eA-E]|[1][0-5]|[0-9])\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_4b nftHL_Integer
syn match  nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_4b '\v((0x[0-9a-fA-F]{1,1})|([0-9]{1,2}))' skipwhite contained

hi link    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_6b nftHL_Integer
syn match  nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_6b '\v((0x[0-9a-fA-F]{1,1})|([0-9]{1,2}))' skipwhite contained

hi link    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_8b nftHL_Integer
syn match  nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_8b '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))' skipwhite contained

hi link    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_8b_protocol nftHL_Integer
syn match  nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_8b_protocol '\v(0x[fF]{2}|0x[0-9a-eA-E][0-9a-fA-F]|0x[0-9a-fA-F]|25[0-5]|2[0-4][0-9]|[1-9][0-9]|[0-9])\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_8b_ttl nftHL_Integer
syn match  nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_8b_ttl '\v(0x[fF]{2}|0x[0-9a-eA-E][0-9a-fA-F]|0x[0-9a-fA-F]|25[0-5]|2[0-4][0-9]|[1-9][0-9]|[0-9])\ze[ \t\n]' skipwhite contained

hi link    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_13b_frag_off nftHL_Integer
syn match  nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_13b_frag_off '\v(0x1[fF]{3}|0x1[fF][0-9a-eA-E][0-9a-fA-F]|0x1[0-9a-eA-E][0-9a-fA-F]{2}|0x[0-9a-fA-F]{1,3}|819[0-1]|81[0-8][0-9]|80[0-9]{2}|[1-7][0-9]{3}|[1-9][0-9]{0,2}|0)\ze[ \t\n]' skipwhite contained

hi link    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_16b_length nftHL_Integer
syn match  nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_16b_length '\v(0x[fF]{4}|0x[0-9a-eA-E][0-9a-fA-F]{3}|0x[0-9a-fA-F]{3}|0x[0-9a-fA-F]{2}|0x[2-9a-fA-F]|6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|6[0-4][0-9]{3}|[1-5][0-9]{4}|[1-9][0-9]{3}|[1-9][0-9]{2}|[2-9][0-9])' skipwhite contained

hi link    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_16b_checksum nftHL_Integer
syn match  nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_16b_checksum '\v(0x[fF]{4}|0x[0-9a-eA-E][0-9a-fA-F]{3}|0x[0-9a-fA-F]{3}|0x[0-9a-fA-F]{2}|0x[0-9a-fA-F]|6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|6[0-4][0-9]{3}|[1-5][0-9]{4}|[1-9][0-9]{3}|[1-9][0-9]{2}|[1-9][0-9]|[0-9])\ze[ \t\n]' skipwhite contained

hi link    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_16b_id nftHL_Integer
syn match  nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_int_hex_16b_id '\v(0x[fF]{4}|0x[0-9a-eA-E][0-9a-fA-F]{3}|0x[0-9a-fA-F]{3}|0x[0-9a-fA-F]{2}|0x[0-9a-fA-F]|6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|6[0-4][0-9]{3}|[1-5][0-9]{4}|[1-9][0-9]{3}|[1-9][0-9]{2}|[1-9][0-9]|[0-9])\ze[ \t\n]' skipwhite contained

hi link    nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_string_ip_opt_cidr nftHL_Integer
syn match  nft_stmt_ip_payload_expr_ip_hdr_expr_close_scope_ip_primary_expr_constant_expr_string_ip_opt_cidr
\ '\v(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}(\/(3[0-2]|[12]\d|[0-9]))?'
\ skipwhite contained


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
" 'rule'
hi link   nft_stmt_declarative_keyword_ip  nftHL_Statement
syn match nft_stmt_declarative_keyword_ip  '\vip\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_ip_hdr_field_keyword_hdrversion,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_hdrlength,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_checksum,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_frag_off,
\    nft_ip_hdr_expr_keyword_option,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_daddr,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_saddr,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_dscp,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_ecn,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_ttl,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_id,
\    @nft_c_primary_stmt_expr
"\    nft_ip_hdr_expr_ip_hdr_field_keyword_length,
"\    nft_ip_hdr_expr_ip_hdr_field_keyword_protocol,
" no error here, 'ip' can be a standalone statement

hi link   nft_add_rule_imperative_keyword_ip  nftHL_Command
syn match nft_add_rule_imperative_keyword_ip  '\vip\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_ip_hdr_expr_ip_hdr_field_keyword_hdrversion,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_hdrlength,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_checksum,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_frag_off,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_protocol,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_length,
\    nft_ip_hdr_expr_keyword_option,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_daddr,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_saddr,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_dscp,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_ecn,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_ttl,
\    nft_ip_hdr_expr_ip_hdr_field_keyword_id,
\    nft_Error


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
