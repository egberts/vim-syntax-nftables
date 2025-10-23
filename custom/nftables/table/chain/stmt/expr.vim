" File: expr.vim
" Directory: custom/nftables/table/chain/stmt/
"
" set_expr before verdict_map_expr
let s:expr_list_filepaths_semantic_early = [
\    'table/chain/stmt/expr/integer_expr.vim',
\    'table/chain/stmt/expr/boolean_expr.vim',
\    'table/chain/stmt/expr/hash_expr.vim',
\    'table/chain/stmt/expr/eth_hdr_expr.vim',
\    'table/chain/stmt/expr/arp_hdr_expr.vim',
\    'table/chain/stmt/expr/vlan_hdr_expr.vim',
\    'table/chain/stmt/expr/meta_expr.vim',
\    'table/chain/stmt/expr/ip_hdr_expr.vim',
\    'table/chain/stmt/expr/ct_expr.vim',
\    'table/chain/stmt/expr/rt_expr.vim',
\    'table/chain/stmt/expr/icmp_hdr_expr.vim',
\    'table/chain/stmt/expr/icmp6_hdr_expr.vim',
\    'table/chain/stmt/expr/map_expr.vim',
\    'table/chain/stmt/expr/socket_expr.vim',
\    'table/chain/stmt/expr/numgen_expr.vim',
\    'table/chain/stmt/expr/set_expr.vim',
\    'table/chain/stmt/expr/verdict_expr.vim',
\    'table/chain/stmt/expr/verdict_map_expr.vim',
\    'table/chain/stmt/expr/keyword_expr.vim',
\    'table/chain/stmt/expr/payload_raw_expr.vim',
\    'table/chain/stmt/expr/payload_expr.vim',
\    'table/chain/stmt/expr/primary_expr.vim'
\    ]
" 'meta_expr' before 'ip_hdr_expr', so that 'ip length' is done by 'ip_hdr_expr'

let s:expr_list_filepaths_semantic_later = []

if exists('b:did_nftables_expr')
  call nftables#syntax#log('INFO', 'Skipped expr (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:expr_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading expr syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

  for s:this_semantic_file in s:expr_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded expr for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define expr.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_expr = v:true
