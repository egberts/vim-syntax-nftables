" File: describe_cmd.vim
" Directory: custom/nftables/
"
let s:describe_cmd_list_filepaths_semantic_early = []
let s:describe_cmd_list_filepaths_semantic_later = []

if exists('b:did_nftables_describe_cmd')
  call nftables#syntax#log('INFO', 'Skipped describe_cmd (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:describe_cmd_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading describe_cmd syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

  " TODO, reverify this primary_expr_payload_expr in 'describe'
hi link   nft_describe_keyword_primary_expr_payload_expr nftHL_Command
syn match nft_describe_keyword_primary_expr_payload_expr '(arp_op|arp hlen|arp htype|ar operation|arp plen|ether_addr|tcp|udp)\ze[ \t]' skipwhite contained

hi link   nft_describe_keyword_primary_expr_meta_expr nftHL_Command
syn match nft_describe_keyword_primary_expr_meta_expr 'iifgroup' skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr 'oifgroup' skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr 'iifkind' skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr 'iifname' skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr 'iiftype' skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr 'oifkind' skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr 'oifname' skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr 'oiftype' skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr 'iif' skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr 'oif' skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr '(ether_type|hour|time|day)\ze[ \t]' skipwhite contained

hi link   nft_base_cmd_keyword_describe nftHL_Command
syn match nft_base_cmd_keyword_describe '\vdescribe\ze[ \t]' oneline skipwhite contained
\ nextgroup=
\    nft_describe_keyword_primary_expr_datatype,
\    nft_describe_keyword_primary_expr_payload_expr,
\    nft_describe_keyword_primary_expr_meta_expr

  for s:this_semantic_file in s:describe_cmd_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded describe_cmd for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define describe_cmd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_describe_cmd = v:true
