" File: stmt_nat.vim
" Directory: custom/nftables/table/chain/stmt/
"
let s:stmt_nat_list_filepaths_semantic_early = []
let s:stmt_nat_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_nat')
  call nftables#syntax#log('INFO', 'Skipped stmt_nat (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_nat_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_nat syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "



"******************** BEGIN nat_stmt ******************************
hi link   nft_stmt_nat_stmt_keyword_to nftHL_Write
syn match nft_stmt_nat_stmt_keyword_to '\vto\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt_expr

hi link   nft_stmt_nat_stmt_nf_key_proto_keyword_ip nftHL_Define
syn match nft_stmt_nat_stmt_nf_key_proto_keyword_ip '\vip' skipwhite contained
\ nextgroup=
\    nft_stmt_nat_stmt_keyword_to
hi link   nft_stmt_nat_stmt_nf_key_proto_keyword_ip6 nftHL_Define
syn match nft_stmt_nat_stmt_nf_key_proto_keyword_ip6 '\vip6' skipwhite contained
\ nextgroup=
\    nft_stmt_nat_stmt_keyword_to
hi link   nft_stmt_nat_stmt_keyword_prefix nftHL_Keyword
syn match nft_stmt_nat_stmt_keyword_prefix '\vprefix' skipwhite contained
hi link   nft_stmt_nat_stmt_keyword_interval nftHL_Keyword
syn match nft_stmt_nat_stmt_keyword_interval '\vinterval' skipwhite contained

hi link   nft_stmt_nat_stmt_nat_stmt_alloc_keyword_dnat nftHL_Statement
syn match nft_stmt_nat_stmt_nat_stmt_alloc_keyword_dnat '\vdnat\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stmt_nat_stmt_keyword_interval,
\    nft_stmt_nat_stmt_keyword_prefix,
\    nft_stmt_nat_stmt_nf_key_proto_keyword_ip6,
\    nft_stmt_nat_stmt_nf_key_proto_keyword_ip,
\    nft_stmt_nat_stmt_keyword_to,
\    nft_Error

hi link   nft_stmt_nat_stmt_nat_stmt_alloc_keyword_snat nftHL_Statement
syn match nft_stmt_nat_stmt_nat_stmt_alloc_keyword_snat '\vsnat\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stmt_nat_stmt_keyword_interval,
\    nft_stmt_nat_stmt_keyword_prefix,
\    nft_stmt_nat_stmt_nf_key_proto_keyword_ip6,
\    nft_stmt_nat_stmt_nf_key_proto_keyword_ip,
\    nft_stmt_nat_stmt_keyword_to,
\    nft_Error
"******************** END nat_stmt ******************************

  for s:this_semantic_file in s:stmt_nat_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_nat for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_nat.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_nat = v:true
