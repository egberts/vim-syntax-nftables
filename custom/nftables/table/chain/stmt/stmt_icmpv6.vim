" File: stmt_icmpv6.vim
" Directory: custom/nftables/
" The actual start of 'stmt' statements for starting 'icmpv6' token/keyword
"
"  The 'icmpv6' keyword is the focus here within this file
"  (and not the 'payload_expr' semantic action that it appears to emulate).
"
" Some overlays for 'icmpv6' keywords as the token opener of statements are:
"
"    - keyword_expr (simplest 'icmpv6')
"    - payload_stmt is a write and has a 'set' keyword
"    - primary_expr (includes payload_expr) is a read-only  ('icmpv6 protocol icmpv6')
"    - primary_stmt_expr is this run-on, add-ons of additional 'expr' for each 'stmt'
"    - concat_stmt_expr is this 'glueless' run-on of 'primary_stmt_expr' together.
"    - payload_stmt_expr is may be surrounded by parenthesis during 'glueless'
"          concat_stmt_expr chaining, e.g., 'icmpv6 protocol icmpv6 (icmpv6 type echo-request)'
"
" For expression, see 'icmpv6_expr.vim'
"
"  By staying true to LL(1) (or keyword-centric, we avoid clashes by semantic actions)

let s:stmt_icmpv6_list_filepaths_semantic_early = []
let s:stmt_icmpv6_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_icmpv6')
  call nftables#syntax#log('INFO', 'Skipped stmt_icmpv6 (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_icmpv6_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_icmpv6 syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
" ************************* BEGIN payload_stmt ***********************
hi link   nft_stmt_icmpv6_payload_stmt_keyword_set nftHL_Write
syn match nft_stmt_icmpv6_payload_stmt_keyword_set '\vset\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt_expr

" ************************* END payload_stmt ***********************

hi link   nft_close_scope_icmpv6_primary_expr_constant_expr_at_setname nftHL_AtSetname
syn match nft_close_scope_icmpv6_primary_expr_constant_expr_at_setname '\v\@[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link    nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_2b_ecn nftHL_Integer
syn match  nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_2b_ecn '\v(0x)?[0-3]' skipwhite contained

hi link    nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_4b_hdrlength nftHL_Integer
syn match  nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_4b_hdrlength '\v(0x[5-9a-fA-F]|1[0-5]|[5-9])\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link    nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_4b_hdrversion nftHL_Integer
syn match  nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_4b_hdrversion '\v(0x[fF]|0x[0-9a-eA-E]|[1][0-5]|[0-9])\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link    nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_4b nftHL_Integer
syn match  nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_4b '\v((0x[0-9a-fA-F]{1,1})|([0-9]{1,2}))' skipwhite contained

hi link    nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_6b nftHL_Integer
syn match  nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_6b '\v((0x[0-9a-fA-F]{1,1})|([0-9]{1,2}))' skipwhite contained

hi link    nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_8b nftHL_Integer
syn match  nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_8b '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))' skipwhite contained

hi link    nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_8b_protocol nftHL_Integer
syn match  nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_8b_protocol '\v(0x[fF]{2}|0x[0-9a-eA-E][0-9a-fA-F]|0x[0-9a-fA-F]|25[0-5]|2[0-4][0-9]|[1-9][0-9]|[0-9])\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_primary_stmt_expr

hi link    nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_8b_ttl nftHL_Integer
syn match  nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_8b_ttl '\v(0x[fF]{2}|0x[0-9a-eA-E][0-9a-fA-F]|0x[0-9a-fA-F]|25[0-5]|2[0-4][0-9]|[1-9][0-9]|[0-9])\ze[ \t\n]' skipwhite contained

hi link    nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_13b_frag_off nftHL_Integer
syn match  nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_13b_frag_off '\v(0x1[fF]{3}|0x1[fF][0-9a-eA-E][0-9a-fA-F]|0x1[0-9a-eA-E][0-9a-fA-F]{2}|0x[0-9a-fA-F]{1,3}|819[0-1]|81[0-8][0-9]|80[0-9]{2}|[1-7][0-9]{3}|[1-9][0-9]{0,2}|0)\ze[ \t\n]' skipwhite contained

