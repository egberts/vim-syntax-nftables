" File: stmt_ether.vim
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

let s:stmt_ether_list_filepaths_semantic_early = []
let s:stmt_ether_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_ether')
  call nftables#syntax#log('INFO', 'Skipped stmt_ether (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_ether_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_ether syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
" ************************* BEGIN payload_stmt ***********************
hi link   nft_stmt_ether_payload_stmt_keyword_set nftHL_Write
syn match nft_stmt_ether_payload_stmt_keyword_set '\vset\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt_expr

" ************************* END payload_stmt ***********************

" ************************* Keyword 'ether' ***************************
" this is not an expression but THE opening statement 'ether' keyword
"
" No expression allowed here
""
" WRONG to use: rule → stmt_list → stmt → stmt_expr → multiton_stmt_expr → primary_stmt_expr → keyword_expr -> 'ether'
"     multiton_stmt_expr is for range/prefix only

" TODO, rename this multion_stmt_expr to:
"   stmt->payload_stmt->payload_expr->eth_hdr_expr->'ether' (only if using 'set')
"   stmt->match_stmt->relational_expr->expr->concat_expr->basic_expr->primary_expr->payload_expr->eth_hdr_expr
"   stmt->match_stmt->relational_expr->expr->concat_expr->basic_expr->primary_expr->payload_expr->eth_hdr_expr
"   (14 others)->stmt_expr->symbol_stmt_expr->keyword_expr->'ether'; typically with modifier keyword ('set', 'to', 'devices')
"   primary_stmt_expr->payload_expr->eth_hdr_expr->'ether' (used in sub-stmt, not applicable in this 'stmt' context here)
""
"   payload_expr->eth_hdr_expr->'ether'
"   family_spec->family_spec_explicit->'ether'  (not applicable in this 'stmt' context here)
"
" Most simplistic LL(1) semantic action is 'keyword_expr' (one keyword: 'ether'),
" not used because out-of-scope (not at 'stmt' context) and only used as an
" expression after its initial statement.
"
" Next most simplistic semantic is 'concat_stmt_expr': 'ether protocol icmp', the 'ether' part.
"
" 'rule'
hi link   nft_stmt_declarative_keyword_ether  nftHL_Command
syn match nft_stmt_declarative_keyword_ether  '\vether\ze[ \t]' skipwhite contained
\  nextgroup=
\    nft_eth_hdr_expr_eth_hdr_field_keyword_daddr,
\    nft_eth_hdr_expr_eth_hdr_field_keyword_saddr,
\    nft_eth_hdr_expr_eth_hdr_field_keyword_type,
\    nft_UnexpectedNumber,
\    nft_chainError

hi link   nft_add_rule_imperative_keyword_ether  nftHL_Command
syn match nft_add_rule_imperative_keyword_ether  '\vether\ze[ \t]' skipwhite contained
\  nextgroup=
\    nft_eth_hdr_expr_eth_hdr_field_keyword_daddr,
\    nft_eth_hdr_expr_eth_hdr_field_keyword_saddr,
\    nft_eth_hdr_expr_eth_hdr_field_keyword_type,
\    nft_UnexpectedNumber,
\    nft_chainError


  for s:this_semantic_file in s:stmt_ether_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_ether for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_ether.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_ether = v:true
