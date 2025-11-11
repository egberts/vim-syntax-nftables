" File: stmt_fwd.vim
" Directory: custom/nftables/table/chain/stmt/
"
let s:stmt_fwd_list_filepaths_semantic_early = []
let s:stmt_fwd_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_fwd')
  call nftables#syntax#log('INFO', 'Skipped stmt_fwd (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_fwd_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_fwd syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "



"******************** BEGIN nat_stmt ******************************
hi link   nft_fwd_stmt_keyword_to nftHL_Write
syn match nft_fwd_stmt_keyword_to '\vto' skipwhite contained
\ nextgroup=
\    @nft_c_stmt_expr

hi link   nft_fwd_stmt_nf_key_proto_keyword_ip nftHL_Define
syn match nft_fwd_stmt_nf_key_proto_keyword_ip '\vip' skipwhite contained
\ nextgroup=
\    nft_fwd_stmt_keyword_to

hi link   nft_fwd_stmt_nf_key_proto_keyword_ip6 nftHL_Define
syn match nft_fwd_stmt_nf_key_proto_keyword_ip6 '\vip6' skipwhite contained
\ nextgroup=
\    nft_fwd_stmt_keyword_to

hi link   nft_stmt_fwd_stmt_keyword_fwd nftHL_Statement
syn match nft_stmt_fwd_stmt_keyword_fwd '\vfwd' skipnl skipwhite contained
\ nextgroup=
\    nft_fwd_stmt_nf_key_proto_keyword_ip6,
\    nft_fwd_stmt_nf_key_proto_keyword_ip,
\    nft_fwd_stmt_keyword_to,
\    nft_Error
"******************** END nat_stmt ******************************

  for s:this_semantic_file in s:stmt_fwd_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_fwd for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_fwd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_fwd = v:true
