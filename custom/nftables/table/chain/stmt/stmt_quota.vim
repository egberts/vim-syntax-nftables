" File: stmt_quota.vim
" Directory: custom/nftables/
"
let s:stmt_quota_list_filepaths_semantic_early = []
let s:stmt_quota_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_quota')
  call nftables#syntax#log('INFO', 'Skipped stmt_quota (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_quota_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_quota syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

" *********************  BEGIN 'quota_stmt' **************************
hi link   nft_quota_stmt_keyword_packets nftHL_Keyword
syn match nft_quota_stmt_keyword_packets '\vpackets' skipwhite contained
hi link   nft_quota_stmt_keyword_bytes nftHL_Keyword
syn match nft_quota_stmt_keyword_bytes '\vbytes' skipwhite contained
hi link   nft_quota_stmt_num nftHL_Integer
syn match nft_quota_stmt_num '\v(0[xX][0-9a-fA-F]{1,8})|([0-9]{1,10})' skipwhite contained
\ nextgroup=
\    nft_quota_stmt_keyword_packets,
\    nft_quota_stmt_keyword_bytes

hi link   nft_quota_stmt_quota_mode_keyword_until nftHL_Keyword
syn match nft_quota_stmt_quota_mode_keyword_until '\vuntil' skipwhite contained
\ nextgroup=nft_quota_stmt_num,nft_Error

hi link   nft_quota_stmt_quota_mode_keyword_over nftHL_Keyword
syn match nft_quota_stmt_quota_mode_keyword_over '\vover' skipwhite contained
\ nextgroup=nft_quota_stmt_num,nft_Error

" Match the 'quota' statement
" nft_stmt_objref_stmt_objref_stmt_quota_keyword_quota
hi link   nft_stmt_keyword_quota nftHL_Statement
syn match nft_stmt_keyword_quota '\vquota\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_quota_stmt_quota_mode_keyword_until,
\    nft_stmt_objref_stmt_objref_stmt_quota_keyword_name,
\    nft_quota_stmt_quota_mode_keyword_over,
\    nft_quota_stmt_num,
" *********************  END 'quota_stmt' ****************************
  for s:this_semantic_file in s:stmt_quota_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_quota for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_quota.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_quota = v:true
