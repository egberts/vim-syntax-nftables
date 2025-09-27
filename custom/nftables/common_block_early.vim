" ~/.vim/syntax/nftables/common_block_early.vim

let s:sub_files = []

" Store script filename (without extension) in snake_case
let s:script_name = substitute(expand('<sfile>:t:r'), '-', '_', 'g')
let s:script_name_abs = resolve(s:script_name)
" Store parent directory name
let s:script_dir = fnamemodify(expand('<sfile>:p:h'), ':t')
let s:script_dir_abs = resolve(s:script_dir)

"call nftables#syntax#log('OK', 'script_name: ' . string(s:script_name) )
"call nftables#syntax#log('OK', 'script_name_abs: ' . s:script_name_abs )
"call nftables#syntax#log('OK', 'script_dir: ' . s:script_dir )
"call nftables#syntax#log('OK', 'script_dir_abs: ' . s:script_dir_abs )


if exists('b:did_nftables_common_block_early')
  call nftables#syntax#log('INFO', 'Skipped common_block_early.vim (already loaded for buffer: ' . bufname('%') . ')')
  finish
endif

let s:sub_dir = fnamemodify(expand('<sfile>'), ':p:h') " . '/sub_dir/'
for sub in s:sub_files
  call nftables#syntax#load(sub)
endfor

call nftables#syntax#debug('Loading common_block_early.vim ...')
call nftables#syntax#log('INFO', 'Loaded common_block_early.vim for buffer: ' . bufname('%'))

call nftables#syntax#define_match('nft_identifier', ['nft_comment'], ['nft_my_keyword', 'oopsie_missing_comma'], '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}', 'Error')

syntax match mismatch 'oopsie" skipwhite contained

" Common ending
let b:did_nftables_common_block_early = 1
