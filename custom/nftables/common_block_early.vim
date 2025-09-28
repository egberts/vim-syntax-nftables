" File: ~/.vim/custom/nftables/common_block_early.vim

let s:sub_files = []

if exists('b:did_nftables_common_block_early')
  call nftables#syntax#log('INFO', 'Skipped common_block_early.vim (already loaded for buffer: ' . bufname('%') . ')')
  finish
endif

" save the filespec of this script into a stack for logging purpose
echom '<sfile>:p: ' . expand('<sfile>:p')
let s:script_filename = fnamemodify(expand('<sfile>:p'), ':r')
echom 's:script_filename: ' . s:script_filename
call nftables#syntax#push(s:script_filename)

let s:sub_dir = fnamemodify(s:script_filename, ':p:h') . '/sub_dir/'
for sub in s:sub_files
  call nftables#syntax#load(sub)
endfor

call nftables#syntax#debug('Loading common_block_early ...')
call nftables#syntax#log('INFO', 'Loaded common_block_early for buffer: ' . bufname('%'))

call nftables#syntax#define_match('nft_identifier', ['nft_comment'], ['nft_my_keyword', 'oopsie_missing_comma'], '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}', 'Error')

"syntax match mismatch 'oopsie" skipwhite contained

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Common ending
let b:did_nftables_common_block_early = 1