hi link    nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_16b_length nftHL_Integer
syn match  nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_16b_length '\v(0x[fF]{4}|0x[0-9a-eA-E][0-9a-fA-F]{3}|0x[0-9a-fA-F]{3}|0x[0-9a-fA-F]{2}|0x[2-9a-fA-F]|6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|6[0-4][0-9]{3}|[1-5][0-9]{4}|[1-9][0-9]{3}|[1-9][0-9]{2}|[2-9][0-9])' skipwhite contained

hi link    nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_16b_checksum nftHL_Integer
syn match  nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_16b_checksum '\v(0x[fF]{4}|0x[0-9a-eA-E][0-9a-fA-F]{3}|0x[0-9a-fA-F]{3}|0x[0-9a-fA-F]{2}|0x[0-9a-fA-F]|6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|6[0-4][0-9]{3}|[1-5][0-9]{4}|[1-9][0-9]{3}|[1-9][0-9]{2}|[1-9][0-9]|[0-9])\ze[ \t\n]' skipwhite contained

hi link    nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_16b_id nftHL_Integer
syn match  nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_int_hex_16b_id '\v(0x[fF]{4}|0x[0-9a-eA-E][0-9a-fA-F]{3}|0x[0-9a-fA-F]{3}|0x[0-9a-fA-F]{2}|0x[0-9a-fA-F]|6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|6[0-4][0-9]{3}|[1-5][0-9]{4}|[1-9][0-9]{3}|[1-9][0-9]{2}|[1-9][0-9]|[0-9])\ze[ \t\n]' skipwhite contained

hi link    nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_string_icmpv6_opt_cidr nftHL_Integer
syn match  nft_stmt_icmpv6_payload_expr_icmpv6_hdr_expr_close_scope_icmpv6_primary_expr_constant_expr_string_icmpv6_opt_cidr
\ '\v(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}(\/(3[0-2]|[12]\d|[0-9]))?'
\ skipwhite contained


" ************************* Keyword 'icmpv6' ***************************
" this is not an expression but THE opening statement 'icmpv6' keyword
"
" No expression allowed here
""
" WRONG to use: rule → stmt_list → stmt → stmt_expr → multiton_stmt_expr → primary_stmt_expr → keyword_expr -> 'icmpv6'
"     multiton_stmt_expr is for range/prefix only

" TODO, rename this multion_stmt_expr to:
"   stmt->payload_stmt->payload_expr->icmpv6_hdr_expr->'icmpv6' (only if using 'set')
"   stmt->match_stmt->relational_expr->expr->concat_expr->basic_expr->primary_expr->payload_expr->icmpv6_hdr_expr
"   stmt->match_stmt->relational_expr->expr->concat_expr->basic_expr->primary_expr->payload_expr->icmpv6_hdr_expr
"   (14 others)->stmt_expr->symbol_stmt_expr->keyword_expr->'icmpv6'; typically with modifier keyword ('set', 'to', 'devices')
"   primary_stmt_expr->payload_expr->icmpv6_hdr_expr->'icmpv6' (used in sub-stmt, not applicable in this 'stmt' context here)
""
"   payload_expr->icmpv6_hdr_expr->'icmpv6'
"   family_spec->family_spec_explicit->'icmpv6'  (not applicable in this 'stmt' context here)
" stmt
" └── expr_stmt
"      └── expr
"           └── primary_expr
"                └── payload_expr
"                     └── icmp6_hdr_expr
"
"
" 'icmpv6'
hi link   nft_stmt_declarative_keyword_icmpv6 nftHL_Command
syn match nft_stmt_declarative_keyword_icmpv6 '\vicmpv6\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_parameter_problem,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_max_delay,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_sequence,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_checksum,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_daddr,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_taddr,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_code,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_type,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_mtu,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_id,
\    @nft_c_primary_stmt_expr
" no error here, 'icmpv6' can be a standalone statement

hi link   nft_add_rule_imperative_keyword_icmpv6  nftHL_Command
syn match nft_add_rule_imperative_keyword_icmpv6  '\vicmpv6\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_parameter_problem,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_max_delay,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_sequence,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_checksum,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_daddr,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_taddr,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_code,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_type,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_mtu,
\    nft_icmpv6_hdr_expr_icmpv6_hdr_field_keyword_id,
\    @nft_c_primary_stmt_expr


  for s:this_semantic_file in s:stmt_icmpv6_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_icmpv6 for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_icmpv6.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_icmpv6 = v:true
